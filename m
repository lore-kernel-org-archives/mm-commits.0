From: akpm@linux-foundation.org
Subject: +
 page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch added to -mm tree
Date: Tue, 28 Apr 2015 16:17:42 -0700
Message-ID: <55401516.o8qZg65qtPreZhHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031051AbbD1XRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 19:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mel@csn.ul.ie, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,compaction: fix isolate_migratepages_block() for THP=n
has been added to the -mm tree.  Its filename is
     page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm,compaction: fix isolate_migratepages_block() for THP=n

PageTrans* helpers are always false if THP is disabled at compile-time. 
It means isolate_migratepages_block() will fail to detect hugetlb pages in
this case.

Let's use PageCompound() instead.  With a small tweak to how we calculate
next low_pfn it will make isolate_migratepages_block() ready to see tail
pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix mm/compaction.c
--- a/mm/compaction.c~page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix
+++ a/mm/compaction.c
@@ -732,18 +732,18 @@ isolate_migratepages_block(struct compac
 		 * splitting and collapsing (collapsing has already happened
 		 * if PageLRU is set) but the lock is not necessarily taken
 		 * here and it is wasteful to take it just to check transhuge.
-		 * Check TransHuge without lock and skip the whole pageblock if
-		 * it's either a transhuge or hugetlbfs page, as calling
+		 * Check PageCompound without lock and skip the whole pageblock
+		 * if it's either a transhuge or hugetlbfs page, as calling
 		 * compound_order() without preventing THP from splitting the
 		 * page underneath us may return surprising results.
 		 */
-		if (PageTransHuge(page)) {
-			if (!locked)
-				low_pfn = ALIGN(low_pfn + 1,
-						pageblock_nr_pages) - 1;
+		if (PageCompound(page)) {
+			int nr;
+			if (locked)
+				nr = 1 << compound_order(page);
 			else
-				low_pfn += (1 << compound_order(page)) - 1;
-
+				nr = pageblock_nr_pages;
+			low_pfn = ALIGN(low_pfn + 1, nr) - 1;
 			continue;
 		}
 
@@ -763,11 +763,12 @@ isolate_migratepages_block(struct compac
 			if (!locked)
 				break;
 
-			/* Recheck PageLRU and PageTransHuge under lock */
+			/* Recheck PageLRU and PageCompound under lock */
 			if (!PageLRU(page))
 				continue;
-			if (PageTransHuge(page)) {
-				low_pfn += (1 << compound_order(page)) - 1;
+			if (PageCompound(page)) {
+				int nr = 1 << compound_order(page);
+				low_pfn = ALIGN(low_pfn + 1, nr) - 1;
 				continue;
 			}
 		}
@@ -778,7 +779,7 @@ isolate_migratepages_block(struct compac
 		if (__isolate_lru_page(page, isolate_mode) != 0)
 			continue;
 
-		VM_BUG_ON_PAGE(PageTransCompound(page), page);
+		VM_BUG_ON_PAGE(PageCompound(page), page);
 
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch

