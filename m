From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-only-count-actual-rotations-as-lru-reclaim-cost.patch added to -mm tree
Date: Wed, 20 May 2020 20:32:07 -0700
Message-ID: <20200521033207.LCLBOZjXb%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgEUDcJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:09 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: only count actual rotations as LRU reclaim cost
has been added to the -mm tree.  Its filename is
     mm-only-count-actual-rotations-as-lru-reclaim-cost.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-only-count-actual-rotations-as-lru-reclaim-cost.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: only count actual rotations as LRU reclaim cost

When shrinking the active file list we rotate referenced pages only when
they're in an executable mapping.  The others get deactivated.  When it
comes to balancing scan pressure, though, we count all referenced pages as
rotated, even the deactivated ones.  Yet they do not carry the same cost
to the system: the deactivated page *might* refault later on, but the
deactivation is tangible progress toward freeing pages; rotations on the
other hand cost time and effort without getting any closer to freeing
memory.

Don't treat both events as equal.  The following patch will hook up LRU
balancing to cache and anon refaults, which are a much more concrete cost
signal for reclaiming one list over the other.  Thus, remove the maybe-IO
cost bias from page references, and only note the CPU cost for actual
rotations that prevent the pages from getting reclaimed.

Link: http://lkml.kernel.org/r/20200520232525.798933-11-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-only-count-actual-rotations-as-lru-reclaim-cost
+++ a/mm/vmscan.c
@@ -2054,7 +2054,6 @@ static void shrink_active_list(unsigned
 
 		if (page_referenced(page, 0, sc->target_mem_cgroup,
 				    &vm_flags)) {
-			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
@@ -2065,6 +2064,7 @@ static void shrink_active_list(unsigned
 			 * so we ignore them here.
 			 */
 			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
+				nr_rotated += hpage_nr_pages(page);
 				list_add(&page->lru, &l_active);
 				continue;
 			}
@@ -2080,10 +2080,8 @@ static void shrink_active_list(unsigned
 	 */
 	spin_lock_irq(&pgdat->lru_lock);
 	/*
-	 * Count referenced pages from currently used mappings as rotated,
-	 * even though only some of them are actually re-activated.  This
-	 * helps balance scan pressure between file and anonymous pages in
-	 * get_scan_count.
+	 * Rotating pages costs CPU without actually
+	 * progressing toward the reclaim goal.
 	 */
 	lru_note_cost(lruvec, file, nr_rotated);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-workingset-let-cache-workingset-challenge-anon.patch
mm-remove-use-once-cache-bias-from-lru-balancing.patch
mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
mm-base-lru-balancing-on-an-explicit-cost-model.patch
mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
mm-balance-lru-lists-based-on-relative-thrashing.patch
mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
mm-vmscan-reclaim-writepage-is-io-cost.patch
mm-vmscan-limit-the-range-of-lru-type-balancing.patch
