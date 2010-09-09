From: akpm@linux-foundation.org
Subject: + mmc-move-regulator-handling-closer-to-core-v4.patch added to -mm tree
Date: Thu, 09 Sep 2010 14:21:41 -0700
Message-ID: <201009092121.o89LLfWJ007170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab0IIVWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2010 17:22:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@stericsson.com, adrian.hunter@nokia.com, broonie@opensource.wolfsonmicro.com, cbrake@bec-systems.com, daniel@caiaq.de, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, lrg@slimlogic.co.uk, matt@console-pimps.org, pierre@ossman.eu, rmk+kernel@arm.linux.org.uk, robert.jarzmik@free.fr, sundar.iyer@stericsson.com, tony@atomide.com


The patch titled
     mmc-move-regulator-handling-closer-to-core-v4
has been added to the -mm tree.  Its filename is
     mmc-move-regulator-handling-closer-to-core-v4.patch

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
Subject: mmc-move-regulator-handling-closer-to-core-v4
From: Linus Walleij <linus.walleij@stericsson.com>

Propagate errors from regulator_set_ocr() properly in the
pxamci and mmci drivers, as far as is possible until we hit the
fact that mmc_set_ios() returns void and cannot handle error
codes.

Switched a pr_debug() in the PXA driver to a dev_dbg() as well
because it was disturbing to see it.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
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

 drivers/mmc/host/mmci.c   |   13 ++++++++++++-
 drivers/mmc/host/pxamci.c |   31 +++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/host/mmci.c~mmc-move-regulator-handling-closer-to-core-v4 drivers/mmc/host/mmci.c
--- a/drivers/mmc/host/mmci.c~mmc-move-regulator-handling-closer-to-core-v4
+++ a/drivers/mmc/host/mmci.c
@@ -531,8 +531,19 @@ static void mmci_set_ios(struct mmc_host
 			ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);
 		break;
 	case MMC_POWER_UP:
-		if (host->vcc)
+		if (host->vcc) {
 			ret = mmc_regulator_set_ocr(mmc, host->vcc, ios->vdd);
+			if (ret) {
+				dev_err(mmc_dev(mmc), "unable to set OCR\n");
+				/*
+				 * The .set_ios() function in the mmc_host_ops
+				 * struct return void, and failing to set the
+				 * power should be rare so we print an error
+				 * and return here.
+				 */
+				return;
+			}
+		}
 		if (host->plat->vdd_handler)
 			pwr |= host->plat->vdd_handler(mmc_dev(mmc), ios->vdd,
 						       ios->power_mode);
diff -puN drivers/mmc/host/pxamci.c~mmc-move-regulator-handling-closer-to-core-v4 drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~mmc-move-regulator-handling-closer-to-core-v4
+++ a/drivers/mmc/host/pxamci.c
@@ -99,7 +99,7 @@ static inline void pxamci_init_ocr(struc
 	}
 }
 
-static inline void pxamci_set_power(struct pxamci_host *host,
+static inline int pxamci_set_power(struct pxamci_host *host,
 				    unsigned char power_mode,
 				    unsigned int vdd)
 {
@@ -108,10 +108,15 @@ static inline void pxamci_set_power(stru
 	if (host->vcc) {
 		int ret;
 
-		if (power_mode == MMC_POWER_UP)
+		if (power_mode == MMC_POWER_UP) {
 			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
-		else if (power_mode == MMC_POWER_OFF)
+			if (ret)
+				return ret;
+		} else if (power_mode == MMC_POWER_OFF) {
 			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
+			if (ret)
+				return ret;
+		}
 	}
 	if (!host->vcc && host->pdata &&
 	    gpio_is_valid(host->pdata->gpio_power)) {
@@ -121,6 +126,8 @@ static inline void pxamci_set_power(stru
 	}
 	if (!host->vcc && host->pdata && host->pdata->setpower)
 		host->pdata->setpower(mmc_dev(host->mmc), vdd);
+
+	return 0;
 }
 
 static void pxamci_stop_clock(struct pxamci_host *host)
@@ -496,9 +503,21 @@ static void pxamci_set_ios(struct mmc_ho
 	}
 
 	if (host->power_mode != ios->power_mode) {
+		int ret;
+
 		host->power_mode = ios->power_mode;
 
-		pxamci_set_power(host, ios->power_mode, ios->vdd);
+		ret = pxamci_set_power(host, ios->power_mode, ios->vdd);
+		if (ret) {
+			dev_err(mmc_dev(mmc), "unable to set power\n");
+			/*
+			 * The .set_ios() function in the mmc_host_ops
+			 * struct return void, and failing to set the
+			 * power should be rare so we print an error and
+			 * return here.
+			 */
+			return;
+		}
 
 		if (ios->power_mode == MMC_POWER_ON)
 			host->cmdat |= CMDAT_INIT;
@@ -509,8 +528,8 @@ static void pxamci_set_ios(struct mmc_ho
 	else
 		host->cmdat &= ~CMDAT_SD_4DAT;
 
-	pr_debug("PXAMCI: clkrt = %x cmdat = %x\n",
-		 host->clkrt, host->cmdat);
+	dev_dbg(mmc_dev(mmc), "PXAMCI: clkrt = %x cmdat = %x\n",
+		host->clkrt, host->cmdat);
 }
 
 static void pxamci_enable_sdio_irq(struct mmc_host *host, int enable)
_

Patches currently in -mm which might be from linus.walleij@stericsson.com are

linux-next.patch
rtc-do-not-mark-pl031-irq-as-shared.patch
mmc-mmc-44-ddr-support.patch
mmc-move-regulator-handling-closer-to-core-v3.patch
mmc-move-regulator-handling-closer-to-core-v4.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
checkpatch-check-for-incorrect-permissions.patch

