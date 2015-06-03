From: akpm@linux-foundation.org
Subject: +
 page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch added to -mm tree
Date: Wed, 03 Jun 2015 16:06:58 -0700
Message-ID: <556f8892.Hbf3K25m8XdNoX3S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbFCXG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2015 19:06:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, kirill@shutemov.name, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix
has been added to the -mm tree.  Its filename is
     page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch

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
@@ -733,9 +733,12 @@ isolate_migratepages_block(struct compac
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
@@ -743,7 +746,7 @@ isolate_migratepages_block(struct compac
 				nr = 1 << compound_order(page);
 			else
 				nr = pageblock_nr_pages;
-			low_pfn = ALIGN(low_pfn + 1, nr) - 1;
+			low_pfn += nr - 1;
 			continue;
 		}
 
@@ -768,7 +771,7 @@ isolate_migratepages_block(struct compac
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

mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
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
linux-next.patch

