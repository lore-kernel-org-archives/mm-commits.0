From: akpm@linux-foundation.org
Subject: + unregister_chrdev-return-void.patch added to -mm tree
Date: Tue, 03 Jul 2007 12:52:21 -0700
Message-ID: <200707031952.l63JqLQK011945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012AbXGCTw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 15:52:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     unregister_chrdev() return void
has been added to the -mm tree.  Its filename is
     unregister_chrdev-return-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1625,7 +1625,7 @@ extern int alloc_chrdev_region(dev_t *, 
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

git-dvb.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
fault-injection-fix-example-scripts-in-documentation.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
