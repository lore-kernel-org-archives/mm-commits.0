From: akpm@linux-foundation.org
Subject: [merged] s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:09 -0700
Message-ID: <200910051839.n95Id9gN018475__22963.2912124091$1254768068$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbZJESjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: make SDIO IRQ hardware IRQ support build-time configurable
has been removed from the -mm tree.  Its filename was
     s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

gpiolib-add-names-file-in-gpio-chip-sysfs.patch

