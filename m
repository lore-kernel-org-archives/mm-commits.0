From: akpm@linux-foundation.org
Subject: + mincore-break-do_mincore-into-logical-pieces.patch added to -mm tree
Date: Wed, 24 Mar 2010 14:29:43 -0700
Message-ID: <201003242129.o2OLThtA028061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab0CXV37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 17:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, n-horiguchi@ah.jp.nec.com


The patch titled
     mincore: break do_mincore() into logical pieces
has been added to the -mm tree.  Its filename is
     mincore-break-do_mincore-into-logical-pieces.patch

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
Subject: mincore: break do_mincore() into logical pieces
From: Johannes Weiner <hannes@cmpxchg.org>

Split out functions to handle hugetlb ranges, pte ranges and unmapped
ranges, to improve readability but also to prepare the file structure for
nested page table walks.

No semantic changes intended.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |  171 +++++++++++++++++++++++++++----------------------
 1 file changed, 97 insertions(+), 74 deletions(-)

diff -puN mm/mincore.c~mincore-break-do_mincore-into-logical-pieces mm/mincore.c
--- a/mm/mincore.c~mincore-break-do_mincore-into-logical-pieces
+++ a/mm/mincore.c
@@ -19,6 +19,42 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
+static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
+				unsigned long addr, unsigned long nr,
+				unsigned char *vec)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	struct hstate *h;
+	int i;
+
+	i = 0;
+	h = hstate_vma(vma);
+	while (1) {
+		unsigned char present;
+		pte_t *ptep;
+		/*
+		 * Huge pages are always in RAM for now, but
+		 * theoretically it needs to be checked.
+		 */
+		ptep = huge_pte_offset(current->mm,
+				       addr & huge_page_mask(h));
+		present = ptep && !huge_pte_none(huge_ptep_get(ptep));
+		while (1) {
+			vec[i++] = present;
+			addr += PAGE_SIZE;
+			/* reach buffer limit */
+			if (i == nr)
+				return;
+			/* check hugepage border */
+			if (!(addr & ~huge_page_mask(h)))
+				break;
+		}
+	}
+#else
+	BUG();
+#endif
+}
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -49,6 +85,64 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
+static void mincore_unmapped_range(struct vm_area_struct *vma,
+				unsigned long addr, unsigned long nr,
+				unsigned char *vec)
+{
+	int i;
+
+	if (vma->vm_file) {
+		pgoff_t pgoff;
+
+		pgoff = linear_page_index(vma, addr);
+		for (i = 0; i < nr; i++, pgoff++)
+			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
+	} else {
+		for (i = 0; i < nr; i++)
+			vec[i] = 0;
+	}
+}
+
+static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, unsigned long nr,
+			unsigned char *vec)
+{
+	spinlock_t *ptl;
+	pte_t *ptep;
+	int i;
+
+	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE) {
+		pte_t pte = *ptep;
+		pgoff_t pgoff;
+
+		if (pte_none(pte))
+			mincore_unmapped_range(vma, addr, 1, vec);
+		else if (pte_present(pte))
+			vec[i] = 1;
+		else if (pte_file(pte)) {
+			pgoff = pte_to_pgoff(pte);
+			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
+		} else { /* pte is a swap entry */
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			if (is_migration_entry(entry)) {
+				/* migration entries are always uptodate */
+				vec[i] = 1;
+			} else {
+#ifdef CONFIG_SWAP
+				pgoff = entry.val;
+				vec[i] = mincore_page(&swapper_space, pgoff);
+#else
+				WARN_ON(1);
+				vec[i] = 1;
+#endif
+			}
+		}
+	}
+	pte_unmap_unlock(ptep - 1, ptl);
+}
+
 /*
  * Do a chunk of "sys_mincore()". We've already checked
  * all the arguments, we hold the mmap semaphore: we should
@@ -59,11 +153,7 @@ static long do_mincore(unsigned long add
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *ptep;
-	spinlock_t *ptl;
 	unsigned long nr;
-	int i;
-	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 
 	vma = find_vma(current->mm, addr);
@@ -72,35 +162,10 @@ static long do_mincore(unsigned long add
 
 	nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
 
-#ifdef CONFIG_HUGETLB_PAGE
 	if (is_vm_hugetlb_page(vma)) {
-		struct hstate *h;
-
-		i = 0;
-		h = hstate_vma(vma);
-		while (1) {
-			unsigned char present;
-			/*
-			 * Huge pages are always in RAM for now, but
-			 * theoretically it needs to be checked.
-			 */
-			ptep = huge_pte_offset(current->mm,
-					       addr & huge_page_mask(h));
-			present = ptep && !huge_pte_none(huge_ptep_get(ptep));
-			while (1) {
-				vec[i++] = present;
-				addr += PAGE_SIZE;
-				/* reach buffer limit */
-				if (i == nr)
-					return nr;
-				/* check hugepage border */
-				if (!(addr & ~huge_page_mask(h)))
-					break;
-			}
-		}
+		mincore_hugetlb_page_range(vma, addr, nr, vec);
 		return nr;
 	}
-#endif
 
 	/*
 	 * Calculate how many pages there are left in the last level of the
@@ -118,53 +183,11 @@ static long do_mincore(unsigned long add
 	if (pmd_none_or_clear_bad(pmd))
 		goto none_mapped;
 
-	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE) {
-		pte_t pte = *ptep;
-
-		if (pte_none(pte)) {
-			if (vma->vm_file) {
-				pgoff = linear_page_index(vma, addr);
-				vec[i] = mincore_page(vma->vm_file->f_mapping,
-						pgoff);
-			} else
-				vec[i] = 0;
-		} else if (pte_present(pte))
-			vec[i] = 1;
-		else if (pte_file(pte)) {
-			pgoff = pte_to_pgoff(pte);
-			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
-		} else { /* pte is a swap entry */
-			swp_entry_t entry = pte_to_swp_entry(pte);
-
-			if (is_migration_entry(entry)) {
-				/* migration entries are always uptodate */
-				vec[i] = 1;
-			} else {
-#ifdef CONFIG_SWAP
-				pgoff = entry.val;
-				vec[i] = mincore_page(&swapper_space, pgoff);
-#else
-				WARN_ON(1);
-				vec[i] = 1;
-#endif
-			}
-		}
-	}
-	pte_unmap_unlock(ptep - 1, ptl);
-
+	mincore_pte_range(vma, pmd, addr, nr, vec);
 	return nr;
 
 none_mapped:
-	if (vma->vm_file) {
-		pgoff = linear_page_index(vma, addr);
-		for (i = 0; i < nr; i++, pgoff++)
-			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
-	} else {
-		for (i = 0; i < nr; i++)
-			vec[i] = 0;
-	}
