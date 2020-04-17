From: akpm@linux-foundation.org
Subject: + lib-test_lockupc-make-test_inode-static.patch added to
 -mm tree
Date: Fri, 17 Apr 2020 15:03:25 -0700
Message-ID: <20200417220325.TGLMXKdwx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgDQWD0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 18:03:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: lib/test_lockup.c: make test_inode static
has been added to the -mm tree.  Its filename is
     lib-test_lockupc-make-test_inode-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_lockupc-make-test_inode-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_lockupc-make-test_inode-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userc-make-uidhash_table-static.patch
lib-test_lockupc-make-test_inode-static.patch
