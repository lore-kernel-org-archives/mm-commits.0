From: akpm@linux-foundation.org
Subject: + scsi-sr-avoids-useless-buffer-allocation.patch added to -mm tree
Date: Tue, 03 Jun 2008 14:55:24 -0700
Message-ID: <200806032155.m53LtOPL021687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbYFCV4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de


The patch titled
     scsi: sr avoids useless buffer allocation
has been added to the -mm tree.  Its filename is
     scsi-sr-avoids-useless-buffer-allocation.patch

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
Subject: scsi: sr avoids useless buffer allocation
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

blk_rq_map_kern can handle the stack buffers correctly (avoid DMA
from/to the stack buffers by using the bounce buffer) so we don't need
to complicate the code by allocating just 8 bytes.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/sr.c~scsi-sr-avoids-useless-buffer-allocation drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-sr-avoids-useless-buffer-allocation
+++ a/drivers/scsi/sr.c
@@ -670,24 +670,20 @@ fail:
 static void get_sectorsize(struct scsi_cd *cd)
 {
 	unsigned char cmd[10];
-	unsigned char *buffer;
+	unsigned char buffer[8];
 	int the_result, retries = 3;
 	int sector_size;
 	struct request_queue *queue;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
-	if (!buffer)
-		goto Enomem;
-
 	do {
 		cmd[0] = READ_CAPACITY;
 		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, 8, NULL, SR_TIMEOUT,
-					      MAX_RETRIES);
+					      buffer, sizeof(buffer), NULL,
+					      SR_TIMEOUT, MAX_RETRIES);
 
 		retries--;
 
@@ -742,14 +738,8 @@ static void get_sectorsize(struct scsi_c
 
 	queue = cd->device->request_queue;
 	blk_queue_hardsect_size(queue, sector_size);
-out:
-	kfree(buffer);
-	return;
 
-Enomem:
-	cd->capacity = 0x1fffff;
-	cd->device->sector_size = 2048;	/* A guess, just in case */
-	goto out;
+	return;
 }
 
 static void get_capabilities(struct scsi_cd *cd)
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

