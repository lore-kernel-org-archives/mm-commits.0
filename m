From: akpm@linux-foundation.org
Subject: + hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch added to -mm tree
Date: Fri, 10 Oct 2008 14:52:42 -0700
Message-ID: <200810102152.m9ALqgqc006888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757324AbYJJVxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 17:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     hugetlb: pull gigantic page initialisation out of the default path
has been added to the -mm tree.  Its filename is
     hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: pull gigantic page initialisation out of the default path
From: Andy Whitcroft <apw@shadowen.org>

As we can determine exactly when a gigantic page is in use we can optimise
the common regular page cases by pulling out gigantic page initialisation
into its own function.  As gigantic pages are never released to buddy we
do not need a destructor.  This effectivly reverts the previous change
to the main buddy allocator.  It also adds a paranoid check to ensure we
never release gigantic pages from hugetlbfs to the main buddy.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c    |    4 +++-
 mm/internal.h   |    1 +
 mm/page_alloc.c |   26 +++++++++++++++++++-------
 3 files changed, 23 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path
+++ a/mm/hugetlb.c
@@ -455,6 +455,8 @@ static void update_and_free_page(struct 
 {
 	int i;
 
+	BUG_ON(h->order >= MAX_ORDER);
+
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
 	for (i = 0; i < pages_per_huge_page(h); i++) {
@@ -979,7 +981,7 @@ static void __init gather_bootmem_preall
 		struct hstate *h = m->hstate;
 		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
-		prep_compound_page(page, h->order);
+		prep_compound_gigantic_page(page, h->order);
 		prep_new_huge_page(h, page, page_to_nid(page));
 	}
 }
diff -puN mm/internal.h~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path mm/internal.h
--- a/mm/internal.h~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path
+++ a/mm/internal.h
@@ -17,6 +17,7 @@ void free_pgtables(struct mmu_gather *tl
 		unsigned long floor, unsigned long ceiling);
 
 extern void prep_compound_page(struct page *page, unsigned long order);
+extern void prep_compound_gigantic_page(struct page *page, unsigned long order);
 
 static inline void set_page_count(struct page *page, int v)
 {
diff -puN mm/page_alloc.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path mm/page_alloc.c
--- a/mm/page_alloc.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path
+++ a/mm/page_alloc.c
@@ -268,14 +268,28 @@ void prep_compound_page(struct page *pag
 {
 	int i;
 	int nr_pages = 1 << order;
+
+	set_compound_page_dtor(page, free_compound_page);
+	set_compound_order(page, order);
+	__SetPageHead(page);
+	for (i = 1; i < nr_pages; i++) {
+		struct page *p = page + i;
+
+		__SetPageTail(p);
+		p->first_page = page;
+	}
+}
+
+void prep_compound_gigantic_page(struct page *page, unsigned long order)
+{
+	int i;
+	int nr_pages = 1 << order;
 	struct page *p = page + 1;
 
 	set_compound_page_dtor(page, free_compound_page);
 	set_compound_order(page, order);
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++, p++) {
-		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
-			p = pfn_to_page(page_to_pfn(page) + i);
+	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		__SetPageTail(p);
 		p->first_page = page;
 	}
@@ -285,7 +299,6 @@ static void destroy_compound_page(struct
 {
 	int i;
 	int nr_pages = 1 << order;
-	struct page *p = page + 1;
 
 	if (unlikely(compound_order(page) != order))
 		bad_page(page);
@@ -293,9 +306,8 @@ static void destroy_compound_page(struct
 	if (unlikely(!PageHead(page)))
 			bad_page(page);
 	__ClearPageHead(page);
-	for (i = 1; i < nr_pages; i++, p++) {
-		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
-			p = pfn_to_page(page_to_pfn(page) + i);
+	for (i = 1; i < nr_pages; i++) {
+		struct page *p = page + i;
 
 		if (unlikely(!PageTail(p) |
 				(p->first_page != page)))
_

Patches currently in -mm which might be from apw@shadowen.org are

mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch
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
checkpatch-do-is-not-a-possible-type.patch
checkpatch-labels-are-not-possible-types.patch
checkpatch-handle-do-without-braces-if-we-have-enough-context.patch
checkpatch-macros-which-define-structure-members-are-not-complex.patch
checkpatch-accept-any-sized-le-be-type.patch
checkpatch-pull-out-known-acceptable-typedefs.patch
checkpatch-suspect-code-indent-must-stop-at-else-elif.patch
checkpatch-complex-macros-checks-miss-square-brackets.patch
checkpatch-define_-macros-are-real-definitions-for-exports.patch
checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line.patch
checkpatch-suspect-indent-handle-macro-continuation.patch
checkpatch-allow-for-comments-either-side-of-a-brace-on-case.patch
checkpatch-version-024.patch
page-owner-tracking-leak-detector.patch

