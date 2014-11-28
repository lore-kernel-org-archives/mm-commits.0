From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch removed from -mm tree
Date: Thu, 27 Nov 2014 21:06:43 -0800
Message-ID: <547802e3.YTbY8IuJrfXp7/pN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaK1FGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Nov 2014 00:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: store updated page migratetype to avoid misusing stale value
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: page_alloc: store updated page migratetype to avoid misusing stale value

Commit ad53f92e ("fix incorrect isolation behavior by rechecking
migratetype") patch series describe the race between page isolation and
free path, and try to fix the freepage account issues.

However, there is still a little issue: freed page could have stale
migratetype in the free_list.  This would cause some bad behavior if we
misuse this stale value later.

Such as: in __test_page_isolated_in_pageblock() we check the buddy page,
if the page's stale migratetype is not MIGRATE_ISOLATE, which will cause
unnecessary page move action.

This patch stores the page's updated migratetype after freeing the page to
the free_list to avoid subsequent misusing stale value, and uses a
WARN_ON_ONCE to catch a potential undetected race between isolation and
free path.

[akpm@linux-foundation.org: fix comment]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    1 +
 mm/page_isolation.c |   17 +++++------------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value
+++ a/mm/page_alloc.c
@@ -627,6 +627,7 @@ static inline void __free_one_page(struc
 	}
 
 	list_add(&page->lru, &zone->free_area[order].free_list[migratetype]);
+	set_freepage_migratetype(page, migratetype);
 out:
 	zone->free_area[order].nr_free++;
 }
diff -puN mm/page_isolation.c~mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value
+++ a/mm/page_isolation.c
@@ -226,19 +226,12 @@ __test_page_isolated_in_pageblock(unsign
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page)) {
 			/*
-			 * If race between isolatation and allocation happens,
-			 * some free pages could be in MIGRATE_MOVABLE list
-			 * although pageblock's migratation type of the page
-			 * is MIGRATE_ISOLATE. Catch it and move the page into
-			 * MIGRATE_ISOLATE list.
+			 * Use a WARN_ON_ONCE to catch a potential undetected
+			 * race between isolation and pages freeing, even though
+			 * we try to avoid this issue.
 			 */
-			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
-				struct page *end_page;
