From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-move-definition-for-lru-isolation-modes-to-a-header.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:28 -0700
Message-ID: <201004221906.o3MJ6S83002114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918Ab0DVTNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: move definition for LRU isolation modes to a header
has been removed from the -mm tree.  Its filename was
     mm-move-definition-for-lru-isolation-modes-to-a-header.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move definition for LRU isolation modes to a header
From: Mel Gorman <mel@csn.ul.ie>

Currently, vmscan.c defines the isolation modes for __isolate_lru_page(). 
Memory compaction needs access to these modes for isolating pages for
migration.  This patch exports them.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/vmscan.c          |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/swap.h~mm-move-definition-for-lru-isolation-modes-to-a-header include/linux/swap.h
--- a/include/linux/swap.h~mm-move-definition-for-lru-isolation-modes-to-a-header
+++ a/include/linux/swap.h
@@ -238,6 +238,11 @@ static inline void lru_cache_add_active_
 	__lru_cache_add(page, LRU_ACTIVE_FILE);
 }
 
+/* LRU Isolation modes. */
+#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
+#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
+#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
+
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff -puN mm/vmscan.c~mm-move-definition-for-lru-isolation-modes-to-a-header mm/vmscan.c
--- a/mm/vmscan.c~mm-move-definition-for-lru-isolation-modes-to-a-header
+++ a/mm/vmscan.c
@@ -839,11 +839,6 @@ keep:
 	return nr_reclaimed;
 }
 
-/* LRU Isolation modes. */
-#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
-#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
-#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
-
 /*
  * Attempt to remove the specified page from its LRU.  Only take this page
  * if it is of the appropriate PageActive status.  Pages which are being
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
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

