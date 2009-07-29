From: akpm@linux-foundation.org
Subject: + omap_hsmmc-context-save-restore-support.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:16 -0700
Message-ID: <200907292058.n6TKwGbb008998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbZG2U7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: context save/restore support
has been added to the -mm tree.  Its filename is
     omap_hsmmc-context-save-restore-support.patch

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
Subject: omap_hsmmc: context save/restore support
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

Keep the context over PM dynamic OFF states.

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

 drivers/mmc/host/omap_hsmmc.c |  194 ++++++++++++++++++++++++++++++--
 1 file changed, 184 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-context-save-restore-support drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-context-save-restore-support
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -37,6 +37,7 @@
 
 /* OMAP HSMMC Host Controller Registers */
 #define OMAP_HSMMC_SYSCONFIG	0x0010
+#define OMAP_HSMMC_SYSSTATUS	0x0014
 #define OMAP_HSMMC_CON		0x002C
 #define OMAP_HSMMC_BLK		0x0104
 #define OMAP_HSMMC_ARG		0x0108
@@ -96,6 +97,8 @@
 #define DUAL_VOLT_OCR_BIT	7
 #define SRC			(1 << 25)
 #define SRD			(1 << 26)
+#define SOFTRESET		(1 << 1)
+#define RESETDONE		(1 << 0)
 
 /*
  * FIXME: Most likely all the data using these _DEVID defines should come
@@ -154,6 +157,8 @@ struct mmc_omap_host {
 	int			slot_id;
 	int			dbclk_enabled;
 	int			response_busy;
+	int			context_loss;
+
 	struct	omap_mmc_platform_data	*pdata;
 };
 
@@ -168,6 +173,166 @@ static void omap_mmc_stop_clock(struct m
 		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
 }
 
+#ifdef CONFIG_PM
+
+/*
+ * Restore the MMC host context, if it was lost as result of a
+ * power state change.
+ */
+static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
+{
+	struct mmc_ios *ios = &host->mmc->ios;
+	struct omap_mmc_platform_data *pdata = host->pdata;
+	int context_loss = 0;
+	u32 hctl, capa, con;
+	u16 dsor = 0;
+	unsigned long timeout;
+
+	if (pdata->get_context_loss_count) {
+		context_loss = pdata->get_context_loss_count(host->dev);
+		if (context_loss < 0)
+			return 1;
+	}
+
+	dev_dbg(mmc_dev(host->mmc), "context was %slost\n",
+		context_loss == host->context_loss ? "not " : "");
+	if (host->context_loss == context_loss)
+		return 1;
+
+	/* Wait for hardware reset */
+	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+	while ((OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE) != RESETDONE
+		&& time_before(jiffies, timeout))
+		;
+
+	/* Do software reset */
+	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET);
+	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+	while ((OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE) != RESETDONE
+		&& time_before(jiffies, timeout))
+		;
+
+	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
+			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
+
+	if (host->id == OMAP_MMC1_DEVID) {
+		if (host->power_mode != MMC_POWER_OFF &&
+		    (1 << ios->vdd) <= MMC_VDD_23_24)
+			hctl = SDVS18;
+		else
+			hctl = SDVS30;
+		capa = VS30 | VS18;
+	} else {
+		hctl = SDVS18;
+		capa = VS18;
+	}
+
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+			OMAP_HSMMC_READ(host->base, HCTL) | hctl);
+
+	OMAP_HSMMC_WRITE(host->base, CAPA,
+			OMAP_HSMMC_READ(host->base, CAPA) | capa);
+
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+			OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+
+	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP
+		&& time_before(jiffies, timeout))
+		;
+
+	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
+	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
+
+	/* Do not initialize card-specific things if the power is off */
+	if (host->power_mode == MMC_POWER_OFF)
+		goto out;
+
+	con = OMAP_HSMMC_READ(host->base, CON);
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_8:
+		OMAP_HSMMC_WRITE(host->base, CON, con | DW8);
+		break;
+	case MMC_BUS_WIDTH_4:
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
+		OMAP_HSMMC_WRITE(host->base, HCTL,
+			OMAP_HSMMC_READ(host->base, HCTL) | FOUR_BIT);
+		break;
+	case MMC_BUS_WIDTH_1:
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
+		OMAP_HSMMC_WRITE(host->base, HCTL,
+			OMAP_HSMMC_READ(host->base, HCTL) & ~FOUR_BIT);
+		break;
+	}
+
+	if (ios->clock) {
+		dsor = OMAP_MMC_MASTER_CLOCK / ios->clock;
+		if (dsor < 1)
+			dsor = 1;
+
+		if (OMAP_MMC_MASTER_CLOCK / dsor > ios->clock)
+			dsor++;
+
+		if (dsor > 250)
+			dsor = 250;
+	}
+
+	OMAP_HSMMC_WRITE(host->base, SYSCTL,
+		OMAP_HSMMC_READ(host->base, SYSCTL) & ~CEN);
+	OMAP_HSMMC_WRITE(host->base, SYSCTL, (dsor << 6) | (DTO << 16));
+	OMAP_HSMMC_WRITE(host->base, SYSCTL,
+		OMAP_HSMMC_READ(host->base, SYSCTL) | ICE);
+
+	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != ICS
+		&& time_before(jiffies, timeout))
+		;
+
+	OMAP_HSMMC_WRITE(host->base, SYSCTL,
+		OMAP_HSMMC_READ(host->base, SYSCTL) | CEN);
+
+	con = OMAP_HSMMC_READ(host->base, CON);
+	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
+		OMAP_HSMMC_WRITE(host->base, CON, con | OD);
+	else
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~OD);
+out:
+	host->context_loss = context_loss;
+
+	dev_dbg(mmc_dev(host->mmc), "context is restored\n");
+	return 0;
+}
+
+/*
+ * Save the MMC host context (store the number of power state changes so far).
+ */
+static void omap_mmc_save_ctx(struct mmc_omap_host *host)
+{
+	struct omap_mmc_platform_data *pdata = host->pdata;
+	int context_loss;
+
+	if (pdata->get_context_loss_count) {
+		context_loss = pdata->get_context_loss_count(host->dev);
+		if (context_loss < 0)
+			return;
+		host->context_loss = context_loss;
+	}
+}
+
+#else
+
+static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
+{
+	return 0;
+}
+
+static void omap_mmc_save_ctx(struct mmc_omap_host *host)
+{
+}
+
+#endif
+
 /*
  * Send init stream sequence to card
  * before sending IDLE command
@@ -830,6 +995,7 @@ static int omap_mmc_enable(struct mmc_ho
 	if (err)
 		return err;
 	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
+	omap_mmc_restore_ctx(host);
 	return 0;
 }
 
@@ -837,6 +1003,7 @@ static int omap_mmc_disable(struct mmc_h
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
 
+	omap_mmc_save_ctx(host);
 	clk_disable(host->fclk);
 	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
 	return 0;
@@ -941,7 +1108,7 @@ static void omap_mmc_set_ios(struct mmc_
 
 	/* Wait till the ICS bit is set */
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != 0x2
+	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != ICS
 		&& time_before(jiffies, timeout))
 		msleep(1);
 
@@ -1021,12 +1188,19 @@ static int mmc_regs_show(struct seq_file
 {
 	struct mmc_host *mmc = s->private;
 	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_mmc_platform_data *pdata = host->pdata;
+	int context_loss = 0;
+
+	if (pdata->get_context_loss_count)
+		context_loss = pdata->get_context_loss_count(host->dev);
 
 	seq_printf(s, "mmc%d:\n"
 			" enabled:\t%d\n"
 			" nesting_cnt:\t%d\n"
+			" ctx_loss:\t%d:%d\n"
 			"\nregs:\n",
-			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt);
+			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt,
+			host->context_loss, context_loss);
 
 	if (clk_enable(host->fclk) != 0) {
 		seq_printf(s, "can't read the regs\n");
@@ -1151,6 +1325,8 @@ static int __init omap_mmc_probe(struct 
 		goto err1;
 	}
 
+	omap_mmc_save_ctx(host);
+
 	mmc->caps |= MMC_CAP_DISABLE;
 	mmc_set_disable_delay(mmc, 100);
 	if (mmc_host_enable(host->mmc) != 0) {
@@ -1387,21 +1563,19 @@ static int omap_mmc_resume(struct platfo
 		return 0;
 
 	if (host) {
-
-		if (mmc_host_enable(host->mmc) != 0)
-			goto clk_en_err;
-
 		ret = clk_enable(host->iclk);
-		if (ret) {
-			mmc_host_disable(host->mmc);
-			clk_put(host->fclk);
+		if (ret)
 			goto clk_en_err;
-		}
 
 		if (clk_enable(host->dbclk) != 0)
 			dev_dbg(mmc_dev(host->mmc),
 					"Enabling debounce clk failed\n");
 
+		if (mmc_host_enable(host->mmc) != 0) {
+			clk_disable(host->iclk);
+			goto clk_en_err;
+		}
+
 		omap_hsmmc_init(host);
 
 		if (host->pdata->resume) {
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

