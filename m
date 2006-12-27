From: akpm@osdl.org
Subject: + arm-omap-fix-gpmc-compiler-errors.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:13:38 -0800
Message-ID: <200612270913.kBR9Dc8L006525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43091 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbWL0JN7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     ARM: OMAP: fix GPMC compiler errors
has been added to the -mm tree.  Its filename is
     arm-omap-fix-gpmc-compiler-errors.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: OMAP: fix GPMC compiler errors
From: Kyungmin Park <kyungmin.park@samsung.com>

Fix GPMC compiler errors on OMAP2

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/mach-omap2/gpmc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN arch/arm/mach-omap2/gpmc.c~arm-omap-fix-gpmc-compiler-errors arch/arm/mach-omap2/gpmc.c
--- a/arch/arm/mach-omap2/gpmc.c~arm-omap-fix-gpmc-compiler-errors
+++ a/arch/arm/mach-omap2/gpmc.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/io.h>
+#include <asm/mach-types.h>
 #include <asm/arch/gpmc.h>
 
 #undef DEBUG
@@ -338,19 +339,13 @@ void __init gpmc_mem_init(void)
 	int cs;
 	unsigned long boot_rom_space = 0;
 
-	if (cpu_is_omap242x()) {
-		u32 l;
-		l = omap_readl(OMAP242X_CONTROL_STATUS);
-		/* In case of internal boot the 1st MB is redirected to the
-		 * boot ROM memory space.
-		 */
-		if (l & (1 << 3))
-			boot_rom_space = BOOT_ROM_SPACE;
-	} else
-		/* We assume internal boot if the mode can't be
-		 * determined.
-		 */
-		boot_rom_space = BOOT_ROM_SPACE;
+	/* never allocate the first page, to facilitate bug detection;
+	 * even if we didn't boot from ROM.
+	 */
+	boot_rom_space = BOOT_ROM_SPACE;
+	/* In apollon the CS0 is mapped as 0x0000 0000 */
+	if (machine_is_omap_apollon())
+		boot_rom_space = 0;
 	gpmc_mem_root.start = GPMC_MEM_START + boot_rom_space;
 	gpmc_mem_root.end = GPMC_MEM_END;
 
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

arm-omap-fix-gpmc-compiler-errors.patch
git-mtd.patch

