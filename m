From: akpm@linux-foundation.org
Subject: [patch 025/124] zram: remove waitqueue for IO done
Date: Fri, 24 Feb 2017 14:56:47 -0800
Message-ID: <58b0ba2f.9ZFnXL/t8vh5lIjA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdBXW45 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove waitqueue for IO done

zram_reset_device() waits for ongoing writepage pages to be completed by
zram->refcount logic.  However, it's pointless because before the reset,
we prevent further opening of zram by zram->claim and flush all of pending
IO by fsync_bdev so there should be no pending IO at the
zram_reset_device().

So let's remove that code which is even broken due to the lack of wake_up
elsewhere.

Link: http://lkml.kernel.org/r/1485145031-11661-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   40 ++------------------------------
 drivers/block/zram/zram_drv.h |    3 --
 2 files changed, 3 insertions(+), 40 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-waitqueue-for-io-done drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-waitqueue-for-io-done
+++ a/drivers/block/zram/zram_drv.c
@@ -391,18 +391,6 @@ static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
 static DEVICE_ATTR_RO(debug_stat);
 
-static inline bool zram_meta_get(struct zram *zram)
-{
-	if (atomic_inc_not_zero(&zram->refcount))
-		return true;
-	return false;
-}
-
-static inline void zram_meta_put(struct zram *zram)
-{
-	atomic_dec(&zram->refcount);
-}
-
 static void zram_meta_free(struct zram_meta *meta, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -859,22 +847,17 @@ static blk_qc_t zram_make_request(struct
 {
 	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!zram_meta_get(zram)))
-		goto error;
-
 	blk_queue_split(queue, &bio, queue->bio_split);
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		goto put_zram;
+		goto error;
 	}
 
 	__zram_make_request(zram, bio);
-	zram_meta_put(zram);
 	return BLK_QC_T_NONE;
-put_zram:
-	zram_meta_put(zram);
+
 error:
 	bio_io_error(bio);
 	return BLK_QC_T_NONE;
@@ -904,13 +887,11 @@ static int zram_rw_page(struct block_dev
 	struct bio_vec bv;
 
 	zram = bdev->bd_disk->private_data;
-	if (unlikely(!zram_meta_get(zram)))
-		goto out;
 
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
 		atomic64_inc(&zram->stats.invalid_io);
 		err = -EINVAL;
-		goto put_zram;
+		goto out;
 	}
 
 	index = sector >> SECTORS_PER_PAGE_SHIFT;
@@ -921,8 +902,6 @@ static int zram_rw_page(struct block_dev
 	bv.bv_offset = 0;
 
 	err = zram_bvec_rw(zram, &bv, index, offset, is_write);
-put_zram:
-	zram_meta_put(zram);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
@@ -955,17 +934,6 @@ static void zram_reset_device(struct zra
 	meta = zram->meta;
 	comp = zram->comp;
 	disksize = zram->disksize;
-	/*
-	 * Refcount will go down to 0 eventually and r/w handler
-	 * cannot handle further I/O so it will bail out by
-	 * check zram_meta_get.
-	 */
-	zram_meta_put(zram);
-	/*
-	 * We want to free zram_meta in process context to avoid
-	 * deadlock between reclaim path and any other locks.
-	 */
-	wait_event(zram->io_done, atomic_read(&zram->refcount) == 0);
 
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
@@ -1013,8 +981,6 @@ static ssize_t disksize_store(struct dev
 		goto out_destroy_comp;
 	}
 
-	init_waitqueue_head(&zram->io_done);
-	atomic_set(&zram->refcount, 1);
 	zram->meta = meta;
 	zram->comp = comp;
 	zram->disksize = disksize;
diff -puN drivers/block/zram/zram_drv.h~zram-remove-waitqueue-for-io-done drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-waitqueue-for-io-done
+++ a/drivers/block/zram/zram_drv.h
@@ -106,9 +106,6 @@ struct zram {
 	unsigned long limit_pages;
 
 	struct zram_stats stats;
-	atomic_t refcount; /* refcount for zram_meta */
-	/* wait all IO under all of cpu are done */
-	wait_queue_head_t io_done;
 	/*
 	 * This is the limit on amount of *uncompressed* worth of data
 	 * we can store in a disk.
_
