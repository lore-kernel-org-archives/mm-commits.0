From: akpm@osdl.org
Subject: + show_mem-for-ia64-sparsemem-numa.patch added to -mm tree
Date: Thu, 04 Jan 2007 13:33:43 -0800
Message-ID: <200701042133.l04LXhlR031934@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:55541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965077AbXADVdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 16:33:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gbeshers@sgi.com, tony.luck@intel.com


The patch titled
     show_mem() for IA64 sparsemem NUMA
has been added to the -mm tree.  Its filename is
     show_mem-for-ia64-sparsemem-numa.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: show_mem() for IA64 sparsemem NUMA
From: George Beshers <gbeshers@sgi.com>

On the ia64 architecture only this patch upgrades show_mem() for sparse
memory to be the same as it was for discontig memory.  It has been shown to
work on NUMA and flatmem architectures.

Signed-off-by: George Beshers <gbeshers@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/mm/contig.c |   74 +++++++++++++++++++++++++---------------
 1 files changed, 48 insertions(+), 26 deletions(-)

diff -puN arch/ia64/mm/contig.c~show_mem-for-ia64-sparsemem-numa arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~show_mem-for-ia64-sparsemem-numa
+++ a/arch/ia64/mm/contig.c
@@ -30,47 +30,69 @@ static unsigned long max_gap;
 #endif
 
 /**
- * show_mem - display a memory statistics summary
+ * show_mem - give short summary of memory stats
  *
- * Just walks the pages in the system and describes where they're allocated.
+ * Shows a simple page count of reserved and used pages in the system.
+ * For discontig machines, it does this on a per-pgdat basis.
  */
-void
-show_mem (void)
+void show_mem(void)
 {
-	int i, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
+	int i, total_reserved = 0;
+	int total_shared = 0, total_cached = 0;
+	unsigned long total_present = 0;
+	pg_data_t *pgdat;
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-
 	printk(KERN_INFO "Free swap:       %6ldkB\n",
 	       nr_swap_pages<<(PAGE_SHIFT-10));
-	i = max_mapnr;
-	for (i = 0; i < max_mapnr; i++) {
-		if (!pfn_valid(i)) {
+	printk(KERN_INFO "Node memory in pages:\n");
+	for_each_online_pgdat(pgdat) {
+		unsigned long present;
+		unsigned long flags;
+		int shared = 0, cached = 0, reserved = 0;
+
+		pgdat_resize_lock(pgdat, &flags);
+		present = pgdat->node_present_pages;
+		for(i = 0; i < pgdat->node_spanned_pages; i++) {
+			struct page *page;
+			if (pfn_valid(pgdat->node_start_pfn + i))
+				page = pfn_to_page(pgdat->node_start_pfn + i);
+			else {
 #ifdef CONFIG_VIRTUAL_MEM_MAP
-			if (max_gap < LARGE_GAP)
-				continue;
-			i = vmemmap_find_next_valid_pfn(0, i) - 1;
+				if (max_gap < LARGE_GAP)
+					continue;
 #endif
-			continue;
+				i = vmemmap_find_next_valid_pfn(pgdat->node_id,
+					 i) - 1;
+				continue;
+			}
+			if (PageReserved(page))
+				reserved++;
+			else if (PageSwapCache(page))
+				cached++;
+			else if (page_count(page))
+				shared += page_count(page)-1;
 		}
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (page_count(mem_map + i))
-			shared += page_count(mem_map + i) - 1;
+		pgdat_resize_unlock(pgdat, &flags);
+		total_present += present;
+		total_reserved += reserved;
+		total_cached += cached;
+		total_shared += shared;
+		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
+		       "shrd: %10d, swpd: %10d\n", pgdat->node_id,
+		       present, reserved, shared, cached);
 	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-	printk(KERN_INFO "%ld pages in page table cache\n",
+	printk(KERN_INFO "%ld pages of RAM\n", total_present);
+	printk(KERN_INFO "%d reserved pages\n", total_reserved);
+	printk(KERN_INFO "%d pages shared\n", total_shared);
+	printk(KERN_INFO "%d pages swap cached\n", total_cached);
+	printk(KERN_INFO "Total of %ld pages in page table cache\n",
 	       pgtable_quicklist_total_size());
+	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
 }
 
+
 /* physical address where the bootmem map is located */
 unsigned long bootmap_start;
 
_

Patches currently in -mm which might be from gbeshers@sgi.com are

show_mem-for-ia64-sparsemem-numa.patch
