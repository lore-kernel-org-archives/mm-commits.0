From: akpm@linux-foundation.org
Subject: + mincore-pass-ranges-as-startend-address-pairs.patch added to -mm tree
Date: Wed, 24 Mar 2010 14:29:45 -0700
Message-ID: <201003242129.o2OLTj8o028064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab0CXVaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 17:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, n-horiguchi@ah.jp.nec.com


The patch titled
     mincore: pass ranges as start,end address pairs
has been added to the -mm tree.  Its filename is
     mincore-pass-ranges-as-startend-address-pairs.patch

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
Subject: mincore: pass ranges as start,end address pairs
From: Johannes Weiner <hannes@cmpxchg.org>

Instead of passing a start address and a number of pages into the helper
functions, convert them to use a start and an end address.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   57 +++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff -puN mm/mincore.c~mincore-pass-ranges-as-startend-address-pairs mm/mincore.c
--- a/mm/mincore.c~mincore-pass-ranges-as-startend-address-pairs
+++ a/mm/mincore.c
@@ -20,14 +20,12 @@
 #include <asm/pgtable.h>
 
 static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long nr,
+				unsigned long addr, unsigned long end,
 				unsigned char *vec)
 {
 #ifdef CONFIG_HUGETLB_PAGE
 	struct hstate *h;
-	int i;
 
-	i = 0;
 	h = hstate_vma(vma);
 	while (1) {
 		unsigned char present;
@@ -40,10 +38,10 @@ static void mincore_hugetlb_page_range(s
 				       addr & huge_page_mask(h));
 		present = ptep && !huge_pte_none(huge_ptep_get(ptep));
 		while (1) {
-			vec[i++] = present;
+			*vec = present;
+			vec++;
 			addr += PAGE_SIZE;
-			/* reach buffer limit */
-			if (i == nr)
+			if (addr == end)
 				return;
 			/* check hugepage border */
 			if (!(addr & ~huge_page_mask(h)))
@@ -86,9 +84,10 @@ static unsigned char mincore_page(struct
 }
 
 static void mincore_unmapped_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long nr,
+				unsigned long addr, unsigned long end,
 				unsigned char *vec)
 {
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
 
 	if (vma->vm_file) {
@@ -104,42 +103,44 @@ static void mincore_unmapped_range(struc
 }
 
 static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long nr,
+			unsigned long addr, unsigned long end,
 			unsigned char *vec)
 {
+	unsigned long next;
 	spinlock_t *ptl;
 	pte_t *ptep;
-	int i;
 
 	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE) {
+	do {
 		pte_t pte = *ptep;
 		pgoff_t pgoff;
 
+		next = addr + PAGE_SIZE;
 		if (pte_none(pte))
-			mincore_unmapped_range(vma, addr, 1, vec);
+			mincore_unmapped_range(vma, addr, next, vec);
 		else if (pte_present(pte))
-			vec[i] = 1;
+			*vec = 1;
 		else if (pte_file(pte)) {
 			pgoff = pte_to_pgoff(pte);
-			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
+			*vec = mincore_page(vma->vm_file->f_mapping, pgoff);
 		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (is_migration_entry(entry)) {
 				/* migration entries are always uptodate */
-				vec[i] = 1;
+				*vec = 1;
 			} else {
 #ifdef CONFIG_SWAP
 				pgoff = entry.val;
-				vec[i] = mincore_page(&swapper_space, pgoff);
+				*vec = mincore_page(&swapper_space, pgoff);
 #else
 				WARN_ON(1);
-				vec[i] = 1;
+				*vec = 1;
 #endif
 			}
 		}
-	}
+		vec++;
+	} while (ptep++, addr = next, addr != end);
 	pte_unmap_unlock(ptep - 1, ptl);
 }
 
@@ -153,25 +154,21 @@ static long do_mincore(unsigned long add
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	unsigned long nr;
 	struct vm_area_struct *vma;
+	unsigned long end;
 
 	vma = find_vma(current->mm, addr);
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
 
-	nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
+	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 
 	if (is_vm_hugetlb_page(vma)) {
-		mincore_hugetlb_page_range(vma, addr, nr, vec);
-		return nr;
+		mincore_hugetlb_page_range(vma, addr, end, vec);
+		return (end - addr) >> PAGE_SHIFT;
 	}
 
-	/*
-	 * Calculate how many pages there are left in the last level of the
-	 * PTE array for our address.
-	 */
-	nr = min(nr, PTRS_PER_PTE - ((addr >> PAGE_SHIFT) & (PTRS_PER_PTE-1)));
+	end = pmd_addr_end(addr, end);
 
 	pgd = pgd_offset(vma->vm_mm, addr);
 	if (pgd_none_or_clear_bad(pgd))
@@ -183,12 +180,12 @@ static long do_mincore(unsigned long add
 	if (pmd_none_or_clear_bad(pmd))
 		goto none_mapped;
 
-	mincore_pte_range(vma, pmd, addr, nr, vec);
-	return nr;
+	mincore_pte_range(vma, pmd, addr, end, vec);
+	return (end - addr) >> PAGE_SHIFT;
 
 none_mapped:
-	mincore_unmapped_range(vma, addr, nr, vec);
-	return nr;
+	mincore_unmapped_range(vma, addr, end, vec);
+	return (end - addr) >> PAGE_SHIFT;
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch

