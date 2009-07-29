From: akpm@linux-foundation.org
Subject: + omap_hsmmc-support-for-deeper-power-saving-states.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:27 -0700
Message-ID: <200907292058.n6TKwS7r009302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbZG2U6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: support for deeper power saving states
has been added to the -mm tree.  Its filename is
     omap_hsmmc-support-for-deeper-power-saving-states.patch

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
Subject: omap_hsmmc: support for deeper power saving states
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

Support for multi-level dynamic power saving states in omap_hsmmc
(ENABLED->DISABLED->OFF).  In the "deepest" state (OFF) we switch off the
voltage regulators.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
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

 arch/arm/mach-omap2/mmc-twl4030.c     |    3 
 arch/arm/mach-omap2/mmc-twl4030.h     |    1 
 arch/arm/plat-omap/include/mach/mmc.h |    3 
 drivers/mmc/host/omap_hsmmc.c         |  245 +++++++++++++++++++++---
 4 files changed, 222 insertions(+), 30 deletions(-)

diff -puN arch/arm/mach-omap2/mmc-twl4030.c~omap_hsmmc-support-for-deeper-power-saving-states arch/arm/mach-omap2/mmc-twl4030.c
--- a/arch/arm/mach-omap2/mmc-twl4030.c~omap_hsmmc-support-for-deeper-power-saving-states
+++ a/arch/arm/mach-omap2/mmc-twl4030.c
@@ -412,6 +412,9 @@ void __init twl4030_mmc_init(struct twl4
 		if (c->nonremovable)
 			mmc->slots[0].nonremovable = 1;
 
+		if (c->power_saving)
+			mmc->slots[0].power_saving = 1;
+
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
 		 * This may be from a TWL4030-family chip, another
 		 * controllable regulator, or a fixed supply.
diff -puN arch/arm/mach-omap2/mmc-twl4030.h~omap_hsmmc-support-for-deeper-power-saving-states arch/arm/mach-omap2/mmc-twl4030.h
--- a/arch/arm/mach-omap2/mmc-twl4030.h~omap_hsmmc-support-for-deeper-power-saving-states
+++ a/arch/arm/mach-omap2/mmc-twl4030.h
@@ -13,6 +13,7 @@ struct twl4030_hsmmc_info {
 	bool	ext_clock;	/* use external pin for input clock */
 	bool	cover_only;	/* No card detect - just cover switch */
 	bool	nonremovable;	/* Nonremovable e.g. eMMC */
+	bool	power_saving;	/* Try to sleep or power off when possible */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
 	char	*name;		/* or NULL for default */
diff -puN arch/arm/plat-omap/include/mach/mmc.h~omap_hsmmc-support-for-deeper-power-saving-states arch/arm/plat-omap/include/mach/mmc.h
--- a/arch/arm/plat-omap/include/mach/mmc.h~omap_hsmmc-support-for-deeper-power-saving-states
+++ a/arch/arm/plat-omap/include/mach/mmc.h
@@ -86,6 +86,9 @@ struct omap_mmc_platform_data {
 		/* nonremovable e.g. eMMC */
 		unsigned nonremovable:1;
 
+		/* Try to sleep or power off when possible */
+		unsigned power_saving:1;
+
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
 
diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-support-for-deeper-power-saving-states drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-support-for-deeper-power-saving-states
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -113,6 +113,10 @@
 #define OMAP_MMC_MASTER_CLOCK	96000000
 #define DRIVER_NAME		"mmci-omap-hs"
 
+/* Timeouts for entering power saving states on inactivity, msec */
+#define OMAP_MMC_DISABLED_TIMEOUT	100
+#define OMAP_MMC_OFF_TIMEOUT		1000
+
 /*
  * One controller can have multiple slots, like on some omap boards using
  * omap.c controller driver. Luckily this is not currently done on any known
@@ -157,6 +161,7 @@ struct mmc_omap_host {
 	int			dbclk_enabled;
 	int			response_busy;
 	int			context_loss;
+	int			dpm_state;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -992,29 +997,6 @@ mmc_omap_prepare_data(struct mmc_omap_ho
 	return 0;
 }
 
-static int omap_mmc_enable(struct mmc_host *mmc)
-{
-	struct mmc_omap_host *host = mmc_priv(mmc);
-	int err;
-
-	err = clk_enable(host->fclk);
-	if (err)
-		return err;
-	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
-	omap_mmc_restore_ctx(host);
-	return 0;
-}
-
-static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
-{
-	struct mmc_omap_host *host = mmc_priv(mmc);
-
-	omap_mmc_save_ctx(host);
-	clk_disable(host->fclk);
-	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
-	return 0;
-}
-
 /*
  * Request function. for read/write operation
  */
@@ -1068,6 +1050,8 @@ static void omap_mmc_set_ios(struct mmc_
 		host->power_mode = ios->power_mode;
 	}
 
+	/* FIXME: set registers based only on changes to ios */
+
 	con = OMAP_HSMMC_READ(host->base, CON);
 	switch (mmc->ios.bus_width) {
 	case MMC_BUS_WIDTH_8:
@@ -1140,7 +1124,10 @@ static void omap_mmc_set_ios(struct mmc_
 	else
 		OMAP_HSMMC_WRITE(host->base, CON, con & ~OD);
 
-	mmc_host_lazy_disable(host->mmc);
+	if (host->power_mode == MMC_POWER_OFF)
+		mmc_host_disable(host->mmc);
+	else
+		mmc_host_lazy_disable(host->mmc);
 }
 
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
@@ -1190,7 +1177,191 @@ static void omap_hsmmc_init(struct mmc_o
 	set_sd_bus_power(host);
 }
 
-static struct mmc_host_ops mmc_omap_ops = {
+/*
+ * Dynamic power saving handling, FSM:
+ *   ENABLED -> DISABLED -> OFF
+ *     ^___________|          |
+ *     |______________________|
+ *
+ * ENABLED:   mmc host is fully functional
+ * DISABLED:  fclk is off
+ * OFF:       fclk is off,voltage regulator is off
+ *
+ * Transition handlers return the timeout for the next state transition
+ * or negative error.
+ */
+
+enum {ENABLED = 0, DISABLED, OFF};
+
+/* Handler for [ENABLED -> DISABLED] transition */
+static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
+{
+	omap_mmc_save_ctx(host);
+	clk_disable(host->fclk);
+	host->dpm_state = DISABLED;
+
+	dev_dbg(mmc_dev(host->mmc), "ENABLED -> DISABLED\n");
+
+	if (host->power_mode == MMC_POWER_OFF)
+		return 0;
+
+	return msecs_to_jiffies(OMAP_MMC_OFF_TIMEOUT);
+}
+
+/* Handler for [DISABLED -> OFF] transition */
+static int omap_mmc_disabled_to_off(struct mmc_omap_host *host)
+{
+	int new_state;
+
+	dev_dbg(mmc_dev(host->mmc), "DISABLED -> OFF\n");
+
+	if (!mmc_try_claim_host(host->mmc))
+		return 0;
+
+	clk_enable(host->fclk);
+
+	omap_mmc_restore_ctx(host);
+
+	if ((host->mmc->caps & MMC_CAP_NONREMOVABLE) ||
+	    mmc_slot(host).card_detect ||
+	    (mmc_slot(host).get_cover_state &&
+	     mmc_slot(host).get_cover_state(host->dev, host->slot_id))) {
+		mmc_power_save_host(host->mmc);
+		new_state = OFF;
+	} else
+		new_state = DISABLED;
+
+	OMAP_HSMMC_WRITE(host->base, ISE, 0);
+	OMAP_HSMMC_WRITE(host->base, IE, 0);
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+		 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+
+	clk_disable(host->fclk);
+	clk_disable(host->iclk);
+	clk_disable(host->dbclk);
+
+	host->dpm_state = new_state;
+
+	mmc_release_host(host->mmc);
+
+	return 0;
+}
+
+/* Handler for [DISABLED -> ENABLED] transition */
+static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
+{
+	int err;
+
+	err = clk_enable(host->fclk);
+	if (err < 0)
+		return err;
+
+	omap_mmc_restore_ctx(host);
+
+	host->dpm_state = ENABLED;
+
+	dev_dbg(mmc_dev(host->mmc), "DISABLED -> ENABLED\n");
+
+	return 0;
+}
+
+/* Handler for [OFF -> ENABLED] transition */
+static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
+{
+	clk_enable(host->fclk);
+	clk_enable(host->iclk);
+
+	if (clk_enable(host->dbclk))
+		dev_dbg(mmc_dev(host->mmc),
+			"Enabling debounce clk failed\n");
+
+	omap_mmc_restore_ctx(host);
+	omap_hsmmc_init(host);
+	mmc_power_restore_host(host->mmc);
+
+	host->dpm_state = ENABLED;
+
+	dev_dbg(mmc_dev(host->mmc), "OFF -> ENABLED\n");
+
+	return 0;
+}
+
+/*
+ * Bring MMC host to ENABLED from any other PM state.
+ */
+static int omap_mmc_enable(struct mmc_host *mmc)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	switch (host->dpm_state) {
+	case DISABLED:
+		return omap_mmc_disabled_to_enabled(host);
+	case OFF:
+		return omap_mmc_off_to_enabled(host);
+	default:
+		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
+		return -EINVAL;
+	}
+}
+
+/*
+ * Bring MMC host in PM state (one level deeper).
+ */
+static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	switch (host->dpm_state) {
+	case ENABLED: {
+		int delay;
+
+		delay = omap_mmc_enabled_to_disabled(host);
+		if (lazy || delay < 0)
+			return delay;
+		return 0;
+	}
+	case DISABLED:
+		return omap_mmc_disabled_to_off(host);
+	default:
+		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
+		return -EINVAL;
+	}
+}
+
+static int omap_mmc_enable_fclk(struct mmc_host *mmc)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+	int err;
+
+	err = clk_enable(host->fclk);
+	if (err)
+		return err;
+	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
+	omap_mmc_restore_ctx(host);
+	return 0;
+}
+
+static int omap_mmc_disable_fclk(struct mmc_host *mmc, int lazy)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	omap_mmc_save_ctx(host);
+	clk_disable(host->fclk);
+	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
+	return 0;
+}
+
+static const struct mmc_host_ops mmc_omap_ops = {
+	.enable = omap_mmc_enable_fclk,
+	.disable = omap_mmc_disable_fclk,
+	.request = omap_mmc_request,
+	.set_ios = omap_mmc_set_ios,
+	.get_cd = omap_hsmmc_get_cd,
+	.get_ro = omap_hsmmc_get_ro,
+	/* NYET -- enable_sdio_irq */
+};
+
+static const struct mmc_host_ops mmc_omap_ps_ops = {
 	.enable = omap_mmc_enable,
 	.disable = omap_mmc_disable,
 	.request = omap_mmc_request,
@@ -1214,15 +1385,22 @@ static int mmc_regs_show(struct seq_file
 
 	seq_printf(s, "mmc%d:\n"
 			" enabled:\t%d\n"
+			" dpm_state:\t%d\n"
 			" nesting_cnt:\t%d\n"
 			" ctx_loss:\t%d:%d\n"
 			"\nregs:\n",
-			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt,
+			mmc->index, mmc->enabled ? 1 : 0,
+			host->dpm_state, mmc->nesting_cnt,
 			host->context_loss, context_loss);
 
+	if (host->suspended || host->dpm_state == OFF) {
+		seq_printf(s, "host suspended, can't read registers\n");
+		return 0;
+	}
+
 	if (clk_enable(host->fclk) != 0) {
 		seq_printf(s, "can't read the regs\n");
-		goto err;
+		return 0;
 	}
 
 	seq_printf(s, "SYSCONFIG:\t0x%08x\n",
@@ -1241,7 +1419,7 @@ static int mmc_regs_show(struct seq_file
 			OMAP_HSMMC_READ(host->base, CAPA));
 
 	clk_disable(host->fclk);
-err:
+
 	return 0;
 }
 
@@ -1323,7 +1501,11 @@ static int __init omap_mmc_probe(struct 
 	platform_set_drvdata(pdev, host);
 	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
 
-	mmc->ops	= &mmc_omap_ops;
+	if (pdata->slots[host->slot_id].power_saving)
+		mmc->ops	= &mmc_omap_ps_ops;
+	else
+		mmc->ops	= &mmc_omap_ops;
+
 	mmc->f_min	= 400000;
 	mmc->f_max	= 52000000;
 
@@ -1346,7 +1528,10 @@ static int __init omap_mmc_probe(struct 
 	omap_mmc_save_ctx(host);
 
 	mmc->caps |= MMC_CAP_DISABLE;
-	mmc_set_disable_delay(mmc, 100);
+	mmc_set_disable_delay(mmc, OMAP_MMC_DISABLED_TIMEOUT);
+	/* we start off in DISABLED state */
+	host->dpm_state = DISABLED;
+
 	if (mmc_host_enable(host->mmc) != 0) {
 		clk_put(host->iclk);
 		clk_put(host->fclk);
_

Patches currently in -mm which might be from ext-denis.2.karpov@nokia.com are

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

