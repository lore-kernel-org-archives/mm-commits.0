From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-deactivations-shouldnt-bias-the-lru-balance.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:32:05 -0700
Message-ID: <20200521033205.4_ro2ng3k%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgEUDcG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:06 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: deactivations shouldn't bias the LRU balance
has been added to the -mm tree.  Its filename is
     mm-deactivations-shouldnt-bias-the-lru-balance.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-deactivations-shouldnt-bias-the-lru-balance.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-deactivations-shouldnt-bias-the-lru-balance.patch

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
Subject: mm: deactivations shouldn't bias the LRU balance

Operations like MADV_FREE, FADV_DONTNEED etc.  currently move any affected
active pages to the inactive list to accelerate their reclaim (good) but
also steer page reclaim toward that LRU type, or away from the other
(bad).

The reason why this is undesirable is that such operations are not part of
the regular page aging cycle, and rather a fluke that doesn't say much
about the remaining pages on that list; they might all be in heavy use,
and once the chunk of easy victims has been purged, the VM continues to
apply elevated pressure on those remaining hot pages.  The other LRU,
meanwhile, might have easily reclaimable pages, and there was never a need
to steer away from it in the first place.

As the previous patch outlined, we should focus on recording actually
observed cost to steer the balance rather than speculating about the
potential value of one LRU list over the other.  In that spirit, leave
explicitely deactivated pages to the LRU algorithm to pick up, and let
rotations decide which list is the easiest to reclaim.

Link: http://lkml.kernel.org/r/20200520232525.798933-10-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swap.c~mm-deactivations-shouldnt-bias-the-lru-balance
+++ a/mm/swap.c
@@ -515,14 +515,12 @@ static void lru_deactivate_file_fn(struc
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
-	lru_note_cost(lruvec, !file, hpage_nr_pages(page));
 }
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
 			    void *arg)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
@@ -531,7 +529,6 @@ static void lru_deactivate_fn(struct pag
 		add_page_to_lru_list(page, lruvec, lru);
 
 		__count_vm_events(PGDEACTIVATE, hpage_nr_pages(page));
-		lru_note_cost(lruvec, !file, hpage_nr_pages(page));
 	}
 }
 
@@ -556,7 +553,6 @@ static void lru_lazyfree_fn(struct page
 
 		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
 		count_memcg_page_event(page, PGLAZYFREE);
-		lru_note_cost(lruvec, 0, hpage_nr_pages(page));
 	}
 }
 
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
