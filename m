Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3677578F37
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741899728; cv=none; b=pO2qehPASNnw5K35C9sa8muebpcnxTeiGhfWNks76CWB0xgkgCCqcZXsNUmOkNGYBdUzondx2q4lfK6e740YvfwuXuQ2yJ7xmS0wSooTwRX9YDRiQ4E6okVZvGazQtUHMiUGDv+qKTBH4T39muMYGgNesQzG0Cx+q1Z7UEVkcT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741899728; c=relaxed/simple;
	bh=4hbdYUSGGBdVfLgdtRwtA14ZLnEU9F6ey1xuRzXrmfE=;
	h=Date:To:From:Subject:Message-Id; b=MWgey9q7l0pMyuLC69ksWF0bsZENzHHL/YuA4L+ctyl4CmgWzi8eGKByWXH0N/d15jISIXY3Pbc32SgEH/1lcMprnQJkOWhRwypIw3H2nZ0mvePfelPAYSau0TCkw145Qr0FhOUBI6jvJLFSNAmHry474ElvveXjSHhgyKjsdQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bZIknEMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bZIknEMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C36C4CEDD;
	Thu, 13 Mar 2025 21:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741899728;
	bh=4hbdYUSGGBdVfLgdtRwtA14ZLnEU9F6ey1xuRzXrmfE=;
	h=Date:To:From:Subject:From;
	b=bZIknEMHw97SG5nLu222yPWpHJNPKxcyYPPHZkeGUMHbChrOfDvLGmk+2oBsZU0SE
	 +l7NQwGl+WRZ81ErtWhHsig6ZtT649xcj166tVOup3MdAXPRnt5ROHCA8YyRMKeT5t
	 Fqq5qB7d7knLXF/J6lGKNw04ts99eDZwv/B//Z8s=
Date: Thu, 13 Mar 2025 14:02:07 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-mm-streamline-highmem-freeing.patch added to mm-unstable branch
Message-Id: <20250313210208.00C36C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch, mm: streamline HIGHMEM freeing
has been added to the -mm mm-unstable branch.  Its filename is
     arch-mm-streamline-highmem-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-mm-streamline-highmem-freeing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch, mm: streamline HIGHMEM freeing
Date: Thu, 13 Mar 2025 15:50:01 +0200

All architectures that support HIGHMEM have their code that frees high
memory pages to the buddy allocator while __free_memory_core() is limited
to freeing only low memory.

There is no actual reason for that.  The memory map is completely ready by
the time memblock_free_all() is called and high pages can be released to
the buddy allocator along with low memory.

Remove low memory limit from __free_memory_core() and drop per-architecture
code that frees high memory pages.

Link: https://lkml.kernel.org/r/20250313135003.836600-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>	[x86]
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren (csky) <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c             |    6 -----
 arch/arm/mm/init.c             |   29 --------------------------
 arch/csky/mm/init.c            |   14 ------------
 arch/microblaze/mm/init.c      |   16 --------------
 arch/mips/mm/init.c            |   20 ------------------
 arch/powerpc/mm/mem.c          |   14 ------------
 arch/sparc/mm/init_32.c        |   25 ----------------------
 arch/x86/include/asm/highmem.h |    3 --
 arch/x86/include/asm/numa.h    |    4 ---
 arch/x86/include/asm/numa_32.h |   13 -----------
 arch/x86/mm/Makefile           |    2 -
 arch/x86/mm/highmem_32.c       |   34 -------------------------------
 arch/x86/mm/init_32.c          |   28 -------------------------
 arch/xtensa/mm/init.c          |   29 --------------------------
 include/linux/mm.h             |    1 
 mm/memblock.c                  |    3 --
 16 files changed, 2 insertions(+), 239 deletions(-)

--- a/arch/arc/mm/init.c~arch-mm-streamline-highmem-freeing
+++ a/arch/arc/mm/init.c
@@ -160,11 +160,7 @@ void __init setup_arch_memory(void)
 static void __init highmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
-	unsigned long tmp;
-
 	memblock_phys_free(high_mem_start, high_mem_sz);
-	for (tmp = min_high_pfn; tmp < max_high_pfn; tmp++)
-		free_highmem_page(pfn_to_page(tmp));
 #endif
 }
 
@@ -176,8 +172,8 @@ static void __init highmem_init(void)
  */
 void __init mem_init(void)
 {
-	memblock_free_all();
 	highmem_init();
+	memblock_free_all();
 
 	BUILD_BUG_ON((PTRS_PER_PGD * sizeof(pgd_t)) > PAGE_SIZE);
 	BUILD_BUG_ON((PTRS_PER_PUD * sizeof(pud_t)) > PAGE_SIZE);
--- a/arch/arm/mm/init.c~arch-mm-streamline-highmem-freeing
+++ a/arch/arm/mm/init.c
@@ -237,33 +237,6 @@ static inline void poison_init_mem(void
 		*p++ = 0xe7fddef0;
 }
 
-static void __init free_highpages(void)
-{
-#ifdef CONFIG_HIGHMEM
-	unsigned long max_low = max_low_pfn;
-	phys_addr_t range_start, range_end;
-	u64 i;
-
-	/* set highmem page free */
-	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
-				&range_start, &range_end, NULL) {
-		unsigned long start = PFN_UP(range_start);
-		unsigned long end = PFN_DOWN(range_end);
-
-		/* Ignore complete lowmem entries */
-		if (end <= max_low)
-			continue;
-
-		/* Truncate partial highmem entries */
-		if (start < max_low)
-			start = max_low;
-
-		for (; start < end; start++)
-			free_highmem_page(pfn_to_page(start));
-	}
-#endif
-}
-
 /*
  * mem_init() marks the free areas in the mem_map and tells us how much
  * memory is free.  This is done after various parts of the system have
@@ -283,8 +256,6 @@ void __init mem_init(void)
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
 
-	free_highpages();
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
 	 * be detected at build time already.
--- a/arch/csky/mm/init.c~arch-mm-streamline-highmem-freeing
+++ a/arch/csky/mm/init.c
@@ -44,21 +44,7 @@ EXPORT_SYMBOL(empty_zero_page);
 
 void __init mem_init(void)
 {
-#ifdef CONFIG_HIGHMEM
-	unsigned long tmp;
-#endif
-
 	memblock_free_all();
-
-#ifdef CONFIG_HIGHMEM
-	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
-		struct page *page = pfn_to_page(tmp);
-
-		/* FIXME not sure about */
-		if (!memblock_is_reserved(tmp << PAGE_SHIFT))
-			free_highmem_page(page);
-	}
-#endif
 }
 
 void free_initmem(void)
--- a/arch/microblaze/mm/init.c~arch-mm-streamline-highmem-freeing
+++ a/arch/microblaze/mm/init.c
@@ -52,19 +52,6 @@ static void __init highmem_init(void)
 	map_page(PKMAP_BASE, 0, 0);	/* XXX gross */
 	pkmap_page_table = virt_to_kpte(PKMAP_BASE);
 }
-
-static void __meminit highmem_setup(void)
-{
-	unsigned long pfn;
-
-	for (pfn = max_low_pfn; pfn < max_pfn; ++pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		/* FIXME not sure about */
-		if (!memblock_is_reserved(pfn << PAGE_SHIFT))
-			free_highmem_page(page);
-	}
-}
 #endif /* CONFIG_HIGHMEM */
 
 /*
@@ -122,9 +109,6 @@ void __init mem_init(void)
 {
 	/* this will put all memory onto the freelists */
 	memblock_free_all();
-#ifdef CONFIG_HIGHMEM
-	highmem_setup();
-#endif
 
 	mem_init_done = 1;
 }
--- a/arch/mips/mm/init.c~arch-mm-streamline-highmem-freeing
+++ a/arch/mips/mm/init.c
@@ -425,25 +425,6 @@ void __init paging_init(void)
 static struct kcore_list kcore_kseg0;
 #endif
 
-static inline void __init mem_init_free_highmem(void)
-{
-#ifdef CONFIG_HIGHMEM
-	unsigned long tmp;
-
-	if (cpu_has_dc_aliases)
-		return;
-
-	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
-		struct page *page = pfn_to_page(tmp);
-
-		if (!memblock_is_memory(PFN_PHYS(tmp)))
-			SetPageReserved(page);
-		else
-			free_highmem_page(page);
-	}
-#endif
-}
-
 void __init mem_init(void)
 {
 	/*
@@ -454,7 +435,6 @@ void __init mem_init(void)
 
 	maar_init();
 	setup_zero_pages();	/* Setup zeroed pages.  */
-	mem_init_free_highmem();
 	memblock_free_all();
 
 #ifdef CONFIG_64BIT
--- a/arch/powerpc/mm/mem.c~arch-mm-streamline-highmem-freeing
+++ a/arch/powerpc/mm/mem.c
@@ -297,20 +297,6 @@ void __init mem_init(void)
 
 	memblock_free_all();
 
-#ifdef CONFIG_HIGHMEM
-	{
-		unsigned long pfn, highmem_mapnr;
-
-		highmem_mapnr = lowmem_end_addr >> PAGE_SHIFT;
-		for (pfn = highmem_mapnr; pfn < max_mapnr; ++pfn) {
-			phys_addr_t paddr = (phys_addr_t)pfn << PAGE_SHIFT;
-			struct page *page = pfn_to_page(pfn);
-			if (memblock_is_memory(paddr) && !memblock_is_reserved(paddr))
-				free_highmem_page(page);
-		}
-	}
-#endif /* CONFIG_HIGHMEM */
-
 #if defined(CONFIG_PPC_E500) && !defined(CONFIG_SMP)
 	/*
 	 * If smp is enabled, next_tlbcam_idx is initialized in the cpu up
--- a/arch/sparc/mm/init_32.c~arch-mm-streamline-highmem-freeing
+++ a/arch/sparc/mm/init_32.c
@@ -232,18 +232,6 @@ static void __init taint_real_pages(void
 	}
 }
 
-static void map_high_region(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long tmp;
-
-#ifdef CONFIG_DEBUG_HIGHMEM
-	printk("mapping high region %08lx - %08lx\n", start_pfn, end_pfn);
-#endif
-
-	for (tmp = start_pfn; tmp < end_pfn; tmp++)
-		free_highmem_page(pfn_to_page(tmp));
-}
-
 void __init mem_init(void)
 {
 	int i;
@@ -276,19 +264,6 @@ void __init mem_init(void)
 	taint_real_pages();
 
 	memblock_free_all();
-
-	for (i = 0; sp_banks[i].num_bytes != 0; i++) {
-		unsigned long start_pfn = sp_banks[i].base_addr >> PAGE_SHIFT;
-		unsigned long end_pfn = (sp_banks[i].base_addr + sp_banks[i].num_bytes) >> PAGE_SHIFT;
-
-		if (end_pfn <= highstart_pfn)
-			continue;
-
-		if (start_pfn < highstart_pfn)
-			start_pfn = highstart_pfn;
-
-		map_high_region(start_pfn, end_pfn);
-	}
 }
 
 void sparc_flush_page_to_ram(struct page *page)
--- a/arch/x86/include/asm/highmem.h~arch-mm-streamline-highmem-freeing
+++ a/arch/x86/include/asm/highmem.h
@@ -69,9 +69,6 @@ extern unsigned long highstart_pfn, high
 		arch_flush_lazy_mmu_mode();		\
 	} while (0)
 
-extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_HIGHMEM_H */
diff --git a/arch/x86/include/asm/numa_32.h a/arch/x86/include/asm/numa_32.h
deleted file mode 100644
--- a/arch/x86/include/asm/numa_32.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_X86_NUMA_32_H
-#define _ASM_X86_NUMA_32_H
-
-#ifdef CONFIG_HIGHMEM
-extern void set_highmem_pages_init(void);
-#else
-static inline void set_highmem_pages_init(void)
-{
-}
-#endif
-
-#endif /* _ASM_X86_NUMA_32_H */
--- a/arch/x86/include/asm/numa.h~arch-mm-streamline-highmem-freeing
+++ a/arch/x86/include/asm/numa.h
@@ -41,10 +41,6 @@ static inline int numa_cpu_node(int cpu)
 }
 #endif	/* CONFIG_NUMA */
 
-#ifdef CONFIG_X86_32
-# include <asm/numa_32.h>
-#endif
-
 #ifdef CONFIG_NUMA
 extern void numa_set_node(int cpu, int node);
 extern void numa_clear_node(int cpu);
diff --git a/arch/x86/mm/highmem_32.c a/arch/x86/mm/highmem_32.c
deleted file mode 100644
--- a/arch/x86/mm/highmem_32.c
+++ /dev/null
@@ -1,34 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-#include <linux/highmem.h>
-#include <linux/export.h>
-#include <linux/swap.h> /* for totalram_pages */
-#include <linux/memblock.h>
-#include <asm/numa.h>
-
-void __init set_highmem_pages_init(void)
-{
-	struct zone *zone;
-	int nid;
-
-	/*
-	 * Explicitly reset zone->managed_pages because set_highmem_pages_init()
-	 * is invoked before memblock_free_all()
-	 */
-	reset_all_zones_managed_pages();
-	for_each_zone(zone) {
-		unsigned long zone_start_pfn, zone_end_pfn;
-
-		if (!is_highmem(zone))
-			continue;
-
-		zone_start_pfn = zone->zone_start_pfn;
-		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
-
-		nid = zone_to_nid(zone);
-		printk(KERN_INFO "Initializing %s for node %d (%08lx:%08lx)\n",
-				zone->name, nid, zone_start_pfn, zone_end_pfn);
-
-		add_highpages_with_active_regions(nid, zone_start_pfn,
-				 zone_end_pfn);
-	}
-}
--- a/arch/x86/mm/init_32.c~arch-mm-streamline-highmem-freeing
+++ a/arch/x86/mm/init_32.c
@@ -394,23 +394,6 @@ static void __init permanent_kmaps_init(
 
 	pkmap_page_table = virt_to_kpte(vaddr);
 }
-
-void __init add_highpages_with_active_regions(int nid,
-			 unsigned long start_pfn, unsigned long end_pfn)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
-		unsigned long pfn = clamp_t(unsigned long, PFN_UP(start),
-					    start_pfn, end_pfn);
-		unsigned long e_pfn = clamp_t(unsigned long, PFN_DOWN(end),
-					      start_pfn, end_pfn);
-		for ( ; pfn < e_pfn; pfn++)
-			if (pfn_valid(pfn))
-				free_highmem_page(pfn_to_page(pfn));
-	}
-}
 #else
 static inline void permanent_kmaps_init(pgd_t *pgd_base)
 {
@@ -715,17 +698,6 @@ void __init mem_init(void)
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
-	/*
-	 * With CONFIG_DEBUG_PAGEALLOC initialization of highmem pages has to
-	 * be done before memblock_free_all(). Memblock use free low memory for
-	 * temporary data (see find_range_array()) and for this purpose can use
-	 * pages that was already passed to the buddy allocator, hence marked as
-	 * not accessible in the page tables when compiled with
-	 * CONFIG_DEBUG_PAGEALLOC. Otherwise order of initialization is not
-	 * important here.
-	 */
-	set_highmem_pages_init();
-
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
 
--- a/arch/x86/mm/Makefile~arch-mm-streamline-highmem-freeing
+++ a/arch/x86/mm/Makefile
@@ -42,8 +42,6 @@ obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpag
 obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= debug_pagetables.o
 
-obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
-
 KASAN_SANITIZE_kasan_init_$(BITS).o := n
 obj-$(CONFIG_KASAN)		+= kasan_init_$(BITS).o
 
--- a/arch/xtensa/mm/init.c~arch-mm-streamline-highmem-freeing
+++ a/arch/xtensa/mm/init.c
@@ -129,41 +129,12 @@ void __init zones_init(void)
 	print_vm_layout();
 }
 
-static void __init free_highpages(void)
-{
-#ifdef CONFIG_HIGHMEM
-	unsigned long max_low = max_low_pfn;
-	phys_addr_t range_start, range_end;
-	u64 i;
-
-	/* set highmem page free */
-	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
-				&range_start, &range_end, NULL) {
-		unsigned long start = PFN_UP(range_start);
-		unsigned long end = PFN_DOWN(range_end);
-
-		/* Ignore complete lowmem entries */
-		if (end <= max_low)
-			continue;
-
-		/* Truncate partial highmem entries */
-		if (start < max_low)
-			start = max_low;
-
-		for (; start < end; start++)
-			free_highmem_page(pfn_to_page(start));
-	}
-#endif
-}
-
 /*
  * Initialize memory pages.
  */
 
 void __init mem_init(void)
 {
-	free_highpages();
-
 	memblock_free_all();
 }
 
--- a/include/linux/mm.h~arch-mm-streamline-highmem-freeing
+++ a/include/linux/mm.h
@@ -3275,7 +3275,6 @@ extern void reserve_bootmem_region(phys_
 
 /* Free the reserved page into the buddy system, so it gets managed. */
 void free_reserved_page(struct page *page);
-#define free_highmem_page(page) free_reserved_page(page)
 
 static inline void mark_page_reserved(struct page *page)
 {
--- a/mm/memblock.c~arch-mm-streamline-highmem-freeing
+++ a/mm/memblock.c
@@ -2164,8 +2164,7 @@ static unsigned long __init __free_memor
 				 phys_addr_t end)
 {
 	unsigned long start_pfn = PFN_UP(start);
-	unsigned long end_pfn = min_t(unsigned long,
-				      PFN_DOWN(end), max_low_pfn);
+	unsigned long end_pfn = PFN_DOWN(end);
 
 	if (start_pfn >= end_pfn)
 		return 0;
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch
csky-move-setup_initrd-to-setupc.patch
hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch
mips-consolidate-mem_init-for-numa-machines.patch
mips-make-setup_zero_pages-use-memblock.patch
nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch
s390-make-setup_zero_pages-use-memblock.patch
xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch
arch-mm-set-max_mapnr-when-allocating-memory-map-for-flatmem.patch
arch-mm-set-high_memory-in-free_area_init.patch
arch-mm-streamline-highmem-freeing.patch
arch-mm-introduce-arch_mm_preinit.patch
arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

