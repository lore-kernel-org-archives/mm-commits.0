From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-invoke-oom-killer-for-__gfp_nofail.patch removed from -mm tree
Date: Mon, 11 May 2009 14:24:53 -0700
Message-ID: <200905112124.n4BLOr8c000314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbZEKVaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 17:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.


The patch titled
     mm: invoke oom killer for __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     mm-invoke-oom-killer-for-__gfp_nofail.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: invoke oom killer for __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

The oom killer must be invoked regardless of the order if the allocation
is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to free
some memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-invoke-oom-killer-for-__gfp_nofail mm/page_alloc.c
--- a/mm/page_alloc.c~mm-invoke-oom-killer-for-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -1547,7 +1547,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		goto out;
 
 	/* The OOM killer will not help higher order allocs */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
@@ -1763,16 +1763,12 @@ rebalance:
 					migratetype);
 			if (page)
 				goto got_pg;
+			if ((gfp_mask & __GFP_NOFAIL) ||
+					order <= PAGE_ALLOC_COSTLY_ORDER)
+				goto restart;
 
-			/*
-			 * The OOM killer does not trigger for high-order allocations
-			 * but if no progress is being made, there are no other
-			 * options and retrying is unlikely to help
-			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER)
-				goto nopage;
-
-			goto restart;
+			/* No freeing is possible so just fail */
+			goto nopage;
 		}
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
oom-fix-possible-oom_dump_tasks-null-pointer.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-prevent-possible-oom_disable-livelock.patch
mm-invoke-oom-killer-for-__gfp_nofail.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

