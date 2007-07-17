From: akpm@linux-foundation.org
Subject: - unregister_blkdev-delete-redundant-messages-in-callers.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:09 -0700
Message-ID: <200707172302.l6HN292A011539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936420AbXGQXPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     unregister_blkdev() delete redundant messages in callers
has been removed from the -mm tree.  Its filename was
     unregister_blkdev-delete-redundant-messages-in-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unregister_blkdev() delete redundant messages in callers
From: Akinobu Mita <akinobu.mita@gmail.com>

No need to warn unregister_blkdev() failure by the callers.  (The previous
patch makes unregister_blkdev() print error message in error case)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c         |    3 +--
 drivers/block/z2ram.c        |    4 +---
 drivers/md/dm.c              |    4 +---
 drivers/s390/block/dcssblk.c |    7 +------
 drivers/sbus/char/jsflash.c  |    3 +--
 5 files changed, 5 insertions(+), 16 deletions(-)

diff -puN drivers/block/loop.c~unregister_blkdev-delete-redundant-messages-in-callers drivers/block/loop.c
--- a/drivers/block/loop.c~unregister_blkdev-delete-redundant-messages-in-callers
+++ a/drivers/block/loop.c
@@ -1568,8 +1568,7 @@ static void __exit loop_exit(void)
 		loop_del_one(lo);
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
-	if (unregister_blkdev(LOOP_MAJOR, "loop"))
-		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
+	unregister_blkdev(LOOP_MAJOR, "loop");
 }
 
 module_init(loop_init);
diff -puN drivers/block/z2ram.c~unregister_blkdev-delete-redundant-messages-in-callers drivers/block/z2ram.c
--- a/drivers/block/z2ram.c~unregister_blkdev-delete-redundant-messages-in-callers
+++ a/drivers/block/z2ram.c
@@ -371,9 +371,7 @@ static void __exit z2_exit(void)
 {
     int i, j;
     blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), 256);
-    if ( unregister_blkdev( Z2RAM_MAJOR, DEVICE_NAME ) != 0 )
-	printk( KERN_ERR DEVICE_NAME ": unregister of device failed\n");
-
+    unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
     del_gendisk(z2ram_gendisk);
     put_disk(z2ram_gendisk);
     blk_cleanup_queue(z2_queue);
diff -puN drivers/md/dm.c~unregister_blkdev-delete-redundant-messages-in-callers drivers/md/dm.c
--- a/drivers/md/dm.c~unregister_blkdev-delete-redundant-messages-in-callers
+++ a/drivers/md/dm.c
@@ -161,9 +161,7 @@ static void local_exit(void)
 {
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
-
-	if (unregister_blkdev(_major, _name) < 0)
-		DMERR("unregister_blkdev failed");
+	unregister_blkdev(_major, _name);
 
 	_major = 0;
 
diff -puN drivers/s390/block/dcssblk.c~unregister_blkdev-delete-redundant-messages-in-callers drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~unregister_blkdev-delete-redundant-messages-in-callers
+++ a/drivers/s390/block/dcssblk.c
@@ -747,14 +747,9 @@ dcssblk_check_params(void)
 static void __exit
 dcssblk_exit(void)
 {
-	int rc;
-
 	PRINT_DEBUG("DCSSBLOCK EXIT...\n");
 	s390_root_dev_unregister(dcssblk_root_dev);
-	rc = unregister_blkdev(dcssblk_major, DCSSBLK_NAME);
-	if (rc) {
-		PRINT_ERR("unregister_blkdev() failed!\n");
-	}
+	unregister_blkdev(dcssblk_major, DCSSBLK_NAME);
 	PRINT_DEBUG("...finished!\n");
 }
 
diff -puN drivers/sbus/char/jsflash.c~unregister_blkdev-delete-redundant-messages-in-callers drivers/sbus/char/jsflash.c
--- a/drivers/sbus/char/jsflash.c~unregister_blkdev-delete-redundant-messages-in-callers
+++ a/drivers/sbus/char/jsflash.c
@@ -619,8 +619,7 @@ static void __exit jsflash_cleanup_modul
 	jsf0.busy = 0;
 
 	misc_deregister(&jsf_dev);
-	if (unregister_blkdev(JSFD_MAJOR, "jsfd") != 0)
-		printk("jsfd: cleanup_module failed\n");
+	unregister_blkdev(JSFD_MAJOR, "jsfd");
 	blk_cleanup_queue(jsf_queue);
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
