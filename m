From: akpm@linux-foundation.org
Subject: + oom-invoke-oom-killer-for-__gfp_nofail.patch added to -mm tree
Date: Wed, 03 Jun 2009 15:26:20 -0700
Message-ID: <200906032226.n53MQKQh016507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbZFCW1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 18:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: invoke oom killer for __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     oom-invoke-oom-killer-for-__gfp_nofail.patch

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
Subject: oom: invoke oom killer for __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

The oom killer must be invoked regardless of the order if the allocation
is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to free
some memory.

Cc: Nick Piggin <npiggin@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~oom-invoke-oom-killer-for-__gfp_nofail mm/page_alloc.c
--- a/mm/page_alloc.c~oom-invoke-oom-killer-for-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -1576,7 +1576,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		goto out;
 
 	/* The OOM killer will not help higher order allocs */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
@@ -1796,11 +1796,13 @@ rebalance:
 				goto got_pg;
 
 			/*
-			 * The OOM killer does not trigger for high-order allocations
-			 * but if no progress is being made, there are no other
-			 * options and retrying is unlikely to help
+			 * The OOM killer does not trigger for high-order
+			 * ~__GFP_NOFAIL allocations so if no progress is being
+			 * made, there are no other options and retrying is
+			 * unlikely to help.
 			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER)
+			if (order > PAGE_ALLOC_COSTLY_ORDER &&
+						!(gfp_mask & __GFP_NOFAIL))
 				goto nopage;
 
 			goto restart;
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
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

