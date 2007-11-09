From: akpm@linux-foundation.org
Subject: + bidi-support-sr-sd-remove-dead-code.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:53:11 -0800
Message-ID: <200711092353.lA9NrBas005825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbXKIXxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:53:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com


The patch titled
     bidi support: sr/sd: Remove dead code
has been added to the -mm tree.  Its filename is
     bidi-support-sr-sd-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bidi support: sr/sd: Remove dead code
From: Boaz Harrosh <bharrosh@panasas.com>

if (rq_data_dir() == WRITE) else if() else chain had an extra "else" since the
if() is on a value of 1 bit.

Also with a bidi request, rq_data_dir() == WRITE and blk_bidi_rq() == true.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    5 +----
 drivers/scsi/sr.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/sd.c~bidi-support-sr-sd-remove-dead-code drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~bidi-support-sr-sd-remove-dead-code
+++ a/drivers/scsi/sd.c
@@ -445,12 +445,9 @@ static int sd_prep_fn(struct request_que
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	} else if (rq_data_dir(rq) == READ) {
+	} else {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
-		goto out;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
diff -puN drivers/scsi/sr.c~bidi-support-sr-sd-remove-dead-code drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~bidi-support-sr-sd-remove-dead-code
+++ a/drivers/scsi/sr.c
@@ -368,12 +368,9 @@ static int sr_prep_fn(struct request_que
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
  	 	cd->cdi.media_written = 1;
-	} else if (rq_data_dir(rq) == READ) {
+	} else {
 		SCpnt->cmnd[0] = READ_10;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		blk_dump_rq_flags(rq, "Unknown sr command");
-		goto out;
 	}
 
 	{
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
bidi-support-sr-sd-remove-dead-code.patch
bidi-support-tgt-use-scsi_init_io-instead-of-scsi_alloc_sgtable.patch
bidi-support-scsi_data_buffer.patch
scsi-bidi-support.patch
