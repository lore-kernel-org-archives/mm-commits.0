From: akpm@linux-foundation.org
Subject: + x86-support-gb-hugepages-on-64-bit.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:12:01 -0700
Message-ID: <200806081912.m58JC1UX016181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbYFHTMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, agl@us.ibm.com, ak@suse.de


The patch titled
     x86: support GB hugepages on 64-bit
has been added to the -mm tree.  Its filename is
     x86-support-gb-hugepages-on-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: support GB hugepages on 64-bit
From: Nick Piggin <npiggin@suse.de>

Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~x86-support-gb-hugepages-on-64-bit arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~x86-support-gb-hugepages-on-64-bit
+++ a/arch/x86/mm/hugetlbpage.c
@@ -134,9 +134,14 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	pgd = pgd_offset(mm, addr);
 	pud = pud_alloc(mm, pgd, addr);
 	if (pud) {
-		if (pud_none(*pud))
-			huge_pmd_share(mm, addr, pud);
-		pte = (pte_t *) pmd_alloc(mm, pud, addr);
+		if (sz == PUD_SIZE) {
+			pte = (pte_t *)pud;
+		} else {
+			BUG_ON(sz != PMD_SIZE);
+			if (pud_none(*pud))
+				huge_pmd_share(mm, addr, pud);
+			pte = (pte_t *) pmd_alloc(mm, pud, addr);
+		}
 	}
 	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
 
@@ -152,8 +157,11 @@ pte_t *huge_pte_offset(struct mm_struct 
 	pgd = pgd_offset(mm, addr);
 	if (pgd_present(*pgd)) {
 		pud = pud_offset(pgd, addr);
-		if (pud_present(*pud))
+		if (pud_present(*pud)) {
+			if (pud_large(*pud))
+				return (pte_t *)pud;
 			pmd = pmd_offset(pud, addr);
+		}
 	}
 	return (pte_t *) pmd;
 }
@@ -216,7 +224,7 @@ int pmd_huge(pmd_t pmd)
 
 int pud_huge(pud_t pud)
 {
-	return 0;
+	return !!(pud_val(pud) & _PAGE_PSE);
 }
 
 struct page *
@@ -252,6 +260,7 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
+	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
@@ -264,7 +273,7 @@ static unsigned long hugetlb_get_unmappe
 	}
 
 full_search:
-	addr = ALIGN(start_addr, HPAGE_SIZE);
+	addr = ALIGN(start_addr, huge_page_size(h));
 
 	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
 		/* At this point:  (!vma || addr < vma->vm_end). */
@@ -286,7 +295,7 @@ full_search:
 		}
 		if (addr + mm->cached_hole_size < vma->vm_start)
 		        mm->cached_hole_size = vma->vm_start - addr;
-		addr = ALIGN(vma->vm_end, HPAGE_SIZE);
+		addr = ALIGN(vma->vm_end, huge_page_size(h));
 	}
 }
 
@@ -294,6 +303,7 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long addr0, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
+	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev_vma;
 	unsigned long base = mm->mmap_base, addr = addr0;
@@ -314,7 +324,7 @@ try_again:
 		goto fail;
 
 	/* either no address requested or cant fit in requested address hole */
-	addr = (mm->free_area_cache - len) & HPAGE_MASK;
+	addr = (mm->free_area_cache - len) & huge_page_mask(h);
 	do {
 		/*
 		 * Lookup failure means no vma is above this address,
@@ -345,7 +355,7 @@ try_again:
 		        largest_hole = vma->vm_start - addr;
 
 		/* try just below the current vma->vm_start */
-		addr = (vma->vm_start - len) & HPAGE_MASK;
+		addr = (vma->vm_start - len) & huge_page_mask(h);
 	} while (len <= vma->vm_start);
 
 fail:
@@ -383,10 +393,11 @@ unsigned long
 hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
+	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 
-	if (len & ~HPAGE_MASK)
+	if (len & ~huge_page_mask(h))
 		return -EINVAL;
 	if (len > TASK_SIZE)
 		return -ENOMEM;
@@ -398,7 +409,7 @@ hugetlb_get_unmapped_area(struct file *f
 	}
 
 	if (addr) {
-		addr = ALIGN(addr, HPAGE_SIZE);
+		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
 		if (TASK_SIZE - len >= addr &&
 		    (!vma || addr + len <= vma->vm_start))
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

