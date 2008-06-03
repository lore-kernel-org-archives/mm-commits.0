From: akpm@linux-foundation.org
Subject: + ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch added to -mm tree
Date: Tue, 03 Jun 2008 14:55:17 -0700
Message-ID: <200806032155.m53LtMZR021684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbYFCV4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, petkovbb@gmail.com, tsbogend@alpha.franken.de


The patch titled
     ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
has been added to the -mm tree.  Its filename is
     ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch

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
Subject: ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
leads to memory corruption on a non-coherent platform.

With regard to alignment and padding, ide-cd has the the dma safe
check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buffer
check to that check.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/ide/ide-cd.c~ide-avoid-dma-on-the-stack-for-req_type_ata_pc drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~ide-avoid-dma-on-the-stack-for-req_type_ata_pc
+++ a/drivers/ide/ide-cd.c
@@ -1195,6 +1195,7 @@ static ide_startstop_t cdrom_do_block_pc
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
 		unsigned long addr;
+		unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 		if (rq->bio)
 			addr = (unsigned long)bio_data(rq->bio);
@@ -1212,6 +1213,10 @@ static ide_startstop_t cdrom_do_block_pc
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
+
+		if (!((addr & stack_mask) ^
+		      ((unsigned long)current->stack & stack_mask)))
+			info->dma = 0;
 	}
 
 	/* start sending the command to the drive */
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

