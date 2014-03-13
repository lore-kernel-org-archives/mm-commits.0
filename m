From: akpm@linux-foundation.org
Subject: + zram-support-req_discard-v4.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:40:41 -0700
Message-ID: <532217c9.USelz9LYnadLMV7k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbaCMUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, iamjoonsoo.kim@lge.com

Subject: + zram-support-req_discard-v4.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:40:41 -0700


The patch titled
     Subject: zram-support-req_discard-v4
has been added to the -mm tree.  Its filename is
     zram-support-req_discard-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-support-req_discard-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-support-req_discard-v4.patch

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
Subject: zram-support-req_discard-v4

v4: replenish code comments suggested by Andrew.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-support-req_discard-v4 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-req_discard-v4
+++ a/drivers/block/zram/zram_drv.c
@@ -550,15 +550,25 @@ static int zram_bvec_rw(struct zram *zra
 	return ret;
 }
 
+/*
+ * zram_bio_discard - handler on discard request
+ * @index: physical block index by PAGE_SIZE unit
+ * @offset: offset within physical block
+ */
 static void zram_bio_discard(struct zram *zram, u32 index,
 			     int offset, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
 
 	/*
-	 * On some arch, logical block (4096) aligned request couldn't be
-	 * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
-	 * Therefore we should handle this misaligned case here.
+	 * zram manages data by physical block size unit. Because logical block
+	 * size isn't identical with physical block size on some arch, we
+	 * could get discard request pointing to specific offset within certain
+	 * physical block. Although we can handle this request by reading that
+	 * physiclal block and decompressing and partially zeroing and
+	 * re-compressing and then re-storing it, it isn't reasonable because
+	 * our intention of handling discard request is to save memory.
+	 * So skipping this logical block is approriate here.
 	 */
 	if (offset) {
 		if (n < offset)
@@ -569,6 +579,11 @@ static void zram_bio_discard(struct zram
 	}
 
 	while (n >= PAGE_SIZE) {
+		/*
+		 * discard request can be too large so that the zram can
+		 * be stucked for a long time if we handle the request
+		 * at once. So handle the request by PAGE_SIZE unit at a time.
+		 */
 		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);
 		write_unlock(&zram->meta->tb_lock);
@@ -890,8 +905,11 @@ static int create_device(struct zram *zr
 	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
 	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
 	/*
-	 * We will skip to discard mis-aligned range, so we can't ensure
-	 * whether discarded region is zero or not.
+	 * zram_bio_discard() will clear all logical blocks if logical block
+	 * size is identical with physical block size(PAGE_SIZE). But if it is
+	 * different, we will skip to discard some parts of logical blocks in
+	 * whole request range which isn't aligned to physical block size.
+	 * So we can't ensure that some discarded logical block is zeroed.
 	 */
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		zram->disk->queue->limits.discard_zeroes_data = 1;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
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
zram-support-req_discard-v4.patch
zram-support-req_discard-v4-fix.patch
page-owners-correct-page-order-when-to-free-page.patch

