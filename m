From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-__count_immobile_pages.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:49 -0700
Message-ID: <20120801201350.2ED9D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:60988 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:52 -0400
Received: by fat25 with SMTP id 25so341923fat.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, b.zolnierkie@samsung.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up __count_immobile_pages()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-__count_immobile_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: clean up __count_immobile_pages()

The __count_immobile_pages() naming is rather awkward.  Choose a more
clear name and add a comment.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN mm/page_alloc.c~mm-clean-up-__count_immobile_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-clean-up-__count_immobile_pages
+++ a/mm/page_alloc.c
@@ -5471,26 +5471,28 @@ void set_pageblock_flags_group(struct pa
 }
 
 /*
- * This is designed as sub function...plz see page_isolation.c also.
- * set/clear page block's type to be ISOLATE.
- * page allocater never alloc memory from ISOLATE block.
+ * This function checks whether pageblock includes unmovable pages or not.
+ * If @count is not zero, it is okay to include less @count unmovable pages
+ *
+ * PageLRU check wihtout isolation or lru_lock could race so that
+ * MIGRATE_MOVABLE block might include unmovable pages. It means you can't
+ * expect this function should be exact.
  */
-
-static int
-__count_immobile_pages(struct zone *zone, struct page *page, int count)
+static bool
+__has_unmovable_pages(struct zone *zone, struct page *page, int count)
 {
 	unsigned long pfn, iter, found;
 	int mt;
 
 	/*
 	 * For avoiding noise data, lru_add_drain_all() should be called
-	 * If ZONE_MOVABLE, the zone never contains immobile pages
+	 * If ZONE_MOVABLE, the zone never contains unmovable pages
 	 */
 	if (zone_idx(zone) == ZONE_MOVABLE)
-		return true;
+		return false;
 	mt = get_pageblock_migratetype(page);
 	if (mt == MIGRATE_MOVABLE || is_migrate_cma(mt))
-		return true;
+		return false;
 
 	pfn = page_to_pfn(page);
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
@@ -5528,9 +5530,9 @@ __count_immobile_pages(struct zone *zone
 		 * page at boot.
 		 */
 		if (found > count)
-			return false;
+			return true;
 	}
-	return true;
+	return false;
 }
 
 bool is_pageblock_removable_nolock(struct page *page)
@@ -5554,7 +5556,7 @@ bool is_pageblock_removable_nolock(struc
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
-	return __count_immobile_pages(zone, page, 0);
+	return !__has_unmovable_pages(zone, page, 0);
 }
 
 int set_migratetype_isolate(struct page *page)
@@ -5593,12 +5595,12 @@ int set_migratetype_isolate(struct page 
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if (__count_immobile_pages(zone, page, arg.pages_found))
+	if (!__has_unmovable_pages(zone, page, arg.pages_found))
 		ret = 0;
