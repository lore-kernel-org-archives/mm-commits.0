From: akpm@linux-foundation.org
Subject: + mm-introduce-new-field-managed_pages-to-struct-zone.patch added to -mm tree
Date: Wed, 21 Nov 2012 14:04:07 -0800
Message-ID: <20121121220407.7BBC910034D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42282 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab2KVTkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Nov 2012 14:40:35 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so983076yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Nov 2012 11:40:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, chris2553@googlemail.com, hannes@cmpxchg.org, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: mm: introduce new field "managed_pages" to struct zone
has been added to the -mm tree.  Its filename is
     mm-introduce-new-field-managed_pages-to-struct-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: introduce new field "managed_pages" to struct zone

Currently a zone's present_pages is calcuated as below, which is
inaccurate and may cause trouble to memory hotplug.

	spanned_pages - absent_pages - memmap_pages - dma_reserve.

During fixing bugs caused by inaccurate zone->present_pages, we found
zone->present_pages has been abused.  The field zone->present_pages may
have different meanings in different contexts:

1) pages existing in a zone.
2) pages managed by the buddy system.

For more discussions about the issue, please refer to:
http://lkml.org/lkml/2012/11/5/866
https://patchwork.kernel.org/patch/1346751/

This patchset tries to introduce a new field named "managed_pages" to
struct zone, which counts "pages managed by the buddy system".  And revert
zone->present_pages to count "physical pages existing in a zone", which
also keep in consistence with pgdat->node_present_pages.

We will set an initial value for zone->managed_pages in function
free_area_init_core() and will adjust it later if the initial value is
inaccurate.

For DMA/normal zones, the initial value is set to:

	(spanned_pages - absent_pages - memmap_pages - dma_reserve)

Later zone->managed_pages will be adjusted to the accurate value when the
bootmem allocator frees all free pages to the buddy system in function
free_all_bootmem_node() and free_all_bootmem().

The bootmem allocator doesn't touch highmem pages, so highmem zones'
managed_pages is set to the accurate value "spanned_pages - absent_pages"
in function free_area_init_core() and won't be updated anymore.

This patch also adds a new field "managed_pages" to /proc/zoneinfo
and sysrq showmem.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   41 ++++++++++++++++++++++++++++++------
 mm/bootmem.c           |   21 ++++++++++++++++++
 mm/memory_hotplug.c    |   10 ++++++++
 mm/nobootmem.c         |   22 +++++++++++++++++++
 mm/page_alloc.c        |   44 ++++++++++++++++++++++++++-------------
 mm/vmstat.c            |    6 +++--
 6 files changed, 121 insertions(+), 23 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-new-field-managed_pages-to-struct-zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-new-field-managed_pages-to-struct-zone
+++ a/include/linux/mmzone.h
@@ -450,17 +450,44 @@ struct zone {
 	unsigned long		zone_start_pfn;
 
 	/*
-	 * zone_start_pfn, spanned_pages and present_pages are all
-	 * protected by span_seqlock.  It is a seqlock because it has
-	 * to be read outside of zone->lock, and it is done in the main
-	 * allocator path.  But, it is written quite infrequently.
+	 * spanned_pages is the total pages spanned by the zone, including
+	 * holes, which is calcualted as:
+	 * 	spanned_pages = zone_end_pfn - zone_start_pfn;
 	 *
-	 * The lock is declared along with zone->lock because it is
+	 * present_pages is physical pages existing within the zone, which
+	 * is calculated as:
+	 *	present_pages = spanned_pages - absent_pages(pags in holes);
+	 *
+	 * managed_pages is present pages managed by the buddy system, which
+	 * is calculated as (reserved_pages includes pages allocated by the
+	 * bootmem allocator):
+	 *	managed_pages = present_pages - reserved_pages;
+	 *
+	 * So present_pages may be used by memory hotplug or memory power
+	 * management logic to figure out unmanaged pages by checking
+	 * (present_pages - managed_pages). And managed_pages should be used
+	 * by page allocator and vm scanner to calculate all kinds of watermarks
+	 * and thresholds.
+	 *
+	 * Lock Rules:
+	 *
+	 * zone_start_pfn, spanned_pages are protected by span_seqlock.
+	 * It is a seqlock because it has to be read outside of zone->lock,
+	 * and it is done in the main allocator path.  But, it is written
+	 * quite infrequently.
+	 *
+	 * The span_seq lock is declared along with zone->lock because it is
 	 * frequently read in proximity to zone->lock.  It's good to
 	 * give them a chance of being in the same cacheline.
+	 *
+	 * Writing access to present_pages and managed_pages at runtime should
+	 * be protected by lock_memory_hotplug()/unlock_memory_hotplug().
+	 * Any reader who can't tolerant drift of present_pages and
+	 * managed_pages should hold memory hotplug lock to get a stable value.
 	 */
-	unsigned long		spanned_pages;	/* total size, including holes */
-	unsigned long		present_pages;	/* amount of memory (excluding holes) */
+	unsigned long		spanned_pages;
+	unsigned long		present_pages;
+	unsigned long		managed_pages;
 
 	/*
 	 * rarely used fields:
diff -puN mm/bootmem.c~mm-introduce-new-field-managed_pages-to-struct-zone mm/bootmem.c
--- a/mm/bootmem.c~mm-introduce-new-field-managed_pages-to-struct-zone
+++ a/mm/bootmem.c
@@ -229,6 +229,22 @@ static unsigned long __init free_all_boo
 	return count;
 }
 
+static void reset_node_lowmem_managed_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	/*
+	 * In free_area_init_core(), highmem zone's managed_pages is set to
+	 * present_pages, and bootmem allocator doesn't allocate from highmem
+	 * zones. So there's no need to recalculate managed_pages because all
+	 * highmem pages will be managed by the buddy system. Here highmem
+	 * zone also includes highmem movable zone.
+	 */
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		if (!is_highmem(z))
+			z->managed_pages = 0;
+}
+
 /**
  * free_all_bootmem_node - release a node's free pages to the buddy allocator
  * @pgdat: node to be released
@@ -238,6 +254,7 @@ static unsigned long __init free_all_boo
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
+	reset_node_lowmem_managed_pages(pgdat);
 	return free_all_bootmem_core(pgdat->bdata);
 }
 
@@ -250,6 +267,10 @@ unsigned long __init free_all_bootmem(vo
 {
 	unsigned long total_pages = 0;
 	bootmem_data_t *bdata;
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat)
+		reset_node_lowmem_managed_pages(pgdat);
 
 	list_for_each_entry(bdata, &bdata_list, list)
 		total_pages += free_all_bootmem_core(bdata);
diff -puN mm/memory_hotplug.c~mm-introduce-new-field-managed_pages-to-struct-zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-introduce-new-field-managed_pages-to-struct-zone
+++ a/mm/memory_hotplug.c
@@ -106,6 +106,7 @@ static void get_page_bootmem(unsigned lo
 void __ref put_page_bootmem(struct page *page)
 {
 	unsigned long type;
+	static DEFINE_MUTEX(ppb_lock);
 
 	type = (unsigned long) page->lru.next;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
@@ -115,7 +116,14 @@ void __ref put_page_bootmem(struct page 
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
+
+		/*
+		 * Please refer to comment for __free_pages_bootmem()
+		 * for why we serialize here.
+		 */
+		mutex_lock(&ppb_lock);
 		__free_pages_bootmem(page, 0);
+		mutex_unlock(&ppb_lock);
 	}
 
 }
@@ -748,6 +756,7 @@ int __ref online_pages(unsigned long pfn
 		return ret;
 	}
 
+	zone->managed_pages += onlined_pages;
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 	if (onlined_pages) {
@@ -1321,6 +1330,7 @@ repeat:
 	/* reset pagetype flags and makes migrate type to be MOVABLE */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	/* removal success */
+	zone->managed_pages -= offlined_pages;
 	zone->present_pages -= offlined_pages;
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
diff -puN mm/nobootmem.c~mm-introduce-new-field-managed_pages-to-struct-zone mm/nobootmem.c
--- a/mm/nobootmem.c~mm-introduce-new-field-managed_pages-to-struct-zone
+++ a/mm/nobootmem.c
@@ -137,6 +137,22 @@ unsigned long __init free_low_memory_cor
 	return count;
 }
 
+static void reset_node_lowmem_managed_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	/*
+	 * In free_area_init_core(), highmem zone's managed_pages is set to
+	 * present_pages, and bootmem allocator doesn't allocate from highmem
+	 * zones. So there's no need to recalculate managed_pages because all
+	 * highmem pages will be managed by the buddy system. Here highmem
+	 * zone also includes highmem movable zone.
+	 */
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		if (!is_highmem(z))
+			z->managed_pages = 0;
+}
+
 /**
  * free_all_bootmem_node - release a node's free pages to the buddy allocator
  * @pgdat: node to be released
@@ -146,6 +162,7 @@ unsigned long __init free_low_memory_cor
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
+	reset_node_lowmem_managed_pages(pgdat);
 
 	/* free_low_memory_core_early(MAX_NUMNODES) will be called later */
 	return 0;
@@ -158,6 +175,11 @@ unsigned long __init free_all_bootmem_no
  */
 unsigned long __init free_all_bootmem(void)
 {
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat)
+		reset_node_lowmem_managed_pages(pgdat);
+
 	/*
 	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
 	 *  because in some case like Node0 doesn't have RAM installed
diff -puN mm/page_alloc.c~mm-introduce-new-field-managed_pages-to-struct-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-new-field-managed_pages-to-struct-zone
+++ a/mm/page_alloc.c
@@ -734,6 +734,13 @@ static void __free_pages_ok(struct page 
 	local_irq_restore(flags);
 }
 
+/*
+ * Read access to zone->managed_pages is safe because it's unsigned long,
+ * but we still need to serialize writers. Currently all callers of
+ * __free_pages_bootmem() except put_page_bootmem() should only be used
+ * at boot time. So for shorter boot time, we have shift the burden to
+ * put_page_bootmem() to serialize writers.
+ */
 void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
@@ -749,6 +756,7 @@ void __meminit __free_pages_bootmem(stru
 		set_page_count(p, 0);
 	}
 
+	page_zone(page)->managed_pages += 1 << order;
 	set_page_refcounted(page);
 	__free_pages(page, order);
 }
@@ -3018,6 +3026,7 @@ void show_free_areas(unsigned int filter
 			" isolated(anon):%lukB"
 			" isolated(file):%lukB"
 			" present:%lukB"
+			" managed:%lukB"
 			" mlocked:%lukB"
 			" dirty:%lukB"
 			" writeback:%lukB"
@@ -3047,6 +3056,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_ISOLATED_ANON)),
 			K(zone_page_state(zone, NR_ISOLATED_FILE)),
 			K(zone->present_pages),
+			K(zone->managed_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
 			K(zone_page_state(zone, NR_FILE_DIRTY)),
 			K(zone_page_state(zone, NR_WRITEBACK)),
@@ -4539,48 +4549,54 @@ static void __paginginit free_area_init_
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
-		unsigned long size, realsize, memmap_pages;
+		unsigned long size, realsize, freesize, memmap_pages;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
-		realsize = size - zone_absent_pages_in_node(nid, j,
+		realsize = freesize = size - zone_absent_pages_in_node(nid, j,
 								zholes_size);
 
 		/*
-		 * Adjust realsize so that it accounts for how much memory
+		 * Adjust freesize so that it accounts for how much memory
 		 * is used by this zone for memmap. This affects the watermark
 		 * and per-cpu initialisations
 		 */
 		memmap_pages =
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
-		if (realsize >= memmap_pages) {
-			realsize -= memmap_pages;
+		if (freesize >= memmap_pages) {
+			freesize -= memmap_pages;
 			if (memmap_pages)
 				printk(KERN_DEBUG
 				       "  %s zone: %lu pages used for memmap\n",
 				       zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
-				"  %s zone: %lu pages exceeds realsize %lu\n",
-				zone_names[j], memmap_pages, realsize);
+				"  %s zone: %lu pages exceeds freesize %lu\n",
+				zone_names[j], memmap_pages, freesize);
 
 		/* Account for reserved pages */
-		if (j == 0 && realsize > dma_reserve) {
-			realsize -= dma_reserve;
+		if (j == 0 && freesize > dma_reserve) {
+			freesize -= dma_reserve;
 			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
 					zone_names[0], dma_reserve);
 		}
 
 		if (!is_highmem_idx(j))
-			nr_kernel_pages += realsize;
-		nr_all_pages += realsize;
+			nr_kernel_pages += freesize;
+		nr_all_pages += freesize;
 
 		zone->spanned_pages = size;
-		zone->present_pages = realsize;
+		zone->present_pages = freesize;
+		/*
+		 * Set an approximate value for lowmem here, it will be adjusted
+		 * when the bootmem allocator frees pages into the buddy system.
+		 * And all highmem pages will be managed by the buddy system.
+		 */
+		zone->managed_pages = is_highmem_idx(j) ? realsize : freesize;
 #ifdef CONFIG_NUMA
 		zone->node = nid;
-		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
+		zone->min_unmapped_pages = (freesize*sysctl_min_unmapped_ratio)
 						/ 100;
-		zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
+		zone->min_slab_pages = (freesize * sysctl_min_slab_ratio) / 100;
 #endif
 		zone->name = zone_names[j];
 		spin_lock_init(&zone->lock);
diff -puN mm/vmstat.c~mm-introduce-new-field-managed_pages-to-struct-zone mm/vmstat.c
--- a/mm/vmstat.c~mm-introduce-new-field-managed_pages-to-struct-zone
+++ a/mm/vmstat.c
@@ -1001,14 +1001,16 @@ static void zoneinfo_show_print(struct s
 		   "\n        high     %lu"
 		   "\n        scanned  %lu"
 		   "\n        spanned  %lu"
-		   "\n        present  %lu",
+		   "\n        present  %lu"
+		   "\n        managed  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->pages_scanned,
 		   zone->spanned_pages,
-		   zone->present_pages);
+		   zone->present_pages,
+		   zone->managed_pages);
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		seq_printf(m, "\n    %-12s %lu", vmstat_text[i],
_

Patches currently in -mm which might be from liuj97@gmail.com are

linux-next.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch

