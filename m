From: akpm@linux-foundation.org
Subject: + mm-move-bootmem-descriptors-definition-to-a-single-place.patch added to -mm tree
Date: Wed, 30 Apr 2008 12:30:00 -0700
Message-ID: <200804301930.m3UJU0MD031149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932428AbYD3TcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 15:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, apw@shadowen.org, clameter@sgi.com, davem@davemloft.net, geert@linux-m68k.org, kyle@parisc-linux.org, lethal@linux-sh.org, mel@csn.ul.ie, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, rth@twiddle.net, takata@linux-m32r.org, tony.luck@intel.com, yhlu.kernel@gmail.com


The patch titled
     mm: move bootmem descriptors definition to a single place
has been added to the -mm tree.  Its filename is
     mm-move-bootmem-descriptors-definition-to-a-single-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move bootmem descriptors definition to a single place
From: Johannes Weiner <hannes@saeurebad.de>

There are a lot of places that define either a single bootmem descriptor or an
array of them.  Use only one central array with MAX_NUMNODES items instead.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/numa.c             |    8 +++---
 arch/arm/mm/discontig.c          |   34 +++++++++++++----------------
 arch/ia64/mm/discontig.c         |   11 ++++-----
 arch/m32r/mm/discontig.c         |    4 ---
 arch/m68k/mm/init.c              |    4 ---
 arch/mips/sgi-ip27/ip27-memory.c |    3 --
 arch/parisc/mm/init.c            |    3 --
 arch/powerpc/mm/numa.c           |    3 --
 arch/sh/mm/numa.c                |    5 +---
 arch/sparc64/mm/init.c           |    3 --
 arch/x86/mm/discontig_32.c       |    3 --
 arch/x86/mm/numa_64.c            |    6 -----
 include/linux/bootmem.h          |    2 +
 mm/bootmem.c                     |    2 +
 mm/page_alloc.c                  |    4 ---
 15 files changed, 40 insertions(+), 55 deletions(-)

diff -puN arch/alpha/mm/numa.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/alpha/mm/numa.c
@@ -19,7 +19,6 @@
 #include <asm/pgalloc.h>
 
 pg_data_t node_data[MAX_NUMNODES];
-bootmem_data_t node_bdata[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
 
 #undef DEBUG_DISCONTIG
@@ -141,7 +140,7 @@ setup_memory_node(int nid, void *kernel_
 		printk(" not enough mem to reserve NODE_DATA");
 		return;
 	}
-	NODE_DATA(nid)->bdata = &node_bdata[nid];
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 
 	printk(" Detected node memory:   start %8lu, end %8lu\n",
 	       node_min_pfn, node_max_pfn);
@@ -304,8 +303,9 @@ void __init paging_init(void)
 	dma_local_pfn = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 
 	for_each_online_node(nid) {
-		unsigned long start_pfn = node_bdata[nid].node_boot_start >> PAGE_SHIFT;
-		unsigned long end_pfn = node_bdata[nid].node_low_pfn;
+		bootmem_data_t *bdata = &bootmem_node_data[nid];
+		unsigned long start_pfn = bdata->node_boot_start >> PAGE_SHIFT;
+		unsigned long end_pfn = bdata->node_low_pfn;
 
 		if (dma_local_pfn >= end_pfn - start_pfn)
 			zones_size[ZONE_DMA] = end_pfn - start_pfn;
diff -puN arch/arm/mm/discontig.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/arm/mm/discontig.c
--- a/arch/arm/mm/discontig.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/arm/mm/discontig.c
@@ -21,26 +21,24 @@
  * Our node_data structure for discontiguous memory.
  */
 
-static bootmem_data_t node_bootmem_data[MAX_NUMNODES];
-
 pg_data_t discontig_node_data[MAX_NUMNODES] = {
-  { .bdata = &node_bootmem_data[0] },
-  { .bdata = &node_bootmem_data[1] },
-  { .bdata = &node_bootmem_data[2] },
-  { .bdata = &node_bootmem_data[3] },
+  { .bdata = &bootmem_node_data[0] },
+  { .bdata = &bootmem_node_data[1] },
+  { .bdata = &bootmem_node_data[2] },
+  { .bdata = &bootmem_node_data[3] },
 #if MAX_NUMNODES == 16
-  { .bdata = &node_bootmem_data[4] },
-  { .bdata = &node_bootmem_data[5] },
-  { .bdata = &node_bootmem_data[6] },
-  { .bdata = &node_bootmem_data[7] },
-  { .bdata = &node_bootmem_data[8] },
-  { .bdata = &node_bootmem_data[9] },
-  { .bdata = &node_bootmem_data[10] },
-  { .bdata = &node_bootmem_data[11] },
-  { .bdata = &node_bootmem_data[12] },
-  { .bdata = &node_bootmem_data[13] },
-  { .bdata = &node_bootmem_data[14] },
-  { .bdata = &node_bootmem_data[15] },
+  { .bdata = &bootmem_node_data[4] },
+  { .bdata = &bootmem_node_data[5] },
+  { .bdata = &bootmem_node_data[6] },
+  { .bdata = &bootmem_node_data[7] },
+  { .bdata = &bootmem_node_data[8] },
+  { .bdata = &bootmem_node_data[9] },
+  { .bdata = &bootmem_node_data[10] },
+  { .bdata = &bootmem_node_data[11] },
+  { .bdata = &bootmem_node_data[12] },
+  { .bdata = &bootmem_node_data[13] },
+  { .bdata = &bootmem_node_data[14] },
+  { .bdata = &bootmem_node_data[15] },
 #endif
 };
 
diff -puN arch/ia64/mm/discontig.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/ia64/mm/discontig.c
@@ -36,7 +36,6 @@ struct early_node_data {
 	struct ia64_node_data *node_data;
 	unsigned long pernode_addr;
 	unsigned long pernode_size;
-	struct bootmem_data bootmem_data;
 	unsigned long num_physpages;
 #ifdef CONFIG_ZONE_DMA
 	unsigned long num_dma_physpages;
@@ -76,7 +75,7 @@ static int __init build_node_maps(unsign
 				  int node)
 {
 	unsigned long cstart, epfn, end = start + len;
-	struct bootmem_data *bdp = &mem_data[node].bootmem_data;
+	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	epfn = GRANULEROUNDUP(end) >> PAGE_SHIFT;
 	cstart = GRANULEROUNDDOWN(start);
@@ -167,7 +166,7 @@ static void __init fill_pernode(int node
 {
 	void *cpu_data;
 	int cpus = early_nr_cpus_node(node);
-	struct bootmem_data *bdp = &mem_data[node].bootmem_data;
+	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	mem_data[node].pernode_addr = pernode;
 	mem_data[node].pernode_size = pernodesize;
@@ -224,7 +223,7 @@ static int __init find_pernode_space(uns
 {
 	unsigned long epfn;
 	unsigned long pernodesize = 0, pernode, pages, mapsize;
-	struct bootmem_data *bdp = &mem_data[node].bootmem_data;
+	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	epfn = (start + len) >> PAGE_SHIFT;
 
@@ -440,7 +439,7 @@ void __init find_memory(void)
 	efi_memmap_walk(find_max_min_low_pfn, NULL);
 
 	for_each_online_node(node)
-		if (mem_data[node].bootmem_data.node_low_pfn) {
+		if (bootmem_node_data[node].node_low_pfn) {
 			node_clear(node, memory_less_mask);
 			mem_data[node].min_pfn = ~0UL;
 		}
@@ -460,7 +459,7 @@ void __init find_memory(void)
 		else if (node_isset(node, memory_less_mask))
 			continue;
 
-		bdp = &mem_data[node].bootmem_data;
+		bdp = &bootmem_node_data[node];
 		pernode = mem_data[node].pernode_addr;
 		pernodesize = mem_data[node].pernode_size;
 		map = pernode + pernodesize;
diff -puN arch/m32r/mm/discontig.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/m32r/mm/discontig.c
@@ -20,7 +20,6 @@ extern char _end[];
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
-static bootmem_data_t node_bdata[MAX_NUMNODES] __initdata;
 
 pg_data_t m32r_node_data[MAX_NUMNODES];
 
@@ -81,7 +80,7 @@ unsigned long __init setup_memory(void)
 	for_each_online_node(nid) {
 		mp = &mem_prof[nid];
 		NODE_DATA(nid)=(pg_data_t *)&m32r_node_data[nid];
-		NODE_DATA(nid)->bdata = &node_bdata[nid];
+		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 		min_pfn = mp->start_pfn;
 		max_pfn = mp->start_pfn + mp->pages;
 		bootmap_size = init_bootmem_node(NODE_DATA(nid), mp->free_pfn,
@@ -163,4 +162,3 @@ unsigned long __init zone_sizes_init(voi
 
 	return holes;
 }
-
diff -puN arch/m68k/mm/init.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/m68k/mm/init.c
@@ -32,8 +32,6 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-static bootmem_data_t __initdata bootmem_data[MAX_NUMNODES];
-
 pg_data_t pg_data_map[MAX_NUMNODES];
 EXPORT_SYMBOL(pg_data_map);
 
@@ -58,7 +56,7 @@ void __init m68k_setup_node(int node)
 		pg_data_table[i] = pg_data_map + node;
 	}
 #endif
-	pg_data_map[node].bdata = bootmem_data + node;
+	pg_data_map[node].bdata = bootmem_node_data + node;
 	node_set_online(node);
 }
 
diff -puN arch/mips/sgi-ip27/ip27-memory.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -37,7 +37,6 @@
 
 static short __initdata slot_lastfilled_cache[MAX_COMPACT_NODES];
 static unsigned short __initdata slot_psize_cache[MAX_COMPACT_NODES][MAX_MEM_SLOTS];
-static struct bootmem_data __initdata plat_node_bdata[MAX_COMPACT_NODES];
 
 struct node_data *__node_data[MAX_COMPACT_NODES];
 
@@ -453,7 +452,7 @@ static void __init node_mem_init(cnodeid
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
 
 	pd = NODE_DATA(node);
-	pd->bdata = &plat_node_bdata[node];
+	pd->bdata = &bootmem_node_data[node];
 
 	cpus_clear(hub_data(node)->h_cpus);
 
diff -puN arch/parisc/mm/init.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/parisc/mm/init.c
@@ -36,7 +36,6 @@ extern int  data_start;
 
 #ifdef CONFIG_DISCONTIGMEM
 struct node_map_data node_data[MAX_NUMNODES] __read_mostly;
-bootmem_data_t bmem_data[MAX_NUMNODES] __read_mostly;
 unsigned char pfnnid_map[PFNNID_MAP_MAX] __read_mostly;
 #endif
 
@@ -262,7 +261,7 @@ static void __init setup_bootmem(void)
 #ifdef CONFIG_DISCONTIGMEM
 	for (i = 0; i < MAX_PHYSMEM_RANGES; i++) {
 		memset(NODE_DATA(i), 0, sizeof(pg_data_t));
-		NODE_DATA(i)->bdata = &bmem_data[i];
+		NODE_DATA(i)->bdata = &bootmem_node_data[i];
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
diff -puN arch/powerpc/mm/numa.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/powerpc/mm/numa.c
@@ -39,7 +39,6 @@ EXPORT_SYMBOL(numa_cpu_lookup_table);
 EXPORT_SYMBOL(numa_cpumask_lookup_table);
 EXPORT_SYMBOL(node_data);
 
-static bootmem_data_t __initdata plat_node_bdata[MAX_NUMNODES];
 static int min_common_depth;
 static int n_mem_addr_cells, n_mem_size_cells;
 
@@ -685,7 +684,7 @@ void __init do_init_bootmem(void)
   		dbg("node %d\n", nid);
 		dbg("NODE_DATA() = %p\n", NODE_DATA(nid));
 
-		NODE_DATA(nid)->bdata = &plat_node_bdata[nid];
+		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 		NODE_DATA(nid)->node_start_pfn = start_pfn;
 		NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
diff -puN arch/sh/mm/numa.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/sh/mm/numa.c
--- a/arch/sh/mm/numa.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/sh/mm/numa.c
@@ -14,7 +14,6 @@
 #include <linux/pfn.h>
 #include <asm/sections.h>
 
-static bootmem_data_t plat_node_bdata[MAX_NUMNODES];
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL_GPL(node_data);
 
@@ -35,7 +34,7 @@ void __init setup_memory(void)
 	NODE_DATA(0) = pfn_to_kaddr(free_pfn);
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
 	free_pfn += PFN_UP(sizeof(struct pglist_data));
-	NODE_DATA(0)->bdata = &plat_node_bdata[0];
+	NODE_DATA(0)->bdata = &bootmem_node_data[0];
 
 	/* Set up node 0 */
 	setup_bootmem_allocator(free_pfn);
@@ -66,7 +65,7 @@ void __init setup_bootmem_node(int nid, 
 	free_pfn += PFN_UP(sizeof(struct pglist_data));
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(nid)->bdata = &plat_node_bdata[nid];
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
diff -puN arch/sparc64/mm/init.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/sparc64/mm/init.c
@@ -787,7 +787,6 @@ int numa_cpu_lookup_table[NR_CPUS];
 cpumask_t numa_cpumask_lookup_table[MAX_NUMNODES];
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-static bootmem_data_t plat_node_bdata[MAX_NUMNODES];
 
 struct mdesc_mblock {
 	u64	base;
@@ -870,7 +869,7 @@ static void __init allocate_node_data(in
 	NODE_DATA(nid) = __va(paddr);
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(nid)->bdata = &plat_node_bdata[nid];
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 #endif
 
 	p = NODE_DATA(nid);
diff -puN arch/x86/mm/discontig_32.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/x86/mm/discontig_32.c
--- a/arch/x86/mm/discontig_32.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/x86/mm/discontig_32.c
@@ -41,7 +41,6 @@
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
-static bootmem_data_t node0_bdata;
 
 /*
  * numa interface - we expect the numa architecture specific code to have
@@ -382,7 +381,7 @@ unsigned long __init setup_memory(void)
 		propagate_e820_map_node(nid);
 
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
-	NODE_DATA(0)->bdata = &node0_bdata;
+	NODE_DATA(0)->bdata = &bootmem_node_data[0];
 	setup_bootmem_allocator();
 	return max_low_pfn;
 }
diff -puN arch/x86/mm/numa_64.c~mm-move-bootmem-descriptors-definition-to-a-single-place arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/arch/x86/mm/numa_64.c
@@ -27,8 +27,6 @@
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
-bootmem_data_t plat_node_bdata[MAX_NUMNODES];
-
 struct memnode memnode;
 
 #ifdef CONFIG_SMP
@@ -215,7 +213,7 @@ void __init setup_node_bootmem(int nodei
 		nodedata_phys + pgdat_size - 1);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
-	NODE_DATA(nodeid)->bdata = &plat_node_bdata[nodeid];
+	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = end_pfn - start_pfn;
 
@@ -671,5 +669,3 @@ void __init init_cpu_to_node(void)
 		numa_set_node(i, node);
 	}
 }
-
-
diff -puN include/linux/bootmem.h~mm-move-bootmem-descriptors-definition-to-a-single-place include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/include/linux/bootmem.h
@@ -38,6 +38,8 @@ typedef struct bootmem_data {
 	struct list_head list;
 } bootmem_data_t;
 
+extern bootmem_data_t bootmem_node_data[];
+
 extern unsigned long bootmem_bootmap_pages(unsigned long);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 extern void free_bootmem(unsigned long addr, unsigned long size);
diff -puN mm/bootmem.c~mm-move-bootmem-descriptors-definition-to-a-single-place mm/bootmem.c
--- a/mm/bootmem.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/mm/bootmem.c
@@ -36,6 +36,8 @@ static LIST_HEAD(bdata_list);
 unsigned long saved_max_pfn;
 #endif
 
+bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
+
 /* return the number of _pages_ that will be allocated for the boot bitmap */
 unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
diff -puN mm/page_alloc.c~mm-move-bootmem-descriptors-definition-to-a-single-place mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-bootmem-descriptors-definition-to-a-single-place
+++ a/mm/page_alloc.c
@@ -4006,9 +4006,7 @@ void __init set_dma_reserve(unsigned lon
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static bootmem_data_t contig_bootmem_data;
-struct pglist_data contig_page_data = { .bdata = &contig_bootmem_data };
