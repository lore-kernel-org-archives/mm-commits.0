From: akpm@linux-foundation.org
Subject: - mmc-omap-clean-up-omap-set_ios-and-make-mmc_power_on.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:45 -0700
Message-ID: <200705031930.l43JUj8d018210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767907AbXECTfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: carlos.aguiar@indt.org.br, drzeus@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     MMC: OMAP: Clean up omap set_ios and make MMC_POWER_ON  work
has been removed from the -mm tree.  Its filename was
     mmc-omap-clean-up-omap-set_ios-and-make-mmc_power_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MMC: OMAP: Clean up omap set_ios and make MMC_POWER_ON  work
From: Carlos Aguiar <carlos.aguiar@indt.org.br>

Move divisor calculation into a separate function and re-arrange the init
order to make MMC_POWER_ON work.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   47 +++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-clean-up-omap-set_ios-and-make-mmc_power_on drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-clean-up-omap-set_ios-and-make-mmc_power_on
+++ a/drivers/mmc/host/omap.c
@@ -936,33 +936,41 @@ static void mmc_omap_power(struct mmc_om
 	}
 }
 
-static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+static int mmc_omap_calc_divisor(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
+	int func_clk_rate = clk_get_rate(host->fclk);
 	int dsor;
-	int realclock, i;
-
-	realclock = ios->clock;
 
 	if (ios->clock == 0)
-		dsor = 0;
-	else {
-		int func_clk_rate = clk_get_rate(host->fclk);
-
-		dsor = func_clk_rate / realclock;
-		if (dsor < 1)
-			dsor = 1;
+		return 0;
 
-		if (func_clk_rate / dsor > realclock)
-			dsor++;
+	dsor = func_clk_rate / ios->clock;
+	if (dsor < 1)
+		dsor = 1;
 
-		if (dsor > 250)
-			dsor = 250;
+	if (func_clk_rate / dsor > ios->clock)
 		dsor++;
 
-		if (ios->bus_width == MMC_BUS_WIDTH_4)
-			dsor |= 1 << 15;
-	}
+	if (dsor > 250)
+		dsor = 250;
+	dsor++;
+
+	if (ios->bus_width == MMC_BUS_WIDTH_4)
+		dsor |= 1 << 15;
+
+	return dsor;
+}
+
+static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+	int dsor;
+	int i;
+
+	dsor = mmc_omap_calc_divisor(mmc, ios);
+	host->bus_mode = ios->bus_mode;
+	host->hw_bus_mode = host->bus_mode;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
@@ -977,9 +985,6 @@ static void mmc_omap_set_ios(struct mmc_
 		break;
 	}
 
-	host->bus_mode = ios->bus_mode;
-	host->hw_bus_mode = host->bus_mode;
-
 	clk_enable(host->fclk);
 
 	/* On insanely high arm_per frequencies something sometimes
_

Patches currently in -mm which might be from carlos.aguiar@indt.org.br are
