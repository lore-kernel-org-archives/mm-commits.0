From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch added to -mm tree
Date: Fri, 07 Sep 2012 12:56:25 -0700
Message-ID: <20120907195626.C775D5C01DB@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:44238 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2IGT43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 15:56:29 -0400
Received: by weyr1 with SMTP id r1so190188wey.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 12:56:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug: fix pages missed by race rather than failing
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch

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
 mm/page_isolation.c            |   15 +++++++++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

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
@@ -918,7 +918,7 @@ static int fallbacks[MIGRATE_TYPES][4] =
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
@@ -194,8 +194,19 @@ __test_page_isolated_in_pageblock(unsign
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
+				struct page *end_page = page +
+						(1 << page_order(page)) - 1;
+				move_freepages(page_zone(page), page, end_page,
+						MIGRATE_ISOLATE);
+			}
 			pfn += 1 << page_order(page);
 		}
 		else if (page_count(page) == 0 &&
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

