From: akpm@linux-foundation.org
Subject: [merged]
 rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:06 -0700
Message-ID: <56f04006.T/wxjfDy40R32BJw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbcCUT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: extend try_to_unmap() to be usable by split_huge_page()
has been removed from the -mm tree.  Its filename was
     rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rmap: extend try_to_unmap() to be usable by split_huge_page()

Add support for two ttu_flags:

  - TTU_SPLIT_HUGE_PMD would split PMD if it's there, before trying to
    unmap page;

  - TTU_RMAP_LOCKED indicates that caller holds relevant rmap lock;

Also, change rwc->done to !page_mapcount() instead of !page_mapped(). 
try_to_unmap() works on pte level, so we are really interested in the
mappedness of this small page rather than of the compound page it's a part
of.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 +++++++
 include/linux/rmap.h    |    3 +++
 mm/huge_memory.c        |    5 +----
 mm/rmap.c               |   24 ++++++++++++++++--------
 4 files changed, 27 insertions(+), 12 deletions(-)

diff -puN include/linux/huge_mm.h~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page
+++ a/include/linux/huge_mm.h
@@ -106,6 +106,9 @@ void __split_huge_pmd(struct vm_area_str
 			__split_huge_pmd(__vma, __pmd, __address);	\
 	}  while (0)
 
+
+void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address);
+
 #if HPAGE_PMD_ORDER >= MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -173,6 +176,10 @@ static inline int split_huge_page(struct
 static inline void deferred_split_huge_page(struct page *page) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
+
+static inline void split_huge_pmd_address(struct vm_area_struct *vma,
+		unsigned long address) {}
+
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
diff -puN include/linux/rmap.h~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page
+++ a/include/linux/rmap.h
@@ -86,6 +86,7 @@ enum ttu_flags {
 	TTU_MIGRATION = 2,		/* migration mode */
 	TTU_MUNLOCK = 4,		/* munlock mode */
 	TTU_LZFREE = 8,			/* lazy free mode */
+	TTU_SPLIT_HUGE_PMD = 16,	/* split huge PMD if any */
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
@@ -93,6 +94,8 @@ enum ttu_flags {
 	TTU_BATCH_FLUSH = (1 << 11),	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
 					 * do a final flush if necessary */
+	TTU_RMAP_LOCKED = (1 << 12)	/* do not grab rmap lock:
+					 * caller holds it */
 };
 
 #ifdef CONFIG_MMU
diff -puN mm/huge_memory.c~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page
+++ a/mm/huge_memory.c
@@ -3006,15 +3006,12 @@ out:
 	}
 }
 
-static void split_huge_pmd_address(struct vm_area_struct *vma,
-				    unsigned long address)
+void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
-
 	pgd = pgd_offset(vma->vm_mm, address);
 	if (!pgd_present(*pgd))
 		return;
diff -puN mm/rmap.c~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page mm/rmap.c
--- a/mm/rmap.c~rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page
+++ a/mm/rmap.c
@@ -1431,6 +1431,8 @@ static int try_to_unmap_one(struct page
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		goto out;
 
+	if (flags & TTU_SPLIT_HUGE_PMD)
+		split_huge_pmd_address(vma, address);
 	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
@@ -1576,10 +1578,10 @@ static bool invalid_migration_vma(struct
 	return is_vma_temporary_stack(vma);
 }
 
-static int page_not_mapped(struct page *page)
+static int page_mapcount_is_zero(struct page *page)
 {
-	return !page_mapped(page);
-};
+	return !page_mapcount(page);
+}
 
 /**
  * try_to_unmap - try to remove all page table mappings to a page
@@ -1606,12 +1608,10 @@ int try_to_unmap(struct page *page, enum
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = &rp,
-		.done = page_not_mapped,
+		.done = page_mapcount_is_zero,
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
-	VM_BUG_ON_PAGE(!PageHuge(page) && PageTransHuge(page), page);
-
 	/*
 	 * During exec, a temporary VMA is setup and later moved.
 	 * The VMA is moved under the anon_vma lock but not the
@@ -1623,9 +1623,12 @@ int try_to_unmap(struct page *page, enum
 	if ((flags & TTU_MIGRATION) && !PageKsm(page) && PageAnon(page))
 		rwc.invalid_vma = invalid_migration_vma;
 
-	ret = rmap_walk(page, &rwc);
+	if (flags & TTU_RMAP_LOCKED)
+		ret = rmap_walk_locked(page, &rwc);
+	else
+		ret = rmap_walk(page, &rwc);
 
-	if (ret != SWAP_MLOCK && !page_mapped(page)) {
+	if (ret != SWAP_MLOCK && !page_mapcount(page)) {
 		ret = SWAP_SUCCESS;
 		if (rp.lazyfreed && !PageDirty(page))
 			ret = SWAP_LZFREE;
@@ -1633,6 +1636,11 @@ int try_to_unmap(struct page *page, enum
 	return ret;
 }
 
+static int page_not_mapped(struct page *page)
+{
+	return !page_mapped(page);
+};
+
 /**
  * try_to_munlock - try to munlock a page
  * @page: the page to be munlocked
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

