From: akpm@linux-foundation.org
Subject: + omap_hsmmc-put-mmc-regulator-to-sleep.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:32 -0700
Message-ID: <200907292058.n6TKwXv5009397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZG2U6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: put MMC regulator to sleep
has been added to the -mm tree.  Its filename is
     omap_hsmmc-put-mmc-regulator-to-sleep.patch

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
Subject: omap_hsmmc: put MMC regulator to sleep
From: Adrian Hunter <adrian.hunter@nokia.com>

When a card is not in use, the voltage regulator can be put to sleep. 
This is an alternative to powering the card off, when powering off is not
safe because the card might be replaced without the driver being aware of
it.

That situation happens if:
	- the card is removable i.e. not eMMC
	- and there is no card detect
	- and there is a cover switch but the cover is open

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

 drivers/mmc/host/omap_hsmmc.c |   59 +++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-put-mmc-regulator-to-sleep drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-put-mmc-regulator-to-sleep
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -162,6 +162,7 @@ struct mmc_omap_host {
 	int			response_busy;
 	int			context_loss;
 	int			dpm_state;
+	int			vdd;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -1038,10 +1039,12 @@ static void omap_mmc_set_ios(struct mmc_
 		case MMC_POWER_OFF:
 			mmc_slot(host).set_power(host->dev, host->slot_id,
 						 0, 0);
+			host->vdd = 0;
 			break;
 		case MMC_POWER_UP:
 			mmc_slot(host).set_power(host->dev, host->slot_id,
 						 1, ios->vdd);
+			host->vdd = ios->vdd;
 			break;
 		case MMC_POWER_ON:
 			do_send_init_stream = 1;
@@ -1179,19 +1182,20 @@ static void omap_hsmmc_init(struct mmc_o
 
 /*
  * Dynamic power saving handling, FSM:
- *   ENABLED -> DISABLED -> OFF
+ *   ENABLED -> DISABLED -> OFF / REGSLEEP
  *     ^___________|          |
  *     |______________________|
  *
  * ENABLED:   mmc host is fully functional
  * DISABLED:  fclk is off
  * OFF:       fclk is off,voltage regulator is off
+ * REGSLEEP:  fclk is off,voltage regulator is asleep
  *
  * Transition handlers return the timeout for the next state transition
  * or negative error.
  */
 
-enum {ENABLED = 0, DISABLED, OFF};
+enum {ENABLED = 0, DISABLED, REGSLEEP, OFF};
 
 /* Handler for [ENABLED -> DISABLED] transition */
 static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
@@ -1228,8 +1232,12 @@ static int omap_mmc_disabled_to_off(stru
 	     mmc_slot(host).get_cover_state(host->dev, host->slot_id))) {
 		mmc_power_save_host(host->mmc);
 		new_state = OFF;
-	} else
-		new_state = DISABLED;
+	} else {
+		if (mmc_slot(host).set_sleep)
+			mmc_slot(host).set_sleep(host->dev, host->slot_id,
+						 1, 0, 0);
+		new_state = REGSLEEP;
+	}
 
 	OMAP_HSMMC_WRITE(host->base, ISE, 0);
 	OMAP_HSMMC_WRITE(host->base, IE, 0);
@@ -1286,6 +1294,44 @@ static int omap_mmc_off_to_enabled(struc
 	return 0;
 }
 
+/* Handler for [REGSLEEP -> ENABLED] transition */
+static int omap_mmc_regsleep_to_enabled(struct mmc_omap_host *host)
+{
+	unsigned long timeout;
+
+	dev_dbg(mmc_dev(host->mmc), "REGSLEEP -> ENABLED\n");
+
+	clk_enable(host->fclk);
+	clk_enable(host->iclk);
+
+	if (clk_enable(host->dbclk))
+		dev_dbg(mmc_dev(host->mmc),
+			"Enabling debounce clk failed\n");
+
+	omap_mmc_restore_ctx(host);
+
+	/*
+	 * We turned off interrupts and bus power.  Interrupts
+	 * are turned on by 'mmc_omap_start_command()' so we
+	 * just need to turn on the bus power here.
+	 */
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+
+	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP &&
+	       time_before(jiffies, timeout))
+		;
+
+	if (mmc_slot(host).set_sleep)
+		mmc_slot(host).set_sleep(host->dev, host->slot_id,
+					 0, host->vdd, 0);
+
+	host->dpm_state = ENABLED;
+
+	return 0;
+}
+
 /*
  * Bring MMC host to ENABLED from any other PM state.
  */
@@ -1296,6 +1342,8 @@ static int omap_mmc_enable(struct mmc_ho
 	switch (host->dpm_state) {
 	case DISABLED:
 		return omap_mmc_disabled_to_enabled(host);
+	case REGSLEEP:
+		return omap_mmc_regsleep_to_enabled(host);
 	case OFF:
 		return omap_mmc_off_to_enabled(host);
 	default:
@@ -1393,7 +1441,8 @@ static int mmc_regs_show(struct seq_file
 			host->dpm_state, mmc->nesting_cnt,
 			host->context_loss, context_loss);
 
-	if (host->suspended || host->dpm_state == OFF) {
+	if (host->suspended || host->dpm_state == OFF ||
+	    host->dpm_state == REGSLEEP) {
 		seq_printf(s, "host suspended, can't read registers\n");
 		return 0;
 	}
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

