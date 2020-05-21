From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-let-cache-workingset-challenge-anon.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:31:56 -0700
Message-ID: <20200521033156.6qCTgox9f%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbgEUDb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:31:58 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: workingset: let cache workingset challenge anon
has been added to the -mm tree.  Its filename is
     mm-workingset-let-cache-workingset-challenge-anon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-let-cache-workingset-challenge-anon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-let-cache-workingset-challenge-anon.patch

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
Subject: mm: workingset: let cache workingset challenge anon

We activate cache refaults with reuse distances in pages smaller than the
size of the total cache.  This allows new pages with competitive access
frequencies to establish themselves, as well as challenge and potentially
displace pages on the active list that have gone cold.

However, that assumes that active cache can only replace other active
cache in a competition for the hottest memory.  This is not a great
default assumption.  The page cache might be thrashing while there are
enough completely cold and unused anonymous pages sitting around that we'd
only have to write to swap once to stop all IO from the cache.

Activate cache refaults when their reuse distance in pages is smaller than
the total userspace workingset, including anonymous pages.

Reclaim can still decide how to balance pressure among the two LRUs
depending on the IO situation.  Rotational drives will prefer avoiding
random IO from swap and go harder after cache.  But fundamentally, hot
cache should be able to compete with anon pages for a place in RAM.

Link: http://lkml.kernel.org/r/20200520232525.798933-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/workingset.c~mm-workingset-let-cache-workingset-challenge-anon
+++ a/mm/workingset.c
@@ -277,8 +277,8 @@ void workingset_refault(struct page *pag
 	struct mem_cgroup *eviction_memcg;
 	struct lruvec *eviction_lruvec;
 	unsigned long refault_distance;
+	unsigned long workingset_size;
 	struct pglist_data *pgdat;
-	unsigned long active_file;
 	struct mem_cgroup *memcg;
 	unsigned long eviction;
 	struct lruvec *lruvec;
@@ -310,7 +310,6 @@ void workingset_refault(struct page *pag
 		goto out;
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->inactive_age);
-	active_file = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
 
 	/*
 	 * Calculate the refault distance
@@ -345,10 +344,18 @@ void workingset_refault(struct page *pag
 
 	/*
 	 * Compare the distance to the existing workingset size. We
-	 * don't act on pages that couldn't stay resident even if all
-	 * the memory was available to the page cache.
+	 * don't activate pages that couldn't stay resident even if
+	 * all the memory was available to the page cache. Whether
+	 * cache can compete with anon or not depends on having swap.
 	 */
-	if (refault_distance > active_file)
+	workingset_size = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
+	if (mem_cgroup_get_nr_swap_pages(memcg) > 0) {
+		workingset_size += lruvec_page_state(eviction_lruvec,
+						     NR_INACTIVE_ANON);
+		workingset_size += lruvec_page_state(eviction_lruvec,
+						     NR_ACTIVE_ANON);
+	}
+	if (refault_distance > workingset_size)
 		goto out;
 
 	SetPageActive(page);
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
