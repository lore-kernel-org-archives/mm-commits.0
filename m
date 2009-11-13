From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:08 -0800
Message-ID: <200911131926.nADJQ8uv027440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124AbZKMT1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     page allocator: Do not allow interrupts to use ALLOC_HARDER
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: Do not allow interrupts to use ALLOC_HARDER
From: Mel Gorman <mel@csn.ul.ie>

Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 ("page allocator:
calculate the alloc_flags for allocation only once") altered watermark
logic slightly by allowing rt_tasks that are handling an interrupt to set
ALLOC_HARDER.  This patch brings the watermark logic more in line with
2.6.30.

This change results in a reduction of the number high-order GFP_ATOMIC
allocation failures reported.  See
http://www.gossamer-threads.com/lists/linux/kernel/1144153

[rientjes@google.com: Spotted the problem]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/page_alloc.c~page-allocator-do-not-allow-interrupts-to-use-alloc_harder mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-allow-interrupts-to-use-alloc_harder
+++ a/mm/page_alloc.c
@@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)))
+	} else if (unlikely(rt_task(p)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
add-debugging-aid-for-memory-initialisation-problems.patch

