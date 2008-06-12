From: akpm@linux-foundation.org
Subject: + block-blk-mapc-use-the-new-object_is_on_stack-helper.patch added to -mm tree
Date: Thu, 12 Jun 2008 10:44:00 -0700
Message-ID: <200806121744.m5CHi0D7030875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbYFLRpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 13:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de


The patch titled
     block/blk-map.c: use the new object_is_on_stack() helper
has been added to the -mm tree.  Its filename is
     block-blk-mapc-use-the-new-object_is_on_stack-helper.patch

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
Subject: block/blk-map.c: use the new object_is_on_stack() helper
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-map.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN block/blk-map.c~block-blk-mapc-use-the-new-object_is_on_stack-helper block/blk-map.c
--- a/block/blk-map.c~block-blk-mapc-use-the-new-object_is_on_stack-helper
+++ a/block/blk-map.c
@@ -268,7 +268,6 @@ int blk_rq_map_kern(struct request_queue
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
-	unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -277,11 +276,8 @@ int blk_rq_map_kern(struct request_queue
 
 	kaddr = (unsigned long)kbuf;
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	do_copy = ((kaddr & alignment) || (len & alignment));
-
-	if (!((kaddr & stack_mask) ^
-	      ((unsigned long)current->stack & stack_mask)))
-		do_copy = 1;
+	do_copy = ((kaddr & alignment) || (len & alignment) ||
+		   object_is_on_stack(kbuf));
 
 	if (do_copy)
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch

