From: akpm@linux-foundation.org
Subject: + mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:54:40 -0700
Message-ID: <200907242254.n6OMsfYm031077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbZGXWyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     mmc: add host capabilities for SD only and MMC only
has been added to the -mm tree.  Its filename is
     mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch

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
Subject: mmc: add host capabilities for SD only and MMC only
From: Adrian Hunter <adrian.hunter@nokia.com>

Some hosts can accept only certain types of cards.  For example, an eMMC
is MMC only and a uSD slot may be SD only.  However the MMC card scanning
logic checks for all card types one by one.

Add host capabilities to specify which card types cannot be used, and
amend the card scanning logic to skip scanning for those types.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   16 +++++++++++++++-
 include/linux/mmc/host.h |    7 +++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/core.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/core/core.c
@@ -1072,7 +1072,11 @@ void mmc_rescan(struct work_struct *work
 	mmc_power_up(host);
 	mmc_go_idle(host);
 
-	mmc_send_if_cond(host, host->ocr_avail);
+	if (!(host->caps & MMC_CAP_NOT_SDIO) || !(host->caps & MMC_CAP_NOT_SD))
+		mmc_send_if_cond(host, host->ocr_avail);
+
+	if (host->caps & MMC_CAP_NOT_SDIO)
+		goto not_sdio;
 
 	/*
 	 * First we search for SDIO...
@@ -1084,6 +1088,10 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+not_sdio:
+	if (host->caps & MMC_CAP_NOT_SD)
+		goto not_sd;
+
 	/*
 	 * ...then normal SD...
 	 */
@@ -1094,6 +1102,10 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+not_sd:
+	if (host->caps & MMC_CAP_NOT_MMC)
+		goto not_mmc;
+
 	/*
 	 * ...and finally MMC.
 	 */
@@ -1104,6 +1116,8 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+not_mmc:
+
 	mmc_release_host(host);
 	mmc_power_off(host);
 
diff -puN include/linux/mmc/host.h~mmc-add-host-capabilities-for-sd-only-and-mmc-only include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/include/linux/mmc/host.h
@@ -150,6 +150,13 @@ struct mmc_host {
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
+#define MMC_CAP_NOT_SDIO	(1 << 10)	/* Card cannot be SDIO */
+#define MMC_CAP_NOT_SD		(1 << 11)	/* Card cannot be SD */
+#define MMC_CAP_NOT_MMC		(1 << 12)	/* Card cannot be MMC */
+
+#define MMC_CAP_SDIO_ONLY	(MMC_CAP_NOT_SD | MMC_CAP_NOT_MMC)
+#define MMC_CAP_SD_ONLY		(MMC_CAP_NOT_SDIO | MMC_CAP_NOT_MMC)
+#define MMC_CAP_MMC_ONLY	(MMC_CAP_NOT_SDIO | MMC_CAP_NOT_SD)
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
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

