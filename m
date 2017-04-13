From: akpm@linux-foundation.org
Subject: + zram-handle-multiple-pages-attached-bios-bvec.patch added to
 -mm tree
Date: Thu, 13 Apr 2017 13:33:41 -0700
Message-ID: <58efe0a5.eLxvMNu6dcSCu+pK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdDMUdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 16:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hare@suse.com, jthumshirn@suse.de, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: handle multiple pages attached bio's bvec
has been added to the -mm tree.  Its filename is
     zram-handle-multiple-pages-attached-bios-bvec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-handle-multiple-pages-attached-bios-bvec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-handle-multiple-pages-attached-bios-bvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: handle multiple pages attached bio's bvec

Patch series "zram clean up", v2.

This patchset aims to clean up zram .

[1] clean up multiple pages's bvec handling.
[2] clean up partial IO handling
[3-6] clean up zram via using accessor and removing pointless structure.

With [2-6] applied, we can get a few hundred bytes as well as huge
readibility enhance.

x86: 708 byte save

    add/remove: 1/1 grow/shrink: 0/11 up/down: 478/-1186 (-708)
    function                                     old     new   delta
    zram_special_page_read                         -     478    +478
    zram_reset_device                            317     314      -3
    mem_used_max_store                           131     128      -3
    compact_store                                 96      93      -3
    mm_stat_show                                 203     197      -6
    zram_add                                     719     712      -7
    zram_slot_free_notify                        229     214     -15
    zram_make_request                            819     803     -16
    zram_meta_free                               128     111     -17
    zram_free_page                               180     151     -29
    disksize_store                               432     361     -71
    zram_decompress_page.isra                    504       -    -504
    zram_bvec_rw                                2592    2080    -512
    Total: Before=25350773, After=25350065, chg -0.00%
    
ppc64: 231 byte save
    
    add/remove: 2/0 grow/shrink: 1/9 up/down: 681/-912 (-231)
    function                                     old     new   delta
    zram_special_page_read                         -     480    +480
    zram_slot_lock                                 -     200    +200
    vermagic                                      39      40      +1
    mm_stat_show                                 256     248      -8
    zram_meta_free                               200     184     -16
    zram_add                                     944     912     -32
    zram_free_page                               348     308     -40
    disksize_store                               572     492     -80
    zram_decompress_page                         664     564    -100
    zram_slot_free_notify                        292     160    -132
    zram_make_request                           1132    1000    -132
    zram_bvec_rw                                2768    2396    -372
    Total: Before=17565825, After=17565594, chg -0.00%


This patch (of 6):

Johannes Thumshirn reported system goes the panic when using NVMe over
Fabrics loopback target with zram.

The reason is zram expects each bvec in bio contains a single page
but nvme can attach a huge bulk of pages attached to the bio's bvec
so that zram's index arithmetic could be wrong so that out-of-bound
access makes system panic.

[1] in mainline solved solved the problem by limiting max_sectors with
SECTORS_PER_PAGE but it makes zram slow because bio should split with
each pages so this patch makes zram aware of multiple pages in a bvec
so it could solve without any regression(ie, bio split).

[1] 0bc315381fe9, zram: set physical queue limits to avoid array out of
    bounds accesses

Link: http://lkml.kernel.org/r/20170413134057.GA27499@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   40 ++++++++------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-handle-multiple-pages-attached-bios-bvec drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-handle-multiple-pages-attached-bios-bvec
+++ a/drivers/block/zram/zram_drv.c
@@ -137,8 +137,7 @@ static inline bool valid_io_request(stru
 
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
 {
-	if (*offset + bvec->bv_len >= PAGE_SIZE)
-		(*index)++;
+	*index  += (*offset + bvec->bv_len) / PAGE_SIZE;
 	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
 }
 
@@ -836,34 +835,21 @@ static void __zram_make_request(struct z
 	}
 
 	bio_for_each_segment(bvec, bio, iter) {
-		int max_transfer_size = PAGE_SIZE - offset;
-
-		if (bvec.bv_len > max_transfer_size) {
-			/*
-			 * zram_bvec_rw() can only make operation on a single
-			 * zram page. Split the bio vector.
-			 */
-			struct bio_vec bv;
-
-			bv.bv_page = bvec.bv_page;
-			bv.bv_len = max_transfer_size;
-			bv.bv_offset = bvec.bv_offset;
+		struct bio_vec bv = bvec;
+		unsigned int unwritten = bvec.bv_len;
 
+		do {
+			bv.bv_len = min_t(unsigned int, PAGE_SIZE - offset,
+							unwritten);
 			if (zram_bvec_rw(zram, &bv, index, offset,
-					 op_is_write(bio_op(bio))) < 0)
+					op_is_write(bio_op(bio))) < 0)
 				goto out;
 
-			bv.bv_len = bvec.bv_len - max_transfer_size;
-			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index + 1, 0,
-					 op_is_write(bio_op(bio))) < 0)
-				goto out;
-		} else
-			if (zram_bvec_rw(zram, &bvec, index, offset,
-					 op_is_write(bio_op(bio))) < 0)
-				goto out;
+			bv.bv_offset += bv.bv_len;
+			unwritten -= bv.bv_len;
 
-		update_position(&index, &offset, &bvec);
+			update_position(&index, &offset, &bv);
+		} while (unwritten);
 	}
 
 	bio_endio(bio);
@@ -880,8 +866,6 @@ static blk_qc_t zram_make_request(struct
 {
 	struct zram *zram = queue->queuedata;
 
-	blk_queue_split(queue, &bio, queue->bio_split);
-
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
 		atomic64_inc(&zram->stats.invalid_io);
@@ -1189,8 +1173,6 @@ static int zram_add(void)
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
 	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
-	zram->disk->queue->limits.max_sectors = SECTORS_PER_PAGE;
-	zram->disk->queue->limits.chunk_sectors = 0;
 	blk_queue_max_discard_sectors(zram->disk->queue, UINT_MAX);
 	/*
 	 * zram_bio_discard() will clear all logical blocks if logical block
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-operator-precedence-to-get-offset.patch
zram-do-not-use-copy_page-with-non-page-alinged-address.patch
zsmalloc-expand-class-bit.patch
mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch
zram-use-zram_free_page-instead-of-open-coded.patch

