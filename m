From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:53 -0700
Message-ID: <579ba6b9.rbc9U9ppdW0tsByb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcG2Szy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: release/reacquire lru_lock on pgdat change
has been removed from the -mm tree.  Its filename was
     mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mgorman@techsingularity.net are


