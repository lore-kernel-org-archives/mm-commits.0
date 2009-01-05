From: akpm@linux-foundation.org
Subject: - mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:04 -0800
Message-ID: <200901050641.n056f42a005131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbZAEGlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-adrian.hunter@nokia.com, mm-commits@vger.kernel.org


The patch titled
     mmc_block: ensure all sectors that do not have errors are read
has been removed from the -mm tree.  Its filename was
     mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_block: ensure all sectors that do not have errors are read
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

If a card encounters an ECC error while reading a sector it will timeout. 
Instead of reporting the entire I/O request as having an error, redo the
I/O one sector at a time so that all readable sectors are provided to the
upper layers.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read
+++ a/drivers/mmc/card/block.c
@@ -230,12 +230,15 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
 	int ret = 1;
+	int disable_multi = 0;
 
 	mmc_claim_host(card->host);
 
 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd, status = 0;
+		int multi;
+		int err;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -251,6 +254,9 @@ static int mmc_blk_issue_rq(struct mmc_q
 		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
 		brq.data.blocks = req->nr_sectors;
 
+		if (disable_multi && brq.data.blocks > 1)
+			brq.data.blocks = 1;
+
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
@@ -260,10 +266,12 @@ static int mmc_blk_issue_rq(struct mmc_q
 				brq.mrq.stop = &brq.stop;
 			readcmd = MMC_READ_MULTIPLE_BLOCK;
 			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
+			multi = 1;
 		} else {
 			brq.mrq.stop = NULL;
 			readcmd = MMC_READ_SINGLE_BLOCK;
 			writecmd = MMC_WRITE_BLOCK;
+			multi = 0;
 		}
 
 		if (rq_data_dir(req) == READ) {
@@ -285,6 +293,13 @@ static int mmc_blk_issue_rq(struct mmc_q
 
 		mmc_queue_bounce_post(mq);
 
+		if (multi && rq_data_dir(req) == READ &&
+		    brq.data.error == -ETIMEDOUT) {
+			/* Redo read one sector at a time */
+			disable_multi = 1;
+			continue;
+		}
+
 		/*
 		 * Check for errors here, but don't jump to cmd_err
 		 * until later as we need to wait for the card to leave
@@ -348,14 +363,21 @@ static int mmc_blk_issue_rq(struct mmc_q
 #endif
 		}
 
-		if (brq.cmd.error || brq.data.error || brq.stop.error)
+		if (brq.cmd.error || brq.stop.error)
 			goto cmd_err;
 
-		/*
-		 * A block was successfully transferred.
-		 */
+		if (brq.data.error) {
+			if (brq.data.error == -ETIMEDOUT &&
+			    rq_data_dir(req) == READ) {
+				err = -EIO;
+				brq.data.bytes_xfered = brq.data.blksz;
+			} else
+				goto cmd_err;
+		} else
+			err = 0;
+
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, err, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
_

Patches currently in -mm which might be from ext-adrian.hunter@nokia.com are

origin.patch
linux-next.patch

