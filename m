From: akpm@linux-foundation.org
Subject: [merged] arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:54:57 -0700
Message-ID: <200909231954.n8NJsvQm001788__13131.2272082598$1253736626$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbZIWUKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     ARM: OMAP: mmc-twl4030: add regulator sleep / wake function
has been removed from the -mm tree.  Its filename was
     arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ARM: OMAP: mmc-twl4030: add regulator sleep / wake function
From: Adrian Hunter <adrian.hunter@nokia.com>

Add the ability for the driver to put the card power regulators to sleep
and wake them up again.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/mmc-twl4030.c     |   57 ++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/mmc.h |    2 
 2 files changed, 59 insertions(+)

diff -puN arch/arm/mach-omap2/mmc-twl4030.c~arm-omap-mmc-twl4030-add-regulator-sleep-wake-function arch/arm/mach-omap2/mmc-twl4030.c
--- a/arch/arm/mach-omap2/mmc-twl4030.c~arm-omap-mmc-twl4030-add-regulator-sleep-wake-function
+++ a/arch/arm/mach-omap2/mmc-twl4030.c
@@ -340,6 +340,61 @@ static int twl_mmc23_set_power(struct de
 	return ret;
 }
 
+static int twl_mmc1_set_sleep(struct device *dev, int slot, int sleep, int vdd,
+			      int cardsleep)
+{
+	struct twl_mmc_controller *c = &hsmmc[0];
+	int mode = sleep ? REGULATOR_MODE_STANDBY : REGULATOR_MODE_NORMAL;
+
+	return regulator_set_mode(c->vcc, mode);
+}
+
+static int twl_mmc23_set_sleep(struct device *dev, int slot, int sleep, int vdd,
+			       int cardsleep)
+{
+	struct twl_mmc_controller *c = NULL;
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+	int i, err, mode;
+
+	for (i = 1; i < ARRAY_SIZE(hsmmc); i++) {
+		if (mmc == hsmmc[i].mmc) {
+			c = &hsmmc[i];
+			break;
+		}
+	}
+
+	if (c == NULL)
+		return -ENODEV;
+
+	/*
+	 * If we don't see a Vcc regulator, assume it's a fixed
+	 * voltage always-on regulator.
+	 */
+	if (!c->vcc)
+		return 0;
+
+	mode = sleep ? REGULATOR_MODE_STANDBY : REGULATOR_MODE_NORMAL;
+
+	if (!c->vcc_aux)
+		return regulator_set_mode(c->vcc, mode);
+
+	if (cardsleep) {
+		/* VCC can be turned off if card is asleep */
+		struct regulator *vcc_aux = c->vcc_aux;
+
+		c->vcc_aux = NULL;
+		if (sleep)
+			err = twl_mmc23_set_power(dev, slot, 0, 0);
+		else
+			err = twl_mmc23_set_power(dev, slot, 1, vdd);
+		c->vcc_aux = vcc_aux;
+	} else
+		err = regulator_set_mode(c->vcc, mode);
+	if (err)
+		return err;
+	return regulator_set_mode(c->vcc_aux, mode);
+}
+
 static struct omap_mmc_platform_data *hsmmc_data[OMAP34XX_NR_MMC] __initdata;
 
 void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
@@ -433,6 +488,7 @@ void __init twl4030_mmc_init(struct twl4
 		case 1:
 			/* on-chip level shifting via PBIAS0/PBIAS1 */
 			mmc->slots[0].set_power = twl_mmc1_set_power;
+			mmc->slots[0].set_sleep = twl_mmc1_set_sleep;
 			break;
 		case 2:
 			if (c->ext_clock)
@@ -443,6 +499,7 @@ void __init twl4030_mmc_init(struct twl4
 		case 3:
 			/* off-chip level shifting, or none */
 			mmc->slots[0].set_power = twl_mmc23_set_power;
+			mmc->slots[0].set_sleep = twl_mmc23_set_sleep;
 			break;
 		default:
 			pr_err("MMC%d configuration not supported!\n", c->mmc);
diff -puN arch/arm/plat-omap/include/mach/mmc.h~arm-omap-mmc-twl4030-add-regulator-sleep-wake-function arch/arm/plat-omap/include/mach/mmc.h
--- a/arch/arm/plat-omap/include/mach/mmc.h~arm-omap-mmc-twl4030-add-regulator-sleep-wake-function
+++ a/arch/arm/plat-omap/include/mach/mmc.h
@@ -95,6 +95,8 @@ struct omap_mmc_platform_data {
 		int (* set_bus_mode)(struct device *dev, int slot, int bus_mode);
 		int (* set_power)(struct device *dev, int slot, int power_on, int vdd);
 		int (* get_ro)(struct device *dev, int slot);
+		int (*set_sleep)(struct device *dev, int slot, int sleep,
+				 int vdd, int cardsleep);
 
 		/* return MMC cover switch state, can be NULL if not supported.
 		 *
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch

