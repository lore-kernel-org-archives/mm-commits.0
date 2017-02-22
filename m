From: akpm@linux-foundation.org
Subject: [patch 125/142] mm, vmscan: consider eligible zones in
 get_scan_count
Date: Wed, 22 Feb 2017 15:46:01 -0800
Message-ID: <58ae22b9.3MurGfgC1ewkEW+N%akpm__16480.0080158331$1487807168$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934342AbdBVXqC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, stable@vger.kernel.org, trevor@tecnopolis.ca

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: consider eligible zones in get_scan_count

get_scan_count() considers the whole node LRU size when

- doing SCAN_FILE due to many page cache inactive pages
- calculating the number of pages to scan

In both cases this might lead to unexpected behavior especially on 32b
systems where we can expect lowmem memory pressure very often.

A large highmem zone can easily distort SCAN_FILE heuristic because there
might be only few file pages from the eligible zones on the node lru and
we would still enforce file lru scanning which can lead to trashing while
we could still scan anonymous pages.

The later use of lruvec_lru_size can be problematic as well.  Especially
when there are not many pages from the eligible zones.  We would have to
skip over many pages to find anything to reclaim but shrink_node_memcg
would only reduce the remaining number to scan by SWAP_CLUSTER_MAX at
maximum.  Therefore we can end up going over a large LRU many times
without actually having chance to reclaim much if anything at all.  The
closer we are out of memory on lowmem zone the worse the problem will be.

Fix this by filtering out all the ineligible zones when calculating the
lru size for both paths and consider only sc->reclaim_idx zones.

The patch would need to be tweaked a bit to apply to 4.10 and older but I
will do that as soon as it hits the Linus tree in the next merge window.

Link: http://lkml.kernel.org/r/20170117103702.28542-3-mhocko@kernel.org
Fixes: b2e18757f2c9 ("mm, vmscan: begin reclaiming pages on a per-node basis")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Tested-by: Trevor Cordes <trevor@tecnopolis.ca>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-consider-eligible-zones-in-get_scan_count mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-consider-eligible-zones-in-get_scan_count
+++ a/mm/vmscan.c
@@ -2233,7 +2233,7 @@ static void get_scan_count(struct lruvec
 	 * system is under heavy pressure.
 	 */
 	if (!inactive_list_is_low(lruvec, true, sc, false) &&
-	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES) >> sc->priority) {
+	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, sc->reclaim_idx) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2300,7 +2300,7 @@ out:
 			unsigned long size;
 			unsigned long scan;
 
-			size = lruvec_lru_size(lruvec, lru, MAX_NR_ZONES);
+			size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
 			scan = size >> sc->priority;
 
 			if (!scan && pass && force_scan)
_
