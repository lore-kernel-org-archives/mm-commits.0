From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-fix-endless-loop-in-kswapd-balancing.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:29:04 -0800
Message-ID: <20121130212904.CFD00100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58593 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2K3V3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:29:07 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so1996449yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:29:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, johannes.hirte@fem.tu-ilmenau.de, linux@horizon.com, mel@csn.ul.ie, riel@redhat.com, stable@vger.kernel.org, tracek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix endless loop in kswapd balancing
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-endless-loop-in-kswapd-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: fix endless loop in kswapd balancing

Kswapd does not in all places have the same criteria for a balanced zone. 
Zones are only being reclaimed when their high watermark is breached, but
compaction checks loop over the zonelist again when the zone does not meet
the low watermark plus two times the size of the allocation.  This gets
kswapd stuck in an endless loop over a small zone, like the DMA zone,
where the high watermark is smaller than the compaction requirement.

Add a function, zone_balanced(), that checks the watermark, and, for
higher order allocations, if compaction has enough free memory.  Then use
it uniformly to check for balanced zones.

This makes sure that when the compaction watermark is not met, at least
reclaim happens and progress is made - or the zone is declared
unreclaimable at some point and skipped entirely.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: George Spelvin <linux@horizon.com>
Reported-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Reported-by: Tomas Racek <tracek@redhat.com>
Tested-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-endless-loop-in-kswapd-balancing mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-endless-loop-in-kswapd-balancing
+++ a/mm/vmscan.c
@@ -2414,6 +2414,19 @@ static void age_active_anon(struct zone 
 	} while (memcg);
 }
 
+static bool zone_balanced(struct zone *zone, int order,
+			  unsigned long balance_gap, int classzone_idx)
+{
+	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
+				    balance_gap, classzone_idx, 0))
+		return false;
+
+	if (COMPACTION_BUILD && order && !compaction_suitable(zone, order))
+		return false;
+
+	return true;
+}
+
 /*
  * pgdat_balanced is used when checking if a node is balanced for high-order
  * allocations. Only zones that meet watermarks and are in a zone allowed
@@ -2492,8 +2505,7 @@ static bool prepare_kswapd_sleep(pg_data
 			continue;
 		}
 
-		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							i, 0))
+		if (!zone_balanced(zone, order, 0, i))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;
@@ -2602,8 +2614,7 @@ loop_again:
 				break;
 			}
 
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone), 0, 0)) {
+			if (!zone_balanced(zone, order, 0, 0)) {
 				end_zone = i;
 				break;
 			} else {
@@ -2679,9 +2690,8 @@ loop_again:
 				testorder = 0;
 
 			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
-				    !zone_watermark_ok_safe(zone, testorder,
-					high_wmark_pages(zone) + balance_gap,
-					end_zone, 0)) {
+			    !zone_balanced(zone, testorder,
+					   balance_gap, end_zone)) {
 				shrink_zone(zone, &sc);
 
 				reclaim_state->reclaimed_slab = 0;
@@ -2708,8 +2718,7 @@ loop_again:
 				continue;
 			}
 
-			if (!zone_watermark_ok_safe(zone, testorder,
-					high_wmark_pages(zone), end_zone, 0)) {
+			if (!zone_balanced(zone, testorder, 0, end_zone)) {
 				all_zones_ok = 0;
 				/*
 				 * We are still under min water mark.  This
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
avr32-kconfig-remove-have_arch_bootmem.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch

