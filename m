From: akpm@linux-foundation.org
Subject: + loop-cleanup-partitions-when-detaching-loop-device.patch added to -mm tree
Date: Thu, 14 Mar 2013 15:07:32 -0700
Message-ID: <20130314220732.C47A031C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:56094 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 18:07:33 -0400
Received: by mail-yh0-f73.google.com with SMTP id 28so280415yhr.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 15:07:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: psusi@ubuntu.com, axboe@kernel.dk


The patch titled
     Subject: loop: cleanup partitions when detaching loop device
has been added to the -mm tree.  Its filename is
     loop-cleanup-partitions-when-detaching-loop-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Susi <psusi@ubuntu.com>
Subject: loop: cleanup partitions when detaching loop device

Any partitions added by user space to the loop device were being left in
place after detaching the loop device.  This was because the detach path
issued a BLKRRPART to clean up partitions if LO_FLAGS_PARTSCAN was set,
meaning that the partitions were auto scanned on attach.  Replace this
BLKRRPART with code that unconditionally cleans up partitions on detach
instead.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device drivers/block/loop.c
--- a/drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device
+++ a/drivers/block/loop.c
@@ -1044,12 +1044,24 @@ static int loop_clr_fd(struct loop_devic
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
+	if (bdev)
+	{
+		struct disk_part_iter piter;
+		struct hd_struct *part;
+
+		mutex_lock_nested(&bdev->bd_mutex, 1);
+		invalidate_partition(bdev->bd_disk, 0);
+		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter)))
+			delete_partition(bdev->bd_disk, part->partno);
+		disk_part_iter_exit(&piter);
+		mutex_unlock(&bdev->bd_mutex);
+	}
+
 	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.
 	 * Calling fput holding lo_ctl_mutex triggers a circular
_

Patches currently in -mm which might be from psusi@ubuntu.com are

loop-cleanup-partitions-when-detaching-loop-device.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch

