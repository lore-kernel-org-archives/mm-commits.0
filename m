From: akpm@linux-foundation.org
Subject: + zram-support-req_discard.patch added to -mm tree
Date: Wed, 12 Mar 2014 13:33:27 -0700
Message-ID: <5320c497.csWoCw8Kz3/yp+Y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaCLUd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 16:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, iamjoonsoo.kim@lge.com

Subject: + zram-support-req_discard.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 13:33:27 -0700


The patch titled
     Subject: zram: support REQ_DISCARD
has been added to the -mm tree.  Its filename is
     zram-support-req_discard.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-support-req_discard.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-support-req_discard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   44 ++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-support-req_discard drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-req_discard
+++ a/drivers/block/zram/zram_drv.c
@@ -550,6 +550,33 @@ static int zram_bvec_rw(struct zram *zra
 	return ret;
 }
 
+static void zram_bio_discard(struct zram *zram, u32 index,
+			     int offset, struct bio *bio)
+{
+	size_t n = bio->bi_iter.bi_size;
+
+	/*
+	 * On some arch, logical block (4096) aligned request couldn't be
+	 * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
+	 * Therefore we should handle this misaligned case here.
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
@@ -685,6 +712,12 @@ static void __zram_make_request(struct z
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
 
@@ -854,6 +887,17 @@ static int create_device(struct zram *zr
 					ZRAM_LOGICAL_BLOCK_SIZE);
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
+	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
+	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
+	/*
+	 * We will skip to discard mis-aligned range, so we can't ensure
+	 * whether discarded region is zero or not.
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
kthread-ensure-locality-of-task_struct-allocations.patch
slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
zram-support-req_discard.patch
page-owners-correct-page-order-when-to-free-page.patch

