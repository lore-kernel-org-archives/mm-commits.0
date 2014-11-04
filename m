From: akpm@linux-foundation.org
Subject: + mm-use-new-helper-functions-around-the-i_mmap_mutex.patch added to -mm tree
Date: Tue, 04 Nov 2014 15:04:42 -0800
Message-ID: <54595b8a.Saip9Qb9p+vtu7Sa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaKDXEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill.shutemov@intel.linux.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use new helper functions around the i_mmap_mutex
has been added to the -mm tree.  Its filename is
     mm-use-new-helper-functions-around-the-i_mmap_mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-new-helper-functions-around-the-i_mmap_mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm: use new helper functions around the i_mmap_mutex

Convert all open coded mutex_lock/unlock calls to the
i_mmap_[lock/unlock]_write() helpers.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    4 ++--
 kernel/events/uprobes.c |    4 ++--
 kernel/fork.c           |    4 ++--
 mm/filemap_xip.c        |    4 ++--
 mm/hugetlb.c            |   12 ++++++------
 mm/memory-failure.c     |    4 ++--
 mm/memory.c             |    8 ++++----
 mm/mmap.c               |   14 +++++++-------
 mm/mremap.c             |    4 ++--
 mm/nommu.c              |   14 +++++++-------
 mm/rmap.c               |    4 ++--
 11 files changed, 38 insertions(+), 38 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-use-new-helper-functions-around-the-i_mmap_mutex fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/fs/hugetlbfs/inode.c
@@ -412,10 +412,10 @@ static int hugetlb_vmtruncate(struct ino
 	pgoff = offset >> PAGE_SHIFT;
 
 	i_size_write(inode, offset);
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 	truncate_hugepages(inode, offset);
 	return 0;
 }
diff -puN kernel/events/uprobes.c~mm-use-new-helper-functions-around-the-i_mmap_mutex kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/kernel/events/uprobes.c
@@ -724,7 +724,7 @@ build_map_info(struct address_space *map
 	int more = 0;
 
  again:
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
@@ -755,7 +755,7 @@ build_map_info(struct address_space *map
 		info->mm = vma->vm_mm;
 		info->vaddr = offset_to_vaddr(vma, offset);
 	}
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 
 	if (!more)
 		goto out;
diff -puN kernel/fork.c~mm-use-new-helper-functions-around-the-i_mmap_mutex kernel/fork.c
--- a/kernel/fork.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/kernel/fork.c
@@ -433,7 +433,7 @@ static int dup_mmap(struct mm_struct *mm
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
-			mutex_lock(&mapping->i_mmap_mutex);
+			i_mmap_lock_write(mapping);
 			if (tmp->vm_flags & VM_SHARED)
 				atomic_inc(&mapping->i_mmap_writable);
 			flush_dcache_mmap_lock(mapping);
@@ -445,7 +445,7 @@ static int dup_mmap(struct mm_struct *mm
 				vma_interval_tree_insert_after(tmp, mpnt,
 							&mapping->i_mmap);
 			flush_dcache_mmap_unlock(mapping);
-			mutex_unlock(&mapping->i_mmap_mutex);
+			i_mmap_unlock_write(mapping);
 		}
 
 		/*
diff -puN mm/filemap_xip.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/filemap_xip.c
@@ -182,7 +182,7 @@ __xip_unmap (struct address_space * mapp
 		return;
 
 retry:
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
 		address = vma->vm_start +
@@ -202,7 +202,7 @@ retry:
 			page_cache_release(page);
 		}
 	}
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 
 	if (locked) {
 		mutex_unlock(&xip_sparse_mutex);
diff -puN mm/hugetlb.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/hugetlb.c
--- a/mm/hugetlb.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/hugetlb.c
@@ -2777,7 +2777,7 @@ static void unmap_ref_private(struct mm_
 	 * this mapping should be shared between all the VMAs,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(iter_vma, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2794,7 +2794,7 @@ static void unmap_ref_private(struct mm_
 			unmap_hugepage_range(iter_vma, address,
 					     address + huge_page_size(h), page);
 	}
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 }
 
 /*
@@ -3352,7 +3352,7 @@ unsigned long hugetlb_change_protection(
 	flush_cache_range(vma, address, end);
 
 	mmu_notifier_invalidate_range_start(mm, start, end);
-	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address);
@@ -3381,7 +3381,7 @@ unsigned long hugetlb_change_protection(
 	 */
 	flush_tlb_range(vma, start, end);
 	mmu_notifier_invalidate_range(mm, start, end);
-	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 
 	return pages << h->order;
@@ -3549,7 +3549,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
 
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -3577,7 +3577,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 	return pte;
 }
 
diff -puN mm/memory-failure.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/memory-failure.c
--- a/mm/memory-failure.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/memory-failure.c
@@ -466,7 +466,7 @@ static void collect_procs_file(struct pa
 	struct task_struct *tsk;
 	struct address_space *mapping = page->mapping;
 
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page_to_pgoff(page);
@@ -488,7 +488,7 @@ static void collect_procs_file(struct pa
 		}
 	}
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 }
 
 /*
diff -puN mm/memory.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/memory.c
--- a/mm/memory.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/memory.c
@@ -1341,9 +1341,9 @@ static void unmap_single_vma(struct mmu_
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
-				mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
+				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
-				mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+				i_mmap_unlock_write(vma->vm_file->f_mapping);
 			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
@@ -2392,12 +2392,12 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
diff -puN mm/mmap.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/mmap.c
--- a/mm/mmap.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/mmap.c
@@ -260,9 +260,9 @@ void unlink_file_vma(struct vm_area_stru
 
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 		__remove_shared_vm_struct(vma, file, mapping);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 	}
 }
 
@@ -674,14 +674,14 @@ static void vma_link(struct mm_struct *m
 
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 	}
 
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	__vma_link_file(vma);
 
 	if (mapping)
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -793,7 +793,7 @@ again:			remove_next = 1 + (end > next->
 							next->vm_end);
 		}
 
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 		if (insert) {
 			/*
 			 * Put into interval tree now, so instantiated pages
@@ -880,7 +880,7 @@ again:			remove_next = 1 + (end > next->
 		anon_vma_unlock_write(anon_vma);
 	}
 	if (mapping)
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 
 	if (root) {
 		uprobe_mmap(vma);
@@ -3176,7 +3176,7 @@ static void vm_unlock_mapping(struct add
 		 * AS_MM_ALL_LOCKS can't change to 0 from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
 					&mapping->flags))
 			BUG();
diff -puN mm/mremap.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/mremap.c
--- a/mm/mremap.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/mremap.c
@@ -119,7 +119,7 @@ static void move_ptes(struct vm_area_str
 	if (need_rmap_locks) {
 		if (vma->vm_file) {
 			mapping = vma->vm_file->f_mapping;
-			mutex_lock(&mapping->i_mmap_mutex);
+			i_mmap_lock_write(mapping);
 		}
 		if (vma->anon_vma) {
 			anon_vma = vma->anon_vma;
@@ -156,7 +156,7 @@ static void move_ptes(struct vm_area_str
 	if (anon_vma)
 		anon_vma_unlock_write(anon_vma);
 	if (mapping)
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 }
 
 #define LATENCY_LIMIT	(64 * PAGE_SIZE)
diff -puN mm/nommu.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/nommu.c
--- a/mm/nommu.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/nommu.c
@@ -722,11 +722,11 @@ static void add_vma_to_mm(struct mm_stru
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_insert(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 	}
 
 	/* add the VMA to the tree */
@@ -795,11 +795,11 @@ static void delete_vma_from_mm(struct vm
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_remove(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 	}
 
 	/* remove from the MM's tree and list */
@@ -2094,14 +2094,14 @@ int nommu_shrink_inode_mappings(struct i
 	high = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	down_write(&nommu_region_sem);
-	mutex_lock(&inode->i_mapping->i_mmap_mutex);
+	i_mmap_lock_write(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
 	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
-			mutex_unlock(&inode->i_mapping->i_mmap_mutex);
+			i_mmap_unlock_write(inode->i_mapping);
 			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
 		}
@@ -2129,7 +2129,7 @@ int nommu_shrink_inode_mappings(struct i
 		}
 	}
 
-	mutex_unlock(&inode->i_mapping->i_mmap_mutex);
+	i_mmap_unlock_write(inode->i_mapping);
 	up_write(&nommu_region_sem);
 	return 0;
 }
diff -puN mm/rmap.c~mm-use-new-helper-functions-around-the-i_mmap_mutex mm/rmap.c
--- a/mm/rmap.c~mm-use-new-helper-functions-around-the-i_mmap_mutex
+++ a/mm/rmap.c
@@ -1688,7 +1688,7 @@ static int rmap_walk_file(struct page *p
 
 	if (!mapping)
 		return ret;
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 
@@ -1711,7 +1711,7 @@ static int rmap_walk_file(struct page *p
 	ret = rwc->file_nonlinear(page, mapping, rwc->arg);
 
 done:
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_write(mapping);
 	return ret;
 }
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch

