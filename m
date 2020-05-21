From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:32:00 -0700
Message-ID: <20200521033200.rtNX0jfpb%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbgEUDcB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:01 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: vmscan: drop unnecessary div0 avoidance rounding in get_scan_count()
has been added to the -mm tree.  Its filename is
     mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch

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
Subject: mm: vmscan: drop unnecessary div0 avoidance rounding in get_scan_count()

When we calculate the relative scan pressure between the anon and file LRU
lists, we have to assume that reclaim_stat can contain zeroes.  To avoid
div0 crashes, we add 1 to all denominators like so:

        anon_prio = swappiness;
        file_prio = 200 - anon_prio;

	[...]

        /*
         * The amount of pressure on anon vs file pages is inversely
         * proportional to the fraction of recently scanned pages on
         * each list that were recently referenced and in active use.
         */
        ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
        ap /= reclaim_stat->recent_rotated[0] + 1;

        fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
        fp /= reclaim_stat->recent_rotated[1] + 1;
        spin_unlock_irq(&pgdat->lru_lock);

        fraction[0] = ap;
        fraction[1] = fp;
        denominator = ap + fp + 1;

While reclaim_stat can contain 0, it's not actually possible for ap + fp
to be 0.  One of anon_prio or file_prio could be zero, but they must still
add up to 200.  And the reclaim_stat fraction, due to the +1 in there, is
always at least 1.  So if one of the two numerators is 0, the other one
can't be.  ap + fp is always at least 1.  Drop the + 1.

Link: http://lkml.kernel.org/r/20200520232525.798933-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count
+++ a/mm/vmscan.c
@@ -2348,7 +2348,7 @@ static void get_scan_count(struct lruvec
 
 	fraction[0] = ap;
 	fraction[1] = fp;
-	denominator = ap + fp + 1;
+	denominator = ap + fp;
 out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
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
