From: akpm@linux-foundation.org
Subject: - mm-dirty-page-tracking-race-fix.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:48 -0700
Message-ID: <200808210349.m7L3nmGq015665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbYHUDuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, cotte@freenet.de, hugh@veritas.com, jaredeh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: dirty page tracking race fix
has been removed from the -mm tree.  Its filename was
     mm-dirty-page-tracking-race-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: dirty page tracking race fix
From: Nick Piggin <npiggin@suse.de>

There is a race with dirty page accounting where a page may not properly
be accounted for.

clear_page_dirty_for_io() calls page_mkclean; then TestClearPageDirty.

page_mkclean walks the rmaps for that page, and for each one it cleans and
write protects the pte if it was dirty.  It uses page_check_address to
find the pte.  That function has a shortcut to avoid the ptl if the pte is
not present.  Unfortunately, the pte can be switched to not-present then
back to present by other code while holding the page table lock -- this
should not be a signal for page_mkclean to ignore that pte, because it may
be dirty.

For example, powerpc64's set_pte_at will clear a previously present pte
before setting it to the desired value.  There may also be other code in
core mm or in arch which do similar things.

The consequence of the bug is loss of data integrity due to msync, and
loss of dirty page accounting accuracy.  XIP's __xip_unmap could easily
also be unreliable (depending on the exact XIP locking scheme), which can
lead to data corruption.

Fix this by having an option to always take ptl to check the pte in
page_check_address.

It's possible to retain this optimization for page_referenced and
try_to_unmap.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Carsten Otte <cotte@freenet.de>
Cc: Hugh Dickins <hugh@veritas.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/filemap_xip.c     |    2 +-
 mm/rmap.c            |   14 +++++++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff -puN include/linux/rmap.h~mm-dirty-page-tracking-race-fix include/linux/rmap.h
--- a/include/linux/rmap.h~mm-dirty-page-tracking-race-fix
+++ a/include/linux/rmap.h
@@ -102,7 +102,7 @@ int try_to_unmap(struct page *, int igno
  * Called from mm/filemap_xip.c to unmap empty zero page
  */
 pte_t *page_check_address(struct page *, struct mm_struct *,
-				unsigned long, spinlock_t **);
+				unsigned long, spinlock_t **, int);
 
 /*
  * Used by swapoff to help locate where page is expected in vma.
diff -puN mm/filemap_xip.c~mm-dirty-page-tracking-race-fix mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-dirty-page-tracking-race-fix
+++ a/mm/filemap_xip.c
@@ -185,7 +185,7 @@ __xip_unmap (struct address_space * mapp
 		address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-		pte = page_check_address(page, mm, address, &ptl);
+		pte = page_check_address(page, mm, address, &ptl, 1);
 		if (pte) {
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
diff -puN mm/rmap.c~mm-dirty-page-tracking-race-fix mm/rmap.c
--- a/mm/rmap.c~mm-dirty-page-tracking-race-fix
+++ a/mm/rmap.c
@@ -224,10 +224,14 @@ unsigned long page_address_in_vma(struct
 /*
  * Check that @page is mapped at @address into @mm.
  *
+ * If @sync is false, page_check_address may perform a racy check to avoid
+ * the page table lock when the pte is not present (helpful when reclaiming
+ * highly shared pages).
+ *
  * On success returns with pte mapped and locked.
  */
 pte_t *page_check_address(struct page *page, struct mm_struct *mm,
-			  unsigned long address, spinlock_t **ptlp)
+			  unsigned long address, spinlock_t **ptlp, int sync)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -249,7 +253,7 @@ pte_t *page_check_address(struct page *p
 
 	pte = pte_offset_map(pmd, address);
 	/* Make a quick check before getting the lock */
-	if (!pte_present(*pte)) {
+	if (!sync && !pte_present(*pte)) {
 		pte_unmap(pte);
 		return NULL;
 	}
@@ -281,7 +285,7 @@ static int page_referenced_one(struct pa
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
 
@@ -450,7 +454,7 @@ static int page_mkclean_one(struct page 
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page, mm, address, &ptl, 1);
 	if (!pte)
 		goto out;
 
@@ -704,7 +708,7 @@ static int try_to_unmap_one(struct page 
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

