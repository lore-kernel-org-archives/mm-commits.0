From: akpm@linux-foundation.org
Subject: + hugetlbfs-handle-pages-higher-order-than-max_order.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:45:28 -0700
Message-ID: <200810272145.m9RLjSxO009756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYJ0VqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, cl@linux-foundation.org, kniht@linux.vnet.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, stable@kernel.org


The patch titled
     hugetlbfs: handle pages higher order than MAX_ORDER
has been added to the -mm tree.  Its filename is
     hugetlbfs-handle-pages-higher-order-than-max_order.patch

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
Subject: hugetlbfs: handle pages higher order than MAX_ORDER
From: Andy Whitcroft <apw@shadowen.org>

When working with hugepages, hugetlbfs assumes that those hugepages are
smaller than MAX_ORDER.  Specifically it assumes that the mem_map is
contigious and uses that to optimise access to the elements of the mem_map
that represent the hugepage.  Gigantic pages (such as 16GB pages on
powerpc) by definition are of greater order than MAX_ORDER (larger than
MAX_ORDER_NR_PAGES in size).  This means that we can no longer make use of
the buddy alloctor guarentees for the contiguity of the mem_map, which
ensures that the mem_map is at least contigious for maximmally aligned
areas of MAX_ORDER_NR_PAGES pages.

This patch adds new mem_map accessors and iterator helpers which handle
any discontiguity at MAX_ORDER_NR_PAGES boundaries.  It then uses these to
implement gigantic page versions of copy_huge_page and clear_huge_page,
and to allow follow_hugetlb_page handle gigantic pages.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |   37 ++++++++++++++++++++++++++++++++++++-
 mm/internal.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlbfs-handle-pages-higher-order-than-max_order mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-handle-pages-higher-order-than-max_order
+++ a/mm/hugetlb.c
@@ -354,11 +354,26 @@ static int vma_has_reserves(struct vm_ar
 	return 0;
 }
 
+static void clear_gigantic_page(struct page *page,
+			unsigned long addr, unsigned long sz)
+{
+	int i;
+	struct page *p = page;
+
+	might_sleep();
+	for (i = 0; i < sz/PAGE_SIZE; i++, p = mem_map_next(p, page, i)) {
+		cond_resched();
+		clear_user_highpage(p, addr + i * PAGE_SIZE);
+	}
+}
 static void clear_huge_page(struct page *page,
 			unsigned long addr, unsigned long sz)
 {
 	int i;
 
+	if (unlikely(sz > MAX_ORDER_NR_PAGES))
+		return clear_gigantic_page(page, addr, sz);
+
 	might_sleep();
 	for (i = 0; i < sz/PAGE_SIZE; i++) {
 		cond_resched();
@@ -366,12 +381,32 @@ static void clear_huge_page(struct page 
 	}
 }
 
+static void copy_gigantic_page(struct page *dst, struct page *src,
+			   unsigned long addr, struct vm_area_struct *vma)
+{
+	int i;
+	struct hstate *h = hstate_vma(vma);
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page(h); ) {
+		cond_resched();
+		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
 static void copy_huge_page(struct page *dst, struct page *src,
 			   unsigned long addr, struct vm_area_struct *vma)
 {
 	int i;
 	struct hstate *h = hstate_vma(vma);
 
+	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES))
+		return copy_gigantic_page(dst, src, addr, vma);
+
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		cond_resched();
@@ -2130,7 +2165,7 @@ same_page:
 			if (zeropage_ok)
 				pages[i] = ZERO_PAGE(0);
 			else
-				pages[i] = page + pfn_offset;
+				pages[i] = mem_map_offset(page, pfn_offset);
 			get_page(pages[i]);
 		}
 
diff -puN mm/internal.h~hugetlbfs-handle-pages-higher-order-than-max_order mm/internal.h
--- a/mm/internal.h~hugetlbfs-handle-pages-higher-order-than-max_order
+++ a/mm/internal.h
@@ -176,6 +176,34 @@ static inline void free_page_mlock(struc
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 /*
+ * Return the mem_map entry representing the 'offset' subpage within
+ * the maximally aligned gigantic page 'base'.  Handle any discontiguity
+ * in the mem_map at MAX_ORDER_NR_PAGES boundaries.
+ */
+static inline struct page *mem_map_offset(struct page *base, int offset)
+{
+	if (unlikely(offset >= MAX_ORDER_NR_PAGES))
+		return pfn_to_page(page_to_pfn(base) + offset);
+	return base + offset;
+}
+
+/*
+ * Iterator over all subpages withing the maximally aligned gigantic
+ * page 'base'.  Handle any discontiguity in the mem_map.
+ */
+static inline struct page *mem_map_next(struct page *iter,
+						struct page *base, int offset)
+{
+	if (unlikely((offset & (MAX_ORDER_NR_PAGES - 1)) == 0)) {
+		unsigned long pfn = page_to_pfn(base) + offset;
+		if (!pfn_valid(pfn))
+			return NULL;
+		return pfn_to_page(pfn);
+	}
+	return iter + 1;
+}
+
+/*
  * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
  * so all functions starting at paging_init should be marked __init
  * in those cases. SPARSEMEM, however, allows for memory hotplug,
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

