From: akpm@linux-foundation.org
Subject: [merged] page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:03 -0800
Message-ID: <200911131926.nADJQ38v027203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197AbZKMT1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, penberg@cs.helsinki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     page allocator: always wake kswapd when restarting an allocation attempt after direct reclaim failed
has been removed from the -mm tree.  Its filename was
     page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: always wake kswapd when restarting an allocation attempt after direct reclaim failed
From: Mel Gorman <mel@csn.ul.ie>

If a direct reclaim makes no forward progress, it considers whether it
should go OOM or not.  Whether OOM is triggered or not, it may retry the
allocation afterwards.  In times past, this would always wake kswapd as
well but currently, kswapd is not woken up after direct reclaim fails. 
For order-0 allocations, this makes little difference but if there is a
heavy mix of higher-order allocations that direct reclaim is failing for,
it might mean that kswapd is not rewoken for higher orders as much as it
did previously.

This patch wakes up kswapd when an allocation is being retried after a
direct reclaim failure.  It would be expected that kswapd is already
awake, but this has the effect of telling kswapd to reclaim at the higher
order as well.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/page_alloc.c~page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed
+++ a/mm/page_alloc.c
@@ -1817,9 +1817,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
+restart:
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
-restart:
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
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

