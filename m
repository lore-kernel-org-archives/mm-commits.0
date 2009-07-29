From: akpm@linux-foundation.org
Subject: [to-be-updated] arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:50:09 -0700
Message-ID: <200907292050.n6TKo9T5028089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbZG2Uuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     ARM: OMAP: RX51: set MMC capabilities and power-saving flag
has been removed from the -mm tree.  Its filename was
     arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ARM: OMAP: RX51: set MMC capabilities and power-saving flag
From: Adrian Hunter <adrian.hunter@nokia.com>

Specify MMC capabilities and set the power-saving flag for RX51.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
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
+		.caps		= MMC_CAP_SD_ONLY,
 	},
 	{
 		.name		= "internal",
@@ -109,6 +112,8 @@ static struct twl4030_hsmmc_info mmc[] =
 		.wires		= 8,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
+		.power_saving	= true,
+		.caps		= MMC_CAP_MMC_ONLY | MMC_CAP_NONREMOVABLE,
 	},
 	{}	/* Terminator */
 };
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

