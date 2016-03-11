From: akpm@linux-foundation.org
Subject: +
 thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix.patch
 added to -mm tree
Date: Fri, 11 Mar 2016 13:12:02 -0800
Message-ID: <56e334a2.5Up/QFJszfHimMoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbcCKVME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2016 16:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: make sure we replace the right page with migration entires
has been added to the -mm tree.  Its filename is
     thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix.patch

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
Subject: thp: make sure we replace the right page with migration entires

split_huge_pmd_address(freeze == true) would split the pmd and setup
migration entries into ptes.

To get it work properly we need a page to check pmd against. Otherwise
we can end up replacing wrong page (i.e. after COW break).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 mm/huge_memory.c        |   17 +++++++++++++----
 mm/rmap.c               |    3 ++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff -puN include/linux/huge_mm.h~thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix
+++ a/include/linux/huge_mm.h
@@ -109,7 +109,7 @@ void __split_huge_pmd(struct vm_area_str
 
 
 void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
-		bool freeze);
+		bool freeze, struct page *page);
 
 #if HPAGE_PMD_ORDER >= MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
@@ -180,7 +180,7 @@ static inline void deferred_split_huge_p
 	do { } while (0)
 
 static inline void split_huge_pmd_address(struct vm_area_struct *vma,
-		unsigned long address, bool freeze) {}
+		unsigned long address, bool freeze, struct page *page) {}
 
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
diff -puN mm/huge_memory.c~thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix
+++ a/mm/huge_memory.c
@@ -3007,7 +3007,7 @@ out:
 }
 
 void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
-		bool freeze)
+		bool freeze, struct page *page)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -3024,6 +3024,15 @@ void split_huge_pmd_address(struct vm_ar
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd) || (!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)))
 		return;
+
+	/*
+	 * If caller asks to setup a migration entries, we need a page to check
+	 * pmd against. Otherwise we can end up replacing wrong page.
+	 */
+	VM_BUG_ON(freeze && !page);
+	if (page && page != pmd_page(*pmd))
+		return;
+
 	/*
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
 	 * materialize from under us.
@@ -3044,7 +3053,7 @@ void vma_adjust_trans_huge(struct vm_are
 	if (start & ~HPAGE_PMD_MASK &&
 	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
 	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_pmd_address(vma, start, false);
+		split_huge_pmd_address(vma, start, false, NULL);
 
 	/*
 	 * If the new end address isn't hpage aligned and it could
@@ -3054,7 +3063,7 @@ void vma_adjust_trans_huge(struct vm_are
 	if (end & ~HPAGE_PMD_MASK &&
 	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
 	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_pmd_address(vma, end, false);
+		split_huge_pmd_address(vma, end, false, NULL);
 
 	/*
 	 * If we're also updating the vma->vm_next->vm_start, if the new
@@ -3068,7 +3077,7 @@ void vma_adjust_trans_huge(struct vm_are
 		if (nstart & ~HPAGE_PMD_MASK &&
 		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
 		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
-			split_huge_pmd_address(next, nstart, false);
+			split_huge_pmd_address(next, nstart, false, NULL);
 	}
 }
 
diff -puN mm/rmap.c~thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix mm/rmap.c
--- a/mm/rmap.c~thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix
+++ a/mm/rmap.c
@@ -1432,7 +1432,8 @@ static int try_to_unmap_one(struct page
 		goto out;
 
 	if (flags & TTU_SPLIT_HUGE_PMD) {
-		split_huge_pmd_address(vma, address, flags & TTU_MIGRATION);
+		split_huge_pmd_address(vma, address,
+				flags & TTU_MIGRATION, page);
 		/* check if we have anything to do after split */
 		if (page_mapcount(page) == 0)
 			goto out;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-cleanup-pte_alloc-interfaces.patch
rmap-introduce-rmap_walk_locked.patch
rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch
mm-make-remove_migration_ptes-beyond-mm-migrationc.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix.patch
thp-fix-deadlock-in-split_huge_pmd.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

