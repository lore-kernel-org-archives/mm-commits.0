From: akpm@linux-foundation.org
Subject: - mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch removed from -mm tree
Date: Mon, 26 Nov 2007 23:13:04 -0800
Message-ID: <200711270713.lAR7D4Cr032593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbXK0HNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:13:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roopesh@cyberspace.org, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     MMC/SD: Write operation in invalid states by borken cards.
has been removed from the -mm tree.  Its filename was
     mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: MMC/SD: Write operation in invalid states by borken cards.
From: Roopesh <roopesh@cyberspace.org>

If a write operation fails, shouldnt we still check for the card state to
be 'ready to accept next data'?

This question is because I have noticed that some (broken) cards fail the
write command, and the immediately issued subsequent commands also fail
since the card state was never checked before sending these commands. 
(There was a discussion about these cards at the thread: "MMC: CRC Errors
with 2GB cards)

Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc-sd-write-operation-in-invalid-states-by-borken-cards drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-sd-write-operation-in-invalid-states-by-borken-cards
+++ a/drivers/mmc/card/block.c
@@ -208,6 +208,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
 	int ret = 1, sg_pos, data_size;
+	int data_error = 0;
 
 	mmc_claim_host(card->host);
 
@@ -293,19 +294,19 @@ static int mmc_blk_issue_rq(struct mmc_q
 		if (brq.cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write command\n",
 			       req->rq_disk->disk_name, brq.cmd.error);
-			goto cmd_err;
+			data_error = 1;
 		}
 
 		if (brq.data.error) {
 			printk(KERN_ERR "%s: error %d transferring data\n",
 			       req->rq_disk->disk_name, brq.data.error);
-			goto cmd_err;
+			data_error = 1;
 		}
 
 		if (brq.stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command\n",
 			       req->rq_disk->disk_name, brq.stop.error);
-			goto cmd_err;
+			data_error = 1;
 		}
 
 		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
@@ -338,6 +339,9 @@ static int mmc_blk_issue_rq(struct mmc_q
 #endif
 		}
 
+		if (data_error == 1)
+			goto cmd_err;
+
 		/*
 		 * A block was successfully transferred.
 		 */
_

Patches currently in -mm which might be from roopesh@cyberspace.org are

mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch
