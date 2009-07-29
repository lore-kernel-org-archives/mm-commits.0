From: akpm@linux-foundation.org
Subject: + omap_hsmmc-cleanup-macro-usage.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:38 -0700
Message-ID: <200907292058.n6TKwcOp009615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbZG2U67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:58:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: cleanup macro usage
has been added to the -mm tree.  Its filename is
     omap_hsmmc-cleanup-macro-usage.patch

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
Subject: omap_hsmmc: cleanup macro usage
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

Use macro mmc_slot() in omap_hsmmc.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   42 ++++++++++++++------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-cleanup-macro-usage drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-cleanup-macro-usage
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -368,9 +368,8 @@ int mmc_omap_cover_is_closed(struct mmc_
 {
 	int r = 1;
 
-	if (host->pdata->slots[host->slot_id].get_cover_state)
-		r = host->pdata->slots[host->slot_id].get_cover_state(host->dev,
-			host->slot_id);
+	if (mmc_slot(host).get_cover_state)
+		r = mmc_slot(host).get_cover_state(host->dev, host->slot_id);
 	return r;
 }
 
@@ -393,9 +392,8 @@ mmc_omap_show_slot_name(struct device *d
 {
 	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
 	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_slot_data slot = host->pdata->slots[host->slot_id];
 
-	return sprintf(buf, "%s\n", slot.name);
+	return sprintf(buf, "%s\n", mmc_slot(host).name);
 }
 
 static DEVICE_ATTR(slot_name, S_IRUGO, mmc_omap_show_slot_name, NULL);
@@ -632,7 +630,8 @@ static irqreturn_t mmc_omap_irq(int irq,
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
-					mmc_omap_reset_controller_fsm(host, SRC);
+					mmc_omap_reset_controller_fsm(host,
+								      SRC);
 					host->cmd->error = -ETIMEDOUT;
 				} else {
 					host->cmd->error = -EILSEQ;
@@ -775,7 +774,7 @@ static void mmc_omap_detect(struct work_
 
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 
-	if (mmc_slot(host).card_detect)
+	if (slot->card_detect)
 		carddetect = slot->card_detect(slot->card_detect_irq);
 	else
 		carddetect = -ENOSYS;
@@ -830,7 +829,7 @@ static void mmc_omap_config_dma_params(s
 			sg_dma_address(sgl), 0, 0);
 	} else {
 		omap_set_dma_src_params(dma_ch, 0, OMAP_DMA_AMODE_CONSTANT,
-					(host->mapbase + OMAP_HSMMC_DATA), 0, 0);
+			(host->mapbase + OMAP_HSMMC_DATA), 0, 0);
 		omap_set_dma_dest_params(dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
 			sg_dma_address(sgl), 0, 0);
 	}
@@ -918,7 +917,7 @@ mmc_omap_start_dma_transfer(struct mmc_o
 	}
 
 	ret = omap_request_dma(mmc_omap_get_dma_sync_dev(host, data), "MMC/SD",
-			       mmc_omap_dma_cb,host, &dma_ch);
+			       mmc_omap_dma_cb, host, &dma_ch);
 	if (ret != 0) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: omap_request_dma() failed with %d\n",
@@ -1138,21 +1137,19 @@ static void omap_mmc_set_ios(struct mmc_
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_platform_data *pdata = host->pdata;
 
-	if (!pdata->slots[0].card_detect)
+	if (!mmc_slot(host).card_detect)
 		return -ENOSYS;
-	return pdata->slots[0].card_detect(pdata->slots[0].card_detect_irq);
+	return mmc_slot(host).card_detect(mmc_slot(host).card_detect_irq);
 }
 
 static int omap_hsmmc_get_ro(struct mmc_host *mmc)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_platform_data *pdata = host->pdata;
 
-	if (!pdata->slots[0].get_ro)
+	if (!mmc_slot(host).get_ro)
 		return -ENOSYS;
-	return pdata->slots[0].get_ro(host->dev, 0);
+	return mmc_slot(host).get_ro(host->dev, 0);
 }
 
 static void omap_hsmmc_init(struct mmc_omap_host *host)
@@ -1563,7 +1560,7 @@ static int __init omap_mmc_probe(struct 
 	platform_set_drvdata(pdev, host);
 	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
 
-	if (pdata->slots[host->slot_id].power_saving)
+	if (mmc_slot(host).power_saving)
 		mmc->ops	= &mmc_omap_ps_ops;
 	else
 		mmc->ops	= &mmc_omap_ops;
@@ -1633,12 +1630,12 @@ static int __init omap_mmc_probe(struct 
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
 		     MMC_CAP_WAIT_WHILE_BUSY;
 
-	if (pdata->slots[host->slot_id].wires >= 8)
+	if (mmc_slot(host).wires >= 8)
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
-	else if (pdata->slots[host->slot_id].wires >= 4)
+	else if (mmc_slot(host).wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	if (pdata->slots[host->slot_id].nonremovable)
+	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
 
 	mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
@@ -1702,13 +1699,12 @@ static int __init omap_mmc_probe(struct 
 
 	mmc_add_host(mmc);
 
-	if (host->pdata->slots[host->slot_id].name != NULL) {
+	if (mmc_slot(host).name != NULL) {
 		ret = device_create_file(&mmc->class_dev, &dev_attr_slot_name);
 		if (ret < 0)
 			goto err_slot_name;
 	}
-	if (mmc_slot(host).card_detect_irq &&
-	    host->pdata->slots[host->slot_id].get_cover_state) {
+	if (mmc_slot(host).card_detect_irq && mmc_slot(host).get_cover_state) {
 		ret = device_create_file(&mmc->class_dev,
 					&dev_attr_cover_switch);
 		if (ret < 0)
@@ -1814,7 +1810,7 @@ static int omap_mmc_suspend(struct platf
 
 
 			OMAP_HSMMC_WRITE(host->base, HCTL,
-					 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
 			clk_disable(host->dbclk);
_

Patches currently in -mm which might be from ext-denis.2.karpov@nokia.com are

mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

