From: akpm@linux-foundation.org
Subject: [merged] omap_hsmmc-prevent-races-with-irq-handler.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:11 -0700
Message-ID: <200909231955.n8NJtBsD002278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbZIWTzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     omap_hsmmc: prevent races with irq handler
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-prevent-races-with-irq-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: prevent races with irq handler
From: Adrian Hunter <adrian.hunter@nokia.com>

If an unexpected interrupt occurs while preparing the next request, an
oops can occur.

For example, a new request is setting up DMA for data transfer so
host->data is not NULL.  An unexpected transfer complete (TC) interrupt
comes along and the interrupt handler sets host->data to NULL.  Oops!

Prevent that by adding a spinlock.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-prevent-races-with-irq-handler drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-prevent-races-with-irq-handler
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -148,6 +148,8 @@ struct mmc_omap_host {
 	struct	work_struct	mmc_carddetect_work;
 	void	__iomem		*base;
 	resource_size_t		mapbase;
+	spinlock_t		irq_lock; /* Prevent races with irq handler */
+	unsigned long		flags;
 	unsigned int		id;
 	unsigned int		dma_len;
 	unsigned int		dma_sg_idx;
@@ -459,6 +461,14 @@ mmc_omap_start_command(struct mmc_omap_h
 	if (host->use_dma)
 		cmdreg |= DMA_EN;
 
+	/*
+	 * In an interrupt context (i.e. STOP command), the spinlock is unlocked
+	 * by the interrupt handler, otherwise (i.e. for a new request) it is
+	 * unlocked here.
+	 */
+	if (!in_interrupt())
+		spin_unlock_irqrestore(&host->irq_lock, host->flags);
+
 	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
 	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
 }
@@ -621,11 +631,14 @@ static irqreturn_t mmc_omap_irq(int irq,
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
 
+	spin_lock(&host->irq_lock);
+
 	if (host->mrq == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
 			OMAP_HSMMC_READ(host->base, STAT));
 		/* Flush posted write */
 		OMAP_HSMMC_READ(host->base, STAT);
+		spin_unlock(&host->irq_lock);
 		return IRQ_HANDLED;
 	}
 
@@ -690,6 +703,8 @@ static irqreturn_t mmc_omap_irq(int irq,
 	if ((end_trans || (status & TC)) && host->mrq)
 		mmc_omap_xfer_done(host, data);
 
+	spin_unlock(&host->irq_lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -1018,6 +1033,13 @@ static void omap_mmc_request(struct mmc_
 	struct mmc_omap_host *host = mmc_priv(mmc);
 	int err;
 
+	/*
+	 * Prevent races with the interrupt handler because of unexpected
+	 * interrupts, but not if we are already in interrupt context i.e.
+	 * retries.
+	 */
+	if (!in_interrupt())
+		spin_lock_irqsave(&host->irq_lock, host->flags);
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
 	err = mmc_omap_prepare_data(host, req);
@@ -1026,6 +1048,8 @@ static void omap_mmc_request(struct mmc_
 		if (req->data)
 			req->data->error = err;
 		host->mrq = NULL;
+		if (!in_interrupt())
+			spin_unlock_irqrestore(&host->irq_lock, host->flags);
 		mmc_request_done(mmc, req);
 		return;
 	}
@@ -1580,6 +1604,7 @@ static int __init omap_mmc_probe(struct 
 	mmc->f_max	= 52000000;
 
 	sema_init(&host->sem, 1);
+	spin_lock_init(&host->irq_lock);
 
 	host->iclk = clk_get(&pdev->dev, "ick");
 	if (IS_ERR(host->iclk)) {
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch

