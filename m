From: akpm@linux-foundation.org
Subject: - au1xmmc-remove-custom-carddetect-poll-implementation.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:18 -0700
Message-ID: <200807112351.m6BNpIre011031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757676AbYGKXwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mano@roarinelk.homelinux.net, mm-commits@vger.kernel.org


The patch titled
     au1xmmc: remove custom carddetect poll implementation
has been removed from the -mm tree.  Its filename was
     au1xmmc-remove-custom-carddetect-poll-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: au1xmmc: remove custom carddetect poll implementation
From: Manuel Lauss <mano@roarinelk.homelinux.net>

The MMC core provides a carddetect poll feature, time to remove the
driver's own implementation of it.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/au1xmmc.c |   79 +++++++----------------------------
 1 file changed, 18 insertions(+), 61 deletions(-)

diff -puN drivers/mmc/host/au1xmmc.c~au1xmmc-remove-custom-carddetect-poll-implementation drivers/mmc/host/au1xmmc.c
--- a/drivers/mmc/host/au1xmmc.c~au1xmmc-remove-custom-carddetect-poll-implementation
+++ a/drivers/mmc/host/au1xmmc.c
@@ -21,7 +21,7 @@
  * published by the Free Software Foundation.
  */
 
-/* Why is a timer used to detect insert events?
+/* Why don't we use the SD controllers' carddetect feature?
  *
  * From the AU1100 MMC application guide:
  * If the Au1100-based design is intended to support both MultiMediaCards
@@ -30,8 +30,6 @@
  * In doing so, a MMC card never enters SPI-mode communications,
  * but now the SecureDigital card-detect feature of CD/DAT3 is ineffective
  * (the low to high transition will not occur).
- *
- * So we use the timer to check the status manually.
  */
 
 #include <linux/module.h>
@@ -111,7 +109,6 @@ struct au1xmmc_host {
 
 	int irq;
 
-	struct timer_list timer;
 	struct tasklet_struct finish_task;
 	struct tasklet_struct data_task;
 	struct au1xmmc_platform_data *platdata;
@@ -198,29 +195,24 @@ static void au1xmmc_set_power(struct au1
 		host->platdata->set_power(host->mmc, state);
 }
 
-static int au1xmmc_card_inserted(struct au1xmmc_host *host)
+static int au1xmmc_card_inserted(struct mmc_host *mmc)
 {
-	int ret;
+	struct au1xmmc_host *host = mmc_priv(mmc);
 
 	if (host->platdata && host->platdata->card_inserted)
-		ret = host->platdata->card_inserted(host->mmc);
-	else
-		ret = 1;	/* assume there is a card */
+		return !!host->platdata->card_inserted(host->mmc);
 
-	return ret;
+	return -ENOSYS;
 }
 
 static int au1xmmc_card_readonly(struct mmc_host *mmc)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
-	int ret;
 
 	if (host->platdata && host->platdata->card_readonly)
-		ret = host->platdata->card_readonly(mmc);
-	else
-		ret = 0;	/* assume card is read-write */
+		return !!host->platdata->card_readonly(mmc);
 
-	return ret;
+	return -ENOSYS;
 }
 
 static void au1xmmc_finish_request(struct au1xmmc_host *host)
@@ -698,7 +690,7 @@ static void au1xmmc_request(struct mmc_h
 	host->status = HOST_S_CMD;
 
 	/* fail request immediately if no card is present */
-	if (0 == au1xmmc_card_inserted(host)) {
+	if (0 == au1xmmc_card_inserted(mmc)) {
 		mrq->cmd->error = -ENOMEDIUM;
 		au1xmmc_finish_request(host);
 		return;
@@ -935,39 +927,10 @@ static const struct mmc_host_ops au1xmmc
 	.request	= au1xmmc_request,
 	.set_ios	= au1xmmc_set_ios,
 	.get_ro		= au1xmmc_card_readonly,
+	.get_cd		= au1xmmc_card_inserted,
 	.enable_sdio_irq = au1xmmc_enable_sdio_irq,
 };
 
-static void au1xmmc_poll_event(unsigned long arg)
-{
-	struct au1xmmc_host *host = (struct au1xmmc_host *)arg;
-	int card = au1xmmc_card_inserted(host);
-	int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
-
-	if (card != controller) {
-		host->flags &= ~HOST_F_ACTIVE;
-		if (card)
-			host->flags |= HOST_F_ACTIVE;
-		mmc_detect_change(host->mmc, 0);
-	}
-
-#ifdef DEBUG
-	if (host->mrq != NULL) {
-		u32 status = au_readl(HOST_STATUS(host));
-		DBG("PENDING - %8.8x\n", host->pdev->id, status);
-	}
-#endif
-	mod_timer(&host->timer, jiffies + AU1XMMC_DETECT_TIMEOUT);
-}
-
-static void au1xmmc_init_cd_poll_timer(struct au1xmmc_host *host)
-{
-	init_timer(&host->timer);
-	host->timer.function = au1xmmc_poll_event;
-	host->timer.data = (unsigned long)host;
-	host->timer.expires = jiffies + AU1XMMC_DETECT_TIMEOUT;
-}
-
 static int __devinit au1xmmc_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
@@ -1042,13 +1005,11 @@ static int __devinit au1xmmc_probe(struc
 	if (host->platdata && host->platdata->cd_setup) {
 		ret = host->platdata->cd_setup(mmc, 1);
 		if (ret) {
-			dev_err(&pdev->dev, "board CD setup failed\n");
-			goto out4;
+			dev_warn(&pdev->dev, "board CD setup failed\n");
+			mmc->caps |= MMC_CAP_NEEDS_POLL;
 		}
-	} else {
-		/* poll the board-specific is-card-in-socket-? method */
-		au1xmmc_init_cd_poll_timer(host);
-	}
+	} else
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
 	tasklet_init(&host->data_task, au1xmmc_tasklet_data,
 			(unsigned long)host);
@@ -1084,10 +1045,6 @@ static int __devinit au1xmmc_probe(struc
 
 	platform_set_drvdata(pdev, mmc);
 
-	/* start the carddetect poll timer if necessary */
-	if (!(host->platdata && host->platdata->cd_setup))
-		add_timer(&host->timer);
-
 	printk(KERN_INFO DRIVER_NAME ": MMC Controller %d set up at %8.8X"
 		" (mode=%s)\n", pdev->id, host->iobase,
 		host->flags & HOST_F_DMA ? "dma" : "pio");
@@ -1112,9 +1069,10 @@ out5:
 	tasklet_kill(&host->data_task);
 	tasklet_kill(&host->finish_task);
 
-	if (host->platdata && host->platdata->cd_setup)
+	if (host->platdata && host->platdata->cd_setup &&
+	    !(mmc->caps & MMC_CAP_NEEDS_POLL))
 		host->platdata->cd_setup(mmc, 0);
-out4:
+
 	free_irq(host->irq, host);
 out3:
 	iounmap((void *)host->iobase);
@@ -1142,10 +1100,9 @@ static int __devexit au1xmmc_remove(stru
 			led_classdev_unregister(host->platdata->led);
 #endif
 
-		if (host->platdata && host->platdata->cd_setup)
+		if (host->platdata && host->platdata->cd_setup &&
+		    !(mmc->caps & MMC_CAP_NEEDS_POLL))
 			host->platdata->cd_setup(mmc, 0);
-		else
-			del_timer_sync(&host->timer);
 
 		au_writel(0, HOST_ENABLE(host));
 		au_writel(0, HOST_CONFIG(host));
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

linux-next.patch
spi-au1550_spi-proper-platform-device.patch
video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver.patch

