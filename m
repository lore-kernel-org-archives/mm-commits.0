From: akpm@linux-foundation.org
Subject: [patch 101/126] thp, mlock: do not mlock PTE-mapped file huge
 pages
Date: Tue, 26 Jul 2016 15:25:53 -0700
Message-ID: <5797e371.BUxgbXojnOMZe4W/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbcGZWZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, mlock: do not mlock PTE-mapped file huge pages

As with anon THP, we only mlock file huge pages if we can prove that the
page is not mapped with PTE. This way we can avoid mlock leak into
non-mlocked vma on split.

We rely on PageDoubleMap() under lock_page() to check if the the page
may be PTE mapped. PG_double_map is set by page_add_file_rmap() when the
page mapped with PTEs.

Link: http://lkml.kernel.org/r/1466021202-61880-21-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   13 ++++++++++++-
 mm/huge_memory.c           |   27 ++++++++++++++++++++-------
 mm/mmap.c                  |    6 ++++++
 mm/page_alloc.c            |    2 ++
 mm/rmap.c                  |   16 ++++++++++++++--
 5 files changed, 54 insertions(+), 10 deletions(-)

diff -puN include/linux/page-flags.h~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages
+++ a/include/linux/page-flags.h
@@ -581,6 +581,17 @@ static inline int PageDoubleMap(struct p
 	return PageHead(page) && test_bit(PG_double_map, &page[1].flags);
 }
 
+static inline void SetPageDoubleMap(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	set_bit(PG_double_map, &page[1].flags);
+}
+
+static inline void ClearPageDoubleMap(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	clear_bit(PG_double_map, &page[1].flags);
+}
 static inline int TestSetPageDoubleMap(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHead(page), page);
@@ -598,7 +609,7 @@ TESTPAGEFLAG_FALSE(TransHuge)
 TESTPAGEFLAG_FALSE(TransCompound)
 TESTPAGEFLAG_FALSE(TransCompoundMap)
 TESTPAGEFLAG_FALSE(TransTail)
-TESTPAGEFLAG_FALSE(DoubleMap)
+PAGEFLAG_FALSE(DoubleMap)
 	TESTSETFLAG_FALSE(DoubleMap)
 	TESTCLEARFLAG_FALSE(DoubleMap)
 #endif
diff -puN mm/huge_memory.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages
+++ a/mm/huge_memory.c
@@ -1437,6 +1437,8 @@ struct page *follow_trans_huge_pmd(struc
 		 * We don't mlock() pte-mapped THPs. This way we can avoid
 		 * leaking mlocked pages into non-VM_LOCKED VMAs.
 		 *
+		 * For anon THP:
+		 *
 		 * In most cases the pmd is the only mapping of the page as we
 		 * break COW for the mlock() -- see gup_flags |= FOLL_WRITE for
 		 * writable private mappings in populate_vma_page_range().
@@ -1444,15 +1446,26 @@ struct page *follow_trans_huge_pmd(struc
 		 * The only scenario when we have the page shared here is if we
 		 * mlocking read-only mapping shared over fork(). We skip
 		 * mlocking such pages.
+		 *
+		 * For file THP:
+		 *
+		 * We can expect PageDoubleMap() to be stable under page lock:
+		 * for file pages we set it in page_add_file_rmap(), which
+		 * requires page to be locked.
 		 */
-		if (compound_mapcount(page) == 1 && !PageDoubleMap(page) &&
-				page->mapping && trylock_page(page)) {
-			lru_add_drain();
-			if (page->mapping)
-				mlock_vma_page(page);
-			unlock_page(page);
-		}
+
+		if (PageAnon(page) && compound_mapcount(page) != 1)
+			goto skip_mlock;
+		if (PageDoubleMap(page) || !page->mapping)
+			goto skip_mlock;
+		if (!trylock_page(page))
+			goto skip_mlock;
+		lru_add_drain();
+		if (page->mapping && !PageDoubleMap(page))
+			mlock_vma_page(page);
+		unlock_page(page);
 	}
+skip_mlock:
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	if (flags & FOLL_GET)
diff -puN mm/mmap.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages mm/mmap.c
--- a/mm/mmap.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages
+++ a/mm/mmap.c
@@ -2591,6 +2591,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		/* drop PG_Mlocked flag for over-mapped range */
 		for (tmp = vma; tmp->vm_start >= start + size;
 				tmp = tmp->vm_next) {
+			/*
+			 * Split pmd and munlock page on the border
+			 * of the range.
+			 */
+			vma_adjust_trans_huge(tmp, start, start + size, 0);
+
 			munlock_vma_pages_range(tmp,
 					max(tmp->vm_start, start),
 					min(tmp->vm_end, start + size));
diff -puN mm/page_alloc.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages mm/page_alloc.c
--- a/mm/page_alloc.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages
+++ a/mm/page_alloc.c
@@ -1007,6 +1007,8 @@ static __always_inline bool free_pages_p
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
+		if (compound)
+			ClearPageDoubleMap(page);
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
diff -puN mm/rmap.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages mm/rmap.c
--- a/mm/rmap.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages
+++ a/mm/rmap.c
@@ -1284,6 +1284,12 @@ void page_add_file_rmap(struct page *pag
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
 	} else {
+		if (PageTransCompound(page)) {
+			VM_BUG_ON_PAGE(!PageLocked(page), page);
+			SetPageDoubleMap(compound_head(page));
+			if (PageMlocked(page))
+				clear_page_mlock(compound_head(page));
+		}
 		if (!atomic_inc_and_test(&page->_mapcount))
 			goto out;
 	}
@@ -1458,8 +1464,14 @@ static int try_to_unmap_one(struct page
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
 		if (vma->vm_flags & VM_LOCKED) {
-			/* Holding pte lock, we do *not* need mmap_sem here */
-			mlock_vma_page(page);
+			/* PTE-mapped THP are never mlocked */
+			if (!PageTransCompound(page)) {
+				/*
+				 * Holding pte lock, we do *not* need
+				 * mmap_sem here
+				 */
+				mlock_vma_page(page);
+			}
 			ret = SWAP_MLOCK;
 			goto out_unmap;
 		}
_
