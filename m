From: akpm@linux-foundation.org
Subject: - block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:46 -0700
Message-ID: <200807112351.m6BNpk1w011073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbYGKXwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     block: blk_rq_map_kern uses the bounce buffers for stack buffers
has been removed from the -mm tree.  Its filename was
     block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: blk_rq_map_kern uses the bounce buffers for stack buffers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

blk_rq_map_kern is used for kernel internal I/Os. Some callers use
this function with stack buffers but DMA to/from the stack buffers
leads to memory corruption on a non-coherent platform.

This patch make blk_rq_map_kern uses the bounce buffers if a caller
passes a stack buffer (on the all platforms for simplicity).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-map.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN block/blk-map.c~block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers block/blk-map.c
--- a/block/blk-map.c~block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers
+++ a/block/blk-map.c
@@ -269,6 +269,7 @@ int blk_rq_map_kern(struct request_queue
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
+	unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -279,6 +280,10 @@ int blk_rq_map_kern(struct request_queue
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 	do_copy = ((kaddr & alignment) || (len & alignment));
 
+	if (!((kaddr & stack_mask) ^
+	      ((unsigned long)current->stack & stack_mask)))
+		do_copy = 1;
+
 	if (do_copy)
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch

