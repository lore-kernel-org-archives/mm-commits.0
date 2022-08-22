Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB13C38142
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiHVTVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiHVTUz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EB813CC3
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A35E460F8D
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA53C433C1;
        Mon, 22 Aug 2022 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196017;
        bh=rtPR0OTXZ2eT/uJ25TU8Hxl7kKB0VolQJ0NuSZ4LoWg=;
        h=Date:To:From:Subject:From;
        b=SRrktE5CN5HpTYaOtCJBumc/HcxGVBZhkk8R2T8dfIakiC/kWK6yihCMuH2HsoC8s
         EbOpJ+w5YFVuwtxYGp4xtnkM6eC4EEezEanVvNwwQCOVFx6//5MKnc/KCtirzgaf+v
         jnc1CyrxNnpVMPZNj9tSV/iFIiQ1kw6Z78gLbxb4=
Date:   Mon, 22 Aug 2022 12:20:16 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch added to mm-unstable branch
Message-Id: <20220822192016.EEA53C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use advanced maple tree API for mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use advanced maple tree API for mmap_region()
Date: Mon, 22 Aug 2022 15:05:09 +0000

Changing mmap_region() to use the maple tree state and the advanced maple
tree interface allows for a lot less tree walking.

This change removes the last caller of munmap_vma_range(), so drop this
unused function.

Add vma_expand() to expand a VMA if possible by doing the necessary
hugepage check, uprobe_munmap of files, dcache flush, modifications then
undoing the detaches, etc.

Link: https://lkml.kernel.org/r/20220822150128.1562046-25-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |  251 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 203 insertions(+), 48 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-advanced-maple-tree-api-for-mmap_region
+++ a/mm/mmap.c
@@ -470,28 +470,6 @@ static inline struct vm_area_struct *__v
 	return vma->vm_next;
 }
 
-/*
- * munmap_vma_range() - munmap VMAs that overlap a range.
- * @mm: The mm struct
- * @start: The start of the range.
- * @len: The length of the range.
- * @pprev: pointer to the pointer that will be set to previous vm_area_struct
- *
- * Find all the vm_area_struct that overlap from @start to
- * @end and munmap them.  Set @pprev to the previous vm_area_struct.
- *
- * Returns: -ENOMEM on munmap failure or 0 on success.
- */
-static inline int
-munmap_vma_range(struct mm_struct *mm, unsigned long start, unsigned long len,
-		 struct vm_area_struct **pprev, struct list_head *uf)
-{
-	while (range_has_overlap(mm, start, start + len, pprev))
-		if (do_munmap(mm, start, len, uf))
-			return -ENOMEM;
-	return 0;
-}
-
 static unsigned long count_vma_pages_range(struct mm_struct *mm,
 		unsigned long addr, unsigned long end)
 {
@@ -619,6 +597,129 @@ static void __insert_vm_struct(struct mm
 }
 
 /*
+ * vma_expand - Expand an existing VMA
+ *
+ * @mas: The maple state
+ * @vma: The vma to expand
+ * @start: The start of the vma
+ * @end: The exclusive end of the vma
+ * @pgoff: The page offset of vma
+ * @next: The current of next vma.
+ *
+ * Expand @vma to @start and @end.  Can expand off the start and end.  Will
+ * expand over @next if it's different from @vma and @end == @next->vm_end.
+ * Checking if the @vma can expand and merge with @next needs to be handled by
+ * the caller.
+ *
+ * Returns: 0 on success
+ */
+inline int vma_expand(struct ma_state *mas, struct vm_area_struct *vma,
+		      unsigned long start, unsigned long end, pgoff_t pgoff,
+		      struct vm_area_struct *next)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct address_space *mapping = NULL;
+	struct rb_root_cached *root = NULL;
+	struct anon_vma *anon_vma = vma->anon_vma;
+	struct file *file = vma->vm_file;
+	bool remove_next = false;
+
+	if (next && (vma != next) && (end == next->vm_end)) {
+		remove_next = true;
+		if (next->anon_vma && !vma->anon_vma) {
+			int error;
+
+			anon_vma = next->anon_vma;
+			vma->anon_vma = anon_vma;
+			error = anon_vma_clone(vma, next);
+			if (error)
+				return error;
+		}
+	}
+
+	/* Not merging but overwriting any part of next is not handled. */
+	VM_BUG_ON(next && !remove_next && next != vma && end > next->vm_start);
+	/* Only handles expanding */
+	VM_BUG_ON(vma->vm_start < start || vma->vm_end > end);
+
+	if (mas_preallocate(mas, vma, GFP_KERNEL))
+		goto nomem;
+
+	vma_adjust_trans_huge(vma, start, end, 0);
+
+	if (file) {
+		mapping = file->f_mapping;
+		root = &mapping->i_mmap;
+		uprobe_munmap(vma, vma->vm_start, vma->vm_end);
+		i_mmap_lock_write(mapping);
+	}
+
+	if (anon_vma) {
+		anon_vma_lock_write(anon_vma);
+		anon_vma_interval_tree_pre_update_vma(vma);
+	}
+
+	if (file) {
+		flush_dcache_mmap_lock(mapping);
+		vma_interval_tree_remove(vma, root);
+	}
+
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	/* Note: mas must be pointing to the expanding VMA */
+	vma_mas_store(vma, mas);
+
+	if (file) {
+		vma_interval_tree_insert(vma, root);
+		flush_dcache_mmap_unlock(mapping);
+	}
+
+	/* Expanding over the next vma */
+	if (remove_next) {
+		/* Remove from mm linked list - also updates highest_vm_end */
+		__vma_unlink_list(mm, next);
+
+		/* Kill the cache */
+		vmacache_invalidate(mm);
+
+		if (file)
+			__remove_shared_vm_struct(next, file, mapping);
+
+	} else if (!next) {
+		mm->highest_vm_end = vm_end_gap(vma);
+	}
+
+	if (anon_vma) {
+		anon_vma_interval_tree_post_update_vma(vma);
+		anon_vma_unlock_write(anon_vma);
+	}
+
+	if (file) {
+		i_mmap_unlock_write(mapping);
+		uprobe_mmap(vma);
+	}
+
+	if (remove_next) {
+		if (file) {
+			uprobe_munmap(next, next->vm_start, next->vm_end);
+			fput(file);
+		}
+		if (next->anon_vma)
+			anon_vma_merge(vma, next);
+		mm->map_count--;
+		mpol_put(vma_policy(next));
+		vm_area_free(next);
+	}
+
+	validate_mm(mm);
+	return 0;
+
+nomem:
+	return -ENOMEM;
+}
+
+/*
  * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
  * is already present in an i_mmap tree without adjusting the tree.
  * The following helper function should be used when such adjustments
@@ -1630,9 +1731,15 @@ unsigned long mmap_region(struct file *f
 		struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev, *merge;
-	int error;
+	struct vm_area_struct *vma = NULL;
+	struct vm_area_struct *next, *prev, *merge;
+	pgoff_t pglen = len >> PAGE_SHIFT;
 	unsigned long charged = 0;
+	unsigned long end = addr + len;
+	unsigned long merge_start = addr, merge_end = end;
+	pgoff_t vm_pgoff;
+	int error;
+	MA_STATE(mas, &mm->mm_mt, addr, end - 1);
 
 	/* Check against address space limit. */
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT)) {
@@ -1642,16 +1749,17 @@ unsigned long mmap_region(struct file *f
 		 * MAP_FIXED may remove pages of mappings that intersects with
 		 * requested mapping. Account for the pages it would unmap.
 		 */
-		nr_pages = count_vma_pages_range(mm, addr, addr + len);
+		nr_pages = count_vma_pages_range(mm, addr, end);
 
 		if (!may_expand_vm(mm, vm_flags,
 					(len >> PAGE_SHIFT) - nr_pages))
 			return -ENOMEM;
 	}
 
-	/* Clear old maps, set up prev and uf */
-	if (munmap_vma_range(mm, addr, len, &prev, uf))
+	/* Unmap any existing mapping in the area */
+	if (do_munmap(mm, addr, len, uf))
 		return -ENOMEM;
+
 	/*
 	 * Private writable mapping: check memory availability
 	 */
@@ -1662,14 +1770,43 @@ unsigned long mmap_region(struct file *f
 		vm_flags |= VM_ACCOUNT;
 	}
 
-	/*
-	 * Can we just expand an old mapping?
-	 */
-	vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
-			NULL, file, pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
-	if (vma)
-		goto out;
+	next = mas_next(&mas, ULONG_MAX);
+	prev = mas_prev(&mas, 0);
+	if (vm_flags & VM_SPECIAL)
+		goto cannot_expand;
 
+	/* Attempt to expand an old mapping */
+	/* Check next */
+	if (next && next->vm_start == end && !vma_policy(next) &&
+	    can_vma_merge_before(next, vm_flags, NULL, file, pgoff+pglen,
+				 NULL_VM_UFFD_CTX, NULL)) {
+		merge_end = next->vm_end;
+		vma = next;
+		vm_pgoff = next->vm_pgoff - pglen;
+	}
+
+	/* Check prev */
+	if (prev && prev->vm_end == addr && !vma_policy(prev) &&
+	    (vma ? can_vma_merge_after(prev, vm_flags, vma->anon_vma, file,
+				       pgoff, vma->vm_userfaultfd_ctx, NULL) :
+		   can_vma_merge_after(prev, vm_flags, NULL, file, pgoff,
+				       NULL_VM_UFFD_CTX, NULL))) {
+		merge_start = prev->vm_start;
+		vma = prev;
+		vm_pgoff = prev->vm_pgoff;
+	}
+
+
+	/* Actually expand, if possible */
+	if (vma &&
+	    !vma_expand(&mas, vma, merge_start, merge_end, vm_pgoff, next)) {
+		khugepaged_enter_vma(vma, vm_flags);
+		goto expanded;
+	}
+
+	mas.index = addr;
+	mas.last = end - 1;
+cannot_expand:
 	/*
 	 * Determine the object being mapped and call the appropriate
 	 * specific mapper. the address has already been validated, but
@@ -1682,7 +1819,7 @@ unsigned long mmap_region(struct file *f
 	}
 
 	vma->vm_start = addr;
-	vma->vm_end = addr + len;
+	vma->vm_end = end;
 	vma->vm_flags = vm_flags;
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 	vma->vm_pgoff = pgoff;
@@ -1703,28 +1840,32 @@ unsigned long mmap_region(struct file *f
 		 *
 		 * Answer: Yes, several device drivers can do it in their
 		 *         f_op->mmap method. -DaveM
-		 * Bug: If addr is changed, prev, rb_link, rb_parent should
-		 *      be updated for vma_link()
 		 */
 		WARN_ON_ONCE(addr != vma->vm_start);
 
 		addr = vma->vm_start;
+		mas_reset(&mas);
 
-		/* If vm_flags changed after call_mmap(), we should try merge vma again
-		 * as we may succeed this time.
+		/*
+		 * If vm_flags changed after call_mmap(), we should try merge
+		 * vma again as we may succeed this time.
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && prev)) {
 			merge = vma_merge(mm, prev, vma->vm_start, vma->vm_end, vma->vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
 			if (merge) {
-				/* ->mmap() can change vma->vm_file and fput the original file. So
-				 * fput the vma->vm_file here or we would add an extra fput for file
-				 * and cause general protection fault ultimately.
+				/*
+				 * ->mmap() can change vma->vm_file and fput
+				 * the original file. So fput the vma->vm_file
+				 * here or we would add an extra fput for file
+				 * and cause general protection fault
+				 * ultimately.
 				 */
 				fput(vma->vm_file);
 				vm_area_free(vma);
 				vma = merge;
 				/* Update vm_flags to pick up the change. */
+				addr = vma->vm_start;
 				vm_flags = vma->vm_flags;
 				goto unmap_writable;
 			}
@@ -1748,7 +1889,7 @@ unsigned long mmap_region(struct file *f
 			goto free_vma;
 	}
 
-	if (vma_link(mm, vma, prev)) {
+	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
 		error = -ENOMEM;
 		if (file)
 			goto unmap_and_free_vma;
@@ -1756,6 +1897,22 @@ unsigned long mmap_region(struct file *f
 			goto free_vma;
 	}
 
+	if (vma->vm_file)
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+
+	vma_mas_store(vma, &mas);
+	__vma_link_list(mm, vma, prev);
+	mm->map_count++;
+	if (vma->vm_file) {
+		if (vma->vm_flags & VM_SHARED)
+			mapping_allow_writable(vma->vm_file->f_mapping);
+
+		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
+		vma_interval_tree_insert(vma, &vma->vm_file->f_mapping->i_mmap);
+		flush_dcache_mmap_unlock(vma->vm_file->f_mapping);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	}
+
 	/*
 	 * vma_merge() calls khugepaged_enter_vma() either, the below
 	 * call covers the non-merge case.
@@ -1767,7 +1924,7 @@ unmap_writable:
 	if (file && vm_flags & VM_SHARED)
 		mapping_unmap_writable(file->f_mapping);
 	file = vma->vm_file;
-out:
+expanded:
 	perf_event_mmap(vma);
 
 	vm_stat_account(mm, vm_flags, len >> PAGE_SHIFT);
@@ -1794,6 +1951,7 @@ out:
 
 	vma_set_page_prot(vma);
 
+	validate_mm(mm);
 	return addr;
 
 unmap_and_free_vma:
@@ -1809,6 +1967,7 @@ free_vma:
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
+	validate_mm(mm);
 	return error;
 }
 
@@ -2632,10 +2791,6 @@ int __do_munmap(struct mm_struct *mm, un
 	prev = vma->vm_prev;
 	/* we have start < vma->vm_end  */
 
-	/* if it doesn't overlap, we have nothing.. */
-	if (vma->vm_start >= end)
-		return 0;
-
 	/*
 	 * If we need to split any vma, do it now to save pain later.
 	 *
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple-tree-add-new-data-structure.patch
radix-tree-test-suite-add-pr_err-define.patch
radix-tree-test-suite-add-kmem_cache_set_non_kernel.patch
radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache.patch
radix-tree-test-suite-add-support-for-slab-bulk-apis.patch
radix-tree-test-suite-add-lockdep_is_held-to-header.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mm-start-tracking-vmas-with-maple-tree.patch
mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree.patch
mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree.patch
mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch
mm-remove-rb-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
xen-use-vma_lookup-in-privcmd_ioctl_mmap.patch
mm-optimize-find_exact_vma-to-use-vma_lookup.patch
mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap.patch
mm-use-maple-tree-operations-for-find_vma_intersection.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch
mm-remove-vmacache.patch
mm-convert-vma_lookup-to-use-mtree_load.patch
mm-mmap-move-mmap_region-below-do_munmap.patch
mm-mmap-reorganize-munmap-to-use-maple-states.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap.patch
arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch
fs-proc-base-use-maple-tree-iterators-in-place-of-linked-list.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch
ipc-shm-use-vma-iterator-instead-of-linked-list.patch
bpf-remove-vma-linked-list.patch
mm-gup-use-maple-tree-navigation-instead-of-linked-list.patch
mm-madvise-use-vma_find-instead-of-vma-linked-list.patch
mm-memcontrol-stop-using-mm-highest_vm_end.patch
mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch
mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list.patch
mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list.patch
mm-msync-use-vma_find-instead-of-vma-linked-list.patch
mm-oom_kill-use-maple-tree-iterators-instead-of-vma-linked-list.patch
mm-swapfile-use-vma-iterator-instead-of-vma-linked-list.patch
riscv-use-vma-iterator-for-vdso.patch
mm-remove-the-vma-linked-list.patch
mm-mmap-drop-range_has_overlap-function.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch

