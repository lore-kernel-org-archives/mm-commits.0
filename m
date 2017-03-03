From: akpm@linux-foundation.org
Subject: + mm-use-is_migrate_highatomic-to-simplify-the-code.patch added
 to -mm tree
Date: Fri, 03 Mar 2017 15:06:30 -0800
Message-ID: <58b9f6f6.T/iI7oadPDsrO0ol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdCCXPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:15:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use is_migrate_highatomic() to simplify the code
has been added to the -mm tree.  Its filename is
     mm-use-is_migrate_highatomic-to-simplify-the-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-is_migrate_highatomic-to-simplify-the-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-is_migrate_highatomic-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use is_migrate_highatomic() to simplify the code

Introduce two helpers, is_migrate_highatomic() and is_migrate_highatomic_page().
Simplify the code, no functional changes.

Link: http://lkml.kernel.org/r/58B94F15.6060606@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +++++
 mm/page_alloc.c        |   14 ++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-use-is_migrate_highatomic-to-simplify-the-code include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-use-is_migrate_highatomic-to-simplify-the-code
+++ a/include/linux/mmzone.h
@@ -66,6 +66,11 @@ enum {
 /* In mm/page_alloc.c; keep in sync also with show_migration_types() there */
 extern char * const migratetype_names[MIGRATE_TYPES];
 
+#define is_migrate_highatomic(migratetype)				\
+	(migratetype == MIGRATE_HIGHATOMIC)
+#define is_migrate_highatomic_page(_page)				\
+	(get_pageblock_migratetype(_page) == MIGRATE_HIGHATOMIC)
+
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #  define is_migrate_cma_page(_page) (get_pageblock_migratetype(_page) == MIGRATE_CMA)
diff -puN mm/page_alloc.c~mm-use-is_migrate_highatomic-to-simplify-the-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-is_migrate_highatomic-to-simplify-the-code
+++ a/mm/page_alloc.c
@@ -2034,8 +2034,8 @@ static void reserve_highatomic_pageblock
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
-	if (mt != MIGRATE_HIGHATOMIC &&
-			!is_migrate_isolate(mt) && !is_migrate_cma(mt)) {
+	if (!is_migrate_highatomic(mt) && !is_migrate_isolate(mt)
+	    && !is_migrate_cma(mt)) {
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 		set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
 		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC);
@@ -2092,8 +2092,7 @@ static bool unreserve_highatomic_pageblo
 			 * from highatomic to ac->migratetype. So we should
 			 * adjust the count once.
 			 */
-			if (get_pageblock_migratetype(page) ==
-							MIGRATE_HIGHATOMIC) {
+			if (is_migrate_highatomic_page(page)) {
 				/*
 				 * It should never happen but changes to
 				 * locking could inadvertently allow a per-cpu
@@ -2150,8 +2149,7 @@ __rmqueue_fallback(struct zone *zone, un
 
 		page = list_first_entry(&area->free_list[fallback_mt],
 						struct page, lru);
-		if (can_steal &&
-			get_pageblock_migratetype(page) != MIGRATE_HIGHATOMIC)
+		if (can_steal && !is_migrate_highatomic_page(page))
 			steal_suitable_fallback(zone, page, start_migratetype);
 
 		/* Remove the page from the freelists */
@@ -2488,7 +2486,7 @@ void free_hot_cold_page(struct page *pag
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Free ISOLATE pages back to the allocator because they are being
-	 * offlined but treat RESERVE as movable pages so we can get those
+	 * offlined but treat HIGHATOMIC as movable pages so we can get those
 	 * areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
@@ -2599,7 +2597,7 @@ int __isolate_free_page(struct page *pag
 		for (; page < endpage; page += pageblock_nr_pages) {
 			int mt = get_pageblock_migratetype(page);
 			if (!is_migrate_isolate(mt) && !is_migrate_cma(mt)
-				&& mt != MIGRATE_HIGHATOMIC)
+			    && !is_migrate_highatomic(mt))
 				set_pageblock_migratetype(page,
 							  MIGRATE_MOVABLE);
 		}
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-use-is_migrate_highatomic-to-simplify-the-code.patch
mm-use-is_migrate_isolate_page-to-simplify-the-code.patch

