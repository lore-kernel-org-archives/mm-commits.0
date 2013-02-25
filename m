From: akpm@linux-foundation.org
Subject: [merged] loopdev-move-common-code-into-loop_figure_size.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:41 -0800
Message-ID: <20130225205641.C118131C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41121 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3BYU4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:43 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so363493qaj.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: loopdev: move common code into loop_figure_size()
has been removed from the -mm tree.  Its filename was
     loopdev-move-common-code-into-loop_figure_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: loopdev: move common code into loop_figure_size()

Update block device size in accord with gendisk size and let userspace
know the change in loop_figure_size(). This is a clean up to remove
common code of loop_figure_size()'s two callers.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff -puN drivers/block/loop.c~loopdev-move-common-code-into-loop_figure_size drivers/block/loop.c
--- a/drivers/block/loop.c~loopdev-move-common-code-into-loop_figure_size
+++ a/drivers/block/loop.c
@@ -190,6 +190,7 @@ figure_loop_size(struct loop_device *lo,
 {
 	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
 	sector_t x = (sector_t)size;
+	struct block_device *bdev = lo->lo_device;
 
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;
@@ -198,6 +199,9 @@ figure_loop_size(struct loop_device *lo,
 	if (lo->lo_sizelimit != sizelimit)
 		lo->lo_sizelimit = sizelimit;
 	set_capacity(lo->lo_disk, x);
+	bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
+	/* let user-space know about the new size */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
@@ -1091,15 +1095,10 @@ loop_set_status(struct loop_device *lo, 
 		return err;
 
 	if (lo->lo_offset != info->lo_offset ||
-	    lo->lo_sizelimit != info->lo_sizelimit) {
-		struct block_device *bdev = lo->lo_device;
-
+	    lo->lo_sizelimit != info->lo_sizelimit)
 		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
 			return -EFBIG;
 
-		bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
-		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	}
 	loop_config_discard(lo);
 
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
@@ -1276,26 +1275,10 @@ loop_get_status64(struct loop_device *lo
 
 static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 {
-	int err;
-	sector_t sec;
-	loff_t sz;
-
-	err = -ENXIO;
 	if (unlikely(lo->lo_state != Lo_bound))
-		goto out;
-	err = figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
-	if (unlikely(err))
-		goto out;
-	sec = get_capacity(lo->lo_disk);
-	/* the width of sector_t may be narrow for bit-shift */
-	sz = sec;
-	sz <<= 9;
-	bd_set_size(bdev, sz);
-	/* let user-space know about the new size */
-	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+		return -ENXIO;
 
- out:
-	return err;
+	return figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 }
 
 static int lo_ioctl(struct block_device *bdev, fmode_t mode,
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

