From: akpm@linux-foundation.org
Subject: +
 mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch added to
 -mm tree
Date: Tue, 28 Feb 2017 15:53:30 -0800
Message-ID: <58b60d7a.9uZFx81EJ9LjnLWi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdB1XzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't avoid high-priority reclaim on unreclaimable nodes
has been added to the -mm tree.  Its filename is
     mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch

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
Subject: mm: don't avoid high-priority reclaim on unreclaimable nodes

246e87a93934 ("memcg: fix get_scan_count() for small targets") sought to
avoid high reclaim priorities for kswapd by forcing it to scan a minimum
amount of pages when lru_pages >> priority yielded nothing.

b95a2f2d486d ("mm: vmscan: convert global reclaim to per-memcg LRU
lists"), due to switching global reclaim to a round-robin scheme over all
cgroups, had to restrict this forceful behavior to unreclaimable zones in
order to prevent massive overreclaim with many cgroups.

The latter patch effectively neutered the behavior completely for all but
extreme memory pressure.  But in those situations we might as well drop
the reclaimers to lower priority levels.  Remove the check.

Link: http://lkml.kernel.org/r/20170228214007.5621-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes
+++ a/mm/vmscan.c
@@ -2129,22 +2129,13 @@ static void get_scan_count(struct lruvec
 	int pass;
 
 	/*
-	 * If the zone or memcg is small, nr[l] can be 0.  This
-	 * results in no scanning on this priority and a potential
-	 * priority drop.  Global direct reclaim can go to the next
-	 * zone and tends to have no problems. Global kswapd is for
-	 * zone balancing and it needs to scan a minimum amount. When
+	 * If the zone or memcg is small, nr[l] can be 0. When
 	 * reclaiming for a memcg, a priority drop can cause high
-	 * latencies, so it's better to scan a minimum amount there as
-	 * well.
+	 * latencies, so it's better to scan a minimum amount. When a
+	 * cgroup has already been deleted, scrape out the remaining
+	 * cache forcefully to get rid of the lingering state.
 	 */
-	if (current_is_kswapd()) {
-		if (!pgdat_reclaimable(pgdat))
-			force_scan = true;
-		if (!mem_cgroup_online(memcg))
-			force_scan = true;
-	}
-	if (!global_reclaim(sc))
+	if (!global_reclaim(sc) || !mem_cgroup_online(memcg))
 		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

