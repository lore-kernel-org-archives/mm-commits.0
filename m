From: akpm@linux-foundation.org
Subject: [merged] mm-join-struct-fault_env-and-vm_fault.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:15 -0800
Message-ID: <5852e533.bQBYgf5rP3KCl+Dz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48940 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756359AbcLOSrV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: join struct fault_env and vm_fault
has been removed from the -mm tree.  Its filename was
     mm-join-struct-fault_env-and-vm_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: join struct fault_env and vm_fault

Currently we have two different structures for passing fault information
around - struct vm_fault and struct fault_env.  DAX will need more
information in struct vm_fault to handle its faults so the content of that
structure would become event closer to fault_env.  Furthermore it would
need to generate struct fault_env to be able to call some of the generic
functions.  So at this point I don't think there's much use in keeping
these two structures separate.  Just embed into struct vm_fault all that
is needed to use it for both purposes.

Link: http://lkml.kernel.org/r/1479460644-25076-2-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 
 fs/userfaultfd.c                  |   22 -
 include/linux/huge_mm.h           |   10 
 include/linux/mm.h                |   28 -
 include/linux/userfaultfd_k.h     |    4 
 mm/filemap.c                      |   14 
 mm/huge_memory.c                  |  173 ++++----
 mm/internal.h                     |    2 
 mm/khugepaged.c                   |   20 
 mm/memory.c                       |  568 ++++++++++++++--------------
 mm/nommu.c                        |    2 
 11 files changed, 423 insertions(+), 422 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-join-struct-fault_env-and-vm_fault Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-join-struct-fault_env-and-vm_fault
+++ a/Documentation/filesystems/Locking
@@ -556,7 +556,7 @@ till "end_pgoff". ->map_pages() is calle
 not block.  If it's not possible to reach a page without blocking,
 filesystem should skip it. Filesystem should use do_set_pte() to setup
 page table entry. Pointer to entry associated with the page is passed in
-"pte" field in fault_env structure. Pointers to entries for other offsets
+"pte" field in vm_fault structure. Pointers to entries for other offsets
 should be calculated relative to "pte".
 
 	->page_mkwrite() is called when a previously read-only pte is
diff -puN fs/userfaultfd.c~mm-join-struct-fault_env-and-vm_fault fs/userfaultfd.c
--- a/fs/userfaultfd.c~mm-join-struct-fault_env-and-vm_fault
+++ a/fs/userfaultfd.c
@@ -257,9 +257,9 @@ out:
  * fatal_signal_pending()s, and the mmap_sem must be released before
  * returning it.
  */
-int handle_userfault(struct fault_env *fe, unsigned long reason)
+int handle_userfault(struct vm_fault *vmf, unsigned long reason)
 {
-	struct mm_struct *mm = fe->vma->vm_mm;
+	struct mm_struct *mm = vmf->vma->vm_mm;
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue uwq;
 	int ret;
@@ -268,7 +268,7 @@ int handle_userfault(struct fault_env *f
 	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
 	ret = VM_FAULT_SIGBUS;
-	ctx = fe->vma->vm_userfaultfd_ctx.ctx;
+	ctx = vmf->vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx)
 		goto out;
 
@@ -301,17 +301,18 @@ int handle_userfault(struct fault_env *f
 	 * without first stopping userland access to the memory. For
 	 * VM_UFFD_MISSING userfaults this is enough for now.
 	 */
-	if (unlikely(!(fe->flags & FAULT_FLAG_ALLOW_RETRY))) {
+	if (unlikely(!(vmf->flags & FAULT_FLAG_ALLOW_RETRY))) {
 		/*
 		 * Validate the invariant that nowait must allow retry
 		 * to be sure not to return SIGBUS erroneously on
 		 * nowait invocations.
 		 */
-		BUG_ON(fe->flags & FAULT_FLAG_RETRY_NOWAIT);
+		BUG_ON(vmf->flags & FAULT_FLAG_RETRY_NOWAIT);
 #ifdef CONFIG_DEBUG_VM
 		if (printk_ratelimit()) {
 			printk(KERN_WARNING
-			       "FAULT_FLAG_ALLOW_RETRY missing %x\n", fe->flags);
+			       "FAULT_FLAG_ALLOW_RETRY missing %x\n",
+			       vmf->flags);
 			dump_stack();
 		}
 #endif
@@ -323,7 +324,7 @@ int handle_userfault(struct fault_env *f
 	 * and wait.
 	 */
 	ret = VM_FAULT_RETRY;
-	if (fe->flags & FAULT_FLAG_RETRY_NOWAIT)
+	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
 		goto out;
 
 	/* take the reference before dropping the mmap_sem */
@@ -331,11 +332,11 @@ int handle_userfault(struct fault_env *f
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(fe->address, fe->flags, reason);
+	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason);
 	uwq.ctx = ctx;
 
 	return_to_userland =
-		(fe->flags & (FAULT_FLAG_USER|FAULT_FLAG_KILLABLE)) ==
+		(vmf->flags & (FAULT_FLAG_USER|FAULT_FLAG_KILLABLE)) ==
 		(FAULT_FLAG_USER|FAULT_FLAG_KILLABLE);
 
 	spin_lock(&ctx->fault_pending_wqh.lock);
@@ -353,7 +354,8 @@ int handle_userfault(struct fault_env *f
 			  TASK_KILLABLE);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 
-	must_wait = userfaultfd_must_wait(ctx, fe->address, fe->flags, reason);
+	must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
+					  reason);
 	up_read(&mm->mmap_sem);
 
 	if (likely(must_wait && !ACCESS_ONCE(ctx->released) &&
diff -puN include/linux/huge_mm.h~mm-join-struct-fault_env-and-vm_fault include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-join-struct-fault_env-and-vm_fault
+++ a/include/linux/huge_mm.h
@@ -1,12 +1,12 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
-extern int do_huge_pmd_anonymous_page(struct fault_env *fe);
+extern int do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 			 struct vm_area_struct *vma);
-extern void huge_pmd_set_accessed(struct fault_env *fe, pmd_t orig_pmd);
-extern int do_huge_pmd_wp_page(struct fault_env *fe, pmd_t orig_pmd);
+extern void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
+extern int do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd);
 extern struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 					  unsigned long addr,
 					  pmd_t *pmd,
@@ -142,7 +142,7 @@ static inline int hpage_nr_pages(struct
 	return 1;
 }
 
-extern int do_huge_pmd_numa_page(struct fault_env *fe, pmd_t orig_pmd);
+extern int do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
 
@@ -212,7 +212,7 @@ static inline spinlock_t *pmd_trans_huge
 	return NULL;
 }
 
-static inline int do_huge_pmd_numa_page(struct fault_env *fe, pmd_t orig_pmd)
+static inline int do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	return 0;
 }
diff -puN include/linux/mm.h~mm-join-struct-fault_env-and-vm_fault include/linux/mm.h
--- a/include/linux/mm.h~mm-join-struct-fault_env-and-vm_fault
+++ a/include/linux/mm.h
@@ -292,10 +292,16 @@ extern pgprot_t protection_map[16];
  * pgoff should be used in favour of virtual_address, if possible.
  */
 struct vm_fault {
+	struct vm_area_struct *vma;	/* Target VMA */
 	unsigned int flags;		/* FAULT_FLAG_xxx flags */
 	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 	pgoff_t pgoff;			/* Logical page offset based on vma */
-	void __user *virtual_address;	/* Faulting virtual address */
+	unsigned long address;		/* Faulting virtual address */
+	void __user *virtual_address;	/* Faulting virtual address masked by
+					 * PAGE_MASK */
+	pmd_t *pmd;			/* Pointer to pmd entry matching
+					 * the 'address'
+					 */
 
 	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
@@ -309,19 +315,7 @@ struct vm_fault {
 					 * VM_FAULT_DAX_LOCKED and fill in
 					 * entry here.
 					 */
-};
-
-/*
- * Page fault context: passes though page fault handler instead of endless list
- * of function arguments.
- */
-struct fault_env {
-	struct vm_area_struct *vma;	/* Target VMA */
-	unsigned long address;		/* Faulting virtual address */
-	unsigned int flags;		/* FAULT_FLAG_xxx flags */
-	pmd_t *pmd;			/* Pointer to pmd entry matching
-					 * the 'address'
-					 */
+	/* These three entries are valid only while holding ptl lock */
 	pte_t *pte;			/* Pointer to pte entry matching
 					 * the 'address'. NULL if the page
 					 * table hasn't been allocated.
@@ -351,7 +345,7 @@ struct vm_operations_struct {
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
 	int (*pmd_fault)(struct vm_area_struct *, unsigned long address,
 						pmd_t *, unsigned int flags);
-	void (*map_pages)(struct fault_env *fe,
+	void (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
 
 	/* notification that a previously read-only page is about to become
@@ -625,7 +619,7 @@ static inline pte_t maybe_mkwrite(pte_t
 	return pte;
 }
 
-int alloc_set_pte(struct fault_env *fe, struct mem_cgroup *memcg,
+int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
 		struct page *page);
 #endif
 
@@ -2094,7 +2088,7 @@ extern void truncate_inode_pages_final(s
 
 /* generic vm_area_ops exported for stackable file systems */
 extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
-extern void filemap_map_pages(struct fault_env *fe,
+extern void filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff);
 extern int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 
diff -puN include/linux/userfaultfd_k.h~mm-join-struct-fault_env-and-vm_fault include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~mm-join-struct-fault_env-and-vm_fault
+++ a/include/linux/userfaultfd_k.h
@@ -27,7 +27,7 @@
 #define UFFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define UFFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS)
 
-extern int handle_userfault(struct fault_env *fe, unsigned long reason);
+extern int handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
 extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
 			    unsigned long src_start, unsigned long len);
@@ -55,7 +55,7 @@ static inline bool userfaultfd_armed(str
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
-static inline int handle_userfault(struct fault_env *fe, unsigned long reason)
+static inline int handle_userfault(struct vm_fault *vmf, unsigned long reason)
 {
 	return VM_FAULT_SIGBUS;
 }
diff -puN mm/filemap.c~mm-join-struct-fault_env-and-vm_fault mm/filemap.c
--- a/mm/filemap.c~mm-join-struct-fault_env-and-vm_fault
+++ a/mm/filemap.c
@@ -2164,12 +2164,12 @@ page_not_uptodate:
 }
 EXPORT_SYMBOL(filemap_fault);
 
-void filemap_map_pages(struct fault_env *fe,
+void filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
 	struct radix_tree_iter iter;
 	void **slot;
-	struct file *file = fe->vma->vm_file;
+	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	pgoff_t last_pgoff = start_pgoff;
 	loff_t size;
@@ -2225,11 +2225,11 @@ repeat:
 		if (file->f_ra.mmap_miss > 0)
 			file->f_ra.mmap_miss--;
 
-		fe->address += (iter.index - last_pgoff) << PAGE_SHIFT;
-		if (fe->pte)
-			fe->pte += iter.index - last_pgoff;
+		vmf->address += (iter.index - last_pgoff) << PAGE_SHIFT;
+		if (vmf->pte)
+			vmf->pte += iter.index - last_pgoff;
 		last_pgoff = iter.index;
-		if (alloc_set_pte(fe, NULL, page))
+		if (alloc_set_pte(vmf, NULL, page))
 			goto unlock;
 		unlock_page(page);
 		goto next;
@@ -2239,7 +2239,7 @@ skip:
 		put_page(page);
 next:
 		/* Huge page is mapped? No need to proceed. */
-		if (pmd_trans_huge(*fe->pmd))
+		if (pmd_trans_huge(*vmf->pmd))
 			break;
 		if (iter.index == end_pgoff)
 			break;
diff -puN mm/huge_memory.c~mm-join-struct-fault_env-and-vm_fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-join-struct-fault_env-and-vm_fault
+++ a/mm/huge_memory.c
@@ -542,13 +542,13 @@ unsigned long thp_get_unmapped_area(stru
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
-static int __do_huge_pmd_anonymous_page(struct fault_env *fe, struct page *page,
+static int __do_huge_pmd_anonymous_page(struct vm_fault *vmf, struct page *page,
 		gfp_t gfp)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
-	unsigned long haddr = fe->address & HPAGE_PMD_MASK;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
@@ -573,9 +573,9 @@ static int __do_huge_pmd_anonymous_page(
 	 */
 	__SetPageUptodate(page);
 
-	fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
-	if (unlikely(!pmd_none(*fe->pmd))) {
-		spin_unlock(fe->ptl);
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_none(*vmf->pmd))) {
+		spin_unlock(vmf->ptl);
 		mem_cgroup_cancel_charge(page, memcg, true);
 		put_page(page);
 		pte_free(vma->vm_mm, pgtable);
@@ -586,11 +586,11 @@ static int __do_huge_pmd_anonymous_page(
 		if (userfaultfd_missing(vma)) {
 			int ret;
 
-			spin_unlock(fe->ptl);
+			spin_unlock(vmf->ptl);
 			mem_cgroup_cancel_charge(page, memcg, true);
 			put_page(page);
 			pte_free(vma->vm_mm, pgtable);
-			ret = handle_userfault(fe, VM_UFFD_MISSING);
+			ret = handle_userfault(vmf, VM_UFFD_MISSING);
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			return ret;
 		}
@@ -600,11 +600,11 @@ static int __do_huge_pmd_anonymous_page(
 		page_add_new_anon_rmap(page, vma, haddr, true);
 		mem_cgroup_commit_charge(page, memcg, false, true);
 		lru_cache_add_active_or_unevictable(page, vma);
-		pgtable_trans_huge_deposit(vma->vm_mm, fe->pmd, pgtable);
-		set_pmd_at(vma->vm_mm, haddr, fe->pmd, entry);
+		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
+		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		atomic_long_inc(&vma->vm_mm->nr_ptes);
-		spin_unlock(fe->ptl);
+		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 	}
 
@@ -651,12 +651,12 @@ static bool set_huge_zero_page(pgtable_t
 	return true;
 }
 
-int do_huge_pmd_anonymous_page(struct fault_env *fe)
+int do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	gfp_t gfp;
 	struct page *page;
-	unsigned long haddr = fe->address & HPAGE_PMD_MASK;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 
 	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
 		return VM_FAULT_FALLBACK;
@@ -664,7 +664,7 @@ int do_huge_pmd_anonymous_page(struct fa
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 		return VM_FAULT_OOM;
-	if (!(fe->flags & FAULT_FLAG_WRITE) &&
+	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
@@ -680,22 +680,22 @@ int do_huge_pmd_anonymous_page(struct fa
 			count_vm_event(THP_FAULT_FALLBACK);
 			return VM_FAULT_FALLBACK;
 		}
-		fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
+		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
 		set = false;
-		if (pmd_none(*fe->pmd)) {
+		if (pmd_none(*vmf->pmd)) {
 			if (userfaultfd_missing(vma)) {
-				spin_unlock(fe->ptl);
-				ret = handle_userfault(fe, VM_UFFD_MISSING);
+				spin_unlock(vmf->ptl);
+				ret = handle_userfault(vmf, VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
 				set_huge_zero_page(pgtable, vma->vm_mm, vma,
-						   haddr, fe->pmd, zero_page);
-				spin_unlock(fe->ptl);
+						   haddr, vmf->pmd, zero_page);
+				spin_unlock(vmf->ptl);
 				set = true;
 			}
 		} else
-			spin_unlock(fe->ptl);
+			spin_unlock(vmf->ptl);
 		if (!set)
 			pte_free(vma->vm_mm, pgtable);
 		return ret;
@@ -707,7 +707,7 @@ int do_huge_pmd_anonymous_page(struct fa
 		return VM_FAULT_FALLBACK;
 	}
 	prep_transhuge_page(page);
-	return __do_huge_pmd_anonymous_page(fe, page, gfp);
+	return __do_huge_pmd_anonymous_page(vmf, page, gfp);
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
@@ -879,30 +879,30 @@ out:
 	return ret;
 }
 
-void huge_pmd_set_accessed(struct fault_env *fe, pmd_t orig_pmd)
+void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	pmd_t entry;
 	unsigned long haddr;
 
-	fe->ptl = pmd_lock(fe->vma->vm_mm, fe->pmd);
-	if (unlikely(!pmd_same(*fe->pmd, orig_pmd)))
+	vmf->ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
 		goto unlock;
 
 	entry = pmd_mkyoung(orig_pmd);
-	haddr = fe->address & HPAGE_PMD_MASK;
-	if (pmdp_set_access_flags(fe->vma, haddr, fe->pmd, entry,
-				fe->flags & FAULT_FLAG_WRITE))
-		update_mmu_cache_pmd(fe->vma, fe->address, fe->pmd);
+	haddr = vmf->address & HPAGE_PMD_MASK;
+	if (pmdp_set_access_flags(vmf->vma, haddr, vmf->pmd, entry,
+				vmf->flags & FAULT_FLAG_WRITE))
+		update_mmu_cache_pmd(vmf->vma, vmf->address, vmf->pmd);
 
 unlock:
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 }
 
-static int do_huge_pmd_wp_page_fallback(struct fault_env *fe, pmd_t orig_pmd,
+static int do_huge_pmd_wp_page_fallback(struct vm_fault *vmf, pmd_t orig_pmd,
 		struct page *page)
 {
-	struct vm_area_struct *vma = fe->vma;
-	unsigned long haddr = fe->address & HPAGE_PMD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
 	pmd_t _pmd;
@@ -921,7 +921,7 @@ static int do_huge_pmd_wp_page_fallback(
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE |
 					       __GFP_OTHER_NODE, vma,
-					       fe->address, page_to_nid(page));
+					       vmf->address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_try_charge(pages[i], vma->vm_mm,
 				     GFP_KERNEL, &memcg, false))) {
@@ -952,15 +952,15 @@ static int do_huge_pmd_wp_page_fallback(
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(vma->vm_mm, mmun_start, mmun_end);
 
-	fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
-	if (unlikely(!pmd_same(*fe->pmd, orig_pmd)))
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
 		goto out_free_pages;
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
-	pmdp_huge_clear_flush_notify(vma, haddr, fe->pmd);
+	pmdp_huge_clear_flush_notify(vma, haddr, vmf->pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = pgtable_trans_huge_withdraw(vma->vm_mm, fe->pmd);
+	pgtable = pgtable_trans_huge_withdraw(vma->vm_mm, vmf->pmd);
 	pmd_populate(vma->vm_mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -969,20 +969,20 @@ static int do_huge_pmd_wp_page_fallback(
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
-		page_add_new_anon_rmap(pages[i], fe->vma, haddr, false);
+		page_add_new_anon_rmap(pages[i], vmf->vma, haddr, false);
 		mem_cgroup_commit_charge(pages[i], memcg, false, false);
 		lru_cache_add_active_or_unevictable(pages[i], vma);
-		fe->pte = pte_offset_map(&_pmd, haddr);
-		VM_BUG_ON(!pte_none(*fe->pte));
-		set_pte_at(vma->vm_mm, haddr, fe->pte, entry);
-		pte_unmap(fe->pte);
+		vmf->pte = pte_offset_map(&_pmd, haddr);
+		VM_BUG_ON(!pte_none(*vmf->pte));
+		set_pte_at(vma->vm_mm, haddr, vmf->pte, entry);
+		pte_unmap(vmf->pte);
 	}
 	kfree(pages);
 
 	smp_wmb(); /* make pte visible before pmd */
-	pmd_populate(vma->vm_mm, fe->pmd, pgtable);
+	pmd_populate(vma->vm_mm, vmf->pmd, pgtable);
 	page_remove_rmap(page, true);
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 
 	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start, mmun_end);
 
@@ -993,7 +993,7 @@ out:
 	return ret;
 
 out_free_pages:
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start, mmun_end);
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		memcg = (void *)page_private(pages[i]);
@@ -1005,23 +1005,23 @@ out_free_pages:
 	goto out;
 }
 
-int do_huge_pmd_wp_page(struct fault_env *fe, pmd_t orig_pmd)
+int do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL, *new_page;
 	struct mem_cgroup *memcg;
-	unsigned long haddr = fe->address & HPAGE_PMD_MASK;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 	gfp_t huge_gfp;			/* for allocation and charge */
 	int ret = 0;
 
-	fe->ptl = pmd_lockptr(vma->vm_mm, fe->pmd);
+	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
 	if (is_huge_zero_pmd(orig_pmd))
 		goto alloc;
-	spin_lock(fe->ptl);
-	if (unlikely(!pmd_same(*fe->pmd, orig_pmd)))
+	spin_lock(vmf->ptl);
+	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
 		goto out_unlock;
 
 	page = pmd_page(orig_pmd);
@@ -1034,13 +1034,13 @@ int do_huge_pmd_wp_page(struct fault_env
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		if (pmdp_set_access_flags(vma, haddr, fe->pmd, entry,  1))
-			update_mmu_cache_pmd(vma, fe->address, fe->pmd);
+		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry,  1))
+			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
 	get_page(page);
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow()) {
@@ -1053,12 +1053,12 @@ alloc:
 		prep_transhuge_page(new_page);
 	} else {
 		if (!page) {
-			split_huge_pmd(vma, fe->pmd, fe->address);
+			split_huge_pmd(vma, vmf->pmd, vmf->address);
 			ret |= VM_FAULT_FALLBACK;
 		} else {
-			ret = do_huge_pmd_wp_page_fallback(fe, orig_pmd, page);
+			ret = do_huge_pmd_wp_page_fallback(vmf, orig_pmd, page);
 			if (ret & VM_FAULT_OOM) {
-				split_huge_pmd(vma, fe->pmd, fe->address);
+				split_huge_pmd(vma, vmf->pmd, vmf->address);
 				ret |= VM_FAULT_FALLBACK;
 			}
 			put_page(page);
@@ -1070,7 +1070,7 @@ alloc:
 	if (unlikely(mem_cgroup_try_charge(new_page, vma->vm_mm,
 					huge_gfp, &memcg, true))) {
 		put_page(new_page);
-		split_huge_pmd(vma, fe->pmd, fe->address);
+		split_huge_pmd(vma, vmf->pmd, vmf->address);
 		if (page)
 			put_page(page);
 		ret |= VM_FAULT_FALLBACK;
@@ -1090,11 +1090,11 @@ alloc:
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(vma->vm_mm, mmun_start, mmun_end);
 
-	spin_lock(fe->ptl);
+	spin_lock(vmf->ptl);
 	if (page)
 		put_page(page);
-	if (unlikely(!pmd_same(*fe->pmd, orig_pmd))) {
-		spin_unlock(fe->ptl);
+	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
+		spin_unlock(vmf->ptl);
 		mem_cgroup_cancel_charge(new_page, memcg, true);
 		put_page(new_page);
 		goto out_mn;
@@ -1102,12 +1102,12 @@ alloc:
 		pmd_t entry;
 		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		pmdp_huge_clear_flush_notify(vma, haddr, fe->pmd);
+		pmdp_huge_clear_flush_notify(vma, haddr, vmf->pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr, true);
 		mem_cgroup_commit_charge(new_page, memcg, false, true);
 		lru_cache_add_active_or_unevictable(new_page, vma);
-		set_pmd_at(vma->vm_mm, haddr, fe->pmd, entry);
-		update_mmu_cache_pmd(vma, fe->address, fe->pmd);
+		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
+		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		if (!page) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		} else {
@@ -1117,13 +1117,13 @@ alloc:
 		}
 		ret |= VM_FAULT_WRITE;
 	}
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 out_mn:
 	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start, mmun_end);
 out:
 	return ret;
 out_unlock:
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 	return ret;
 }
 
@@ -1196,12 +1196,12 @@ out:
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
-int do_huge_pmd_numa_page(struct fault_env *fe, pmd_t pmd)
+int do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t pmd)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct anon_vma *anon_vma = NULL;
 	struct page *page;
-	unsigned long haddr = fe->address & HPAGE_PMD_MASK;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	int page_nid = -1, this_nid = numa_node_id();
 	int target_nid, last_cpupid = -1;
 	bool page_locked;
@@ -1209,8 +1209,8 @@ int do_huge_pmd_numa_page(struct fault_e
 	bool was_writable;
 	int flags = 0;
 
-	fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
-	if (unlikely(!pmd_same(pmd, *fe->pmd)))
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmd, *vmf->pmd)))
 		goto out_unlock;
 
 	/*
@@ -1218,9 +1218,9 @@ int do_huge_pmd_numa_page(struct fault_e
 	 * without disrupting NUMA hinting information. Do not relock and
 	 * check_same as the page may no longer be mapped.
 	 */
-	if (unlikely(pmd_trans_migrating(*fe->pmd))) {
-		page = pmd_page(*fe->pmd);
-		spin_unlock(fe->ptl);
+	if (unlikely(pmd_trans_migrating(*vmf->pmd))) {
+		page = pmd_page(*vmf->pmd);
+		spin_unlock(vmf->ptl);
 		wait_on_page_locked(page);
 		goto out;
 	}
@@ -1253,7 +1253,7 @@ int do_huge_pmd_numa_page(struct fault_e
 
 	/* Migration could have started since the pmd_trans_migrating check */
 	if (!page_locked) {
-		spin_unlock(fe->ptl);
+		spin_unlock(vmf->ptl);
 		wait_on_page_locked(page);
 		page_nid = -1;
 		goto out;
@@ -1264,12 +1264,12 @@ int do_huge_pmd_numa_page(struct fault_e
 	 * to serialises splits
 	 */
 	get_page(page);
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 	anon_vma = page_lock_anon_vma_read(page);
 
 	/* Confirm the PMD did not change while page_table_lock was released */
-	spin_lock(fe->ptl);
-	if (unlikely(!pmd_same(pmd, *fe->pmd))) {
+	spin_lock(vmf->ptl);
+	if (unlikely(!pmd_same(pmd, *vmf->pmd))) {
 		unlock_page(page);
 		put_page(page);
 		page_nid = -1;
@@ -1287,9 +1287,9 @@ int do_huge_pmd_numa_page(struct fault_e
 	 * Migrate the THP to the requested node, returns with page unlocked
 	 * and access rights restored.
 	 */
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 	migrated = migrate_misplaced_transhuge_page(vma->vm_mm, vma,
-				fe->pmd, pmd, fe->address, page, target_nid);
+				vmf->pmd, pmd, vmf->address, page, target_nid);
 	if (migrated) {
 		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
@@ -1304,18 +1304,19 @@ clear_pmdnuma:
 	pmd = pmd_mkyoung(pmd);
 	if (was_writable)
 		pmd = pmd_mkwrite(pmd);
-	set_pmd_at(vma->vm_mm, haddr, fe->pmd, pmd);
-	update_mmu_cache_pmd(vma, fe->address, fe->pmd);
+	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	unlock_page(page);
 out_unlock:
-	spin_unlock(fe->ptl);
+	spin_unlock(vmf->ptl);
 
 out:
 	if (anon_vma)
 		page_unlock_anon_vma_read(anon_vma);
 
 	if (page_nid != -1)
-		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, fe->flags);
+		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR,
+				vmf->flags);
 
 	return 0;
 }
diff -puN mm/internal.h~mm-join-struct-fault_env-and-vm_fault mm/internal.h
--- a/mm/internal.h~mm-join-struct-fault_env-and-vm_fault
+++ a/mm/internal.h
@@ -36,7 +36,7 @@
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
-int do_swap_page(struct fault_env *fe, pte_t orig_pte);
+int do_swap_page(struct vm_fault *vmf, pte_t orig_pte);
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
diff -puN mm/khugepaged.c~mm-join-struct-fault_env-and-vm_fault mm/khugepaged.c
--- a/mm/khugepaged.c~mm-join-struct-fault_env-and-vm_fault
+++ a/mm/khugepaged.c
@@ -877,7 +877,7 @@ static bool __collapse_huge_page_swapin(
 {
 	pte_t pteval;
 	int swapped_in = 0, ret = 0;
-	struct fault_env fe = {
+	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address,
 		.flags = FAULT_FLAG_ALLOW_RETRY,
@@ -889,19 +889,19 @@ static bool __collapse_huge_page_swapin(
 		trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 		return false;
 	}
-	fe.pte = pte_offset_map(pmd, address);
-	for (; fe.address < address + HPAGE_PMD_NR*PAGE_SIZE;
-			fe.pte++, fe.address += PAGE_SIZE) {
-		pteval = *fe.pte;
+	vmf.pte = pte_offset_map(pmd, address);
+	for (; vmf.address < address + HPAGE_PMD_NR*PAGE_SIZE;
+			vmf.pte++, vmf.address += PAGE_SIZE) {
+		pteval = *vmf.pte;
 		if (!is_swap_pte(pteval))
 			continue;
 		swapped_in++;
-		ret = do_swap_page(&fe, pteval);
+		ret = do_swap_page(&vmf, pteval);
 
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
 		if (ret & VM_FAULT_RETRY) {
 			down_read(&mm->mmap_sem);
-			if (hugepage_vma_revalidate(mm, address, &fe.vma)) {
+			if (hugepage_vma_revalidate(mm, address, &vmf.vma)) {
 				/* vma is no longer available, don't continue to swapin */
 				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 				return false;
@@ -915,10 +915,10 @@ static bool __collapse_huge_page_swapin(
 			return false;
 		}
 		/* pte is unmapped now, we need to map it */
-		fe.pte = pte_offset_map(pmd, fe.address);
+		vmf.pte = pte_offset_map(pmd, vmf.address);
 	}
-	fe.pte--;
-	pte_unmap(fe.pte);
+	vmf.pte--;
+	pte_unmap(vmf.pte);
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 1);
 	return true;
 }
diff -puN mm/memory.c~mm-join-struct-fault_env-and-vm_fault mm/memory.c
--- a/mm/memory.c~mm-join-struct-fault_env-and-vm_fault
+++ a/mm/memory.c
@@ -2070,11 +2070,11 @@ static int do_page_mkwrite(struct vm_are
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct fault_env *fe, pte_t orig_pte,
+static inline int wp_page_reuse(struct vm_fault *vmf, pte_t orig_pte,
 			struct page *page, int page_mkwrite, int dirty_shared)
-	__releases(fe->ptl)
+	__releases(vmf->ptl)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	pte_t entry;
 	/*
 	 * Clear the pages cpupid information as the existing
@@ -2084,12 +2084,12 @@ static inline int wp_page_reuse(struct f
 	if (page)
 		page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
 
-	flush_cache_page(vma, fe->address, pte_pfn(orig_pte));
+	flush_cache_page(vma, vmf->address, pte_pfn(orig_pte));
 	entry = pte_mkyoung(orig_pte);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	if (ptep_set_access_flags(vma, fe->address, fe->pte, entry, 1))
-		update_mmu_cache(vma, fe->address, fe->pte);
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
+		update_mmu_cache(vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
 	if (dirty_shared) {
 		struct address_space *mapping;
@@ -2135,15 +2135,15 @@ static inline int wp_page_reuse(struct f
  *   held to the old page, as well as updating the rmap.
  * - In any case, unlock the PTL and drop the reference we took to the old page.
  */
-static int wp_page_copy(struct fault_env *fe, pte_t orig_pte,
+static int wp_page_copy(struct vm_fault *vmf, pte_t orig_pte,
 		struct page *old_page)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *new_page = NULL;
 	pte_t entry;
 	int page_copied = 0;
-	const unsigned long mmun_start = fe->address & PAGE_MASK;
+	const unsigned long mmun_start = vmf->address & PAGE_MASK;
 	const unsigned long mmun_end = mmun_start + PAGE_SIZE;
 	struct mem_cgroup *memcg;
 
@@ -2151,15 +2151,16 @@ static int wp_page_copy(struct fault_env
 		goto oom;
 
 	if (is_zero_pfn(pte_pfn(orig_pte))) {
-		new_page = alloc_zeroed_user_highpage_movable(vma, fe->address);
+		new_page = alloc_zeroed_user_highpage_movable(vma,
+							      vmf->address);
 		if (!new_page)
 			goto oom;
 	} else {
 		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
-				fe->address);
+				vmf->address);
 		if (!new_page)
 			goto oom;
-		cow_user_page(new_page, old_page, fe->address, vma);
+		cow_user_page(new_page, old_page, vmf->address, vma);
 	}
 
 	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg, false))
@@ -2172,8 +2173,8 @@ static int wp_page_copy(struct fault_env
 	/*
 	 * Re-check the pte - we dropped the lock
 	 */
-	fe->pte = pte_offset_map_lock(mm, fe->pmd, fe->address, &fe->ptl);
-	if (likely(pte_same(*fe->pte, orig_pte))) {
+	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, vmf->address, &vmf->ptl);
+	if (likely(pte_same(*vmf->pte, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
 				dec_mm_counter_fast(mm,
@@ -2183,7 +2184,7 @@ static int wp_page_copy(struct fault_env
 		} else {
 			inc_mm_counter_fast(mm, MM_ANONPAGES);
 		}
-		flush_cache_page(vma, fe->address, pte_pfn(orig_pte));
+		flush_cache_page(vma, vmf->address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		/*
@@ -2192,8 +2193,8 @@ static int wp_page_copy(struct fault_env
 		 * seen in the presence of one thread doing SMC and another
 		 * thread doing COW.
 		 */
-		ptep_clear_flush_notify(vma, fe->address, fe->pte);
-		page_add_new_anon_rmap(new_page, vma, fe->address, false);
+		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
+		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(new_page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
@@ -2201,8 +2202,8 @@ static int wp_page_copy(struct fault_env
 		 * mmu page tables (such as kvm shadow page tables), we want the
 		 * new page to be mapped directly into the secondary page table.
 		 */
-		set_pte_at_notify(mm, fe->address, fe->pte, entry);
-		update_mmu_cache(vma, fe->address, fe->pte);
+		set_pte_at_notify(mm, vmf->address, vmf->pte, entry);
+		update_mmu_cache(vma, vmf->address, vmf->pte);
 		if (old_page) {
 			/*
 			 * Only after switching the pte to the new page may
@@ -2239,7 +2240,7 @@ static int wp_page_copy(struct fault_env
 	if (new_page)
 		put_page(new_page);
 
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	if (old_page) {
 		/*
@@ -2267,43 +2268,43 @@ oom:
  * Handle write page faults for VM_MIXEDMAP or VM_PFNMAP for a VM_SHARED
  * mapping
  */
-static int wp_pfn_shared(struct fault_env *fe,  pte_t orig_pte)
+static int wp_pfn_shared(struct vm_fault *vmf, pte_t orig_pte)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 
 	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
-		struct vm_fault vmf = {
+		struct vm_fault vmf2 = {
 			.page = NULL,
-			.pgoff = linear_page_index(vma, fe->address),
+			.pgoff = linear_page_index(vma, vmf->address),
 			.virtual_address =
-				(void __user *)(fe->address & PAGE_MASK),
+				(void __user *)(vmf->address & PAGE_MASK),
 			.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE,
 		};
 		int ret;
 
-		pte_unmap_unlock(fe->pte, fe->ptl);
-		ret = vma->vm_ops->pfn_mkwrite(vma, &vmf);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		ret = vma->vm_ops->pfn_mkwrite(vma, &vmf2);
 		if (ret & VM_FAULT_ERROR)
 			return ret;
-		fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd, fe->address,
-				&fe->ptl);
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+				vmf->address, &vmf->ptl);
 		/*
 		 * We might have raced with another page fault while we
 		 * released the pte_offset_map_lock.
 		 */
-		if (!pte_same(*fe->pte, orig_pte)) {
-			pte_unmap_unlock(fe->pte, fe->ptl);
+		if (!pte_same(*vmf->pte, orig_pte)) {
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;
 		}
 	}
-	return wp_page_reuse(fe, orig_pte, NULL, 0, 0);
+	return wp_page_reuse(vmf, orig_pte, NULL, 0, 0);
 }
 
-static int wp_page_shared(struct fault_env *fe, pte_t orig_pte,
+static int wp_page_shared(struct vm_fault *vmf, pte_t orig_pte,
 		struct page *old_page)
-	__releases(fe->ptl)
+	__releases(vmf->ptl)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	int page_mkwrite = 0;
 
 	get_page(old_page);
@@ -2311,8 +2312,8 @@ static int wp_page_shared(struct fault_e
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 		int tmp;
 
-		pte_unmap_unlock(fe->pte, fe->ptl);
-		tmp = do_page_mkwrite(vma, old_page, fe->address);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		tmp = do_page_mkwrite(vma, old_page, vmf->address);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(old_page);
@@ -2324,18 +2325,18 @@ static int wp_page_shared(struct fault_e
 		 * they did, we just return, as we can count on the
 		 * MMU to tell us if they didn't also make it writable.
 		 */
-		fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd, fe->address,
-						 &fe->ptl);
-		if (!pte_same(*fe->pte, orig_pte)) {
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+						vmf->address, &vmf->ptl);
+		if (!pte_same(*vmf->pte, orig_pte)) {
 			unlock_page(old_page);
-			pte_unmap_unlock(fe->pte, fe->ptl);
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			put_page(old_page);
 			return 0;
 		}
 		page_mkwrite = 1;
 	}
 
-	return wp_page_reuse(fe, orig_pte, old_page, page_mkwrite, 1);
+	return wp_page_reuse(vmf, orig_pte, old_page, page_mkwrite, 1);
 }
 
 /*
@@ -2356,13 +2357,13 @@ static int wp_page_shared(struct fault_e
  * but allow concurrent faults), with pte both mapped and locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
-static int do_wp_page(struct fault_env *fe, pte_t orig_pte)
-	__releases(fe->ptl)
+static int do_wp_page(struct vm_fault *vmf, pte_t orig_pte)
+	__releases(vmf->ptl)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *old_page;
 
-	old_page = vm_normal_page(vma, fe->address, orig_pte);
+	old_page = vm_normal_page(vma, vmf->address, orig_pte);
 	if (!old_page) {
 		/*
 		 * VM_MIXEDMAP !pfn_valid() case, or VM_SOFTDIRTY clear on a
@@ -2373,10 +2374,10 @@ static int do_wp_page(struct fault_env *
 		 */
 		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 				     (VM_WRITE|VM_SHARED))
-			return wp_pfn_shared(fe, orig_pte);
+			return wp_pfn_shared(vmf, orig_pte);
 
-		pte_unmap_unlock(fe->pte, fe->ptl);
-		return wp_page_copy(fe, orig_pte, old_page);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return wp_page_copy(vmf, orig_pte, old_page);
 	}
 
 	/*
@@ -2387,13 +2388,13 @@ static int do_wp_page(struct fault_env *
 		int total_mapcount;
 		if (!trylock_page(old_page)) {
 			get_page(old_page);
-			pte_unmap_unlock(fe->pte, fe->ptl);
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			lock_page(old_page);
-			fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd,
-					fe->address, &fe->ptl);
-			if (!pte_same(*fe->pte, orig_pte)) {
+			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+					vmf->address, &vmf->ptl);
+			if (!pte_same(*vmf->pte, orig_pte)) {
 				unlock_page(old_page);
-				pte_unmap_unlock(fe->pte, fe->ptl);
+				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				put_page(old_page);
 				return 0;
 			}
@@ -2411,12 +2412,12 @@ static int do_wp_page(struct fault_env *
 				page_move_anon_rmap(old_page, vma);
 			}
 			unlock_page(old_page);
-			return wp_page_reuse(fe, orig_pte, old_page, 0, 0);
+			return wp_page_reuse(vmf, orig_pte, old_page, 0, 0);
 		}
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
-		return wp_page_shared(fe, orig_pte, old_page);
+		return wp_page_shared(vmf, orig_pte, old_page);
 	}
 
 	/*
@@ -2424,8 +2425,8 @@ static int do_wp_page(struct fault_env *
 	 */
 	get_page(old_page);
 
-	pte_unmap_unlock(fe->pte, fe->ptl);
-	return wp_page_copy(fe, orig_pte, old_page);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return wp_page_copy(vmf, orig_pte, old_page);
 }
 
 static void unmap_mapping_range_vma(struct vm_area_struct *vma,
@@ -2513,9 +2514,9 @@ EXPORT_SYMBOL(unmap_mapping_range);
  * We return with the mmap_sem locked or unlocked in the same cases
  * as does filemap_fault().
  */
-int do_swap_page(struct fault_env *fe, pte_t orig_pte)
+int do_swap_page(struct vm_fault *vmf, pte_t orig_pte)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *page, *swapcache;
 	struct mem_cgroup *memcg;
 	swp_entry_t entry;
@@ -2524,17 +2525,18 @@ int do_swap_page(struct fault_env *fe, p
 	int exclusive = 0;
 	int ret = 0;
 
-	if (!pte_unmap_same(vma->vm_mm, fe->pmd, fe->pte, orig_pte))
+	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, orig_pte))
 		goto out;
 
 	entry = pte_to_swp_entry(orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
 		if (is_migration_entry(entry)) {
-			migration_entry_wait(vma->vm_mm, fe->pmd, fe->address);
+			migration_entry_wait(vma->vm_mm, vmf->pmd,
+					     vmf->address);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
 		} else {
-			print_bad_pte(vma, fe->address, orig_pte, NULL);
+			print_bad_pte(vma, vmf->address, orig_pte, NULL);
 			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
@@ -2542,16 +2544,16 @@ int do_swap_page(struct fault_env *fe, p
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
-		page = swapin_readahead(entry,
-					GFP_HIGHUSER_MOVABLE, vma, fe->address);
+		page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vma,
+					vmf->address);
 		if (!page) {
 			/*
 			 * Back out if somebody else faulted in this pte
 			 * while we released the pte lock.
 			 */
-			fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd,
-					fe->address, &fe->ptl);
-			if (likely(pte_same(*fe->pte, orig_pte)))
+			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+					vmf->address, &vmf->ptl);
+			if (likely(pte_same(*vmf->pte, orig_pte)))
 				ret = VM_FAULT_OOM;
 			delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 			goto unlock;
@@ -2573,7 +2575,7 @@ int do_swap_page(struct fault_env *fe, p
 	}
 
 	swapcache = page;
-	locked = lock_page_or_retry(page, vma->vm_mm, fe->flags);
+	locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
 
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 	if (!locked) {
@@ -2590,7 +2592,7 @@ int do_swap_page(struct fault_env *fe, p
 	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
-	page = ksm_might_need_to_copy(page, vma, fe->address);
+	page = ksm_might_need_to_copy(page, vma, vmf->address);
 	if (unlikely(!page)) {
 		ret = VM_FAULT_OOM;
 		page = swapcache;
@@ -2606,9 +2608,9 @@ int do_swap_page(struct fault_env *fe, p
 	/*
 	 * Back out if somebody else already faulted in this pte.
 	 */
-	fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd, fe->address,
-			&fe->ptl);
-	if (unlikely(!pte_same(*fe->pte, orig_pte)))
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+			&vmf->ptl);
+	if (unlikely(!pte_same(*vmf->pte, orig_pte)))
 		goto out_nomap;
 
 	if (unlikely(!PageUptodate(page))) {
@@ -2629,22 +2631,22 @@ int do_swap_page(struct fault_env *fe, p
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	dec_mm_counter_fast(vma->vm_mm, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
-	if ((fe->flags & FAULT_FLAG_WRITE) && reuse_swap_page(page, NULL)) {
+	if ((vmf->flags & FAULT_FLAG_WRITE) && reuse_swap_page(page, NULL)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
-		fe->flags &= ~FAULT_FLAG_WRITE;
+		vmf->flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
 		exclusive = RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
-	set_pte_at(vma->vm_mm, fe->address, fe->pte, pte);
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	if (page == swapcache) {
-		do_page_add_anon_rmap(page, vma, fe->address, exclusive);
+		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 		mem_cgroup_commit_charge(page, memcg, true, false);
 		activate_page(page);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, fe->address, false);
+		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
@@ -2667,22 +2669,22 @@ int do_swap_page(struct fault_env *fe, p
 		put_page(swapcache);
 	}
 
-	if (fe->flags & FAULT_FLAG_WRITE) {
-		ret |= do_wp_page(fe, pte);
+	if (vmf->flags & FAULT_FLAG_WRITE) {
+		ret |= do_wp_page(vmf, pte);
 		if (ret & VM_FAULT_ERROR)
 			ret &= VM_FAULT_ERROR;
 		goto out;
 	}
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(vma, fe->address, fe->pte);
+	update_mmu_cache(vma, vmf->address, vmf->pte);
 unlock:
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	return ret;
 out_nomap:
 	mem_cgroup_cancel_charge(page, memcg, false);
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
 	unlock_page(page);
 out_release:
@@ -2733,9 +2735,9 @@ static inline int check_stack_guard_page
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
-static int do_anonymous_page(struct fault_env *fe)
+static int do_anonymous_page(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct mem_cgroup *memcg;
 	struct page *page;
 	pte_t entry;
@@ -2745,7 +2747,7 @@ static int do_anonymous_page(struct faul
 		return VM_FAULT_SIGBUS;
 
 	/* Check if we need to add a guard page to the stack */
-	if (check_stack_guard_page(vma, fe->address) < 0)
+	if (check_stack_guard_page(vma, vmf->address) < 0)
 		return VM_FAULT_SIGSEGV;
 
 	/*
@@ -2758,26 +2760,26 @@ static int do_anonymous_page(struct faul
 	 *
 	 * Here we only have down_read(mmap_sem).
 	 */
-	if (pte_alloc(vma->vm_mm, fe->pmd, fe->address))
+	if (pte_alloc(vma->vm_mm, vmf->pmd, vmf->address))
 		return VM_FAULT_OOM;
 
 	/* See the comment in pte_alloc_one_map() */
-	if (unlikely(pmd_trans_unstable(fe->pmd)))
+	if (unlikely(pmd_trans_unstable(vmf->pmd)))
 		return 0;
 
 	/* Use the zero-page for reads */
-	if (!(fe->flags & FAULT_FLAG_WRITE) &&
+	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm)) {
-		entry = pte_mkspecial(pfn_pte(my_zero_pfn(fe->address),
+		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
 						vma->vm_page_prot));
-		fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd, fe->address,
-				&fe->ptl);
-		if (!pte_none(*fe->pte))
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+				vmf->address, &vmf->ptl);
+		if (!pte_none(*vmf->pte))
 			goto unlock;
 		/* Deliver the page fault to userland, check inside PT lock */
 		if (userfaultfd_missing(vma)) {
-			pte_unmap_unlock(fe->pte, fe->ptl);
-			return handle_userfault(fe, VM_UFFD_MISSING);
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			return handle_userfault(vmf, VM_UFFD_MISSING);
 		}
 		goto setpte;
 	}
@@ -2785,7 +2787,7 @@ static int do_anonymous_page(struct faul
 	/* Allocate our own private page. */
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
-	page = alloc_zeroed_user_highpage_movable(vma, fe->address);
+	page = alloc_zeroed_user_highpage_movable(vma, vmf->address);
 	if (!page)
 		goto oom;
 
@@ -2803,30 +2805,30 @@ static int do_anonymous_page(struct faul
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
-	fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd, fe->address,
-			&fe->ptl);
-	if (!pte_none(*fe->pte))
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+			&vmf->ptl);
+	if (!pte_none(*vmf->pte))
 		goto release;
 
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
-		pte_unmap_unlock(fe->pte, fe->ptl);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		mem_cgroup_cancel_charge(page, memcg, false);
 		put_page(page);
-		return handle_userfault(fe, VM_UFFD_MISSING);
+		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, fe->address, false);
+	page_add_new_anon_rmap(page, vma, vmf->address, false);
 	mem_cgroup_commit_charge(page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
-	set_pte_at(vma->vm_mm, fe->address, fe->pte, entry);
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(vma, fe->address, fe->pte);
+	update_mmu_cache(vma, vmf->address, vmf->pte);
 unlock:
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return 0;
 release:
 	mem_cgroup_cancel_charge(page, memcg, false);
@@ -2843,62 +2845,62 @@ oom:
  * released depending on flags and vma->vm_ops->fault() return value.
  * See filemap_fault() and __lock_page_retry().
  */
-static int __do_fault(struct fault_env *fe, pgoff_t pgoff,
+static int __do_fault(struct vm_fault *vmf, pgoff_t pgoff,
 		struct page *cow_page, struct page **page, void **entry)
 {
-	struct vm_area_struct *vma = fe->vma;
-	struct vm_fault vmf;
+	struct vm_area_struct *vma = vmf->vma;
+	struct vm_fault vmf2;
 	int ret;
 
-	vmf.virtual_address = (void __user *)(fe->address & PAGE_MASK);
-	vmf.pgoff = pgoff;
-	vmf.flags = fe->flags;
-	vmf.page = NULL;
-	vmf.gfp_mask = __get_fault_gfp_mask(vma);
-	vmf.cow_page = cow_page;
+	vmf2.virtual_address = (void __user *)(vmf->address & PAGE_MASK);
+	vmf2.pgoff = pgoff;
+	vmf2.flags = vmf->flags;
+	vmf2.page = NULL;
+	vmf2.gfp_mask = __get_fault_gfp_mask(vma);
+	vmf2.cow_page = cow_page;
 
-	ret = vma->vm_ops->fault(vma, &vmf);
+	ret = vma->vm_ops->fault(vma, &vmf2);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 	if (ret & VM_FAULT_DAX_LOCKED) {
-		*entry = vmf.entry;
+		*entry = vmf2.entry;
 		return ret;
 	}
 
-	if (unlikely(PageHWPoison(vmf.page))) {
+	if (unlikely(PageHWPoison(vmf2.page))) {
 		if (ret & VM_FAULT_LOCKED)
-			unlock_page(vmf.page);
-		put_page(vmf.page);
+			unlock_page(vmf2.page);
+		put_page(vmf2.page);
 		return VM_FAULT_HWPOISON;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-		lock_page(vmf.page);
+		lock_page(vmf2.page);
 	else
-		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
+		VM_BUG_ON_PAGE(!PageLocked(vmf2.page), vmf2.page);
 
-	*page = vmf.page;
+	*page = vmf2.page;
 	return ret;
 }
 
-static int pte_alloc_one_map(struct fault_env *fe)
+static int pte_alloc_one_map(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 
-	if (!pmd_none(*fe->pmd))
+	if (!pmd_none(*vmf->pmd))
 		goto map_pte;
-	if (fe->prealloc_pte) {
-		fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
-		if (unlikely(!pmd_none(*fe->pmd))) {
-			spin_unlock(fe->ptl);
+	if (vmf->prealloc_pte) {
+		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+		if (unlikely(!pmd_none(*vmf->pmd))) {
+			spin_unlock(vmf->ptl);
 			goto map_pte;
 		}
 
 		atomic_long_inc(&vma->vm_mm->nr_ptes);
-		pmd_populate(vma->vm_mm, fe->pmd, fe->prealloc_pte);
-		spin_unlock(fe->ptl);
-		fe->prealloc_pte = 0;
-	} else if (unlikely(pte_alloc(vma->vm_mm, fe->pmd, fe->address))) {
+		pmd_populate(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
+		spin_unlock(vmf->ptl);
+		vmf->prealloc_pte = 0;
+	} else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd, vmf->address))) {
 		return VM_FAULT_OOM;
 	}
 map_pte:
@@ -2913,11 +2915,11 @@ map_pte:
 	 * through an atomic read in C, which is what pmd_trans_unstable()
 	 * provides.
 	 */
-	if (pmd_trans_unstable(fe->pmd) || pmd_devmap(*fe->pmd))
+	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
 		return VM_FAULT_NOPAGE;
 
-	fe->pte = pte_offset_map_lock(vma->vm_mm, fe->pmd, fe->address,
-			&fe->ptl);
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+			&vmf->ptl);
 	return 0;
 }
 
@@ -2935,24 +2937,24 @@ static inline bool transhuge_vma_suitabl
 	return true;
 }
 
-static void deposit_prealloc_pte(struct fault_env *fe)
+static void deposit_prealloc_pte(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 
-	pgtable_trans_huge_deposit(vma->vm_mm, fe->pmd, fe->prealloc_pte);
+	pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
 	/*
 	 * We are going to consume the prealloc table,
 	 * count that as nr_ptes.
 	 */
 	atomic_long_inc(&vma->vm_mm->nr_ptes);
-	fe->prealloc_pte = 0;
+	vmf->prealloc_pte = 0;
 }
 
-static int do_set_pmd(struct fault_env *fe, struct page *page)
+static int do_set_pmd(struct vm_fault *vmf, struct page *page)
 {
-	struct vm_area_struct *vma = fe->vma;
-	bool write = fe->flags & FAULT_FLAG_WRITE;
-	unsigned long haddr = fe->address & HPAGE_PMD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t entry;
 	int i, ret;
 
@@ -2966,15 +2968,15 @@ static int do_set_pmd(struct fault_env *
 	 * Archs like ppc64 need additonal space to store information
 	 * related to pte entry. Use the preallocated table for that.
 	 */
-	if (arch_needs_pgtable_deposit() && !fe->prealloc_pte) {
-		fe->prealloc_pte = pte_alloc_one(vma->vm_mm, fe->address);
-		if (!fe->prealloc_pte)
+	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
+		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm, vmf->address);
+		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
 		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
-	fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
-	if (unlikely(!pmd_none(*fe->pmd)))
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_none(*vmf->pmd)))
 		goto out;
 
 	for (i = 0; i < HPAGE_PMD_NR; i++)
@@ -2990,11 +2992,11 @@ static int do_set_pmd(struct fault_env *
 	 * deposit and withdraw with pmd lock held
 	 */
 	if (arch_needs_pgtable_deposit())
-		deposit_prealloc_pte(fe);
+		deposit_prealloc_pte(vmf);
 
-	set_pmd_at(vma->vm_mm, haddr, fe->pmd, entry);
+	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 
-	update_mmu_cache_pmd(vma, haddr, fe->pmd);
+	update_mmu_cache_pmd(vma, haddr, vmf->pmd);
 
 	/* fault is handled */
 	ret = 0;
@@ -3005,13 +3007,13 @@ out:
 	 * withdraw with pmd lock held.
 	 */
 	if (arch_needs_pgtable_deposit() && ret == VM_FAULT_FALLBACK)
-		fe->prealloc_pte = pgtable_trans_huge_withdraw(vma->vm_mm,
-							       fe->pmd);
-	spin_unlock(fe->ptl);
+		vmf->prealloc_pte = pgtable_trans_huge_withdraw(vma->vm_mm,
+								vmf->pmd);
+	spin_unlock(vmf->ptl);
 	return ret;
 }
 #else
-static int do_set_pmd(struct fault_env *fe, struct page *page)
+static int do_set_pmd(struct vm_fault *vmf, struct page *page)
 {
 	BUILD_BUG();
 	return 0;
@@ -3022,41 +3024,42 @@ static int do_set_pmd(struct fault_env *
  * alloc_set_pte - setup new PTE entry for given page and add reverse page
  * mapping. If needed, the fucntion allocates page table or use pre-allocated.
  *
- * @fe: fault environment
+ * @vmf: fault environment
  * @memcg: memcg to charge page (only for private mappings)
  * @page: page to map
  *
- * Caller must take care of unlocking fe->ptl, if fe->pte is non-NULL on return.
+ * Caller must take care of unlocking vmf->ptl, if vmf->pte is non-NULL on
+ * return.
  *
  * Target users are page handler itself and implementations of
  * vm_ops->map_pages.
  */
-int alloc_set_pte(struct fault_env *fe, struct mem_cgroup *memcg,
+int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
 		struct page *page)
 {
-	struct vm_area_struct *vma = fe->vma;
-	bool write = fe->flags & FAULT_FLAG_WRITE;
+	struct vm_area_struct *vma = vmf->vma;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	pte_t entry;
 	int ret;
 
-	if (pmd_none(*fe->pmd) && PageTransCompound(page) &&
+	if (pmd_none(*vmf->pmd) && PageTransCompound(page) &&
 			IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE)) {
 		/* THP on COW? */
 		VM_BUG_ON_PAGE(memcg, page);
 
-		ret = do_set_pmd(fe, page);
+		ret = do_set_pmd(vmf, page);
 		if (ret != VM_FAULT_FALLBACK)
 			goto fault_handled;
 	}
 
-	if (!fe->pte) {
-		ret = pte_alloc_one_map(fe);
+	if (!vmf->pte) {
+		ret = pte_alloc_one_map(vmf);
 		if (ret)
 			goto fault_handled;
 	}
 
 	/* Re-check under ptl */
-	if (unlikely(!pte_none(*fe->pte))) {
+	if (unlikely(!pte_none(*vmf->pte))) {
 		ret = VM_FAULT_NOPAGE;
 		goto fault_handled;
 	}
@@ -3068,24 +3071,24 @@ int alloc_set_pte(struct fault_env *fe,
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-		page_add_new_anon_rmap(page, vma, fe->address, false);
+		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
 		page_add_file_rmap(page, false);
 	}
-	set_pte_at(vma->vm_mm, fe->address, fe->pte, entry);
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
 	/* no need to invalidate: a not-present page won't be cached */
-	update_mmu_cache(vma, fe->address, fe->pte);
+	update_mmu_cache(vma, vmf->address, vmf->pte);
 	ret = 0;
 
 fault_handled:
 	/* preallocated pagetable is unused: free it */
-	if (fe->prealloc_pte) {
-		pte_free(fe->vma->vm_mm, fe->prealloc_pte);
-		fe->prealloc_pte = 0;
+	if (vmf->prealloc_pte) {
+		pte_free(vmf->vma->vm_mm, vmf->prealloc_pte);
+		vmf->prealloc_pte = 0;
 	}
 	return ret;
 }
@@ -3154,17 +3157,17 @@ late_initcall(fault_around_debugfs);
  * fault_around_pages() value (and therefore to page order).  This way it's
  * easier to guarantee that we don't cross page table boundaries.
  */
-static int do_fault_around(struct fault_env *fe, pgoff_t start_pgoff)
+static int do_fault_around(struct vm_fault *vmf, pgoff_t start_pgoff)
 {
-	unsigned long address = fe->address, nr_pages, mask;
+	unsigned long address = vmf->address, nr_pages, mask;
 	pgoff_t end_pgoff;
 	int off, ret = 0;
 
 	nr_pages = READ_ONCE(fault_around_bytes) >> PAGE_SHIFT;
 	mask = ~(nr_pages * PAGE_SIZE - 1) & PAGE_MASK;
 
-	fe->address = max(address & mask, fe->vma->vm_start);
-	off = ((address - fe->address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+	vmf->address = max(address & mask, vmf->vma->vm_start);
+	off = ((address - vmf->address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 	start_pgoff -= off;
 
 	/*
@@ -3172,44 +3175,45 @@ static int do_fault_around(struct fault_
 	 *  or fault_around_pages() from start_pgoff, depending what is nearest.
 	 */
 	end_pgoff = start_pgoff -
-		((fe->address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
+		((vmf->address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
 		PTRS_PER_PTE - 1;
-	end_pgoff = min3(end_pgoff, vma_pages(fe->vma) + fe->vma->vm_pgoff - 1,
+	end_pgoff = min3(end_pgoff, vma_pages(vmf->vma) + vmf->vma->vm_pgoff - 1,
 			start_pgoff + nr_pages - 1);
 
-	if (pmd_none(*fe->pmd)) {
-		fe->prealloc_pte = pte_alloc_one(fe->vma->vm_mm, fe->address);
-		if (!fe->prealloc_pte)
+	if (pmd_none(*vmf->pmd)) {
+		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm,
+						  vmf->address);
+		if (!vmf->prealloc_pte)
 			goto out;
 		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
-	fe->vma->vm_ops->map_pages(fe, start_pgoff, end_pgoff);
+	vmf->vma->vm_ops->map_pages(vmf, start_pgoff, end_pgoff);
 
 	/* Huge page is mapped? Page fault is solved */
-	if (pmd_trans_huge(*fe->pmd)) {
+	if (pmd_trans_huge(*vmf->pmd)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
 
 	/* ->map_pages() haven't done anything useful. Cold page cache? */
-	if (!fe->pte)
+	if (!vmf->pte)
 		goto out;
 
 	/* check if the page fault is solved */
-	fe->pte -= (fe->address >> PAGE_SHIFT) - (address >> PAGE_SHIFT);
-	if (!pte_none(*fe->pte))
+	vmf->pte -= (vmf->address >> PAGE_SHIFT) - (address >> PAGE_SHIFT);
+	if (!pte_none(*vmf->pte))
 		ret = VM_FAULT_NOPAGE;
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-	fe->address = address;
-	fe->pte = NULL;
+	vmf->address = address;
+	vmf->pte = NULL;
 	return ret;
 }
 
-static int do_read_fault(struct fault_env *fe, pgoff_t pgoff)
+static int do_read_fault(struct vm_fault *vmf, pgoff_t pgoff)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page;
 	int ret = 0;
 
@@ -3219,27 +3223,27 @@ static int do_read_fault(struct fault_en
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		ret = do_fault_around(fe, pgoff);
+		ret = do_fault_around(vmf, pgoff);
 		if (ret)
 			return ret;
 	}
 
-	ret = __do_fault(fe, pgoff, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf, pgoff, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-	ret |= alloc_set_pte(fe, NULL, fault_page);
-	if (fe->pte)
-		pte_unmap_unlock(fe->pte, fe->ptl);
+	ret |= alloc_set_pte(vmf, NULL, fault_page);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	unlock_page(fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		put_page(fault_page);
 	return ret;
 }
 
-static int do_cow_fault(struct fault_env *fe, pgoff_t pgoff)
+static int do_cow_fault(struct vm_fault *vmf, pgoff_t pgoff)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page, *new_page;
 	void *fault_entry;
 	struct mem_cgroup *memcg;
@@ -3248,7 +3252,7 @@ static int do_cow_fault(struct fault_env
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, fe->address);
+	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
 	if (!new_page)
 		return VM_FAULT_OOM;
 
@@ -3258,17 +3262,17 @@ static int do_cow_fault(struct fault_env
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(fe, pgoff, new_page, &fault_page, &fault_entry);
+	ret = __do_fault(vmf, pgoff, new_page, &fault_page, &fault_entry);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
 	if (!(ret & VM_FAULT_DAX_LOCKED))
-		copy_user_highpage(new_page, fault_page, fe->address, vma);
+		copy_user_highpage(new_page, fault_page, vmf->address, vma);
 	__SetPageUptodate(new_page);
 
-	ret |= alloc_set_pte(fe, memcg, new_page);
-	if (fe->pte)
-		pte_unmap_unlock(fe->pte, fe->ptl);
+	ret |= alloc_set_pte(vmf, memcg, new_page);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (!(ret & VM_FAULT_DAX_LOCKED)) {
 		unlock_page(fault_page);
 		put_page(fault_page);
@@ -3284,15 +3288,15 @@ uncharge_out:
 	return ret;
 }
 
-static int do_shared_fault(struct fault_env *fe, pgoff_t pgoff)
+static int do_shared_fault(struct vm_fault *vmf, pgoff_t pgoff)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page;
 	struct address_space *mapping;
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(fe, pgoff, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf, pgoff, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3302,7 +3306,7 @@ static int do_shared_fault(struct fault_
 	 */
 	if (vma->vm_ops->page_mkwrite) {
 		unlock_page(fault_page);
-		tmp = do_page_mkwrite(vma, fault_page, fe->address);
+		tmp = do_page_mkwrite(vma, fault_page, vmf->address);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(fault_page);
@@ -3310,9 +3314,9 @@ static int do_shared_fault(struct fault_
 		}
 	}
 
-	ret |= alloc_set_pte(fe, NULL, fault_page);
-	if (fe->pte)
-		pte_unmap_unlock(fe->pte, fe->ptl);
+	ret |= alloc_set_pte(vmf, NULL, fault_page);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 					VM_FAULT_RETRY))) {
 		unlock_page(fault_page);
@@ -3350,19 +3354,19 @@ static int do_shared_fault(struct fault_
  * The mmap_sem may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
-static int do_fault(struct fault_env *fe)
+static int do_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = fe->vma;
-	pgoff_t pgoff = linear_page_index(vma, fe->address);
+	struct vm_area_struct *vma = vmf->vma;
+	pgoff_t pgoff = linear_page_index(vma, vmf->address);
 
 	/* The VMA was not fully populated on mmap() or missing VM_DONTEXPAND */
 	if (!vma->vm_ops->fault)
 		return VM_FAULT_SIGBUS;
-	if (!(fe->flags & FAULT_FLAG_WRITE))
-		return do_read_fault(fe, pgoff);
+	if (!(vmf->flags & FAULT_FLAG_WRITE))
+		return do_read_fault(vmf, pgoff);
 	if (!(vma->vm_flags & VM_SHARED))
-		return do_cow_fault(fe, pgoff);
-	return do_shared_fault(fe, pgoff);
+		return do_cow_fault(vmf, pgoff);
+	return do_shared_fault(vmf, pgoff);
 }
 
 static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
@@ -3380,9 +3384,9 @@ static int numa_migrate_prep(struct page
 	return mpol_misplaced(page, vma, addr);
 }
 
-static int do_numa_page(struct fault_env *fe, pte_t pte)
+static int do_numa_page(struct vm_fault *vmf, pte_t pte)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL;
 	int page_nid = -1;
 	int last_cpupid;
@@ -3400,10 +3404,10 @@ static int do_numa_page(struct fault_env
 	* page table entry is not accessible, so there would be no
 	* concurrent hardware modifications to the PTE.
 	*/
-	fe->ptl = pte_lockptr(vma->vm_mm, fe->pmd);
-	spin_lock(fe->ptl);
-	if (unlikely(!pte_same(*fe->pte, pte))) {
-		pte_unmap_unlock(fe->pte, fe->ptl);
+	vmf->ptl = pte_lockptr(vma->vm_mm, vmf->pmd);
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(*vmf->pte, pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		goto out;
 	}
 
@@ -3412,18 +3416,18 @@ static int do_numa_page(struct fault_env
 	pte = pte_mkyoung(pte);
 	if (was_writable)
 		pte = pte_mkwrite(pte);
-	set_pte_at(vma->vm_mm, fe->address, fe->pte, pte);
-	update_mmu_cache(vma, fe->address, fe->pte);
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	update_mmu_cache(vma, vmf->address, vmf->pte);
 
-	page = vm_normal_page(vma, fe->address, pte);
+	page = vm_normal_page(vma, vmf->address, pte);
 	if (!page) {
-		pte_unmap_unlock(fe->pte, fe->ptl);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return 0;
 	}
 
 	/* TODO: handle PTE-mapped THP */
 	if (PageCompound(page)) {
-		pte_unmap_unlock(fe->pte, fe->ptl);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return 0;
 	}
 
@@ -3447,9 +3451,9 @@ static int do_numa_page(struct fault_env
 
 	last_cpupid = page_cpupid_last(page);
 	page_nid = page_to_nid(page);
-	target_nid = numa_migrate_prep(page, vma, fe->address, page_nid,
+	target_nid = numa_migrate_prep(page, vma, vmf->address, page_nid,
 			&flags);
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (target_nid == -1) {
 		put_page(page);
 		goto out;
@@ -3469,28 +3473,28 @@ out:
 	return 0;
 }
 
-static int create_huge_pmd(struct fault_env *fe)
+static int create_huge_pmd(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = fe->vma;
+	struct vm_area_struct *vma = vmf->vma;
 	if (vma_is_anonymous(vma))
-		return do_huge_pmd_anonymous_page(fe);
+		return do_huge_pmd_anonymous_page(vmf);
 	if (vma->vm_ops->pmd_fault)
-		return vma->vm_ops->pmd_fault(vma, fe->address, fe->pmd,
-				fe->flags);
+		return vma->vm_ops->pmd_fault(vma, vmf->address, vmf->pmd,
+				vmf->flags);
 	return VM_FAULT_FALLBACK;
 }
 
-static int wp_huge_pmd(struct fault_env *fe, pmd_t orig_pmd)
+static int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
-	if (vma_is_anonymous(fe->vma))
-		return do_huge_pmd_wp_page(fe, orig_pmd);
-	if (fe->vma->vm_ops->pmd_fault)
-		return fe->vma->vm_ops->pmd_fault(fe->vma, fe->address, fe->pmd,
-				fe->flags);
+	if (vma_is_anonymous(vmf->vma))
+		return do_huge_pmd_wp_page(vmf, orig_pmd);
+	if (vmf->vma->vm_ops->pmd_fault)
+		return vmf->vma->vm_ops->pmd_fault(vmf->vma, vmf->address,
+						   vmf->pmd, vmf->flags);
 
 	/* COW handled on pte level: split pmd */
-	VM_BUG_ON_VMA(fe->vma->vm_flags & VM_SHARED, fe->vma);
-	__split_huge_pmd(fe->vma, fe->pmd, fe->address, false, NULL);
+	VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
+	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
 
 	return VM_FAULT_FALLBACK;
 }
@@ -3515,21 +3519,21 @@ static inline bool vma_is_accessible(str
  * The mmap_sem may have been released depending on flags and our return value.
  * See filemap_fault() and __lock_page_or_retry().
  */
-static int handle_pte_fault(struct fault_env *fe)
+static int handle_pte_fault(struct vm_fault *vmf)
 {
 	pte_t entry;
 
-	if (unlikely(pmd_none(*fe->pmd))) {
+	if (unlikely(pmd_none(*vmf->pmd))) {
 		/*
 		 * Leave __pte_alloc() until later: because vm_ops->fault may
 		 * want to allocate huge page, and if we expose page table
 		 * for an instant, it will be difficult to retract from
 		 * concurrent faults and from rmap lookups.
 		 */
-		fe->pte = NULL;
+		vmf->pte = NULL;
 	} else {
 		/* See comment in pte_alloc_one_map() */
-		if (pmd_trans_unstable(fe->pmd) || pmd_devmap(*fe->pmd))
+		if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
 			return 0;
 		/*
 		 * A regular pmd is established and it can't morph into a huge
@@ -3537,9 +3541,9 @@ static int handle_pte_fault(struct fault
 		 * mmap_sem read mode and khugepaged takes it in write mode.
 		 * So now it's safe to run pte_offset_map().
 		 */
-		fe->pte = pte_offset_map(fe->pmd, fe->address);
+		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
 
-		entry = *fe->pte;
+		entry = *vmf->pte;
 
 		/*
 		 * some architectures can have larger ptes than wordsize,
@@ -3551,37 +3555,37 @@ static int handle_pte_fault(struct fault
 		 */
 		barrier();
 		if (pte_none(entry)) {
-			pte_unmap(fe->pte);
-			fe->pte = NULL;
+			pte_unmap(vmf->pte);
+			vmf->pte = NULL;
 		}
 	}
 
-	if (!fe->pte) {
-		if (vma_is_anonymous(fe->vma))
-			return do_anonymous_page(fe);
+	if (!vmf->pte) {
+		if (vma_is_anonymous(vmf->vma))
+			return do_anonymous_page(vmf);
 		else
-			return do_fault(fe);
+			return do_fault(vmf);
 	}
 
 	if (!pte_present(entry))
-		return do_swap_page(fe, entry);
+		return do_swap_page(vmf, entry);
 
-	if (pte_protnone(entry) && vma_is_accessible(fe->vma))
-		return do_numa_page(fe, entry);
+	if (pte_protnone(entry) && vma_is_accessible(vmf->vma))
+		return do_numa_page(vmf, entry);
 
-	fe->ptl = pte_lockptr(fe->vma->vm_mm, fe->pmd);
-	spin_lock(fe->ptl);
-	if (unlikely(!pte_same(*fe->pte, entry)))
+	vmf->ptl = pte_lockptr(vmf->vma->vm_mm, vmf->pmd);
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(*vmf->pte, entry)))
 		goto unlock;
-	if (fe->flags & FAULT_FLAG_WRITE) {
+	if (vmf->flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))
-			return do_wp_page(fe, entry);
+			return do_wp_page(vmf, entry);
 		entry = pte_mkdirty(entry);
 	}
 	entry = pte_mkyoung(entry);
-	if (ptep_set_access_flags(fe->vma, fe->address, fe->pte, entry,
-				fe->flags & FAULT_FLAG_WRITE)) {
-		update_mmu_cache(fe->vma, fe->address, fe->pte);
+	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
+				vmf->flags & FAULT_FLAG_WRITE)) {
+		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
 	} else {
 		/*
 		 * This is needed only for protection faults but the arch code
@@ -3589,11 +3593,11 @@ static int handle_pte_fault(struct fault
 		 * This still avoids useless tlb flushes for .text page faults
 		 * with threads.
 		 */
-		if (fe->flags & FAULT_FLAG_WRITE)
-			flush_tlb_fix_spurious_fault(fe->vma, fe->address);
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address);
 	}
 unlock:
-	pte_unmap_unlock(fe->pte, fe->ptl);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return 0;
 }
 
@@ -3606,7 +3610,7 @@ unlock:
 static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 		unsigned int flags)
 {
-	struct fault_env fe = {
+	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address,
 		.flags = flags,
@@ -3619,35 +3623,35 @@ static int __handle_mm_fault(struct vm_a
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
 		return VM_FAULT_OOM;
-	fe.pmd = pmd_alloc(mm, pud, address);
-	if (!fe.pmd)
+	vmf.pmd = pmd_alloc(mm, pud, address);
+	if (!vmf.pmd)
 		return VM_FAULT_OOM;
-	if (pmd_none(*fe.pmd) && transparent_hugepage_enabled(vma)) {
-		int ret = create_huge_pmd(&fe);
+	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
+		int ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		pmd_t orig_pmd = *fe.pmd;
+		pmd_t orig_pmd = *vmf.pmd;
 		int ret;
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
-				return do_huge_pmd_numa_page(&fe, orig_pmd);
+				return do_huge_pmd_numa_page(&vmf, orig_pmd);
 
-			if ((fe.flags & FAULT_FLAG_WRITE) &&
+			if ((vmf.flags & FAULT_FLAG_WRITE) &&
 					!pmd_write(orig_pmd)) {
-				ret = wp_huge_pmd(&fe, orig_pmd);
+				ret = wp_huge_pmd(&vmf, orig_pmd);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
-				huge_pmd_set_accessed(&fe, orig_pmd);
+				huge_pmd_set_accessed(&vmf, orig_pmd);
 				return 0;
 			}
 		}
 	}
 
-	return handle_pte_fault(&fe);
+	return handle_pte_fault(&vmf);
 }
 
 /*
diff -puN mm/nommu.c~mm-join-struct-fault_env-and-vm_fault mm/nommu.c
--- a/mm/nommu.c~mm-join-struct-fault_env-and-vm_fault
+++ a/mm/nommu.c
@@ -1801,7 +1801,7 @@ int filemap_fault(struct vm_area_struct
 }
 EXPORT_SYMBOL(filemap_fault);
 
-void filemap_map_pages(struct fault_env *fe,
+void filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
 	BUG();
_

Patches currently in -mm which might be from jack@suse.cz are


