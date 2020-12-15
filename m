Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81694C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BF122D02
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgLOX7S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgLOXW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:58 -0500
Date:   Tue, 15 Dec 2020 15:20:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074457;
        bh=ucyiMaNRFgDZKMxPs71jRsyYwiGGzQdc5leJsWRtYoA=;
        h=From:To:Subject:From;
        b=yyJnCZvJ4qgcuZSI1+v+4CNx80EvLLvo1+8MV6sAXiNJxAtMkOIKse2wAwFRrpUhN
         ucdDGJMh7imX0IWxJ4yDHUqeSkUhJMZ8WRtGrBFaYwSe/ZYkDPVbe2mbWaRt+Wk46F
         //sUi2X32grie5fDlVtM2ZJKyu4luaDsw2e2ZBH8=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 arm-remove-config_arch_has_holes_memorymodel.patch removed from -mm tree
Message-ID: <20201215232056.j8xYCEe7R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
has been removed from the -mm tree.  Its filename was
     arm-remove-config_arch_has_holes_memorymodel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL

ARM is the only architecture that defines CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
which in turn enables memmap_valid_within() function that is intended to
verify existence  of struct page associated with a pfn when there are holes
in the memory map.

However, the ARCH_HAS_HOLES_MEMORYMODEL also enables HAVE_ARCH_PFN_VALID
and arch-specific pfn_valid() implementation that also deals with the holes
in the memory map.

The only two users of memmap_valid_within() call this function after
a call to pfn_valid() so the memmap_valid_within() check becomes redundant.

Remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL and memmap_valid_within() and rely
entirely on ARM's implementation of pfn_valid() that is now enabled
unconditionally.

Link: https://lkml.kernel.org/r/20201101170454.9567-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/memory-model.rst |    3 --
 arch/arm/Kconfig                  |    8 +------
 arch/arm/mach-bcm/Kconfig         |    1 
 arch/arm/mach-davinci/Kconfig     |    1 
 arch/arm/mach-exynos/Kconfig      |    1 
 arch/arm/mach-highbank/Kconfig    |    1 
 arch/arm/mach-omap2/Kconfig       |    1 
 arch/arm/mach-s5pv210/Kconfig     |    1 
 arch/arm/mach-tango/Kconfig       |    1 
 fs/proc/kcore.c                   |    2 -
 include/linux/mmzone.h            |   31 ----------------------------
 mm/mmzone.c                       |   14 ------------
 mm/vmstat.c                       |    4 ---
 13 files changed, 3 insertions(+), 66 deletions(-)

--- a/arch/arm/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/Kconfig
@@ -25,7 +25,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_KEEP_MEMBLOCK if HAVE_ARCH_PFN_VALID || KEXEC
+	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_NO_SG_CHAIN if !ARM_HAS_SG_CHAIN
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
@@ -520,7 +520,6 @@ config ARCH_S3C24XX
 config ARCH_OMAP1
 	bool "TI OMAP1"
 	depends on MMU
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
@@ -1480,9 +1479,6 @@ config OABI_COMPAT
 	  UNPREDICTABLE (in fact it can be predicted that it won't work
 	  at all). If in doubt say N.
 
-config ARCH_HAS_HOLES_MEMORYMODEL
-	bool
-
 config ARCH_SELECT_MEMORY_MODEL
 	bool
 
@@ -1494,7 +1490,7 @@ config ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_STATIC if SPARSEMEM
 
 config HAVE_ARCH_PFN_VALID
-	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
+	def_bool y
 
 config HIGHMEM
 	bool "High Memory Support"
--- a/arch/arm/mach-bcm/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-bcm/Kconfig
@@ -211,7 +211,6 @@ config ARCH_BRCMSTB
 	select BCM7038_L1_IRQ
 	select BRCMSTB_L2_IRQ
 	select BCM7120_L2_IRQ
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ZONE_DMA if ARM_LPAE
 	select SOC_BRCMSTB
 	select SOC_BUS
--- a/arch/arm/mach-davinci/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-davinci/Kconfig
@@ -5,7 +5,6 @@ menuconfig ARCH_DAVINCI
 	depends on ARCH_MULTI_V5
 	select DAVINCI_TIMER
 	select ZONE_DMA
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select PM_GENERIC_DOMAINS if PM
 	select PM_GENERIC_DOMAINS_OF if PM && OF
 	select REGMAP_MMIO
--- a/arch/arm/mach-exynos/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-exynos/Kconfig
@@ -8,7 +8,6 @@
 menuconfig ARCH_EXYNOS
 	bool "Samsung Exynos"
 	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
--- a/arch/arm/mach-highbank/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-highbank/Kconfig
@@ -2,7 +2,6 @@
 config ARCH_HIGHBANK
 	bool "Calxeda ECX-1000/2000 (Highbank/Midway)"
 	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_ERRATA_764369 if SMP
--- a/arch/arm/mach-omap2/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-omap2/Kconfig
@@ -93,7 +93,6 @@ config SOC_DRA7XX
 config ARCH_OMAP2PLUS
 	bool
 	select ARCH_HAS_BANDGAP
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_OMAP
 	select CLKSRC_MMIO
--- a/arch/arm/mach-s5pv210/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-s5pv210/Kconfig
@@ -8,7 +8,6 @@
 config ARCH_S5PV210
 	bool "Samsung S5PV210/S5PC110"
 	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARM_VIC
 	select CLKSRC_SAMSUNG_PWM
 	select COMMON_CLK_SAMSUNG
--- a/arch/arm/mach-tango/Kconfig~arm-remove-config_arch_has_holes_memorymodel
+++ a/arch/arm/mach-tango/Kconfig
@@ -3,7 +3,6 @@ config ARCH_TANGO
 	bool "Sigma Designs Tango4 (SMP87xx)"
 	depends on ARCH_MULTI_V7
 	# Cortex-A9 MPCore r3p0, PL310 r3p2
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_ERRATA_775420
--- a/Documentation/vm/memory-model.rst~arm-remove-config_arch_has_holes_memorymodel
+++ a/Documentation/vm/memory-model.rst
@@ -51,8 +51,7 @@ call :c:func:`free_area_init` function.
 usable until the call to :c:func:`memblock_free_all` that hands all the
 memory to the page allocator.
 
-If an architecture enables `CONFIG_ARCH_HAS_HOLES_MEMORYMODEL` option,
-it may free parts of the `mem_map` array that do not cover the
+An architecture may free parts of the `mem_map` array that do not cover the
 actual physical pages. In such case, the architecture specific
 :c:func:`pfn_valid` implementation should take the holes in the
 `mem_map` into account.
--- a/fs/proc/kcore.c~arm-remove-config_arch_has_holes_memorymodel
+++ a/fs/proc/kcore.c
@@ -193,8 +193,6 @@ kclist_add_private(unsigned long pfn, un
 		return 1;
 
 	p = pfn_to_page(pfn);
-	if (!memmap_valid_within(pfn, p, page_zone(p)))
-		return 1;
 
 	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
 	if (!ent)
--- a/include/linux/mmzone.h~arm-remove-config_arch_has_holes_memorymodel
+++ a/include/linux/mmzone.h
@@ -1440,37 +1440,6 @@ void sparse_init(void);
 #define pfn_valid_within(pfn) (1)
 #endif
 
-#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
-/*
- * pfn_valid() is meant to be able to tell if a given PFN has valid memmap
- * associated with it or not. This means that a struct page exists for this
- * pfn. The caller cannot assume the page is fully initialized in general.
- * Hotplugable pages might not have been onlined yet. pfn_to_online_page()
- * will ensure the struct page is fully online and initialized. Special pages
- * (e.g. ZONE_DEVICE) are never onlined and should be treated accordingly.
- *
- * In FLATMEM, it is expected that holes always have valid memmap as long as
- * there is valid PFNs either side of the hole. In SPARSEMEM, it is assumed
- * that a valid section has a memmap for the entire section.
- *
- * However, an ARM, and maybe other embedded architectures in the future
- * free memmap backing holes to save memory on the assumption the memmap is
- * never used. The page_zone linkages are then broken even though pfn_valid()
- * returns true. A walker of the full memmap must then do this additional
- * check to ensure the memmap they are looking at is sane by making sure
- * the zone and PFN linkages are still valid. This is expensive, but walkers
- * of the full memmap are extremely rare.
- */
-bool memmap_valid_within(unsigned long pfn,
-					struct page *page, struct zone *zone);
-#else
-static inline bool memmap_valid_within(unsigned long pfn,
-					struct page *page, struct zone *zone)
-{
-	return true;
-}
-#endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
-
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
--- a/mm/mmzone.c~arm-remove-config_arch_has_holes_memorymodel
+++ a/mm/mmzone.c
@@ -72,20 +72,6 @@ struct zoneref *__next_zones_zonelist(st
 	return z;
 }
 
-#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
-bool memmap_valid_within(unsigned long pfn,
-					struct page *page, struct zone *zone)
-{
-	if (page_to_pfn(page) != pfn)
-		return false;
-
-	if (page_zone(page) != zone)
-		return false;
-
-	return true;
-}
-#endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
-
 void lruvec_init(struct lruvec *lruvec)
 {
 	enum lru_list lru;
--- a/mm/vmstat.c~arm-remove-config_arch_has_holes_memorymodel
+++ a/mm/vmstat.c
@@ -1503,10 +1503,6 @@ static void pagetypeinfo_showblockcount_
 		if (!page)
 			continue;
 
-		/* Watch for unexpected holes punched in the memmap */
-		if (!memmap_valid_within(pfn, page, zone))
-			continue;
-
 		if (page_zone(page) != zone)
 			continue;
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

