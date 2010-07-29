From: akpm@linux-foundation.org
Subject: + sdhci-add-regulator-support.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:52:32 -0700
Message-ID: <201007292052.o6TKqWoh000627__27299.4848237888$1280436769$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab0G2Uwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:52:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci: add regulator support
has been added to the -mm tree.  Its filename is
     sdhci-add-regulator-support.patch

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
Subject: sdhci: add regulator support
From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds support for regulator API to sdhci core driver. 
Regulators can be used to disable power in suspended state to reduce
dissipated energy.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   26 +++++++++++++++++++++++++-
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-add-regulator-support drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-add-regulator-support
+++ a/drivers/mmc/host/sdhci.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/jiffies.h>
+#include <linux/regulator/consumer.h>
 
 #include <linux/leds.h>
 
@@ -1573,7 +1574,10 @@ int sdhci_suspend_host(struct sdhci_host
 
 	free_irq(host->irq, host);
 
-	return 0;
+	if (host->vmmc)
+		ret = regulator_disable(host->vmmc);
+
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(sdhci_suspend_host);
@@ -1582,6 +1586,13 @@ int sdhci_resume_host(struct sdhci_host 
 {
 	int ret;
 
+	if (host->vmmc) {
+		int ret = regulator_enable(host->vmmc);
+		if (ret)
+			return ret;
+	}
+
+
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
 			host->ops->enable_dma(host);
@@ -1878,6 +1889,14 @@ int sdhci_add_host(struct sdhci_host *ho
 	if (ret)
 		return ret;
 
+	host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
+	if (IS_ERR(host->vmmc)) {
+		printk(KERN_INFO "%s: no vmmc regulator found\n", mmc_hostname(mmc));
+		host->vmmc = NULL;
+	} else {
+		regulator_enable(host->vmmc);
+	}
+
 	sdhci_init(host, 0);
 
 #ifdef CONFIG_MMC_DEBUG
@@ -1955,6 +1974,11 @@ void sdhci_remove_host(struct sdhci_host
 
 	flush_work(&host->finish_work);
 
+	if (host->vmmc) {
+		regulator_disable(host->vmmc);
+		regulator_put(host->vmmc);
+	}
+
 	kfree(host->adma_desc);
 	kfree(host->align_buffer);
 
diff -puN drivers/mmc/host/sdhci.h~sdhci-add-regulator-support drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-add-regulator-support
+++ a/drivers/mmc/host/sdhci.h
@@ -253,6 +253,8 @@ struct sdhci_host {
 
 	const struct sdhci_ops	*ops;		/* Low level hw interface */
 
+	struct regulator	*vmmc;		/* Power regulator */
+
 	/* Internal data */
 	struct mmc_host		*mmc;		/* MMC structure */
 	u64			dma_mask;	/* custom DMA mask */
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-s3c-enable-sdhci_quirk_no_hispd_bit-quirk.patch
sdhci-s3c-add-support-for-new-card-detection-methods.patch
sdhci-add-regulator-support.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch
s3c-fb-automatically-calculate-pixel-clock-when-none-is-given.patch
arm-samsung-remove-pixclock-from-several-boards.patch

