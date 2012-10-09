From: akpm@linux-foundation.org
Subject: [merged] mm-remain-migratetype-in-freed-page.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:42 -0700
Message-ID: <20121009181142.B9A611E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33038 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2JISLn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:43 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660901ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remain migratetype in freed page
has been removed from the -mm tree.  Its filename was
     mm-remain-migratetype-in-freed-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remain migratetype in freed page

The page allocator caches the pageblock information in page->private while
it is in the PCP freelists but this is overwritten with the order of the
page when freed to the buddy allocator.  This patch stores the migratetype
of the page in the page->index field so that it is available at all times
when the page remain in free_list.

This patch adds a new call site in __free_pages_ok so it might be overhead
a bit but it's for high order allocation.  So I believe damage isn't hurt.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 mm/page_alloc.c    |    7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-remain-migratetype-in-freed-page include/linux/mm.h
--- a/include/linux/mm.h~mm-remain-migratetype-in-freed-page
+++ a/include/linux/mm.h
@@ -240,13 +240,13 @@ struct inode;
 /* It's valid only if the page is free path or free_list */
 static inline void set_freepage_migratetype(struct page *page, int migratetype)
 {
-	set_page_private(page, migratetype);
+	page->index = migratetype;
 }
 
 /* It's valid only if the page is free path or free_list */
 static inline int get_freepage_migratetype(struct page *page)
 {
-	return page_private(page);
+	return page->index;
 }
 
 /*
diff -puN mm/page_alloc.c~mm-remain-migratetype-in-freed-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remain-migratetype-in-freed-page
+++ a/mm/page_alloc.c
@@ -729,6 +729,7 @@ static void __free_pages_ok(struct page 
 {
 	unsigned long flags;
 	int wasMlocked = __TestClearPageMlocked(page);
+	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -737,8 +738,9 @@ static void __free_pages_ok(struct page 
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, order,
-					get_pageblock_migratetype(page));
+	migratetype = get_pageblock_migratetype(page);
+	set_freepage_migratetype(page, migratetype);
+	free_one_page(page_zone(page), page, order, migratetype);
 	local_irq_restore(flags);
 }
 
@@ -959,6 +961,7 @@ static int move_freepages(struct zone *z
 		order = page_order(page);
 		list_move(&page->lru,
 			  &zone->free_area[order].free_list[migratetype]);
+		set_freepage_migratetype(page, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

