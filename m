From: akpm@linux-foundation.org
Subject: [merged] davinci-mmc-add-support-for-8bit-mmc-cards.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:45 -0800
Message-ID: <201003091907.o29J7jkN031380__41752.4838740521$1268162583$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011Ab0CITW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vipin.bhandari@ti.com, chaithrika@ti.com, david-b@pacbell.net, linux-mmc@vger.kernel.org, sudhakar.raj@ti.com, mm-commits@vger.kernel.org


The patch titled
     davinci: MMC: add support for 8bit MMC cards
has been removed from the -mm tree.  Its filename was
     davinci-mmc-add-support-for-8bit-mmc-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: MMC: add support for 8bit MMC cards
From: Vipin Bhandari <vipin.bhandari@ti.com>

Add support for 8bit MMC cards.  The controller data width is configurable
depending on the wires setting in the platform data structure.

MMC 8bit is tested on OMAPL137 and MMC 4bit is tested on OMAPL138 EVM.

Signed-off-by: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Chaithrika U S <chaithrika@ti.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/davinci_mmc.c |   45 ++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/davinci_mmc.c~davinci-mmc-add-support-for-8bit-mmc-cards drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~davinci-mmc-add-support-for-8bit-mmc-cards
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -73,6 +73,7 @@
 /* DAVINCI_MMCCTL definitions */
 #define MMCCTL_DATRST         (1 << 0)
 #define MMCCTL_CMDRST         (1 << 1)
+#define MMCCTL_WIDTH_8_BIT    (1 << 8)
 #define MMCCTL_WIDTH_4_BIT    (1 << 2)
 #define MMCCTL_DATEG_DISABLED (0 << 6)
 #define MMCCTL_DATEG_RISING   (1 << 6)
@@ -791,22 +792,42 @@ static void calculate_clk_divider(struct
 
 static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	unsigned int mmc_pclk = 0;
 	struct mmc_davinci_host *host = mmc_priv(mmc);
 
-	mmc_pclk = host->mmc_input_clk;
 	dev_dbg(mmc_dev(host->mmc),
 		"clock %dHz busmode %d powermode %d Vdd %04x\n",
 		ios->clock, ios->bus_mode, ios->power_mode,
 		ios->vdd);
-	if (ios->bus_width == MMC_BUS_WIDTH_4) {
-		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
-		writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
-			host->base + DAVINCI_MMCCTL);
-	} else {
-		dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
-		writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_8:
+		dev_dbg(mmc_dev(host->mmc), "Enabling 8 bit mode\n");
+		writel((readl(host->base + DAVINCI_MMCCTL) &
+			~MMCCTL_WIDTH_4_BIT) | MMCCTL_WIDTH_8_BIT,
 			host->base + DAVINCI_MMCCTL);
+		break;
+	case MMC_BUS_WIDTH_4:
+		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
+		if (host->version == MMC_CTLR_VERSION_2)
+			writel((readl(host->base + DAVINCI_MMCCTL) &
+				~MMCCTL_WIDTH_8_BIT) | MMCCTL_WIDTH_4_BIT,
+				host->base + DAVINCI_MMCCTL);
+		else
+			writel(readl(host->base + DAVINCI_MMCCTL) |
+				MMCCTL_WIDTH_4_BIT,
+				host->base + DAVINCI_MMCCTL);
+		break;
+	case MMC_BUS_WIDTH_1:
+		dev_dbg(mmc_dev(host->mmc), "Enabling 1 bit mode\n");
+		if (host->version == MMC_CTLR_VERSION_2)
+			writel(readl(host->base + DAVINCI_MMCCTL) &
+				~(MMCCTL_WIDTH_8_BIT | MMCCTL_WIDTH_4_BIT),
+				host->base + DAVINCI_MMCCTL);
+		else
+			writel(readl(host->base + DAVINCI_MMCCTL) &
+				~MMCCTL_WIDTH_4_BIT,
+				host->base + DAVINCI_MMCCTL);
+		break;
 	}
 
 	calculate_clk_divider(mmc, ios);
@@ -1189,10 +1210,14 @@ static int __init davinci_mmcsd_probe(st
 
 	/* REVISIT:  someday, support IRQ-driven card detection.  */
 	mmc->caps |= MMC_CAP_NEEDS_POLL;
+	mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY;
 
-	if (!pdata || pdata->wires == 4 || pdata->wires == 0)
+	if (pdata && (pdata->wires == 4 || pdata->wires == 0))
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
+	if (pdata && (pdata->wires == 8))
+		mmc->caps |= (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA);
+
 	host->version = pdata->version;
 
 	mmc->ops = &mmc_davinci_ops;
_

Patches currently in -mm which might be from vipin.bhandari@ti.com are


