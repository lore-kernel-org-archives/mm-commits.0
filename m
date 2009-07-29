From: akpm@linux-foundation.org
Subject: + omap_hsmmc-keep-track-of-power-mode.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:14 -0700
Message-ID: <200907292058.n6TKwEfM008961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159AbZG2VDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 17:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: keep track of power mode
has been added to the -mm tree.  Its filename is
     omap_hsmmc-keep-track-of-power-mode.patch

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
Subject: omap_hsmmc: keep track of power mode
From: Adrian Hunter <adrian.hunter@nokia.com>

This patch is preparation for adding context save and restore support.

Keep track of the current power mode so that the context restore function
can avoid restoring the context for a card if the power has been switched
off.  If the power is off, the card must be reinitialized anyway which
will re-establish the context.

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

 drivers/mmc/host/omap_hsmmc.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-keep-track-of-power-mode drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-keep-track-of-power-mode
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -143,6 +143,7 @@ struct mmc_omap_host {
 	unsigned int		dma_len;
 	unsigned int		dma_sg_idx;
 	unsigned char		bus_mode;
+	unsigned char		power_mode;
 	u32			*buffer;
 	u32			bytesleft;
 	int			suspended;
@@ -863,16 +864,25 @@ static void omap_mmc_set_ios(struct mmc_
 	unsigned long regval;
 	unsigned long timeout;
 	u32 con;
+	int do_send_init_stream = 0;
 
 	mmc_host_enable(host->mmc);
 
-	switch (ios->power_mode) {
-	case MMC_POWER_OFF:
-		mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
-		break;
-	case MMC_POWER_UP:
-		mmc_slot(host).set_power(host->dev, host->slot_id, 1, ios->vdd);
-		break;
+	if (ios->power_mode != host->power_mode) {
+		switch (ios->power_mode) {
+		case MMC_POWER_OFF:
+			mmc_slot(host).set_power(host->dev, host->slot_id,
+						 0, 0);
+			break;
+		case MMC_POWER_UP:
+			mmc_slot(host).set_power(host->dev, host->slot_id,
+						 1, ios->vdd);
+			break;
+		case MMC_POWER_ON:
+			do_send_init_stream = 1;
+			break;
+		}
+		host->power_mode = ios->power_mode;
 	}
 
 	con = OMAP_HSMMC_READ(host->base, CON);
@@ -938,7 +948,7 @@ static void omap_mmc_set_ios(struct mmc_
 	OMAP_HSMMC_WRITE(host->base, SYSCTL,
 		OMAP_HSMMC_READ(host->base, SYSCTL) | CEN);
 
-	if (ios->power_mode == MMC_POWER_ON)
+	if (do_send_init_stream)
 		send_init_stream(host);
 
 	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
@@ -1116,6 +1126,7 @@ static int __init omap_mmc_probe(struct 
 	host->slot_id	= 0;
 	host->mapbase	= res->start;
 	host->base	= ioremap(host->mapbase, SZ_4K);
+	host->power_mode = -1;
 
 	platform_set_drvdata(pdev, host);
 	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
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

