From: akpm@linux-foundation.org
Subject: - x86-support-gb-hugepages-on-64-bit.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:22 -0700
Message-ID: <200807242323.m6ONNMFh010659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYGXXXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86: support GB hugepages on 64-bit
has been removed from the -mm tree.  Its filename was
     x86-support-gb-hugepages-on-64-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

