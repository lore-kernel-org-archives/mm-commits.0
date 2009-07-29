From: akpm@linux-foundation.org
Subject: + omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:53 -0700
Message-ID: <200907292058.n6TKwrVJ009985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbZG2U7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: ensure all clock enables and disables are paired
has been added to the -mm tree.  Its filename is
     omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch

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
Subject: omap_hsmmc: ensure all clock enables and disables are paired
From: Adrian Hunter <adrian.hunter@nokia.com>

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

 drivers/mmc/host/omap_hsmmc.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -742,22 +742,24 @@ static int omap_hsmmc_switch_opcond(stru
 	/* Disable the clocks */
 	clk_disable(host->fclk);
 	clk_disable(host->iclk);
-	clk_disable(host->dbclk);
+	if (host->dbclk_enabled)
+		clk_disable(host->dbclk);
 
 	/* Turn the power off */
 	ret = mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
-	if (ret != 0)
-		goto err;
 
 	/* Turn the power ON with given VDD 1.8 or 3.0v */
-	ret = mmc_slot(host).set_power(host->dev, host->slot_id, 1, vdd);
+	if (!ret)
+		ret = mmc_slot(host).set_power(host->dev, host->slot_id, 1,
+					       vdd);
+	clk_enable(host->iclk);
+	if (host->dbclk_enabled)
+		clk_enable(host->dbclk);
+	clk_enable(host->fclk);
+
 	if (ret != 0)
 		goto err;
 
-	clk_enable(host->fclk);
-	clk_enable(host->iclk);
-	clk_enable(host->dbclk);
-
 	OMAP_HSMMC_WRITE(host->base, HCTL,
 		OMAP_HSMMC_READ(host->base, HCTL) & SDVSCLR);
 	reg_val = OMAP_HSMMC_READ(host->base, HCTL);
@@ -1908,7 +1910,8 @@ static int omap_hsmmc_suspend(struct pla
 				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
-			clk_disable(host->dbclk);
+			if (host->dbclk_enabled)
+				clk_disable(host->dbclk);
 		} else {
 			host->suspended = 0;
 			if (host->pdata->resume) {
@@ -1939,9 +1942,8 @@ static int omap_hsmmc_resume(struct plat
 		if (ret)
 			goto clk_en_err;
 
-		if (clk_enable(host->dbclk) != 0)
-			dev_dbg(mmc_dev(host->mmc),
-					"Enabling debounce clk failed\n");
+		if (host->dbclk_enabled)
+			clk_enable(host->dbclk);
 
 		if (mmc_host_enable(host->mmc) != 0) {
 			clk_disable(host->iclk);
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
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

