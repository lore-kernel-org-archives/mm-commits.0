From: akpm@linux-foundation.org
Subject: + mmc-add-mmc_cap_nonremovable-host-capability.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:57:54 -0700
Message-ID: <200907292057.n6TKvtMP008402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbZG2U6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     mmc: add MMC_CAP_NONREMOVABLE host capability
has been added to the -mm tree.  Its filename is
     mmc-add-mmc_cap_nonremovable-host-capability.patch

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
Subject: mmc: add MMC_CAP_NONREMOVABLE host capability
From: Adrian Hunter <adrian.hunter@nokia.com>

eMMC's are not removable, so unsafe resume is OK always.

To permit this a new host capability MMC_CAP_NONREMOVABLE has been added
and suspend / resume updated accordingly.

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

 drivers/mmc/core/mmc.c   |   41 ++++++++++++++++++++++++++++++-------
 drivers/mmc/core/sd.c    |   41 ++++++++++++++++++++++++++++++-------
 include/linux/mmc/host.h |    1 
 3 files changed, 69 insertions(+), 14 deletions(-)

diff -puN drivers/mmc/core/mmc.c~mmc-add-mmc_cap_nonremovable-host-capability drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-add-mmc_cap_nonremovable-host-capability
+++ a/drivers/mmc/core/mmc.c
@@ -507,8 +507,6 @@ static void mmc_detect(struct mmc_host *
 	}
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
 /*
  * Suspend callback from host.
  */
@@ -551,20 +549,49 @@ static void mmc_resume(struct mmc_host *
 
 }
 
-#else
+#ifdef CONFIG_MMC_UNSAFE_RESUME
 
-#define mmc_suspend NULL
-#define mmc_resume NULL
+static const struct mmc_bus_ops mmc_ops = {
+	.remove = mmc_remove,
+	.detect = mmc_detect,
+	.suspend = mmc_suspend,
+	.resume = mmc_resume,
+};
 
-#endif
+static void mmc_attach_bus_ops(struct mmc_host *host)
+{
+	mmc_attach_bus(host, &mmc_ops);
+}
+
+#else
 
 static const struct mmc_bus_ops mmc_ops = {
 	.remove = mmc_remove,
 	.detect = mmc_detect,
+	.suspend = NULL,
+	.resume = NULL,
+};
+
+static const struct mmc_bus_ops mmc_ops_unsafe = {
+	.remove = mmc_remove,
+	.detect = mmc_detect,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
 };
 
+static void mmc_attach_bus_ops(struct mmc_host *host)
+{
+	const struct mmc_bus_ops *bus_ops;
+
+	if (host->caps & MMC_CAP_NONREMOVABLE)
+		bus_ops = &mmc_ops_unsafe;
+	else
+		bus_ops = &mmc_ops;
+	mmc_attach_bus(host, bus_ops);
+}
+
+#endif
+
 /*
  * Starting point for MMC card init.
  */
@@ -575,7 +602,7 @@ int mmc_attach_mmc(struct mmc_host *host
 	BUG_ON(!host);
 	WARN_ON(!host->claimed);
 
-	mmc_attach_bus(host, &mmc_ops);
+	mmc_attach_bus_ops(host);
 
 	/*
 	 * We need to get OCR a different way for SPI.
diff -puN drivers/mmc/core/sd.c~mmc-add-mmc_cap_nonremovable-host-capability drivers/mmc/core/sd.c
--- a/drivers/mmc/core/sd.c~mmc-add-mmc_cap_nonremovable-host-capability
+++ a/drivers/mmc/core/sd.c
@@ -561,8 +561,6 @@ static void mmc_sd_detect(struct mmc_hos
 	}
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
 /*
  * Suspend callback from host.
  */
@@ -605,20 +603,49 @@ static void mmc_sd_resume(struct mmc_hos
 
 }
 
-#else
+#ifdef CONFIG_MMC_UNSAFE_RESUME
 
-#define mmc_sd_suspend NULL
-#define mmc_sd_resume NULL
+static const struct mmc_bus_ops mmc_sd_ops = {
+	.remove = mmc_sd_remove,
+	.detect = mmc_sd_detect,
+	.suspend = mmc_sd_suspend,
+	.resume = mmc_sd_resume,
+};
 
-#endif
+static void mmc_sd_attach_bus_ops(struct mmc_host *host)
+{
+	mmc_attach_bus(host, &mmc_sd_ops);
+}
+
+#else
 
 static const struct mmc_bus_ops mmc_sd_ops = {
 	.remove = mmc_sd_remove,
 	.detect = mmc_sd_detect,
+	.suspend = NULL,
+	.resume = NULL,
+};
+
+static const struct mmc_bus_ops mmc_sd_ops_unsafe = {
+	.remove = mmc_sd_remove,
+	.detect = mmc_sd_detect,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
 };
 
+static void mmc_sd_attach_bus_ops(struct mmc_host *host)
+{
+	const struct mmc_bus_ops *bus_ops;
+
+	if (host->caps & MMC_CAP_NONREMOVABLE)
+		bus_ops = &mmc_sd_ops_unsafe;
+	else
+		bus_ops = &mmc_sd_ops;
+	mmc_attach_bus(host, bus_ops);
+}
+
+#endif
+
 /*
  * Starting point for SD card init.
  */
@@ -629,7 +656,7 @@ int mmc_attach_sd(struct mmc_host *host,
 	BUG_ON(!host);
 	WARN_ON(!host->claimed);
 
-	mmc_attach_bus(host, &mmc_sd_ops);
+	mmc_sd_attach_bus_ops(host);
 
 	/*
 	 * We need to get OCR a different way for SPI.
diff -puN include/linux/mmc/host.h~mmc-add-mmc_cap_nonremovable-host-capability include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-add-mmc_cap_nonremovable-host-capability
+++ a/include/linux/mmc/host.h
@@ -148,6 +148,7 @@ struct mmc_host {
 #define MMC_CAP_NEEDS_POLL	(1 << 5)	/* Needs polling for card-detection */
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
+#define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
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

