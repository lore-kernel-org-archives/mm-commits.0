From: akpm@linux-foundation.org
Subject: [wrecked]
 mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 13:01:15 -0700
Message-ID: <53bafc8b.tGRRCQkyfdQ1HaXw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:54522 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaGGUBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:01:16 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so1031606pdi.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:01:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, riel@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3

- add comment on page_size_order()
- use compound_order(compound_head(page)) instead of huge_page_size_order()
- use page_pgoff() in rmap_walk_file() too
- use page_size_order() in kill_proc()
- fix space indent

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_inline.h |    6 ------
 include/linux/pagemap.h        |   16 ++++++++++++++--
 mm/hugetlb.c                   |    5 -----
 mm/memory-failure.c            |    2 +-
 mm/rmap.c                      |    2 +-
 5 files changed, 16 insertions(+), 15 deletions(-)

diff -puN include/linux/hugetlb_inline.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3 include/linux/hugetlb_inline.h
--- a/include/linux/hugetlb_inline.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3
+++ a/include/linux/hugetlb_inline.h
@@ -11,7 +11,6 @@ static inline int is_vm_hugetlb_page(str
 }
 
 int PageHuge(struct page *page);
-unsigned int huge_page_size_order(struct page *page);
 
 #else
 
@@ -24,11 +23,6 @@ static inline int PageHuge(struct page *
 {
 	return 0;
 }
-
-static inline unsigned int huge_page_size_order(struct page *page)
-{
-	return 0;
-}
 
 #endif
 
diff -puN include/linux/pagemap.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3 include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3
+++ a/include/linux/pagemap.h
@@ -411,10 +411,22 @@ static inline loff_t page_file_offset(st
 	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
 }
 
+/*
+ * Getting page order of a given page in the context of the pagecache which
+ * each page belongs to.
+ *
+ * Pagecache unit size is not a fixed value (hugetlbfs is an example), but
+ * vma_interval_tree and anon_vma_internval_tree APIs assume that its indices
+ * are in PAGE_SIZE unit. So this routine helps us to get normalized indices.
+ *
+ * This page should be called only for pagecache pages/hugepages and anonymous
+ * pages/hugepages, because pagecache unit size is irrelevant except for those
+ * pages.
+ */
 static inline unsigned int page_size_order(struct page *page)
 {
 	return unlikely(PageHuge(page)) ?
-		huge_page_size_order(page) :
+		compound_order(compound_head(page)) :
 		(PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
@@ -424,7 +436,7 @@ static inline unsigned int page_size_ord
  */
 static inline pgoff_t page_pgoff(struct page *page)
 {
-        return page->index << page_size_order(page);
+	return page->index << page_size_order(page);
 }
 
 extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
diff -puN mm/hugetlb.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3
+++ a/mm/hugetlb.c
@@ -982,11 +982,6 @@ pgoff_t __basepage_index(struct page *pa
 	return (index << compound_order(page_head)) + compound_idx;
 }
 
-unsigned int huge_page_size_order(struct page *page)
-{
-	return huge_page_order(page_hstate(page));
-}
-
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
diff -puN mm/memory-failure.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3
+++ a/mm/memory-failure.c
@@ -202,7 +202,7 @@ static int kill_proc(struct task_struct
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
-	si.si_addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
+	si.si_addr_lsb = page_size_order(page) + PAGE_SHIFT;
 
 	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
 		si.si_code = BUS_MCEERR_AR;
diff -puN mm/rmap.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3 mm/rmap.c
--- a/mm/rmap.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3
+++ a/mm/rmap.c
@@ -1676,7 +1676,7 @@ static int rmap_walk_anon(struct page *p
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << compound_order(page);
+	pgoff_t pgoff = page_pgoff(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

