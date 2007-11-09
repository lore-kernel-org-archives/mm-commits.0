From: akpm@linux-foundation.org
Subject: + mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:07:33 -0800
Message-ID: <200711092307.lA9N7XXw003816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbXKIXHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:07:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roopesh@cyberspace.org, drzeus-list@drzeus.cx


The patch titled
     MMC/SD: Write operation in invalid states by borken cards.
has been added to the -mm tree.  Its filename is
     mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -332,6 +333,9 @@ static int mmc_blk_issue_rq(struct mmc_q
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
