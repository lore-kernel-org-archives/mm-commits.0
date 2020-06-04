From: akpm@linux-foundation.org
Subject: [merged]
 mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:16:31 -0700
Message-ID: <20200604171631.l_vG2S3kw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730068AbgFDRQe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: free_area_init: use maximal zone PFNs rather than zone sizes
has been removed from the -mm tree.  Its filename was
     mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: free_area_init: use maximal zone PFNs rather than zone sizes

Currently, architectures that use free_area_init() to initialize memory
map and node and zone structures need to calculate zone and hole sizes. 
We can use free_area_init_nodes() instead and let it detect the zone
boundaries while the architectures will only have to supply the possible
limits for the zones.

Link: http://lkml.kernel.org/r/20200412194859.12663-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Tested-by: Hoan Tran <hoan@os.amperecomputing.com>	[arm64]
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c    |   16 ++++++----------
 arch/c6x/mm/init.c      |    8 +++-----
 arch/h8300/mm/init.c    |    6 +++---
 arch/hexagon/mm/init.c  |    6 +++---
 arch/m68k/mm/init.c     |    6 +++---
 arch/m68k/mm/mcfmmu.c   |    9 +++------
 arch/nds32/mm/init.c    |   11 ++++-------
 arch/nios2/mm/init.c    |    8 +++-----
 arch/openrisc/mm/init.c |    9 +++------
 arch/um/kernel/mem.c    |   12 ++++--------
 include/linux/mm.h      |    2 +-
 mm/page_alloc.c         |    5 ++---
 12 files changed, 38 insertions(+), 60 deletions(-)

--- a/arch/alpha/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/alpha/mm/init.c
@@ -243,21 +243,17 @@ callback_init(void * kernel_end)
  */
 void __init paging_init(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES] = {0, };
-	unsigned long dma_pfn, high_pfn;
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
+	unsigned long dma_pfn;
 
 	dma_pfn = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-	high_pfn = max_pfn = max_low_pfn;
+	max_pfn = max_low_pfn;
 
-	if (dma_pfn >= high_pfn)
-		zones_size[ZONE_DMA] = high_pfn;
-	else {
-		zones_size[ZONE_DMA] = dma_pfn;
-		zones_size[ZONE_NORMAL] = high_pfn - dma_pfn;
-	}
+	max_zone_pfn[ZONE_DMA] = dma_pfn;
+	max_zone_pfn[ZONE_NORMAL] = max_pfn;
 
 	/* Initialize mem_map[].  */
-	free_area_init(zones_size);
+	free_area_init(max_zone_pfn);
 
 	/* Initialize the kernel's ZERO_PGE. */
 	memset((void *)ZERO_PGE, 0, PAGE_SIZE);
--- a/arch/c6x/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/c6x/mm/init.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(empty_zero_page);
 void __init paging_init(void)
 {
 	struct pglist_data *pgdat = NODE_DATA(0);
-	unsigned long zones_size[MAX_NR_ZONES] = {0, };
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
 	empty_zero_page      = (unsigned long) memblock_alloc(PAGE_SIZE,
 							      PAGE_SIZE);
@@ -49,11 +49,9 @@ void __init paging_init(void)
 	/*
 	 * Define zones
 	 */
-	zones_size[ZONE_NORMAL] = (memory_end - PAGE_OFFSET) >> PAGE_SHIFT;
-	pgdat->node_zones[ZONE_NORMAL].zone_start_pfn =
-		__pa(PAGE_OFFSET) >> PAGE_SHIFT;
+	max_zone_pfn[ZONE_NORMAL] = memory_end >> PAGE_SHIFT;
 
-	free_area_init(zones_size);
+	free_area_init(max_zone_pfn);
 }
 
 void __init mem_init(void)
--- a/arch/h8300/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/h8300/mm/init.c
@@ -83,10 +83,10 @@ void __init paging_init(void)
 		 start_mem, end_mem);
 
 	{
-		unsigned long zones_size[MAX_NR_ZONES] = {0, };
+		unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
-		zones_size[ZONE_NORMAL] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT;
-		free_area_init(zones_size);
+		max_zone_pfn[ZONE_NORMAL] = end_mem >> PAGE_SHIFT;
+		free_area_init(max_zone_pfn);
 	}
 }
 
--- a/arch/hexagon/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/hexagon/mm/init.c
@@ -91,7 +91,7 @@ void sync_icache_dcache(pte_t pte)
  */
 void __init paging_init(void)
 {
-	unsigned long zones_sizes[MAX_NR_ZONES] = {0, };
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
 	/*
 	 *  This is not particularly well documented anywhere, but
@@ -101,9 +101,9 @@ void __init paging_init(void)
 	 *  adjust accordingly.
 	 */
 
-	zones_sizes[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
 
-	free_area_init(zones_sizes);  /*  sets up the zonelists and mem_map  */
+	free_area_init(max_zone_pfn);  /*  sets up the zonelists and mem_map  */
 
 	/*
 	 * Start of high memory area.  Will probably need something more
--- a/arch/m68k/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/m68k/mm/init.c
@@ -84,7 +84,7 @@ void __init paging_init(void)
 	 * page_alloc get different views of the world.
 	 */
 	unsigned long end_mem = memory_end & PAGE_MASK;
-	unsigned long zones_size[MAX_NR_ZONES] = { 0, };
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
 
 	high_memory = (void *) end_mem;
 
@@ -98,8 +98,8 @@ void __init paging_init(void)
 	 */
 	set_fs (USER_DS);
 
-	zones_size[ZONE_DMA] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT;
-	free_area_init(zones_size);
+	max_zone_pfn[ZONE_DMA] = end_mem >> PAGE_SHIFT;
+	free_area_init(max_zone_pfn);
 }
 
 #endif /* CONFIG_MMU */
--- a/arch/m68k/mm/mcfmmu.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/m68k/mm/mcfmmu.c
@@ -39,7 +39,7 @@ void __init paging_init(void)
 	pte_t *pg_table;
 	unsigned long address, size;
 	unsigned long next_pgtable, bootmem_end;
-	unsigned long zones_size[MAX_NR_ZONES];
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 	enum zone_type zone;
 	int i;
 
@@ -80,11 +80,8 @@ void __init paging_init(void)
 	}
 
 	current->mm = NULL;
-
-	for (zone = 0; zone < MAX_NR_ZONES; zone++)
-		zones_size[zone] = 0x0;
-	zones_size[ZONE_DMA] = num_pages;
-	free_area_init(zones_size);
+	max_zone_pfn[ZONE_DMA] = PFN_DOWN(_ramend);
+	free_area_init(max_zone_pfn);
 }
 
 int cf_tlb_miss(struct pt_regs *regs, int write, int dtlb, int extension_word)
--- a/arch/nds32/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/nds32/mm/init.c
@@ -31,16 +31,13 @@ EXPORT_SYMBOL(empty_zero_page);
 
 static void __init zone_sizes_init(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES];
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
-	/* Clear the zone sizes */
-	memset(zones_size, 0, sizeof(zones_size));
-
-	zones_size[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-	zones_size[ZONE_HIGHMEM] = max_pfn;
+	max_zone_pfn[ZONE_HIGHMEM] = max_pfn;
 #endif
-	free_area_init(zones_size);
+	free_area_init(max_zone_pfn);
 
 }
 
--- a/arch/nios2/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/nios2/mm/init.c
@@ -46,17 +46,15 @@ pgd_t *pgd_current;
  */
 void __init paging_init(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES];
-
-	memset(zones_size, 0, sizeof(zones_size));
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
 	pagetable_init();
 	pgd_current = swapper_pg_dir;
 
-	zones_size[ZONE_NORMAL] = max_mapnr;
+	max_zone_pfn[ZONE_NORMAL] = max_mapnr;
 
 	/* pass the memory from the bootmem allocator to the main allocator */
-	free_area_init(zones_size);
+	free_area_init(max_zone_pfn);
 
 	flush_dcache_range((unsigned long)empty_zero_page,
 			(unsigned long)empty_zero_page + PAGE_SIZE);
--- a/arch/openrisc/mm/init.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/openrisc/mm/init.c
@@ -45,17 +45,14 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 
 static void __init zone_sizes_init(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES];
-
-	/* Clear the zone sizes */
-	memset(zones_size, 0, sizeof(zones_size));
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
 	/*
 	 * We use only ZONE_NORMAL
 	 */
-	zones_size[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
 
-	free_area_init(zones_size);
+	free_area_init(max_zone_pfn);
 }
 
 extern const char _s_kernel_ro[], _e_kernel_ro[];
--- a/arch/um/kernel/mem.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/arch/um/kernel/mem.c
@@ -158,8 +158,8 @@ static void __init fixaddr_user_init( vo
 
 void __init paging_init(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES], vaddr;
-	int i;
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
+	unsigned long vaddr;
 
 	empty_zero_page = (unsigned long *) memblock_alloc_low(PAGE_SIZE,
 							       PAGE_SIZE);
@@ -167,12 +167,8 @@ void __init paging_init(void)
 		panic("%s: Failed to allocate %lu bytes align=%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
 
-	for (i = 0; i < ARRAY_SIZE(zones_size); i++)
-		zones_size[i] = 0;
-
-	zones_size[ZONE_NORMAL] = (end_iomem >> PAGE_SHIFT) -
-		(uml_physmem >> PAGE_SHIFT);
-	free_area_init(zones_size);
+	max_zone_pfn[ZONE_NORMAL] = end_iomem >> PAGE_SHIFT;
+	free_area_init(max_zone_pfn);
 
 	/*
 	 * Fixed mappings, only the page table structure has to be
--- a/include/linux/mm.h~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/include/linux/mm.h
@@ -2329,7 +2329,7 @@ static inline spinlock_t *pud_lock(struc
 }
 
 extern void __init pagecache_init(void);
-extern void free_area_init(unsigned long * zones_size);
+extern void free_area_init(unsigned long * max_zone_pfn);
 extern void __init free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
 extern void free_initmem(void);
--- a/mm/page_alloc.c~mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes
+++ a/mm/page_alloc.c
@@ -7712,11 +7712,10 @@ void __init set_dma_reserve(unsigned lon
 	dma_reserve = new_dma_reserve;
 }
 
-void __init free_area_init(unsigned long *zones_size)
+void __init free_area_init(unsigned long *max_zone_pfn)
 {
 	init_unavailable_mem();
-	free_area_init_node(0, zones_size,
-			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
+	free_area_init_nodes(max_zone_pfn);
 }
 
 static int page_alloc_cpu_dead(unsigned int cpu)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix-2.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
