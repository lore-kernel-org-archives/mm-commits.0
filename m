From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-is_migrate_highatomic-to-simplify-the-code.patch removed from -mm
 tree
Date: Thu, 04 May 2017 12:10:03 -0700
Message-ID: <20170504191003.ZQYWwnY4J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbdEDTKF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, qiuxishi@huawei.com, vbabka@suse.cz


The patch titled
     Subject: mm: use is_migrate_highatomic() to simplify the code
has been removed from the -mm tree.  Its filename was
     mm-use-is_migrate_highatomic-to-simplify-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use is_migrate_highatomic() to simplify the code

Introduce two helpers, is_migrate_highatomic() and is_migrate_highatomic_page().
Simplify the code, no functional changes.

[akpm@linux-foundation.org: use static inlines rather than macros, per mhocko]
Link: http://lkml.kernel.org/r/58B94F15.6060606@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/internal.h          |   10 ++++++++++
 mm/page_alloc.c        |   14 ++++++--------
 3 files changed, 17 insertions(+), 9 deletions(-)

diff -puN include/linux/mmzone.h~mm-use-is_migrate_highatomic-to-simplify-the-code include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-use-is_migrate_highatomic-to-simplify-the-code
+++ a/include/linux/mmzone.h
@@ -35,7 +35,7 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
-enum {
+enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
 	MIGRATE_RECLAIMABLE,
diff -puN mm/internal.h~mm-use-is_migrate_highatomic-to-simplify-the-code mm/internal.h
--- a/mm/internal.h~mm-use-is_migrate_highatomic-to-simplify-the-code
+++ a/mm/internal.h
@@ -510,4 +510,14 @@ extern const struct trace_print_flags pa
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
+static inline bool is_migrate_highatomic(enum migratetype migratetype)
+{
+	return migratetype == MIGRATE_HIGHATOMIC;
+}
+
+static inline bool is_migrate_highatomic_page(struct page *page)
+{
+	return get_pageblock_migratetype(page) == MIGRATE_HIGHATOMIC;
+}
+
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/page_alloc.c~mm-use-is_migrate_highatomic-to-simplify-the-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-is_migrate_highatomic-to-simplify-the-code
+++ a/mm/page_alloc.c
@@ -2036,8 +2036,8 @@ static void reserve_highatomic_pageblock
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
-	if (mt != MIGRATE_HIGHATOMIC &&
-			!is_migrate_isolate(mt) && !is_migrate_cma(mt)) {
+	if (!is_migrate_highatomic(mt) && !is_migrate_isolate(mt)
+	    && !is_migrate_cma(mt)) {
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 		set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
 		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC);
@@ -2094,8 +2094,7 @@ static bool unreserve_highatomic_pageblo
 			 * from highatomic to ac->migratetype. So we should
 			 * adjust the count once.
 			 */
-			if (get_pageblock_migratetype(page) ==
-							MIGRATE_HIGHATOMIC) {
+			if (is_migrate_highatomic_page(page)) {
 				/*
 				 * It should never happen but changes to
 				 * locking could inadvertently allow a per-cpu
@@ -2152,8 +2151,7 @@ __rmqueue_fallback(struct zone *zone, un
 
 		page = list_first_entry(&area->free_list[fallback_mt],
 						struct page, lru);
-		if (can_steal &&
-			get_pageblock_migratetype(page) != MIGRATE_HIGHATOMIC)
+		if (can_steal && !is_migrate_highatomic_page(page))
 			steal_suitable_fallback(zone, page, start_migratetype);
 
 		/* Remove the page from the freelists */
@@ -2493,7 +2491,7 @@ void free_hot_cold_page(struct page *pag
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Free ISOLATE pages back to the allocator because they are being
-	 * offlined but treat RESERVE as movable pages so we can get those
+	 * offlined but treat HIGHATOMIC as movable pages so we can get those
 	 * areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
@@ -2603,7 +2601,7 @@ int __isolate_free_page(struct page *pag
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


