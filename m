From: akpm@linux-foundation.org
Subject: + mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch added to -mm tree
Date: Fri, 07 Sep 2012 12:56:14 -0700
Message-ID: <20120907195615.B7BD5200135@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44060 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab2IGT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 15:56:19 -0400
Received: by fass10 with SMTP id s10so189687fas.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 12:56:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm: page_alloc: use get_freepage_migratetype() instead of page_private()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch

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
 mm/page_alloc.c     |   10 ++++++----
 mm/page_isolation.c |    2 +-
 3 files changed, 19 insertions(+), 5 deletions(-)

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
@@ -671,8 +671,10 @@ static void free_pcppages_bulk(struct zo
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
-			__free_one_page(page, zone, 0, page_private(page));
-			trace_mm_page_pcpu_drain(page, 0, page_private(page));
+			__free_one_page(page, zone, 0,
+				get_freepage_migratetype(page));
+			trace_mm_page_pcpu_drain(page, 0,
+				get_freepage_migratetype(page));
 		} while (--to_free && --batch_free && !list_empty(list));
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
@@ -1134,7 +1136,7 @@ static int rmqueue_bulk(struct zone *zon
 			if (!is_migrate_cma(mt) && mt != MIGRATE_ISOLATE)
 				mt = migratetype;
 		}
-		set_page_private(page, mt);
+		set_freepage_migratetype(page, mt);
 		list = &page->lru;
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
@@ -1301,7 +1303,7 @@ void free_hot_cold_page(struct page *pag
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
@@ -196,7 +196,7 @@ __test_page_isolated_in_pageblock(unsign
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

