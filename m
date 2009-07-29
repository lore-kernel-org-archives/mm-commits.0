From: akpm@linux-foundation.org
Subject: + arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:57 -0700
Message-ID: <200907292058.n6TKwvOW010134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbZG2U7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     ARM: OMAP: RX51: set MMC capabilities and power-saving flag
has been added to the -mm tree.  Its filename is
     arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

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
Subject: ARM: OMAP: RX51: set MMC capabilities and power-saving flag
From: Adrian Hunter <adrian.hunter@nokia.com>

Specify MMC capabilities and set the power-saving flag for RX51.

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

 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/arm/mach-omap2/board-rx51-peripherals.c~arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag arch/arm/mach-omap2/board-rx51-peripherals.c
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c~arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag
+++ a/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/regulator/machine.h>
 #include <linux/gpio.h>
+#include <linux/mmc/host.h>
 
 #include <mach/mcspi.h>
 #include <mach/mux.h>
@@ -102,6 +103,8 @@ static struct twl4030_hsmmc_info mmc[] =
 		.cover_only	= true,
 		.gpio_cd	= 160,
 		.gpio_wp	= -EINVAL,
+		.power_saving	= true,
+		.caps		= MMC_CAP_SD,
 	},
 	{
 		.name		= "internal",
@@ -109,6 +112,8 @@ static struct twl4030_hsmmc_info mmc[] =
 		.wires		= 8,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
+		.power_saving	= true,
+		.caps		= MMC_CAP_MMC | MMC_CAP_NONREMOVABLE,
 	},
 	{}	/* Terminator */
 };
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

