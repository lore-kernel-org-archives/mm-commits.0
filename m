From: akpm@linux-foundation.org
Subject: [merged] oom-invoke-oom-killer-for-__gfp_nofail.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:01 -0700
Message-ID: <200906171836.n5HIa1Pw002063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760503AbZFQShJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     oom: invoke oom killer for __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     oom-invoke-oom-killer-for-__gfp_nofail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1561,7 +1561,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		goto out;
 
 	/* The OOM killer will not help higher order allocs */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
@@ -1781,11 +1781,13 @@ rebalance:
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

origin.patch
linux-next.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

