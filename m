From: akpm@linux-foundation.org
Subject: [withdrawn] omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch removed from -mm tree
Date: Thu, 10 Sep 2009 15:02:23 -0700
Message-ID: <200909102202.n8AM2Oju025924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbZIJWDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 18:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, robe


The patch titled
     omap_hsmmc: pass host capabilities for SD only and MMC only
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: pass host capabilities for SD only and MMC only
From: Adrian Hunter <adrian.hunter@nokia.com>

Some hosts can accept only certain types of cards.  For example, an eMMC
is MMC only and a uSD slot may be SD only.  Pass host capabilities from
the board through to the driver.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/mmc-twl4030.c     |    5 ++---
 arch/arm/mach-omap2/mmc-twl4030.h     |    2 +-
 arch/arm/plat-omap/include/mach/mmc.h |    6 +++---
 drivers/mmc/host/omap_hsmmc.c         |    7 ++++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-omap2/mmc-twl4030.c~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only arch/arm/mach-omap2/mmc-twl4030.c
--- a/arch/arm/mach-omap2/mmc-twl4030.c~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only
+++ a/arch/arm/mach-omap2/mmc-twl4030.c
@@ -470,12 +470,11 @@ void __init twl4030_mmc_init(struct twl4
 		} else
 			mmc->slots[0].gpio_wp = -EINVAL;
 
-		if (c->nonremovable)
-			mmc->slots[0].nonremovable = 1;
-
 		if (c->power_saving)
 			mmc->slots[0].power_saving = 1;
 
+		mmc->slots[0].caps = c->caps;
+
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
 		 * This may be from a TWL4030-family chip, another
 		 * controllable regulator, or a fixed supply.
diff -puN arch/arm/mach-omap2/mmc-twl4030.h~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only arch/arm/mach-omap2/mmc-twl4030.h
--- a/arch/arm/mach-omap2/mmc-twl4030.h~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only
+++ a/arch/arm/mach-omap2/mmc-twl4030.h
@@ -12,8 +12,8 @@ struct twl4030_hsmmc_info {
 	bool	transceiver;	/* MMC-2 option */
 	bool	ext_clock;	/* use external pin for input clock */
 	bool	cover_only;	/* No card detect - just cover switch */
-	bool	nonremovable;	/* Nonremovable e.g. eMMC */
 	bool	power_saving;	/* Try to sleep or power off when possible */
+	unsigned long caps;	/* MMC host capabilities */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
 	char	*name;		/* or NULL for default */
diff -puN arch/arm/plat-omap/include/mach/mmc.h~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only arch/arm/plat-omap/include/mach/mmc.h
--- a/arch/arm/plat-omap/include/mach/mmc.h~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only
+++ a/arch/arm/plat-omap/include/mach/mmc.h
@@ -83,12 +83,12 @@ struct omap_mmc_platform_data {
 		/* use the internal clock */
 		unsigned internal_clock:1;
 
-		/* nonremovable e.g. eMMC */
-		unsigned nonremovable:1;
-
 		/* Try to sleep or power off when possible */
 		unsigned power_saving:1;
 
+		/* MMC host capabilities */
+		unsigned long caps;
+
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
 
diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1671,10 +1671,11 @@ static int __init omap_mmc_probe(struct 
 	else if (mmc_slot(host).wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	if (mmc_slot(host).nonremovable)
-		mmc->caps |= MMC_CAP_NONREMOVABLE;
+	mmc->caps |= mmc_slot(host).caps;
 
-	mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
+	/* If no card caps specified then assume them all */
+	if (!(mmc->caps & (MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC)))
+		mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	omap_hsmmc_init(host);
 
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

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
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update.patch

