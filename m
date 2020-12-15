Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D61C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF1622CAE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgLOX7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgLOXWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:37 -0500
Date:   Tue, 15 Dec 2020 15:20:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074460;
        bh=OQOsZJx+6IitvXe6hxyqUmilKWTEzwlgfoiX6fsF6vk=;
        h=From:To:Subject:From;
        b=hkZOWfK1toyJE8cBR5otMrudQg7UJbiTPu5fwG/Je1zsmVWTFQliOKoMbsurYgNiT
         KoKtLprfVnlEwC874A/0fpCLwvNW1D2zAAVYOkkuZWv/NCQ2HaMBBWsQaa90frQRlt
         Hfmo0p1Ia6NukqmJhA2FRtV1p8vqqf8WCcVj6w3o=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 arm-arm64-move-free_unused_memmap-to-generic-mm.patch removed from -mm tree
Message-ID: <20201215232059.TbxBY-oVH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm, arm64: move free_unused_memmap() to generic mm
has been removed from the -mm tree.  Its filename was
     arm-arm64-move-free_unused_memmap-to-generic-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm, arm64: move free_unused_memmap() to generic mm

ARM and ARM64 free unused parts of the memory map just before the
initialization of the page allocator. To allow holes in the memory map both
architectures overload pfn_valid() and define HAVE_ARCH_PFN_VALID.

Allowing holes in the memory map for FLATMEM may be useful for small
machines, such as ARC and m68k and will enable those architectures to cease
using DISCONTIGMEM and still support more than one memory bank.

Move the functions that free unused memory map to generic mm and enable
them in case HAVE_ARCH_PFN_VALID=y.

Link: https://lkml.kernel.org/r/20201101170454.9567-10-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Alexey Dobriyan <adobriyan@gmail.com>
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

 arch/Kconfig         |    3 +
 arch/arm/Kconfig     |    4 --
 arch/arm/mm/init.c   |   78 ---------------------------------------
 arch/arm64/Kconfig   |    4 --
 arch/arm64/mm/init.c |   68 ----------------------------------
 mm/memblock.c        |   80 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+), 152 deletions(-)

--- a/arch/arm64/Kconfig~arm-arm64-move-free_unused_memmap-to-generic-mm
+++ a/arch/arm64/Kconfig
@@ -140,6 +140,7 @@ config ARM64
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
+	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_PREL32_RELOCATIONS
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_STACKLEAK
@@ -1043,9 +1044,6 @@ config ARCH_SELECT_MEMORY_MODEL
 config ARCH_FLATMEM_ENABLE
 	def_bool !NUMA
 
-config HAVE_ARCH_PFN_VALID
-	def_bool y
-
 config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
--- a/arch/arm64/mm/init.c~arm-arm64-move-free_unused_memmap-to-generic-mm
+++ a/arch/arm64/mm/init.c
@@ -430,71 +430,6 @@ void __init bootmem_init(void)
 	memblock_dump_all();
 }
 
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static inline void free_memmap(unsigned long start_pfn, unsigned long end_pfn)
-{
-	struct page *start_pg, *end_pg;
-	unsigned long pg, pgend;
-
-	/*
-	 * Convert start_pfn/end_pfn to a struct page pointer.
-	 */
-	start_pg = pfn_to_page(start_pfn - 1) + 1;
-	end_pg = pfn_to_page(end_pfn - 1) + 1;
-
-	/*
-	 * Convert to physical addresses, and round start upwards and end
-	 * downwards.
-	 */
-	pg = (unsigned long)PAGE_ALIGN(__pa(start_pg));
-	pgend = (unsigned long)__pa(end_pg) & PAGE_MASK;
-
-	/*
-	 * If there are free pages between these, free the section of the
-	 * memmap array.
-	 */
-	if (pg < pgend)
-		memblock_free(pg, pgend - pg);
-}
-
-/*
- * The mem_map array can get very big. Free the unused area of the memory map.
- */
-static void __init free_unused_memmap(void)
-{
-	unsigned long start, end, prev_end = 0;
-	int i;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
-#ifdef CONFIG_SPARSEMEM
-		/*
-		 * Take care not to free memmap entries that don't exist due
-		 * to SPARSEMEM sections which aren't present.
-		 */
-		start = min(start, ALIGN(prev_end, PAGES_PER_SECTION));
-#endif
-		/*
-		 * If we had a previous bank, and there is a space between the
-		 * current bank and the previous, free it.
-		 */
-		if (prev_end && prev_end < start)
-			free_memmap(prev_end, start);
-
-		/*
-		 * Align up here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank end aligned to
-		 * MAX_ORDER_NR_PAGES.
-		 */
-		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
-	}
-
-#ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
-		free_memmap(prev_end, ALIGN(prev_end, PAGES_PER_SECTION));
-#endif
-}
-#endif	/* !CONFIG_SPARSEMEM_VMEMMAP */
-
 /*
  * mem_init() marks the free areas in the mem_map and tells us how much memory
  * is free.  This is done after various parts of the system have claimed their
@@ -510,9 +445,6 @@ void __init mem_init(void)
 
 	set_max_mapnr(max_pfn - PHYS_PFN_OFFSET);
 
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-	free_unused_memmap();
-#endif
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
 
--- a/arch/arm/Kconfig~arm-arm64-move-free_unused_memmap-to-generic-mm
+++ a/arch/arm/Kconfig
@@ -69,6 +69,7 @@ config ARM
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
+	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
@@ -1489,9 +1490,6 @@ config ARCH_SPARSEMEM_ENABLE
 	bool
 	select SPARSEMEM_STATIC if SPARSEMEM
 
-config HAVE_ARCH_PFN_VALID
-	def_bool y
-
 config HIGHMEM
 	bool "High Memory Support"
 	depends on MMU
--- a/arch/arm/mm/init.c~arm-arm64-move-free_unused_memmap-to-generic-mm
+++ a/arch/arm/mm/init.c
@@ -267,83 +267,6 @@ static inline void poison_init_mem(void
 		*p++ = 0xe7fddef0;
 }
 
-static inline void __init
-free_memmap(unsigned long start_pfn, unsigned long end_pfn)
-{
-	struct page *start_pg, *end_pg;
-	phys_addr_t pg, pgend;
-
-	/*
-	 * Convert start_pfn/end_pfn to a struct page pointer.
-	 */
-	start_pg = pfn_to_page(start_pfn - 1) + 1;
-	end_pg = pfn_to_page(end_pfn - 1) + 1;
-
-	/*
-	 * Convert to physical addresses, and
-	 * round start upwards and end downwards.
-	 */
-	pg = PAGE_ALIGN(__pa(start_pg));
-	pgend = __pa(end_pg) & PAGE_MASK;
-
-	/*
-	 * If there are free pages between these,
-	 * free the section of the memmap array.
-	 */
-	if (pg < pgend)
-		memblock_free_early(pg, pgend - pg);
-}
-
-/*
- * The mem_map array can get very big.  Free the unused area of the memory map.
- */
-static void __init free_unused_memmap(void)
-{
-	unsigned long start, end, prev_end = 0;
-	int i;
-
-	/*
-	 * This relies on each bank being in address order.
-	 * The banks are sorted previously in bootmem_init().
-	 */
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
-#ifdef CONFIG_SPARSEMEM
-		/*
-		 * Take care not to free memmap entries that don't exist
-		 * due to SPARSEMEM sections which aren't present.
-		 */
-		start = min(start,
-				 ALIGN(prev_end, PAGES_PER_SECTION));
-#else
-		/*
-		 * Align down here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank start aligned to
-		 * MAX_ORDER_NR_PAGES.
-		 */
-		start = round_down(start, MAX_ORDER_NR_PAGES);
-#endif
-		/*
-		 * If we had a previous bank, and there is a space
-		 * between the current bank and the previous, free it.
-		 */
-		if (prev_end && prev_end < start)
-			free_memmap(prev_end, start);
-
-		/*
-		 * Align up here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank end aligned to
-		 * MAX_ORDER_NR_PAGES.
-		 */
-		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
-	}
-
-#ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
-		free_memmap(prev_end,
-			    ALIGN(prev_end, PAGES_PER_SECTION));
-#endif
-}
-
 static void __init free_highpages(void)
 {
 #ifdef CONFIG_HIGHMEM
@@ -385,7 +308,6 @@ void __init mem_init(void)
 	set_max_mapnr(pfn_to_page(max_pfn) - mem_map);
 
 	/* this will put all unused low memory onto the freelists */
-	free_unused_memmap();
 	memblock_free_all();
 
 #ifdef CONFIG_SA1111
--- a/arch/Kconfig~arm-arm64-move-free_unused_memmap-to-generic-mm
+++ a/arch/Kconfig
@@ -1044,6 +1044,9 @@ config ARCH_WANT_LD_ORPHAN_WARN
 	  by the linker, since the locations of such sections can change between linker
 	  versions.
 
+config HAVE_ARCH_PFN_VALID
+	bool
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
--- a/mm/memblock.c~arm-arm64-move-free_unused_memmap-to-generic-mm
+++ a/mm/memblock.c
@@ -1926,6 +1926,85 @@ static int __init early_memblock(char *p
 }
 early_param("memblock", early_memblock);
 
+static void __init free_memmap(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct page *start_pg, *end_pg;
+	phys_addr_t pg, pgend;
+
+	/*
+	 * Convert start_pfn/end_pfn to a struct page pointer.
+	 */
+	start_pg = pfn_to_page(start_pfn - 1) + 1;
+	end_pg = pfn_to_page(end_pfn - 1) + 1;
+
+	/*
+	 * Convert to physical addresses, and round start upwards and end
+	 * downwards.
+	 */
+	pg = PAGE_ALIGN(__pa(start_pg));
+	pgend = __pa(end_pg) & PAGE_MASK;
+
+	/*
+	 * If there are free pages between these, free the section of the
+	 * memmap array.
+	 */
+	if (pg < pgend)
+		memblock_free(pg, pgend - pg);
+}
+
+/*
+ * The mem_map array can get very big.  Free the unused area of the memory map.
+ */
+static void __init free_unused_memmap(void)
+{
+	unsigned long start, end, prev_end = 0;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) ||
+	    IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
+		return;
+
+	/*
+	 * This relies on each bank being in address order.
+	 * The banks are sorted previously in bootmem_init().
+	 */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
+#ifdef CONFIG_SPARSEMEM
+		/*
+		 * Take care not to free memmap entries that don't exist
+		 * due to SPARSEMEM sections which aren't present.
+		 */
+		start = min(start, ALIGN(prev_end, PAGES_PER_SECTION));
+#else
+		/*
+		 * Align down here since the VM subsystem insists that the
+		 * memmap entries are valid from the bank start aligned to
+		 * MAX_ORDER_NR_PAGES.
+		 */
+		start = round_down(start, MAX_ORDER_NR_PAGES);
+#endif
+
+		/*
+		 * If we had a previous bank, and there is a space
+		 * between the current bank and the previous, free it.
+		 */
+		if (prev_end && prev_end < start)
+			free_memmap(prev_end, start);
+
+		/*
+		 * Align up here since the VM subsystem insists that the
+		 * memmap entries are valid from the bank end aligned to
+		 * MAX_ORDER_NR_PAGES.
+		 */
+		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
+	}
+
+#ifdef CONFIG_SPARSEMEM
+	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
+		free_memmap(prev_end, ALIGN(prev_end, PAGES_PER_SECTION));
+#endif
+}
+
 static void __init __free_pages_memory(unsigned long start, unsigned long end)
 {
 	int order;
@@ -2012,6 +2091,7 @@ unsigned long __init memblock_free_all(v
 {
 	unsigned long pages;
 
+	free_unused_memmap();
 	reset_all_zones_managed_pages();
 
 	pages = free_low_memory_core_early();
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

