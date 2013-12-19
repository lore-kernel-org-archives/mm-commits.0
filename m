From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy.patch added to
 -mm tree
Date: Thu, 19 Dec 2013 15:41:53 -0800
Message-ID: <52b38441.G7HWlfTmZAJG+hZ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab3LSXly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 18:41:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, dave.hansen@intel.com, hannes@cmpxchg.org

Subject: + mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy.patch added to -mm tree
To: hannes@cmpxchg.org,dave.hansen@intel.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 15:41:53 -0800


The patch titled
     Subject: mm/page_alloc.c: revert NUMA aspect of fair allocation policy
has been added to the -mm tree.  Its filename is
     mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/page_alloc.c: revert NUMA aspect of fair allocation policy

81c0a2bb ("mm: page_alloc: fair zone allocator policy") meant to bring
aging fairness among zones in system, but it was overzealous and badly
regressed basic workloads on NUMA systems.

Due to the way kswapd and page allocator interacts, we still want to make
sure that all zones in any given node are used equally for all allocations
to maximize memory utilization and prevent thrashing on the highest zone
in the node.

While the same principle applies to NUMA nodes - memory utilization is
obviously improved by spreading allocations throughout all nodes - remote
references can be costly and so many workloads prefer locality over memory
utilization.  The original change assumed that zone_reclaim_mode would be
a good enough predictor for that, but it turned out to be as indicative as
a coin flip.

Revert the NUMA aspect of the fairness until we can find a proper way
to make it configurable and agree on a sane default.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>		[3.12]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy
+++ a/mm/page_alloc.c
@@ -1913,19 +1913,17 @@ zonelist_scan:
 		 * page was allocated in should have no effect on the
 		 * time the page has in memory before being reclaimed.
 		 *
-		 * When zone_reclaim_mode is enabled, try to stay in
-		 * local zones in the fastpath.  If that fails, the
-		 * slowpath is entered, which will do another pass
-		 * starting with the local zones, but ultimately fall
-		 * back to remote zones that do not partake in the
-		 * fairness round-robin cycle of this zonelist.
+		 * Try to stay in local zones in the fastpath.  If that fails,
+		 * the slowpath is entered, which will do another pass starting
+		 * with the local zones, but ultimately fall back to remote
+		 * zones that do not partake in the fairness round-robin cycle
+		 * of this zonelist.
 		 */
 		if ((alloc_flags & ALLOC_WMARK_LOW) &&
 		    (gfp_mask & GFP_MOVABLE_MASK)) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
-			if (zone_reclaim_mode &&
-			    !zone_local(preferred_zone, zone))
+			if (!zone_local(preferred_zone, zone))
 				continue;
 		}
 		/*
@@ -2391,7 +2389,7 @@ static void prepare_slowpath(gfp_t gfp_m
 		 * thrash fairness information for zones that are not
 		 * actually part of this zonelist's round-robin cycle.
 		 */
-		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+		if (!zone_local(preferred_zone, zone))
 			continue;
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
 				    high_wmark_pages(zone) -
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-memcg_size-calculation.patch
mm-page_allocc-revert-numa-aspect-of-fair-allocation-policy.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

