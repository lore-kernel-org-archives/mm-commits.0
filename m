From: akpm@linux-foundation.org
Subject: + mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:20 -0700
Message-ID: <201004070007.o3707KPk016408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324Ab0DGAIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: direct compact when a high-order allocation fails
has been added to the -mm tree.  Its filename is
     mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: direct compact when a high-order allocation fails
From: Mel Gorman <mel@csn.ul.ie>

Ordinarily when a high-order allocation fails, direct reclaim is entered
to free pages to satisfy the allocation.  With this patch, it is
determined if an allocation failed due to external fragmentation instead
of low memory and if so, the calling process will compact until a suitable
page is freed.  Compaction by moving pages in memory is considerably
cheaper than paging out to disk and works where there are locked pages or
no swap.  If compaction fails to free a page of a suitable size, then
reclaim will still occur.

Direct compaction returns as soon as possible.  As each block is
compacted, it is checked if a suitable page has been freed and if so, it
returns.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   20 ++++-
 include/linux/vmstat.h     |    1 
 mm/compaction.c            |  117 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |   31 +++++++++
 mm/vmstat.c                |   15 +++-
 5 files changed, 178 insertions(+), 6 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-direct-compact-when-a-high-order-allocation-fails include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-direct-compact-when-a-high-order-allocation-fails
+++ a/include/linux/compaction.h
@@ -1,15 +1,27 @@
 #ifndef _LINUX_COMPACTION_H
 #define _LINUX_COMPACTION_H
 
-/* Return values for compact_zone() */
-#define COMPACT_INCOMPLETE	0
-#define COMPACT_PARTIAL		1
-#define COMPACT_COMPLETE	2
+/* Return values for compact_zone() and try_to_compact_pages() */
+#define COMPACT_SKIPPED		0
+#define COMPACT_INCOMPLETE	1
+#define COMPACT_PARTIAL		2
+#define COMPACT_COMPLETE	3
 
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
+
+extern int fragmentation_index(struct zone *zone, unsigned int order);
+extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
+			int order, gfp_t gfp_mask, nodemask_t *mask);
+#else
+static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
+			int order, gfp_t gfp_mask, nodemask_t *nodemask)
+{
+	return COMPACT_INCOMPLETE;
+}
+
 #endif /* CONFIG_COMPACTION */
 
 #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
diff -puN include/linux/vmstat.h~mm-compaction-direct-compact-when-a-high-order-allocation-fails include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-compaction-direct-compact-when-a-high-order-allocation-fails
+++ a/include/linux/vmstat.h
@@ -44,6 +44,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
+		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN mm/compaction.c~mm-compaction-direct-compact-when-a-high-order-allocation-fails mm/compaction.c
--- a/mm/compaction.c~mm-compaction-direct-compact-when-a-high-order-allocation-fails
+++ a/mm/compaction.c
@@ -35,6 +35,8 @@ struct compact_control {
 	unsigned long nr_anon;
 	unsigned long nr_file;
 
+	unsigned int order;		/* order a direct compactor needs */
+	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
 };
 
@@ -327,6 +329,9 @@ static void update_nr_listpages(struct c
 static int compact_finished(struct zone *zone,
 						struct compact_control *cc)
 {
+	unsigned int order;
+	unsigned long watermark = low_wmark_pages(zone) + (1 << cc->order);
+
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
@@ -334,6 +339,24 @@ static int compact_finished(struct zone 
 	if (cc->free_pfn <= cc->migrate_pfn)
 		return COMPACT_COMPLETE;
 
+	/* Compaction run is not finished if the watermark is not met */
+	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
+		return COMPACT_INCOMPLETE;
+
+	if (cc->order == -1)
+		return COMPACT_INCOMPLETE;
+
+	/* Direct compactor: Is a suitable page free? */
+	for (order = cc->order; order < MAX_ORDER; order++) {
+		/* Job done if page is free of the right migratetype */
+		if (!list_empty(&zone->free_area[order].free_list[cc->migratetype]))
+			return COMPACT_PARTIAL;
+
+		/* Job done if allocation would set block type */
+		if (order >= pageblock_order && zone->free_area[order].nr_free)
+			return COMPACT_PARTIAL;
+	}
+
 	return COMPACT_INCOMPLETE;
 }
 
@@ -379,6 +402,99 @@ static int compact_zone(struct zone *zon
 	return ret;
 }
 
+static unsigned long compact_zone_order(struct zone *zone,
+						int order, gfp_t gfp_mask)
+{
+	struct compact_control cc = {
+		.nr_freepages = 0,
+		.nr_migratepages = 0,
+		.order = order,
+		.migratetype = allocflags_to_migratetype(gfp_mask),
+		.zone = zone,
+	};
+	INIT_LIST_HEAD(&cc.freepages);
+	INIT_LIST_HEAD(&cc.migratepages);
+
+	return compact_zone(zone, &cc);
+}
+
+/**
+ * try_to_compact_pages - Direct compact to satisfy a high-order allocation
+ * @zonelist: The zonelist used for the current allocation
+ * @order: The order of the current allocation
+ * @gfp_mask: The GFP mask of the current allocation
+ * @nodemask: The allowed nodes to allocate from
+ *
+ * This is the main entry point for direct page compaction.
+ */
+unsigned long try_to_compact_pages(struct zonelist *zonelist,
+			int order, gfp_t gfp_mask, nodemask_t *nodemask)
+{
+	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	int may_enter_fs = gfp_mask & __GFP_FS;
+	int may_perform_io = gfp_mask & __GFP_IO;
+	unsigned long watermark;
+	struct zoneref *z;
+	struct zone *zone;
+	int rc = COMPACT_SKIPPED;
+
+	/*
+	 * Check whether it is worth even starting compaction. The order check is
+	 * made because an assumption is made that the page allocator can satisfy
+	 * the "cheaper" orders without taking special steps
+	 */
+	if (order <= PAGE_ALLOC_COSTLY_ORDER || !may_enter_fs || !may_perform_io)
+		return rc;
+
+	count_vm_event(COMPACTSTALL);
+
+	/* Compact each zone in the list */
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
+								nodemask) {
+		int fragindex;
+		int status;
+
+		/*
+		 * Watermarks for order-0 must be met for compaction. Note
+		 * the 2UL. This is because during migration, copies of
+		 * pages need to be allocated and for a short time, the
+		 * footprint is higher
+		 */
+		watermark = low_wmark_pages(zone) + (2UL << order);
+		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+			continue;
+
+		/*
+		 * fragmentation index determines if allocation failures are
+		 * due to low memory or external fragmentation
+		 *
+		 * index of -1 implies allocations might succeed depending
+		 * 	on watermarks
+		 * index towards 0 implies failure is due to lack of memory
+		 * index towards 1000 implies failure is due to fragmentation
+		 *
+		 * Only compact if a failure would be due to fragmentation.
+		 */
+		fragindex = fragmentation_index(zone, order);
+		if (fragindex >= 0 && fragindex <= 500)
+			continue;
+
+		if (fragindex == -1 && zone_watermark_ok(zone, order, watermark, 0, 0)) {
+			rc = COMPACT_PARTIAL;
+			break;
+		}
+
+		status = compact_zone_order(zone, order, gfp_mask);
+		rc = max(status, rc);
+
+		if (zone_watermark_ok(zone, order, watermark, 0, 0))
+			break;
+	}
+
+	return rc;
+}
+
+
 /* Compact all zones within a node */
 static int compact_node(int nid)
 {
@@ -403,6 +519,7 @@ static int compact_node(int nid)
 		cc.nr_freepages = 0;
 		cc.nr_migratepages = 0;
 		cc.zone = zone;
+		cc.order = -1;
 		INIT_LIST_HEAD(&cc.freepages);
 		INIT_LIST_HEAD(&cc.migratepages);
 
diff -puN mm/page_alloc.c~mm-compaction-direct-compact-when-a-high-order-allocation-fails mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-direct-compact-when-a-high-order-allocation-fails
+++ a/mm/page_alloc.c
@@ -49,6 +49,7 @@
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
+#include <linux/compaction.h>
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
 
@@ -1768,6 +1769,36 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	cond_resched();
 
+	/* Try memory compaction for high-order allocations before reclaim */
+	if (order) {
+		*did_some_progress = try_to_compact_pages(zonelist,
+						order, gfp_mask, nodemask);
+		if (*did_some_progress != COMPACT_SKIPPED) {
+
+			/* Page migration frees to the PCP lists but we want merging */
+			drain_pages(get_cpu());
+			put_cpu();
+
+			page = get_page_from_freelist(gfp_mask, nodemask,
+					order, zonelist, high_zoneidx,
+					alloc_flags, preferred_zone,
+					migratetype);
+			if (page) {
+				__count_vm_event(COMPACTSUCCESS);
+				return page;
+			}
+
+			/*
+			 * It's bad if compaction run occurs and fails.
+			 * The most likely reason is that pages exist,
+			 * but not enough to satisfy watermarks.
+			 */
+			count_vm_event(COMPACTFAIL);
+
+			cond_resched();
+		}
+	}
+
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
 	p->flags |= PF_MEMALLOC;
diff -puN mm/vmstat.c~mm-compaction-direct-compact-when-a-high-order-allocation-fails mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-direct-compact-when-a-high-order-allocation-fails
+++ a/mm/vmstat.c
@@ -562,7 +562,7 @@ static int unusable_show(struct seq_file
  * The value can be used to determine if page reclaim or compaction
  * should be used
  */
-int fragmentation_index(unsigned int order, struct contig_page_info *info)
+int __fragmentation_index(unsigned int order, struct contig_page_info *info)
 {
 	unsigned long requested = 1UL << order;
 
@@ -582,6 +582,14 @@ int fragmentation_index(unsigned int ord
 	return 1000 - div_u64( (1000+(div_u64(info->free_pages * 1000ULL, requested))), info->free_blocks_total);
 }
 
+/* Same as __fragmentation index but allocs contig_page_info on stack */
+int fragmentation_index(struct zone *zone, unsigned int order)
+{
+	struct contig_page_info info;
+
+	fill_contig_page_info(zone, order, &info);
+	return __fragmentation_index(order, &info);
+}
 
 static void extfrag_show_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
@@ -597,7 +605,7 @@ static void extfrag_show_print(struct se
 				zone->name);
 	for (order = 0; order < MAX_ORDER; ++order) {
 		fill_contig_page_info(zone, order, &info);
-		index = fragmentation_index(order, &info);
+		index = __fragmentation_index(order, &info);
 		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
 	}
 
@@ -897,6 +905,9 @@ static const char * const vmstat_text[] 
 	"compact_blocks_moved",
 	"compact_pages_moved",
 	"compact_pagemigrate_failed",
+	"compact_stall",
+	"compact_fail",
+	"compact_success",
 
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

