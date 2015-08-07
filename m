From: akpm@linux-foundation.org
Subject: [alternative-merged]
 page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch removed from -mm tree
Date: Fri, 07 Aug 2015 16:15:48 -0700
Message-ID: <55c53c24.ryhSbkT3kuS2HzfJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946357AbbHGXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, kirill@shutemov.name, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix
has been removed from the -mm tree.  Its filename was
     page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix

Mentioning hugetlbfs is misleading, because PageLRU() checks skip over
hugetlb pages.  The ALIGN() parts are useless, because
compound_order(page) returns 0 for tail pages.

Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix mm/compaction.c
--- a/mm/compaction.c~page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix
+++ a/mm/compaction.c
@@ -764,9 +764,12 @@ isolate_migratepages_block(struct compac
 		 * if PageLRU is set) but the lock is not necessarily taken
 		 * here and it is wasteful to take it just to check transhuge.
 		 * Check PageCompound without lock and skip the whole pageblock
-		 * if it's either a transhuge or hugetlbfs page, as calling
-		 * compound_order() without preventing THP from splitting the
-		 * page underneath us may return surprising results.
+		 * if it's a transhuge page, as calling compound_order()
+		 * without preventing THP from splitting the page underneath us
+		 * may return surprising results.
+		 * If we happen to check a THP tail page, compound_order()
+		 * returns 0. It should be rare enough to not bother with
+		 * using compound_head() in that case.
 		 */
 		if (PageCompound(page)) {
 			int nr;
@@ -774,7 +777,7 @@ isolate_migratepages_block(struct compac
 				nr = 1 << compound_order(page);
 			else
 				nr = pageblock_nr_pages;
-			low_pfn = ALIGN(low_pfn + 1, nr) - 1;
+			low_pfn += nr - 1;
 			continue;
 		}
 
@@ -799,7 +802,7 @@ isolate_migratepages_block(struct compac
 				continue;
 			if (PageCompound(page)) {
 				int nr = 1 << compound_order(page);
-				low_pfn = ALIGN(low_pfn + 1, nr) - 1;
+				low_pfn += nr - 1;
 				continue;
 			}
 		}
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

