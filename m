From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:07:22 -0700
Message-ID: <201004221907.o3MJ7Moa002195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043Ab0DVTH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice
From: Mel Gorman <mel@csn.ul.ie>

mm,compaction: Do not compact twice

Patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
created a __alloc_pages_direct_compact() function but the old call to
try_to_compact_pages() was not removed.  This patch removes it.

This is a fix to the mmotm patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice
+++ a/mm/page_alloc.c
@@ -1822,38 +1822,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	cond_resched();
 
-#ifdef CONFIG_COMPACTION
-	/* Try memory compaction for high-order allocations before reclaim */
-	if (order) {
-		*did_some_progress = try_to_compact_pages(zonelist,
-						order, gfp_mask, nodemask);
-		if (*did_some_progress != COMPACT_SKIPPED) {
-
-			/* Page migration frees to the PCP lists but we want merging */
-			drain_pages(get_cpu());
-			put_cpu();
-
-			page = get_page_from_freelist(gfp_mask, nodemask,
-					order, zonelist, high_zoneidx,
-					alloc_flags, preferred_zone,
-					migratetype);
-			if (page) {
-				__count_vm_event(COMPACTSUCCESS);
-				return page;
-			}
-
-			/*
-			 * It's bad if compaction run occurs and fails.
-			 * The most likely reason is that pages exist,
-			 * but not enough to satisfy watermarks.
-			 */
-			count_vm_event(COMPACTFAIL);
-
-			cond_resched();
-		}
-	}
-#endif
-
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
 	p->flags |= PF_MEMALLOC;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
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

