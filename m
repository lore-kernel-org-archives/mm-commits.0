From: akpm@linux-foundation.org
Subject: + sdio-sdhci-support-for-suspend-mode-pm-features.patch added to -mm tree
Date: Thu, 11 Feb 2010 12:33:17 -0800
Message-ID: <201002112033.o1BKXHBR026962__5417.37070675499$1265920438$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734Ab0BKUdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:33:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com


The patch titled
     sdio: sdhci support for suspend mode PM features
has been added to the -mm tree.  Its filename is
     sdio-sdhci-support-for-suspend-mode-pm-features.patch

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
-
 	sdhci_enable_card_detection(host);
 
-	return 0;
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(sdhci_resume_host);
@@ -1864,7 +1872,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	if (ret)
 		goto untasklet;
 
-	sdhci_init(host);
+	sdhci_init(host, 0);
 
 #ifdef CONFIG_MMC_DEBUG
 	sdhci_dumpregs(host);
_

Patches currently in -mm which might be from nico@fluxnic.net are

mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch
sdio-introduce-api-for-special-power-management-features.patch
sdio-sdhci-support-for-suspend-mode-pm-features.patch
sdio-kick-the-interrupt-thread-upon-a-resume.patch

