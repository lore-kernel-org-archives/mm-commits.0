From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-config_have_memblock_node_map-option.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:25:43 -0700
Message-ID: <20200414002543.Mfhxs3r9t%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgDNAZq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:25:46 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option
has been added to the -mm tree.  Its filename is
     mm-remove-config_have_memblock_node_map-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-config_have_memblock_node_map-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-config_have_memblock_node_map-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option

CONFIG_HAVE_MEMBLOCK_NODE_MAP is used to differentiate initialization of
nodes and zones structures between the systems that have region to node
mapping in memblock and those that don't.

Currently all the NUMA architectures enable this option and for the
non-NUMA systems we can presume that all the memory belongs to node 0 and
therefore the compile time configuration option is not required.

The remaining few architectures that use DISCONTIGMEM without NUMA are
easily updated to use memblock_add_node() instead of memblock_add() and
thus have proper correspondence of memblock regions to NUMA nodes.

Still, free_area_init_node() must have a backward compatible version
because its semantics with and without CONFIG_HAVE_MEMBLOCK_NODE_MAP is
different.  Once all the architectures will use the new semantics, the
entire compatibility layer can be dropped.

To avoid addition of extra run time memory to store node id for
architectures that keep memblock but have only a single node, the node id
field of the memblock_region is guarded by CONFIG_NEED_MULTIPLE_NODES and
the corresponding accessors presume that in those cases it is always 0.

Link: http://lkml.kernel.org/r/20200412194859.12663-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
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
Cc: Hoan Tran <Hoan@os.amperecomputing.com>
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

 Documentation/features/vm/numa-memblock/arch-support.txt |   34 ---
 arch/alpha/mm/numa.c                                     |    4 
 arch/arm64/Kconfig                                       |    1 
 arch/ia64/Kconfig                                        |    1 
 arch/m68k/mm/motorola.c                                  |    4 
 arch/microblaze/Kconfig                                  |    1 
 arch/mips/Kconfig                                        |    1 
 arch/powerpc/Kconfig                                     |    1 
 arch/riscv/Kconfig                                       |    1 
 arch/s390/Kconfig                                        |    1 
 arch/sh/Kconfig                                          |    1 
 arch/sparc/Kconfig                                       |    1 
 arch/x86/Kconfig                                         |    1 
 include/linux/memblock.h                                 |    8 
 include/linux/mm.h                                       |   12 -
 include/linux/mmzone.h                                   |    2 
 mm/Kconfig                                               |    3 
 mm/memblock.c                                            |   11 -
 mm/memory_hotplug.c                                      |    4 
 mm/page_alloc.c                                          |  101 +++++-----
 20 files changed, 74 insertions(+), 119 deletions(-)

--- a/arch/alpha/mm/numa.c~mm-remove-config_have_memblock_node_map-option
+++ a/arch/alpha/mm/numa.c
@@ -144,8 +144,8 @@ setup_memory_node(int nid, void *kernel_
 	if (!nid && (node_max_pfn < end_kernel_pfn || node_min_pfn > start_kernel_pfn))
 		panic("kernel loaded out of ram");
 
-	memblock_add(PFN_PHYS(node_min_pfn),
-		     (node_max_pfn - node_min_pfn) << PAGE_SHIFT);
+	memblock_add_node(PFN_PHYS(node_min_pfn),
+			  (node_max_pfn - node_min_pfn) << PAGE_SHIFT, nid);
 
 	/* Zone start phys-addr must be 2^(MAX_ORDER-1) aligned.
 	   Note that we round this down, not up - node memory
--- a/arch/arm64/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/arm64/Kconfig
@@ -157,7 +157,6 @@ config ARM64
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_MEMBLOCK_NODE_MAP if NUMA
 	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
--- a/arch/ia64/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/ia64/Kconfig
@@ -31,7 +31,6 @@ config IA64
 	select HAVE_FUNCTION_TRACER
 	select TTY
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
 	select DMA_NONCOHERENT_MMAP
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
--- a/arch/m68k/mm/motorola.c~mm-remove-config_have_memblock_node_map-option
+++ a/arch/m68k/mm/motorola.c
@@ -386,7 +386,7 @@ void __init paging_init(void)
 
 	min_addr = m68k_memory[0].addr;
 	max_addr = min_addr + m68k_memory[0].size;
-	memblock_add(m68k_memory[0].addr, m68k_memory[0].size);
+	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0);
 	for (i = 1; i < m68k_num_memory;) {
 		if (m68k_memory[i].addr < min_addr) {
 			printk("Ignoring memory chunk at 0x%lx:0x%lx before the first chunk\n",
@@ -397,7 +397,7 @@ void __init paging_init(void)
 				(m68k_num_memory - i) * sizeof(struct m68k_mem_info));
 			continue;
 		}
-		memblock_add(m68k_memory[i].addr, m68k_memory[i].size);
+		memblock_add_node(m68k_memory[i].addr, m68k_memory[i].size, i);
 		addr = m68k_memory[i].addr + m68k_memory[i].size;
 		if (addr > max_addr)
 			max_addr = addr;
--- a/arch/microblaze/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/microblaze/Kconfig
@@ -32,7 +32,6 @@ config MICROBLAZE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
 	select HAVE_PCI
 	select IRQ_DOMAIN
--- a/arch/mips/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/mips/Kconfig
@@ -72,7 +72,6 @@ config MIPS
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_OPROFILE
--- a/arch/powerpc/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/powerpc/Kconfig
@@ -211,7 +211,6 @@ config PPC
 	select HAVE_KRETPROBES
 	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
 	select HAVE_LIVEPATCH			if HAVE_DYNAMIC_FTRACE_WITH_REGS
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI				if PERF_EVENTS || (PPC64 && PPC_BOOK3S)
 	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if (PPC64 && PPC_BOOK3S)
--- a/arch/riscv/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/riscv/Kconfig
@@ -32,7 +32,6 @@ config RISCV
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ASM_MODVERSIONS
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_DMA_CONTIGUOUS if MMU
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_PERF_EVENTS
--- a/arch/s390/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/s390/Kconfig
@@ -163,7 +163,6 @@ config S390
 	select HAVE_LIVEPATCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MEMBLOCK_PHYS_MAP
 	select MMU_GATHER_NO_GATHER
 	select HAVE_MOD_ARCH_SPECIFIC
--- a/arch/sh/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/sh/Kconfig
@@ -9,7 +9,6 @@ config SUPERH
 	select CLKDEV_LOOKUP
 	select DMA_DECLARE_COHERENT
 	select HAVE_IDE if HAS_IOPORT_MAP
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_PERF_EVENTS
--- a/arch/sparc/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/sparc/Kconfig
@@ -65,7 +65,6 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select MMU_GATHER_RCU_TABLE_FREE if SMP
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
--- a/arch/x86/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/arch/x86/Kconfig
@@ -191,7 +191,6 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM
 	select HAVE_LIVEPATCH			if X86_64
-	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_MOVE_PMD
--- a/Documentation/features/vm/numa-memblock/arch-support.txt
+++ /dev/null
@@ -1,34 +0,0 @@
-#
-# Feature name:          numa-memblock
-#         Kconfig:       HAVE_MEMBLOCK_NODE_MAP
-#         description:   arch supports NUMA aware memblocks
-#
-    -----------------------
-    |         arch |status|
-    -----------------------
-    |       alpha: | TODO |
-    |         arc: |  ..  |
-    |         arm: |  ..  |
-    |       arm64: |  ok  |
-    |         c6x: |  ..  |
-    |        csky: |  ..  |
-    |       h8300: |  ..  |
-    |     hexagon: |  ..  |
-    |        ia64: |  ok  |
-    |        m68k: |  ..  |
-    |  microblaze: |  ok  |
-    |        mips: |  ok  |
-    |       nds32: | TODO |
-    |       nios2: |  ..  |
-    |    openrisc: |  ..  |
-    |      parisc: |  ..  |
-    |     powerpc: |  ok  |
-    |       riscv: |  ok  |
-    |        s390: |  ok  |
-    |          sh: |  ok  |
-    |       sparc: |  ok  |
-    |          um: |  ..  |
-    |   unicore32: |  ..  |
-    |         x86: |  ok  |
-    |      xtensa: |  ..  |
-    -----------------------
--- a/include/linux/memblock.h~mm-remove-config_have_memblock_node_map-option
+++ a/include/linux/memblock.h
@@ -50,7 +50,7 @@ struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
 	enum memblock_flags flags;
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 	int nid;
 #endif
 };
@@ -215,7 +215,6 @@ static inline bool memblock_is_nomap(str
 	return m->flags & MEMBLOCK_NOMAP;
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
@@ -234,7 +233,6 @@ void __next_mem_pfn_range(int *idx, int
 #define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
 	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
 	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
@@ -310,10 +308,10 @@ void __next_mem_pfn_range_in_zone(u64 *i
 	for_each_mem_range_rev(i, &memblock.memory, &memblock.reserved,	\
 			       nid, flags, p_start, p_end, p_nid)
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_set_node(phys_addr_t base, phys_addr_t size,
 		      struct memblock_type *type, int nid);
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 static inline void memblock_set_region_node(struct memblock_region *r, int nid)
 {
 	r->nid = nid;
@@ -332,7 +330,7 @@ static inline int memblock_get_region_no
 {
 	return 0;
 }
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+#endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 /* Flags for memblock allocation APIs */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
--- a/include/linux/mm.h~mm-remove-config_have_memblock_node_map-option
+++ a/include/linux/mm.h
@@ -2344,9 +2344,8 @@ static inline unsigned long get_num_phys
 	return phys_pages;
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
- * With CONFIG_HAVE_MEMBLOCK_NODE_MAP set, an architecture may initialise its
+ * Using memblock node mappings, an architecture may initialise its
  * zones, allocate the backing mem_map and account for memory holes in a more
  * architecture independent manner. This is a substitute for creating the
  * zone_sizes[] and zholes_size[] arrays and passing them to
@@ -2367,9 +2366,6 @@ static inline unsigned long get_num_phys
  * registered physical page range.  Similarly
  * sparse_memory_present_with_active_regions() calls memory_present() for
  * each range when SPARSEMEM is enabled.
- *
- * See mm/page_alloc.c for more information on each function exposed by
- * CONFIG_HAVE_MEMBLOCK_NODE_MAP.
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
@@ -2384,13 +2380,9 @@ extern void free_bootmem_with_active_reg
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
 
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-
-#if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
-    !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
+#ifndef CONFIG_NEED_MULTIPLE_NODES
 static inline int early_pfn_to_nid(unsigned long pfn)
 {
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_NUMA));
 	return 0;
 }
 #else
--- a/include/linux/mmzone.h~mm-remove-config_have_memblock_node_map-option
+++ a/include/linux/mmzone.h
@@ -874,7 +874,7 @@ extern int movable_zone;
 #ifdef CONFIG_HIGHMEM
 static inline int zone_movable_is_highmem(void)
 {
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
--- a/mm/Kconfig~mm-remove-config_have_memblock_node_map-option
+++ a/mm/Kconfig
@@ -126,9 +126,6 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config HAVE_MEMBLOCK_NODE_MAP
-	bool
-
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
--- a/mm/memblock.c~mm-remove-config_have_memblock_node_map-option
+++ a/mm/memblock.c
@@ -620,7 +620,7 @@ repeat:
 		 * area, insert that portion.
 		 */
 		if (rbase > base) {
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 			WARN_ON(nid != memblock_get_region_node(rgn));
 #endif
 			WARN_ON(flags != rgn->flags);
@@ -1197,7 +1197,6 @@ void __init_memblock __next_mem_range_re
 	*idx = ULLONG_MAX;
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
  * Common iterator interface used to define for_each_mem_pfn_range().
  */
@@ -1247,6 +1246,7 @@ void __init_memblock __next_mem_pfn_rang
 int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 				      struct memblock_type *type, int nid)
 {
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 	int start_rgn, end_rgn;
 	int i, ret;
 
@@ -1258,9 +1258,10 @@ int __init_memblock memblock_set_node(ph
 		memblock_set_region_node(&type->regions[i], nid);
 
 	memblock_merge_regions(type);
+#endif
 	return 0;
 }
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 /**
  * __next_mem_pfn_range_in_zone - iterator for for_each_*_range_in_zone()
@@ -1799,7 +1800,6 @@ bool __init_memblock memblock_is_map_mem
 	return !memblock_is_nomap(&memblock.memory.regions[i]);
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
 			 unsigned long *start_pfn, unsigned long *end_pfn)
 {
@@ -1814,7 +1814,6 @@ int __init_memblock memblock_search_pfn_
 
 	return memblock_get_region_node(&type->regions[mid]);
 }
-#endif
 
 /**
  * memblock_is_region_memory - check if a region is a subset of memory
@@ -1905,7 +1904,7 @@ static void __init_memblock memblock_dum
 		size = rgn->size;
 		end = base + size - 1;
 		flags = rgn->flags;
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
 			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
 				 memblock_get_region_node(rgn));
--- a/mm/memory_hotplug.c~mm-remove-config_have_memblock_node_map-option
+++ a/mm/memory_hotplug.c
@@ -1372,11 +1372,7 @@ check_pages_isolated_cb(unsigned long st
 
 static int __init cmdline_parse_movable_node(char *p)
 {
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	movable_node_enabled = true;
-#else
-	pr_warn("movable_node parameter depends on CONFIG_HAVE_MEMBLOCK_NODE_MAP to work properly\n");
-#endif
 	return 0;
 }
 early_param("movable_node", cmdline_parse_movable_node);
--- a/mm/page_alloc.c~mm-remove-config_have_memblock_node_map-option
+++ a/mm/page_alloc.c
@@ -335,7 +335,6 @@ static unsigned long nr_kernel_pages __i
 static unsigned long nr_all_pages __initdata;
 static unsigned long dma_reserve __initdata;
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 static unsigned long arch_zone_lowest_possible_pfn[MAX_NR_ZONES] __initdata;
 static unsigned long arch_zone_highest_possible_pfn[MAX_NR_ZONES] __initdata;
 static unsigned long required_kernelcore __initdata;
@@ -348,7 +347,6 @@ static bool mirrored_kernelcore __memini
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
 EXPORT_SYMBOL(movable_zone);
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if MAX_NUMNODES > 1
 unsigned int nr_node_ids __read_mostly = MAX_NUMNODES;
@@ -1499,8 +1497,7 @@ void __free_pages_core(struct page *page
 	__free_pages(page, order);
 }
 
-#if defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) || \
-	defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 
 static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
 
@@ -1542,7 +1539,7 @@ int __meminit early_pfn_to_nid(unsigned
 
 	return nid;
 }
-#endif
+#endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
 /* Only safe to use early in boot when initialisation is single-threaded */
@@ -5924,7 +5921,6 @@ void __ref build_all_zonelists(pg_data_t
 static bool __meminit
 overlap_memmap_init(unsigned long zone, unsigned long *pfn)
 {
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	static struct memblock_region *r;
 
 	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
@@ -5940,7 +5936,6 @@ overlap_memmap_init(unsigned long zone,
 			return true;
 		}
 	}
-#endif
 	return false;
 }
 
@@ -6573,8 +6568,7 @@ static unsigned long __init zone_absent_
 	return nr_absent;
 }
 
-#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-static inline unsigned long __init zone_spanned_pages_in_node(int nid,
+static inline unsigned long __init compat_zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
@@ -6593,7 +6587,7 @@ static inline unsigned long __init zone_
 	return zones_size[zone_type];
 }
 
-static inline unsigned long __init zone_absent_pages_in_node(int nid,
+static inline unsigned long __init compat_zone_absent_pages_in_node(int nid,
 						unsigned long zone_type,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn,
@@ -6605,13 +6599,12 @@ static inline unsigned long __init zone_
 	return zholes_size[zone_type];
 }
 
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-
 static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn,
 						unsigned long *zones_size,
-						unsigned long *zholes_size)
+						unsigned long *zholes_size,
+						bool compat)
 {
 	unsigned long realtotalpages = 0, totalpages = 0;
 	enum zone_type i;
@@ -6619,17 +6612,38 @@ static void __init calculate_node_totalp
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 		unsigned long zone_start_pfn, zone_end_pfn;
+		unsigned long spanned, absent;
 		unsigned long size, real_size;
 
-		size = zone_spanned_pages_in_node(pgdat->node_id, i,
-						  node_start_pfn,
-						  node_end_pfn,
-						  &zone_start_pfn,
-						  &zone_end_pfn,
-						  zones_size);
-		real_size = size - zone_absent_pages_in_node(pgdat->node_id, i,
-						  node_start_pfn, node_end_pfn,
-						  zholes_size);
+		if (compat) {
+			spanned = compat_zone_spanned_pages_in_node(
+						pgdat->node_id, i,
+						node_start_pfn,
+						node_end_pfn,
+						&zone_start_pfn,
+						&zone_end_pfn,
+						zones_size);
+			absent = compat_zone_absent_pages_in_node(
+						pgdat->node_id, i,
+						node_start_pfn,
+						node_end_pfn,
+						zholes_size);
+		} else {
+			spanned = zone_spanned_pages_in_node(pgdat->node_id, i,
+						node_start_pfn,
+						node_end_pfn,
+						&zone_start_pfn,
+						&zone_end_pfn,
+						zones_size);
+			absent = zone_absent_pages_in_node(pgdat->node_id, i,
+						node_start_pfn,
+						node_end_pfn,
+						zholes_size);
+		}
+
+		size = spanned;
+		real_size = size - absent;
+
 		if (size)
 			zone->zone_start_pfn = zone_start_pfn;
 		else
@@ -6929,10 +6943,8 @@ static void __ref alloc_node_mem_map(str
 	 */
 	if (pgdat == NODE_DATA(0)) {
 		mem_map = NODE_DATA(0)->node_mem_map;
-#if defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) || defined(CONFIG_FLATMEM)
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
 			mem_map -= offset;
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	}
 #endif
 }
@@ -6949,9 +6961,10 @@ static inline void pgdat_set_deferred_ra
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
 #endif
 
-void __init free_area_init_node(int nid, unsigned long *zones_size,
-				   unsigned long node_start_pfn,
-				   unsigned long *zholes_size)
+static void __init __free_area_init_node(int nid, unsigned long *zones_size,
+					 unsigned long node_start_pfn,
+					 unsigned long *zholes_size,
+					 bool compat)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long start_pfn = 0;
@@ -6963,16 +6976,16 @@ void __init free_area_init_node(int nid,
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	pgdat->per_cpu_nodestats = NULL;
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-		(u64)start_pfn << PAGE_SHIFT,
-		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
-#else
-	start_pfn = node_start_pfn;
-#endif
+	if (!compat) {
+		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
+			(u64)start_pfn << PAGE_SHIFT,
+			end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+	} else {
+		start_pfn = node_start_pfn;
+	}
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
-				  zones_size, zholes_size);
+				  zones_size, zholes_size, compat);
 
 	alloc_node_mem_map(pgdat);
 	pgdat_set_deferred_range(pgdat);
@@ -6980,6 +6993,14 @@ void __init free_area_init_node(int nid,
 	free_area_init_core(pgdat);
 }
 
+void __init free_area_init_node(int nid, unsigned long *zones_size,
+				unsigned long node_start_pfn,
+				unsigned long *zholes_size)
+{
+	__free_area_init_node(nid, zones_size, node_start_pfn, zholes_size,
+			      true);
+}
+
 #if !defined(CONFIG_FLAT_NODE_MEM_MAP)
 /*
  * Initialize all valid struct pages in the range [spfn, epfn) and mark them
@@ -7063,8 +7084,6 @@ static inline void __init init_unavailab
 }
 #endif /* !CONFIG_FLAT_NODE_MEM_MAP */
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-
 #if MAX_NUMNODES > 1
 /*
  * Figure out the number of possible node ids.
@@ -7493,8 +7512,8 @@ void __init free_area_init_nodes(unsigne
 	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		free_area_init_node(nid, NULL,
-				find_min_pfn_for_node(nid), NULL);
+		__free_area_init_node(nid, NULL,
+				      find_min_pfn_for_node(nid), NULL, false);
 
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
@@ -7559,8 +7578,6 @@ static int __init cmdline_parse_movablec
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
