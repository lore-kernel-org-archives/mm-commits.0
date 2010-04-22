From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:07:24 -0700
Message-ID: <201004221907.o3MJ7OWN002198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab0DVTOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: defer compaction using an exponential backoff
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: defer compaction using an exponential backoff
From: Mel Gorman <mel@csn.ul.ie>

The fragmentation index may indicate that a failure is due to external
fragmentation but after a compaction run completes, it is still possible
for an allocation to fail.  There are two obvious reasons as to why

  o Page migration cannot move all pages so fragmentation remains
  o A suitable page may exist but watermarks are not met

In the event of compaction followed by an allocation failure, this patch
defers further compaction in the zone (1 << compact_defer_shift) times. 
If the next compaction attempt also fails, compact_defer_shift is
increased up to a maximum of 6.  If compaction succeeds, the defer
counters are reset again.

The zone that is deferred is the first zone in the zonelist - i.e.  the
preferred zone.  To defer compaction in the other zones, the information
would need to be stored in the zonelist or implemented similar to the
zonelist_cache.  This would impact the fast-paths and is not justified at
this time.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   39 +++++++++++++++++++++++++++++++++++
 include/linux/mmzone.h     |    9 ++++++++
 mm/page_alloc.c            |    5 +++-
 3 files changed, 52 insertions(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree
+++ a/include/linux/compaction.h
@@ -18,6 +18,36 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask);
+
+/* Do not skip compaction more than 64 times */
+#define COMPACT_MAX_DEFER_SHIFT 6
+
+/*
+ * Compaction is deferred when compaction fails to result in a page
+ * allocation success. 1 << compact_defer_limit compactions are skipped up
+ * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
+ */
+static inline void defer_compaction(struct zone *zone)
+{
+	zone->compact_considered = 0;
+	zone->compact_defer_shift++;
+
+	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
+		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
+}
+
+/* Returns true if compaction should be skipped this time */
+static inline bool compaction_deferred(struct zone *zone)
+{
+	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
+
+	/* Avoid possible overflow */
+	if (++zone->compact_considered > defer_limit)
+		zone->compact_considered = defer_limit;
+
+	return zone->compact_considered < (1UL << zone->compact_defer_shift);
+}
+
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask)
@@ -25,6 +55,15 @@ static inline unsigned long try_to_compa
 	return COMPACT_INCOMPLETE;
 }
 
+static inline void defer_compaction(struct zone *zone)
+{
+}
+
+static inline bool compaction_deferred(struct zone *zone)
+{
+	return 1;
+}
+
 #endif /* CONFIG_COMPACTION */
 
 #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
diff -puN include/linux/mmzone.h~mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree
+++ a/include/linux/mmzone.h
@@ -321,6 +321,15 @@ struct zone {
 	unsigned long		*pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_COMPACTION
+	/*
+	 * On compaction failure, 1<<compact_defer_shift compactions
+	 * are skipped before trying again. The number attempted since
+	 * last failure is tracked with compact_considered.
+	 */
+	unsigned int		compact_considered;
+	unsigned int		compact_defer_shift;
+#endif
 
 	ZONE_PADDING(_pad1_)
 
diff -puN mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree
+++ a/mm/page_alloc.c
@@ -1766,7 +1766,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 {
 	struct page *page;
 
-	if (!order)
+	if (!order || compaction_deferred(preferred_zone))
 		return NULL;
 
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
@@ -1782,6 +1782,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				alloc_flags, preferred_zone,
 				migratetype);
 		if (page) {
+			preferred_zone->compact_considered = 0;
+			preferred_zone->compact_defer_shift = 0;
 			__count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
@@ -1792,6 +1794,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		 * but not enough to satisfy watermarks.
 		 */
 		count_vm_event(COMPACTFAIL);
+		defer_compaction(preferred_zone);
 
 		cond_resched();
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

