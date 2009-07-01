From: akpm@linux-foundation.org
Subject: + msm_sdccc-convert-printkkern_level-to-pr_level.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:41:49 -0700
Message-ID: <200907012241.n61Mfo40024925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbZGAWnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, drzeus-list@drzeus.cx, pavel@ucw.cz, san@android.com, swetland@google.com


The patch titled
     msm_sdcc.c: convert printk(KERN_<level> to pr_<level>(
has been added to the -mm tree.  Its filename is
     msm_sdccc-convert-printkkern_level-to-pr_level.patch

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
Subject: msm_sdcc.c: convert printk(KERN_<level> to pr_<level>(
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: San Mehat <san@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/msm_sdcc.c |  105 ++++++++++++++--------------------
 1 file changed, 46 insertions(+), 59 deletions(-)

diff -puN drivers/mmc/host/msm_sdcc.c~msm_sdccc-convert-printkkern_level-to-pr_level drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~msm_sdccc-convert-printkkern_level-to-pr_level
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -58,8 +58,6 @@ static unsigned int msmsdcc_sdioirq;
 #define PIO_SPINMAX 30
 #define CMD_SPINMAX 20
 
-
-
 static void
 msmsdcc_start_command(struct msmsdcc_host *host, struct mmc_command *cmd,
 		      u32 c);
@@ -127,7 +125,7 @@ msmsdcc_dma_complete_func(struct msm_dmo
 	BUG_ON(!mrq);
 
 	if (!(result & DMOV_RSLT_VALID)) {
-		printk(KERN_ERR "msmsdcc: Invalid DataMover result\n");
+		pr_err("msmsdcc: Invalid DataMover result\n");
 		goto out;
 	}
 
@@ -136,14 +134,13 @@ msmsdcc_dma_complete_func(struct msm_dmo
 	} else {
 		/* Error or flush  */
 		if (result & DMOV_RSLT_ERROR)
-			printk(KERN_ERR "%s: DMA error (0x%.8x)\n",
+			pr_err("%s: DMA error (0x%.8x)\n",
 			       mmc_hostname(host->mmc), result);
 		if (result & DMOV_RSLT_FLUSH)
-			printk(KERN_ERR "%s: DMA channel flushed (0x%.8x)\n",
+			pr_err("%s: DMA channel flushed (0x%.8x)\n",
 			       mmc_hostname(host->mmc), result);
 		if (err)
-			printk(KERN_ERR
-			       "Flush data: %.8x %.8x %.8x %.8x %.8x %.8x\n",
+			pr_err("Flush data: %.8x %.8x %.8x %.8x %.8x %.8x\n",
 			       err->flush[0], err->flush[1], err->flush[2],
 			       err->flush[3], err->flush[4], err->flush[5]);
 		if (!mrq->data->error)
@@ -248,7 +245,7 @@ static int msmsdcc_config_dma(struct msm
 			host->dma.num_ents, host->dma.dir);
 
 	if (n != host->dma.num_ents) {
-		printk(KERN_ERR "%s: Unable to map in all sg elements\n",
+		pr_err("%s: Unable to map in all sg elements\n",
 		       mmc_hostname(host->mmc));
 		host->dma.sg = NULL;
 		host->dma.num_ents = 0;
@@ -393,24 +390,23 @@ msmsdcc_data_err(struct msmsdcc_host *ho
 		 unsigned int status)
 {
 	if (status & MCI_DATACRCFAIL) {
-		printk(KERN_ERR "%s: Data CRC error\n",
-		       mmc_hostname(host->mmc));
-		printk(KERN_ERR "%s: opcode 0x%.8x\n", __func__,
+		pr_err("%s: Data CRC error\n", mmc_hostname(host->mmc));
+		pr_err("%s: opcode 0x%.8x\n", __func__,
 		       data->mrq->cmd->opcode);
-		printk(KERN_ERR "%s: blksz %d, blocks %d\n", __func__,
+		pr_err("%s: blksz %d, blocks %d\n", __func__,
 		       data->blksz, data->blocks);
 		data->error = -EILSEQ;
 	} else if (status & MCI_DATATIMEOUT) {
-		printk(KERN_ERR "%s: Data timeout\n", mmc_hostname(host->mmc));
+		pr_err("%s: Data timeout\n", mmc_hostname(host->mmc));
 		data->error = -ETIMEDOUT;
 	} else if (status & MCI_RXOVERRUN) {
-		printk(KERN_ERR "%s: RX overrun\n", mmc_hostname(host->mmc));
+		pr_err("%s: RX overrun\n", mmc_hostname(host->mmc));
 		data->error = -EIO;
 	} else if (status & MCI_TXUNDERRUN) {
-		printk(KERN_ERR "%s: TX underrun\n", mmc_hostname(host->mmc));
+		pr_err("%s: TX underrun\n", mmc_hostname(host->mmc));
 		data->error = -EIO;
 	} else {
-		printk(KERN_ERR "%s: Unknown error (0x%.8x)\n",
+		pr_err("%s: Unknown error (0x%.8x)\n",
 		      mmc_hostname(host->mmc), status);
 		data->error = -EIO;
 	}
@@ -566,8 +562,7 @@ static void msmsdcc_do_cmdirq(struct msm
 		cmd->error = -ETIMEDOUT;
 	} else if (status & MCI_CMDCRCFAIL &&
 		   cmd->flags & MMC_RSP_CRC) {
-		printk(KERN_ERR "%s: Command CRC error\n",
-		       mmc_hostname(host->mmc));
+		pr_err("%s: Command CRC error\n", mmc_hostname(host->mmc));
 		cmd->error = -EILSEQ;
 	}
 
@@ -759,8 +754,8 @@ msmsdcc_set_ios(struct mmc_host *mmc, st
 		if (ios->clock != host->clk_rate) {
 			rc = clk_set_rate(host->clk, ios->clock);
 			if (rc < 0)
-				printk(KERN_ERR
-				       "Error setting clock rate (%d)\n", rc);
+				pr_err("%s: Error setting clock rate (%d)\n",
+				       mmc_hostname(host->mmc), rc);
 			else
 				host->clk_rate = ios->clock;
 		}
@@ -848,9 +843,8 @@ msmsdcc_check_status(unsigned long data)
 	status = host->plat->status(mmc_dev(host->mmc));
 	host->eject = !status;
 	if (status ^ host->oldstat) {
-		printk(KERN_INFO
-		       "%s: Slot status change detected (%d -> %d)\n",
-		       mmc_hostname(host->mmc), host->oldstat, status);
+		pr_info("%s: Slot status change detected (%d -> %d)\n",
+			mmc_hostname(host->mmc), host->oldstat, status);
 		if (status)
 			mmc_detect_change(host->mmc, (5 * HZ) / 2);
 		else
@@ -900,13 +894,13 @@ msmsdcc_command_expired(unsigned long _d
 	mrq = host->curr.mrq;
 
 	if (!mrq) {
-		printk(KERN_INFO "%s: Command expiry misfire\n",
-		       mmc_hostname(host->mmc));
+		pr_info("%s: Command expiry misfire\n",
+			mmc_hostname(host->mmc));
 		spin_unlock_irqrestore(&host->lock, flags);
 		return;
 	}
 
-	printk(KERN_ERR "%s: Command timeout (%p %p %p %p)\n",
+	pr_err("%s: Command timeout (%p %p %p %p)\n",
 	       mmc_hostname(host->mmc), mrq, mrq->cmd,
 	       mrq->data, host->dma.sg);
 
@@ -937,7 +931,7 @@ msmsdcc_init_dma(struct msmsdcc_host *ho
 					  &host->dma.nc_busaddr,
 					  GFP_KERNEL);
 	if (host->dma.nc == NULL) {
-		printk(KERN_ERR "Unable to allocate DMA buffer\n");
+		pr_err("Unable to allocate DMA buffer\n");
 		return -ENOMEM;
 	}
 	memset(host->dma.nc, 0x00, sizeof(struct msmsdcc_nc_dmadata));
@@ -980,7 +974,7 @@ msmsdcc_probe(struct platform_device *pd
 
 	/* must have platform data */
 	if (!plat) {
-		printk(KERN_ERR "%s: Platform data not available\n", __func__);
+		pr_err("%s: Platform data not available\n", __func__);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -989,7 +983,7 @@ msmsdcc_probe(struct platform_device *pd
 		return -EINVAL;
 
 	if (pdev->resource == NULL || pdev->num_resources < 2) {
-		printk(KERN_ERR "%s: Invalid resource\n", __func__);
+		pr_err("%s: Invalid resource\n", __func__);
 		return -ENXIO;
 	}
 
@@ -1003,7 +997,7 @@ msmsdcc_probe(struct platform_device *pd
 						   "status_irq");
 
 	if (!cmd_irqres || !pio_irqres || !memres) {
-		printk(KERN_ERR "%s: Invalid resource\n", __func__);
+		pr_err("%s: Invalid resource\n", __func__);
 		return -ENXIO;
 	}
 
@@ -1071,8 +1065,7 @@ msmsdcc_probe(struct platform_device *pd
 
 	ret = clk_set_rate(host->clk, msmsdcc_fmin);
 	if (ret) {
-		printk(KERN_ERR "%s: Clock rate set failed (%d)\n",
-		       __func__, ret);
+		pr_err("%s: Clock rate set failed (%d)\n", __func__, ret);
 		goto clk_disable;
 	}
 
@@ -1125,14 +1118,14 @@ msmsdcc_probe(struct platform_device *pd
 				  DRIVER_NAME " (slot)",
 				  host);
 		if (ret) {
-			printk(KERN_ERR "Unable to get slot IRQ %d (%d)\n",
-			       host->stat_irq, ret);
+			pr_err("%s: Unable to get slot IRQ %d (%d)\n",
+			       mmc_hostname(mmc), host->stat_irq, ret);
 			goto clk_disable;
 		}
 	} else if (plat->register_status_notify) {
 		plat->register_status_notify(msmsdcc_status_notify_cb, host);
 	} else if (!plat->status)
-		printk(KERN_ERR "%s: No card detect facilities available\n",
+		pr_err("%s: No card detect facilities available\n",
 		       mmc_hostname(mmc));
 	else {
 		init_timer(&host->timer);
@@ -1168,34 +1161,28 @@ msmsdcc_probe(struct platform_device *pd
 	mmc_set_drvdata(pdev, mmc);
 	mmc_add_host(mmc);
 
-	printk(KERN_INFO
-	       "%s: Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
-	       mmc_hostname(mmc), (unsigned long long)memres->start,
-	       (unsigned int) cmd_irqres->start,
-	       (unsigned int) host->stat_irq, host->dma.channel);
-	printk(KERN_INFO "%s: 4 bit data mode %s\n", mmc_hostname(mmc),
-	       (mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled"));
-	printk(KERN_INFO "%s: MMC clock %u -> %u Hz, PCLK %u Hz\n",
-	       mmc_hostname(mmc), msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
-	printk(KERN_INFO "%s: Slot eject status = %d\n", mmc_hostname(mmc),
-	       host->eject);
-	printk(KERN_INFO "%s: Power save feature enable = %d\n",
-	       mmc_hostname(mmc), msmsdcc_pwrsave);
+	pr_info("%s: Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
+		mmc_hostname(mmc), (unsigned long long)memres->start,
+		(unsigned int) cmd_irqres->start,
+		(unsigned int) host->stat_irq, host->dma.channel);
+	pr_info("%s: 4 bit data mode %s\n", mmc_hostname(mmc),
+		(mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled"));
+	pr_info("%s: MMC clock %u -> %u Hz, PCLK %u Hz\n",
+		mmc_hostname(mmc), msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
+	pr_info("%s: Slot eject status = %d\n", mmc_hostname(mmc), host->eject);
+	pr_info("%s: Power save feature enable = %d\n",
+		mmc_hostname(mmc), msmsdcc_pwrsave);
 
 	if (host->dma.channel != -1) {
-		printk(KERN_INFO
-		       "%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
-		       mmc_hostname(mmc), host->dma.nc, host->dma.nc_busaddr);
-		printk(KERN_INFO
-		       "%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
-		       mmc_hostname(mmc), host->dma.cmd_busaddr,
-		       host->dma.cmdptr_busaddr);
+		pr_info("%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
+			mmc_hostname(mmc), host->dma.nc, host->dma.nc_busaddr);
+		pr_info("%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
+			mmc_hostname(mmc), host->dma.cmd_busaddr,
+			host->dma.cmdptr_busaddr);
 	} else
-		printk(KERN_INFO
-		       "%s: PIO transfer enabled\n", mmc_hostname(mmc));
+		pr_info("%s: PIO transfer enabled\n", mmc_hostname(mmc));
 	if (host->timer.function)
-		printk(KERN_INFO "%s: Polling status mode enabled\n",
-		       mmc_hostname(mmc));
+		pr_info("%s: Polling status mode enabled\n", mmc_hostname(mmc));
 
 	return 0;
  cmd_irq_free:
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

