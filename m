From: akpm@linux-foundation.org
Subject: + mincore-cleanups.patch added to -mm tree
Date: Wed, 24 Mar 2010 14:29:41 -0700
Message-ID: <201003242129.o2OLTfFD028058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab0CXV36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 17:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, n-horiguchi@ah.jp.nec.com


The patch titled
     mincore: cleanups
has been added to the -mm tree.  Its filename is
     mincore-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mincore: cleanups
From: Johannes Weiner <hannes@cmpxchg.org>

This fixes some minor issues that bugged me while going over the code:

o adjust argument order of do_mincore() to match the syscall
o simplify range length calculation
o drop superfluous shift in huge tlb calculation, address is page aligned
o drop dead nr_huge calculation
o check pte_none() before pte_present()
o comment and whitespace fixes

No semantic changes intended.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   76 +++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff -puN mm/mincore.c~mincore-cleanups mm/mincore.c
--- a/mm/mincore.c~mincore-cleanups
+++ a/mm/mincore.c
@@ -54,7 +54,7 @@ static unsigned char mincore_page(struct
  * all the arguments, we hold the mmap semaphore: we should
  * just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages)
+static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -64,35 +64,29 @@ static long do_mincore(unsigned long add
 	unsigned long nr;
 	int i;
 	pgoff_t pgoff;
-	struct vm_area_struct *vma = find_vma(current->mm, addr);
+	struct vm_area_struct *vma;
 
-	/*
-	 * find_vma() didn't find anything above us, or we're
-	 * in an unmapped hole in the address space: ENOMEM.
-	 */
+	vma = find_vma(current->mm, addr);
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
 
+	nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (is_vm_hugetlb_page(vma)) {
 		struct hstate *h;
-		unsigned long nr_huge;
-		unsigned char present;
 
 		i = 0;
-		nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
 		h = hstate_vma(vma);
-		nr_huge = ((addr + pages * PAGE_SIZE - 1) >> huge_page_shift(h))
-			  - (addr >> huge_page_shift(h)) + 1;
-		nr_huge = min(nr_huge,
-			      (vma->vm_end - addr) >> huge_page_shift(h));
 		while (1) {
-			/* hugepage always in RAM for now,
-			 * but generally it needs to be check */
+			unsigned char present;
+			/*
+			 * Huge pages are always in RAM for now, but
+			 * theoretically it needs to be checked.
+			 */
 			ptep = huge_pte_offset(current->mm,
 					       addr & huge_page_mask(h));
-			present = !!(ptep &&
-				     !huge_pte_none(huge_ptep_get(ptep)));
+			present = ptep && !huge_pte_none(huge_ptep_get(ptep));
 			while (1) {
 				vec[i++] = present;
 				addr += PAGE_SIZE;
@@ -100,8 +94,7 @@ static long do_mincore(unsigned long add
 				if (i == nr)
 					return nr;
 				/* check hugepage border */
-				if (!((addr & ~huge_page_mask(h))
-				      >> PAGE_SHIFT))
+				if (!(addr & ~huge_page_mask(h)))
 					break;
 			}
 		}
@@ -113,17 +106,7 @@ static long do_mincore(unsigned long add
 	 * Calculate how many pages there are left in the last level of the
 	 * PTE array for our address.
 	 */
-	nr = PTRS_PER_PTE - ((addr >> PAGE_SHIFT) & (PTRS_PER_PTE-1));
-
-	/*
-	 * Don't overrun this vma
-	 */
-	nr = min(nr, (vma->vm_end - addr) >> PAGE_SHIFT);
-
-	/*
-	 * Don't return more than the caller asked for
-	 */
-	nr = min(nr, pages);
+	nr = min(nr, PTRS_PER_PTE - ((addr >> PAGE_SHIFT) & (PTRS_PER_PTE-1)));
 
 	pgd = pgd_offset(vma->vm_mm, addr);
 	if (pgd_none_or_clear_bad(pgd))
@@ -137,43 +120,38 @@ static long do_mincore(unsigned long add
 
 	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE) {
-		unsigned char present;
 		pte_t pte = *ptep;
 
-		if (pte_present(pte)) {
-			present = 1;
-
-		} else if (pte_none(pte)) {
+		if (pte_none(pte)) {
 			if (vma->vm_file) {
 				pgoff = linear_page_index(vma, addr);
-				present = mincore_page(vma->vm_file->f_mapping,
-							pgoff);
+				vec[i] = mincore_page(vma->vm_file->f_mapping,
+						pgoff);
 			} else
-				present = 0;
-
-		} else if (pte_file(pte)) {
+				vec[i] = 0;
+		} else if (pte_present(pte))
+			vec[i] = 1;
+		else if (pte_file(pte)) {
 			pgoff = pte_to_pgoff(pte);
-			present = mincore_page(vma->vm_file->f_mapping, pgoff);
-
+			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
 		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
+
 			if (is_migration_entry(entry)) {
 				/* migration entries are always uptodate */
-				present = 1;
+				vec[i] = 1;
 			} else {
 #ifdef CONFIG_SWAP
 				pgoff = entry.val;
-				present = mincore_page(&swapper_space, pgoff);
+				vec[i] = mincore_page(&swapper_space, pgoff);
 #else
 				WARN_ON(1);
-				present = 1;
+				vec[i] = 1;
 #endif
 			}
 		}
-
-		vec[i] = present;
 	}
-	pte_unmap_unlock(ptep-1, ptl);
+	pte_unmap_unlock(ptep - 1, ptl);
 
 	return nr;
 
@@ -247,7 +225,7 @@ SYSCALL_DEFINE3(mincore, unsigned long, 
 		 * the temporary buffer size.
 		 */
 		down_read(&current->mm->mmap_sem);
-		retval = do_mincore(start, tmp, min(pages, PAGE_SIZE));
+		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
 		up_read(&current->mm->mmap_sem);
 
 		if (retval <= 0)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch

