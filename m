From: akpm@linux-foundation.org
Subject: - mmc-omap-new-release-dma-and-abort-xfer-functions.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:17:43 -0700
Message-ID: <200803270317.m2R3HhJu015171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901AbYC0DR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juha.yrjola@solidboot.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: new release dma and abort xfer functions
has been removed from the -mm tree.  Its filename was
     mmc-omap-new-release-dma-and-abort-xfer-functions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: new release dma and abort xfer functions
From: Juha Yrjola <juha.yrjola@solidboot.com>

New functions to support MMC multislot: mmc_omap_release_dma() and
mmc_omap_abort_xfer().

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   77 +++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 18 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-new-release-dma-and-abort-xfer-functions drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-new-release-dma-and-abort-xfer-functions
+++ a/drivers/mmc/host/omap.c
@@ -327,26 +327,32 @@ mmc_omap_start_command(struct mmc_omap_h
 }
 
 static void
+mmc_omap_release_dma(struct mmc_omap_host *host, struct mmc_data *data,
+		     int abort)
+{
+	enum dma_data_direction dma_data_dir;
+
+	BUG_ON(host->dma_ch < 0);
+	if (data->error)
+		omap_stop_dma(host->dma_ch);
+	/* Release DMA channel lazily */
+	mod_timer(&host->dma_timer, jiffies + HZ);
+	if (data->flags & MMC_DATA_WRITE)
+		dma_data_dir = DMA_TO_DEVICE;
+	else
+		dma_data_dir = DMA_FROM_DEVICE;
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_len,
+		     dma_data_dir);
+}
+
+static void
 mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	if (host->dma_in_use) {
-		enum dma_data_direction dma_data_dir;
+	if (host->dma_in_use)
+		mmc_omap_release_dma(host, data, data->error);
 
-		BUG_ON(host->dma_ch < 0);
-		if (data->error)
-			omap_stop_dma(host->dma_ch);
-		/* Release DMA channel lazily */
-		mod_timer(&host->dma_timer, jiffies + HZ);
-		if (data->flags & MMC_DATA_WRITE)
-			dma_data_dir = DMA_TO_DEVICE;
-		else
-			dma_data_dir = DMA_FROM_DEVICE;
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_len,
-			     dma_data_dir);
-	}
 	host->data = NULL;
 	host->sg_len = 0;
-	clk_disable(host->fclk);
 
 	/* NOTE:  MMC layer will sometimes poll-wait CMD13 next, issuing
 	 * dozens of requests until the card finishes writing data.
@@ -354,8 +360,12 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 	 */
 
 	if (!data->stop) {
+		struct mmc_host *mmc;
+
 		host->mrq = NULL;
-		mmc_request_done(host->mmc, data->mrq);
+		mmc = host->mmc;
+		mmc_omap_release_slot(host->current_slot);
+		mmc_request_done(mmc, data->mrq);
 		return;
 	}
 
@@ -363,6 +373,32 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 }
 
 static void
+mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
+{
+	int loops;
+	u16 ie;
+
+	if (host->dma_in_use)
+		mmc_omap_release_dma(host, data, 1);
+
+	host->data = NULL;
+	host->sg_len = 0;
+
+	ie = OMAP_MMC_READ(host, IE);
+	OMAP_MMC_WRITE(host, IE, 0);
+	OMAP_MMC_WRITE(host, CMD, 1 << 7);
+	loops = 0;
+	while (!(OMAP_MMC_READ(host, STAT) & OMAP_MMC_STAT_END_OF_CMD)) {
+		udelay(1);
+		loops++;
+		if (loops == 100000)
+			break;
+	}
+	OMAP_MMC_WRITE(host, STAT, OMAP_MMC_STAT_END_OF_CMD);
+	OMAP_MMC_WRITE(host, IE, ie);
+}
+
+static void
 mmc_omap_end_of_data(struct mmc_omap_host *host, struct mmc_data *data)
 {
 	unsigned long flags;
@@ -439,9 +475,14 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 	}
 
 	if (host->data == NULL || cmd->error) {
+		struct mmc_host *mmc;
+
+		if (host->data != NULL)
+			mmc_omap_abort_xfer(host, host->data);
 		host->mrq = NULL;
-		clk_disable(host->fclk);
-		mmc_request_done(host->mmc, cmd->mrq);
+		mmc = host->mmc;
+		mmc_omap_release_slot(host->current_slot);
+		mmc_request_done(mmc, cmd->mrq);
 	}
 }
 
_

Patches currently in -mm which might be from juha.yrjola@solidboot.com are

mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch

