From: akpm@linux-foundation.org
Subject: [patch 079/102] zram: handle multiple pages attached bio's
 bvec
Date: Wed, 03 May 2017 14:55:38 -0700
Message-ID: <20170503215538.zzcajJCNQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52080 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdECV45 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hare@suse.com, jthumshirn@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

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
 
@@ -840,34 +839,21 @@ static void __zram_make_request(struct z
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
@@ -884,8 +870,6 @@ static blk_qc_t zram_make_request(struct
 {
 	struct zram *zram = queue->queuedata;
 
-	blk_queue_split(queue, &bio, queue->bio_split);
