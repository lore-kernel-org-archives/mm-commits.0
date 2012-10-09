From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:48 -0700
Message-ID: <20121009181149.3BE8920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:59964 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2JISLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:53 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so309288lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix pages missed by race rather than failing
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: memory-hotplug: fix pages missed by race rather than failing

If race between allocation and isolation in memory-hotplug offline
happens, some pages could be in MIGRATE_MOVABLE of free_list although the
pageblock's migratetype of the page is MIGRATE_ISOLATE.

The race could be detected by get_freepage_migratetype in
__test_page_isolated_in_pageblock.  If it is detected, now EBUSY gets
bubbled all the way up and the hotplug operations fails.

But better idea is instead of returning and failing memory-hotremove, move
the free page to the correct list at the time it is detected.  It could
enhance memory-hotremove operation success ratio although the race is
really rare.

Suggested by Mel Gorman.

[akpm@linux-foundation.org: small cleanup]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    4 ++++
 mm/page_alloc.c                |    2 +-
 mm/page_isolation.c            |   16 ++++++++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff -puN include/linux/page-isolation.h~memory-hotplug-fix-pages-missed-by-race-rather-than-failing include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~memory-hotplug-fix-pages-missed-by-race-rather-than-failing
+++ a/include/linux/page-isolation.h
@@ -6,6 +6,10 @@ bool has_unmovable_pages(struct zone *zo
 void set_pageblock_migratetype(struct page *page, int migratetype);
 int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype);
+int move_freepages(struct zone *zone,
+			  struct page *start_page, struct page *end_page,
+			  int migratetype);
+
 /*
  * Changes migrate type in [start_pfn, end_pfn) to be MIGRATE_ISOLATE.
  * If specified range includes migrate types other than MOVABLE or CMA,
diff -puN mm/page_alloc.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failing mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failing
+++ a/mm/page_alloc.c
@@ -925,7 +925,7 @@ static int fallbacks[MIGRATE_TYPES][4] =
  * Note that start_page and end_pages are not aligned on a pageblock
  * boundary. If alignment is required, use move_freepages_block()
  */
-static int move_freepages(struct zone *zone,
+int move_freepages(struct zone *zone,
 			  struct page *start_page, struct page *end_page,
 			  int migratetype)
 {
diff -puN mm/page_isolation.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failing mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failing
+++ a/mm/page_isolation.c
@@ -201,8 +201,20 @@ __test_page_isolated_in_pageblock(unsign
 		}
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page)) {
-			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE)
-				break;
+			/*
+			 * If race between isolatation and allocation happens,
+			 * some free pages could be in MIGRATE_MOVABLE list
+			 * although pageblock's migratation type of the page
+			 * is MIGRATE_ISOLATE. Catch it and move the page into
+			 * MIGRATE_ISOLATE list.
+			 */
+			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
+				struct page *end_page;
+
+				end_page = page + (1 << page_order(page)) - 1;
+				move_freepages(page_zone(page), page, end_page,
+						MIGRATE_ISOLATE);
+			}
 			pfn += 1 << page_order(page);
 		}
 		else if (page_count(page) == 0 &&
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

