From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:39 -0700
Message-ID: <20121009181139.BFA391E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53577 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2JISLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:41 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so662339vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: use get_freepage_migratetype() instead of page_private()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: page_alloc: use get_freepage_migratetype() instead of page_private()

The page allocator uses set_page_private and page_private for handling
migratetype when it frees page.  Let's replace them with [set|get]
_freepage_migratetype to make it more clear.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   12 ++++++++++++
 mm/page_alloc.c     |    6 +++---
 mm/page_isolation.c |    2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private
+++ a/include/linux/mm.h
@@ -237,6 +237,18 @@ struct inode;
 #define page_private(page)		((page)->private)
 #define set_page_private(page, v)	((page)->private = (v))
 
+/* It's valid only if the page is free path or free_list */
+static inline void set_freepage_migratetype(struct page *page, int migratetype)
+{
+	set_page_private(page, migratetype);
+}
+
+/* It's valid only if the page is free path or free_list */
+static inline int get_freepage_migratetype(struct page *page)
+{
+	return page_private(page);
+}
+
 /*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
diff -puN mm/page_alloc.c~mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private
+++ a/mm/page_alloc.c
@@ -674,7 +674,7 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
-			mt = page_private(page);
+			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
@@ -1143,7 +1143,7 @@ static int rmqueue_bulk(struct zone *zon
 			if (!is_migrate_cma(mt) && mt != MIGRATE_ISOLATE)
 				mt = migratetype;
 		}
-		set_page_private(page, mt);
+		set_freepage_migratetype(page, mt);
 		list = &page->lru;
 		if (is_migrate_cma(mt))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
@@ -1313,7 +1313,7 @@ void free_hot_cold_page(struct page *pag
 		return;
 
 	migratetype = get_pageblock_migratetype(page);
-	set_page_private(page, migratetype);
+	set_freepage_migratetype(page, migratetype);
 	local_irq_save(flags);
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
diff -puN mm/page_isolation.c~mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private
+++ a/mm/page_isolation.c
@@ -203,7 +203,7 @@ __test_page_isolated_in_pageblock(unsign
 		if (PageBuddy(page))
 			pfn += 1 << page_order(page);
 		else if (page_count(page) == 0 &&
-				page_private(page) == MIGRATE_ISOLATE)
+			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
 			pfn += 1;
 		else
 			break;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

