From: akpm@linux-foundation.org
Subject: - fix-section-mismatch-of-memory-hotplug-related-code.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:35 -0700
Message-ID: <200705090243.l492hZQa008490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970007AbXEICnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix section mismatch of memory hotplug related code.
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-of-memory-hotplug-related-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix section mismatch of memory hotplug related code.
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This is to fix many section mismatches of code related to memory hotplug.
I checked compile with memory hotplug on/off on ia64 and x86-64 box.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c |    2 ++
 arch/x86_64/mm/init.c    |    6 +++---
 drivers/acpi/numa.c      |    4 ++--
 mm/page_alloc.c          |   26 +++++++++++++-------------
 mm/sparse.c              |   10 ++++++----
 5 files changed, 26 insertions(+), 22 deletions(-)

diff -puN arch/ia64/mm/discontig.c~fix-section-mismatch-of-memory-hotplug-related-code arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~fix-section-mismatch-of-memory-hotplug-related-code
+++ a/arch/ia64/mm/discontig.c
@@ -693,6 +693,7 @@ void __init paging_init(void)
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 pg_data_t *arch_alloc_nodedata(int nid)
 {
 	unsigned long size = compute_pernodesize(nid);
@@ -710,3 +711,4 @@ void arch_refresh_nodedata(int update_no
 	pgdat_list[update_node] = update_pgdat;
 	scatter_node_data();
 }
+#endif
diff -puN arch/x86_64/mm/init.c~fix-section-mismatch-of-memory-hotplug-related-code arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~fix-section-mismatch-of-memory-hotplug-related-code
+++ a/arch/x86_64/mm/init.c
@@ -172,7 +172,7 @@ __set_fixmap (enum fixed_addresses idx, 
 	set_pte_phys(address, phys, prot);
 }
 
-unsigned long __initdata table_start, table_end; 
+unsigned long __meminitdata table_start, table_end;
 
 static __meminit void *alloc_low_page(unsigned long *phys)
 { 
@@ -204,7 +204,7 @@ static __meminit void unmap_low_page(voi
 } 
 
 /* Must run before zap_low_mappings */
-__init void *early_ioremap(unsigned long addr, unsigned long size)
+__meminit void *early_ioremap(unsigned long addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd, *last_pmd;
@@ -233,7 +233,7 @@ __init void *early_ioremap(unsigned long
 }
 
 /* To avoid virtual aliases later */
-__init void early_iounmap(void *addr, unsigned long size)
+__meminit void early_iounmap(void *addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd;
diff -puN drivers/acpi/numa.c~fix-section-mismatch-of-memory-hotplug-related-code drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~fix-section-mismatch-of-memory-hotplug-related-code
+++ a/drivers/acpi/numa.c
@@ -228,7 +228,7 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
-int acpi_get_pxm(acpi_handle h)
+int __meminit acpi_get_pxm(acpi_handle h)
 {
 	unsigned long pxm;
 	acpi_status status;
@@ -246,7 +246,7 @@ int acpi_get_pxm(acpi_handle h)
 }
 EXPORT_SYMBOL(acpi_get_pxm);
 
-int acpi_get_node(acpi_handle *handle)
+int __meminit acpi_get_node(acpi_handle *handle)
 {
 	int pxm, node = -1;
 
diff -puN mm/page_alloc.c~fix-section-mismatch-of-memory-hotplug-related-code mm/page_alloc.c
--- a/mm/page_alloc.c~fix-section-mismatch-of-memory-hotplug-related-code
+++ a/mm/page_alloc.c
@@ -103,7 +103,7 @@ int min_free_kbytes = 1024;
 
 unsigned long __meminitdata nr_kernel_pages;
 unsigned long __meminitdata nr_all_pages;
-static unsigned long __initdata dma_reserve;
+static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
   /*
@@ -126,10 +126,10 @@ static unsigned long __initdata dma_rese
     #endif
   #endif
 
-  struct node_active_region __initdata early_node_map[MAX_ACTIVE_REGIONS];
-  int __initdata nr_nodemap_entries;
-  unsigned long __initdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  unsigned long __initdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+  struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
+  int __meminitdata nr_nodemap_entries;
+  unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
+  unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
   unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES];
   unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES];
@@ -2267,7 +2267,7 @@ __meminit int init_currently_empty_zone(
  * Basic iterator support. Return the first range of PFNs for a node
  * Note: nid == MAX_NUMNODES returns first region regardless of node
  */
-static int __init first_active_region_index_in_nid(int nid)
+static int __meminit first_active_region_index_in_nid(int nid)
 {
 	int i;
 
@@ -2282,7 +2282,7 @@ static int __init first_active_region_in
  * Basic iterator support. Return the next active range of PFNs for a node
  * Note: nid == MAX_NUMNODES returns next region regardles of node
  */
-static int __init next_active_region_index_in_nid(int index, int nid)
+static int __meminit next_active_region_index_in_nid(int index, int nid)
 {
 	for (index = index + 1; index < nr_nodemap_entries; index++)
 		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
@@ -2435,7 +2435,7 @@ static void __init account_node_boundary
  * with no available memory, a warning is printed and the start and end
  * PFNs will be 0.
  */
-void __init get_pfn_range_for_nid(unsigned int nid,
+void __meminit get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	int i;
@@ -2460,7 +2460,7 @@ void __init get_pfn_range_for_nid(unsign
  * Return the number of pages a zone spans in a node, including holes
  * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
  */
-unsigned long __init zone_spanned_pages_in_node(int nid,
+unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
 {
@@ -2488,7 +2488,7 @@ unsigned long __init zone_spanned_pages_
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __init __absent_pages_in_range(int nid,
+unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -2548,7 +2548,7 @@ unsigned long __init absent_pages_in_ran
 }
 
 /* Return the number of page frames in holes in a zone on a node */
-unsigned long __init zone_absent_pages_in_node(int nid,
+unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
 {
@@ -2584,7 +2584,7 @@ static inline unsigned long zone_absent_
 
 #endif
 
-static void __init calculate_node_totalpages(struct pglist_data *pgdat,
+static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	unsigned long realtotalpages, totalpages = 0;
@@ -2692,7 +2692,7 @@ static void __meminit free_area_init_cor
 	}
 }
 
-static void __init alloc_node_mem_map(struct pglist_data *pgdat)
+static void __meminit alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	/* Skip empty nodes */
 	if (!pgdat->node_spanned_pages)
diff -puN mm/sparse.c~fix-section-mismatch-of-memory-hotplug-related-code mm/sparse.c
--- a/mm/sparse.c~fix-section-mismatch-of-memory-hotplug-related-code
+++ a/mm/sparse.c
@@ -61,7 +61,7 @@ static struct mem_section *sparse_index_
 	return section;
 }
 
-static int sparse_index_init(unsigned long section_nr, int nid)
+static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	static DEFINE_SPINLOCK(index_init_lock);
 	unsigned long root = SECTION_NR_TO_ROOT(section_nr);
@@ -138,7 +138,7 @@ static inline int sparse_early_nid(struc
 }
 
 /* Record a memory area against a node. */
-void memory_present(int nid, unsigned long start, unsigned long end)
+void __init memory_present(int nid, unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 
@@ -197,7 +197,7 @@ struct page *sparse_decode_mem_map(unsig
 	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
 }
 
-static int sparse_init_one_section(struct mem_section *ms,
+static int __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map)
 {
 	if (!valid_section(ms))
@@ -209,7 +209,7 @@ static int sparse_init_one_section(struc
 	return 1;
 }
 
-static struct page *sparse_early_mem_map_alloc(unsigned long pnum)
+static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
 	struct mem_section *ms = __nr_to_section(pnum);
@@ -288,6 +288,7 @@ void __init sparse_init(void)
 	}
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
@@ -327,3 +328,4 @@ out:
 		__kfree_section_memmap(memmap, nr_pages);
 	return ret;
 }
+#endif
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
fix-unnecesary-meminit.patch
move-free-pages-between-lists-on-steal.patch
create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch
handle-kernelcore=-generic.patch
