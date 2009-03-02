From: akpm@linux-foundation.org
Subject: + ubd-stop-defintining-major_nr.patch added to -mm tree
Date: Mon, 02 Mar 2009 12:45:57 -0800
Message-ID: <200903022045.n22KjvOl020717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbZCBUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 15:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jdike@addtoit.com


The patch titled
     ubd: stop defintining MAJOR_NR
has been added to the -mm tree.  Its filename is
     ubd-stop-defintining-major_nr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ubd: stop defintining MAJOR_NR
From: Christoph Hellwig <hch@lst.de>

MAJOR_NR isn't needed anymore since very early 2.5 kernels.

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
+		if(fake_major != UBD_MAJOR){
 			*error_out = "Can't assign a fake major twice";
 			goto out1;
 		}
@@ -818,13 +817,13 @@ static int ubd_disk_register(int major, 
 	disk->first_minor = unit << UBD_SHIFT;
 	disk->fops = &ubd_blops;
 	set_capacity(disk, size / 512);
-	if(major == MAJOR_NR)
+	if(major == UBD_MAJOR)
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
+	if(fake_major != UBD_MAJOR)
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
vfs-simple_set_mnt-should-return-void.patch
ubd-stop-defintining-major_nr.patch
loop-add-ioctl-to-resize-a-loop-device.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch

