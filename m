From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:55:44 -0700
Message-ID: <579ba6b0.E/yf0Vybitu69cjH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbcG2Szp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, pagevec: release/reacquire lru_lock on pgdat change
has been removed from the -mm tree.  Its filename was
     mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, pagevec: release/reacquire lru_lock on pgdat change

With node-lru, the locking is based on the pgdat. Previously it was
required that a pagevec drain released one zone lru_lock and acquired
another zone lru_lock on every zone change. Now, it's only necessary if
the node changes. The end-result is fewer lock release/acquires if the
pages are all on the same node but in different zones.

Link: http://lkml.kernel.org/r/1468588165-12461-4-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/swap.c~mm-pagevec-release-reacquire-lru_lock-on-pgdat-change mm/swap.c
--- a/mm/swap.c~mm-pagevec-release-reacquire-lru_lock-on-pgdat-change
+++ a/mm/swap.c
@@ -179,26 +179,26 @@ static void pagevec_lru_move_fn(struct p
 	void *arg)
 {
 	int i;
-	struct zone *zone = NULL;
+	struct pglist_data *pgdat = NULL;
 	struct lruvec *lruvec;
 	unsigned long flags = 0;
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
-		struct zone *pagezone = page_zone(page);
+		struct pglist_data *pagepgdat = page_pgdat(page);
 
-		if (pagezone != zone) {
-			if (zone)
-				spin_unlock_irqrestore(zone_lru_lock(zone), flags);
-			zone = pagezone;
-			spin_lock_irqsave(zone_lru_lock(zone), flags);
+		if (pagepgdat != pgdat) {
+			if (pgdat)
+				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+			pgdat = pagepgdat;
+			spin_lock_irqsave(&pgdat->lru_lock, flags);
 		}
 
-		lruvec = mem_cgroup_page_lruvec(page, zone->zone_pgdat);
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 		(*move_fn)(page, lruvec, arg);
 	}
-	if (zone)
-		spin_unlock_irqrestore(zone_lru_lock(zone), flags);
+	if (pgdat)
+		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


