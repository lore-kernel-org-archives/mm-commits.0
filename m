From: akpm@linux-foundation.org
Subject: - ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:20 -0700
Message-ID: <200807182324.m6INOKL4004188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbYGRX2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, petkovbb@gmail.com, tsbogend@alpha.franken.de, mm-co


The patch titled
     ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
has been removed from the -mm tree.  Its filename was
     ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1157,6 +1157,7 @@ static void cdrom_do_block_pc(ide_drive_
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
 		unsigned long addr;
+		unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 		if (rq->bio)
 			addr = (unsigned long)bio_data(rq->bio);
@@ -1174,6 +1175,10 @@ static void cdrom_do_block_pc(ide_drive_
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
+
+		if (!((addr & stack_mask) ^
+		      ((unsigned long)current->stack & stack_mask)))
+			info->dma = 0;
 	}
 }
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch

