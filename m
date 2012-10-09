From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:45 -0700
Message-ID: <20121009181145.DC6D81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39150 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2JISLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:46 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so661217ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, qiuxishi@huawei.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: bug fix race between isolation and allocation
has been removed from the -mm tree.  Its filename was
     memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: memory-hotplug: bug fix race between isolation and allocation

Like below, memory-hotplug makes race between page-isolation
and page-allocation so it can hit BUG_ON in __offline_isolated_pages.

	CPU A					CPU B

start_isolate_page_range
set_migratetype_isolate
spin_lock_irqsave(zone->lock)

				free_hot_cold_page(Page A)
				/* without zone->lock */
				migratetype = get_pageblock_migratetype(Page A);
				/*
				 * Page could be moved into MIGRATE_MOVABLE
				 * of per_cpu_pages
				 */
				list_add_tail(&page->lru, &pcp->lists[migratetype]);

set_pageblock_isolate
move_freepages_block
drain_all_pages

				/* Page A could be in MIGRATE_MOVABLE of free_list. */

check_pages_isolated
__test_page_isolated_in_pageblock
/*
 * We can't catch freed page which
 * is free_list[MIGRATE_MOVABLE]
 */
if (PageBuddy(page A))
	pfn += 1 << page_order(page A);

				/* So, Page A could be allocated */

__offline_isolated_pages
/*
 * BUG_ON hit or offline page
 * which is used by someone
 */
BUG_ON(!PageBuddy(page A));

This patch checks page's migratetype in freelist in
__test_page_isolated_in_pageblock.  So now
__test_page_isolated_in_pageblock can check the page caused by above race
and can fail of memory offlining.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_isolation.c~memory-hotplug-bug-fix-race-between-isolation-and-allocation mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-bug-fix-race-between-isolation-and-allocation
+++ a/mm/page_isolation.c
@@ -200,8 +200,11 @@ __test_page_isolated_in_pageblock(unsign
 			continue;
 		}
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page))
+		if (PageBuddy(page)) {
+			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE)
+				break;
 			pfn += 1 << page_order(page);
+		}
 		else if (page_count(page) == 0 &&
 			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
 			pfn += 1;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

