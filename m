From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
 added to -mm tree
Date: Thu, 27 Feb 2014 13:21:04 -0800
Message-ID: <530fac40.TxuvfGBF6Vz9ClHe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaB0VVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 16:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 13:21:04 -0800


The patch titled
     Subject: mm, hugetlbfs: fix rmapping for anonymous hugepages with page_pgoff()
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -326,6 +326,19 @@ static inline loff_t page_file_offset(st
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
@@ -1875,7 +1875,7 @@ static void __split_huge_page(struct pag
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
@@ -764,6 +764,11 @@ pgoff_t __basepage_index(struct page *pa
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
@@ -408,7 +408,7 @@ static void collect_procs_anon(struct pa
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
-	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff = page_pgoff(page);
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
@@ -441,7 +441,7 @@ static void collect_procs_file(struct pa
 	mutex_lock(&mapping->i_mmap_mutex);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
-		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+		pgoff_t pgoff = page_pgoff(page);
 
 		if (!task_early_kill(tsk))
 			continue;
diff -puN mm/rmap.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff mm/rmap.c
--- a/mm/rmap.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff
+++ a/mm/rmap.c
@@ -515,11 +515,7 @@ void page_unlock_anon_vma_read(struct an
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
 
@@ -1588,7 +1584,7 @@ static struct anon_vma *rmap_walk_anon_l
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page_pgoff(page);
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch

