From: akpm@linux-foundation.org
Subject: - mm-remove-nopfn.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:42 -0700
Message-ID: <200807242321.m6ONLgU0010416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbYGXXVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove nopfn
has been removed from the -mm tree.  Its filename was
     mm-remove-nopfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove nopfn
From: Nick Piggin <npiggin@suse.de>

There are no users of nopfn in the tree. Remove it.

[hugh@veritas.com: fix build error]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 -----
 mm/memory.c        |   67 ++++---------------------------------------
 2 files changed, 7 insertions(+), 69 deletions(-)

diff -puN include/linux/mm.h~mm-remove-nopfn include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-nopfn
+++ a/include/linux/mm.h
@@ -166,8 +166,6 @@ struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
-	unsigned long (*nopfn)(struct vm_area_struct *area,
-			unsigned long address);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
@@ -675,13 +673,6 @@ static inline int page_mapped(struct pag
 }
 
 /*
- * Error return values for the *_nopfn functions
- */
-#define NOPFN_SIGBUS	((unsigned long) -1)
-#define NOPFN_OOM	((unsigned long) -2)
-#define NOPFN_REFAULT	((unsigned long) -3)
-
-/*
  * Different kinds of faults, as returned by handle_mm_fault().
  * Used to decide whether a process gets delivered SIGBUS or
  * just gets major/minor fault counters bumped up.
diff -puN mm/memory.c~mm-remove-nopfn mm/memory.c
--- a/mm/memory.c~mm-remove-nopfn
+++ a/mm/memory.c
@@ -1058,11 +1058,9 @@ static inline int use_zero_page(struct v
 	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
 		return 0;
 	/*
-	 * And if we have a fault or a nopfn routine, it's not an
-	 * anonymous region.
+	 * And if we have a fault routine, it's not an anonymous region.
 	 */
-	return !vma->vm_ops ||
-		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
+	return !vma->vm_ops || !vma->vm_ops->fault;
 }
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
@@ -1338,6 +1336,11 @@ out:
  *
  * This function should only be called from a vm_ops->fault handler, and
  * in that case the handler should return NULL.
+ *
+ * vma cannot be a COW mapping.
+ *
+ * As this is called only for pages that do not currently exist, we
+ * do not need to flush old virtual caches or the TLB.
  */
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn)
@@ -2501,59 +2504,6 @@ static int do_linear_fault(struct mm_str
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-
-/*
- * do_no_pfn() tries to create a new page mapping for a page without
- * a struct_page backing it
- *
- * As this is called only for pages that do not currently exist, we
- * do not need to flush old virtual caches or the TLB.
- *
- * We enter with non-exclusive mmap_sem (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_sem still held, but pte unmapped and unlocked.
- *
- * It is expected that the ->nopfn handler always returns the same pfn
- * for a given virtual mapping.
- *
- * Mark this `noinline' to prevent it from bloating the main pagefault code.
- */
-static noinline int do_no_pfn(struct mm_struct *mm, struct vm_area_struct *vma,
-		     unsigned long address, pte_t *page_table, pmd_t *pmd,
-		     int write_access)
-{
-	spinlock_t *ptl;
-	pte_t entry;
-	unsigned long pfn;
-
-	pte_unmap(page_table);
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-
-	pfn = vma->vm_ops->nopfn(vma, address & PAGE_MASK);
-
-	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
-
-	if (unlikely(pfn == NOPFN_OOM))
-		return VM_FAULT_OOM;
-	else if (unlikely(pfn == NOPFN_SIGBUS))
-		return VM_FAULT_SIGBUS;
-	else if (unlikely(pfn == NOPFN_REFAULT))
-		return 0;
-
-	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-
-	/* Only go through if we didn't race with anybody else... */
-	if (pte_none(*page_table)) {
-		entry = pfn_pte(pfn, vma->vm_page_prot);
-		if (write_access)
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		set_pte_at(mm, address, page_table, entry);
-	}
-	pte_unmap_unlock(page_table, ptl);
-	return 0;
-}
-
 /*
  * Fault of a previously existing named mapping. Repopulate the pte
  * from the encoded file_pte if possible. This enables swappable
@@ -2614,9 +2564,6 @@ static inline int handle_pte_fault(struc
 				if (likely(vma->vm_ops->fault))
 					return do_linear_fault(mm, vma, address,
 						pte, pmd, write_access, entry);
-				if (unlikely(vma->vm_ops->nopfn))
-					return do_no_pfn(mm, vma, address, pte,
-							 pmd, write_access);
 			}
 			return do_anonymous_page(mm, vma, address,
 						 pte, pmd, write_access);
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

