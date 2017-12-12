From: akpm@linux-foundation.org
Subject: + mm-add-unmap_mapping_pages.patch added to -mm tree
Date: Tue, 12 Dec 2017 15:26:36 -0800
Message-ID: <5a3065ac.NV9uO27GUu3X5B0y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdLLX0h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 18:26:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@infradead.org, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, yi.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add unmap_mapping_pages()
has been added to the -mm tree.  Its filename is
     mm-add-unmap_mapping_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-unmap_mapping_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-unmap_mapping_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: add unmap_mapping_pages()

Several users of unmap_mapping_range() would prefer to express their range
in pages rather than bytes.  Unfortuately, on a 32-bit kernel, you have to
remember to cast your page number to a 64-bit type before shifting it, and
four places in the current tree didn't remember to do that.  That's a sign
of a bad interface.

Conveniently, unmap_mapping_range() actually converts from bytes into
pages, so hoist the guts of unmap_mapping_range() into a new function
unmap_mapping_pages() and convert the callers which want to use pages.

Link: http://lkml.kernel.org/r/20171206142627.GD32044@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reported-by: "zhangyi (F)" <yi.zhang@huawei.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c           |   19 ++++++-------------
 include/linux/mm.h |   26 ++++++++++++++++----------
 mm/khugepaged.c    |    3 +--
 mm/memory.c        |   43 +++++++++++++++++++++++++++++++------------
 mm/nommu.c         |    7 -------
 mm/truncate.c      |   23 +++++++----------------
 6 files changed, 61 insertions(+), 60 deletions(-)

diff -puN fs/dax.c~mm-add-unmap_mapping_pages fs/dax.c
--- a/fs/dax.c~mm-add-unmap_mapping_pages
+++ a/fs/dax.c
@@ -44,6 +44,7 @@
 
 /* The 'colour' (ie low bits) within a PMD of a page offset.  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
+#define PG_PMD_NR	(PMD_SIZE >> PAGE_SHIFT)
 
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
@@ -375,8 +376,8 @@ restart:
 		 * unmapped.
 		 */
 		if (pmd_downgrade && dax_is_zero_entry(entry))
-			unmap_mapping_range(mapping,
-				(index << PAGE_SHIFT) & PMD_MASK, PMD_SIZE, 0);
+			unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
+							PG_PMD_NR, false);
 
 		err = radix_tree_preload(
 				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
@@ -538,12 +539,10 @@ static void *dax_insert_mapping_entry(st
 	if (dax_is_zero_entry(entry) && !(flags & RADIX_DAX_ZERO_PAGE)) {
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
-			unmap_mapping_range(mapping,
-					(vmf->pgoff << PAGE_SHIFT) & PMD_MASK,
-					PMD_SIZE, 0);
+			unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
+							PG_PMD_NR, false);
 		else /* pte entry */
-			unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
-					PAGE_SIZE, 0);
+			unmap_mapping_pages(mapping, vmf->pgoff, 1, false);
 	}
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -1270,12 +1269,6 @@ static int dax_iomap_pte_fault(struct vm
 }
 
 #ifdef CONFIG_FS_DAX_PMD
-/*
- * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
- * more often than one might expect in the below functions.
- */
-#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
-
 static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 		void *entry)
 {
diff -puN include/linux/mm.h~mm-add-unmap_mapping_pages include/linux/mm.h
--- a/include/linux/mm.h~mm-add-unmap_mapping_pages
+++ a/include/linux/mm.h
@@ -1312,8 +1312,6 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
 			struct vm_area_struct *vma);
-void unmap_mapping_range(struct address_space *mapping,
-		loff_t const holebegin, loff_t const holelen, int even_cows);
 int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 			     unsigned long *start, unsigned long *end,
 			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
@@ -1324,12 +1322,6 @@ int follow_phys(struct vm_area_struct *v
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
-static inline void unmap_shared_mapping_range(struct address_space *mapping,
-		loff_t const holebegin, loff_t const holelen)
-{
-	unmap_mapping_range(mapping, holebegin, holelen, 0);
-}
-
 extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
@@ -1344,6 +1336,10 @@ extern int handle_mm_fault(struct vm_are
 extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
+void unmap_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t nr, bool even_cows);
+void unmap_mapping_range(struct address_space *mapping,
+		loff_t const holebegin, loff_t const holelen, int even_cows);
 #else
 static inline int handle_mm_fault(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags)
@@ -1360,10 +1356,20 @@ static inline int fixup_user_fault(struc
 	BUG();
 	return -EFAULT;
 }
+static inline void unmap_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t nr, bool even_cows) { }
+static inline void unmap_mapping_range(struct address_space *mapping,
+		loff_t const holebegin, loff_t const holelen, int even_cows) { }
 #endif
 
-extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len,
-		unsigned int gup_flags);
+static inline void unmap_shared_mapping_range(struct address_space *mapping,
+		loff_t const holebegin, loff_t const holelen)
+{
+	unmap_mapping_range(mapping, holebegin, holelen, 0);
+}
+
+extern int access_process_vm(struct task_struct *tsk, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags);
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 extern int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
diff -puN mm/khugepaged.c~mm-add-unmap_mapping_pages mm/khugepaged.c
--- a/mm/khugepaged.c~mm-add-unmap_mapping_pages
+++ a/mm/khugepaged.c
@@ -1399,8 +1399,7 @@ static void collapse_shmem(struct mm_str
 		}
 
 		if (page_mapped(page))
-			unmap_mapping_range(mapping, index << PAGE_SHIFT,
-					PAGE_SIZE, 0);
+			unmap_mapping_pages(mapping, index, 1, false);
 
 		spin_lock_irq(&mapping->tree_lock);
 
diff -puN mm/memory.c~mm-add-unmap_mapping_pages mm/memory.c
--- a/mm/memory.c~mm-add-unmap_mapping_pages
+++ a/mm/memory.c
@@ -2799,8 +2799,37 @@ static inline void unmap_mapping_range_t
 }
 
 /**
+ * unmap_mapping_pages() - Unmap pages from processes.
+ * @mapping: The address space containing pages to be unmapped.
+ * @start: Index of first page to be unmapped.
+ * @nr: Number of pages to be unmapped.  0 to unmap to end of file.
+ * @even_cows: Whether to unmap even private COWed pages.
+ *
+ * Unmap the pages in this address space from any userspace process which
+ * has them mmaped.  Generally, you want to remove COWed pages as well when
+ * a file is being truncated, but not when invalidating pages from the page
+ * cache.
+ */
+void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
+		pgoff_t nr, bool even_cows)
+{
+	struct zap_details details = { };
+
+	details.check_mapping = even_cows ? NULL : mapping;
+	details.first_index = start;
+	details.last_index = start + nr - 1;
+	if (details.last_index < details.first_index)
+		details.last_index = ULONG_MAX;
+
+	i_mmap_lock_write(mapping);
+	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+		unmap_mapping_range_tree(&mapping->i_mmap, &details);
+	i_mmap_unlock_write(mapping);
+}
+
+/**
  * unmap_mapping_range - unmap the portion of all mmaps in the specified
- * address_space corresponding to the specified page range in the underlying
+ * address_space corresponding to the specified byte range in the underlying
  * file.
  *
  * @mapping: the address space containing mmaps to be unmapped.
@@ -2818,7 +2847,6 @@ static inline void unmap_mapping_range_t
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	struct zap_details details = { };
 	pgoff_t hba = holebegin >> PAGE_SHIFT;
 	pgoff_t hlen = (holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
@@ -2830,16 +2858,7 @@ void unmap_mapping_range(struct address_
 			hlen = ULONG_MAX - hba + 1;
 	}
 
-	details.check_mapping = even_cows ? NULL : mapping;
-	details.first_index = hba;
-	details.last_index = hba + hlen - 1;
-	if (details.last_index < details.first_index)
-		details.last_index = ULONG_MAX;
-
-	i_mmap_lock_write(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
-		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	i_mmap_unlock_write(mapping);
+	unmap_mapping_pages(mapping, hba, hlen, even_cows);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
diff -puN mm/nommu.c~mm-add-unmap_mapping_pages mm/nommu.c
--- a/mm/nommu.c~mm-add-unmap_mapping_pages
+++ a/mm/nommu.c
@@ -1788,13 +1788,6 @@ unsigned long arch_get_unmapped_area(str
 	return -ENOMEM;
 }
 
-void unmap_mapping_range(struct address_space *mapping,
-			 loff_t const holebegin, loff_t const holelen,
-			 int even_cows)
-{
-}
-EXPORT_SYMBOL(unmap_mapping_range);
-
 int filemap_fault(struct vm_fault *vmf)
 {
 	BUG();
diff -puN mm/truncate.c~mm-add-unmap_mapping_pages mm/truncate.c
--- a/mm/truncate.c~mm-add-unmap_mapping_pages
+++ a/mm/truncate.c
@@ -179,12 +179,8 @@ static void
 truncate_cleanup_page(struct address_space *mapping, struct page *page)
 {
 	if (page_mapped(page)) {
-		loff_t holelen;
-
-		holelen = PageTransHuge(page) ? HPAGE_PMD_SIZE : PAGE_SIZE;
-		unmap_mapping_range(mapping,
-				   (loff_t)page->index << PAGE_SHIFT,
-				   holelen, 0);
+		pgoff_t nr = PageTransHuge(page) ? HPAGE_PMD_NR : 1;
+		unmap_mapping_pages(mapping, page->index, nr, false);
 	}
 
 	if (page_has_private(page))
@@ -715,19 +711,15 @@ int invalidate_inode_pages2_range(struct
 					/*
 					 * Zap the rest of the file in one hit.
 					 */
-					unmap_mapping_range(mapping,
-					   (loff_t)index << PAGE_SHIFT,
-					   (loff_t)(1 + end - index)
-							 << PAGE_SHIFT,
-							 0);
+					unmap_mapping_pages(mapping, index,
+						(1 + end - index), false);
 					did_range_unmap = 1;
 				} else {
 					/*
 					 * Just zap this page
 					 */
-					unmap_mapping_range(mapping,
-					   (loff_t)index << PAGE_SHIFT,
-					   PAGE_SIZE, 0);
+					unmap_mapping_pages(mapping, index,
+								1, false);
 				}
 			}
 			BUG_ON(page_mapped(page));
@@ -753,8 +745,7 @@ int invalidate_inode_pages2_range(struct
 	 * get remapped later.
 	 */
 	if (dax_mapping(mapping)) {
-		unmap_mapping_range(mapping, (loff_t)start << PAGE_SHIFT,
-				    (loff_t)(end - start + 1) << PAGE_SHIFT, 0);
+		unmap_mapping_pages(mapping, start, end - start + 1, false);
 	}
 out:
 	cleancache_invalidate_inode(mapping);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-unmap_mapping_pages.patch

