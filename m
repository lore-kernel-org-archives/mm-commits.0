From: akpm@linux-foundation.org
Subject: + block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch added to -mm tree
Date: Tue, 03 Jun 2008 14:55:15 -0700
Message-ID: <200806032155.m53LtGxK021677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbYFCV4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de


The patch titled
     block: blk_rq_map_kern uses the bounce buffers for stack buffers
has been added to the -mm tree.  Its filename is
     block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -268,6 +268,7 @@ int blk_rq_map_kern(struct request_queue
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
+	unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -278,6 +279,10 @@ int blk_rq_map_kern(struct request_queue
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
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch

