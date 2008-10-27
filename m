From: akpm@linux-foundation.org
Subject: + hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:45:31 -0700
Message-ID: <200810272145.m9RLjWWe009792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYJ0Vq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:46:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, cl@linux-foundation.org, kniht@linux.vnet.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, stable@kernel.org


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

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: pull gigantic page initialisation out of the default path
From: Andy Whitcroft <apw@shadowen.org>

As we can determine exactly when a gigantic page is in use we can optimise
the common regular page cases by pulling out gigantic page initialisation
into its own function.  As gigantic pages are never released to buddy we
do not need a destructor.  This effectivly reverts the previous change to
the main buddy allocator.  It also adds a paranoid check to ensure we
never release gigantic pages from hugetlbfs to the main buddy.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c    |   12 +++++++++++-
 mm/internal.h   |    1 +
 mm/page_alloc.c |   28 +++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path
+++ a/mm/hugetlb.c
@@ -491,6 +491,8 @@ static void update_and_free_page(struct 
 {
 	int i;
 
+	VM_BUG_ON(h->order >= MAX_ORDER);
+
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
 	for (i = 0; i < pages_per_huge_page(h); i++) {
@@ -1005,6 +1007,14 @@ found:
 	return 1;
 }
 
+static void prep_compound_huge_page(struct page *page, int order)
+{
+	if (unlikely(order > (MAX_ORDER - 1)))
+		prep_compound_gigantic_page(page, order);
+	else
+		prep_compound_page(page, order);
+}
+
 /* Put bootmem huge pages into the standard lists after mem_map is up */
 static void __init gather_bootmem_prealloc(void)
 {
@@ -1015,7 +1025,7 @@ static void __init gather_bootmem_preall
 		struct hstate *h = m->hstate;
 		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
-		prep_compound_page(page, h->order);
+		prep_compound_huge_page(page, h->order);
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
@@ -263,24 +263,39 @@ void prep_compound_page(struct page *pag
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
+#ifdef CONFIG_HUGETLBFS
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
 }
+#endif
 
 static void destroy_compound_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
-	struct page *p = page + 1;
 
 	if (unlikely(compound_order(page) != order))
 		bad_page(page);
@@ -288,9 +303,8 @@ static void destroy_compound_page(struct
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

hugetlbfs-handle-pages-higher-order-than-max_order.patch
hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch
checkpatch-add-checks-for-in_atomic.patch
checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch
checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch
checkpatch-structure-member-assignments-are-not-complex.patch
checkpatch-__weak-is-an-official-attribute.patch
checkpatch-detect-multiple-bitfield-declarations.patch
checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch
checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch
checkpatch-version-025.patch

