From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:54 -0700
Message-ID: <201004221906.o3MJ6sW7002153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420Ab0DVTHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: direct compact when a high-order allocation fails
has been removed from the -mm tree.  Its filename was
     mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch

This patch was dropped because an updated version will be merged

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

 include/linux/compaction.h |   20 ++++--
 include/linux/vmstat.h     |    1 
 mm/compaction.c            |  116 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |   31 +++++++++
 mm/vmstat.c                |   16 ++++
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
 
@@ -335,6 +337,9 @@ static void update_nr_listpages(struct c
 static int compact_finished(struct zone *zone,
 						struct compact_control *cc)
 {
+	unsigned int order;
+	unsigned long watermark = low_wmark_pages(zone) + (1 << cc->order);
+
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
@@ -342,6 +347,24 @@ static int compact_finished(struct zone 
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
 
@@ -388,6 +411,99 @@ static int compact_zone(struct zone *zon
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
@@ -503,7 +503,7 @@ static void fill_contig_page_info(struct
  * The value can be used to determine if page reclaim or compaction
  * should be used
  */
-int fragmentation_index(unsigned int order, struct contig_page_info *info)
+int __fragmentation_index(unsigned int order, struct contig_page_info *info)
 {
 	unsigned long requested = 1UL << order;
 
@@ -766,6 +766,9 @@ static const char * const vmstat_text[] 
 	"compact_blocks_moved",
 	"compact_pages_moved",
 	"compact_pagemigrate_failed",
+	"compact_stall",
+	"compact_fail",
+	"compact_success",
 
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
@@ -1117,6 +1120,15 @@ static const struct file_operations unus
 	.release	= seq_release,
 };
 
+/* Same as __fragmentation index but allocs contig_page_info on stack */
+int fragmentation_index(struct zone *zone, unsigned int order)
+{
+	struct contig_page_info info;
+
+	fill_contig_page_info(zone, order, &info);
+	return __fragmentation_index(order, &info);
+}
+
 static void extfrag_show_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -1131,7 +1143,7 @@ static void extfrag_show_print(struct se
 				zone->name);
 	for (order = 0; order < MAX_ORDER; ++order) {
 		fill_contig_page_info(zone, order, &info);
-		index = fragmentation_index(order, &info);
+		index = __fragmentation_index(order, &info);
 		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
 	}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
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

