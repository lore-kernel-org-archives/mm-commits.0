From: akpm@linux-foundation.org
Subject: + mmc-omap-general-cleanup-for-mmc-multislot-support.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:27 -0700
Message-ID: <200803172227.m2HMRRnW001543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbYCQW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juha.yrjola@solidboot.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: general cleanup for MMC multislot support
has been added to the -mm tree.  Its filename is
     mmc-omap-general-cleanup-for-mmc-multislot-support.patch

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
Subject: mmc: omap: general cleanup for MMC multislot support
From: Juha Yrjola <juha.yrjola@solidboot.com>

General code cleanup, modifications at some dev_* functions and other hacks at
mmc_omap_irq() for MMC multislot support.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   46 +++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-general-cleanup-for-mmc-multislot-support drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-general-cleanup-for-mmc-multislot-support
+++ a/drivers/mmc/host/omap.c
@@ -547,11 +547,12 @@ static irqreturn_t mmc_omap_irq(int irq,
 	u16 status;
 	int end_command;
 	int end_transfer;
-	int transfer_error;
+	int transfer_error, cmd_error;
 
 	if (host->cmd == NULL && host->data == NULL) {
 		status = OMAP_MMC_READ(host, STAT);
-		dev_info(mmc_dev(host->mmc),"spurious irq 0x%04x\n", status);
+		dev_info(mmc_dev(host->slots[0]->mmc),
+			 "Spurious IRQ 0x%04x\n", status);
 		if (status != 0) {
 			OMAP_MMC_WRITE(host, STAT, status);
 			OMAP_MMC_WRITE(host, IE, 0);
@@ -562,12 +563,19 @@ static irqreturn_t mmc_omap_irq(int irq,
 	end_command = 0;
 	end_transfer = 0;
 	transfer_error = 0;
+	cmd_error = 0;
 
 	while ((status = OMAP_MMC_READ(host, STAT)) != 0) {
+		int cmd;
+
 		OMAP_MMC_WRITE(host, STAT, status);
+		if (host->cmd != NULL)
+			cmd = host->cmd->opcode;
+		else
+			cmd = -1;
 #ifdef CONFIG_MMC_DEBUG
 		dev_dbg(mmc_dev(host->mmc), "MMC IRQ %04x (CMD %d): ",
-			status, host->cmd != NULL ? host->cmd->opcode : -1);
+			status, cmd);
 		mmc_omap_report_irq(status);
 		printk("\n");
 #endif
@@ -579,12 +587,12 @@ static irqreturn_t mmc_omap_irq(int irq,
 				mmc_omap_xfer_data(host, 1);
 		}
 
-		if (status & OMAP_MMC_STAT_END_OF_DATA) {
+		if (status & OMAP_MMC_STAT_END_OF_DATA)
 			end_transfer = 1;
-		}
 
 		if (status & OMAP_MMC_STAT_DATA_TOUT) {
-			dev_dbg(mmc_dev(host->mmc), "data timeout\n");
+			dev_dbg(mmc_dev(host->mmc), "data timeout (CMD%d)\n",
+				cmd);
 			if (host->data) {
 				host->data->error = -ETIMEDOUT;
 				transfer_error = 1;
@@ -608,12 +616,14 @@ static irqreturn_t mmc_omap_irq(int irq,
 			if (host->cmd) {
 				struct mmc_omap_slot *slot =
 					host->current_slot;
-				if (!mmc_omap_cover_is_open(slot))
+				if (slot == NULL ||
+				    !mmc_omap_cover_is_open(slot))
 					dev_err(mmc_dev(host->mmc),
-						"command timeout, CMD %d\n",
-						host->cmd->opcode);
+						"command timeout (CMD%d)\n",
+						cmd);
 				host->cmd->error = -ETIMEDOUT;
 				end_command = 1;
+				cmd_error = 1;
 			}
 		}
 
@@ -621,9 +631,10 @@ static irqreturn_t mmc_omap_irq(int irq,
 			if (host->cmd) {
 				dev_err(mmc_dev(host->mmc),
 					"command CRC error (CMD%d, arg 0x%08x)\n",
-					host->cmd->opcode, host->cmd->arg);
+					cmd, host->cmd->arg);
 				host->cmd->error = -EILSEQ;
 				end_command = 1;
+				cmd_error = 1;
 			} else
 				dev_err(mmc_dev(host->mmc),
 					"command CRC error without cmd?\n");
@@ -632,13 +643,13 @@ static irqreturn_t mmc_omap_irq(int irq,
 		if (status & OMAP_MMC_STAT_CARD_ERR) {
 			dev_dbg(mmc_dev(host->mmc),
 				"ignoring card status error (CMD%d)\n",
-				host->cmd->opcode);
+				cmd);
 			end_command = 1;
 		}
 
 		/*
 		 * NOTE: On 1610 the END_OF_CMD may come too early when
-		 * starting a write 
+		 * starting a write
 		 */
 		if ((status & OMAP_MMC_STAT_END_OF_CMD) &&
 		    (!(status & OMAP_MMC_STAT_A_EMPTY))) {
@@ -646,13 +657,14 @@ static irqreturn_t mmc_omap_irq(int irq,
 		}
 	}
 
-	if (end_command) {
+	if (end_command)
 		mmc_omap_cmd_done(host, host->cmd);
+	if (host->data != NULL) {
+		if (transfer_error)
+			mmc_omap_xfer_done(host, host->data);
+		else if (end_transfer)
+			mmc_omap_end_of_data(host, host->data);
 	}
-	if (transfer_error)
-		mmc_omap_xfer_done(host, host->data);
-	else if (end_transfer)
-		mmc_omap_end_of_data(host, host->data);
 
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from juha.yrjola@solidboot.com are

mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch

