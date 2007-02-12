From: akpm@linux-foundation.org
Subject: - mm-mincore-anon.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:42:52 -0800
Message-ID: <200702122242.l1CMgqwO013454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030227AbXBLWm7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:42:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm: mincore anon
has been removed from the -mm tree.  Its filename was
     mm-mincore-anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: mincore anon
From: Nick Piggin <npiggin@suse.de>

Make mincore work for anon mappings, nonlinear, and migration entries.
Based on patch from Linus Torvalds <torvalds@linux-foundation.org>.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |  102 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 76 insertions(+), 26 deletions(-)

diff -puN mm/mincore.c~mm-mincore-anon mm/mincore.c
--- a/mm/mincore.c~mm-mincore-anon
+++ a/mm/mincore.c
@@ -12,6 +12,8 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/syscalls.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -22,14 +24,22 @@
  * and is up to date; i.e. that no page-in operation would be required
  * at this time if an application were to map and access this page.
  */
-static unsigned char mincore_page(struct vm_area_struct * vma,
-	unsigned long pgoff)
+static unsigned char mincore_page(struct address_space *mapping, pgoff_t pgoff)
 {
 	unsigned char present = 0;
-	struct address_space * as = vma->vm_file->f_mapping;
-	struct page * page;
+	struct page *page;
 
-	page = find_get_page(as, pgoff);
+	/*
+	 * When tmpfs swaps out a page from a file, any process mapping that
+	 * file will not get a swp_entry_t in its pte, but rather it is like
+	 * any other file mapping (ie. marked !present and faulted in with
+	 * tmpfs's .nopage). So swapped out tmpfs mappings are tested here.
+	 *
+	 * However when tmpfs moves the page from pagecache and into swapcache,
+	 * it is still in core, but the find_get_page below won't find it.
+	 * No big deal, but make a note of it.
+	 */
+	page = find_get_page(mapping, pgoff);
 	if (page) {
 		present = PageUptodate(page);
 		page_cache_release(page);
@@ -45,7 +55,14 @@ static unsigned char mincore_page(struct
  */
 static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages)
 {
-	unsigned long i, nr, pgoff;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep;
+	spinlock_t *ptl;
+	unsigned long nr;
+	int i;
+	pgoff_t pgoff;
 	struct vm_area_struct *vma = find_vma(current->mm, addr);
 
 	/*
@@ -56,31 +73,64 @@ static long do_mincore(unsigned long add
 		return -ENOMEM;
 
 	/*
-	 * Ok, got it. But check whether it's a segment we support
-	 * mincore() on. Right now, we don't do any anonymous mappings.
-	 *
-	 * FIXME: This is just stupid. And returning ENOMEM is 
-	 * stupid too. We should just look at the page tables. But
-	 * this is what we've traditionally done, so we'll just
-	 * continue doing it.
+	 * Calculate how many pages there are left in the last level of the
+	 * PTE array for our address.
 	 */
-	if (!vma->vm_file)
-		return -ENOMEM;
-
-	/*
-	 * Calculate how many pages there are left in the vma, and
-	 * what the pgoff is for our address.
-	 */
-	nr = (vma->vm_end - addr) >> PAGE_SHIFT;
+	nr = PTRS_PER_PTE - ((addr >> PAGE_SHIFT) & (PTRS_PER_PTE-1));
 	if (nr > pages)
 		nr = pages;
 
-	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
-	pgoff += vma->vm_pgoff;
+	pgd = pgd_offset(vma->vm_mm, addr);
+	if (pgd_none_or_clear_bad(pgd))
+		goto none_mapped;
+	pud = pud_offset(pgd, addr);
+	if (pud_none_or_clear_bad(pud))
+		goto none_mapped;
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none_or_clear_bad(pmd))
+		goto none_mapped;
+
+	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE) {
+		unsigned char present;
+		pte_t pte = *ptep;
+
+		if (pte_present(pte)) {
+			present = 1;
+
+		} else if (pte_none(pte)) {
+			if (vma->vm_file) {
+				pgoff = linear_page_index(vma, addr);
+				present = mincore_page(vma->vm_file->f_mapping,
+							pgoff);
+			} else
+				present = 0;
+
+		} else if (pte_file(pte)) {
+			pgoff = pte_to_pgoff(pte);
+			present = mincore_page(vma->vm_file->f_mapping, pgoff);
+
+		} else { /* pte is a swap entry */
+			swp_entry_t entry = pte_to_swp_entry(pte);
+			if (is_migration_entry(entry)) {
+				/* migration entries are always uptodate */
+				present = 1;
+			} else {
+				pgoff = entry.val;
+				present = mincore_page(&swapper_space, pgoff);
+			}
+		}
+	}
+	pte_unmap_unlock(ptep-1, ptl);
+
+	return nr;
 
-	/* And then we just fill the sucker in.. */
-	for (i = 0 ; i < nr; i++, pgoff++)
-		vec[i] = mincore_page(vma, pgoff);
+none_mapped:
+	if (vma->vm_file) {
+		pgoff = linear_page_index(vma, addr);
+		for (i = 0; i < nr; i++, pgoff++)
+			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
+	}
 
 	return nr;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
