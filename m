From: akpm@linux-foundation.org
Subject: [merged] sdio-sdhci-support-for-suspend-mode-pm-features.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:12 -0800
Message-ID: <201003091908.o29J8CHX031429__28219.9498768479$1268162562$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005Ab0CITWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     sdio: sdhci support for suspend mode PM features
has been removed from the -mm tree.  Its filename was
     sdio-sdhci-support-for-suspend-mode-pm-features.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: sdhci support for suspend mode PM features
From: Nicolas Pitre <nico@fluxnic.net>

Tested with an XO v1.5 from OLPC.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |   17 ++++++++++++++---
 drivers/mmc/host/sdhci.c     |   26 +++++++++++++++++---------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff -puN drivers/mmc/host/sdhci-pci.c~sdio-sdhci-support-for-suspend-mode-pm-features drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~sdio-sdhci-support-for-suspend-mode-pm-features
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -501,6 +501,7 @@ static int sdhci_pci_suspend (struct pci
 {
 	struct sdhci_pci_chip *chip;
 	struct sdhci_pci_slot *slot;
+	mmc_pm_flag_t pm_flags = 0;
 	int i, ret;
 
 	chip = pci_get_drvdata(pdev);
@@ -519,6 +520,8 @@ static int sdhci_pci_suspend (struct pci
 				sdhci_resume_host(chip->slots[i]->host);
 			return ret;
 		}
+
+		pm_flags |= slot->host->mmc->pm_flags;
 	}
 
 	if (chip->fixes && chip->fixes->suspend) {
@@ -531,9 +534,15 @@ static int sdhci_pci_suspend (struct pci
 	}
 
 	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	if (pm_flags & MMC_PM_KEEP_POWER) {
+		if (pm_flags & MMC_PM_WAKE_SDIO_IRQ)
+			pci_enable_wake(pdev, PCI_D3hot, 1);
+		pci_set_power_state(pdev, PCI_D3hot);
+	} else {
+		pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
+		pci_disable_device(pdev);
+		pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	}
 
 	return 0;
 }
@@ -653,6 +662,8 @@ static struct sdhci_pci_slot * __devinit
 			goto unmap;
 	}
 
+	host->mmc->pm_caps = MMC_PM_KEEP_POWER | MMC_PM_WAKE_SDIO_IRQ;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		goto remove;
diff -puN drivers/mmc/host/sdhci.c~sdio-sdhci-support-for-suspend-mode-pm-features drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdio-sdhci-support-for-suspend-mode-pm-features
+++ a/drivers/mmc/host/sdhci.c
@@ -174,20 +174,31 @@ static void sdhci_reset(struct sdhci_hos
 		sdhci_clear_set_irqs(host, SDHCI_INT_ALL_MASK, ier);
 }
 
-static void sdhci_init(struct sdhci_host *host)
+static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios);
+
+static void sdhci_init(struct sdhci_host *host, int soft)
 {
-	sdhci_reset(host, SDHCI_RESET_ALL);
+	if (soft)
+		sdhci_reset(host, SDHCI_RESET_CMD|SDHCI_RESET_DATA);
+	else
+		sdhci_reset(host, SDHCI_RESET_ALL);
 
 	sdhci_clear_set_irqs(host, SDHCI_INT_ALL_MASK,
 		SDHCI_INT_BUS_POWER | SDHCI_INT_DATA_END_BIT |
 		SDHCI_INT_DATA_CRC | SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_INDEX |
 		SDHCI_INT_END_BIT | SDHCI_INT_CRC | SDHCI_INT_TIMEOUT |
 		SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE);
+
+	if (soft) {
+		/* force clock reconfiguration */
+		host->clock = 0;
+		sdhci_set_ios(host->mmc, &host->mmc->ios);
+	}
 }
 
 static void sdhci_reinit(struct sdhci_host *host)
 {
-	sdhci_init(host);
+	sdhci_init(host, 0);
 	sdhci_enable_card_detection(host);
 }
 
@@ -1600,16 +1611,13 @@ int sdhci_resume_host(struct sdhci_host 
 	if (ret)
 		return ret;
 
-	sdhci_init(host);
+	sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
 	mmiowb();
 
 	ret = mmc_resume_host(host->mmc);
-	if (ret)
-		return ret;
