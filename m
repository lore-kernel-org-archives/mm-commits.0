From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:47:16 -0700
Message-ID: <55f08cc4.3uOvM79fV+OSh5JN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbIITrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: always skip all compound pages by order in migrate scanner
has been removed from the -mm tree.  Its filename was
     mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: always skip all compound pages by order in migrate scanner

The compaction migrate scanner tries to skip THP pages by their order, to
reduce number of iterations for pages it cannot isolate.  The check is
only done if PageLRU() is true, which means it applies to THP pages, but
not e.g.  hugetlbfs pages or any other non-LRU compound pages, which we
have to iterate by base pages.

This limitation comes from the assumption that it's only safe to read
compound_order() when we have the zone's lru_lock and THP cannot be split
under us.  But the only danger (after filtering out order values that are
not below MAX_ORDER, to prevent overflows) is that we skip too much or too
little after reading a bogus compound_order() due to a rare race.  This is
the same reasoning as patch 99c0fd5e51c4 ("mm, compaction: skip buddy
pages by their order in the migrate scanner") introduced for unsafely
reading PageBuddy() order.

After this patch, all pages are tested for PageCompound() and we skip them
by compound_order().  The test is done after the test for
balloon_page_movable() as we don't want to assume if balloon pages (or
other pages with own isolation and migration implementation if a generic
API gets implemented) are compound or not.

When tested with stress-highalloc from mmtests on 4GB system with 1GB
hugetlbfs pages, the vmstat compact_migrate_scanned count decreased by
15%.

[kirill.shutemov@linux.intel.com: change PageTransHuge checks to PageCompound for different series was squashed here]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   47 ++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff -puN mm/compaction.c~mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner
+++ a/mm/compaction.c
@@ -680,6 +680,8 @@ isolate_migratepages_block(struct compac
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
+		bool is_lru;
+
 		/*
 		 * Periodically drop the lock (if held) regardless of its
 		 * contention, to give chance to IRQs. Abort async compaction
@@ -723,36 +725,35 @@ isolate_migratepages_block(struct compac
 		 * It's possible to migrate LRU pages and balloon pages
 		 * Skip any other type of page
 		 */
-		if (!PageLRU(page)) {
+		is_lru = PageLRU(page);
+		if (!is_lru) {
 			if (unlikely(balloon_page_movable(page))) {
 				if (balloon_page_isolate(page)) {
 					/* Successfully isolated */
 					goto isolate_success;
 				}
 			}
-			continue;
 		}
 
 		/*
-		 * PageLRU is set. lru_lock normally excludes isolation
-		 * splitting and collapsing (collapsing has already happened
-		 * if PageLRU is set) but the lock is not necessarily taken
-		 * here and it is wasteful to take it just to check transhuge.
-		 * Check TransHuge without lock and skip the whole pageblock if
-		 * it's either a transhuge or hugetlbfs page, as calling
-		 * compound_order() without preventing THP from splitting the
-		 * page underneath us may return surprising results.
+		 * Regardless of being on LRU, compound pages such as THP and
+		 * hugetlbfs are not to be compacted. We can potentially save
+		 * a lot of iterations if we skip them at once. The check is
+		 * racy, but we can consider only valid values and the only
+		 * danger is skipping too much.
 		 */
-		if (PageTransHuge(page)) {
-			if (!locked)
-				low_pfn = ALIGN(low_pfn + 1,
-						pageblock_nr_pages) - 1;
-			else
-				low_pfn += (1 << compound_order(page)) - 1;
+		if (PageCompound(page)) {
+			unsigned int comp_order = compound_order(page);
+
+			if (likely(comp_order < MAX_ORDER))
+				low_pfn += (1UL << comp_order) - 1;
 
 			continue;
 		}
 
+		if (!is_lru)
+			continue;
+
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
@@ -769,11 +770,17 @@ isolate_migratepages_block(struct compac
 			if (!locked)
 				break;
 
-			/* Recheck PageLRU and PageTransHuge under lock */
+			/* Recheck PageLRU and PageCompound under lock */
 			if (!PageLRU(page))
 				continue;
-			if (PageTransHuge(page)) {
-				low_pfn += (1 << compound_order(page)) - 1;
+
+			/*
+			 * Page become compound since the non-locked check,
+			 * and it's on LRU. It can only be a THP so the order
+			 * is safe to read and it's 0 for tail pages.
+			 */
+			if (unlikely(PageCompound(page))) {
+				low_pfn += (1UL << compound_order(page)) - 1;
 				continue;
 			}
 		}
@@ -784,7 +791,7 @@ isolate_migratepages_block(struct compac
 		if (__isolate_lru_page(page, isolate_mode) != 0)
 			continue;
 
-		VM_BUG_ON_PAGE(PageTransCompound(page), page);
+		VM_BUG_ON_PAGE(PageCompound(page), page);
 
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
_

Patches currently in -mm which might be from vbabka@suse.cz are


