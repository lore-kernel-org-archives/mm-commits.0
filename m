From: akpm@linux-foundation.org
Subject: - unregister_chrdev-return-void.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:49 -0700
Message-ID: <200707192000.l6JK0n4Y019477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760923AbXGSUQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     unregister_chrdev() return void
has been removed from the -mm tree.  Its filename was
     unregister_chrdev-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unregister_chrdev() return void
From: Akinobu Mita <akinobu.mita@gmail.com>

unregister_chrdev() does not return meaningful value.  This patch makes it
return void like most unregister_* functions.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c      |    3 +--
 include/linux/fs.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/char_dev.c~unregister_chrdev-return-void fs/char_dev.c
--- a/fs/char_dev.c~unregister_chrdev-return-void
+++ a/fs/char_dev.c
@@ -321,14 +321,13 @@ void unregister_chrdev_region(dev_t from
 	}
 }
 
-int unregister_chrdev(unsigned int major, const char *name)
+void unregister_chrdev(unsigned int major, const char *name)
 {
 	struct char_device_struct *cd;
 	cd = __unregister_chrdev_region(major, 0, 256);
 	if (cd && cd->cdev)
 		cdev_del(cd->cdev);
 	kfree(cd);
-	return 0;
 }
 
 static DEFINE_SPINLOCK(cdev_lock);
diff -puN include/linux/fs.h~unregister_chrdev-return-void include/linux/fs.h
--- a/include/linux/fs.h~unregister_chrdev-return-void
+++ a/include/linux/fs.h
@@ -1463,7 +1463,7 @@ extern int alloc_chrdev_region(dev_t *, 
 extern int register_chrdev_region(dev_t, unsigned, const char *);
 extern int register_chrdev(unsigned int, const char *,
 			   const struct file_operations *);
-extern int unregister_chrdev(unsigned int, const char *);
+extern void unregister_chrdev(unsigned int, const char *);
 extern void unregister_chrdev_region(dev_t, unsigned);
 extern int chrdev_open(struct inode *, struct file *);
 extern void chrdev_show(struct seq_file *,off_t);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
