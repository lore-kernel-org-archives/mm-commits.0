From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 14:12:22 -0800
Message-ID: <54dbd3c6.2F2E8otUW8xw6cqR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbbBKWMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 17:12:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, vdavydov@parallels.com, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

This patch was dropped because it was folded into mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix

Move the zone_page_state_snapshot() fallback logic into
too_many_isolated(), so shrink_inactive_list() doesn't incorrectly call
congestion_wait().

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix
+++ a/mm/vmscan.c
@@ -1402,7 +1402,7 @@ int isolate_lru_page(struct page *page)
 }
 
 static int __too_many_isolated(struct zone *zone, int file,
-	struct scan_control *sc, int safe)
+			       struct scan_control *sc, int safe)
 {
 	unsigned long inactive, isolated;
 
@@ -1435,7 +1435,7 @@ static int __too_many_isolated(struct zo
  * unnecessary swapping, thrashing and OOM.
  */
 static int too_many_isolated(struct zone *zone, int file,
-		struct scan_control *sc, int safe)
+			     struct scan_control *sc)
 {
 	if (current_is_kswapd())
 		return 0;
@@ -1443,12 +1443,14 @@ static int too_many_isolated(struct zone
 	if (!global_reclaim(sc))
 		return 0;
 
-	if (unlikely(__too_many_isolated(zone, file, sc, 0))) {
-		if (safe)
-			return __too_many_isolated(zone, file, sc, safe);
-		else
-			return 1;
-	}
+	/*
+	 * __too_many_isolated(safe=0) is fast but inaccurate, because it
+	 * doesn't account for the vm_stat_diff[] counters.  So if it looks
+	 * like too_many_isolated() is about to return true, fall back to the
+	 * slower, more accurate zone_page_state_snapshot().
+	 */
+	if (unlikely(__too_many_isolated(zone, file, sc, 0)))
+		return __too_many_isolated(zone, file, sc, 1);
 
 	return 0;
 }
@@ -1540,18 +1542,15 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_immediate = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
-	int safe = 0;
 	struct zone *zone = lruvec_zone(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	while (unlikely(too_many_isolated(zone, file, sc, safe))) {
+	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
 			return SWAP_CLUSTER_MAX;
