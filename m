From: akpm@linux-foundation.org
Subject: [to-be-updated] sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch removed from -mm tree
Date: Thu, 13 May 2010 15:02:20 -0700
Message-ID: <201005132202.o4DM2K5O023003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab0EMWD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 18:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     sh: prepare the SDHI MFD driver to pass DMA configuration to tmio_mmc.c
has been removed from the -mm tree.  Its filename was
     sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: prepare the SDHI MFD driver to pass DMA configuration to tmio_mmc.c
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Pass DMA slave IDs from platform down to the tmio_mmc driver, to be used
for dmaengine configuration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sh_mobile_sdhi.c       |   24 ++++++++++++++++++++----
 include/linux/mfd/sh_mobile_sdhi.h |    2 ++
 include/linux/mfd/tmio.h           |    6 ++++++
 3 files changed, 28 insertions(+), 4 deletions(-)

diff -puN drivers/mfd/sh_mobile_sdhi.c~sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc drivers/mfd/sh_mobile_sdhi.c
--- a/drivers/mfd/sh_mobile_sdhi.c~sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc
+++ a/drivers/mfd/sh_mobile_sdhi.c
@@ -26,11 +26,15 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tmio.h>
 #include <linux/mfd/sh_mobile_sdhi.h>
+#include <linux/sh_dma.h>
 
 struct sh_mobile_sdhi {
 	struct clk *clk;
 	struct tmio_mmc_data mmc_data;
 	struct mfd_cell cell_mmc;
+	struct sh_dmae_slave param_tx;
+	struct sh_dmae_slave param_rx;
+	struct tmio_mmc_dma dma_priv;
 };
 
 static struct resource sh_mobile_sdhi_resources[] = {
@@ -64,6 +68,8 @@ static void sh_mobile_sdhi_set_pwr(struc
 static int __init sh_mobile_sdhi_probe(struct platform_device *pdev)
 {
 	struct sh_mobile_sdhi *priv;
+	struct tmio_mmc_data *mmc_data;
+	struct sh_mobile_sdhi_info *p = pdev->dev.platform_data;
 	struct resource *mem;
 	char clk_name[8];
 	int ret, irq;
@@ -85,6 +91,8 @@ static int __init sh_mobile_sdhi_probe(s
 		return -ENOMEM;
 	}
 
+	mmc_data = &priv->mmc_data;
+
 	snprintf(clk_name, sizeof(clk_name), "sdhi%d", pdev->id);
 	priv->clk = clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(priv->clk)) {
@@ -96,12 +104,20 @@ static int __init sh_mobile_sdhi_probe(s
 
 	clk_enable(priv->clk);
 
-	priv->mmc_data.hclk = clk_get_rate(priv->clk);
-	priv->mmc_data.set_pwr = sh_mobile_sdhi_set_pwr;
-	priv->mmc_data.capabilities = MMC_CAP_MMC_HIGHSPEED;
+	mmc_data->hclk = clk_get_rate(priv->clk);
+	mmc_data->set_pwr = sh_mobile_sdhi_set_pwr;
+	mmc_data->capabilities = MMC_CAP_MMC_HIGHSPEED;
+
+	if (p && p->dma_slave_tx >= 0 && p->dma_slave_rx >= 0) {
+		priv->param_tx.slave_id = p->dma_slave_tx;
+		priv->param_rx.slave_id = p->dma_slave_rx;
+		priv->dma_priv.chan_priv_tx = &priv->param_tx;
+		priv->dma_priv.chan_priv_rx = &priv->param_rx;
+		mmc_data->dma = &priv->dma_priv;
+	}
 
 	memcpy(&priv->cell_mmc, &sh_mobile_sdhi_cell, sizeof(priv->cell_mmc));
-	priv->cell_mmc.driver_data = &priv->mmc_data;
+	priv->cell_mmc.driver_data = mmc_data;
 	priv->cell_mmc.platform_data = &priv->cell_mmc;
 	priv->cell_mmc.data_size = sizeof(priv->cell_mmc);
 
diff -puN include/linux/mfd/sh_mobile_sdhi.h~sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc include/linux/mfd/sh_mobile_sdhi.h
--- a/include/linux/mfd/sh_mobile_sdhi.h~sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc
+++ a/include/linux/mfd/sh_mobile_sdhi.h
@@ -2,6 +2,8 @@
 #define __SH_MOBILE_SDHI_H__
 
 struct sh_mobile_sdhi_info {
+	int dma_slave_tx;
+	int dma_slave_rx;
 	void (*set_pwr)(struct platform_device *pdev, int state);
 };
 
diff -puN include/linux/mfd/tmio.h~sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc include/linux/mfd/tmio.h
--- a/include/linux/mfd/tmio.h~sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc
+++ a/include/linux/mfd/tmio.h
@@ -55,12 +55,18 @@ int tmio_core_mmc_resume(void __iomem *c
 void tmio_core_mmc_pwr(void __iomem *cnf, int shift, int state);
 void tmio_core_mmc_clk_div(void __iomem *cnf, int shift, int state);
 
+struct tmio_mmc_dma {
+	void *chan_priv_tx;
+	void *chan_priv_rx;
+};
+
 /*
  * data for the MMC controller
  */
 struct tmio_mmc_data {
 	unsigned int			hclk;
 	unsigned long			capabilities;
+	struct tmio_mmc_dma		*dma;
 	void (*set_pwr)(struct platform_device *host, int state);
 	void (*set_clk_div)(struct platform_device *host, int state);
 };
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch

