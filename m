From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-limit-the-range-of-lru-type-balancing.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:32:20 -0700
Message-ID: <20200521033220.Ez2XvcTDF%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgEUDcW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:22 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: vmscan: limit the range of LRU type balancing
has been added to the -mm tree.  Its filename is
     mm-vmscan-limit-the-range-of-lru-type-balancing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-limit-the-range-of-lru-type-balancing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-limit-the-range-of-lru-type-balancing.patch

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
Subject: mm: vmscan: limit the range of LRU type balancing

When LRU cost only shows up on one list, we abruptly stop scanning that
list altogether.  That's an extreme reaction: by the time the other list
starts thrashing and the pendulum swings back, we may have no recent age
information on the first list anymore, and we could have significant
latencies until the scanner has caught up.

Soften this change in the feedback system by ensuring that no list
receives less than a third of overall pressure, and only distribute the
other 66% according to LRU cost.  This ensures that we maintain a minimum
rate of aging on the entire workingset while it's being pressured, while
still allowing a generous rate of convergence when the relative sizes of
the lists need to adjust.

Link: http://lkml.kernel.org/r/20200520232525.798933-15-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-limit-the-range-of-lru-type-balancing
+++ a/mm/vmscan.c
@@ -2237,12 +2237,11 @@ static void get_scan_count(struct lruvec
 			   unsigned long *nr)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	unsigned long anon_cost, file_cost, total_cost;
 	int swappiness = mem_cgroup_swappiness(memcg);
 	u64 fraction[2];
 	u64 denominator = 0;	/* gcc */
-	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
-	unsigned long totalcost;
 	unsigned long ap, fp;
 	enum lru_list lru;
 
@@ -2301,17 +2300,22 @@ static void get_scan_count(struct lruvec
 	 * the relative IO cost of bringing back a swapped out
 	 * anonymous page vs reloading a filesystem page (swappiness).
 	 *
+	 * Although we limit that influence to ensure no list gets
+	 * left behind completely: at least a third of the pressure is
+	 * applied, before swappiness.
+	 *
 	 * With swappiness at 100, anon and file have equal IO cost.
 	 */
-	anon_prio = swappiness;
-	file_prio = 200 - anon_prio;
+	total_cost = sc->anon_cost + sc->file_cost;
+	anon_cost = total_cost + sc->anon_cost;
+	file_cost = total_cost + sc->file_cost;
+	total_cost = anon_cost + file_cost;
 
-	totalcost = sc->anon_cost + sc->file_cost;
-	ap = anon_prio * (totalcost + 1);
-	ap /= sc->anon_cost + 1;
+	ap = swappiness * (total_cost + 1);
+	ap /= anon_cost + 1;
 
-	fp = file_prio * (totalcost + 1);
-	fp /= sc->file_cost + 1;
+	fp = (200 - swappiness) * (total_cost + 1);
+	fp /= file_cost + 1;
 
 	fraction[0] = ap;
 	fraction[1] = fp;
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
