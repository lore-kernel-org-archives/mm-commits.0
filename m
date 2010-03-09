From: akpm@linux-foundation.org
Subject: [merged] mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:07 -0800
Message-ID: <201003091904.o29J47qm031017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab0CITEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, minchan.kim@gmail.com, mm-commits@vger.


The patch titled
     mm: change anon_vma linking to fix multi-process server scalability issue
has been removed from the -mm tree.  Its filename was
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: change anon_vma linking to fix multi-process server scalability issue
From: Rik van Riel <riel@redhat.com>

The old anon_vma code can lead to scalability issues with heavily forking
workloads.  Specifically, each anon_vma will be shared between the parent
process and all its child processes.

In a workload with 1000 child processes and a VMA with 1000 anonymous
pages per process that get COWed, this leads to a system with a million
anonymous pages in the same anon_vma, each of which is mapped in just one
of the 1000 processes.  However, the current rmap code needs to walk them
all, leading to O(N) scanning complexity for each page.

This can result in systems where one CPU is walking the page tables of
1000 processes in page_referenced_one, while all other CPUs are stuck on
the anon_vma lock.  This leads to catastrophic failure for a benchmark
like AIM7, where the total number of processes can reach in the tens of
thousands.  Real workloads are still a factor 10 less process intensive
than AIM7, but they are catching up.

This patch changes the way anon_vmas and VMAs are linked, which allows us
to associate multiple anon_vmas with a VMA.  At fork time, each child
process gets its own anon_vmas, in which its COWed pages will be
instantiated.  The parents' anon_vma is also linked to the VMA, because
non-COWed pages could be present in any of the children.

This reduces rmap scanning complexity to O(1) for the pages of the 1000
child processes, with O(N) complexity for at most 1/N pages in the system.
 This reduces the average scanning cost in heavily forking workloads from
O(N) to 2.

The only real complexity in this patch stems from the fact that linking a
VMA to anon_vmas now involves memory allocations.  This means vma_adjust
can fail, if it needs to attach a VMA to anon_vma structures.  This in
turn means error handling needs to be added to the calling functions.

A second source of complexity is that, because there can be multiple
anon_vmas, the anon_vma linking in vma_adjust can no longer be done under
"the" anon_vma lock.  To prevent the rmap code from walking up an
incomplete VMA, this patch introduces the VM_LOCK_RMAP VMA flag.  This bit
flag uses the same slot as the NOMMU VM_MAPPED_COPY, with an ifdef in mm.h
to make sure it is impossible to compile a kernel that needs both symbolic
values for the same bitflag.

Some test results:

Without the anon_vma changes, when AIM7 hits around 9.7k users (on a test
box with 16GB RAM and not quite enough IO), the system ends up running
>99% in system time, with every CPU on the same anon_vma lock in the
pageout code.

With these changes, AIM7 hits the cross-over point around 29.7k users. 
This happens with ~99% IO wait time, there never seems to be any spike in
system time.  The anon_vma lock contention appears to be resolved.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    1 
 arch/ia64/mm/init.c        |    2 
 fs/exec.c                  |    6 -
 include/linux/mm.h         |    6 +
 include/linux/mm_types.h   |    3 
 include/linux/rmap.h       |   35 ++++++-
 kernel/fork.c              |    6 +
 mm/ksm.c                   |   12 +-
 mm/memory-failure.c        |    5 -
 mm/memory.c                |    4 
 mm/mmap.c                  |  138 +++++++++++++++++++++---------
 mm/mremap.c                |    7 +
 mm/nommu.c                 |    2 
 mm/rmap.c                  |  158 +++++++++++++++++++++++++++++------
 14 files changed, 299 insertions(+), 86 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/arch/ia64/kernel/perfmon.c
@@ -2315,6 +2315,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 		DPRINT(("Cannot allocate vma\n"));
 		goto error_kmem;
 	}
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
 	/*
 	 * partially initialize the vma for the sampling buffer
diff -puN arch/ia64/mm/init.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/arch/ia64/mm/init.c
@@ -117,6 +117,7 @@ ia64_init_addr_space (void)
 	 */
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
+		INIT_LIST_HEAD(&vma->anon_vma_chain);
 		vma->vm_mm = current->mm;
 		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
@@ -135,6 +136,7 @@ ia64_init_addr_space (void)
 	if (!(current->personality & MMAP_PAGE_ZERO)) {
 		vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 		if (vma) {
+			INIT_LIST_HEAD(&vma->anon_vma_chain);
 			vma->vm_mm = current->mm;
 			vma->vm_end = PAGE_SIZE;
 			vma->vm_page_prot = __pgprot(pgprot_val(PAGE_READONLY) | _PAGE_MA_NAT);
diff -puN fs/exec.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue fs/exec.c
--- a/fs/exec.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/fs/exec.c
@@ -246,6 +246,7 @@ static int __bprm_mm_init(struct linux_b
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	err = insert_vm_struct(mm, vma);
 	if (err)
 		goto err;
@@ -516,7 +517,8 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL);
+	if (vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL))
+		return -ENOMEM;
 
 	/*
 	 * move the page tables downwards, on failure we rely on
@@ -547,7 +549,7 @@ static int shift_arg_pages(struct vm_are
 	tlb_finish_mmu(tlb, new_end, old_end);
 
 	/*
-	 * shrink the vma to just the new range.
+	 * Shrink the vma to just the new range.  Always succeeds.
 	 */
 	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
 
diff -puN include/linux/mm.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue include/linux/mm.h
--- a/include/linux/mm.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/include/linux/mm.h
@@ -97,7 +97,11 @@ extern unsigned int kobjsize(const void 
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
+#ifdef CONFIG_MMU
+#define VM_LOCK_RMAP	0x01000000	/* Do not follow this rmap (mmu mmap) */
+#else
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
+#endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
@@ -1216,7 +1220,7 @@ static inline void vma_nonlinear_insert(
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern void vma_adjust(struct vm_area_struct *vma, unsigned long start,
+extern int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
diff -puN include/linux/mm_types.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/include/linux/mm_types.h
@@ -163,7 +163,8 @@ struct vm_area_struct {
 	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
 	 * or brk vma (with NULL file) can only be in an anon_vma list.
 	 */
-	struct list_head anon_vma_node;	/* Serialized by anon_vma->lock */
+	struct list_head anon_vma_chain; /* Serialized by mmap_sem &
+					  * page_table_lock */
 	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
 
 	/* Function pointers to deal with this struct. */
diff -puN include/linux/rmap.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue include/linux/rmap.h
--- a/include/linux/rmap.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/include/linux/rmap.h
@@ -37,7 +37,27 @@ struct anon_vma {
 	 * is serialized by a system wide lock only visible to
 	 * mm_take_all_locks() (mm_all_locks_mutex).
 	 */
-	struct list_head head;	/* List of private "related" vmas */
+	struct list_head head;	/* Chain of private "related" vmas */
+};
+
+/*
+ * The copy-on-write semantics of fork mean that an anon_vma
+ * can become associated with multiple processes. Furthermore,
+ * each child process will have its own anon_vma, where new
+ * pages for that process are instantiated.
+ *
+ * This structure allows us to find the anon_vmas associated
+ * with a VMA, or the VMAs associated with an anon_vma.
+ * The "same_vma" list contains the anon_vma_chains linking
+ * all the anon_vmas associated with this VMA.
+ * The "same_anon_vma" list contains the anon_vma_chains
+ * which link all the VMAs associated with this anon_vma.
+ */
+struct anon_vma_chain {
+	struct vm_area_struct *vma;
+	struct anon_vma *anon_vma;
+	struct list_head same_vma;   /* locked by mmap_sem & page_table_lock */
+	struct list_head same_anon_vma;	/* locked by anon_vma->lock */
 };
 
 #ifdef CONFIG_MMU
@@ -89,12 +109,19 @@ static inline void anon_vma_unlock(struc
  */
 void anon_vma_init(void);	/* create anon_vma_cachep */
 int  anon_vma_prepare(struct vm_area_struct *);
-void __anon_vma_merge(struct vm_area_struct *, struct vm_area_struct *);
-void anon_vma_unlink(struct vm_area_struct *);
-void anon_vma_link(struct vm_area_struct *);
+void unlink_anon_vmas(struct vm_area_struct *);
+int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
+int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
 void anon_vma_free(struct anon_vma *);
 
+static inline void anon_vma_merge(struct vm_area_struct *vma,
+				  struct vm_area_struct *next)
+{
+	VM_BUG_ON(vma->anon_vma != next->anon_vma);
+	unlink_anon_vmas(next);
+}
+
 /*
  * rmap interfaces called when adding or removing pte of page
  */
diff -puN kernel/fork.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue kernel/fork.c
--- a/kernel/fork.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/kernel/fork.c
@@ -329,15 +329,17 @@ static int dup_mmap(struct mm_struct *mm
 		if (!tmp)
 			goto fail_nomem;
 		*tmp = *mpnt;
+		INIT_LIST_HEAD(&tmp->anon_vma_chain);
 		pol = mpol_dup(vma_policy(mpnt));
 		retval = PTR_ERR(pol);
 		if (IS_ERR(pol))
 			goto fail_nomem_policy;
 		vma_set_policy(tmp, pol);
+		if (anon_vma_fork(tmp, mpnt))
+			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~VM_LOCKED;
 		tmp->vm_mm = mm;
 		tmp->vm_next = NULL;
-		anon_vma_link(tmp);
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file->f_path.dentry->d_inode;
@@ -392,6 +394,8 @@ out:
 	flush_tlb_mm(oldmm);
 	up_write(&oldmm->mmap_sem);
 	return retval;
+fail_nomem_anon_vma_fork:
+	mpol_put(pol);
 fail_nomem_policy:
 	kmem_cache_free(vm_area_cachep, tmp);
 fail_nomem:
diff -puN mm/ksm.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/ksm.c
--- a/mm/ksm.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/ksm.c
@@ -1563,10 +1563,12 @@ int page_referenced_ksm(struct page *pag
 again:
 	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
+		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
 		spin_lock(&anon_vma->lock);
-		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
+			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
 				continue;
@@ -1614,10 +1616,12 @@ int try_to_unmap_ksm(struct page *page, 
 again:
 	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
+		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
 		spin_lock(&anon_vma->lock);
-		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
+			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
 				continue;
@@ -1664,10 +1668,12 @@ int rmap_walk_ksm(struct page *page, int
 again:
 	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
+		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
 		spin_lock(&anon_vma->lock);
-		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
+			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
 				continue;
diff -puN mm/memory-failure.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/memory-failure.c
--- a/mm/memory-failure.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/memory-failure.c
@@ -383,9 +383,12 @@ static void collect_procs_anon(struct pa
 	if (av == NULL)	/* Not actually mapped anymore */
 		goto out;
 	for_each_process (tsk) {
+		struct anon_vma_chain *vmac;
+
 		if (!task_early_kill(tsk))
 			continue;
-		list_for_each_entry (vma, &av->head, anon_vma_node) {
+		list_for_each_entry(vmac, &av->head, same_anon_vma) {
+			vma = vmac->vma;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
 			if (vma->vm_mm == tsk->mm)
diff -puN mm/memory.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/memory.c
--- a/mm/memory.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/memory.c
@@ -374,7 +374,7 @@ void free_pgtables(struct mmu_gather *tl
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
 		 */
-		anon_vma_unlink(vma);
+		unlink_anon_vmas(vma);
 		unlink_file_vma(vma);
 
 		if (is_vm_hugetlb_page(vma)) {
@@ -388,7 +388,7 @@ void free_pgtables(struct mmu_gather *tl
 			       && !is_vm_hugetlb_page(next)) {
 				vma = next;
 				next = vma->vm_next;
-				anon_vma_unlink(vma);
+				unlink_anon_vmas(vma);
 				unlink_file_vma(vma);
 			}
 			free_pgd_range(tlb, addr, vma->vm_end,
diff -puN mm/mmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/mmap.c
--- a/mm/mmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/mmap.c
@@ -437,7 +437,6 @@ __vma_link(struct mm_struct *mm, struct 
 {
 	__vma_link_list(mm, vma, prev, rb_parent);
 	__vma_link_rb(mm, vma, rb_link, rb_parent);
-	__anon_vma_link(vma);
 }
 
 static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -499,7 +498,7 @@ __vma_unlink(struct mm_struct *mm, struc
  * are necessary.  The "insert" vma (if any) is to be inserted
  * before we drop the necessary locks.
  */
-void vma_adjust(struct vm_area_struct *vma, unsigned long start,
+int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -542,6 +541,28 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	/*
+	 * When changing only vma->vm_end, we don't really need anon_vma lock.
+	 */
+	if (vma->anon_vma && (insert || importer || start != vma->vm_start))
+		anon_vma = vma->anon_vma;
+	if (anon_vma) {
+		/*
+		 * Easily overlooked: when mprotect shifts the boundary,
+		 * make sure the expanding vma has anon_vma set if the
+		 * shrinking vma had, to cover any anon pages imported.
+		 */
+		if (importer && !importer->anon_vma) {
+			/* Block reverse map lookups until things are set up. */
+			importer->vm_flags |= VM_LOCK_RMAP;
+			if (anon_vma_clone(importer, vma)) {
+				importer->vm_flags &= ~VM_LOCK_RMAP;
+				return -ENOMEM;
+			}
+			importer->anon_vma = anon_vma;
+		}
+	}
+
 	if (file) {
 		mapping = file->f_mapping;
 		if (!(vma->vm_flags & VM_NONLINEAR))
@@ -567,25 +588,6 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
-	/*
-	 * When changing only vma->vm_end, we don't really need
-	 * anon_vma lock.
-	 */
-	if (vma->anon_vma && (insert || importer || start != vma->vm_start))
-		anon_vma = vma->anon_vma;
-	if (anon_vma) {
-		spin_lock(&anon_vma->lock);
-		/*
-		 * Easily overlooked: when mprotect shifts the boundary,
-		 * make sure the expanding vma has anon_vma set if the
-		 * shrinking vma had, to cover any anon pages imported.
-		 */
-		if (importer && !importer->anon_vma) {
-			importer->anon_vma = anon_vma;
-			__anon_vma_link(importer);
-		}
-	}
-
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_remove(vma, root);
@@ -616,8 +618,11 @@ again:			remove_next = 1 + (end > next->
 		__vma_unlink(mm, next, vma);
 		if (file)
 			__remove_shared_vm_struct(next, file, mapping);
-		if (next->anon_vma)
-			__anon_vma_merge(vma, next);
+		/*
+		 * This VMA is now dead, no need for rmap to follow it.
+		 * Call anon_vma_merge below, outside of i_mmap_lock.
+		 */
+		next->vm_flags |= VM_LOCK_RMAP;
 	} else if (insert) {
 		/*
 		 * split_vma has split insert from vma, and needs
@@ -627,17 +632,25 @@ again:			remove_next = 1 + (end > next->
 		__insert_vm_struct(mm, insert);
 	}
 
-	if (anon_vma)
-		spin_unlock(&anon_vma->lock);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
+	/*
+	 * The current VMA has been set up. It is now safe for the
+	 * rmap code to get from the pages to the ptes.
+	 */
+	if (anon_vma && importer)
+		importer->vm_flags &= ~VM_LOCK_RMAP;
+
 	if (remove_next) {
 		if (file) {
 			fput(file);
 			if (next->vm_flags & VM_EXECUTABLE)
 				removed_exe_file_vma(mm);
 		}
+		/* Protected by mmap_sem and VM_LOCK_RMAP. */
+		if (next->anon_vma)
+			anon_vma_merge(vma, next);
 		mm->map_count--;
 		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
@@ -653,6 +666,8 @@ again:			remove_next = 1 + (end > next->
 	}
 
 	validate_mm(mm);
+
+	return 0;
 }
 
 /*
@@ -759,6 +774,7 @@ struct vm_area_struct *vma_merge(struct 
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
+	int err;
 
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
@@ -792,11 +808,13 @@ struct vm_area_struct *vma_merge(struct 
 				is_mergeable_anon_vma(prev->anon_vma,
 						      next->anon_vma)) {
 							/* cases 1, 6 */
-			vma_adjust(prev, prev->vm_start,
+			err = vma_adjust(prev, prev->vm_start,
 				next->vm_end, prev->vm_pgoff, NULL);
 		} else					/* cases 2, 5, 7 */
-			vma_adjust(prev, prev->vm_start,
+			err = vma_adjust(prev, prev->vm_start,
 				end, prev->vm_pgoff, NULL);
+		if (err)
+			return NULL;
 		return prev;
 	}
 
@@ -808,11 +826,13 @@ struct vm_area_struct *vma_merge(struct 
 			can_vma_merge_before(next, vm_flags,
 					anon_vma, file, pgoff+pglen)) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
-			vma_adjust(prev, prev->vm_start,
+			err = vma_adjust(prev, prev->vm_start,
 				addr, prev->vm_pgoff, NULL);
 		else					/* cases 3, 8 */
-			vma_adjust(area, addr, next->vm_end,
+			err = vma_adjust(area, addr, next->vm_end,
 				next->vm_pgoff - pglen, NULL);
+		if (err)
+			return NULL;
 		return area;
 	}
 
@@ -1205,6 +1225,7 @@ munmap_back:
 	vma->vm_flags = vm_flags;
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 	vma->vm_pgoff = pgoff;
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
 	if (file) {
 		error = -EINVAL;
@@ -1865,6 +1886,7 @@ static int __split_vma(struct mm_struct 
 {
 	struct mempolicy *pol;
 	struct vm_area_struct *new;
+	int err = -ENOMEM;
 
 	if (is_vm_hugetlb_page(vma) && (addr &
 					~(huge_page_mask(hstate_vma(vma)))))
@@ -1872,11 +1894,13 @@ static int __split_vma(struct mm_struct 
 
 	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!new)
-		return -ENOMEM;
+		goto out_err;
 
 	/* most fields are the same, copy all, and then fixup */
 	*new = *vma;
 
+	INIT_LIST_HEAD(&new->anon_vma_chain);
+
 	if (new_below)
 		new->vm_end = addr;
 	else {
@@ -1886,11 +1910,14 @@ static int __split_vma(struct mm_struct 
 
 	pol = mpol_dup(vma_policy(vma));
 	if (IS_ERR(pol)) {
-		kmem_cache_free(vm_area_cachep, new);
-		return PTR_ERR(pol);
+		err = PTR_ERR(pol);
+		goto out_free_vma;
 	}
 	vma_set_policy(new, pol);
 
+	if (anon_vma_clone(new, vma))
+		goto out_free_mpol;
+
 	if (new->vm_file) {
 		get_file(new->vm_file);
 		if (vma->vm_flags & VM_EXECUTABLE)
@@ -1901,12 +1928,28 @@ static int __split_vma(struct mm_struct 
 		new->vm_ops->open(new);
 
 	if (new_below)
-		vma_adjust(vma, addr, vma->vm_end, vma->vm_pgoff +
+		err = vma_adjust(vma, addr, vma->vm_end, vma->vm_pgoff +
 			((addr - new->vm_start) >> PAGE_SHIFT), new);
 	else
-		vma_adjust(vma, vma->vm_start, addr, vma->vm_pgoff, new);
+		err = vma_adjust(vma, vma->vm_start, addr, vma->vm_pgoff, new);
 
-	return 0;
+	/* Success. */
+	if (!err)
+		return 0;
+
+	/* Clean everything up if vma_adjust failed. */
+	new->vm_ops->close(new);
+	if (new->vm_file) {
+		if (vma->vm_flags & VM_EXECUTABLE)
+			removed_exe_file_vma(mm);
+		fput(new->vm_file);
+	}
+ out_free_mpol:
+	mpol_put(pol);
+ out_free_vma:
+	kmem_cache_free(vm_area_cachep, new);
+ out_err:
+	return err;
 }
 
 /*
@@ -2116,6 +2159,7 @@ unsigned long do_brk(unsigned long addr,
 		return -ENOMEM;
 	}
 
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_mm = mm;
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
@@ -2252,10 +2296,11 @@ struct vm_area_struct *copy_vma(struct v
 		if (new_vma) {
 			*new_vma = *vma;
 			pol = mpol_dup(vma_policy(vma));
-			if (IS_ERR(pol)) {
-				kmem_cache_free(vm_area_cachep, new_vma);
-				return NULL;
-			}
+			if (IS_ERR(pol))
+				goto out_free_vma;
+			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
+			if (anon_vma_clone(new_vma, vma))
+				goto out_free_mempol;
 			vma_set_policy(new_vma, pol);
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
@@ -2271,6 +2316,12 @@ struct vm_area_struct *copy_vma(struct v
 		}
 	}
 	return new_vma;
+
+ out_free_mempol:
+	mpol_put(pol);
+ out_free_vma:
+	kmem_cache_free(vm_area_cachep, new_vma);
+	return NULL;
 }
 
 /*
@@ -2348,6 +2399,7 @@ int install_special_mapping(struct mm_st
 	if (unlikely(vma == NULL))
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_mm = mm;
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
@@ -2448,6 +2500,7 @@ static void vm_lock_mapping(struct mm_st
 int mm_take_all_locks(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
+	struct anon_vma_chain *avc;
 	int ret = -EINTR;
 
 	BUG_ON(down_read_trylock(&mm->mmap_sem));
@@ -2465,7 +2518,8 @@ int mm_take_all_locks(struct mm_struct *
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
-			vm_lock_anon_vma(mm, vma->anon_vma);
+			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+				vm_lock_anon_vma(mm, avc->anon_vma);
 	}
 
 	ret = 0;
@@ -2520,13 +2574,15 @@ static void vm_unlock_mapping(struct add
 void mm_drop_all_locks(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
+	struct anon_vma_chain *avc;
 
 	BUG_ON(down_read_trylock(&mm->mmap_sem));
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->anon_vma)
-			vm_unlock_anon_vma(vma->anon_vma);
+			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+				vm_unlock_anon_vma(avc->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
 			vm_unlock_mapping(vma->vm_file->f_mapping);
 	}
diff -puN mm/mremap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/mremap.c
--- a/mm/mremap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/mremap.c
@@ -460,8 +460,11 @@ unsigned long do_mremap(unsigned long ad
 		if (vma_expandable(vma, new_len - old_len)) {
 			int pages = (new_len - old_len) >> PAGE_SHIFT;
 
-			vma_adjust(vma, vma->vm_start,
-				addr + new_len, vma->vm_pgoff, NULL);
+			if (vma_adjust(vma, vma->vm_start, addr + new_len,
+				       vma->vm_pgoff, NULL)) {
+				ret = -ENOMEM;
+				goto out;
+			}
 
 			mm->total_vm += pages;
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
diff -puN mm/nommu.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/nommu.c
--- a/mm/nommu.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/nommu.c
@@ -1209,7 +1209,7 @@ unsigned long do_mmap_pgoff(struct file 
 	region->vm_flags = vm_flags;
 	region->vm_pgoff = pgoff;
 
-	INIT_LIST_HEAD(&vma->anon_vma_node);
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_flags = vm_flags;
 	vma->vm_pgoff = pgoff;
 
diff -puN mm/rmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue mm/rmap.c
--- a/mm/rmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue
+++ a/mm/rmap.c
@@ -62,6 +62,7 @@
 #include "internal.h"
 
 static struct kmem_cache *anon_vma_cachep;
+static struct kmem_cache *anon_vma_chain_cachep;
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
@@ -73,6 +74,16 @@ void anon_vma_free(struct anon_vma *anon
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
+static inline struct anon_vma_chain *anon_vma_chain_alloc(void)
+{
+	return kmem_cache_alloc(anon_vma_chain_cachep, GFP_KERNEL);
+}
+
+void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
+{
+	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
+}
+
 /**
  * anon_vma_prepare - attach an anon_vma to a memory region
  * @vma: the memory region in question
@@ -103,18 +114,23 @@ void anon_vma_free(struct anon_vma *anon
 int anon_vma_prepare(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma_chain *avc;
 
 	might_sleep();
 	if (unlikely(!anon_vma)) {
 		struct mm_struct *mm = vma->vm_mm;
 		struct anon_vma *allocated;
 
+		avc = anon_vma_chain_alloc();
+		if (!avc)
+			goto out_enomem;
+
 		anon_vma = find_mergeable_anon_vma(vma);
 		allocated = NULL;
 		if (!anon_vma) {
 			anon_vma = anon_vma_alloc();
 			if (unlikely(!anon_vma))
-				return -ENOMEM;
+				goto out_enomem_free_avc;
 			allocated = anon_vma;
 		}
 		spin_lock(&anon_vma->lock);
@@ -123,53 +139,113 @@ int anon_vma_prepare(struct vm_area_stru
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma = anon_vma;
-			list_add_tail(&vma->anon_vma_node, &anon_vma->head);
+			avc->anon_vma = anon_vma;
+			avc->vma = vma;
+			list_add(&avc->same_vma, &vma->anon_vma_chain);
+			list_add(&avc->same_anon_vma, &anon_vma->head);
 			allocated = NULL;
 		}
 		spin_unlock(&mm->page_table_lock);
 
 		spin_unlock(&anon_vma->lock);
-		if (unlikely(allocated))
+		if (unlikely(allocated)) {
 			anon_vma_free(allocated);
+			anon_vma_chain_free(avc);
+		}
 	}
 	return 0;
+
+ out_enomem_free_avc:
+	anon_vma_chain_free(avc);
+ out_enomem:
+	return -ENOMEM;
 }
 
-void __anon_vma_merge(struct vm_area_struct *vma, struct vm_area_struct *next)
-{
-	BUG_ON(vma->anon_vma != next->anon_vma);
-	list_del(&next->anon_vma_node);
+static void anon_vma_chain_link(struct vm_area_struct *vma,
+				struct anon_vma_chain *avc,
+				struct anon_vma *anon_vma)
+{
+	avc->vma = vma;
+	avc->anon_vma = anon_vma;
+	list_add(&avc->same_vma, &vma->anon_vma_chain);
+
+	spin_lock(&anon_vma->lock);
+	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
+	spin_unlock(&anon_vma->lock);
 }
 
-void __anon_vma_link(struct vm_area_struct *vma)
+/*
+ * Attach the anon_vmas from src to dst.
+ * Returns 0 on success, -ENOMEM on failure.
+ */
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma_chain *avc, *pavc;
+
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc();
+		if (!avc)
+			goto enomem_failure;
+		anon_vma_chain_link(dst, avc, pavc->anon_vma);
+	}
+	return 0;
 
-	if (anon_vma)
-		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
+ enomem_failure:
+	unlink_anon_vmas(dst);
+	return -ENOMEM;
 }
 
-void anon_vma_link(struct vm_area_struct *vma)
+/*
+ * Attach vma to its own anon_vma, as well as to the anon_vmas that
+ * the corresponding VMA in the parent process is attached to.
+ * Returns 0 on success, non-zero on failure.
+ */
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma_chain *avc;
+	struct anon_vma *anon_vma;
 
-	if (anon_vma) {
-		spin_lock(&anon_vma->lock);
-		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		spin_unlock(&anon_vma->lock);
-	}
+	/* Don't bother if the parent process has no anon_vma here. */
+	if (!pvma->anon_vma)
+		return 0;
+
+	/*
+	 * First, attach the new VMA to the parent VMA's anon_vmas,
+	 * so rmap can find non-COWed pages in child processes.
+	 */
+	if (anon_vma_clone(vma, pvma))
+		return -ENOMEM;
+
+	/* Then add our own anon_vma. */
+	anon_vma = anon_vma_alloc();
+	if (!anon_vma)
+		goto out_error;
+	avc = anon_vma_chain_alloc();
+	if (!avc)
+		goto out_error_free_anon_vma;
+	anon_vma_chain_link(vma, avc, anon_vma);
+	/* Mark this anon_vma as the one where our new (COWed) pages go. */
+	vma->anon_vma = anon_vma;
+
+	return 0;
+
+ out_error_free_anon_vma:
+	anon_vma_free(anon_vma);
+ out_error:
+	return -ENOMEM;
 }
 
-void anon_vma_unlink(struct vm_area_struct *vma)
+static void anon_vma_unlink(struct anon_vma_chain *anon_vma_chain)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma *anon_vma = anon_vma_chain->anon_vma;
 	int empty;
 
+	/* If anon_vma_fork fails, we can get an empty anon_vma_chain. */
 	if (!anon_vma)
 		return;
 
 	spin_lock(&anon_vma->lock);
-	list_del(&vma->anon_vma_node);
+	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
 	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma);
@@ -179,6 +255,18 @@ void anon_vma_unlink(struct vm_area_stru
 		anon_vma_free(anon_vma);
 }
 
+void unlink_anon_vmas(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc, *next;
+
+	/* Unlink each anon_vma chained to the VMA. */
+	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
+		anon_vma_unlink(avc);
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
+}
+
 static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;
@@ -192,6 +280,7 @@ void __init anon_vma_init(void)
 {
 	anon_vma_cachep = kmem_cache_create("anon_vma", sizeof(struct anon_vma),
 			0, SLAB_DESTROY_BY_RCU|SLAB_PANIC, anon_vma_ctor);
+	anon_vma_chain_cachep = KMEM_CACHE(anon_vma_chain, SLAB_PANIC);
 }
 
 /*
@@ -240,6 +329,18 @@ vma_address(struct page *page, struct vm
 		/* page should be within @vma mapping range */
 		return -EFAULT;
 	}
+	if (unlikely(vma->vm_flags & VM_LOCK_RMAP)) {
+		/*
+		 * This VMA is being unlinked or is not yet linked into the
+		 * VMA tree.  Do not try to follow this rmap.  This race
+		 * condition can result in page_referenced() ignoring a
+		 * reference or in try_to_unmap() failing to unmap a page.
+		 * The VMA cannot be freed under us because we hold the
+		 * anon_vma->lock, which the munmap code takes while
+		 * unlinking the anon_vmas from the VMA.
+		 */
+		return -EFAULT;
+	}
 	return address;
 }
 
@@ -396,7 +497,7 @@ static int page_referenced_anon(struct p
 {
 	unsigned int mapcount;
 	struct anon_vma *anon_vma;
-	struct vm_area_struct *vma;
+	struct anon_vma_chain *avc;
 	int referenced = 0;
 
 	anon_vma = page_lock_anon_vma(page);
@@ -404,7 +505,8 @@ static int page_referenced_anon(struct p
 		return referenced;
 
 	mapcount = page_mapcount(page);
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
@@ -1025,14 +1127,15 @@ static int try_to_unmap_cluster(unsigned
 static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 {
 	struct anon_vma *anon_vma;
-	struct vm_area_struct *vma;
+	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
 	anon_vma = page_lock_anon_vma(page);
 	if (!anon_vma)
 		return ret;
 
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
@@ -1223,7 +1326,7 @@ static int rmap_walk_anon(struct page *p
 		struct vm_area_struct *, unsigned long, void *), void *arg)
 {
 	struct anon_vma *anon_vma;
-	struct vm_area_struct *vma;
+	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
 	/*
@@ -1238,7 +1341,8 @@ static int rmap_walk_anon(struct page *p
 	if (!anon_vma)
 		return ret;
 	spin_lock(&anon_vma->lock);
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
_

Patches currently in -mm which might be from riel@redhat.com are

fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch

