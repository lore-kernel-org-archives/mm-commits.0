From: akpm@linux-foundation.org
Subject: [patch 129/142] arch, mm: remove arch specific show_mem
Date: Wed, 22 Feb 2017 15:46:13 -0800
Message-ID: <58ae22c5.ag2zNlQ6QWIOnx4c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbdBVXqO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, cmetcalf@mellanox.com, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, gxt@mprc.pku.edu.cn, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, jejb@parisc-linux.org, mgorman@suse.de, rientjes@google.com, tony.luck@intel.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: arch, mm: remove arch specific show_mem

We have a generic implementation for quite some time already.  If there is
any arch specific information to be printed then we should add a callback
called from the generic code rather than duplicate the whole show_mem. 
The current code has resulted in the code duplication and the output
divergence which is both confusing and adds maintainance costs.  Let's
just get rid of this mess.

Link: http://lkml.kernel.org/r/20170117091543.25850-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn> [UniCore32]
Acked-by: Helge Deller <deller@gmx.de> [for parisc]
Acked-by: Chris Metcalf <cmetcalf@mellanox.com> [for tile]
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c      |   48 ------------------------------------
 arch/parisc/mm/init.c    |   49 -------------------------------------
 arch/sparc/mm/init_32.c  |   11 --------
 arch/tile/mm/pgtable.c   |   45 ---------------------------------
 arch/unicore32/mm/init.c |   44 ---------------------------------
 5 files changed, 197 deletions(-)

diff -puN arch/ia64/mm/init.c~arch-mm-remove-arch-specific-show_mem arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~arch-mm-remove-arch-specific-show_mem
+++ a/arch/ia64/mm/init.c
@@ -684,51 +684,3 @@ int arch_remove_memory(u64 start, u64 si
 }
 #endif
 #endif
-
-/**
- * show_mem - give short summary of memory stats
- *
- * Shows a simple page count of reserved and used pages in the system.
- * For discontig machines, it does this on a per-pgdat basis.
- */
-void show_mem(unsigned int filter)
-{
-	int total_reserved = 0;
-	unsigned long total_present = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas(filter);
-	printk(KERN_INFO "Node memory in pages:\n");
-	for_each_online_pgdat(pgdat) {
-		unsigned long present;
-		unsigned long flags;
-		int reserved = 0;
-		int nid = pgdat->node_id;
-		int zoneid;
-
-		if (skip_free_areas_node(filter, nid))
-			continue;
-		pgdat_resize_lock(pgdat, &flags);
-
-		for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-			struct zone *zone = &pgdat->node_zones[zoneid];
-			if (!populated_zone(zone))
-				continue;
-
-			reserved += zone->present_pages - zone->managed_pages;
-		}
-		present = pgdat->node_present_pages;
-
-		pgdat_resize_unlock(pgdat, &flags);
-		total_present += present;
-		total_reserved += reserved;
-		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, ",
-		       nid, present, reserved);
-	}
-	printk(KERN_INFO "%ld pages of RAM\n", total_present);
-	printk(KERN_INFO "%d reserved pages\n", total_reserved);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
-}
diff -puN arch/parisc/mm/init.c~arch-mm-remove-arch-specific-show_mem arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~arch-mm-remove-arch-specific-show_mem
+++ a/arch/parisc/mm/init.c
@@ -653,55 +653,6 @@ void __init mem_init(void)
 unsigned long *empty_zero_page __read_mostly;
 EXPORT_SYMBOL(empty_zero_page);
 
-void show_mem(unsigned int filter)
-{
-	int total = 0,reserved = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas(filter);
-
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		int zoneid;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-			struct zone *zone = &pgdat->node_zones[zoneid];
-			if (!populated_zone(zone))
-				continue;
-
-			total += zone->present_pages;
-			reserved = zone->present_pages - zone->managed_pages;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-
-#ifdef CONFIG_DISCONTIGMEM
-	{
-		struct zonelist *zl;
-		int i, j;
-
-		for (i = 0; i < npmem_ranges; i++) {
-			zl = node_zonelist(i, 0);
-			for (j = 0; j < MAX_NR_ZONES; j++) {
-				struct zoneref *z;
-				struct zone *zone;
-
-				printk("Zone list for zone %d on node %d: ", j, i);
-				for_each_zone_zonelist(zone, z, zl, j)
-					printk("[%d/%s] ", zone_to_nid(zone),
-								zone->name);
-				printk("\n");
-			}
-		}
-	}
-#endif
-}
-
 /*
  * pagetable_init() sets up the page tables
  *
diff -puN arch/sparc/mm/init_32.c~arch-mm-remove-arch-specific-show_mem arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~arch-mm-remove-arch-specific-show_mem
+++ a/arch/sparc/mm/init_32.c
@@ -55,17 +55,6 @@ extern unsigned int sparc_ramdisk_size;
 
 unsigned long highstart_pfn, highend_pfn;
 
-void show_mem(unsigned int filter)
-{
-	printk("Mem-info:\n");
-	show_free_areas(filter);
-	printk("Free swap:       %6ldkB\n",
-	       get_nr_swap_pages() << (PAGE_SHIFT-10));
-	printk("%ld pages of RAM\n", totalram_pages);
-	printk("%ld free pages\n", nr_free_pages());
-}
-
-
 unsigned long last_valid_pfn;
 
 unsigned long calc_highpages(void)
diff -puN arch/tile/mm/pgtable.c~arch-mm-remove-arch-specific-show_mem arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~arch-mm-remove-arch-specific-show_mem
+++ a/arch/tile/mm/pgtable.c
@@ -36,51 +36,6 @@
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
 
-/*
- * The normal show_free_areas() is too verbose on Tile, with dozens
- * of processors and often four NUMA zones each with high and lowmem.
- */
-void show_mem(unsigned int filter)
-{
-	struct zone *zone;
-
-	pr_err("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu pagecache:%lu swap:%lu\n",
-	       (global_node_page_state(NR_ACTIVE_ANON) +
-		global_node_page_state(NR_ACTIVE_FILE)),
-	       (global_node_page_state(NR_INACTIVE_ANON) +
-		global_node_page_state(NR_INACTIVE_FILE)),
-	       global_node_page_state(NR_FILE_DIRTY),
-	       global_node_page_state(NR_WRITEBACK),
-	       global_node_page_state(NR_UNSTABLE_NFS),
-	       global_page_state(NR_FREE_PAGES),
-	       (global_page_state(NR_SLAB_RECLAIMABLE) +
-		global_page_state(NR_SLAB_UNRECLAIMABLE)),
-	       global_node_page_state(NR_FILE_MAPPED),
-	       global_page_state(NR_PAGETABLE),
-	       global_page_state(NR_BOUNCE),
-	       global_node_page_state(NR_FILE_PAGES),
-	       get_nr_swap_pages());
-
-	for_each_zone(zone) {
-		unsigned long flags, order, total = 0, largest_order = -1;
-
-		if (!populated_zone(zone))
-			continue;
-
-		spin_lock_irqsave(&zone->lock, flags);
-		for (order = 0; order < MAX_ORDER; order++) {
-			int nr = zone->free_area[order].nr_free;
-			total += nr << order;
-			if (nr)
-				largest_order = order;
-		}
-		spin_unlock_irqrestore(&zone->lock, flags);
-		pr_err("Node %d %7s: %lukB (largest %luKb)\n",
-		       zone_to_nid(zone), zone->name,
-		       K(total), largest_order ? K(1UL) << largest_order : 0);
-	}
-}
-
 /**
  * shatter_huge_page() - ensure a given address is mapped by a small page.
  *
diff -puN arch/unicore32/mm/init.c~arch-mm-remove-arch-specific-show_mem arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~arch-mm-remove-arch-specific-show_mem
+++ a/arch/unicore32/mm/init.c
@@ -57,50 +57,6 @@ early_param("initrd", early_initrd);
  */
 struct meminfo meminfo;
 
-void show_mem(unsigned int filter)
-{
-	int free = 0, total = 0, reserved = 0;
-	int shared = 0, cached = 0, slab = 0, i;
-	struct meminfo *mi = &meminfo;
-
-	printk(KERN_DEFAULT "Mem-info:\n");
-	show_free_areas(filter);
-
-	for_each_bank(i, mi) {
-		struct membank *bank = &mi->bank[i];
-		unsigned int pfn1, pfn2;
-		struct page *page, *end;
-
-		pfn1 = bank_pfn_start(bank);
-		pfn2 = bank_pfn_end(bank);
-
-		page = pfn_to_page(pfn1);
-		end  = pfn_to_page(pfn2 - 1) + 1;
-
-		do {
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-			page++;
-		} while (page < end);
-	}
-
-	printk(KERN_DEFAULT "%d pages of RAM\n", total);
-	printk(KERN_DEFAULT "%d free pages\n", free);
-	printk(KERN_DEFAULT "%d reserved pages\n", reserved);
-	printk(KERN_DEFAULT "%d slab pages\n", slab);
-	printk(KERN_DEFAULT "%d pages shared\n", shared);
-	printk(KERN_DEFAULT "%d pages swap cached\n", cached);
-}
