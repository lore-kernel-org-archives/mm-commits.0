From: akpm@linux-foundation.org
Subject: [merged] arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:23 -0700
Message-ID: <200909231955.n8NJtN34002739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbZIWT4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     ARM: OMAP: RX51: set MMC capabilities and power-saving flag
has been removed from the -mm tree.  Its filename was
     arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 ++++
 1 file changed, 4 insertions(+)

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
@@ -102,6 +103,7 @@ static struct twl4030_hsmmc_info mmc[] =
 		.cover_only	= true,
 		.gpio_cd	= 160,
 		.gpio_wp	= -EINVAL,
+		.power_saving	= true,
 	},
 	{
 		.name		= "internal",
@@ -109,6 +111,8 @@ static struct twl4030_hsmmc_info mmc[] =
 		.wires		= 8,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
+		.nonremovable	= true,
+		.power_saving	= true,
 	},
 	{}	/* Terminator */
 };
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch

