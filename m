From: akpm@osdl.org
Subject: + 9p-fix-bogus-return-code-checks-during-initialization.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:13:39 -0800
Message-ID: <200701240713.l0O7DdDC011315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965480AbXAXHNl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:13:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ericvh@gmail.com


The patch titled
     9p: fix bogus return code checks during initialization
has been added to the -mm tree.  Its filename is
     9p-fix-bogus-return-code-checks-during-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 9p: fix bogus return code checks during initialization
From: Eric Van Hensbergen <ericvh@gmail.com>

There is a simple logic error in init_v9fs - the return code checks are
reversed.  This patch fixes the return code and adds some messages to prevent
module initialization from failing silently.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/mux.c  |    4 +++-
 fs/9p/v9fs.c |   11 ++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/9p/mux.c~9p-fix-bogus-return-code-checks-during-initialization fs/9p/mux.c
--- a/fs/9p/mux.c~9p-fix-bogus-return-code-checks-during-initialization
+++ a/fs/9p/mux.c
@@ -132,8 +132,10 @@ int v9fs_mux_global_init(void)
 		v9fs_mux_poll_tasks[i].task = NULL;
 
 	v9fs_mux_wq = create_workqueue("v9fs");
-	if (!v9fs_mux_wq)
+	if (!v9fs_mux_wq) {
+		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
 		return -ENOMEM;
+	}
 
 	return 0;
 }
diff -puN fs/9p/v9fs.c~9p-fix-bogus-return-code-checks-during-initialization fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~9p-fix-bogus-return-code-checks-during-initialization
+++ a/fs/9p/v9fs.c
@@ -457,14 +457,19 @@ static int __init init_v9fs(void)
 
 	v9fs_error_init();
 
-	printk(KERN_INFO "Installing v9fs 9P2000 file system support\n");
+	printk(KERN_INFO "Installing v9fs 9p2000 file system support\n");
 
 	ret = v9fs_mux_global_init();
-	if (!ret)
+	if (ret) {
+		printk(KERN_WARNING "v9fs: starting mux failed\n");
 		return ret;
+	}
 	ret = register_filesystem(&v9fs_fs_type);
-	if (!ret)
+	if (ret) {
+		printk(KERN_WARNING "v9fs: registering file system failed\n");
 		v9fs_mux_global_exit();
+	}
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from ericvh@gmail.com are

9p-fix-bogus-return-code-checks-during-initialization.patch
9p-fix-rename-return-code.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
