From: akpm@linux-foundation.org
Subject: [merged] davinci-mmc-add-cpufreq-support.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:39 -0800
Message-ID: <200912152158.nBFLwddA015836__46215.9021095887$1260915283$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933877AbZLOWO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:14:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaithrika@ti.com, linus.ml.walleij@gmail.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     davinci: mmc: add cpufreq support
has been removed from the -mm tree.  Its filename was
     davinci-mmc-add-cpufreq-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: mmc: add cpufreq support
From: Chaithrika U S <chaithrika@ti.com>

Add cpufreq support to MMC driver. The clock divider value has to be
modified according to the controller input frequency.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/davinci_mmc.c |  100 ++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 16 deletions(-)

diff -puN drivers/mmc/host/davinci_mmc.c~davinci-mmc-add-cpufreq-support drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~davinci-mmc-add-cpufreq-support
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/cpufreq.h>
 #include <linux/mmc/host.h>
 #include <linux/io.h>
 #include <linux/irq.h>
@@ -200,6 +201,9 @@ struct mmc_davinci_host {
 	u8 version;
 	/* for ns in one cycle calculation */
 	unsigned ns_in_one_cycle;
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
 };
 
 
@@ -739,27 +743,12 @@ static unsigned int calculate_freq_for_c
 	return mmc_push_pull_divisor;
 }
 
-static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	unsigned int open_drain_freq = 0, mmc_pclk = 0;
 	unsigned int mmc_push_pull_freq = 0;
 	struct mmc_davinci_host *host = mmc_priv(mmc);
 
-	mmc_pclk = host->mmc_input_clk;
-	dev_dbg(mmc_dev(host->mmc),
-		"clock %dHz busmode %d powermode %d Vdd %04x\n",
-		ios->clock, ios->bus_mode, ios->power_mode,
-		ios->vdd);
-	if (ios->bus_width == MMC_BUS_WIDTH_4) {
-		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
-		writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
-			host->base + DAVINCI_MMCCTL);
-	} else {
-		dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
-		writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
-			host->base + DAVINCI_MMCCTL);
-	}
-
 	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
 		u32 temp;
 
@@ -798,6 +787,29 @@ static void mmc_davinci_set_ios(struct m
 
 		udelay(10);
 	}
+}
+
+static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	unsigned int mmc_pclk = 0;
+	struct mmc_davinci_host *host = mmc_priv(mmc);
+
+	mmc_pclk = host->mmc_input_clk;
+	dev_dbg(mmc_dev(host->mmc),
+		"clock %dHz busmode %d powermode %d Vdd %04x\n",
+		ios->clock, ios->bus_mode, ios->power_mode,
+		ios->vdd);
+	if (ios->bus_width == MMC_BUS_WIDTH_4) {
+		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
+		writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
+			host->base + DAVINCI_MMCCTL);
+	} else {
+		dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
+		writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
+			host->base + DAVINCI_MMCCTL);
+	}
+
+	calculate_clk_divider(mmc, ios);
 
 	host->bus_mode = ios->bus_mode;
 	if (ios->power_mode == MMC_POWER_UP) {
@@ -1040,6 +1052,52 @@ static struct mmc_host_ops mmc_davinci_o
 
 /*----------------------------------------------------------------------*/
 
+#ifdef CONFIG_CPU_FREQ
+static int mmc_davinci_cpufreq_transition(struct notifier_block *nb,
+				     unsigned long val, void *data)
+{
+	struct mmc_davinci_host *host;
+	unsigned int mmc_pclk;
+	struct mmc_host *mmc;
+	unsigned long flags;
+
+	host = container_of(nb, struct mmc_davinci_host, freq_transition);
+	mmc = host->mmc;
+	mmc_pclk = clk_get_rate(host->clk);
+
+	if (val == CPUFREQ_POSTCHANGE) {
+		spin_lock_irqsave(&mmc->lock, flags);
+		host->mmc_input_clk = mmc_pclk;
+		calculate_clk_divider(mmc, &mmc->ios);
+		spin_unlock_irqrestore(&mmc->lock, flags);
+	}
+
+	return 0;
+}
+
+static inline int mmc_davinci_cpufreq_register(struct mmc_davinci_host *host)
+{
+	host->freq_transition.notifier_call = mmc_davinci_cpufreq_transition;
+
+	return cpufreq_register_notifier(&host->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void mmc_davinci_cpufreq_deregister(struct mmc_davinci_host *host)
+{
+	cpufreq_unregister_notifier(&host->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+#else
+static inline int mmc_davinci_cpufreq_register(struct mmc_davinci_host *host)
+{
+	return 0;
+}
+
+static inline void mmc_davinci_cpufreq_deregister(struct mmc_davinci_host *host)
+{
+}
+#endif
 static void __init init_mmcsd_host(struct mmc_davinci_host *host)
 {
 	/* DAT line portion is diabled and in reset state */
@@ -1169,6 +1227,12 @@ static int __init davinci_mmcsd_probe(st
 
 	platform_set_drvdata(pdev, host);
 
+	ret = mmc_davinci_cpufreq_register(host);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register cpufreq\n");
+		goto cpu_freq_fail;
+	}
+
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto out;
@@ -1186,6 +1250,8 @@ static int __init davinci_mmcsd_probe(st
 	return 0;
 
 out:
+	mmc_davinci_cpufreq_deregister(host);
+cpu_freq_fail:
 	if (host) {
 		davinci_release_dma_channels(host);
 
@@ -1215,6 +1281,8 @@ static int __exit davinci_mmcsd_remove(s
 
 	platform_set_drvdata(pdev, NULL);
 	if (host) {
+		mmc_davinci_cpufreq_deregister(host);
+
 		mmc_remove_host(host->mmc);
 		free_irq(host->irq, host);
 
_

Patches currently in -mm which might be from chaithrika@ti.com are

origin.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch
davinci-fb-add-cpufreq-support.patch
davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features.patch
da850-omap-l138-add-callback-to-control-lcd-panel-power.patch
davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver.patch
davinci-fb-add-framebuffer-blank-operation.patch

