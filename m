From: akpm@linux-foundation.org
Subject: [merged] ubd-stop-defintining-major_nr.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:22 -0700
Message-ID: <200904011839.n31IdMSH008664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761753AbZDAStv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     ubd: stop defintining MAJOR_NR
has been removed from the -mm tree.  Its filename was
     ubd-stop-defintining-major_nr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ubd: stop defintining MAJOR_NR
From: Christoph Hellwig <hch@lst.de>

MAJOR_NR isn't needed anymore since very early 2.5 kernels.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~ubd-stop-defintining-major_nr arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~ubd-stop-defintining-major_nr
+++ a/arch/um/drivers/ubd_kern.c
@@ -17,7 +17,6 @@
  * James McMechan
  */
 
-#define MAJOR_NR UBD_MAJOR
 #define UBD_SHIFT 4
 
 #include "linux/kernel.h"
@@ -115,7 +114,7 @@ static struct block_device_operations ub
 };
 
 /* Protected by ubd_lock */
-static int fake_major = MAJOR_NR;
+static int fake_major = UBD_MAJOR;
 static struct gendisk *ubd_gendisk[MAX_DEV];
 static struct gendisk *fake_gendisk[MAX_DEV];
 
@@ -299,7 +298,7 @@ static int ubd_setup_common(char *str, i
 		}
 
 		mutex_lock(&ubd_lock);
-		if(fake_major != MAJOR_NR){
+		if (fake_major != UBD_MAJOR) {
 			*error_out = "Can't assign a fake major twice";
 			goto out1;
 		}
@@ -818,13 +817,13 @@ static int ubd_disk_register(int major, 
 	disk->first_minor = unit << UBD_SHIFT;
 	disk->fops = &ubd_blops;
 	set_capacity(disk, size / 512);
-	if(major == MAJOR_NR)
+	if (major == UBD_MAJOR)
 		sprintf(disk->disk_name, "ubd%c", 'a' + unit);
 	else
 		sprintf(disk->disk_name, "ubd_fake%d", unit);
 
 	/* sysfs register (not for ide fake devices) */
-	if (major == MAJOR_NR) {
+	if (major == UBD_MAJOR) {
 		ubd_devs[unit].pdev.id   = unit;
 		ubd_devs[unit].pdev.name = DRIVER_NAME;
 		ubd_devs[unit].pdev.dev.release = ubd_device_release;
@@ -871,13 +870,13 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
-	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
+	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
 		goto out_cleanup;
 	}
 
-	if(fake_major != MAJOR_NR)
+	if (fake_major != UBD_MAJOR)
 		ubd_disk_register(fake_major, ubd_dev->size, n,
 				  &fake_gendisk[n]);
 
@@ -1059,10 +1058,10 @@ static int __init ubd_init(void)
 	char *error;
 	int i, err;
 
-	if (register_blkdev(MAJOR_NR, "ubd"))
+	if (register_blkdev(UBD_MAJOR, "ubd"))
 		return -1;
 
-	if (fake_major != MAJOR_NR) {
+	if (fake_major != UBD_MAJOR) {
 		char name[sizeof("ubd_nnn\0")];
 
 		snprintf(name, sizeof(name), "ubd_%d", fake_major);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch

