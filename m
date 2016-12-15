From: akpm@linux-foundation.org
Subject: [merged] mm-add-orig_pte-field-into-vm_fault.patch removed from
 -mm tree
Date: Thu, 15 Dec 2016 10:47:31 -0800
Message-ID: <5852e543.jeXF/yQCvV893bGg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756188AbcLOSrc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add orig_pte field into vm_fault
has been removed from the -mm tree.  Its filename was
     mm-add-orig_pte-field-into-vm_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: add orig_pte field into vm_fault

Add orig_pte field to vm_fault structure to allow ->page_mkwrite handlers
to fully handle the fault.  This also allows us to save some passing of
extra arguments around.

Link: http://lkml.kernel.org/r/1479460644-25076-8-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +-
 mm/internal.h      |    2 -
 mm/khugepaged.c    |    7 +--
 mm/memory.c        |   82 +++++++++++++++++++++----------------------
 4 files changed, 47 insertions(+), 48 deletions(-)

diff -puN include/linux/mm.h~mm-add-orig_pte-field-into-vm_fault include/linux/mm.h
--- a/include/linux/mm.h~mm-add-orig_pte-field-into-vm_fault
+++ a/include/linux/mm.h
@@ -298,8 +298,8 @@ struct vm_fault {
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	unsigned long address;		/* Faulting virtual address */
 	pmd_t *pmd;			/* Pointer to pmd entry matching
-					 * the 'address'
-					 */
+					 * the 'address' */
+	pte_t orig_pte;			/* Value of PTE at the time of fault */
 
 	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
diff -puN mm/internal.h~mm-add-orig_pte-field-into-vm_fault mm/internal.h
--- a/mm/internal.h~mm-add-orig_pte-field-into-vm_fault
+++ a/mm/internal.h
@@ -36,7 +36,7 @@
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
-int do_swap_page(struct vm_fault *vmf, pte_t orig_pte);
+int do_swap_page(struct vm_fault *vmf);
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
diff -puN mm/khugepaged.c~mm-add-orig_pte-field-into-vm_fault mm/khugepaged.c
--- a/mm/khugepaged.c~mm-add-orig_pte-field-into-vm_fault
+++ a/mm/khugepaged.c
@@ -875,7 +875,6 @@ static bool __collapse_huge_page_swapin(
 					unsigned long address, pmd_t *pmd,
 					int referenced)
 {
-	pte_t pteval;
 	int swapped_in = 0, ret = 0;
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -893,11 +892,11 @@ static bool __collapse_huge_page_swapin(
 	vmf.pte = pte_offset_map(pmd, address);
 	for (; vmf.address < address + HPAGE_PMD_NR*PAGE_SIZE;
 			vmf.pte++, vmf.address += PAGE_SIZE) {
-		pteval = *vmf.pte;
-		if (!is_swap_pte(pteval))
+		vmf.orig_pte = *vmf.pte;
+		if (!is_swap_pte(vmf.orig_pte))
 			continue;
 		swapped_in++;
-		ret = do_swap_page(&vmf, pteval);
+		ret = do_swap_page(&vmf);
 
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
 		if (ret & VM_FAULT_RETRY) {
diff -puN mm/memory.c~mm-add-orig_pte-field-into-vm_fault mm/memory.c
--- a/mm/memory.c~mm-add-orig_pte-field-into-vm_fault
+++ a/mm/memory.c
@@ -2070,8 +2070,8 @@ static int do_page_mkwrite(struct vm_are
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct vm_fault *vmf, pte_t orig_pte,
-			struct page *page, int page_mkwrite, int dirty_shared)
+static inline int wp_page_reuse(struct vm_fault *vmf, struct page *page,
+				int page_mkwrite, int dirty_shared)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -2084,8 +2084,8 @@ static inline int wp_page_reuse(struct v
 	if (page)
 		page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
 
-	flush_cache_page(vma, vmf->address, pte_pfn(orig_pte));
-	entry = pte_mkyoung(orig_pte);
+	flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
+	entry = pte_mkyoung(vmf->orig_pte);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
 		update_mmu_cache(vma, vmf->address, vmf->pte);
@@ -2135,8 +2135,7 @@ static inline int wp_page_reuse(struct v
  *   held to the old page, as well as updating the rmap.
  * - In any case, unlock the PTL and drop the reference we took to the old page.
  */
-static int wp_page_copy(struct vm_fault *vmf, pte_t orig_pte,
-		struct page *old_page)
+static int wp_page_copy(struct vm_fault *vmf, struct page *old_page)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -2150,7 +2149,7 @@ static int wp_page_copy(struct vm_fault
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 
-	if (is_zero_pfn(pte_pfn(orig_pte))) {
+	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
 		new_page = alloc_zeroed_user_highpage_movable(vma,
 							      vmf->address);
 		if (!new_page)
@@ -2174,7 +2173,7 @@ static int wp_page_copy(struct vm_fault
 	 * Re-check the pte - we dropped the lock
 	 */
 	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, vmf->address, &vmf->ptl);
-	if (likely(pte_same(*vmf->pte, orig_pte))) {
+	if (likely(pte_same(*vmf->pte, vmf->orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
 				dec_mm_counter_fast(mm,
@@ -2184,7 +2183,7 @@ static int wp_page_copy(struct vm_fault
 		} else {
 			inc_mm_counter_fast(mm, MM_ANONPAGES);
 		}
-		flush_cache_page(vma, vmf->address, pte_pfn(orig_pte));
+		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		/*
@@ -2268,7 +2267,7 @@ oom:
  * Handle write page faults for VM_MIXEDMAP or VM_PFNMAP for a VM_SHARED
  * mapping
  */
-static int wp_pfn_shared(struct vm_fault *vmf, pte_t orig_pte)
+static int wp_pfn_shared(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 
@@ -2286,16 +2285,15 @@ static int wp_pfn_shared(struct vm_fault
 		 * We might have raced with another page fault while we
 		 * released the pte_offset_map_lock.
 		 */
-		if (!pte_same(*vmf->pte, orig_pte)) {
+		if (!pte_same(*vmf->pte, vmf->orig_pte)) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;
 		}
 	}
-	return wp_page_reuse(vmf, orig_pte, NULL, 0, 0);
+	return wp_page_reuse(vmf, NULL, 0, 0);
 }
 
-static int wp_page_shared(struct vm_fault *vmf, pte_t orig_pte,
-		struct page *old_page)
+static int wp_page_shared(struct vm_fault *vmf, struct page *old_page)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -2321,7 +2319,7 @@ static int wp_page_shared(struct vm_faul
 		 */
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 						vmf->address, &vmf->ptl);
-		if (!pte_same(*vmf->pte, orig_pte)) {
+		if (!pte_same(*vmf->pte, vmf->orig_pte)) {
 			unlock_page(old_page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			put_page(old_page);
@@ -2330,7 +2328,7 @@ static int wp_page_shared(struct vm_faul
 		page_mkwrite = 1;
 	}
 
-	return wp_page_reuse(vmf, orig_pte, old_page, page_mkwrite, 1);
+	return wp_page_reuse(vmf, old_page, page_mkwrite, 1);
 }
 
 /*
@@ -2351,13 +2349,13 @@ static int wp_page_shared(struct vm_faul
  * but allow concurrent faults), with pte both mapped and locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
-static int do_wp_page(struct vm_fault *vmf, pte_t orig_pte)
+static int do_wp_page(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *old_page;
 
-	old_page = vm_normal_page(vma, vmf->address, orig_pte);
+	old_page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
 	if (!old_page) {
 		/*
 		 * VM_MIXEDMAP !pfn_valid() case, or VM_SOFTDIRTY clear on a
@@ -2368,10 +2366,10 @@ static int do_wp_page(struct vm_fault *v
 		 */
 		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 				     (VM_WRITE|VM_SHARED))
-			return wp_pfn_shared(vmf, orig_pte);
+			return wp_pfn_shared(vmf);
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return wp_page_copy(vmf, orig_pte, old_page);
+		return wp_page_copy(vmf, old_page);
 	}
 
 	/*
@@ -2386,7 +2384,7 @@ static int do_wp_page(struct vm_fault *v
 			lock_page(old_page);
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
-			if (!pte_same(*vmf->pte, orig_pte)) {
+			if (!pte_same(*vmf->pte, vmf->orig_pte)) {
 				unlock_page(old_page);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				put_page(old_page);
@@ -2406,12 +2404,12 @@ static int do_wp_page(struct vm_fault *v
 				page_move_anon_rmap(old_page, vma);
 			}
 			unlock_page(old_page);
-			return wp_page_reuse(vmf, orig_pte, old_page, 0, 0);
+			return wp_page_reuse(vmf, old_page, 0, 0);
 		}
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
-		return wp_page_shared(vmf, orig_pte, old_page);
+		return wp_page_shared(vmf, old_page);
 	}
 
 	/*
@@ -2420,7 +2418,7 @@ static int do_wp_page(struct vm_fault *v
 	get_page(old_page);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	return wp_page_copy(vmf, orig_pte, old_page);
+	return wp_page_copy(vmf, old_page);
 }
 
 static void unmap_mapping_range_vma(struct vm_area_struct *vma,
@@ -2508,7 +2506,7 @@ EXPORT_SYMBOL(unmap_mapping_range);
  * We return with the mmap_sem locked or unlocked in the same cases
  * as does filemap_fault().
  */
-int do_swap_page(struct vm_fault *vmf, pte_t orig_pte)
+int do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page, *swapcache;
@@ -2519,10 +2517,10 @@ int do_swap_page(struct vm_fault *vmf, p
 	int exclusive = 0;
 	int ret = 0;
 
-	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, orig_pte))
+	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte))
 		goto out;
 
-	entry = pte_to_swp_entry(orig_pte);
+	entry = pte_to_swp_entry(vmf->orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
 		if (is_migration_entry(entry)) {
 			migration_entry_wait(vma->vm_mm, vmf->pmd,
@@ -2530,7 +2528,7 @@ int do_swap_page(struct vm_fault *vmf, p
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
 		} else {
-			print_bad_pte(vma, vmf->address, orig_pte, NULL);
+			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
 			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
@@ -2547,7 +2545,7 @@ int do_swap_page(struct vm_fault *vmf, p
 			 */
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
-			if (likely(pte_same(*vmf->pte, orig_pte)))
+			if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
 				ret = VM_FAULT_OOM;
 			delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 			goto unlock;
@@ -2604,7 +2602,7 @@ int do_swap_page(struct vm_fault *vmf, p
 	 */
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
-	if (unlikely(!pte_same(*vmf->pte, orig_pte)))
+	if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte)))
 		goto out_nomap;
 
 	if (unlikely(!PageUptodate(page))) {
@@ -2632,9 +2630,10 @@ int do_swap_page(struct vm_fault *vmf, p
 		exclusive = RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
-	if (pte_swp_soft_dirty(orig_pte))
+	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	vmf->orig_pte = pte;
 	if (page == swapcache) {
 		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 		mem_cgroup_commit_charge(page, memcg, true, false);
@@ -2664,7 +2663,7 @@ int do_swap_page(struct vm_fault *vmf, p
 	}
 
 	if (vmf->flags & FAULT_FLAG_WRITE) {
-		ret |= do_wp_page(vmf, pte);
+		ret |= do_wp_page(vmf);
 		if (ret & VM_FAULT_ERROR)
 			ret &= VM_FAULT_ERROR;
 		goto out;
@@ -3363,7 +3362,7 @@ static int numa_migrate_prep(struct page
 	return mpol_misplaced(page, vma, addr);
 }
 
-static int do_numa_page(struct vm_fault *vmf, pte_t pte)
+static int do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL;
@@ -3371,6 +3370,7 @@ static int do_numa_page(struct vm_fault
 	int last_cpupid;
 	int target_nid;
 	bool migrated = false;
+	pte_t pte = vmf->orig_pte;
 	bool was_writable = pte_write(pte);
 	int flags = 0;
 
@@ -3521,8 +3521,7 @@ static int handle_pte_fault(struct vm_fa
 		 * So now it's safe to run pte_offset_map().
 		 */
 		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
-
-		entry = *vmf->pte;
+		vmf->orig_pte = *vmf->pte;
 
 		/*
 		 * some architectures can have larger ptes than wordsize,
@@ -3533,7 +3532,7 @@ static int handle_pte_fault(struct vm_fa
 		 * ptl lock held. So here a barrier will do.
 		 */
 		barrier();
-		if (pte_none(entry)) {
+		if (pte_none(vmf->orig_pte)) {
 			pte_unmap(vmf->pte);
 			vmf->pte = NULL;
 		}
@@ -3546,19 +3545,20 @@ static int handle_pte_fault(struct vm_fa
 			return do_fault(vmf);
 	}
 
-	if (!pte_present(entry))
-		return do_swap_page(vmf, entry);
+	if (!pte_present(vmf->orig_pte))
+		return do_swap_page(vmf);
 
-	if (pte_protnone(entry) && vma_is_accessible(vmf->vma))
-		return do_numa_page(vmf, entry);
+	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
+		return do_numa_page(vmf);
 
 	vmf->ptl = pte_lockptr(vmf->vma->vm_mm, vmf->pmd);
 	spin_lock(vmf->ptl);
+	entry = vmf->orig_pte;
 	if (unlikely(!pte_same(*vmf->pte, entry)))
 		goto unlock;
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))
-			return do_wp_page(vmf, entry);
+			return do_wp_page(vmf);
 		entry = pte_mkdirty(entry);
 	}
 	entry = pte_mkyoung(entry);
_

Patches currently in -mm which might be from jack@suse.cz are


