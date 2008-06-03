From: akpm@linux-foundation.org
Subject: - ide-use-the-dma-safe-check-for-req_type_ata_pc.patch removed from -mm tree
Date: Tue, 03 Jun 2008 14:51:14 -0700
Message-ID: <200806032151.m53LpEO9021522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbYFCVwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     ide: use the dma safe check for REQ_TYPE_ATA_PC
has been removed from the -mm tree.  Its filename was
     ide-use-the-dma-safe-check-for-req_type_ata_pc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide: use the dma safe check for REQ_TYPE_ATA_PC
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This uses the dma safe check for REQ_TYPE_ATA_PC.  The dma safe check is
used for only sg requests but it should be used for other non fs commands.

This uses blk_queue_update_dma_pad to make the intention clear though ide
don't use the blk APIs so it doesn't change anything.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/ide/ide-cd.c~ide-use-the-dma-safe-check-for-req_type_ata_pc drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~ide-use-the-dma-safe-check-for-req_type_ata_pc
+++ a/drivers/ide/ide-cd.c
@@ -1191,10 +1191,15 @@ static ide_startstop_t cdrom_do_block_pc
 	info->dma = 0;
 
 	/* sg request */
-	if (rq->bio) {
-		int mask = drive->queue->dma_alignment;
-		unsigned long addr =
-			(unsigned long)page_address(bio_page(rq->bio));
+	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
+		struct request_queue *q = drive->queue;
+		unsigned int alignment;
+		unsigned long addr;
+
+		if (rq->bio)
+			addr = (unsigned long)bio_data(rq->bio);
+		else
+			addr = (unsigned long)rq->data;
 
 		info->dma = drive->using_dma;
 
@@ -1204,7 +1209,8 @@ static ide_startstop_t cdrom_do_block_pc
 		 * NOTE! The "len" and "addr" checks should possibly have
 		 * separate masks.
 		 */
-		if ((rq->data_len & 15) || (addr & mask))
+		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
 	}
 
@@ -1872,6 +1878,7 @@ static int ide_cdrom_setup(ide_drive_t *
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
+	blk_queue_update_dma_pad(drive->queue, 15);
 	drive->queue->unplug_delay = (1 * HZ) / 1000;
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch

