From: akpm@linux-foundation.org
Subject: - ide-cd-use-the-new-object_is_in_stack-helper.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:20 -0700
Message-ID: <200807282111.m6SLBKDq027666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762070AbYG1VUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, petkovbb@gmail.com, tsbogend@alpha.franken.de, mm-co


The patch titled
     ide-cd: use the new object_is_in_stack() helper
has been removed from the -mm tree.  Its filename was
     ide-cd-use-the-new-object_is_in_stack-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide-cd: use the new object_is_in_stack() helper
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/ide/ide-cd.c~ide-cd-use-the-new-object_is_in_stack-helper drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~ide-cd-use-the-new-object_is_in_stack-helper
+++ a/drivers/ide/ide-cd.c
@@ -1162,13 +1162,12 @@ static void cdrom_do_block_pc(ide_drive_
 	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
-		unsigned long addr;
-		unsigned long stack_mask = ~(THREAD_SIZE - 1);
+		char *buf;
 
 		if (rq->bio)
-			addr = (unsigned long)bio_data(rq->bio);
+			buf = bio_data(rq->bio);
 		else
-			addr = (unsigned long)rq->data;
+			buf = rq->data;
 
 		info->dma = drive->using_dma;
 
@@ -1179,11 +1178,8 @@ static void cdrom_do_block_pc(ide_drive_
 		 * separate masks.
 		 */
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-		if (addr & alignment || rq->data_len & alignment)
-			info->dma = 0;
