From: akpm@linux-foundation.org
Subject: [merged] loopdev-update-block-device-size-in-loop_set_status.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:38 -0800
Message-ID: <20130225205638.CA2CE31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64736 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3BYU4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:40 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so347868vea.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: loopdev: update block device size in loop_set_status()
has been removed from the -mm tree.  Its filename was
     loopdev-update-block-device-size-in-loop_set_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: loopdev: update block device size in loop_set_status()

Loop device driver sometimes fails to impose the size limit on the
device. Keep issuing following two commands:

losetup --offset 7517244416 --sizelimit 3224971264 /dev/loop0 backed_file
blockdev --getsize64 /dev/loop0

blockdev reports file size instead of sizelimit several out of 100 times.

The problems are:

	- losetup set up the device in two ioctl:
		  LOOP_SET_FD and LOOP_SET_STATUS64.

	- LOOP_SET_STATUS64 only update size of gendisk.

Block device size will be updated lazily when device comes to use. If udev
rushes in between the two ioctl, it will bring in a block device whose
size is backing file size. If the device is not released after
LOOP_SET_STATUS64 ioctl, blockdev will not see the updated size.

Update block size in LOOP_SET_STATUS64 ioctl.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Reported-by: M. Hindess <hindessm@uk.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/block/loop.c~loopdev-update-block-device-size-in-loop_set_status drivers/block/loop.c
--- a/drivers/block/loop.c~loopdev-update-block-device-size-in-loop_set_status
+++ a/drivers/block/loop.c
@@ -1092,8 +1092,13 @@ loop_set_status(struct loop_device *lo, 
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
+		struct block_device *bdev = lo->lo_device;
+
 		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
 			return -EFBIG;
+
+		bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
+		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}
 	loop_config_discard(lo);
 
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

