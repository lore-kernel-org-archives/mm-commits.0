From: akpm@linux-foundation.org
Subject: + mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
 added to -mm tree
Date: Tue, 21 Jul 2015 14:55:16 -0700
Message-ID: <55aebfc4.PeX65VZpMPYwju65%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbbGUVzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 17:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_isolation: remove bogus tests for isolated pages
has been added to the -mm tree.  Its filename is
     mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch

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
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Seungho Park <seungho1.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

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

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
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

