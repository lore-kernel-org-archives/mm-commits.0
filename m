From: akpm@linux-foundation.org
Subject: [merged] memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:27 -0700
Message-ID: <53e3dc43.sXRrGSfH7+Q4qZKp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59030 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaHGUG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:28 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so844029obc.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, vmscan: Fix forced scan of anonymous pages
has been removed from the -mm tree.  Its filename was
     memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: memcg, vmscan: Fix forced scan of anonymous pages

When memory cgoups are enabled, the code that decides to force to scan
anonymous pages in get_scan_count() compares global values (free,
high_watermark) to a value that is restricted to a memory cgroup (file). 
It make the code over-eager to force anon scan.

For instance, it will force anon scan when scanning a memcg that is mainly
populated by anonymous page, even when there is plenty of file pages to
get rid of in others memcgs, even when swappiness == 0.  It breaks user's
expectation about swappiness and hurts performance.

This patch makes sure that forced anon scan only happens when there not
enough file pages for the all zone, not just in one random memcg.

[hannes@cmpxchg.org: cleanups]
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~memcg-vmscan-fix-forced-scan-of-anonymous-pages mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-fix-forced-scan-of-anonymous-pages
+++ a/mm/vmscan.c
@@ -1930,11 +1930,6 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
-	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
-		get_lru_size(lruvec, LRU_INACTIVE_ANON);
-	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
-		get_lru_size(lruvec, LRU_INACTIVE_FILE);
-
 	/*
 	 * Prevent the reclaimer from falling into the cache trap: as
 	 * cache pages start out inactive, every cache fault will tip
@@ -1945,9 +1940,14 @@ static void get_scan_count(struct lruvec
 	 * anon pages.  Try to detect this based on file LRU size.
 	 */
 	if (global_reclaim(sc)) {
-		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
+		unsigned long zonefile;
+		unsigned long zonefree;
+
+		zonefree = zone_page_state(zone, NR_FREE_PAGES);
+		zonefile = zone_page_state(zone, NR_ACTIVE_FILE) +
+			   zone_page_state(zone, NR_INACTIVE_FILE);
 
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
+		if (unlikely(zonefile + zonefree <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
 			goto out;
 		}
@@ -1982,6 +1982,12 @@ static void get_scan_count(struct lruvec
 	 *
 	 * anon in [0], file in [1]
 	 */
+
+	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
+		get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
+		get_lru_size(lruvec, LRU_INACTIVE_FILE);
+
 	spin_lock_irq(&zone->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		reclaim_stat->recent_scanned[0] /= 2;
_

Patches currently in -mm which might be from jmarchan@redhat.com are

origin.patch

