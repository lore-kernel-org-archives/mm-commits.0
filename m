From: akpm@linux-foundation.org
Subject: + mm-clean-up-__count_immobile_pages.patch added to -mm tree
Date: Fri, 22 Jun 2012 16:27:58 -0700
Message-ID: <20120622232758.F1566A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:57696 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab2FVX2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 19:28:01 -0400
Received: by lbbgp10 with SMTP id gp10so194110lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 16:28:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, aarcange@redhat.com, b.zolnierkie@samsung.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz


The patch titled
     Subject: mm: clean up __count_immobile_pages()
has been added to the -mm tree.  Its filename is
     mm-clean-up-__count_immobile_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5470,26 +5470,28 @@ void set_pageblock_flags_group(struct pa
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
@@ -5527,9 +5529,9 @@ __count_immobile_pages(struct zone *zone
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
@@ -5553,7 +5555,7 @@ bool is_pageblock_removable_nolock(struc
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
-	return __count_immobile_pages(zone, page, 0);
+	return !__has_unmovable_pages(zone, page, 0);
 }
 
 int set_migratetype_isolate(struct page *page)
@@ -5592,12 +5594,12 @@ int set_migratetype_isolate(struct page 
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if (__count_immobile_pages(zone, page, arg.pages_found))
+	if (!__has_unmovable_pages(zone, page, arg.pages_found))
 		ret = 0;
-
 	/*
-	 * immobile means "not-on-lru" paes. If immobile is larger than
-	 * removable-by-driver pages reported by notifier, we'll fail.
+	 * Unmovable means "not-on-lru" pages. If Unmovable pages are
+	 * larger than removable-by-driver pages reported by notifier,
+	 * we'll fail.
 	 */
 
 out:
_
Subject: Subject: mm: clean up __count_immobile_pages()

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-fix-page-reclaim-comment-error.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch

