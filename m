From: akpm@linux-foundation.org
Subject: + loopdev-move-common-code-into-loop_figure_size.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:40:20 -0800
Message-ID: <20130129004021.2CC2431C2BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:63974 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3A2AkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:40:22 -0500
Received: by mail-ia0-f201.google.com with SMTP id t4so632655iag.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:40:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: loopdev: move common code into loop_figure_size()
has been added to the -mm tree.  Its filename is
     loopdev-move-common-code-into-loop_figure_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
block-use-i_size_write-in-bd_set_size.patch
block-remove-redundant-check-to-bd_openers.patch
loopdev-fix-a-deadlock.patch
loopdev-update-block-device-size-in-loop_set_status.patch
loopdev-move-common-code-into-loop_figure_size.patch
loopdev-remove-an-user-triggerable-oops.patch
loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch

