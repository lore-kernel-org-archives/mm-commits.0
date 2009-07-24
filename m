From: akpm@linux-foundation.org
Subject: + omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:54:56 -0700
Message-ID: <200907242254.n6OMsu7k031534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbZGXWzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: ensure workqueues are empty before suspend
has been added to the -mm tree.  Its filename is
     omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch

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
Subject: omap_hsmmc: ensure workqueues are empty before suspend
From: Adrian Hunter <adrian.hunter@nokia.com>

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   50 +++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-workqueues-are-empty-before-suspend drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-workqueues-are-empty-before-suspend
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -151,7 +151,6 @@ struct mmc_omap_host {
 	u32			bytesleft;
 	int			suspended;
 	int			irq;
-	int			carddetect;
 	int			use_dma, dma_ch;
 	int			dma_line_tx, dma_line_rx;
 	int			slot_id;
@@ -761,14 +760,19 @@ static void mmc_omap_detect(struct work_
 	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
 						mmc_carddetect_work);
 	struct omap_mmc_slot_data *slot = &mmc_slot(host);
+	int carddetect;
+
+	if (host->suspended)
+		return;
+
+	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 
 	if (mmc_slot(host).card_detect)
-		host->carddetect = slot->card_detect(slot->card_detect_irq);
+		carddetect = slot->card_detect(slot->card_detect_irq);
 	else
-		host->carddetect = -ENOSYS;
+		carddetect = -ENOSYS;
 
-	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
-	if (host->carddetect) {
+	if (carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
 		mmc_host_enable(host->mmc);
@@ -785,6 +789,8 @@ static irqreturn_t omap_mmc_cd_handler(i
 {
 	struct mmc_omap_host *host = (struct mmc_omap_host *)dev_id;
 
+	if (host->suspended)
+		return IRQ_HANDLED;
 	schedule_work(&host->mmc_carddetect_work);
 
 	return IRQ_HANDLED;
@@ -1524,30 +1530,42 @@ static int omap_mmc_suspend(struct platf
 		return 0;
 
 	if (host) {
+		host->suspended = 1;
+		if (host->pdata->suspend) {
+			ret = host->pdata->suspend(&pdev->dev,
+							host->slot_id);
+			if (ret) {
+				dev_dbg(mmc_dev(host->mmc),
+					"Unable to handle MMC board"
+					" level suspend\n");
+				host->suspended = 0;
+				return ret;
+			}
+		}
+		cancel_work_sync(&host->mmc_carddetect_work);
 		mmc_host_enable(host->mmc);
 		ret = mmc_suspend_host(host->mmc, state);
 		if (ret == 0) {
-			host->suspended = 1;
-
 			OMAP_HSMMC_WRITE(host->base, ISE, 0);
 			OMAP_HSMMC_WRITE(host->base, IE, 0);
 
-			if (host->pdata->suspend) {
-				ret = host->pdata->suspend(&pdev->dev,
-								host->slot_id);
-				if (ret)
-					dev_dbg(mmc_dev(host->mmc),
-						"Unable to handle MMC board"
-						" level suspend\n");
-			}
 
 			OMAP_HSMMC_WRITE(host->base, HCTL,
 					 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
 			clk_disable(host->dbclk);
-		} else
+		} else {
+			host->suspended = 0;
+			if (host->pdata->resume) {
+				ret = host->pdata->resume(&pdev->dev,
+							  host->slot_id);
+				if (ret)
+					dev_dbg(mmc_dev(host->mmc),
+						"Unmask interrupt failed\n");
+			}
 			mmc_host_disable(host->mmc);
+		}
 
 	}
 	return ret;
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
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

