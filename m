From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-memory-compaction-core.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:31 -0700
Message-ID: <201004221906.o3MJ6VSk002122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577Ab0DVTHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: memory compaction core
has been removed from the -mm tree.  Its filename was
     mm-compaction-memory-compaction-core.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: memory compaction core
From: Mel Gorman <mel@csn.ul.ie>

This patch is the core of a mechanism which compacts memory in a zone by
relocating movable pages towards the end of the zone.

A single compaction run involves a migration scanner and a free scanner. 
Both scanners operate on pageblock-sized areas in the zone.  The migration
scanner starts at the bottom of the zone and searches for all movable
pages within each area, isolating them onto a private list called
migratelist.  The free scanner starts at the top of the zone and searches
for suitable areas and consumes the free pages within making them
available for the migration scanner.  The pages isolated for migration are
then migrated to the newly isolated free pages.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    9 
 include/linux/mm.h         |    1 
 include/linux/swap.h       |    1 
 include/linux/vmstat.h     |    1 
 mm/Makefile                |    1 
 mm/compaction.c            |  379 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |   39 +++
 mm/vmstat.c                |    5 
 8 files changed, 436 insertions(+)

diff -puN /dev/null include/linux/compaction.h
--- /dev/null
+++ a/include/linux/compaction.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_COMPACTION_H
+#define _LINUX_COMPACTION_H
+
+/* Return values for compact_zone() */
+#define COMPACT_INCOMPLETE	0
+#define COMPACT_PARTIAL		1
+#define COMPACT_COMPLETE	2
+
+#endif /* _LINUX_COMPACTION_H */
diff -puN include/linux/mm.h~mm-compaction-memory-compaction-core include/linux/mm.h
--- a/include/linux/mm.h~mm-compaction-memory-compaction-core
+++ a/include/linux/mm.h
@@ -335,6 +335,7 @@ void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
+int split_free_page(struct page *page);
 
 /*
  * Compound pages have a destructor function.  Provide a
diff -puN include/linux/swap.h~mm-compaction-memory-compaction-core include/linux/swap.h
--- a/include/linux/swap.h~mm-compaction-memory-compaction-core
+++ a/include/linux/swap.h
@@ -151,6 +151,7 @@ enum {
 };
 
 #define SWAP_CLUSTER_MAX 32
+#define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
 #define SWAP_MAP_BAD	0x3f	/* Note pageblock is bad, in first swap_map */
diff -puN include/linux/vmstat.h~mm-compaction-memory-compaction-core include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-compaction-memory-compaction-core
+++ a/include/linux/vmstat.h
@@ -43,6 +43,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN mm/Makefile~mm-compaction-memory-compaction-core mm/Makefile
--- a/mm/Makefile~mm-compaction-memory-compaction-core
+++ a/mm/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_SLOB) += slob.o
+obj-$(CONFIG_COMPACTION) += compaction.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
diff -puN /dev/null mm/compaction.c
--- /dev/null
+++ a/mm/compaction.c
@@ -0,0 +1,379 @@
+/*
+ * linux/mm/compaction.c
+ *
+ * Memory compaction for the reduction of external fragmentation. Note that
+ * this heavily depends upon page migration to do all the real heavy
+ * lifting
+ *
+ * Copyright IBM Corp. 2007-2010 Mel Gorman <mel@csn.ul.ie>
+ */
+#include <linux/swap.h>
+#include <linux/migrate.h>
+#include <linux/compaction.h>
+#include <linux/mm_inline.h>
+#include <linux/backing-dev.h>
+#include "internal.h"
+
+/*
+ * compact_control is used to track pages being migrated and the free pages
+ * they are being migrated to during memory compaction. The free_pfn starts
+ * at the end of a zone and migrate_pfn begins at the start. Movable pages
+ * are moved to the end of a zone during a compaction run and the run
+ * completes when free_pfn <= migrate_pfn
+ */
+struct compact_control {
+	struct list_head freepages;	/* List of free pages to migrate to */
+	struct list_head migratepages;	/* List of pages being migrated */
+	unsigned long nr_freepages;	/* Number of isolated free pages */
+	unsigned long nr_migratepages;	/* Number of pages to migrate */
+	unsigned long free_pfn;		/* isolate_freepages search base */
+	unsigned long migrate_pfn;	/* isolate_migratepages search base */
+
+	/* Account for isolated anon and file pages */
+	unsigned long nr_anon;
+	unsigned long nr_file;
+
+	struct zone *zone;
+};
+
+static int release_freepages(struct list_head *freelist)
+{
+	struct page *page, *next;
+	int count = 0;
+
+	list_for_each_entry_safe(page, next, freelist, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+		count++;
+	}
+
+	return count;
+}
+
+/* Isolate free pages onto a private freelist. Must hold zone->lock */
+static int isolate_freepages_block(struct zone *zone,
+				unsigned long blockpfn,
+				struct list_head *freelist)
+{
+	unsigned long zone_end_pfn, end_pfn;
+	int total_isolated = 0;
+
+	/* Get the last PFN we should scan for free pages at */
+	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	end_pfn = blockpfn + pageblock_nr_pages;
+	if (end_pfn > zone_end_pfn)
+		end_pfn = zone_end_pfn;
+
+	/* Isolate free pages. This assumes the block is valid */
+	for (; blockpfn < end_pfn; blockpfn++) {
+		struct page *page;
+		int isolated, i;
+
+		if (!pfn_valid_within(blockpfn))
+			continue;
+
+		page = pfn_to_page(blockpfn);
+		if (!PageBuddy(page))
+			continue;
+
+		/* Found a free page, break it into order-0 pages */
+		isolated = split_free_page(page);
+		total_isolated += isolated;
+		for (i = 0; i < isolated; i++) {
+			list_add(&page->lru, freelist);
+			page++;
+		}
+
+		/* If a page was split, advance to the end of it */
+		if (isolated)
+			blockpfn += isolated - 1;
+	}
+
+	return total_isolated;
+}
+
+/* Returns 1 if the page is within a block suitable for migration to */
+static int suitable_migration_target(struct page *page)
+{
+
+	int migratetype = get_pageblock_migratetype(page);
+
+	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
+	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
+		return 0;
+
+	/* If the page is a large free page, then allow migration */
+	if (PageBuddy(page) && page_order(page) >= pageblock_order)
+		return 1;
+
+	/* If the block is MIGRATE_MOVABLE, allow migration */
+	if (migratetype == MIGRATE_MOVABLE)
+		return 1;
+
+	/* Otherwise skip the block */
+	return 0;
+}
+
+/*
+ * Based on information in the current compact_control, find blocks
+ * suitable for isolating free pages from
+ */
+static void isolate_freepages(struct zone *zone,
+				struct compact_control *cc)
+{
+	struct page *page;
+	unsigned long high_pfn, low_pfn, pfn;
+	unsigned long flags;
+	int nr_freepages = cc->nr_freepages;
+	struct list_head *freelist = &cc->freepages;
+
+	pfn = cc->free_pfn;
+	low_pfn = cc->migrate_pfn + pageblock_nr_pages;
+	high_pfn = low_pfn;
+
+	/*
+	 * Isolate free pages until enough are available to migrate the
+	 * pages on cc->migratepages. We stop searching if the migrate
+	 * and free page scanners meet or enough free pages are isolated.
+	 */
+	spin_lock_irqsave(&zone->lock, flags);
+	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
+					pfn -= pageblock_nr_pages) {
+		int isolated;
+
+		if (!pfn_valid(pfn))
+			continue;
+
+		/*
+		 * Check for overlapping nodes/zones. It's possible on some
+		 * configurations to have a setup like
+		 * node0 node1 node0
+		 * i.e. it's possible that all pages within a zones range of
+		 * pages do not belong to a single zone.
+		 */
+		page = pfn_to_page(pfn);
+		if (page_zone(page) != zone)
+			continue;
+
+		/* Check the block is suitable for migration */
+		if (!suitable_migration_target(page))
+			continue;
+
+		/* Found a block suitable for isolating free pages from */
+		isolated = isolate_freepages_block(zone, pfn, freelist);
+		nr_freepages += isolated;
+
+		/*
+		 * Record the highest PFN we isolated pages from. When next
+		 * looking for free pages, the search will restart here as
+		 * page migration may have returned some pages to the allocator
+		 */
+		if (isolated)
+			high_pfn = max(high_pfn, pfn);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	cc->free_pfn = high_pfn;
+	cc->nr_freepages = nr_freepages;
+}
+
+/* Update the number of anon and file isolated pages in the zone */
+static void acct_isolated(struct zone *zone, struct compact_control *cc)
+{
+	struct page *page;
+	unsigned int count[NR_LRU_LISTS] = { 0, };
+
+	list_for_each_entry(page, &cc->migratepages, lru) {
+		int lru = page_lru_base_type(page);
+		count[lru]++;
+	}
+
+	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
+	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
+}
+
+/* Similar to reclaim, but different enough that they don't share logic */
+static int too_many_isolated(struct zone *zone)
+{
+
+	unsigned long inactive, isolated;
+
+	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
+					zone_page_state(zone, NR_INACTIVE_ANON);
+	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
+					zone_page_state(zone, NR_ISOLATED_ANON);
+
+	return isolated > inactive;
+}
+
+/*
+ * Isolate all pages that can be migrated from the block pointed to by
+ * the migrate scanner within compact_control.
+ */
+static unsigned long isolate_migratepages(struct zone *zone,
+					struct compact_control *cc)
+{
+	unsigned long low_pfn, end_pfn;
+	struct list_head *migratelist;
+
+	low_pfn = cc->migrate_pfn;
+	migratelist = &cc->migratepages;
+
+	/* Do not scan outside zone boundaries */
+	if (low_pfn < zone->zone_start_pfn)
+		low_pfn = zone->zone_start_pfn;
+
+	/* Setup to scan one block but not past where we are migrating to */
+	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
+
+	/* Do not cross the free scanner or scan within a memory hole */
+	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
+		cc->migrate_pfn = end_pfn;
+		return 0;
+	}
+
+	/* Do not isolate the world */
+	while (unlikely(too_many_isolated(zone))) {
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
+
+		if (fatal_signal_pending(current))
+			return 0;
+	}
+
+	/* Time to isolate some pages for migration */
+	spin_lock_irq(&zone->lru_lock);
+	for (; low_pfn < end_pfn; low_pfn++) {
+		struct page *page;
+		if (!pfn_valid_within(low_pfn))
+			continue;
+
+		/* Get the page and skip if free */
+		page = pfn_to_page(low_pfn);
+		if (PageBuddy(page)) {
+			low_pfn += (1 << page_order(page)) - 1;
+			continue;
+		}
+
+		/* Try isolate the page */
+		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) == 0) {
+			del_page_from_lru_list(zone, page, page_lru(page));
+			list_add(&page->lru, migratelist);
+			mem_cgroup_del_lru(page);
+			cc->nr_migratepages++;
+		}
+
+		/* Avoid isolating too much */
+		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+			break;
+	}
+
+	acct_isolated(zone, cc);
+
+	spin_unlock_irq(&zone->lru_lock);
+	cc->migrate_pfn = low_pfn;
+
+	return cc->nr_migratepages;
+}
+
+/*
+ * This is a migrate-callback that "allocates" freepages by taking pages
+ * from the isolated freelists in the block we are migrating to.
+ */
+static struct page *compaction_alloc(struct page *migratepage,
+					unsigned long data,
+					int **result)
+{
+	struct compact_control *cc = (struct compact_control *)data;
+	struct page *freepage;
+
+	/* Isolate free pages if necessary */
+	if (list_empty(&cc->freepages)) {
+		isolate_freepages(cc->zone, cc);
+
+		if (list_empty(&cc->freepages))
+			return NULL;
+	}
+
+	freepage = list_entry(cc->freepages.next, struct page, lru);
+	list_del(&freepage->lru);
+	cc->nr_freepages--;
+
+	return freepage;
+}
+
+/*
+ * We cannot control nr_migratepages and nr_freepages fully when migration is
+ * running as migrate_pages() has no knowledge of compact_control. When
+ * migration is complete, we count the number of pages on the lists by hand.
+ */
+static void update_nr_listpages(struct compact_control *cc)
+{
+	int nr_migratepages = 0;
+	int nr_freepages = 0;
+	struct page *page;
+	list_for_each_entry(page, &cc->migratepages, lru)
+		nr_migratepages++;
+	list_for_each_entry(page, &cc->freepages, lru)
+		nr_freepages++;
+
+	cc->nr_migratepages = nr_migratepages;
+	cc->nr_freepages = nr_freepages;
+}
+
+static inline int compact_finished(struct zone *zone,
+						struct compact_control *cc)
+{
+	if (fatal_signal_pending(current))
+		return COMPACT_PARTIAL;
+
+	/* Compaction run completes if the migrate and free scanner meet */
+	if (cc->free_pfn <= cc->migrate_pfn)
+		return COMPACT_COMPLETE;
+
+	return COMPACT_INCOMPLETE;
+}
+
+static int compact_zone(struct zone *zone, struct compact_control *cc)
+{
+	int ret = COMPACT_INCOMPLETE;
+
+	/* Setup to move all movable pages to the end of the zone */
+	cc->migrate_pfn = zone->zone_start_pfn;
+	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
+	cc->free_pfn &= ~(pageblock_nr_pages-1);
+
+	migrate_prep();
+
+	for (; ret == COMPACT_INCOMPLETE; ret = compact_finished(zone, cc)) {
+		unsigned long nr_migrate, nr_remaining;
+		if (!isolate_migratepages(zone, cc))
+			continue;
+
+		nr_migrate = cc->nr_migratepages;
+		migrate_pages(&cc->migratepages, compaction_alloc,
+						(unsigned long)cc, 0);
+		update_nr_listpages(cc);
+		nr_remaining = cc->nr_migratepages;
+
+		count_vm_event(COMPACTBLOCKS);
+		count_vm_events(COMPACTPAGES, nr_migrate - nr_remaining);
+		if (nr_remaining)
+			count_vm_events(COMPACTPAGEFAILED, nr_remaining);
+
+		/* Release LRU pages not migrated */
+		if (!list_empty(&cc->migratepages)) {
+			putback_lru_pages(&cc->migratepages);
+			cc->nr_migratepages = 0;
+		}
+
+	}
+
+	/* Release free pages and check accounting */
+	cc->nr_freepages -= release_freepages(&cc->freepages);
+	VM_BUG_ON(cc->nr_freepages != 0);
+
+	return ret;
+}
+
diff -puN mm/page_alloc.c~mm-compaction-memory-compaction-core mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-memory-compaction-core
+++ a/mm/page_alloc.c
@@ -1208,6 +1208,45 @@ void split_page(struct page *page, unsig
 }
 
 /*
+ * Similar to split_page except the page is already free. As this is only
+ * being used for migration, the migratetype of the block also changes.
+ */
+int split_free_page(struct page *page)
+{
+	unsigned int order;
+	unsigned long watermark;
+	struct zone *zone;
+
+	BUG_ON(!PageBuddy(page));
+
+	zone = page_zone(page);
+	order = page_order(page);
+
+	/* Obey watermarks or the system could deadlock */
+	watermark = low_wmark_pages(zone) + (1 << order);
+	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+		return 0;
+
+	/* Remove page from free list */
+	list_del(&page->lru);
+	zone->free_area[order].nr_free--;
+	rmv_page_order(page);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
+
+	/* Split into individual pages */
+	set_page_refcounted(page);
+	split_page(page, order);
+
+	if (order >= pageblock_order - 1) {
+		struct page *endpage = page + (1 << order) - 1;
+		for (; page < endpage; page += pageblock_nr_pages)
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+	}
+
+	return 1 << order;
+}
+
+/*
  * Really, prep_compound_page() should be called from __rmqueue_bulk().  But
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
  * or two.
diff -puN mm/vmstat.c~mm-compaction-memory-compaction-core mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-memory-compaction-core
+++ a/mm/vmstat.c
@@ -893,6 +893,11 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+
+	"compact_blocks_moved",
+	"compact_pages_moved",
+	"compact_pagemigrate_failed",
+
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch
mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

