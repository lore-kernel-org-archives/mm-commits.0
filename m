From: akpm@linux-foundation.org
Subject: - mm-handle-initialising-compound-pages-at-orders-greater-than-max_order.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:28:58 -0700
Message-ID: <200810032128.m93LSwD5016650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbYJCV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, kniht@linux.vnet.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: handle initialising compound pages at orders greater than MAX_ORDER
has been removed from the -mm tree.  Its filename was
     mm-handle-initialising-compound-pages-at-orders-greater-than-max_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: handle initialising compound pages at orders greater than MAX_ORDER
From: Andy Whitcroft <apw@shadowen.org>

When we initialise a compound page we initialise the page flags and head
page pointer for all base pages spanned by that page.  When we initialise
a gigantic page (a page of order greater than or equal to MAX_ORDER) we
have to initialise more than MAX_ORDER_NR_PAGES pages.  Currently we
assume that all elements of the mem_map in this page are contigious in
memory.  However this is only guarenteed out to MAX_ORDER_NR_PAGES pages,
and with SPARSEMEM enabled they will not be contigious.  This leads us to
walk off the end of the first section and scribble on everything which
follows, BAD.

When we reach a MAX_ORDER_NR_PAGES boundary we much locate the next
section of the mem_map.  As gigantic pages can only be maximally aligned
we know this will occur at exact multiple of MAX_ORDER_NR_PAGES pages from
the start of the page.

This is a bug fix for the gigantic page support in hugetlbfs.

Credit to Mel Gorman for spotting the issue.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-handle-initialising-compound-pages-at-orders-greater-than-max_order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-handle-initialising-compound-pages-at-orders-greater-than-max_order
+++ a/mm/page_alloc.c
@@ -268,13 +268,14 @@ void prep_compound_page(struct page *pag
 {
 	int i;
 	int nr_pages = 1 << order;
+	struct page *p = page + 1;
 
 	set_compound_page_dtor(page, free_compound_page);
 	set_compound_order(page, order);
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
-
+	for (i = 1; i < nr_pages; i++, p++) {
+		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
+			p = pfn_to_page(page_to_pfn(page) + i);
 		__SetPageTail(p);
 		p->first_page = page;
 	}
@@ -284,6 +285,7 @@ static void destroy_compound_page(struct
 {
 	int i;
 	int nr_pages = 1 << order;
+	struct page *p = page + 1;
 
 	if (unlikely(compound_order(page) != order))
 		bad_page(page);
@@ -291,8 +293,9 @@ static void destroy_compound_page(struct
 	if (unlikely(!PageHead(page)))
 			bad_page(page);
 	__ClearPageHead(page);
-	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
+	for (i = 1; i < nr_pages; i++, p++) {
+		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
+			p = pfn_to_page(page_to_pfn(page) + i);
 
 		if (unlikely(!PageTail(p) |
 				(p->first_page != page)))
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
checkpatch-values-double-ampersand-may-be-unary.patch
checkpatch-conditional-indent-labels-have-different-indent-rules.patch
checkpatch-switch-indent-allow-plain-return.patch
checkpatch-add-tests-for-the-attribute-matcher.patch
checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
checkpatch-complex-macros-fix-up-extension-handling.patch
checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
checkpatch-include-asm-checks-should-be-anchored.patch
checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
checkpatch-report-any-absolute-references-to-kernel-source-files.patch
checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
checkpatch-perform-indent-checks-on-perl.patch
checkpatch-version-022.patch
checkpatch-case-default-checks-should-only-check-changed-lines.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
checkpatch-handle-comment-quote-nesting-correctly.patch
checkpatch-check-line-endings-in-text-format-files.patch
checkpatch-suspect-indent-count-condition-lines-correctly.patch
checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks.patch
checkpatch-version-023.patch
page-owner-tracking-leak-detector.patch

