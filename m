From: akpm@linux-foundation.org
Subject: [withdrawn] vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch removed from -mm tree
Date: Fri, 13 Nov 2009 15:38:59 -0800
Message-ID: <200911132339.nADNcxVx008366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932559AbZKMXjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:39:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, elendil@planet.nl, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: take order into consideration when deciding if kswapd is in trouble
has been removed from the -mm tree.  Its filename was
     vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: take order into consideration when deciding if kswapd is in trouble
From: Mel Gorman <mel@csn.ul.ie>

If reclaim fails to make sufficient progress, the priority is raised. 
Once the priority is higher, kswapd starts waiting on congestion. 
However, on systems with large numbers of high-order atomics due to crappy
network cards, it's important that kswapd keep working in parallel to save
their sorry ass.

This patch takes into account the order kswapd is reclaiming at before
waiting on congestion.  The higher the order, the longer it is before
kswapd considers itself to be in trouble.  The impact is that kswapd works
harder in parallel rather than depending on direct reclaimers or atomic
allocations to fail.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble mm/vmscan.c
--- a/mm/vmscan.c~vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble
+++ a/mm/vmscan.c
@@ -1950,7 +1950,7 @@ static int sleeping_prematurely(int orde
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 {
 	int all_zones_ok;
-	int priority;
+	int priority, congestion_priority;
 	int i;
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
@@ -1971,6 +1971,16 @@ static unsigned long balance_pgdat(pg_da
 	 */
 	int temp_priority[MAX_NR_ZONES];
 
+	/*
+	 * When priority reaches congestion_priority, kswapd will sleep
+	 * for a short time while congestion clears. The higher the
+	 * order being reclaimed, the less likely kswapd will go to
+	 * sleep as high-order allocations are harder to reclaim and
+	 * stall direct reclaimers longer
+	 */
+	congestion_priority = DEF_PRIORITY - 2;
+	congestion_priority -= min(congestion_priority, sc.order);
+
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
@@ -2096,7 +2106,7 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < congestion_priority)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-memory_hotplug-fix-section-mismatch.patch
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

