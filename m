From: akpm@linux-foundation.org
Subject: + mm-refactor-page-index-offset-getters.patch added to -mm tree
Date: Wed, 23 Jul 2014 14:39:24 -0700
Message-ID: <53d02b8c.cl6r5TldWbRhzJ/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:41103 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbaGWVj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 17:39:26 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so535646ieb.0
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 14:39:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, hughd@google.com, mel@csn.ul.ie, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor page index/offset getters
has been added to the -mm tree.  Its filename is
     mm-refactor-page-index-offset-getters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-page-index-offset-getters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-page-index-offset-getters.patch

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
Subject: mm: refactor page index/offset getters

There is a complaint about duplication around the fundamental routines of
page index/offset getters.

page_(index|offset) and page_file_(index|offset) provide the same
functionality, so we can merge them as page_(index|offset), respectively.

And this patch gives the clear meaning to the getters:
 - page_index(): get page cache index (offset in relevant page size)
 - page_pgoff(): get 4kB page offset
 - page_offset(): get byte offset
All these functions are aware of regular pages, swapcaches, and hugepages.

The definition of PageHuge is relocated to include/linux/mm.h, because
some users of page_pgoff() doesn't include include/linux/hugetlb.h.

__page_file_index() is not well named, because it's only for swap cache.
So let's rename it with __page_swap_index().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/internal.h       |    6 +++---
 fs/nfs/pagelist.c       |    2 +-
 fs/nfs/read.c           |    2 +-
 fs/nfs/write.c          |   10 +++++-----
 fs/xfs/xfs_aops.c       |    2 +-
 include/linux/hugetlb.h |    7 -------
 include/linux/mm.h      |   26 ++++++++++----------------
 include/linux/pagemap.h |   22 +++++++++-------------
 mm/memory-failure.c     |    4 ++--
 mm/page_io.c            |    6 +++---
 mm/rmap.c               |    6 +++---
 mm/swapfile.c           |    4 ++--
 12 files changed, 40 insertions(+), 57 deletions(-)

diff -puN fs/nfs/internal.h~mm-refactor-page-index-offset-getters fs/nfs/internal.h
--- a/fs/nfs/internal.h~mm-refactor-page-index-offset-getters
+++ a/fs/nfs/internal.h
@@ -566,11 +566,11 @@ unsigned int nfs_page_length(struct page
 	loff_t i_size = i_size_read(page_file_mapping(page)->host);
 
 	if (i_size > 0) {
-		pgoff_t page_index = page_file_index(page);
+		pgoff_t index = page_index(page);
 		pgoff_t end_index = (i_size - 1) >> PAGE_CACHE_SHIFT;
-		if (page_index < end_index)
+		if (index < end_index)
 			return PAGE_CACHE_SIZE;
-		if (page_index == end_index)
+		if (index == end_index)
 			return ((i_size - 1) & ~PAGE_CACHE_MASK) + 1;
 	}
 	return 0;
diff -puN fs/nfs/pagelist.c~mm-refactor-page-index-offset-getters fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~mm-refactor-page-index-offset-getters
+++ a/fs/nfs/pagelist.c
@@ -333,7 +333,7 @@ nfs_create_request(struct nfs_open_conte
 	 * long write-back delay. This will be adjusted in
 	 * update_nfs_request below if the region is not locked. */
 	req->wb_page    = page;
-	req->wb_index	= page_file_index(page);
+	req->wb_index	= page_index(page);
 	page_cache_get(page);
 	req->wb_offset  = offset;
 	req->wb_pgbase	= offset;
diff -puN fs/nfs/read.c~mm-refactor-page-index-offset-getters fs/nfs/read.c
--- a/fs/nfs/read.c~mm-refactor-page-index-offset-getters
+++ a/fs/nfs/read.c
@@ -271,7 +271,7 @@ int nfs_readpage(struct file *file, stru
 	int		error;
 
 	dprintk("NFS: nfs_readpage (%p %ld@%lu)\n",
-		page, PAGE_CACHE_SIZE, page_file_index(page));
+		page, PAGE_CACHE_SIZE, page_index(page));
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGE);
 	nfs_add_stats(inode, NFSIOS_READPAGES, 1);
 
diff -puN fs/nfs/write.c~mm-refactor-page-index-offset-getters fs/nfs/write.c
--- a/fs/nfs/write.c~mm-refactor-page-index-offset-getters
+++ a/fs/nfs/write.c
@@ -153,9 +153,9 @@ static void nfs_grow_file(struct page *p
 	spin_lock(&inode->i_lock);
 	i_size = i_size_read(inode);
 	end_index = (i_size - 1) >> PAGE_CACHE_SHIFT;
-	if (i_size > 0 && page_file_index(page) < end_index)
+	if (i_size > 0 && page_index(page) < end_index)
 		goto out;
-	end = page_file_offset(page) + ((loff_t)offset+count);
+	end = page_offset(page) + ((loff_t)offset+count);
 	if (i_size >= end)
 		goto out;
 	i_size_write(inode, end);
@@ -569,7 +569,7 @@ static int nfs_do_writepage(struct page
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
 	nfs_add_stats(inode, NFSIOS_WRITEPAGES, 1);
 
-	nfs_pageio_cond_complete(pgio, page_file_index(page));
+	nfs_pageio_cond_complete(pgio, page_index(page));
 	ret = nfs_page_async_flush(pgio, page, wbc->sync_mode == WB_SYNC_NONE);
 	if (ret == -EAGAIN) {
 		redirty_page_for_writepage(wbc, page);
@@ -1212,7 +1212,7 @@ int nfs_updatepage(struct file *file, st
 	nfs_inc_stats(inode, NFSIOS_VFSUPDATEPAGE);
 
 	dprintk("NFS:       nfs_updatepage(%pD2 %d@%lld)\n",
-		file, count, (long long)(page_file_offset(page) + offset));
+		file, count, (long long)(page_offset(page) + offset));
 
 	if (nfs_can_extend_write(file, page, inode)) {
 		count = max(count + offset, nfs_page_length(page));
@@ -1827,7 +1827,7 @@ int nfs_wb_page_cancel(struct inode *ino
  */
 int nfs_wb_page(struct inode *inode, struct page *page)
 {
-	loff_t range_start = page_file_offset(page);
+	loff_t range_start = page_offset(page);
 	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
diff -puN fs/xfs/xfs_aops.c~mm-refactor-page-index-offset-getters fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~mm-refactor-page-index-offset-getters
+++ a/fs/xfs/xfs_aops.c
@@ -695,7 +695,7 @@ xfs_convert_page(
 	unsigned int		type;
 	int			len, page_dirty;
 	int			count = 0, done = 0, uptodate = 1;
- 	xfs_off_t		offset = page_offset(page);
+	xfs_off_t		offset = page_offset(page);
 
 	if (page->index != tindex)
 		goto fail;
diff -puN include/linux/hugetlb.h~mm-refactor-page-index-offset-getters include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-refactor-page-index-offset-getters
+++ a/include/linux/hugetlb.h
@@ -41,8 +41,6 @@ extern int hugetlb_max_hstate __read_mos
 struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
-int PageHuge(struct page *page);
-
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
@@ -108,11 +106,6 @@ unsigned long hugetlb_change_protection(
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
-static inline int PageHuge(struct page *page)
-{
-	return 0;
-}
-
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
diff -puN include/linux/mm.h~mm-refactor-page-index-offset-getters include/linux/mm.h
--- a/include/linux/mm.h~mm-refactor-page-index-offset-getters
+++ a/include/linux/mm.h
@@ -456,8 +456,13 @@ static inline int page_count(struct page
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
+extern int PageHuge(struct page *page);
 extern int PageHeadHuge(struct page *page_head);
 #else /* CONFIG_HUGETLB_PAGE */
+static inline int PageHuge(struct page *page)
+{
+	return 0;
+}
 static inline int PageHeadHuge(struct page *page_head)
 {
 	return 0;
@@ -986,27 +991,16 @@ static inline int PageAnon(struct page *
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
 }
 
-/*
- * Return the pagecache index of the passed page.  Regular pagecache pages
- * use ->index whereas swapcache pages use ->private
- */
-static inline pgoff_t page_index(struct page *page)
-{
-	if (unlikely(PageSwapCache(page)))
-		return page_private(page);
-	return page->index;
-}
-
-extern pgoff_t __page_file_index(struct page *page);
+extern pgoff_t __page_swap_index(struct page *page);
 
 /*
- * Return the file index of the page. Regular pagecache pages use ->index
- * whereas swapcache pages use swp_offset(->private)
+ * Return the pagecache index of the passed page, which is the offset
+ * in the relevant page size.
  */
-static inline pgoff_t page_file_index(struct page *page)
+static inline pgoff_t page_index(struct page *page)
 {
 	if (unlikely(PageSwapCache(page)))
-		return __page_file_index(page);
+		return __page_swap_index(page);
 
 	return page->index;
 }
diff -puN include/linux/pagemap.h~mm-refactor-page-index-offset-getters include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-refactor-page-index-offset-getters
+++ a/include/linux/pagemap.h
@@ -399,28 +399,24 @@ static inline struct page *read_mapping_
 }
 
 /*
- * Get the offset in PAGE_SIZE.
+ * Return the 4kB page offset of the given page.
  * (TODO: hugepage should have ->index in PAGE_SIZE)
  */
-static inline pgoff_t page_to_pgoff(struct page *page)
+static inline pgoff_t page_pgoff(struct page *page)
 {
-	if (unlikely(PageHeadHuge(page)))
-		return page->index << compound_order(page);
-	else
-		return page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	if (unlikely(PageHuge(page))) {
+		VM_BUG_ON_PAGE(PageTail(page), page);
+		return page_index(page) << compound_order(page);
+	} else
+		return page_index(page) << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
 /*
- * Return byte-offset into filesystem object for page.
+ * Return the byte offset of the given page.
  */
 static inline loff_t page_offset(struct page *page)
 {
-	return ((loff_t)page->index) << PAGE_CACHE_SHIFT;
-}
-
-static inline loff_t page_file_offset(struct page *page)
-{
-	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
+	return ((loff_t)page_pgoff(page)) << PAGE_SHIFT;
 }
 
 extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
diff -puN mm/memory-failure.c~mm-refactor-page-index-offset-getters mm/memory-failure.c
--- a/mm/memory-failure.c~mm-refactor-page-index-offset-getters
+++ a/mm/memory-failure.c
@@ -435,7 +435,7 @@ static void collect_procs_anon(struct pa
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
-	pgoff = page_to_pgoff(page);
+	pgoff = page_pgoff(page);
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
@@ -469,7 +469,7 @@ static void collect_procs_file(struct pa
 	mutex_lock(&mapping->i_mmap_mutex);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
-		pgoff_t pgoff = page_to_pgoff(page);
+		pgoff_t pgoff = page_pgoff(page);
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
 		if (!t)
diff -puN mm/page_io.c~mm-refactor-page-index-offset-getters mm/page_io.c
--- a/mm/page_io.c~mm-refactor-page-index-offset-getters
+++ a/mm/page_io.c
@@ -250,7 +250,7 @@ out:
 
 static sector_t swap_page_sector(struct page *page)
 {
-	return (sector_t)__page_file_index(page) << (PAGE_CACHE_SHIFT - 9);
+	return (sector_t)__page_swap_index(page) << (PAGE_CACHE_SHIFT - 9);
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
@@ -278,7 +278,7 @@ int __swap_writepage(struct page *page,
 		from.bvec = &bv;	/* older gcc versions are broken */
 
 		init_sync_kiocb(&kiocb, swap_file);
-		kiocb.ki_pos = page_file_offset(page);
+		kiocb.ki_pos = page_offset(page);
 		kiocb.ki_nbytes = PAGE_SIZE;
 
 		set_page_writeback(page);
@@ -303,7 +303,7 @@ int __swap_writepage(struct page *page,
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 			pr_err_ratelimited("Write error on dio swapfile (%Lu)\n",
-				page_file_offset(page));
+				page_offset(page));
 		}
 		end_page_writeback(page);
 		return ret;
diff -puN mm/rmap.c~mm-refactor-page-index-offset-getters mm/rmap.c
--- a/mm/rmap.c~mm-refactor-page-index-offset-getters
+++ a/mm/rmap.c
@@ -517,7 +517,7 @@ void page_unlock_anon_vma_read(struct an
 static inline unsigned long
 __vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff = page_pgoff(page);
 	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 }
 
@@ -1615,7 +1615,7 @@ static struct anon_vma *rmap_walk_anon_l
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff = page_pgoff(page);
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1656,7 +1656,7 @@ static int rmap_walk_anon(struct page *p
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff = page_pgoff(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
diff -puN mm/swapfile.c~mm-refactor-page-index-offset-getters mm/swapfile.c
--- a/mm/swapfile.c~mm-refactor-page-index-offset-getters
+++ a/mm/swapfile.c
@@ -2715,13 +2715,13 @@ struct address_space *__page_file_mappin
 }
 EXPORT_SYMBOL_GPL(__page_file_mapping);
 
-pgoff_t __page_file_index(struct page *page)
+pgoff_t __page_swap_index(struct page *page)
 {
 	swp_entry_t swap = { .val = page_private(page) };
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	return swp_offset(swap);
 }
-EXPORT_SYMBOL_GPL(__page_file_index);
+EXPORT_SYMBOL_GPL(__page_swap_index);
 
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

