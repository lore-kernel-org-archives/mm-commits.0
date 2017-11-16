From: akpm@linux-foundation.org
Subject: [merged] zram-set-bdi_cap_stable_writes-once.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:00:04 -0800
Message-ID: <20171116200004.6nlj9I_2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934471AbdKPUAF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, dan.j.williams@intel.com, hch@lst.de, hughd@google.com, idryomov@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sergey.senozhatsky@gmail.com, ying.huang@intel.com


The patch titled
     Subject: zram: set BDI_CAP_STABLE_WRITES once
has been removed from the -mm tree.  Its filename was
     zram-set-bdi_cap_stable_writes-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: set BDI_CAP_STABLE_WRITES once

With fast swap storage, the platform wants to use swap more aggressively
and swap-in is crucial to application latency.

The rw_page() based synchronous devices like zram, pmem and btt are such
fast storage.  When I profile swapin performance with zram lz4 decompress
test, S/W overhead is more than 70%.  Maybe, it would be bigger in nvdimm.

This patchset reduces swap-in latency by skipping swapcache if the swap
device is a synchronous device like a rw_page() based device.

It enhances by 45% my swapin test (5G sequential swapin, no readahead)
from 2.41sec to 1.64sec.


This patch (of 4):

19b7ccf8651d ("block: get rid of blk_integrity_revalidate()") fixed a
weird thing (i.e., reset BDI_CAP_STABLE_WRITES flag unconditionally
whenever revalidat_disk is called) so zram doesn't need to reset the flag
any more when revalidating the bdev.  Instead, set the flag just once when
the zram device is created.

It shouldn't change any behavior.

Link: http://lkml.kernel.org/r/1505886205-9671-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-set-bdi_cap_stable_writes-once drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-set-bdi_cap_stable_writes-once
+++ a/drivers/block/zram/zram_drv.c
@@ -122,14 +122,6 @@ static inline bool is_partial_io(struct
 }
 #endif
 
-static void zram_revalidate_disk(struct zram *zram)
-{
-	revalidate_disk(zram->disk);
-	/* revalidate_disk reset the BDI_CAP_STABLE_WRITES so set again */
-	zram->disk->queue->backing_dev_info->capabilities |=
-		BDI_CAP_STABLE_WRITES;
-}
-
 /*
  * Check if request is within bounds and aligned on zram logical blocks.
  */
@@ -1373,7 +1365,8 @@ static ssize_t disksize_store(struct dev
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	zram_revalidate_disk(zram);
+
+	revalidate_disk(zram->disk);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -1420,7 +1413,7 @@ static ssize_t reset_store(struct device
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	zram_revalidate_disk(zram);
+	revalidate_disk(zram->disk);
 	bdput(bdev);
 
 	mutex_lock(&bdev->bd_mutex);
@@ -1539,6 +1532,7 @@ static int zram_add(void)
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, zram->disk->queue);
+
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
 	 * and n*PAGE_SIZED sized I/O requests.
@@ -1563,6 +1557,8 @@ static int zram_add(void)
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
+	zram->disk->queue->backing_dev_info->capabilities |=
+					BDI_CAP_STABLE_WRITES;
 	add_disk(zram->disk);
 
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
_

Patches currently in -mm which might be from minchan@kernel.org are


