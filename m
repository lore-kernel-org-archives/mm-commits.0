From: akpm@linux-foundation.org
Subject: [merged] lib-test_lockupc-make-test_inode-static.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:07 -0700
Message-ID: <20200605201907._ClQ2_wdA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFEUTH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: lib/test_lockup.c: make test_inode static
has been removed from the -mm tree.  Its filename was
     lib-test_lockupc-make-test_inode-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: lib/test_lockup.c: make test_inode static

Fix the following sparse warning:

lib/test_lockup.c:145:14: warning: symbol 'test_inode' was not declared.
Should it be static?

Link: http://lkml.kernel.org/r/20200417074021.46411-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_lockup.c~lib-test_lockupc-make-test_inode-static
+++ a/lib/test_lockup.c
@@ -142,7 +142,7 @@ module_param(reallocate_pages, bool, 040
 MODULE_PARM_DESC(reallocate_pages, "free and allocate pages between iterations");
 
 struct file *test_file;
-struct inode *test_inode;
+static struct inode *test_inode;
 static char test_file_path[256];
 module_param_string(file_path, test_file_path, sizeof(test_file_path), 0400);
 MODULE_PARM_DESC(file_path, "file path to test");
_

Patches currently in -mm which might be from yanaijie@huawei.com are
