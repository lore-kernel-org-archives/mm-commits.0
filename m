From: akpm@linux-foundation.org
Subject: [merged] mm-show_mem-remove-show_mem_filter_page_count.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:50 -0800
Message-ID: <52e02642.fzR3svAVKktrUJx/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaAVUMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, rientjes@google.com, linux@arm.linux.org.uk, jejb@parisc-linux.org, mgorman@suse.de

Subject: [merged] mm-show_mem-remove-show_mem_filter_page_count.patch removed from -mm tree
To: mgorman@suse.de,jejb@parisc-linux.org,linux@arm.linux.org.uk,rientjes@google.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:50 -0800


The patch titled
     Subject: mm, show_mem: remove SHOW_MEM_FILTER_PAGE_COUNT
has been removed from the -mm tree.  Its filename was
     mm-show_mem-remove-show_mem_filter_page_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm, show_mem: remove SHOW_MEM_FILTER_PAGE_COUNT

Commit 4b59e6c4 ("mm, show_mem: suppress page counts in non-blockable
contexts") introduced SHOW_MEM_FILTER_PAGE_COUNT to suppress PFN walks on
large memory machines.  Commit c78e9363 ("mm: do not walk all of system
memory during show_mem") avoided a PFN walk in the generic show_mem helper
which removes the requirement for SHOW_MEM_FILTER_PAGE_COUNT in that case.

This patch removes PFN walkers from the arch-specific implementations that
report on a per-node or per-zone granularity.  ARM and unicore32 still do
a PFN walk as they report memory usage on each bank which is a much finer
granularity where the debugging information may still be of use.  As the
remaining arches doing PFN walks have relatively small amounts of memory,
this patch simply removes SHOW_MEM_FILTER_PAGE_COUNT.

[akpm@linux-foundation.org: fix parisc]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: James Bottomley <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c       |    3 -
 arch/ia64/mm/contig.c    |   68 -------------------------------------
 arch/ia64/mm/discontig.c |   63 ----------------------------------
 arch/ia64/mm/init.c      |   48 ++++++++++++++++++++++++++
 arch/parisc/mm/init.c    |   61 +++++++++------------------------
 arch/unicore32/mm/init.c |    3 -
 include/linux/mm.h       |    1 
 lib/show_mem.c           |    3 -
 mm/page_alloc.c          |    7 ---
 9 files changed, 66 insertions(+), 191 deletions(-)

diff -puN arch/arm/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/arch/arm/mm/init.c
@@ -92,9 +92,6 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 
-	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
-		return;
-
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff -puN arch/ia64/mm/contig.c~mm-show_mem-remove-show_mem_filter_page_count arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/arch/ia64/mm/contig.c
@@ -31,74 +31,6 @@
 static unsigned long max_gap;
 #endif
 
-/**
- * show_mem - give short summary of memory stats
- *
- * Shows a simple page count of reserved and used pages in the system.
- * For discontig machines, it does this on a per-pgdat basis.
- */
-void show_mem(unsigned int filter)
-{
-	int i, total_reserved = 0;
-	int total_shared = 0, total_cached = 0;
-	unsigned long total_present = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas(filter);
-	printk(KERN_INFO "Node memory in pages:\n");
-	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
-		return;
-	for_each_online_pgdat(pgdat) {
-		unsigned long present;
-		unsigned long flags;
-		int shared = 0, cached = 0, reserved = 0;
-		int nid = pgdat->node_id;
-
-		if (skip_free_areas_node(filter, nid))
-			continue;
-		pgdat_resize_lock(pgdat, &flags);
-		present = pgdat->node_present_pages;
-		for(i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page;
-			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
-				touch_nmi_watchdog();
-			if (pfn_valid(pgdat->node_start_pfn + i))
-				page = pfn_to_page(pgdat->node_start_pfn + i);
-			else {
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-				if (max_gap < LARGE_GAP)
-					continue;
-#endif
-				i = vmemmap_find_next_valid_pfn(nid, i) - 1;
-				continue;
-			}
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page)-1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-		total_present += present;
-		total_reserved += reserved;
-		total_cached += cached;
-		total_shared += shared;
-		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
-		       "shrd: %10d, swpd: %10d\n", nid,
-		       present, reserved, shared, cached);
-	}
-	printk(KERN_INFO "%ld pages of RAM\n", total_present);
-	printk(KERN_INFO "%d reserved pages\n", total_reserved);
-	printk(KERN_INFO "%d pages shared\n", total_shared);
-	printk(KERN_INFO "%d pages swap cached\n", total_cached);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
-}
-
-
 /* physical address where the bootmem map is located */
 unsigned long bootmap_start;
 
diff -puN arch/ia64/mm/discontig.c~mm-show_mem-remove-show_mem_filter_page_count arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/arch/ia64/mm/discontig.c
@@ -608,69 +608,6 @@ void *per_cpu_init(void)
 #endif /* CONFIG_SMP */
 
 /**
- * show_mem - give short summary of memory stats
- *
- * Shows a simple page count of reserved and used pages in the system.
- * For discontig machines, it does this on a per-pgdat basis.
- */
-void show_mem(unsigned int filter)
-{
-	int i, total_reserved = 0;
-	int total_shared = 0, total_cached = 0;
-	unsigned long total_present = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas(filter);
-	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
-		return;
-	printk(KERN_INFO "Node memory in pages:\n");
-	for_each_online_pgdat(pgdat) {
-		unsigned long present;
-		unsigned long flags;
-		int shared = 0, cached = 0, reserved = 0;
-		int nid = pgdat->node_id;
-
-		if (skip_free_areas_node(filter, nid))
-			continue;
-		pgdat_resize_lock(pgdat, &flags);
-		present = pgdat->node_present_pages;
-		for(i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page;
-			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
-				touch_nmi_watchdog();
-			if (pfn_valid(pgdat->node_start_pfn + i))
-				page = pfn_to_page(pgdat->node_start_pfn + i);
-			else {
-				i = vmemmap_find_next_valid_pfn(nid, i) - 1;
-				continue;
-			}
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page)-1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-		total_present += present;
-		total_reserved += reserved;
-		total_cached += cached;
-		total_shared += shared;
-		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
-		       "shrd: %10d, swpd: %10d\n", nid,
-		       present, reserved, shared, cached);
-	}
-	printk(KERN_INFO "%ld pages of RAM\n", total_present);
-	printk(KERN_INFO "%d reserved pages\n", total_reserved);
-	printk(KERN_INFO "%d pages shared\n", total_shared);
-	printk(KERN_INFO "%d pages swap cached\n", total_cached);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
-}
-
-/**
  * call_pernode_memory - use SRAT to call callback functions with node info
  * @start: physical start of range
  * @len: length of range
diff -puN arch/ia64/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/arch/ia64/mm/init.c
@@ -684,3 +684,51 @@ per_linux32_init(void)
 }
 
 __initcall(per_linux32_init);
+
+/**
+ * show_mem - give short summary of memory stats
+ *
+ * Shows a simple page count of reserved and used pages in the system.
+ * For discontig machines, it does this on a per-pgdat basis.
+ */
+void show_mem(unsigned int filter)
+{
+	int total_reserved = 0;
+	unsigned long total_present = 0;
+	pg_data_t *pgdat;
+
+	printk(KERN_INFO "Mem-info:\n");
+	show_free_areas(filter);
+	printk(KERN_INFO "Node memory in pages:\n");
+	for_each_online_pgdat(pgdat) {
+		unsigned long present;
+		unsigned long flags;
+		int reserved = 0;
+		int nid = pgdat->node_id;
+		int zoneid;
+
+		if (skip_free_areas_node(filter, nid))
+			continue;
+		pgdat_resize_lock(pgdat, &flags);
+
+		for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+			struct zone *zone = &pgdat->node_zones[zoneid];
+			if (!populated_zone(zone))
+				continue;
+
+			reserved += zone->present_pages - zone->managed_pages;
+		}
+		present = pgdat->node_present_pages;
+
+		pgdat_resize_unlock(pgdat, &flags);
+		total_present += present;
+		total_reserved += reserved;
+		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, ",
+		       nid, present, reserved);
+	}
+	printk(KERN_INFO "%ld pages of RAM\n", total_present);
+	printk(KERN_INFO "%d reserved pages\n", total_reserved);
+	printk(KERN_INFO "Total of %ld pages in page table cache\n",
+	       quicklist_total_size());
+	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
+}
diff -puN arch/parisc/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/arch/parisc/mm/init.c
@@ -645,55 +645,30 @@ EXPORT_SYMBOL(empty_zero_page);
 
 void show_mem(unsigned int filter)
 {
-	int i,free = 0,total = 0,reserved = 0;
-	int shared = 0, cached = 0;
+	int total = 0,reserved = 0;
+	pg_data_t *pgdat;
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
-	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
-		return;
-#ifndef CONFIG_DISCONTIGMEM
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(&mem_map[i]))
-			free++;
-		else
-			shared += page_count(&mem_map[i]) - 1;
-	}
-#else
-	for (i = 0; i < npmem_ranges; i++) {
-		int j;
-
-		for (j = node_start_pfn(i); j < node_end_pfn(i); j++) {
-			struct page *p;
-			unsigned long flags;
-
-			pgdat_resize_lock(NODE_DATA(i), &flags);
-			p = nid_page_nr(i, j) - node_start_pfn(i);
-
-			total++;
-			if (PageReserved(p))
-				reserved++;
-			else if (PageSwapCache(p))
-				cached++;
-			else if (!page_count(p))
-				free++;
-			else
-				shared += page_count(p) - 1;
-			pgdat_resize_unlock(NODE_DATA(i), &flags);
-        	}
+
+	for_each_online_pgdat(pgdat) {
+		unsigned long flags;
+		int zoneid;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+			struct zone *zone = &pgdat->node_zones[zoneid];
+			if (!populated_zone(zone))
+				continue;
+
+			total += zone->present_pages;
+			reserved = zone->present_pages - zone->managed_pages;
+		}
+		pgdat_resize_unlock(pgdat, &flags);
 	}
-#endif
+
 	printk(KERN_INFO "%d pages of RAM\n", total);
 	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-
 
 #ifdef CONFIG_DISCONTIGMEM
 	{
diff -puN arch/unicore32/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/arch/unicore32/mm/init.c
@@ -66,9 +66,6 @@ void show_mem(unsigned int filter)
 	printk(KERN_DEFAULT "Mem-info:\n");
 	show_free_areas(filter);
 
-	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
-		return;
-
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff -puN include/linux/mm.h~mm-show_mem-remove-show_mem_filter_page_count include/linux/mm.h
--- a/include/linux/mm.h~mm-show_mem-remove-show_mem_filter_page_count
+++ a/include/linux/mm.h
@@ -1016,7 +1016,6 @@ extern void pagefault_out_of_memory(void
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
-#define SHOW_MEM_FILTER_PAGE_COUNT	(0x0002u)	/* page type count */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
diff -puN lib/show_mem.c~mm-show_mem-remove-show_mem_filter_page_count lib/show_mem.c
--- a/lib/show_mem.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/lib/show_mem.c
@@ -17,9 +17,6 @@ void show_mem(unsigned int filter)
 	printk("Mem-Info:\n");
 	show_free_areas(filter);
 
-	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
-		return;
-
 	for_each_online_pgdat(pgdat) {
 		unsigned long flags;
 		int zoneid;
diff -puN mm/page_alloc.c~mm-show_mem-remove-show_mem_filter_page_count mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show_mem-remove-show_mem_filter_page_count
+++ a/mm/page_alloc.c
@@ -2072,13 +2072,6 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		return;
 
 	/*
-	 * Walking all memory to count page types is very expensive and should
-	 * be inhibited in non-blockable contexts.
-	 */
-	if (!(gfp_mask & __GFP_WAIT))
-		filter |= SHOW_MEM_FILTER_PAGE_COUNT;
-
-	/*
 	 * This documents exceptions given to allocations in certain
 	 * contexts that are allowed to allocate outside current's set
 	 * of allowed nodes.
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-improve-documentation-of-page_order-v2.patch
mm-improve-documentation-of-page_order-v2-fix.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

