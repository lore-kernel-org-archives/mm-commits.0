From: akpm@linux-foundation.org
Subject: + mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read.patch added to -mm tree
Date: Thu, 30 Oct 2008 13:19:19 -0700
Message-ID: <200810302019.m9UKJJmF021882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283AbYJ3UUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 16:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com


The patch titled
     mmc_block: ensure all sectors that do not have errors are read
has been added to the -mm tree.  Its filename is
     mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/mmc/card/block.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read
+++ a/drivers/mmc/card/block.c
@@ -255,13 +255,14 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
-	int ret = 1;
+	int ret = 1, disable_multi = 0;
 
 	mmc_claim_host(card->host);
 
 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd;
+		int multi, err;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -277,6 +278,9 @@ static int mmc_blk_issue_rq(struct mmc_q
 		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
 		brq.data.blocks = req->nr_sectors;
 
+		if (disable_multi && brq.data.blocks > 1)
+			brq.data.blocks = 1;
+
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
@@ -286,10 +290,12 @@ static int mmc_blk_issue_rq(struct mmc_q
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
@@ -311,6 +317,13 @@ static int mmc_blk_issue_rq(struct mmc_q
 
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
@@ -359,14 +372,21 @@ static int mmc_blk_issue_rq(struct mmc_q
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

linux-next.patch
mmc_block-print-better-data-error-message-after-timeout.patch
mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read.patch

