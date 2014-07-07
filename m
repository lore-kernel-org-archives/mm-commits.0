From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 12:59:56 -0700
Message-ID: <53bafc3c.GDT46gD3NgEiNBez%akpm__26820.6612942324$1404763225$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:37646 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaGGT77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 15:59:59 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so1028085pdi.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 12:59:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, riel@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlbfs: fix rmapping for anonymous hugepages with page_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm, hugetlbfs: fix rmapping for anonymous hugepages with page_pgoff()

page->index stores pagecache index when the page is mapped into file
mapping region, and the index is in pagecache size unit, so it depends on
the page size.  Some of users of reverse mapping obviously assumes that
page->index is in PAGE_CACHE_SHIFT unit, so they don't work for anonymous
hugepage.

For example, consider that we have 3-hugepage vma and try to mbind the 2nd
hugepage to migrate to another node.  Then the vma is split and
migrate_page() is called for the 2nd hugepage (belonging to the middle
vma.) In migrate operation, rmap_walk_anon() tries to find the relevant
vma to which the target hugepage belongs, but here we miscalculate pgoff. 
So anon_vma_interval_tree_foreach() grabs invalid vma, which fires
VM_BUG_ON.

This patch introduces a new API that is usable both for normal page and
hugepage to get PAGE_SIZE offset from page->index.  Users should clearly
distinguish page_index for pagecache index and page_pgoff for page offset.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   13 +++++++++++++
 mm/huge_memory.c        |    2 +-
 mm/hugetlb.c            |    5 +++++
 mm/memory-failure.c     |    4 ++--
 mm/rmap.c               |    8 ++------
 5 files changed, 23 insertions(+), 9 deletions(-)

diff -puN include/linux/pagemap.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff
+++ a/include/linux/pagemap.h
@@ -411,6 +411,19 @@ static inline loff_t page_file_offset(st
 	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
 }
 
+extern pgoff_t hugepage_pgoff(struct page *page);
+
+/*
+ * page->index stores pagecache index whose unit is not always PAGE_SIZE.
+ * This function converts it into PAGE_SIZE offset.
+ */
+#define page_pgoff(page)					\
+({								\
+	unlikely(PageHuge(page)) ?				\
+		hugepage_pgoff(page) :				\
+		page->index >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);	\
+})
+
 extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
 				     unsigned long address);
 
diff -puN mm/huge_memory.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff mm/huge_memory.c
--- a/mm/huge_memory.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff
+++ a/mm/huge_memory.c
@@ -1838,7 +1838,7 @@ static void __split_huge_page(struct pag
 			      struct list_head *list)
 {
 	int mapcount, mapcount2;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page_pgoff(page);
 	struct anon_vma_chain *avc;
 
 	BUG_ON(!PageHead(page));
diff -puN mm/hugetlb.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff
+++ a/mm/hugetlb.c
@@ -981,6 +981,11 @@ pgoff_t __basepage_index(struct page *pa
 	return (index << compound_order(page_head)) + compound_idx;
 }
 
+pgoff_t hugepage_pgoff(struct page *page)
+{
+	return page->index << huge_page_order(page_hstate(page));
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
diff -puN mm/memory-failure.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff
+++ a/mm/memory-failure.c
@@ -435,7 +435,7 @@ static void collect_procs_anon(struct pa
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
-	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff = page_pgoff(page);
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
@@ -469,7 +469,7 @@ static void collect_procs_file(struct pa
 	mutex_lock(&mapping->i_mmap_mutex);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
-		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+		pgoff_t pgoff = page_pgoff(page);
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
 		if (!t)
diff -puN mm/rmap.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff mm/rmap.c
--- a/mm/rmap.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff
+++ a/mm/rmap.c
@@ -517,11 +517,7 @@ void page_unlock_anon_vma_read(struct an
 static inline unsigned long
 __vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-
-	if (unlikely(is_vm_hugetlb_page(vma)))
-		pgoff = page->index << huge_page_order(page_hstate(page));
-
+	pgoff_t pgoff = page_pgoff(page);
 	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 }
 
@@ -1639,7 +1635,7 @@ static struct anon_vma *rmap_walk_anon_l
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page_pgoff(page);
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

