From: akpm@linux-foundation.org
Subject: + thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch added
 to -mm tree
Date: Tue, 07 Jun 2016 14:04:16 -0700
Message-ID: <575736d0.CJKtydLoLl7/NlJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161158AbcFGVES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:04:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, mlock: do not mlock PTE-mapped file huge pages
has been added to the -mm tree.  Its filename is
     thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, mlock: do not mlock PTE-mapped file huge pages

As with anon THP, we only mlock file huge pages if we can prove that the
page is not mapped with PTE. This way we can avoid mlock leak into
non-mlocked vma on split.

We rely on PageDoubleMap() under lock_page() to check if the the page
may be PTE mapped. PG_double_map is set by page_add_file_rmap() when the
page mapped with PTEs.

Link: http://lkml.kernel.org/r/1465297246-98985-16-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Ning Qu <quning@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
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
@@ -1005,6 +1005,8 @@ static __always_inline bool free_pages_p
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
+		if (compound)
+			ClearPageDoubleMap(page);
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
diff -puN mm/rmap.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages mm/rmap.c
--- a/mm/rmap.c~thp-mlock-do-not-mlock-pte-mapped-file-huge-pages
+++ a/mm/rmap.c
@@ -1287,6 +1287,12 @@ void page_add_file_rmap(struct page *pag
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
@@ -1460,8 +1466,14 @@ static int try_to_unmap_one(struct page
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch
a.patch

