From: akpm@linux-foundation.org
Subject: + arm-omap-mmc-twl4030-add-context-loss-counter-support.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:54:48 -0700
Message-ID: <200907242254.n6OMsnkN031263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbZGXWy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     ARM: OMAP: mmc-twl4030: add context loss counter support
has been added to the -mm tree.  Its filename is
     arm-omap-mmc-twl4030-add-context-loss-counter-support.patch

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
Subject: ARM: OMAP: mmc-twl4030: add context loss counter support
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

PM dynamic OFF state results in context loss.  That is, the host
controller has been powered off at some point, which means the registers
have been reset.  The driver must detect when this happens, and restore
the context.  This patch adds the means to detect context loss.

Note, the PM side is not yet implemented.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/mmc-twl4030.c     |   15 +++++++++++++++
 arch/arm/plat-omap/include/mach/mmc.h |    3 +++
 2 files changed, 18 insertions(+)

diff -puN arch/arm/mach-omap2/mmc-twl4030.c~arm-omap-mmc-twl4030-add-context-loss-counter-support arch/arm/mach-omap2/mmc-twl4030.c
--- a/arch/arm/mach-omap2/mmc-twl4030.c~arm-omap-mmc-twl4030-add-context-loss-counter-support
+++ a/arch/arm/mach-omap2/mmc-twl4030.c
@@ -192,6 +192,18 @@ static int twl_mmc_resume(struct device 
 #define twl_mmc_resume	NULL
 #endif
 
+#if defined(CONFIG_ARCH_OMAP3) && defined(CONFIG_PM)
+
+static int twl4030_mmc_get_context_loss(struct device *dev)
+{
+	/* FIXME: PM DPS not implemented yet */
+	return 0;
+}
+
+#else
+#define twl4030_mmc_get_context_loss NULL
+#endif
+
 static int twl_mmc1_set_power(struct device *dev, int slot, int power_on,
 				int vdd)
 {
@@ -384,6 +396,9 @@ void __init twl4030_mmc_init(struct twl4
 		} else
 			mmc->slots[0].switch_pin = -EINVAL;
 
+		mmc->get_context_loss_count =
+				twl4030_mmc_get_context_loss;
+
 		/* write protect normally uses an OMAP gpio */
 		if (gpio_is_valid(c->gpio_wp)) {
 			gpio_request(c->gpio_wp, "mmc_wp");
diff -puN arch/arm/plat-omap/include/mach/mmc.h~arm-omap-mmc-twl4030-add-context-loss-counter-support arch/arm/plat-omap/include/mach/mmc.h
--- a/arch/arm/plat-omap/include/mach/mmc.h~arm-omap-mmc-twl4030-add-context-loss-counter-support
+++ a/arch/arm/plat-omap/include/mach/mmc.h
@@ -59,6 +59,9 @@ struct omap_mmc_platform_data {
 	int (*suspend)(struct device *dev, int slot);
 	int (*resume)(struct device *dev, int slot);
 
+	/* Return context loss count due to PM states changing */
+	int (*get_context_loss_count)(struct device *dev);
+
 	u64 dma_mask;
 
 	struct omap_mmc_slot_data {
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

