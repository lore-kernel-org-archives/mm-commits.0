From: akpm@linux-foundation.org
Subject: [merged] omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:54:53 -0700
Message-ID: <200909231954.n8NJsrYE001639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560AbZIWTzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     omap_hsmmc: make use of new MMC_CAP_NONREMOVABLE host capability
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: make use of new MMC_CAP_NONREMOVABLE host capability
From: Adrian Hunter <adrian.hunter@nokia.com>

Let the board specify that a card is nonremovable e.g. eMMC

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

 arch/arm/mach-omap2/mmc-twl4030.c     |    3 +++
 arch/arm/mach-omap2/mmc-twl4030.h     |    1 +
 arch/arm/plat-omap/include/mach/mmc.h |    3 +++
 drivers/mmc/host/omap_hsmmc.c         |    3 +++
 4 files changed, 10 insertions(+)

diff -puN arch/arm/mach-omap2/mmc-twl4030.c~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability arch/arm/mach-omap2/mmc-twl4030.c
--- a/arch/arm/mach-omap2/mmc-twl4030.c~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability
+++ a/arch/arm/mach-omap2/mmc-twl4030.c
@@ -415,6 +415,9 @@ void __init twl4030_mmc_init(struct twl4
 		} else
 			mmc->slots[0].gpio_wp = -EINVAL;
 
+		if (c->nonremovable)
+			mmc->slots[0].nonremovable = 1;
+
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
 		 * This may be from a TWL4030-family chip, another
 		 * controllable regulator, or a fixed supply.
diff -puN arch/arm/mach-omap2/mmc-twl4030.h~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability arch/arm/mach-omap2/mmc-twl4030.h
--- a/arch/arm/mach-omap2/mmc-twl4030.h~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability
+++ a/arch/arm/mach-omap2/mmc-twl4030.h
@@ -12,6 +12,7 @@ struct twl4030_hsmmc_info {
 	bool	transceiver;	/* MMC-2 option */
 	bool	ext_clock;	/* use external pin for input clock */
 	bool	cover_only;	/* No card detect - just cover switch */
+	bool	nonremovable;	/* Nonremovable e.g. eMMC */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
 	char	*name;		/* or NULL for default */
diff -puN arch/arm/plat-omap/include/mach/mmc.h~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability arch/arm/plat-omap/include/mach/mmc.h
--- a/arch/arm/plat-omap/include/mach/mmc.h~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability
+++ a/arch/arm/plat-omap/include/mach/mmc.h
@@ -83,6 +83,9 @@ struct omap_mmc_platform_data {
 		/* use the internal clock */
 		unsigned internal_clock:1;
 
+		/* nonremovable e.g. eMMC */
+		unsigned nonremovable:1;
+
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
 
diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1390,6 +1390,9 @@ static int __init omap_mmc_probe(struct 
 	else if (pdata->slots[host->slot_id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
+	if (pdata->slots[host->slot_id].nonremovable)
+		mmc->caps |= MMC_CAP_NONREMOVABLE;
+
 	omap_hsmmc_init(host);
 
 	/* Select DMA lines */
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch

