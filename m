From: akpm@linux-foundation.org
Subject: + omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:55:08 -0700
Message-ID: <200907242255.n6OMt8rx031813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbZGXWzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: add mmc card sleep and awake support
has been added to the -mm tree.  Its filename is
     omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch

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
Subject: omap_hsmmc: add mmc card sleep and awake support
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

After 1 second of inactivity, put card and/or regulator to sleep.  After 8
seconds of inactivity, turn off the power.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |  162 +++++++++++++++++---------------
 1 file changed, 88 insertions(+), 74 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-mmc-card-sleep-and-awake-support drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-mmc-card-sleep-and-awake-support
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -27,6 +27,7 @@
 #include <linux/timer.h>
 #include <linux/clk.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/core.h>
 #include <linux/io.h>
 #include <linux/semaphore.h>
 #include <mach/dma.h>
@@ -115,7 +116,8 @@
 
 /* Timeouts for entering power saving states on inactivity, msec */
 #define OMAP_MMC_DISABLED_TIMEOUT	100
-#define OMAP_MMC_OFF_TIMEOUT		1000
+#define OMAP_MMC_SLEEP_TIMEOUT		1000
+#define OMAP_MMC_OFF_TIMEOUT		8000
 
 /*
  * One controller can have multiple slots, like on some omap boards using
@@ -1182,20 +1184,21 @@ static void omap_hsmmc_init(struct mmc_o
 
 /*
  * Dynamic power saving handling, FSM:
- *   ENABLED -> DISABLED -> OFF / REGSLEEP
- *     ^___________|          |
- *     |______________________|
+ *   ENABLED -> DISABLED -> CARDSLEEP / REGSLEEP -> OFF
+ *     ^___________|          |                      |
+ *     |______________________|______________________|
  *
  * ENABLED:   mmc host is fully functional
  * DISABLED:  fclk is off
- * OFF:       fclk is off,voltage regulator is off
- * REGSLEEP:  fclk is off,voltage regulator is asleep
+ * CARDSLEEP: fclk is off, card is asleep, voltage regulator is asleep
+ * REGSLEEP:  fclk is off, voltage regulator is asleep
+ * OFF:       fclk is off, voltage regulator is off
  *
  * Transition handlers return the timeout for the next state transition
  * or negative error.
  */
 
-enum {ENABLED = 0, DISABLED, REGSLEEP, OFF};
+enum {ENABLED = 0, DISABLED, CARDSLEEP, REGSLEEP, OFF};
 
 /* Handler for [ENABLED -> DISABLED] transition */
 static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
@@ -1209,46 +1212,72 @@ static int omap_mmc_enabled_to_disabled(
 	if (host->power_mode == MMC_POWER_OFF)
 		return 0;
 
-	return msecs_to_jiffies(OMAP_MMC_OFF_TIMEOUT);
+	return msecs_to_jiffies(OMAP_MMC_SLEEP_TIMEOUT);
 }
 
-/* Handler for [DISABLED -> OFF] transition */
-static int omap_mmc_disabled_to_off(struct mmc_omap_host *host)
+/* Handler for [DISABLED -> REGSLEEP / CARDSLEEP] transition */
+static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
 {
-	int new_state;
-
-	dev_dbg(mmc_dev(host->mmc), "DISABLED -> OFF\n");
+	int err, new_state;
 
 	if (!mmc_try_claim_host(host->mmc))
 		return 0;
 
 	clk_enable(host->fclk);
-
 	omap_mmc_restore_ctx(host);
+	if (mmc_card_can_sleep(host->mmc)) {
+		err = mmc_card_sleep(host->mmc);
+		if (err < 0) {
+			clk_disable(host->fclk);
+			mmc_release_host(host->mmc);
+			return err;
+		}
+		new_state = CARDSLEEP;
+	} else
+		new_state = REGSLEEP;
+	if (mmc_slot(host).set_sleep)
+		mmc_slot(host).set_sleep(host->dev, host->slot_id, 1, 0,
+					 new_state == CARDSLEEP);
+	/* FIXME: turn off bus power and perhaps interrupts too */
+	clk_disable(host->fclk);
+	host->dpm_state = new_state;
+
+	mmc_release_host(host->mmc);
+
+	dev_dbg(mmc_dev(host->mmc), "DISABLED -> %s\n",
+		host->dpm_state == CARDSLEEP ? "CARDSLEEP" : "REGSLEEP");
 
 	if ((host->mmc->caps & MMC_CAP_NONREMOVABLE) ||
 	    mmc_slot(host).card_detect ||
 	    (mmc_slot(host).get_cover_state &&
-	     mmc_slot(host).get_cover_state(host->dev, host->slot_id))) {
-		mmc_power_save_host(host->mmc);
-		new_state = OFF;
-	} else {
-		if (mmc_slot(host).set_sleep)
-			mmc_slot(host).set_sleep(host->dev, host->slot_id,
-						 1, 0, 0);
-		new_state = REGSLEEP;
+	     mmc_slot(host).get_cover_state(host->dev, host->slot_id)))
+		return msecs_to_jiffies(OMAP_MMC_OFF_TIMEOUT);
+
+	return 0;
+}
+
+/* Handler for [REGSLEEP / CARDSLEEP -> OFF] transition */
+static int omap_mmc_sleep_to_off(struct mmc_omap_host *host)
+{
+	if (!mmc_try_claim_host(host->mmc))
+		return 0;
+
+	if (!((host->mmc->caps & MMC_CAP_NONREMOVABLE) ||
+	      mmc_slot(host).card_detect ||
+	      (mmc_slot(host).get_cover_state &&
+	       mmc_slot(host).get_cover_state(host->dev, host->slot_id)))) {
+		mmc_release_host(host->mmc);
+		return 0;
 	}
 
-	OMAP_HSMMC_WRITE(host->base, ISE, 0);
-	OMAP_HSMMC_WRITE(host->base, IE, 0);
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-		 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+	mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
+	host->vdd = 0;
+	host->power_mode = MMC_POWER_OFF;
 
-	clk_disable(host->fclk);
-	clk_disable(host->iclk);
-	clk_disable(host->dbclk);
+	dev_dbg(mmc_dev(host->mmc), "%s -> OFF\n",
+		host->dpm_state == CARDSLEEP ? "CARDSLEEP" : "REGSLEEP");
 
-	host->dpm_state = new_state;
+	host->dpm_state = OFF;
 
 	mmc_release_host(host->mmc);
 
@@ -1273,62 +1302,43 @@ static int omap_mmc_disabled_to_enabled(
 	return 0;
 }
 
-/* Handler for [OFF -> ENABLED] transition */
-static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
+/* Handler for [SLEEP -> ENABLED] transition */
+static int omap_mmc_sleep_to_enabled(struct mmc_omap_host *host)
 {
-	clk_enable(host->fclk);
-	clk_enable(host->iclk);
-
-	if (clk_enable(host->dbclk))
-		dev_dbg(mmc_dev(host->mmc),
-			"Enabling debounce clk failed\n");
+	if (!mmc_try_claim_host(host->mmc))
+		return 0;
 
+	clk_enable(host->fclk);
 	omap_mmc_restore_ctx(host);
-	omap_hsmmc_init(host);
-	mmc_power_restore_host(host->mmc);
+	if (mmc_slot(host).set_sleep)
+		mmc_slot(host).set_sleep(host->dev, host->slot_id, 0,
+			 host->vdd, host->dpm_state == CARDSLEEP);
+	if (mmc_card_can_sleep(host->mmc))
+		mmc_card_awake(host->mmc);
+
+	dev_dbg(mmc_dev(host->mmc), "%s -> ENABLED\n",
+		host->dpm_state == CARDSLEEP ? "CARDSLEEP" : "REGSLEEP");
 
 	host->dpm_state = ENABLED;
 
-	dev_dbg(mmc_dev(host->mmc), "OFF -> ENABLED\n");
+	mmc_release_host(host->mmc);
 
 	return 0;
 }
 
-/* Handler for [REGSLEEP -> ENABLED] transition */
-static int omap_mmc_regsleep_to_enabled(struct mmc_omap_host *host)
+/* Handler for [OFF -> ENABLED] transition */
+static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
 {
-	unsigned long timeout;
-
-	dev_dbg(mmc_dev(host->mmc), "REGSLEEP -> ENABLED\n");
-
 	clk_enable(host->fclk);
-	clk_enable(host->iclk);
-
-	if (clk_enable(host->dbclk))
-		dev_dbg(mmc_dev(host->mmc),
-			"Enabling debounce clk failed\n");
 
 	omap_mmc_restore_ctx(host);
-
-	/*
-	 * We turned off interrupts and bus power.  Interrupts
-	 * are turned on by 'mmc_omap_start_command()' so we
-	 * just need to turn on the bus power here.
-	 */
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
-
-	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP &&
-	       time_before(jiffies, timeout))
-		;
-
-	if (mmc_slot(host).set_sleep)
-		mmc_slot(host).set_sleep(host->dev, host->slot_id,
-					 0, host->vdd, 0);
+	omap_hsmmc_init(host);
+	mmc_power_restore_host(host->mmc);
 
 	host->dpm_state = ENABLED;
 
+	dev_dbg(mmc_dev(host->mmc), "OFF -> ENABLED\n");
+
 	return 0;
 }
 
@@ -1342,8 +1352,9 @@ static int omap_mmc_enable(struct mmc_ho
 	switch (host->dpm_state) {
 	case DISABLED:
 		return omap_mmc_disabled_to_enabled(host);
+	case CARDSLEEP:
 	case REGSLEEP:
-		return omap_mmc_regsleep_to_enabled(host);
+		return omap_mmc_sleep_to_enabled(host);
 	case OFF:
 		return omap_mmc_off_to_enabled(host);
 	default:
@@ -1369,7 +1380,10 @@ static int omap_mmc_disable(struct mmc_h
 		return 0;
 	}
 	case DISABLED:
-		return omap_mmc_disabled_to_off(host);
+		return omap_mmc_disabled_to_sleep(host);
+	case CARDSLEEP:
+	case REGSLEEP:
+		return omap_mmc_sleep_to_off(host);
 	default:
 		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
 		return -EINVAL;
@@ -1441,8 +1455,7 @@ static int mmc_regs_show(struct seq_file
 			host->dpm_state, mmc->nesting_cnt,
 			host->context_loss, context_loss);
 
-	if (host->suspended || host->dpm_state == OFF ||
-	    host->dpm_state == REGSLEEP) {
+	if (host->suspended || host->dpm_state == OFF) {
 		seq_printf(s, "host suspended, can't read registers\n");
 		return 0;
 	}
@@ -1617,7 +1630,8 @@ static int __init omap_mmc_probe(struct 
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
 	mmc->max_seg_size = mmc->max_req_size;
 
-	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED;
+	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
+		     MMC_CAP_WAIT_WHILE_BUSY;
 
 	if (pdata->slots[host->slot_id].wires >= 8)
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

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

