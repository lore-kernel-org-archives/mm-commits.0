From: akpm@linux-foundation.org
Subject: [merged] zram-support-req_discard.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:11:57 -0700
Message-ID: <5344661d.kE95TUgA1zXwZz3m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbaDHVL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, iamjoonsoo.kim@lge.com

Subject: [merged] zram-support-req_discard.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:11:57 -0700


The patch titled
     Subject: zram: support REQ_DISCARD
has been removed from the -mm tree.  Its filename was
     zram-support-req_discard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: zram: support REQ_DISCARD

zram is ram based block device and can be used by backend of filesystem. 
When filesystem deletes a file, it normally doesn't do anything on data
block of that file.  It just marks on metadata of that file.  This
behavior has no problem on disk based block device, but has problems on
ram based block device, since we can't free memory used for data block. 
To overcome this disadvantage, there is REQ_DISCARD functionality.  If
block device support REQ_DISCARD and filesystem is mounted with discard
option, filesystem sends REQ_DISCARD to block device whenever some data
blocks are discarded.  All we have to do is to handle this request.

This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
REQ_DISCARD request.  With it, we can free memory used by zram if it isn't
used.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   62 ++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-support-req_discard drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-req_discard
+++ a/drivers/block/zram/zram_drv.c
@@ -551,6 +551,47 @@ static int zram_bvec_rw(struct zram *zra
 	return ret;
 }
 
+/*
+ * zram_bio_discard - handler on discard request
+ * @index: physical block index in PAGE_SIZE units
+ * @offset: byte offset within physical block
+ */
+static void zram_bio_discard(struct zram *zram, u32 index,
+			     int offset, struct bio *bio)
+{
+	size_t n = bio->bi_iter.bi_size;
+
+	/*
+	 * zram manages data in physical block size units. Because logical block
+	 * size isn't identical with physical block size on some arch, we
+	 * could get a discard request pointing to a specific offset within a
+	 * certain physical block.  Although we can handle this request by
+	 * reading that physiclal block and decompressing and partially zeroing
+	 * and re-compressing and then re-storing it, this isn't reasonable
+	 * because our intent with a discard request is to save memory.  So
+	 * skipping this logical block is appropriate here.
+	 */
+	if (offset) {
+		if (n < offset)
+			return;
+
+		n -= offset;
+		index++;
+	}
+
+	while (n >= PAGE_SIZE) {
+		/*
+		 * Discard request can be large so the lock hold times could be
+		 * lengthy.  So take the lock once per page.
+		 */
+		write_lock(&zram->meta->tb_lock);
+		zram_free_page(zram, index);
+		write_unlock(&zram->meta->tb_lock);
+		index++;
+		n -= PAGE_SIZE;
+	}
+}
+
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
@@ -686,6 +727,12 @@ static void __zram_make_request(struct z
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
+	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+		zram_bio_discard(zram, index, offset, bio);
+		bio_endio(bio, 0);
+		return;
+	}
+
 	bio_for_each_segment(bvec, bio, iter) {
 		int max_transfer_size = PAGE_SIZE - offset;
 
@@ -855,6 +902,21 @@ static int create_device(struct zram *zr
 					ZRAM_LOGICAL_BLOCK_SIZE);
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
+	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
+	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
+	/*
+	 * zram_bio_discard() will clear all logical blocks if logical block
+	 * size is identical with physical block size(PAGE_SIZE). But if it is
+	 * different, we will skip discarding some parts of logical blocks in
+	 * the part of the request range which isn't aligned to physical block
+	 * size.  So we can't ensure that all discarded logical blocks are
+	 * zeroed.
+	 */
+	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
+		zram->disk->queue->limits.discard_zeroes_data = 1;
+	else
+		zram->disk->queue->limits.discard_zeroes_data = 0;
+	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
 
 	add_disk(zram->disk);
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

