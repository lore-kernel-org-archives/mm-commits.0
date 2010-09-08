From: akpm@linux-foundation.org
Subject: + mmc-move-regulator-handling-closer-to-core-v3.patch added to -mm tree
Date: Wed, 08 Sep 2010 15:51:29 -0700
Message-ID: <201009082251.o88MpT2k014481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606Ab0IHWxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 18:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@stericsson.com, adrian.hunter@nokia.com, broonie@opensource.wolfsonmicro.com, cbrake@bec-systems.com, daniel@caiaq.de, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, lrg@slimlogic.co.uk, matt@console-pimps.org, pierre@ossman.eu, rmk+kernel@arm.linux.org.uk, robert.jarzmik@free.fr, sundar.iyer@stericsson.com, tony@atomide.com


The patch titled
     mmc: move regulator handling closer to core
has been added to the -mm tree.  Its filename is
     mmc-move-regulator-handling-closer-to-core-v3.patch

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
Subject: mmc: move regulator handling closer to core
From: Linus Walleij <linus.walleij@stericsson.com>

After discovering a problem in regulator reference counting I took Mark
Brown's advice to move the reference count into the MMC core by making the
regulator status a member of struct mmc_host.

I took this opportunity to also implement NULL versions of
the regulator functions so as to rid the driver code from
some ugly #ifdef CONFIG_REGULATOR clauses.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Cliff Brake <cbrake@bec-systems.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c       |   26 ++++++++++++++++----------
 drivers/mmc/host/mmci.c       |   15 ++++++---------
 drivers/mmc/host/omap_hsmmc.c |   21 +++++++++++++--------
 drivers/mmc/host/pxamci.c     |   18 ++++++++++++------
 include/linux/mmc/host.h      |   22 +++++++++++++++++++++-
 5 files changed, 68 insertions(+), 34 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-move-regulator-handling-closer-to-core-v3 drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-move-regulator-handling-closer-to-core-v3
+++ a/drivers/mmc/core/core.c
@@ -771,8 +771,9 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask)
 
 /**
  * mmc_regulator_set_ocr - set regulator to match host->ios voltage
- * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
+ * @mmc: the host to regulate
  * @supply: regulator to use
+ * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
  *
  * Returns zero on success, else negative errno.
  *
@@ -780,15 +781,12 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask)
  * a particular supply voltage.  This would normally be called from the
  * set_ios() method.
  */
-int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
+int mmc_regulator_set_ocr(struct mmc_host *mmc,
+			struct regulator *supply,
+			unsigned short vdd_bit)
 {
 	int			result = 0;
 	int			min_uV, max_uV;
-	int			enabled;
-
-	enabled = regulator_is_enabled(supply);
-	if (enabled < 0)
-		return enabled;
 
 	if (vdd_bit) {
 		int		tmp;
@@ -819,17 +817,25 @@ int mmc_regulator_set_ocr(struct regulat
 		else
 			result = 0;
 
-		if (result == 0 && !enabled)
+		if (result == 0 && !mmc->regulator_enabled) {
 			result = regulator_enable(supply);
-	} else if (enabled) {
+			if (!result)
+				mmc->regulator_enabled = true;
+		}
+	} else if (mmc->regulator_enabled) {
 		result = regulator_disable(supply);
+		if (result == 0)
+			mmc->regulator_enabled = false;
 	}
 
+	if (result)
+		dev_err(mmc_dev(mmc),
+			"could not set regulator OCR (%d)\n", result);
 	return result;
 }
 EXPORT_SYMBOL(mmc_regulator_set_ocr);
 
-#endif
+#endif /* CONFIG_REGULATOR */
 
 /*
  * Mask off any voltages we don't support and select
diff -puN drivers/mmc/host/mmci.c~mmc-move-regulator-handling-closer-to-core-v3 drivers/mmc/host/mmci.c
--- a/drivers/mmc/host/mmci.c~mmc-move-regulator-handling-closer-to-core-v3
+++ a/drivers/mmc/host/mmci.c
@@ -523,19 +523,16 @@ static void mmci_set_ios(struct mmc_host
 	struct mmci_host *host = mmc_priv(mmc);
 	u32 pwr = 0;
 	unsigned long flags;
+	int ret;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		if(host->vcc &&
-		   regulator_is_enabled(host->vcc))
-			regulator_disable(host->vcc);
+		if (host->vcc)
+			ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);
 		break;
 	case MMC_POWER_UP:
-#ifdef CONFIG_REGULATOR
 		if (host->vcc)
-			/* This implicitly enables the regulator */
-			mmc_regulator_set_ocr(host->vcc, ios->vdd);
-#endif
+			ret = mmc_regulator_set_ocr(mmc, host->vcc, ios->vdd);
 		if (host->plat->vdd_handler)
 			pwr |= host->plat->vdd_handler(mmc_dev(mmc), ios->vdd,
 						       ios->power_mode);
@@ -843,8 +840,8 @@ static int __devexit mmci_remove(struct 
 		clk_disable(host->clk);
 		clk_put(host->clk);
 
-		if (regulator_is_enabled(host->vcc))
-			regulator_disable(host->vcc);
+		if (host->vcc)
+			mmc_regulator_set_ocr(mmc, host->vcc, 0);
 		regulator_put(host->vcc);
 
 		mmc_free_host(mmc);
diff -puN drivers/mmc/host/omap_hsmmc.c~mmc-move-regulator-handling-closer-to-core-v3 drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~mmc-move-regulator-handling-closer-to-core-v3
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -250,9 +250,9 @@ static int omap_hsmmc_1_set_power(struct
 		mmc_slot(host).before_set_reg(dev, slot, power_on, vdd);
 
 	if (power_on)
-		ret = mmc_regulator_set_ocr(host->vcc, vdd);
+		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
 	else
-		ret = mmc_regulator_set_ocr(host->vcc, 0);
+		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
 
 	if (mmc_slot(host).after_set_reg)
 		mmc_slot(host).after_set_reg(dev, slot, power_on, vdd);
@@ -291,18 +291,23 @@ static int omap_hsmmc_23_set_power(struc
 	 * chips/cards need an interface voltage rail too.
 	 */
 	if (power_on) {
-		ret = mmc_regulator_set_ocr(host->vcc, vdd);
+		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
 		/* Enable interface voltage rail, if needed */
 		if (ret == 0 && host->vcc_aux) {
 			ret = regulator_enable(host->vcc_aux);
 			if (ret < 0)
-				ret = mmc_regulator_set_ocr(host->vcc, 0);
+				ret = mmc_regulator_set_ocr(host->mmc,
+							host->vcc, 0);
 		}
 	} else {
+		/* Shut down the rail */
 		if (host->vcc_aux)
 			ret = regulator_disable(host->vcc_aux);
-		if (ret == 0)
-			ret = mmc_regulator_set_ocr(host->vcc, 0);
+		if (!ret) {
+			/* Then proceed to shut down the local regulator */
+			ret = mmc_regulator_set_ocr(host->mmc,
+						host->vcc, 0);
+		}
 	}
 
 	if (mmc_slot(host).after_set_reg)
@@ -343,9 +348,9 @@ static int omap_hsmmc_23_set_sleep(struc
 	if (cardsleep) {
 		/* VCC can be turned off if card is asleep */
 		if (sleep)
-			err = mmc_regulator_set_ocr(host->vcc, 0);
+			err = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
 		else
-			err = mmc_regulator_set_ocr(host->vcc, vdd);
+			err = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
 	} else
 		err = regulator_set_mode(host->vcc, mode);
 	if (err)
diff -puN drivers/mmc/host/pxamci.c~mmc-move-regulator-handling-closer-to-core-v3 drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~mmc-move-regulator-handling-closer-to-core-v3
+++ a/drivers/mmc/host/pxamci.c
@@ -99,14 +99,20 @@ static inline void pxamci_init_ocr(struc
 	}
 }
 
-static inline void pxamci_set_power(struct pxamci_host *host, unsigned int vdd)
+static inline void pxamci_set_power(struct pxamci_host *host,
+				    unsigned char power_mode,
+				    unsigned int vdd)
 {
 	int on;
 
-#ifdef CONFIG_REGULATOR
-	if (host->vcc)
-		mmc_regulator_set_ocr(host->vcc, vdd);
-#endif
+	if (host->vcc) {
+		int ret;
+
+		if (power_mode == MMC_POWER_UP)
+			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
+		else if (power_mode == MMC_POWER_OFF)
+			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
+	}
 	if (!host->vcc && host->pdata &&
 	    gpio_is_valid(host->pdata->gpio_power)) {
 		on = ((1 << vdd) & host->pdata->ocr_mask);
@@ -492,7 +498,7 @@ static void pxamci_set_ios(struct mmc_ho
 	if (host->power_mode != ios->power_mode) {
 		host->power_mode = ios->power_mode;
 
-		pxamci_set_power(host, ios->vdd);
+		pxamci_set_power(host, ios->power_mode, ios->vdd);
 
 		if (ios->power_mode == MMC_POWER_ON)
 			host->cmdat |= CMDAT_INIT;
diff -puN include/linux/mmc/host.h~mmc-move-regulator-handling-closer-to-core-v3 include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-move-regulator-handling-closer-to-core-v3
+++ a/include/linux/mmc/host.h
@@ -217,6 +217,10 @@ struct mmc_host {
 	struct led_trigger	*led;		/* activity led */
 #endif
 
+#ifdef CONFIG_REGULATOR
+	bool			regulator_enabled; /* regulator state */
+#endif
+
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
@@ -255,8 +259,24 @@ static inline void mmc_signal_sdio_irq(s
 
 struct regulator;
 
+#ifdef CONFIG_REGULATOR
 int mmc_regulator_get_ocrmask(struct regulator *supply);
-int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
+int mmc_regulator_set_ocr(struct mmc_host *mmc,
+			struct regulator *supply,
+			unsigned short vdd_bit);
+#else
+int inline mmc_regulator_get_ocrmask(struct regulator *supply)
+{
+	return 0;
+}
+
+int inline mmc_regulator_set_ocr(struct mmc_host *mmc,
+				 struct regulator *supply,
+				 unsigned short vdd_bit)
+{
+	return 0;
+}
+#endif
 
 int mmc_card_awake(struct mmc_host *host);
 int mmc_card_sleep(struct mmc_host *host);
_

Patches currently in -mm which might be from linus.walleij@stericsson.com are

linux-next.patch
rtc-do-not-mark-pl031-irq-as-shared.patch
mmc-mmc-44-ddr-support.patch
mmc-move-regulator-handling-closer-to-core-v3.patch
checkpatch-check-for-incorrect-permissions.patch

