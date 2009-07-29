From: akpm@linux-foundation.org
Subject: [to-be-updated] omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:50:03 -0700
Message-ID: <200907292050.n6TKo3lK027963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbZG2Uuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     omap_hsmmc: ensure all clock enables and disables are paired
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: ensure all clock enables and disables are paired
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

 drivers/mmc/host/omap_hsmmc.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -734,22 +734,24 @@ static int omap_hsmmc_switch_opcond(stru
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
@@ -1895,7 +1897,8 @@ static int omap_hsmmc_suspend(struct pla
 				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
-			clk_disable(host->dbclk);
+			if (host->dbclk_enabled)
+				clk_disable(host->dbclk);
 		} else {
 			host->suspended = 0;
 			if (host->pdata->resume) {
@@ -1926,9 +1929,8 @@ static int omap_hsmmc_resume(struct plat
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
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

