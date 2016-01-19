From: akpm@linux-foundation.org
Subject: [merged] thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:01:41 -0800
Message-ID: <569e9625.D/sH0fBiwML4msxi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbcASUBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: rename split_huge_page_pmd() to split_huge_pmd()
has been removed from the -mm tree.  Its filename was
     thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: rename split_huge_page_pmd() to split_huge_pmd()

We are going to decouple splitting THP PMD from splitting underlying
compound page.

This patch renames split_huge_page_pmd*() functions to split_huge_pmd*()
to reflect the fact that it doesn't imply page splitting, only PMD.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/subpage-prot.c |    2 -
 arch/x86/kernel/vm86_32.c      |    6 ++++-
 include/linux/huge_mm.h        |    8 +------
 mm/gup.c                       |    2 -
 mm/huge_memory.c               |   32 ++++++++++---------------------
 mm/memory.c                    |    2 -
 mm/mempolicy.c                 |    2 -
 mm/mprotect.c                  |    2 -
 mm/mremap.c                    |    2 -
 mm/pagewalk.c                  |    2 -
 10 files changed, 25 insertions(+), 35 deletions(-)

diff -puN arch/powerpc/mm/subpage-prot.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd arch/powerpc/mm/subpage-prot.c
--- a/arch/powerpc/mm/subpage-prot.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/arch/powerpc/mm/subpage-prot.c
@@ -135,7 +135,7 @@ static int subpage_walk_pmd_entry(pmd_t
 				  unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	split_huge_page_pmd(vma, addr, pmd);
+	split_huge_pmd(vma, pmd, addr);
 	return 0;
 }
 
diff -puN arch/x86/kernel/vm86_32.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd arch/x86/kernel/vm86_32.c
--- a/arch/x86/kernel/vm86_32.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/arch/x86/kernel/vm86_32.c
@@ -175,7 +175,11 @@ static void mark_screen_rdonly(struct mm
 	if (pud_none_or_clear_bad(pud))
 		goto out;
 	pmd = pmd_offset(pud, 0xA0000);
-	split_huge_page_pmd_mm(mm, 0xA0000, pmd);
+
+	if (pmd_trans_huge(*pmd)) {
+		struct vm_area_struct *vma = find_vma(mm, 0xA0000);
+		split_huge_pmd(vma, pmd, 0xA0000);
+	}
 	if (pmd_none_or_clear_bad(pmd))
 		goto out;
 	pte = pte_offset_map_lock(mm, pmd, 0xA0000, &ptl);
diff -puN include/linux/huge_mm.h~thp-rename-split_huge_page_pmd-to-split_huge_pmd include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/include/linux/huge_mm.h
@@ -102,7 +102,7 @@ static inline int split_huge_page(struct
 }
 extern void __split_huge_page_pmd(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd);
-#define split_huge_page_pmd(__vma, __address, __pmd)			\
+#define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
 		if (unlikely(pmd_trans_huge(*____pmd)))			\
@@ -117,8 +117,6 @@ extern void __split_huge_page_pmd(struct
 		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
 		       pmd_trans_huge(*____pmd));			\
 	} while (0)
-extern void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd);
 #if HPAGE_PMD_ORDER >= MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -183,11 +181,9 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-#define split_huge_page_pmd(__vma, __address, __pmd)	\
-	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
-#define split_huge_page_pmd_mm(__mm, __address, __pmd)	\
+#define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
diff -puN mm/gup.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/gup.c
--- a/mm/gup.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/gup.c
@@ -254,7 +254,7 @@ struct page *follow_page_mask(struct vm_
 		if (is_huge_zero_page(page)) {
 			spin_unlock(ptl);
 			ret = 0;
-			split_huge_page_pmd(vma, address, pmd);
+			split_huge_pmd(vma, pmd, address);
 		} else {
 			get_page(page);
 			spin_unlock(ptl);
diff -puN mm/huge_memory.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/huge_memory.c
@@ -1233,13 +1233,13 @@ alloc:
 
 	if (unlikely(!new_page)) {
 		if (!page) {
-			split_huge_page_pmd(vma, address, pmd);
+			split_huge_pmd(vma, pmd, address);
 			ret |= VM_FAULT_FALLBACK;
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
 			if (ret & VM_FAULT_OOM) {
-				split_huge_page(page);
+				split_huge_pmd(vma, pmd, address);
 				ret |= VM_FAULT_FALLBACK;
 			}
 			put_user_huge_page(page);
@@ -1252,10 +1252,10 @@ alloc:
 					   true))) {
 		put_page(new_page);
 		if (page) {
-			split_huge_page(page);
+			split_huge_pmd(vma, pmd, address);
 			put_user_huge_page(page);
 		} else
-			split_huge_page_pmd(vma, address, pmd);
+			split_huge_pmd(vma, pmd, address);
 		ret |= VM_FAULT_FALLBACK;
 		count_vm_event(THP_FAULT_FALLBACK);
 		goto out;
@@ -3131,17 +3131,7 @@ again:
 		goto again;
 }
 
-void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd)
-{
-	struct vm_area_struct *vma;
-
-	vma = find_vma(mm, address);
-	BUG_ON(vma == NULL);
-	split_huge_page_pmd(vma, address, pmd);
-}
-
-static void split_huge_page_address(struct mm_struct *mm,
+static void split_huge_pmd_address(struct vm_area_struct *vma,
 				    unsigned long address)
 {
 	pgd_t *pgd;
@@ -3150,7 +3140,7 @@ static void split_huge_page_address(stru
 
 	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
 
-	pgd = pgd_offset(mm, address);
+	pgd = pgd_offset(vma->vm_mm, address);
 	if (!pgd_present(*pgd))
 		return;
 
@@ -3159,13 +3149,13 @@ static void split_huge_page_address(stru
 		return;
 
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	if (!pmd_present(*pmd) || !pmd_trans_huge(*pmd))
 		return;
 	/*
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
 	 * materialize from under us.
 	 */
-	split_huge_page_pmd_mm(mm, address, pmd);
+	__split_huge_page_pmd(vma, address, pmd);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
@@ -3181,7 +3171,7 @@ void vma_adjust_trans_huge(struct vm_are
 	if (start & ~HPAGE_PMD_MASK &&
 	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
 	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_page_address(vma->vm_mm, start);
+		split_huge_pmd_address(vma, start);
 
 	/*
 	 * If the new end address isn't hpage aligned and it could
@@ -3191,7 +3181,7 @@ void vma_adjust_trans_huge(struct vm_are
 	if (end & ~HPAGE_PMD_MASK &&
 	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
 	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_page_address(vma->vm_mm, end);
+		split_huge_pmd_address(vma, end);
 
 	/*
 	 * If we're also updating the vma->vm_next->vm_start, if the new
@@ -3205,6 +3195,6 @@ void vma_adjust_trans_huge(struct vm_are
 		if (nstart & ~HPAGE_PMD_MASK &&
 		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
 		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
-			split_huge_page_address(next->vm_mm, nstart);
+			split_huge_pmd_address(next, nstart);
 	}
 }
diff -puN mm/memory.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/memory.c
--- a/mm/memory.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/memory.c
@@ -1193,7 +1193,7 @@ static inline unsigned long zap_pmd_rang
 					BUG();
 				}
 #endif
-				split_huge_page_pmd(vma, addr, pmd);
+				split_huge_pmd(vma, pmd, addr);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
 			/* fall through */
diff -puN mm/mempolicy.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/mempolicy.c
--- a/mm/mempolicy.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/mempolicy.c
@@ -493,7 +493,7 @@ static int queue_pages_pte_range(pmd_t *
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	split_huge_page_pmd(vma, addr, pmd);
+	split_huge_pmd(vma, pmd, addr);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
diff -puN mm/mprotect.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/mprotect.c
--- a/mm/mprotect.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/mprotect.c
@@ -160,7 +160,7 @@ static inline unsigned long change_pmd_r
 
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
-				split_huge_page_pmd(vma, addr, pmd);
+				split_huge_pmd(vma, pmd, addr);
 			else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
 						newprot, prot_numa);
diff -puN mm/mremap.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/mremap.c
--- a/mm/mremap.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/mremap.c
@@ -209,7 +209,7 @@ unsigned long move_page_tables(struct vm
 				need_flush = true;
 				continue;
 			} else if (!err) {
-				split_huge_page_pmd(vma, old_addr, old_pmd);
+				split_huge_pmd(vma, old_pmd, old_addr);
 			}
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
diff -puN mm/pagewalk.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd mm/pagewalk.c
--- a/mm/pagewalk.c~thp-rename-split_huge_page_pmd-to-split_huge_pmd
+++ a/mm/pagewalk.c
@@ -58,7 +58,7 @@ again:
 		if (!walk->pte_entry)
 			continue;
 
-		split_huge_page_pmd_mm(walk->mm, addr, pmd);
+		split_huge_pmd(walk->vma, pmd, addr);
 		if (pmd_trans_unstable(pmd))
 			goto again;
 		err = walk_pte_range(pmd, addr, next, walk);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

