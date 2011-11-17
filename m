From: akpm@linux-foundation.org
Subject: [merged] loop-cleanup-set_status-interface.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:34 -0800
Message-ID: <201111172021.pAHKLYpt023319@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:49509 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab1KQUVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:38 -0500
Received: by faap16 with SMTP id p16so75973faa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: loop: cleanup set_status interface
has been removed from the -mm tree.  Its filename was
     loop-cleanup-set_status-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: loop: cleanup set_status interface

1) Anyone who has read access to loopdev has permission to call set_status
   and may change important parameters such as lo_offset, lo_sizelimit and
   so on, which contradicts to read access pattern and definitely equals
   to write access pattern.
2) Add lo_offset over i_size check to prevent blkdev_size overflow.
   ##Testcase_bagin
   #dd if=/dev/zero of=./file bs=1k count=1
   #losetup /dev/loop0 ./file
   /* userspace_application */
   struct loop_info64 loinf;
   fd = open("/dev/loop0", O_RDONLY);
   ioctl(fd, LOOP_GET_STATUS64, &loinf);
   /* Set offset to any value which is bigger than i_size, and sizelimit
    * to nonzero value*/
   loinf.lo_offset = 4096*1024;
   loinf.lo_sizelimit = 1024;
   ioctl(fd, LOOP_SET_STATUS64, &loinf);
   /* After this loop device will have size similar to 0x7fffffffffxxxx */
   #blockdev --getsz /dev/loop0
   ##OUTPUT: 36028797018955968
   ##Testcase_end

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   44 +++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff -puN drivers/block/loop.c~loop-cleanup-set_status-interface drivers/block/loop.c
--- a/drivers/block/loop.c~loop-cleanup-set_status-interface
+++ a/drivers/block/loop.c
@@ -161,17 +161,19 @@ static struct loop_func_table *xfer_func
 	&xor_funcs
 };
 
-static loff_t get_loop_size(struct loop_device *lo, struct file *file)
+static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
 {
-	loff_t size, offset, loopsize;
+	loff_t size, loopsize;
 
 	/* Compute loopsize in bytes */
 	size = i_size_read(file->f_mapping->host);
-	offset = lo->lo_offset;
 	loopsize = size - offset;
-	if (lo->lo_sizelimit > 0 && lo->lo_sizelimit < loopsize)
-		loopsize = lo->lo_sizelimit;
+	/* offset is beyond i_size, wierd but possible */
+	if (loopsize < 0)
+		return 0;
 
+	if (sizelimit > 0 && sizelimit < loopsize)
+		loopsize = sizelimit;
 	/*
 	 * Unfortunately, if we want to do I/O on the device,
 	 * the number of 512-byte sectors has to fit into a sector_t.
@@ -179,17 +181,25 @@ static loff_t get_loop_size(struct loop_
 	return loopsize >> 9;
 }
 
+static loff_t get_loop_size(struct loop_device *lo, struct file *file)
+{
+	return get_size(lo->lo_offset, lo->lo_sizelimit, file);
+}
+
 static int
-figure_loop_size(struct loop_device *lo)
+figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
-	loff_t size = get_loop_size(lo, lo->lo_backing_file);
+	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
 	sector_t x = (sector_t)size;
 
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;
-
+	if (lo->lo_offset != offset)
+		lo->lo_offset = offset;
+	if (lo->lo_sizelimit != sizelimit)
+		lo->lo_sizelimit = sizelimit;
 	set_capacity(lo->lo_disk, x);
-	return 0;					
+	return 0;
 }
 
 static inline int
@@ -1059,9 +1069,7 @@ loop_set_status(struct loop_device *lo, 
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
-		lo->lo_offset = info->lo_offset;
-		lo->lo_sizelimit = info->lo_sizelimit;
-		if (figure_loop_size(lo))
+		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
 			return -EFBIG;
 	}
 	loop_config_discard(lo);
@@ -1247,7 +1255,7 @@ static int loop_set_capacity(struct loop
 	err = -ENXIO;
 	if (unlikely(lo->lo_state != Lo_bound))
 		goto out;
-	err = figure_loop_size(lo);
+	err = figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 	if (unlikely(err))
 		goto out;
 	sec = get_capacity(lo->lo_disk);
@@ -1285,13 +1293,19 @@ static int lo_ioctl(struct block_device 
 			goto out_unlocked;
 		break;
 	case LOOP_SET_STATUS:
-		err = loop_set_status_old(lo, (struct loop_info __user *) arg);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status_old(lo,
+					(struct loop_info __user *)arg);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_old(lo, (struct loop_info __user *) arg);
 		break;
 	case LOOP_SET_STATUS64:
-		err = loop_set_status64(lo, (struct loop_info64 __user *) arg);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status64(lo,
+					(struct loop_info64 __user *) arg);
 		break;
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

linux-next.patch

