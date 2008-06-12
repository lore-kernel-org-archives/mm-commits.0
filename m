From: akpm@linux-foundation.org
Subject: + ide-cd-use-the-new-object_is_in_stack-helper.patch added to -mm tree
Date: Thu, 12 Jun 2008 10:41:34 -0700
Message-ID: <200806121741.m5CHfYic030816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbYFLRnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 13:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, petkovbb@gmail.com, tsbogend@alpha.franken.de


The patch titled
     ide-cd: use the new object_is_in_stack() helper
has been added to the -mm tree.  Its filename is
     ide-cd-use-the-new-object_is_in_stack-helper.patch

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
@@ -1194,13 +1194,12 @@ static ide_startstop_t cdrom_do_block_pc
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
 
@@ -1211,11 +1210,8 @@ static ide_startstop_t cdrom_do_block_pc
 		 * separate masks.
 		 */
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-		if (addr & alignment || rq->data_len & alignment)
-			info->dma = 0;
-
-		if (!((addr & stack_mask) ^
-		      ((unsigned long)current->stack & stack_mask)))
+		if ((unsigned long)buf & alignment || rq->data_len & alignment
+		    || object_is_on_stack(buf))
 			info->dma = 0;
 	}
 
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

