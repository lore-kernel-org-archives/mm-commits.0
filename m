From: akpm@linux-foundation.org
Subject: +
 mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch added to -mm tree
Date: Tue, 07 Mar 2017 15:27:35 -0800
Message-ID: <58bf41e7.wDu0M25F9Jy+Wqij%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756506AbdCHAVP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 19:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: change migrate_async_suitable() to suitable_migration_source()
has been added to the -mm tree.  Its filename is
     mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: change migrate_async_suitable() to suitable_migration_source()

Preparation for making the decisions more complex and depending on
compact_control flags.  No functional change.

Link: http://lkml.kernel.org/r/20170307131545.28577-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +++++
 mm/compaction.c        |   19 +++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-change-migrate_async_suitable-to-suitable_migration_source include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-change-migrate_async_suitable-to-suitable_migration_source
+++ a/include/linux/mmzone.h
@@ -74,6 +74,11 @@ extern char * const migratetype_names[MI
 #  define is_migrate_cma_page(_page) false
 #endif
 
+static inline bool is_migrate_movable(int mt)
+{
+	return is_migrate_cma(mt) || mt == MIGRATE_MOVABLE;
+}
+
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \
 		for (type = 0; type < MIGRATE_TYPES; type++)
diff -puN mm/compaction.c~mm-compaction-change-migrate_async_suitable-to-suitable_migration_source mm/compaction.c
--- a/mm/compaction.c~mm-compaction-change-migrate_async_suitable-to-suitable_migration_source
+++ a/mm/compaction.c
@@ -89,11 +89,6 @@ static void map_pages(struct list_head *
 	list_splice(&tmp_list, list);
 }
 
-static inline bool migrate_async_suitable(int migratetype)
-{
-	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
-}
-
 #ifdef CONFIG_COMPACTION
 
 int PageMovable(struct page *page)
@@ -988,6 +983,15 @@ isolate_migratepages_range(struct compac
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
 
+static bool suitable_migration_source(struct compact_control *cc,
+							struct page *page)
+{
+	if (cc->mode != MIGRATE_ASYNC)
+		return true;
+
+	return is_migrate_movable(get_pageblock_migratetype(page));
+}
+
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct compact_control *cc,
 							struct page *page)
@@ -1007,7 +1011,7 @@ static bool suitable_migration_target(st
 	}
 
 	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(get_pageblock_migratetype(page)))
+	if (is_migrate_movable(get_pageblock_migratetype(page)))
 		return true;
 
 	/* Otherwise skip the block */
@@ -1242,8 +1246,7 @@ static isolate_migrate_t isolate_migrate
 		 * Async compaction is optimistic to see if the minimum amount
 		 * of work satisfies the allocation.
 		 */
-		if (cc->mode == MIGRATE_ASYNC &&
-		    !migrate_async_suitable(get_pageblock_migratetype(page)))
+		if (!suitable_migration_source(cc, page))
 			continue;
 
 		/* Perform the isolation */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch

