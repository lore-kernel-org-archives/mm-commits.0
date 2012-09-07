From: akpm@linux-foundation.org
Subject: + mm-remain-migratetype-in-freed-page.patch added to -mm tree
Date: Fri, 07 Sep 2012 12:56:18 -0700
Message-ID: <20120907195619.4DAB81E00E7@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39402 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2IGT4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 15:56:21 -0400
Received: by vbis24 with SMTP id s24so40418vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 12:56:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm: remain migratetype in freed page
has been added to the -mm tree.  Its filename is
     mm-remain-migratetype-in-freed-page.patch

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
@@ -723,6 +723,7 @@ static void __free_pages_ok(struct page 
 {
 	unsigned long flags;
 	int wasMlocked = __TestClearPageMlocked(page);
+	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -731,8 +732,9 @@ static void __free_pages_ok(struct page 
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
 
@@ -952,6 +954,7 @@ static int move_freepages(struct zone *z
 		order = page_order(page);
 		list_move(&page->lru,
 			  &zone->free_area[order].free_list[migratetype]);
+		set_freepage_migratetype(page, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-change-enum-migrate_mode-with-bitwise-type.patch
mm-support-migrate_discard.patch
mm-support-migrate_discard-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch

