From: akpm@linux-foundation.org
Subject: + omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:42:53 -0700
Message-ID: <200908202142.n7KLgrwU011970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZHTVnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: madhu.cr@ti.com, adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: fix for the db clock failure message
has been added to the -mm tree.  Its filename is
     omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message.patch

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
Subject: omap_hsmmc: fix for the db clock failure message
From: "Madhusudhan Chikkature" <madhu.cr@ti.com>

Remove the error message "Failed to get debounce clock.." printed out by
the MMC driver on OMAP3430.  The debounce clock needs to be handled only
for OMAP2430.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   46 +++++++++++++++++---------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -162,7 +162,7 @@ struct omap_hsmmc_host {
 	int			use_dma, dma_ch;
 	int			dma_line_tx, dma_line_rx;
 	int			slot_id;
-	int			dbclk_enabled;
+	int			got_dbclk;
 	int			response_busy;
 	int			context_loss;
 	int			dpm_state;
@@ -742,7 +742,7 @@ static int omap_hsmmc_switch_opcond(stru
 	/* Disable the clocks */
 	clk_disable(host->fclk);
 	clk_disable(host->iclk);
-	if (host->dbclk_enabled)
+	if (host->got_dbclk)
 		clk_disable(host->dbclk);
 
 	/* Turn the power off */
@@ -753,9 +753,9 @@ static int omap_hsmmc_switch_opcond(stru
 		ret = mmc_slot(host).set_power(host->dev, host->slot_id, 1,
 					       vdd);
 	clk_enable(host->iclk);
-	if (host->dbclk_enabled)
-		clk_enable(host->dbclk);
 	clk_enable(host->fclk);
+	if (host->got_dbclk)
+		clk_enable(host->dbclk);
 
 	if (ret != 0)
 		goto err;
@@ -1697,18 +1697,22 @@ static int __init omap_hsmmc_probe(struc
 		goto err1;
 	}
 
-	host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
-	/*
-	 * MMC can still work without debounce clock.
-	 */
-	if (IS_ERR(host->dbclk))
-		dev_warn(mmc_dev(host->mmc), "Failed to get debounce clock\n");
-	else
-		if (clk_enable(host->dbclk) != 0)
-			dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
-							" clk failed\n");
+	if (cpu_is_omap2430()) {
+		host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
+		/*
+		 * MMC can still work without debounce clock.
+		 */
+		if (IS_ERR(host->dbclk))
+			dev_warn(mmc_dev(host->mmc),
+				"Failed to get debounce clock\n");
 		else
-			host->dbclk_enabled = 1;
+			host->got_dbclk = 1;
+
+		if (host->got_dbclk)
+			if (clk_enable(host->dbclk) != 0)
+				dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
+							" clk failed\n");
+	}
 
 	/* Since we do only SG emulation, we can have as many segs
 	 * as we want. */
@@ -1825,7 +1829,7 @@ err_irq:
 	clk_disable(host->iclk);
 	clk_put(host->fclk);
 	clk_put(host->iclk);
-	if (host->dbclk_enabled) {
+	if (host->got_dbclk) {
 		clk_disable(host->dbclk);
 		clk_put(host->dbclk);
 	}
@@ -1859,7 +1863,7 @@ static int omap_hsmmc_remove(struct plat
 		clk_disable(host->iclk);
 		clk_put(host->fclk);
 		clk_put(host->iclk);
-		if (host->dbclk_enabled) {
+		if (host->got_dbclk) {
 			clk_disable(host->dbclk);
 			clk_put(host->dbclk);
 		}
@@ -1910,7 +1914,7 @@ static int omap_hsmmc_suspend(struct pla
 				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
-			if (host->dbclk_enabled)
+			if (host->got_dbclk)
 				clk_disable(host->dbclk);
 		} else {
 			host->suspended = 0;
@@ -1942,14 +1946,14 @@ static int omap_hsmmc_resume(struct plat
 		if (ret)
 			goto clk_en_err;
 
-		if (host->dbclk_enabled)
-			clk_enable(host->dbclk);
-
 		if (mmc_host_enable(host->mmc) != 0) {
 			clk_disable(host->iclk);
 			goto clk_en_err;
 		}
 
+		if (host->got_dbclk)
+			clk_enable(host->dbclk);
+
 		omap_hsmmc_conf_bus_power(host);
 
 		if (host->pdata->resume) {
_

Patches currently in -mm which might be from madhu.cr@ti.com are

linux-next.patch
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
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

