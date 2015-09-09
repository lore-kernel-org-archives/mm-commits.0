From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:59 -0700
Message-ID: <55f08c77.GIxpvBvNxEUOUQc4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbbIITqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_isolation: remove bogus tests for isolated pages
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_isolation: remove bogus tests for isolated pages

The __test_page_isolated_in_pageblock() is used to verify whether all
pages in pageblock were either successfully isolated, or are hwpoisoned. 
Two of the possible state of pages, that are tested, are however bogus and
misleading.

Both tests rely on get_freepage_migratetype(page), which however has no
guarantees about pages on freelists.  Specifically, it doesn't guarantee
that the migratetype returned by the function actually matches the
migratetype of the freelist that the page is on.  Such guarantee is not
its purpose and would have negative impact on allocator performance.

The first test checks whether the freepage_migratetype equals
MIGRATE_ISOLATE, supposedly to catch races between page isolation and
allocator activity.  These races should be fixed nowadays with 51bb1a4093
("mm/page_alloc: add freepage on isolate pageblock to correct buddy list")
and related patches.  As explained above, the check wouldn't be able to
catch them reliably anyway.  For the same reason false positives can
happen, although they are harmless, as the move_freepages() call would
just move the page to the same freelist it's already on.  So removing the
test is not a bug fix, just cleanup.  After this patch, we assume that all
PageBuddy pages are on the correct freelist and that the races were really
fixed.  A truly reliable verification in the form of e.g.  VM_BUG_ON()
would be complicated and is arguably not needed.

The second test (page_count(page) == 0 && get_freepage_migratetype(page)
== MIGRATE_ISOLATE) is probably supposed (the code comes from a big memory
isolation patch from 2007) to catch pages on MIGRATE_ISOLATE pcplists. 
However, pcplists don't contain MIGRATE_ISOLATE freepages nowadays, those
are freed directly to free lists, so the check is obsolete.  Remove it as
well.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Seungho Park <seungho1.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    4 ++++
 mm/page_isolation.c |   30 ++++++------------------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff -puN mm/page_alloc.c~mm-page_isolation-remove-bogus-tests-for-isolated-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_isolation-remove-bogus-tests-for-isolated-pages
+++ a/mm/page_alloc.c
@@ -788,7 +788,11 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+
 			mt = get_freepage_migratetype(page);
+			/* MIGRATE_ISOLATE page should not go to pcplists */
+			VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
+			/* Pageblock could have been isolated meanwhile */
 			if (unlikely(has_isolate_pageblock(zone)))
 				mt = get_pageblock_migratetype(page);
 
diff -puN mm/page_isolation.c~mm-page_isolation-remove-bogus-tests-for-isolated-pages mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-remove-bogus-tests-for-isolated-pages
+++ a/mm/page_isolation.c
@@ -223,34 +223,16 @@ __test_page_isolated_in_pageblock(unsign
 			continue;
 		}
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page)) {
+		if (PageBuddy(page))
 			/*
-			 * If race between isolatation and allocation happens,
-			 * some free pages could be in MIGRATE_MOVABLE list
-			 * although pageblock's migratation type of the page
-			 * is MIGRATE_ISOLATE. Catch it and move the page into
-			 * MIGRATE_ISOLATE list.
+			 * If the page is on a free list, it has to be on
+			 * the correct MIGRATE_ISOLATE freelist. There is no
+			 * simple way to verify that as VM_BUG_ON(), though.
 			 */
-			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
-				struct page *end_page;
-
-				end_page = page + (1 << page_order(page)) - 1;
-				move_freepages(page_zone(page), page, end_page,
-						MIGRATE_ISOLATE);
-			}
 			pfn += 1 << page_order(page);
-		}
-		else if (page_count(page) == 0 &&
-			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
-			pfn += 1;
-		else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
-			/*
-			 * The HWPoisoned page may be not in buddy
-			 * system, and page_count() is not 0.
-			 */
+		else if (skip_hwpoisoned_pages && PageHWPoison(page))
+			/* A HWPoisoned page cannot be also PageBuddy */
 			pfn++;
-			continue;
-		}
 		else
 			break;
 	}
_

Patches currently in -mm which might be from vbabka@suse.cz are


