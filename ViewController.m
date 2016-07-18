//
//  ViewController.m
//  Sqlite3Test
//
//  Created by 周海 on 16/7/18.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
@interface ViewController ()
{
    sqlite3 *db; //声明一个sqlite3数据库
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //打开数据库
    [self openDB];
    //插入数据
//    [self insertDataInTable];
    
    
    [self updateData];
//    [self deleteData];
    
    //用完了一定记得关闭，释放内存
//    sqlite3_close(db);
    
}
#pragma mark - 该方法用于返回数据库在Documents文件夹中的全路径信息
- (NSString *)filePath{
    NSString *str = [[NSBundle mainBundle] pathForResource:@"ZhouhaiDatase" ofType:@"sqlite"];
    return str;
}
#pragma mark - 打开数据库的方法
- (void)openDB{
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"打开数据库失败");
    } else{
        NSLog(@"打开数据库成功");
    }
}

#pragma mark - 插入数据方法
- (void)insertDataInTable{
    //方法一  经典方法
    //创建sql语句
    NSString *sql = [NSString stringWithFormat:@"insert into Person(name,age,address,phoneNum) values ('%@','%d','%@','%@')",@"张三",28,@"北京市海淀区",@"13333333333"];
    //执行sql语句
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error)) {
        NSLog(@"插入数据失败");
    } else{
        NSLog(@"插入数据成功");
    }
    
}

#pragma mark - 查询数据
- (void)selectData{
    NSString *sql = @"SELECT * FROM Person";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
//            int tag = sqlite3_column_int(statement, 0);
            
            //获得姓名
            char *rowData = (char *)sqlite3_column_text(statement, 1);
            NSString *name =  [NSString stringWithUTF8String:rowData];
            //获得年龄
            int  age = sqlite3_column_int(statement, 2);
            //地址
            char *addData = (char *)sqlite3_column_text(statement, 3);
            NSString *address = [NSString stringWithUTF8String:addData];
            //电话号码
            char *phoneNumData = (char *)sqlite3_column_text(statement, 4);
            NSString *phoneNum = [NSString stringWithUTF8String:phoneNumData];
            NSLog(@"%@ %d %@ %@",name,age,address,phoneNum);
            
        }
        sqlite3_finalize(statement);
    } else{
        NSAssert(0, @"查询失败");
    }

}

#pragma mark - 删除数据
- (void)deleteData{
    //删除sql 语句
    NSString *sql = [NSString stringWithFormat:@"delete from Person where name == '%@'",@"周海"];
    char *error;
    //执行sql 语句
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error)) {
        NSLog(@"删除数据失败");
    } else{
        NSLog(@"删除数据成功");
    }
    
    [self selectData];
}

#pragma mark - 修改数据
- (void)updateData{
    NSString *sql = [NSString stringWithFormat:@"update Person set name = '%@' where name = '周海'",@"哈哈哈"];
     char *error;
    //执行sql 语句
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error)) {
        NSLog(@"修改数据失败");
    } else{
        NSLog(@"修改数据成功");
    }
    [self selectData];
}
@end
