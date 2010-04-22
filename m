From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:07:13 -0700
Message-ID: <201004221907.o3MJ7Dnu002184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab0DVTHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: do not display compaction-related stats when !CONFIG_COMPACTION
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: do not display compaction-related stats when !CONFIG_COMPACTION
From: Mel Gorman <mel@csn.ul.ie>

Although compaction can be disabled from .config, the vmstat entries still
exist.  This patch removes the vmstat entries.  As page_alloc.c refers
directly to the counters, the patch introduces
__alloc_pages_direct_compact() to isolate use of the counters.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +
 mm/page_alloc.c        |   65 +++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c            |    2 +
 3 files changed, 69 insertions(+)

diff -puN include/linux/vmstat.h~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction
+++ a/include/linux/vmstat.h
@@ -43,8 +43,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+#ifdef CONFIG_COMPACTION
 		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction
+++ a/mm/page_alloc.c
@@ -1756,6 +1756,62 @@ out:
 	return page;
 }
 
+#ifdef CONFIG_COMPACTION
+/* Try memory compaction for high-order allocations before reclaim */
+static struct page *
+__alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	int migratetype, unsigned long *did_some_progress)
+{
+	struct page *page;
+
+	if (!order)
+		return NULL;
+
+	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
+								nodemask);
+	if (*did_some_progress != COMPACT_SKIPPED) {
+
+		/* Page migration frees to the PCP lists but we want merging */
+		drain_pages(get_cpu());
+		put_cpu();
+
+		page = get_page_from_freelist(gfp_mask, nodemask,
+				order, zonelist, high_zoneidx,
+				alloc_flags, preferred_zone,
+				migratetype);
+		if (page) {
+			__count_vm_event(COMPACTSUCCESS);
+			return page;
+		}
+
+		/*
+		 * It's bad if compaction run occurs and fails.
+		 * The most likely reason is that pages exist,
+		 * but not enough to satisfy watermarks.
+		 */
+		count_vm_event(COMPACTFAIL);
+
+		/* On failure, avoid compaction for a short time. */
+		defer_compaction(preferred_zone, jiffies + HZ/50);
+
+		cond_resched();
+	}
+
+	return NULL;
+}
+#else
+static inline struct page *
+__alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	int migratetype, unsigned long *did_some_progress)
+{
+	return NULL;
+}
+#endif /* CONFIG_COMPACTION */
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -1972,6 +2028,15 @@ rebalance:
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
+	/* Try direct compaction */
+	page = __alloc_pages_direct_compact(gfp_mask, order,
+					zonelist, high_zoneidx,
+					nodemask,
+					alloc_flags, preferred_zone,
+					migratetype, &did_some_progress);
+	if (page)
+		goto got_pg;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
diff -puN mm/vmstat.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction
+++ a/mm/vmstat.c
@@ -902,12 +902,14 @@ static const char * const vmstat_text[] 
 
 	"pgrotated",
 
+#ifdef CONFIG_COMPACTION
 	"compact_blocks_moved",
 	"compact_pages_moved",
 	"compact_pagemigrate_failed",
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
+#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
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

