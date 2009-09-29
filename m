From: akpm@linux-foundation.org
Subject: + s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:57:22 -0700
Message-ID: <200909292257.n8TMvMeR026123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbZI2W5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org


The patch titled
     s3cmci: make SDIO IRQ hardware IRQ support build-time configurable
has been added to the -mm tree.  Its filename is
     s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch

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
Subject: s3cmci: make SDIO IRQ hardware IRQ support build-time configurable
From: Ben Dooks <ben@simtec.co.uk>

We have found a couple of boards where the SDIO IRQ hardware support has
failed to work properly, and thus we should make it configurable whether
or not to be included in the driver.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig  |    7 +++++++
 drivers/mmc/host/s3cmci.c |    9 +++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/Kconfig~s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable
+++ a/drivers/mmc/host/Kconfig
@@ -276,6 +276,13 @@ config MMC_S3C
 
 	  If unsure, say N.
 
+config MMC_S3C_HW_SDIO_IRQ
+       bool "Hardware support for SDIO IRQ"
+       depends on MMC_S3C
+       help
+         Enable the hardware support for SDIO interrupts instead of using
+	 the generic polling code.
+
 choice
 	prompt "Samsung S3C SD/MMC transfer code"
 	depends on MMC_S3C
diff -puN drivers/mmc/host/s3cmci.c~s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable
+++ a/drivers/mmc/host/s3cmci.c
@@ -1715,7 +1715,11 @@ static int __devinit s3cmci_probe(struct
 
 	mmc->ops 	= &s3cmci_ops;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+#ifdef CONFIG_MMC_S3C_HW_SDIO_IRQ
 	mmc->caps	= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
+#else
+	mmc->caps	= MMC_CAP_4_BIT_DATA;
+#endif
 	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
 	mmc->f_max 	= host->clk_rate / host->clk_div;
 
@@ -1750,8 +1754,9 @@ static int __devinit s3cmci_probe(struct
 	s3cmci_debugfs_attach(host);
 
 	platform_set_drvdata(pdev, mmc);
-	dev_info(&pdev->dev, "%s - using %s\n", mmc_hostname(mmc),
-		 s3cmci_host_usedma(host) ? "dma" : "pio");
+	dev_info(&pdev->dev, "%s - using %s, %s SDIO IRQ\n", mmc_hostname(mmc),
+		 s3cmci_host_usedma(host) ? "dma" : "pio",
+		 mmc->caps & MMC_CAP_SDIO_IRQ ? "hw" : "sw");
 
 	return 0;
 
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3cmci-use-resource_size-instead-of-local-macro.patch
s3cmci-update-probe-to-use-new-platform-id-list.patch
s3cmci-change-gpio-to-gpiolib-from-s3c24xx-specific-calls.patch
s3cmci-change-to-use-dev_pm_ops.patch
s3cmci-fix-direct-write-to-interrupt-mask.patch
s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state.patch
s3cmci-add-sdio-irq-support.patch
s3cmci-kconfig-selection-for-pio-dma-both.patch
s3cmci-dma-fixes.patch
s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch
s3cmci-add-better-support-for-no-card-detect-or-write-protect-available.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

