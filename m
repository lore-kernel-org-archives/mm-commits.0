From: akpm@linux-foundation.org
Subject: [patch 057/101] mm, vmscan: release/reacquire lru_lock on pgdat
 change
Date: Thu, 28 Jul 2016 15:47:23 -0700
Message-ID: <579a8b7b.ZYQOWNaNUJU8jog5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcG1WrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, minchan@kernel.org, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: release/reacquire lru_lock on pgdat change

With node-lru, the locking is based on the pgdat. As Minchan pointed
out, there is an opportunity to reduce LRU lock release/acquire in
check_move_unevictable_pages by only changing lock on a pgdat change.

[mgorman@techsingularity.net: remove double initialisation]
  Link: http://lkml.kernel.org/r/20160719074835.GC10438@techsingularity.net
Link: http://lkml.kernel.org/r/1468853426-12858-3-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-release-reacquire-lru_lock-on-pgdat-change mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-release-reacquire-lru_lock-on-pgdat-change
+++ a/mm/vmscan.c
@@ -3774,24 +3774,23 @@ int page_evictable(struct page *page)
 void check_move_unevictable_pages(struct page **pages, int nr_pages)
 {
 	struct lruvec *lruvec;
-	struct zone *zone = NULL;
+	struct pglist_data *pgdat = NULL;
 	int pgscanned = 0;
 	int pgrescued = 0;
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pages[i];
-		struct zone *pagezone;
+		struct pglist_data *pagepgdat = page_pgdat(page);
 
 		pgscanned++;
-		pagezone = page_zone(page);
-		if (pagezone != zone) {
-			if (zone)
-				spin_unlock_irq(zone_lru_lock(zone));
-			zone = pagezone;
-			spin_lock_irq(zone_lru_lock(zone));
+		if (pagepgdat != pgdat) {
+			if (pgdat)
+				spin_unlock_irq(&pgdat->lru_lock);
+			pgdat = pagepgdat;
+			spin_lock_irq(&pgdat->lru_lock);
 		}
-		lruvec = mem_cgroup_page_lruvec(page, zone->zone_pgdat);
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 		if (!PageLRU(page) || !PageUnevictable(page))
 			continue;
@@ -3807,10 +3806,10 @@ void check_move_unevictable_pages(struct
 		}
 	}
 
-	if (zone) {
+	if (pgdat) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		spin_unlock_irq(zone_lru_lock(zone));
+		spin_unlock_irq(&pgdat->lru_lock);
 	}
 }
 #endif /* CONFIG_SHMEM */
_
