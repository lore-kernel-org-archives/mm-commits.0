From: akpm@linux-foundation.org
Subject: +
 mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
 added to -mm tree
Date: Fri, 07 Aug 2015 16:16:12 -0700
Message-ID: <55c53c3c.JEq7/1vl8JJVP65/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946357AbbHGXQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 19:16:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: always skip all compound pages by order in migrate scanner
has been added to the -mm tree.  Its filename is
     mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-dont-wait-for-high-order-page-allocation-v2.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-vmscan-never-isolate-more-pages-than-necessary.patch
vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
linux-next.patch

