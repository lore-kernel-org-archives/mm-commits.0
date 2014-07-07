From: akpm@linux-foundation.org
Subject: + rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 12:39:40 -0700
Message-ID: <53baf77c.15nOi2OTkcEHM01L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:52367 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaGGTjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 15:39:41 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so1023085pdi.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 12:39:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, dhillf@gmail.com, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, nao.horiguchi@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap.c: fix pgoff calculation to handle hugepage correctly
has been added to the -mm tree.  Its filename is
     rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch

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
Subject: mm/rmap.c: fix pgoff calculation to handle hugepage correctly

I triggered VM_BUG_ON() in vma_address() when I try to migrate an
anonymous hugepage with mbind() in the kernel v3.16-rc3.  This is because
pgoff's calculation in rmap_walk_anon() fails to consider compound_order()
only to have an incorrect value.

This patch introduces page_to_pgoff(), which gets the page's offset in
PAGE_CACHE_SIZE.  Kirill pointed out that page cache tree should natively
handle hugepages, and in order to make hugetlbfs fit it, page->index of
hugetlbfs page should be in PAGE_CACHE_SIZE.  This is beyond this patch,
but page_to_pgoff() contains the point to be fixed in a single function.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++++++++++++
 mm/memory-failure.c     |    4 ++--
 mm/rmap.c               |   10 +++-------
 3 files changed, 17 insertions(+), 9 deletions(-)

diff -puN include/linux/pagemap.h~rmap-fix-pgoff-calculation-to-handle-hugepage-correctly include/linux/pagemap.h
--- a/include/linux/pagemap.h~rmap-fix-pgoff-calculation-to-handle-hugepage-correctly
+++ a/include/linux/pagemap.h
@@ -399,6 +399,18 @@ static inline struct page *read_mapping_
 }
 
 /*
+ * Get the offset in PAGE_SIZE.
+ * (TODO: hugepage should have ->index in PAGE_SIZE)
+ */
+static inline pgoff_t page_to_pgoff(struct page *page)
+{
+	if (unlikely(PageHeadHuge(page)))
+		return page->index << compound_order(page);
+	else
+		return page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+}
+
+/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
diff -puN mm/memory-failure.c~rmap-fix-pgoff-calculation-to-handle-hugepage-correctly mm/memory-failure.c
--- a/mm/memory-failure.c~rmap-fix-pgoff-calculation-to-handle-hugepage-correctly
+++ a/mm/memory-failure.c
@@ -435,7 +435,7 @@ static void collect_procs_anon(struct pa
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
-	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff = page_to_pgoff(page);
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
@@ -469,7 +469,7 @@ static void collect_procs_file(struct pa
 	mutex_lock(&mapping->i_mmap_mutex);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
-		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+		pgoff_t pgoff = page_to_pgoff(page);
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
 		if (!t)
diff -puN mm/rmap.c~rmap-fix-pgoff-calculation-to-handle-hugepage-correctly mm/rmap.c
--- a/mm/rmap.c~rmap-fix-pgoff-calculation-to-handle-hugepage-correctly
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
+	pgoff_t pgoff = page_to_pgoff(page);
 	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 }
 
@@ -1639,7 +1635,7 @@ static struct anon_vma *rmap_walk_anon_l
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page_to_pgoff(page);
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1680,7 +1676,7 @@ static int rmap_walk_anon(struct page *p
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << compound_order(page);
+	pgoff_t pgoff = page_to_pgoff(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
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

