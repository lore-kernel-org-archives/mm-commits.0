From: akpm@linux-foundation.org
Subject: - mmc_block-print-better-data-error-message-after-timeout.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:07:11 -0800
Message-ID: <200812291907.mBTJ7Bkw022142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbYL2THw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-adrian.hunter@nokia.com, mm-commits@vger.kernel.org


The patch titled
     mmc_block: print better data error message after timeout
has been removed from the -mm tree.  Its filename was
     mmc_block-print-better-data-error-message-after-timeout.patch

This patch was dropped because other wtuff was merged, and wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_block: print better data error message after timeout
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

In particular, if the card gets an ECC error it will timeout, in which
case it is much more helpful to see an ECC error rather than a timeout
error.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |   47 +++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc_block-print-better-data-error-message-after-timeout drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-print-better-data-error-message-after-timeout
+++ a/drivers/mmc/card/block.c
@@ -207,6 +207,47 @@ static u32 mmc_sd_num_wr_blocks(struct m
 	return ntohl(blocks);
 }
 
+static void print_data_error(struct mmc_blk_request *brq, struct mmc_card *card,
+			     struct request *req)
+{
+	struct mmc_command cmd;
+	char *emsg;
+	u32 status;
+	int status_err = 0;
+
+	if (brq->data.error != -ETIMEDOUT || mmc_host_is_spi(card->host))
+		goto out_print;
+
+	if (brq->mrq.stop)
+		/* 'Stop' response contains card status */
+		status = brq->mrq.stop->resp[0];
+	else {
+		cmd.opcode = MMC_SEND_STATUS;
+		cmd.arg = card->rca << 16;
+		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+		status_err = mmc_wait_for_cmd(card->host, &cmd, 0);
+		if (status_err)
+			goto out_print;
+		status = cmd.resp[0];
+	}
+
+	emsg = (status & R1_CARD_ECC_FAILED) ? "ECC" : "I/O";
+
+	printk(KERN_ERR "%s: %s error transferring data, sector %u, "
+	       "card status %#x\n", req->rq_disk->disk_name, emsg,
+	       (unsigned)req->sector, status);
+
+	return;
+
+out_print:
+	printk(KERN_ERR "%s: error %d transferring data, sector %u, nr %u\n",
+	       req->rq_disk->disk_name, brq->data.error, (unsigned)req->sector,
+	       (unsigned)req->nr_sectors);
+	if (status_err)
+		printk(KERN_ERR "%s: error %d requesting card status\n",
+		       req->rq_disk->disk_name, status_err);
+}
+
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -278,10 +319,8 @@ static int mmc_blk_issue_rq(struct mmc_q
 			       req->rq_disk->disk_name, brq.cmd.error);
 		}
 
-		if (brq.data.error) {
-			printk(KERN_ERR "%s: error %d transferring data\n",
-			       req->rq_disk->disk_name, brq.data.error);
-		}
+		if (brq.data.error)
+			print_data_error(&brq, card, req);
 
 		if (brq.stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command\n",
_

Patches currently in -mm which might be from ext-adrian.hunter@nokia.com are

origin.patch
linux-next.patch
mmc_block-print-better-data-error-message-after-timeout.patch
mmc_block-ensure-all-sectors-that-do-not-have-errors-are-read.patch

