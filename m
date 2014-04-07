From: akpm@linux-foundation.org
Subject: [folded-merged] zram-support-req_discard-v4-fix.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:15:45 -0700
Message-ID: <53432391.ldxO3pfFcpFZOrY8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org

Subject: [folded-merged] zram-support-req_discard-v4-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,iamjoonsoo.kim@lge.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:15:45 -0700


The patch titled
     Subject: zram-support-req_discard-v4-fix
has been removed from the -mm tree.  Its filename was
     zram-support-req_discard-v4-fix.patch

This patch was dropped because it was folded into zram-support-req_discard.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-support-req_discard-v4-fix

tweak comments

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-support-req_discard-v4-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-req_discard-v4-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -552,8 +552,8 @@ static int zram_bvec_rw(struct zram *zra
 
 /*
  * zram_bio_discard - handler on discard request
- * @index: physical block index by PAGE_SIZE unit
- * @offset: offset within physical block
+ * @index: physical block index in PAGE_SIZE units
+ * @offset: byte offset within physical block
  */
 static void zram_bio_discard(struct zram *zram, u32 index,
 			     int offset, struct bio *bio)
@@ -561,14 +561,14 @@ static void zram_bio_discard(struct zram
 	size_t n = bio->bi_iter.bi_size;
 
 	/*
-	 * zram manages data by physical block size unit. Because logical block
+	 * zram manages data in physical block size units. Because logical block
 	 * size isn't identical with physical block size on some arch, we
-	 * could get discard request pointing to specific offset within certain
-	 * physical block. Although we can handle this request by reading that
-	 * physiclal block and decompressing and partially zeroing and
-	 * re-compressing and then re-storing it, it isn't reasonable because
-	 * our intention of handling discard request is to save memory.
-	 * So skipping this logical block is approriate here.
+	 * could get a discard request pointing to a specific offset within a
+	 * certain physical block.  Although we can handle this request by
+	 * reading that physiclal block and decompressing and partially zeroing
+	 * and re-compressing and then re-storing it, this isn't reasonable
+	 * because our intent with a discard request is to save memory.  So
+	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
 		if (n < offset)
@@ -580,9 +580,8 @@ static void zram_bio_discard(struct zram
 
 	while (n >= PAGE_SIZE) {
 		/*
-		 * discard request can be too large so that the zram can
-		 * be stucked for a long time if we handle the request
-		 * at once. So handle the request by PAGE_SIZE unit at a time.
+		 * Discard request can be large so the lock hold times could be
+		 * lengthy.  So take the lock once per page.
 		 */
 		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);
@@ -907,9 +906,10 @@ static int create_device(struct zram *zr
 	/*
 	 * zram_bio_discard() will clear all logical blocks if logical block
 	 * size is identical with physical block size(PAGE_SIZE). But if it is
-	 * different, we will skip to discard some parts of logical blocks in
-	 * whole request range which isn't aligned to physical block size.
-	 * So we can't ensure that some discarded logical block is zeroed.
+	 * different, we will skip discarding some parts of logical blocks in
+	 * the part of the request range which isn't aligned to physical block
+	 * size.  So we can't ensure that all discarded logical blocks are
+	 * zeroed.
 	 */
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		zram->disk->queue->limits.discard_zeroes_data = 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

