From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc-add-ability-to-save-power-by-powering-off-cards.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:48:44 -0700
Message-ID: <200907292048.n6TKmiJB025796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163AbZG2Ut1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     mmc: add ability to save power by powering off cards
has been removed from the -mm tree.  Its filename was
     mmc-add-ability-to-save-power-by-powering-off-cards.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: add ability to save power by powering off cards
From: Adrian Hunter <adrian.hunter@nokia.com>

Power can be saved by powering off cards that are not in use.  This is
similar to suspend / resume except it is under the control of the driver,
and does not require any power management support.  It can only be used
when the driver can monitor whether the card is removed, otherwise it is
unsafe.  This is possible because, unlike suspend, the driver still
receives card detect and / or cover switch interrupts.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   34 ++++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h  |    2 ++
 drivers/mmc/core/mmc.c   |   11 +++++++++++
 drivers/mmc/core/sd.c    |   11 +++++++++++
 include/linux/mmc/host.h |    3 +++
 5 files changed, 61 insertions(+)

diff -puN drivers/mmc/core/core.c~mmc-add-ability-to-save-power-by-powering-off-cards drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-add-ability-to-save-power-by-powering-off-cards
+++ a/drivers/mmc/core/core.c
@@ -1148,6 +1148,40 @@ void mmc_stop_host(struct mmc_host *host
 	mmc_power_off(host);
 }
 
+void mmc_power_save_host(struct mmc_host *host)
+{
+	mmc_bus_get(host);
+
+	if (!host->bus_ops || host->bus_dead || !host->bus_ops->power_restore) {
+		mmc_bus_put(host);
+		return;
+	}
+
+	if (host->bus_ops->power_save)
+		host->bus_ops->power_save(host);
+
+	mmc_bus_put(host);
+
+	mmc_power_off(host);
+}
+EXPORT_SYMBOL(mmc_power_save_host);
+
+void mmc_power_restore_host(struct mmc_host *host)
+{
+	mmc_bus_get(host);
+
+	if (!host->bus_ops || host->bus_dead || !host->bus_ops->power_restore) {
+		mmc_bus_put(host);
+		return;
+	}
+
+	mmc_power_up(host);
+	host->bus_ops->power_restore(host);
+
+	mmc_bus_put(host);
+}
+EXPORT_SYMBOL(mmc_power_restore_host);
+
 #ifdef CONFIG_PM
 
 /**
diff -puN drivers/mmc/core/core.h~mmc-add-ability-to-save-power-by-powering-off-cards drivers/mmc/core/core.h
--- a/drivers/mmc/core/core.h~mmc-add-ability-to-save-power-by-powering-off-cards
+++ a/drivers/mmc/core/core.h
@@ -20,6 +20,8 @@ struct mmc_bus_ops {
 	void (*detect)(struct mmc_host *);
 	void (*suspend)(struct mmc_host *);
 	void (*resume)(struct mmc_host *);
+	void (*power_save)(struct mmc_host *);
+	void (*power_restore)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
diff -puN drivers/mmc/core/mmc.c~mmc-add-ability-to-save-power-by-powering-off-cards drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-add-ability-to-save-power-by-powering-off-cards
+++ a/drivers/mmc/core/mmc.c
@@ -549,6 +549,14 @@ static void mmc_resume(struct mmc_host *
 
 }
 
+static void mmc_power_restore(struct mmc_host *host)
+{
+	host->card->state &= ~MMC_STATE_HIGHSPEED;
+	mmc_claim_host(host);
+	mmc_init_card(host, host->ocr, host->card);
+	mmc_release_host(host);
+}
+
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 static const struct mmc_bus_ops mmc_ops = {
@@ -556,6 +564,7 @@ static const struct mmc_bus_ops mmc_ops 
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
+	.power_restore = mmc_power_restore,
 };
 
 static void mmc_attach_bus_ops(struct mmc_host *host)
@@ -570,6 +579,7 @@ static const struct mmc_bus_ops mmc_ops 
 	.detect = mmc_detect,
 	.suspend = NULL,
 	.resume = NULL,
+	.power_restore = mmc_power_restore,
 };
 
 static const struct mmc_bus_ops mmc_ops_unsafe = {
@@ -577,6 +587,7 @@ static const struct mmc_bus_ops mmc_ops_
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
+	.power_restore = mmc_power_restore,
 };
 
 static void mmc_attach_bus_ops(struct mmc_host *host)
diff -puN drivers/mmc/core/sd.c~mmc-add-ability-to-save-power-by-powering-off-cards drivers/mmc/core/sd.c
--- a/drivers/mmc/core/sd.c~mmc-add-ability-to-save-power-by-powering-off-cards
+++ a/drivers/mmc/core/sd.c
@@ -603,6 +603,14 @@ static void mmc_sd_resume(struct mmc_hos
 
 }
 
+static void mmc_sd_power_restore(struct mmc_host *host)
+{
+	host->card->state &= ~MMC_STATE_HIGHSPEED;
+	mmc_claim_host(host);
+	mmc_sd_init_card(host, host->ocr, host->card);
+	mmc_release_host(host);
+}
+
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 static const struct mmc_bus_ops mmc_sd_ops = {
@@ -610,6 +618,7 @@ static const struct mmc_bus_ops mmc_sd_o
 	.detect = mmc_sd_detect,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
+	.power_restore = mmc_sd_power_restore,
 };
 
 static void mmc_sd_attach_bus_ops(struct mmc_host *host)
@@ -624,6 +633,7 @@ static const struct mmc_bus_ops mmc_sd_o
 	.detect = mmc_sd_detect,
 	.suspend = NULL,
 	.resume = NULL,
+	.power_restore = mmc_sd_power_restore,
 };
 
 static const struct mmc_bus_ops mmc_sd_ops_unsafe = {
@@ -631,6 +641,7 @@ static const struct mmc_bus_ops mmc_sd_o
 	.detect = mmc_sd_detect,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
+	.power_restore = mmc_sd_power_restore,
 };
 
 static void mmc_sd_attach_bus_ops(struct mmc_host *host)
diff -puN include/linux/mmc/host.h~mmc-add-ability-to-save-power-by-powering-off-cards include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-add-ability-to-save-power-by-powering-off-cards
+++ a/include/linux/mmc/host.h
@@ -223,6 +223,9 @@ static inline void *mmc_priv(struct mmc_
 extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
 extern int mmc_resume_host(struct mmc_host *);
 
+extern void mmc_power_save_host(struct mmc_host *host);
+extern void mmc_power_restore_host(struct mmc_host *host);
+
 extern void mmc_detect_change(struct mmc_host *, unsigned long delay);
 extern void mmc_request_done(struct mmc_host *, struct mmc_request *);
 
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
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

