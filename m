From: akpm@linux-foundation.org
Subject: + mmc-drop-the-state-argument-to-mmc_suspend_host.patch added to -mm tree
Date: Thu, 13 May 2010 14:45:22 -0700
Message-ID: <201005132145.o4DLjMeP022106__46825.6837608807$1273787175$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab0EMVqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt@console-pimps.org, cbouatmailru@gmail.com, linux-mmc@vger.kernel.org, mirq-linux@rere.qmqm.pl


The patch titled
     mmc: remove the "state" argument to mmc_suspend_host()
has been added to the -mm tree.  Its filename is
     mmc-drop-the-state-argument-to-mmc_suspend_host.patch

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
Subject: mmc: remove the "state" argument to mmc_suspend_host()
From: Matt Fleming <matt@console-pimps.org>

Even though many mmc host drivers pass a pm_message_t argument to
mmc_suspend_host() that argument isn't used the by MMC core.  As host
drivers are converted to dev_pm_ops they'll have to construct
pm_message_t's (as they won't be passed by the PM subsystem any more) just
to appease the mmc suspend interface.

We might as well just delete the unused paramter.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>ZZ
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c          |    3 +--
 drivers/mmc/host/at91_mci.c      |    2 +-
 drivers/mmc/host/au1xmmc.c       |    2 +-
 drivers/mmc/host/bfin_sdh.c      |    2 +-
 drivers/mmc/host/cb710-mmc.c     |    2 +-
 drivers/mmc/host/davinci_mmc.c   |    3 +--
 drivers/mmc/host/imxmmc.c        |    2 +-
 drivers/mmc/host/mmci.c          |    2 +-
 drivers/mmc/host/msm_sdcc.c      |    2 +-
 drivers/mmc/host/mvsdio.c        |    2 +-
 drivers/mmc/host/mxcmmc.c        |    2 +-
 drivers/mmc/host/omap.c          |    2 +-
 drivers/mmc/host/omap_hsmmc.c    |    2 +-
 drivers/mmc/host/pxamci.c        |    2 +-
 drivers/mmc/host/s3cmci.c        |    3 +--
 drivers/mmc/host/sdhci-of-core.c |    2 +-
 drivers/mmc/host/sdhci.c         |    2 +-
 drivers/mmc/host/sdricoh_cs.c    |    2 +-
 drivers/mmc/host/tifm_sd.c       |    2 +-
 drivers/mmc/host/tmio_mmc.c      |    2 +-
 drivers/mmc/host/via-sdmmc.c     |    2 +-
 drivers/mmc/host/wbsd.c          |    2 +-
 include/linux/mmc/host.h         |    2 +-
 23 files changed, 23 insertions(+), 26 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/core/core.c
@@ -1252,9 +1252,8 @@ EXPORT_SYMBOL(mmc_card_can_sleep);
 /**
  *	mmc_suspend_host - suspend a host
  *	@host: mmc host
- *	@state: suspend mode (PM_SUSPEND_xxx)
  */
-int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
+int mmc_suspend_host(struct mmc_host *host)
 {
 	int err = 0;
 
diff -puN drivers/mmc/host/at91_mci.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/at91_mci.c
@@ -1157,7 +1157,7 @@ static int at91_mci_suspend(struct platf
 		enable_irq_wake(host->board->det_pin);
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff -puN drivers/mmc/host/au1xmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/au1xmmc.c
--- a/drivers/mmc/host/au1xmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/au1xmmc.c
@@ -1142,7 +1142,7 @@ static int au1xmmc_suspend(struct platfo
 	struct au1xmmc_host *host = platform_get_drvdata(pdev);
 	int ret;
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc);
 	if (ret)
 		return ret;
 
diff -puN drivers/mmc/host/bfin_sdh.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -576,7 +576,7 @@ static int sdh_suspend(struct platform_d
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() & ~PWR_ON);
 	peripheral_free_list(drv_data->pin_req);
diff -puN drivers/mmc/host/cb710-mmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/cb710-mmc.c
--- a/drivers/mmc/host/cb710-mmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/cb710-mmc.c
@@ -675,7 +675,7 @@ static int cb710_mmc_suspend(struct plat
 	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
 	int err;
 
-	err = mmc_suspend_host(mmc, state);
+	err = mmc_suspend_host(mmc);
 	if (err)
 		return err;
 
diff -puN drivers/mmc/host/davinci_mmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -1337,11 +1337,10 @@ static int davinci_mmcsd_suspend(struct 
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
-	struct pm_message msg = { PM_EVENT_SUSPEND };
 	int ret;
 
 	mmc_host_enable(host->mmc);
-	ret = mmc_suspend_host(host->mmc, msg);
+	ret = mmc_suspend_host(host->mmc);
 	if (!ret) {
 		writel(0, host->base + DAVINCI_MMCIM);
 		mmc_davinci_reset_ctrl(host, 1);
diff -puN drivers/mmc/host/imxmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/imxmmc.c
--- a/drivers/mmc/host/imxmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/imxmmc.c
@@ -1115,7 +1115,7 @@ static int imxmci_suspend(struct platfor
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff -puN drivers/mmc/host/mmci.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/mmci.c
--- a/drivers/mmc/host/mmci.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/mmci.c
@@ -824,7 +824,7 @@ static int mmci_suspend(struct amba_devi
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
 
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 		if (ret == 0)
 			writel(0, host->base + MMCIMASK0);
 	}
diff -puN drivers/mmc/host/msm_sdcc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -1327,7 +1327,7 @@ msmsdcc_suspend(struct platform_device *
 			disable_irq(host->stat_irq);
 
 		if (mmc->card && mmc->card->type != MMC_TYPE_SDIO)
-			rc = mmc_suspend_host(mmc, state);
+			rc = mmc_suspend_host(mmc);
 		if (!rc)
 			msmsdcc_writel(host, 0, MMCIMASK0);
 		if (host->clks_on)
diff -puN drivers/mmc/host/mvsdio.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/mvsdio.c
--- a/drivers/mmc/host/mvsdio.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/mvsdio.c
@@ -865,7 +865,7 @@ static int mvsd_suspend(struct platform_
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff -puN drivers/mmc/host/mxcmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/mxcmmc.c
--- a/drivers/mmc/host/mxcmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/mxcmmc.c
@@ -921,7 +921,7 @@ static int mxcmci_suspend(struct platfor
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff -puN drivers/mmc/host/omap.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/omap.c
@@ -1561,7 +1561,7 @@ static int mmc_omap_suspend(struct platf
 		struct mmc_omap_slot *slot;
 
 		slot = host->slots[i];
-		ret = mmc_suspend_host(slot->mmc, mesg);
+		ret = mmc_suspend_host(slot->mmc);
 		if (ret < 0) {
 			while (--i >= 0) {
 				slot = host->slots[i];
diff -puN drivers/mmc/host/omap_hsmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2292,7 +2292,7 @@ static int omap_hsmmc_suspend(struct dev
 		}
 		cancel_work_sync(&host->mmc_carddetect_work);
 		mmc_host_enable(host->mmc);
-		ret = mmc_suspend_host(host->mmc, state);
+		ret = mmc_suspend_host(host->mmc);
 		if (ret == 0) {
 			omap_hsmmc_disable_irq(host);
 			OMAP_HSMMC_WRITE(host->base, HCTL,
diff -puN drivers/mmc/host/pxamci.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/pxamci.c
@@ -813,7 +813,7 @@ static int pxamci_suspend(struct device 
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, PMSG_SUSPEND);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff -puN drivers/mmc/host/s3cmci.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/s3cmci.c
@@ -1881,9 +1881,8 @@ MODULE_DEVICE_TABLE(platform, s3cmci_dri
 static int s3cmci_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
-	struct pm_message event = { PM_EVENT_SUSPEND };
 
-	return mmc_suspend_host(mmc, event);
+	return mmc_suspend_host(mmc);
 }
 
 static int s3cmci_resume(struct device *dev)
diff -puN drivers/mmc/host/sdhci-of-core.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/sdhci-of-core.c
--- a/drivers/mmc/host/sdhci-of-core.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/sdhci-of-core.c
@@ -89,7 +89,7 @@ static int sdhci_of_suspend(struct of_de
 {
 	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
 
-	return mmc_suspend_host(host->mmc, state);
+	return mmc_suspend_host(host->mmc);
 }
 
 static int sdhci_of_resume(struct of_device *ofdev)
diff -puN drivers/mmc/host/sdhci.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/sdhci.c
@@ -1597,7 +1597,7 @@ int sdhci_suspend_host(struct sdhci_host
 
 	sdhci_disable_card_detection(host);
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc);
 	if (ret)
 		return ret;
 
diff -puN drivers/mmc/host/sdricoh_cs.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/sdricoh_cs.c
--- a/drivers/mmc/host/sdricoh_cs.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/sdricoh_cs.c
@@ -519,7 +519,7 @@ static int sdricoh_pcmcia_suspend(struct
 {
 	struct mmc_host *mmc = link->priv;
 	dev_dbg(&link->dev, "suspend\n");
-	mmc_suspend_host(mmc, PMSG_SUSPEND);
+	mmc_suspend_host(mmc);
 	return 0;
 }
 
diff -puN drivers/mmc/host/tifm_sd.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/tifm_sd.c
--- a/drivers/mmc/host/tifm_sd.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/tifm_sd.c
@@ -1032,7 +1032,7 @@ static void tifm_sd_remove(struct tifm_d
 
 static int tifm_sd_suspend(struct tifm_dev *sock, pm_message_t state)
 {
-	return mmc_suspend_host(tifm_get_drvdata(sock), state);
+	return mmc_suspend_host(tifm_get_drvdata(sock));
 }
 
 static int tifm_sd_resume(struct tifm_dev *sock)
diff -puN drivers/mmc/host/tmio_mmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -657,7 +657,7 @@ static int tmio_mmc_suspend(struct platf
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret;
 
-	ret = mmc_suspend_host(mmc, state);
+	ret = mmc_suspend_host(mmc);
 
 	/* Tell MFD core it can disable us now.*/
 	if (!ret && cell->disable)
diff -puN drivers/mmc/host/via-sdmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/via-sdmmc.c
--- a/drivers/mmc/host/via-sdmmc.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/via-sdmmc.c
@@ -1280,7 +1280,7 @@ static int via_sd_suspend(struct pci_dev
 	via_save_pcictrlreg(host);
 	via_save_sdcreg(host);
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc);
 
 	pci_save_state(pcidev);
 	pci_enable_wake(pcidev, pci_choose_state(pcidev, state), 0);
diff -puN drivers/mmc/host/wbsd.c~mmc-drop-the-state-argument-to-mmc_suspend_host drivers/mmc/host/wbsd.c
--- a/drivers/mmc/host/wbsd.c~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/drivers/mmc/host/wbsd.c
@@ -1819,7 +1819,7 @@ static int wbsd_suspend(struct wbsd_host
 {
 	BUG_ON(host == NULL);
 
-	return mmc_suspend_host(host->mmc, state);
+	return mmc_suspend_host(host->mmc);
 }
 
 static int wbsd_resume(struct wbsd_host *host)
diff -puN include/linux/mmc/host.h~mmc-drop-the-state-argument-to-mmc_suspend_host include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-drop-the-state-argument-to-mmc_suspend_host
+++ a/include/linux/mmc/host.h
@@ -230,7 +230,7 @@ static inline void *mmc_priv(struct mmc_
 #define mmc_classdev(x)	(&(x)->class_dev)
 #define mmc_hostname(x)	(dev_name(&(x)->class_dev))
 
-extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
+extern int mmc_suspend_host(struct mmc_host *);
 extern int mmc_resume_host(struct mmc_host *);
 
 extern void mmc_power_save_host(struct mmc_host *host);
_

Patches currently in -mm which might be from matt@console-pimps.org are

linux-next.patch
mmc-sdhci_int_data_mask-typo-error.patch
sdhci-rename-sdhci-i-o-accessor-functions.patch
mmc-omap-hs-mmc-convert-to-dev_pm_ops.patch
mmc-drop-the-state-argument-to-mmc_suspend_host.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

