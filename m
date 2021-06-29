Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0F7C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A15761D1C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhF2Cpa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2Cpa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4352461D18;
        Tue, 29 Jun 2021 02:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934582;
        bh=OxqACOcAhfF3BZ8+K5g/sFX9aj2hUsR910/Aa+9ODO0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QKbTDVGIRX8Sk63f47z8JELAfjxq4gseu8PTLktZw2HEv9BvnuUKZUHWItirxBY52
         fLhQBwCJAFD9S2c0cWqKgLoBCvz4BBPXmdQTT0CDMV4c5tY5eYrD3cnYb1w/ctuwO3
         vEa+a/rL4JenKxu1YYpZw04XT5WTgJXa2GPaHd84=
Date:   Mon, 28 Jun 2021 19:43:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, corbet@lwn.net,
        david@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, rth@twiddle.net, torvalds@linux-foundation.org,
        vgupta@synopsys.com
Subject:  [patch 187/192] mm: replace CONFIG_NEED_MULTIPLE_NODES
 with CONFIG_NUMA
Message-ID: <20210629024301.ICOHlz5nG%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: replace CONFIG_NEED_MULTIPLE_NODES with CONFIG_NUMA

After removal of DISCINTIGMEM the NEED_MULTIPLE_NODES and NUMA
configuration options are equivalent.

Drop CONFIG_NEED_MULTIPLE_NODES and use CONFIG_NUMA instead.

Done with

	$ sed -i 's/CONFIG_NEED_MULTIPLE_NODES/CONFIG_NUMA/' \
		$(git grep -wl CONFIG_NEED_MULTIPLE_NODES)
	$ sed -i 's/NEED_MULTIPLE_NODES/NUMA/' \
		$(git grep -wl NEED_MULTIPLE_NODES)

with manual tweaks afterwards.

[rppt@linux.ibm.com: fix arm boot crash]
  Link: https://lkml.kernel.org/r/YMj9vHhHOiCVN4BF@linux.ibm.com
Link: https://lkml.kernel.org/r/20210608091316.3622-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                |    2 +-
 arch/ia64/Kconfig                 |    2 +-
 arch/mips/Kconfig                 |    2 +-
 arch/mips/include/asm/mmzone.h    |    2 +-
 arch/mips/include/asm/page.h      |    2 +-
 arch/mips/mm/init.c               |    4 ++--
 arch/powerpc/Kconfig              |    2 +-
 arch/powerpc/include/asm/mmzone.h |    4 ++--
 arch/powerpc/kernel/setup_64.c    |    2 +-
 arch/powerpc/kernel/smp.c         |    2 +-
 arch/powerpc/kexec/core.c         |    4 ++--
 arch/powerpc/mm/Makefile          |    2 +-
 arch/powerpc/mm/mem.c             |    4 ++--
 arch/riscv/Kconfig                |    2 +-
 arch/s390/Kconfig                 |    2 +-
 arch/sh/include/asm/mmzone.h      |    4 ++--
 arch/sh/kernel/topology.c         |    2 +-
 arch/sh/mm/Kconfig                |    2 +-
 arch/sh/mm/init.c                 |    2 +-
 arch/sparc/Kconfig                |    2 +-
 arch/sparc/include/asm/mmzone.h   |    4 ++--
 arch/sparc/kernel/smp_64.c        |    2 +-
 arch/sparc/mm/init_64.c           |   12 ++++++------
 arch/x86/Kconfig                  |    2 +-
 arch/x86/kernel/setup_percpu.c    |    6 +++---
 arch/x86/mm/init_32.c             |    4 ++--
 include/asm-generic/topology.h    |    2 +-
 include/linux/memblock.h          |    6 +++---
 include/linux/mm.h                |    4 ++--
 include/linux/mmzone.h            |    6 +++---
 kernel/crash_core.c               |    2 +-
 mm/Kconfig                        |    9 ---------
 mm/memblock.c                     |    8 ++++----
 mm/memory.c                       |    3 +--
 mm/page_alloc.c                   |    6 +++---
 mm/sparse.c                       |    2 +-
 36 files changed, 59 insertions(+), 69 deletions(-)

--- a/arch/arm64/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/arm64/Kconfig
@@ -1035,7 +1035,7 @@ config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)"
 	range 1 10
 	default "4"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
--- a/arch/ia64/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/ia64/Kconfig
@@ -302,7 +302,7 @@ config NODES_SHIFT
 	int "Max num nodes shift(3-10)"
 	range 3 10
 	default "10"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 	help
 	  This option specifies the maximum number of nodes in your SSI system.
 	  MAX_NUMNODES will be 2^(This value).
--- a/arch/mips/include/asm/mmzone.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/mips/include/asm/mmzone.h
@@ -8,7 +8,7 @@
 
 #include <asm/page.h>
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 # include <mmzone.h>
 #endif
 
--- a/arch/mips/include/asm/page.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/mips/include/asm/page.h
@@ -239,7 +239,7 @@ static inline int pfn_valid(unsigned lon
 
 /* pfn_valid is defined in linux/mmzone.h */
 
-#elif defined(CONFIG_NEED_MULTIPLE_NODES)
+#elif defined(CONFIG_NUMA)
 
 #define pfn_valid(pfn)							\
 ({									\
--- a/arch/mips/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/mips/Kconfig
@@ -2867,7 +2867,7 @@ config RANDOMIZE_BASE_MAX_OFFSET
 config NODES_SHIFT
 	int
 	default "6"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 
 config HW_PERF_EVENTS
 	bool "Enable hardware performance counter support for perf events"
--- a/arch/mips/mm/init.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/mips/mm/init.c
@@ -394,7 +394,7 @@ void maar_init(void)
 	}
 }
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
@@ -473,7 +473,7 @@ void __init mem_init(void)
 				0x80000000 - 4, KCORE_TEXT);
 #endif
 }
-#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+#endif /* !CONFIG_NUMA */
 
 void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 {
--- a/arch/powerpc/include/asm/mmzone.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/include/asm/mmzone.h
@@ -18,7 +18,7 @@
  *    flags field of the struct page
  */
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 
 extern struct pglist_data *node_data[];
 /*
@@ -41,7 +41,7 @@ u64 memory_hotplug_max(void);
 
 #else
 #define memory_hotplug_max() memblock_end_of_DRAM()
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
+#endif /* CONFIG_NUMA */
 #ifdef CONFIG_FA_DUMP
 #define __HAVE_ARCH_RESERVED_KERNEL_PAGES
 #endif
--- a/arch/powerpc/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/Kconfig
@@ -671,7 +671,7 @@ config NODES_SHIFT
 	int
 	default "8" if PPC64
 	default "4"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
--- a/arch/powerpc/kernel/setup_64.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/kernel/setup_64.c
@@ -788,7 +788,7 @@ static void * __init pcpu_alloc_bootmem(
 					size_t align)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int node = early_cpu_to_node(cpu);
 	void *ptr;
 
--- a/arch/powerpc/kernel/smp.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/kernel/smp.c
@@ -1047,7 +1047,7 @@ void __init smp_prepare_cpus(unsigned in
 			zalloc_cpumask_var_node(&per_cpu(cpu_coregroup_map, cpu),
 						GFP_KERNEL, cpu_to_node(cpu));
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 		/*
 		 * numa_node_id() works after this.
 		 */
--- a/arch/powerpc/kexec/core.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/kexec/core.c
@@ -68,11 +68,11 @@ void machine_kexec_cleanup(struct kimage
 void arch_crash_save_vmcoreinfo(void)
 {
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
 #if defined(CONFIG_PPC64) && defined(CONFIG_SPARSEMEM_VMEMMAP)
--- a/arch/powerpc/mm/Makefile~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/mm/Makefile
@@ -13,7 +13,7 @@ obj-y				:= fault.o mem.o pgtable.o mmap
 obj-$(CONFIG_PPC_MMU_NOHASH)	+= nohash/
 obj-$(CONFIG_PPC_BOOK3S_32)	+= book3s32/
 obj-$(CONFIG_PPC_BOOK3S_64)	+= book3s64/
-obj-$(CONFIG_NEED_MULTIPLE_NODES) += numa.o
+obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_PPC_MM_SLICES)	+= slice.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_NOT_COHERENT_CACHE) += dma-noncoherent.o
--- a/arch/powerpc/mm/mem.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/powerpc/mm/mem.c
@@ -127,7 +127,7 @@ void __ref arch_remove_memory(int nid, u
 }
 #endif
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 void __init mem_topology_setup(void)
 {
 	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
@@ -162,7 +162,7 @@ static int __init mark_nonram_nosave(voi
 
 	return 0;
 }
-#else /* CONFIG_NEED_MULTIPLE_NODES */
+#else /* CONFIG_NUMA */
 static int __init mark_nonram_nosave(void)
 {
 	return 0;
--- a/arch/riscv/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/riscv/Kconfig
@@ -332,7 +332,7 @@ config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)"
 	range 1 10
 	default "2"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
--- a/arch/s390/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/s390/Kconfig
@@ -475,7 +475,7 @@ config NUMA
 
 config NODES_SHIFT
 	int
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 	default "1"
 
 config SCHED_SMT
--- a/arch/sh/include/asm/mmzone.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sh/include/asm/mmzone.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SH_MMZONE_H
 #define __ASM_SH_MMZONE_H
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 #include <linux/numa.h>
 
 extern struct pglist_data *node_data[];
@@ -31,7 +31,7 @@ static inline void
 setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 {
 }
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
+#endif /* CONFIG_NUMA */
 
 /* Platform specific mem init */
 void __init plat_mem_setup(void);
--- a/arch/sh/kernel/topology.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sh/kernel/topology.c
@@ -46,7 +46,7 @@ static int __init topology_init(void)
 {
 	int i, ret;
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	for_each_online_node(i)
 		register_one_node(i);
 #endif
--- a/arch/sh/mm/init.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sh/mm/init.c
@@ -211,7 +211,7 @@ void __init allocate_pgdat(unsigned int
 
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	NODE_DATA(nid) = memblock_alloc_try_nid(
 				sizeof(struct pglist_data),
 				SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
--- a/arch/sh/mm/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sh/mm/Kconfig
@@ -120,7 +120,7 @@ config NODES_SHIFT
 	int
 	default "3" if CPU_SUBTYPE_SHX3
 	default "1"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
--- a/arch/sparc/include/asm/mmzone.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sparc/include/asm/mmzone.h
@@ -2,7 +2,7 @@
 #ifndef _SPARC64_MMZONE_H
 #define _SPARC64_MMZONE_H
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 
 #include <linux/cpumask.h>
 
@@ -13,6 +13,6 @@ extern struct pglist_data *node_data[];
 extern int numa_cpu_lookup_table[];
 extern cpumask_t numa_cpumask_lookup_table[];
 
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
+#endif /* CONFIG_NUMA */
 
 #endif /* _SPARC64_MMZONE_H */
--- a/arch/sparc/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sparc/Kconfig
@@ -265,7 +265,7 @@ config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)"
 	range 4 5 if SPARC64
 	default "5"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
--- a/arch/sparc/kernel/smp_64.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sparc/kernel/smp_64.c
@@ -1546,7 +1546,7 @@ static void * __init pcpu_alloc_bootmem(
 					size_t align)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int node = cpu_to_node(cpu);
 	void *ptr;
 
--- a/arch/sparc/mm/init_64.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/sparc/mm/init_64.c
@@ -903,7 +903,7 @@ struct node_mem_mask {
 static struct node_mem_mask node_masks[MAX_NUMNODES];
 static int num_node_masks;
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 
 struct mdesc_mlgroup {
 	u64	node;
@@ -1059,7 +1059,7 @@ static void __init allocate_node_data(in
 {
 	struct pglist_data *p;
 	unsigned long start_pfn, end_pfn;
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 
 	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
 					     SMP_CACHE_BYTES, nid);
@@ -1080,7 +1080,7 @@ static void __init allocate_node_data(in
 
 static void init_node_masks_nonnuma(void)
 {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int i;
 #endif
 
@@ -1090,7 +1090,7 @@ static void init_node_masks_nonnuma(void
 	node_masks[0].match = 0;
 	num_node_masks = 1;
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	for (i = 0; i < NR_CPUS; i++)
 		numa_cpu_lookup_table[i] = 0;
 
@@ -1098,7 +1098,7 @@ static void init_node_masks_nonnuma(void
 #endif
 }
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 struct pglist_data *node_data[MAX_NUMNODES];
 
 EXPORT_SYMBOL(numa_cpu_lookup_table);
@@ -2487,7 +2487,7 @@ int page_in_phys_avail(unsigned long pad
 
 static void __init register_page_bootmem_info(void)
 {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int i;
 
 	for_each_online_node(i)
--- a/arch/x86/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/x86/Kconfig
@@ -1597,7 +1597,7 @@ config NODES_SHIFT
 	default "10" if MAXSMP
 	default "6" if X86_64
 	default "3"
-	depends on NEED_MULTIPLE_NODES
+	depends on NUMA
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
--- a/arch/x86/kernel/setup_percpu.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/x86/kernel/setup_percpu.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(__per_cpu_offset);
  */
 static bool __init pcpu_need_numa(void)
 {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	pg_data_t *last = NULL;
 	unsigned int cpu;
 
@@ -101,7 +101,7 @@ static void * __init pcpu_alloc_bootmem(
 					unsigned long align)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int node = early_cpu_to_node(cpu);
 	void *ptr;
 
@@ -140,7 +140,7 @@ static void __init pcpu_fc_free(void *pt
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	if (early_cpu_to_node(from) == early_cpu_to_node(to))
 		return LOCAL_DISTANCE;
 	else
--- a/arch/x86/mm/init_32.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/arch/x86/mm/init_32.c
@@ -651,7 +651,7 @@ void __init find_low_pfn_range(void)
 		highmem_pfn_init();
 }
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 void __init initmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
@@ -677,7 +677,7 @@ void __init initmem_init(void)
 
 	setup_bootmem_allocator();
 }
-#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+#endif /* !CONFIG_NUMA */
 
 void __init setup_bootmem_allocator(void)
 {
--- a/include/asm-generic/topology.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/include/asm-generic/topology.h
@@ -45,7 +45,7 @@
 #endif
 
 #ifndef cpumask_of_node
-  #ifdef CONFIG_NEED_MULTIPLE_NODES
+  #ifdef CONFIG_NUMA
     #define cpumask_of_node(node)	((node) == 0 ? cpu_online_mask : cpu_none_mask)
   #else
     #define cpumask_of_node(node)	((void)(node), cpu_online_mask)
--- a/include/linux/memblock.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/include/linux/memblock.h
@@ -50,7 +50,7 @@ struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
 	enum memblock_flags flags;
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int nid;
 #endif
 };
@@ -347,7 +347,7 @@ int __init deferred_page_init_max_thread
 int memblock_set_node(phys_addr_t base, phys_addr_t size,
 		      struct memblock_type *type, int nid);
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 static inline void memblock_set_region_node(struct memblock_region *r, int nid)
 {
 	r->nid = nid;
@@ -366,7 +366,7 @@ static inline int memblock_get_region_no
 {
 	return 0;
 }
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
+#endif /* CONFIG_NUMA */
 
 /* Flags for memblock allocation APIs */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
--- a/include/linux/mm.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/include/linux/mm.h
@@ -46,7 +46,7 @@ extern int sysctl_page_lock_unfairness;
 
 void init_mm_internals(void);
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
+#ifndef CONFIG_NUMA		/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
 
 static inline void set_max_mapnr(unsigned long limit)
@@ -2460,7 +2460,7 @@ extern void get_pfn_range_for_nid(unsign
 			unsigned long *start_pfn, unsigned long *end_pfn);
 extern unsigned long find_min_pfn_with_active_regions(void);
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 static inline int early_pfn_to_nid(unsigned long pfn)
 {
 	return 0;
--- a/include/linux/mmzone.h~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/include/linux/mmzone.h
@@ -1043,17 +1043,17 @@ extern int percpu_pagelist_high_fraction
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN	16
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 
 extern struct pglist_data contig_page_data;
 #define NODE_DATA(nid)		(&contig_page_data)
 #define NODE_MEM_MAP(nid)	mem_map
 
-#else /* CONFIG_NEED_MULTIPLE_NODES */
+#else /* CONFIG_NUMA */
 
 #include <asm/mmzone.h>
 
-#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+#endif /* !CONFIG_NUMA */
 
 extern struct pglist_data *first_online_pgdat(void);
 extern struct pglist_data *next_online_pgdat(struct pglist_data *pgdat);
--- a/kernel/crash_core.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/kernel/crash_core.c
@@ -455,7 +455,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL(_stext);
 	VMCOREINFO_SYMBOL(vmap_area_list);
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(mem_map);
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
--- a/mm/Kconfig~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/mm/Kconfig
@@ -60,15 +60,6 @@ config FLAT_NODE_MEM_MAP
 	depends on !SPARSEMEM
 
 #
-# Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
-# to represent different areas of memory.  This variable allows
-# those dependencies to exist individually.
-#
-config NEED_MULTIPLE_NODES
-	def_bool y
-	depends on NUMA
-
-#
 # SPARSEMEM_EXTREME (which is the default) does some bootmem
 # allocations when sparse_init() is called.  If this cannot
 # be done on your architecture, select this option.  However,
--- a/mm/memblock.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/mm/memblock.c
@@ -92,7 +92,7 @@
  * system initialization completes.
  */
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 struct pglist_data __refdata contig_page_data;
 EXPORT_SYMBOL(contig_page_data);
 #endif
@@ -607,7 +607,7 @@ repeat:
 		 * area, insert that portion.
 		 */
 		if (rbase > base) {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 			WARN_ON(nid != memblock_get_region_node(rgn));
 #endif
 			WARN_ON(flags != rgn->flags);
@@ -1205,7 +1205,7 @@ void __init_memblock __next_mem_pfn_rang
 int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 				      struct memblock_type *type, int nid)
 {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 	int start_rgn, end_rgn;
 	int i, ret;
 
@@ -1849,7 +1849,7 @@ static void __init_memblock memblock_dum
 		size = rgn->size;
 		end = base + size - 1;
 		flags = rgn->flags;
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
 			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
 				 memblock_get_region_node(rgn));
--- a/mm/memory.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/mm/memory.c
@@ -90,8 +90,7 @@
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
 #endif
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-/* use the per-pgdat data instead for discontigmem - mbligh */
+#ifndef CONFIG_NUMA
 unsigned long max_mapnr;
 EXPORT_SYMBOL(max_mapnr);
 
--- a/mm/page_alloc.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/mm/page_alloc.c
@@ -1634,7 +1634,7 @@ void __free_pages_core(struct page *page
 	__free_pages_ok(page, order, FPI_TO_TAIL | FPI_SKIP_KASAN_POISON);
 }
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NUMA
 
 /*
  * During memory init memblocks map pfns to nids. The search is expensive and
@@ -1684,7 +1684,7 @@ int __meminit early_pfn_to_nid(unsigned
 
 	return nid;
 }
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
+#endif /* CONFIG_NUMA */
 
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
@@ -7438,7 +7438,7 @@ static void __ref alloc_node_mem_map(str
 	pr_debug("%s: node %d, pgdat %08lx, node_mem_map %08lx\n",
 				__func__, pgdat->node_id, (unsigned long)pgdat,
 				(unsigned long)pgdat->node_mem_map);
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 	/*
 	 * With no DISCONTIG, the global mem_map is just set as node 0's
 	 */
--- a/mm/sparse.c~mm-replace-config_need_multiple_nodes-with-config_numa
+++ a/mm/sparse.c
@@ -346,7 +346,7 @@ size_t mem_section_usage_size(void)
 
 static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
 {
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 	return __pa_symbol(pgdat);
 #else
 	return __pa(pgdat);
_
