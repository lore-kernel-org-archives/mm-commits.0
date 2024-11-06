Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF6F1311AC
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854884; cv=none; b=VJGHgybItGz5Ey2PeymInMZoVsI6V+gIxyx5eKcOCR8QiRRCUOw+bCs+3EPzHJCGFQB1e6Gc039x2W/B9hdzgzlu5U9jANJ/hlvMgn8SwgFzmzXtWFZI16sVbYcOay6nE0mOx3erb64ThAnG/Q2X7GI5Z3FEdpO1Zii2SRHq8W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854884; c=relaxed/simple;
	bh=lO3ep8xUXzFmfVSXNRT/8OC/xP52pi063JVJCWdyH6Q=;
	h=Date:To:From:Subject:Message-Id; b=aqaqbbJVzeT07ciRtgAlZ4l8/IR2x37kJNyA9KSyXYeL+Zyh7gDwgZ8mdlRDSTbcaQUjzZkR8o9aFZDo/zr0p2PtVrwd2pesNDtu9iKPyTjwJpQz6gv+on4+URS+fb4qBPNLP5N+khw+OVhIe/7H5GdEiipG4OOD10+JHy0DqZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qNoDr1gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qNoDr1gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F96FC4CED1;
	Wed,  6 Nov 2024 01:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854884;
	bh=lO3ep8xUXzFmfVSXNRT/8OC/xP52pi063JVJCWdyH6Q=;
	h=Date:To:From:Subject:From;
	b=qNoDr1gm/wBFZdTKUEcJnRI5CdViFbv0M8P5KsP0mRIDLG3u3VGmpr1dSuhbQx7+o
	 Ws4Fcw/AO18EdXBmLPqN7JKITZpLmLNb+RWg2w5i815dNnXJGVJIG2zxHWiKFSHBfx
	 ZpiYJChqlaHarsYQD8WXQRwlfxZle41kPNivu/C8=
Date: Tue, 05 Nov 2024 17:01:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-__mmap_region.patch removed from -mm tree
Message-Id: <20241106010124.8F96FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor __mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-refactor-__mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: refactor __mmap_region()
Date: Fri, 25 Oct 2024 13:26:25 +0100

We have seen bugs and resource leaks arise from the complexity of the
__mmap_region() function.  This, and the generally deeply fragile error
handling logic and complexity which makes understanding the function
difficult make it highly desirable to refactor it into something readable.

Achieve this by separating the function into smaller logical parts which
are easier to understand and follow, and which importantly very
significantly simplify the error handling.

Note that we now call vms_abort_munmap_vmas() in more error paths than we
used to, however in cases where no abort need occur, vms->nr_pages will be
equal to zero and we simply exit this function without doing more than we
would have done previously.

Importantly, the invocation of the driver mmap hook via mmap_file() now
has very simple and obvious handling (this was previously the most
problematic part of the mmap() operation).

Use a generalised stack-based 'mmap state' to thread through values and
also retrieve state as needed.

Also avoid ever relying on vma merge (vmg) state after a merge is
attempted, instead maintain meaningful state in the mmap state and
establish vmg state as and when required.

This avoids any subtle bugs arising from merge logic mutating this state
and mmap_region() logic later relying upon it.

Link: https://lkml.kernel.org/r/25bd2edc3275450f448cbfe0756ce2a7cd06810f.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |  408 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 269 insertions(+), 139 deletions(-)

--- a/mm/vma.c~mm-refactor-__mmap_region
+++ a/mm/vma.c
@@ -7,6 +7,56 @@
 #include "vma_internal.h"
 #include "vma.h"
 
+struct mmap_state {
+	struct mm_struct *mm;
+	struct vma_iterator *vmi;
+
+	unsigned long addr;
+	unsigned long end;
+	pgoff_t pgoff;
+	unsigned long pglen;
+	unsigned long flags;
+	struct file *file;
+
+	unsigned long charged;
+
+	struct vm_area_struct *prev;
+	struct vm_area_struct *next;
+
+	/* Unmapping state. */
+	struct vma_munmap_struct vms;
+	struct ma_state mas_detach;
+	struct maple_tree mt_detach;
+};
+
+#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, flags_, file_) \
+	struct mmap_state name = {					\
+		.mm = mm_,						\
+		.vmi = vmi_,						\
+		.addr = addr_,						\
+		.end = (addr_) + len,					\
+		.pgoff = pgoff_,					\
+		.pglen = PHYS_PFN(len_),				\
+		.flags = flags_,					\
+		.file = file_,						\
+	}
+
+#define VMG_MMAP_STATE(name, map_, vma_)				\
+	struct vma_merge_struct name = {				\
+		.mm = (map_)->mm,					\
+		.vmi = (map_)->vmi,					\
+		.start = (map_)->addr,					\
+		.end = (map_)->end,					\
+		.flags = (map_)->flags,					\
+		.pgoff = (map_)->pgoff,					\
+		.file = (map_)->file,					\
+		.prev = (map_)->prev,					\
+		.vma = vma_,						\
+		.next = (vma_) ? NULL : (map_)->next,			\
+		.state = VMA_MERGE_START,				\
+		.merge_flags = VMG_FLAG_DEFAULT,			\
+	}
+
 static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_next)
 {
 	struct vm_area_struct *vma = merge_next ? vmg->next : vmg->prev;
@@ -2169,188 +2219,249 @@ static void vms_abort_munmap_vmas(struct
 	vms_complete_munmap_vmas(vms, mas_detach);
 }
 
-unsigned long __mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-		struct list_head *uf)
+/*
+ * __mmap_prepare() - Prepare to gather any overlapping VMAs that need to be
+ * unmapped once the map operation is completed, check limits, account mapping
+ * and clean up any pre-existing VMAs.
+ *
+ * @map: Mapping state.
+ * @uf:  Userfaultfd context list.
+ *
+ * Returns: 0 on success, error code otherwise.
+ */
+static int __mmap_prepare(struct mmap_state *map, struct list_head *uf)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = NULL;
-	pgoff_t pglen = PHYS_PFN(len);
-	unsigned long charged = 0;
-	struct vma_munmap_struct vms;
-	struct ma_state mas_detach;
-	struct maple_tree mt_detach;
-	unsigned long end = addr + len;
 	int error;
-	VMA_ITERATOR(vmi, mm, addr);
-	VMG_STATE(vmg, mm, &vmi, addr, end, vm_flags, pgoff);
+	struct vma_iterator *vmi = map->vmi;
+	struct vma_munmap_struct *vms = &map->vms;
 
-	vmg.file = file;
-	/* Find the first overlapping VMA */
-	vma = vma_find(&vmi, end);
-	init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
-	if (vma) {
-		mt_init_flags(&mt_detach, vmi.mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
-		mt_on_stack(mt_detach);
-		mas_init(&mas_detach, &mt_detach, /* addr = */ 0);
+	/* Find the first overlapping VMA and initialise unmap state. */
+	vms->vma = vma_find(vmi, map->end);
+	init_vma_munmap(vms, vmi, vms->vma, map->addr, map->end, uf,
+			/* unlock = */ false);
+
+	/* OK, we have overlapping VMAs - prepare to unmap them. */
+	if (vms->vma) {
+		mt_init_flags(&map->mt_detach,
+			      vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
+		mt_on_stack(map->mt_detach);
+		mas_init(&map->mas_detach, &map->mt_detach, /* addr = */ 0);
 		/* Prepare to unmap any existing mapping in the area */
-		error = vms_gather_munmap_vmas(&vms, &mas_detach);
-		if (error)
-			goto gather_failed;
+		error = vms_gather_munmap_vmas(vms, &map->mas_detach);
+		if (error) {
+			/* On error VMAs will already have been reattached. */
+			vms->nr_pages = 0;
+			return error;
+		}
 
-		vmg.next = vms.next;
-		vmg.prev = vms.prev;
-		vma = NULL;
+		map->next = vms->next;
+		map->prev = vms->prev;
 	} else {
-		vmg.next = vma_iter_next_rewind(&vmi, &vmg.prev);
+		map->next = vma_iter_next_rewind(vmi, &map->prev);
 	}
 
 	/* Check against address space limit. */
-	if (!may_expand_vm(mm, vm_flags, pglen - vms.nr_pages)) {
-		error = -ENOMEM;
-		goto abort_munmap;
-	}
+	if (!may_expand_vm(map->mm, map->flags, map->pglen - vms->nr_pages))
+		return -ENOMEM;
 
-	/*
-	 * Private writable mapping: check memory availability
-	 */
-	if (accountable_mapping(file, vm_flags)) {
-		charged = pglen;
-		charged -= vms.nr_accounted;
-		if (charged) {
-			error = security_vm_enough_memory_mm(mm, charged);
+	/* Private writable mapping: check memory availability. */
+	if (accountable_mapping(map->file, map->flags)) {
+		map->charged = map->pglen;
+		map->charged -= vms->nr_accounted;
+		if (map->charged) {
+			error = security_vm_enough_memory_mm(map->mm, map->charged);
 			if (error)
-				goto abort_munmap;
+				return error;
 		}
 
-		vms.nr_accounted = 0;
-		vm_flags |= VM_ACCOUNT;
-		vmg.flags = vm_flags;
+		vms->nr_accounted = 0;
+		map->flags |= VM_ACCOUNT;
 	}
 
 	/*
-	 * clear PTEs while the vma is still in the tree so that rmap
+	 * Clear PTEs while the vma is still in the tree so that rmap
 	 * cannot race with the freeing later in the truncate scenario.
 	 * This is also needed for mmap_file(), which is why vm_ops
 	 * close function is called.
 	 */
-	vms_clean_up_area(&vms, &mas_detach);
-	vma = vma_merge_new_range(&vmg);
-	if (vma)
-		goto expanded;
+	vms_clean_up_area(vms, &map->mas_detach);
+
+	return 0;
+}
+
+static int __mmap_new_file_vma(struct mmap_state *map,
+			       struct vm_area_struct **vmap, bool *mergedp)
+{
+	struct vma_iterator *vmi = map->vmi;
+	struct vm_area_struct *vma = *vmap;
+	int error;
+
+	vma->vm_file = get_file(map->file);
+	error = mmap_file(vma->vm_file, vma);
+	if (error) {
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
+
+		vma_iter_set(vmi, vma->vm_end);
+		/* Undo any partial mapping done by a device driver. */
+		unmap_region(&vmi->mas, vma, map->prev, map->next);
+
+		return error;
+	}
+
+	/* Drivers cannot alter the address of the VMA. */
+	WARN_ON_ONCE(map->addr != vma->vm_start);
+	/*
+	 * Drivers should not permit writability when previously it was
+	 * disallowed.
+	 */
+	VM_WARN_ON_ONCE(map->flags != vma->vm_flags &&
+			!(map->flags & VM_MAYWRITE) &&
+			(vma->vm_flags & VM_MAYWRITE));
+
+	/* mmap_file() might have changed VMA flags. */
+	map->flags = vma->vm_flags;
+
+	vma_iter_config(vmi, map->addr, map->end);
+	/*
+	 * If flags changed after mmap_file(), we should try merge
+	 * vma again as we may succeed this time.
+	 */
+	if (unlikely(map->flags != vma->vm_flags && map->prev)) {
+		struct vm_area_struct *merge;
+		VMG_MMAP_STATE(vmg, map, /* vma = */ NULL);
+
+		merge = vma_merge_new_range(&vmg);
+		if (merge) {
+			/*
+			 * ->mmap() can change vma->vm_file and fput
+			 * the original file. So fput the vma->vm_file
+			 * here or we would add an extra fput for file
+			 * and cause general protection fault
+			 * ultimately.
+			 */
+			fput(vma->vm_file);
+			vm_area_free(vma);
+			vma = merge;
+			*mergedp = true;
+		} else {
+			vma_iter_config(vmi, map->addr, map->end);
+		}
+	}
+
+	*vmap = vma;
+	return 0;
+}
+
+/*
+ * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
+ * possible.
+ *
+ * An exception to this is if the mapping is file-backed, and the underlying
+ * driver changes the VMA flags, permitting a subsequent merge of the VMA, in
+ * which case the returned VMA is one that was merged on a second attempt.
+ *
+ * @map:  Mapping state.
+ * @vmap: Output pointer for the new VMA.
+ *
+ * Returns: Zero on success, or an error.
+ */
+static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
+{
+	struct vma_iterator *vmi = map->vmi;
+	int error = 0;
+	bool merged = false;
+	struct vm_area_struct *vma;
+
 	/*
 	 * Determine the object being mapped and call the appropriate
 	 * specific mapper. the address has already been validated, but
 	 * not unmapped, but the maps are removed from the list.
 	 */
-	vma = vm_area_alloc(mm);
-	if (!vma) {
-		error = -ENOMEM;
-		goto unacct_error;
-	}
+	vma = vm_area_alloc(map->mm);
+	if (!vma)
+		return -ENOMEM;
 
-	vma_iter_config(&vmi, addr, end);
-	vma_set_range(vma, addr, end, pgoff);
-	vm_flags_init(vma, vm_flags);
-	vma->vm_page_prot = vm_get_page_prot(vm_flags);
+	vma_iter_config(vmi, map->addr, map->end);
+	vma_set_range(vma, map->addr, map->end, map->pgoff);
+	vm_flags_init(vma, map->flags);
+	vma->vm_page_prot = vm_get_page_prot(map->flags);
 
-	if (vma_iter_prealloc(&vmi, vma)) {
+	if (vma_iter_prealloc(vmi, vma)) {
 		error = -ENOMEM;
 		goto free_vma;
 	}
 
-	if (file) {
-		vma->vm_file = get_file(file);
-		error = mmap_file(file, vma);
-		if (error)
-			goto unmap_and_free_file_vma;
-
-		/* Drivers cannot alter the address of the VMA. */
-		WARN_ON_ONCE(addr != vma->vm_start);
-		/*
-		 * Drivers should not permit writability when previously it was
-		 * disallowed.
-		 */
-		VM_WARN_ON_ONCE(vm_flags != vma->vm_flags &&
-				!(vm_flags & VM_MAYWRITE) &&
-				(vma->vm_flags & VM_MAYWRITE));
-
-		vma_iter_config(&vmi, addr, end);
-		/*
-		 * If vm_flags changed after mmap_file(), we should try merge
-		 * vma again as we may succeed this time.
-		 */
-		if (unlikely(vm_flags != vma->vm_flags && vmg.prev)) {
-			struct vm_area_struct *merge;
-
-			vmg.flags = vma->vm_flags;
-			/* If this fails, state is reset ready for a reattempt. */
-			merge = vma_merge_new_range(&vmg);
-
-			if (merge) {
-				/*
-				 * ->mmap() can change vma->vm_file and fput
-				 * the original file. So fput the vma->vm_file
-				 * here or we would add an extra fput for file
-				 * and cause general protection fault
-				 * ultimately.
-				 */
-				fput(vma->vm_file);
-				vm_area_free(vma);
-				vma = merge;
-				/* Update vm_flags to pick up the change. */
-				vm_flags = vma->vm_flags;
-				goto file_expanded;
-			}
-			vma_iter_config(&vmi, addr, end);
-		}
-
-		vm_flags = vma->vm_flags;
-	} else if (vm_flags & VM_SHARED) {
+	if (map->file)
+		error = __mmap_new_file_vma(map, &vma, &merged);
+	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
-		if (error)
-			goto free_iter_vma;
-	} else {
+	else
 		vma_set_anonymous(vma);
-	}
+
+	if (error)
+		goto free_iter_vma;
+
+	if (merged)
+		goto file_expanded;
 
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(vm_flags));
+	WARN_ON_ONCE(!arch_validate_flags(map->flags));
 #endif
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
-	vma_iter_store(&vmi, vma);
-	mm->map_count++;
+	vma_iter_store(vmi, vma);
+	map->mm->map_count++;
 	vma_link_file(vma);
 
 	/*
 	 * vma_merge_new_range() calls khugepaged_enter_vma() too, the below
 	 * call covers the non-merge case.
 	 */
-	khugepaged_enter_vma(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, map->flags);
 
 file_expanded:
-	file = vma->vm_file;
 	ksm_add_vma(vma);
-expanded:
+	*vmap = vma;
+	return 0;
+
+free_iter_vma:
+	vma_iter_free(vmi);
+free_vma:
+	vm_area_free(vma);
+	return error;
+}
+
+/*
+ * __mmap_complete() - Unmap any VMAs we overlap, account memory mapping
+ *                     statistics, handle locking and finalise the VMA.
+ *
+ * @map: Mapping state.
+ * @vma: Merged or newly allocated VMA for the mmap()'d region.
+ */
+static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = map->mm;
+	unsigned long vm_flags = vma->vm_flags;
+
 	perf_event_mmap(vma);
 
-	/* Unmap any existing mapping in the area */
-	vms_complete_munmap_vmas(&vms, &mas_detach);
+	/* Unmap any existing mapping in the area. */
+	vms_complete_munmap_vmas(&map->vms, &map->mas_detach);
 
-	vm_stat_account(mm, vm_flags, pglen);
+	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
 		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
-					vma == get_gate_vma(current->mm))
+					vma == get_gate_vma(mm))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
 		else
-			mm->locked_vm += pglen;
+			mm->locked_vm += map->pglen;
 	}
 
-	if (file)
+	if (vma->vm_file)
 		uprobe_mmap(vma);
 
 	/*
@@ -2363,26 +2474,45 @@ expanded:
 	vm_flags_set(vma, VM_SOFTDIRTY);
 
 	vma_set_page_prot(vma);
+}
+
+unsigned long __mmap_region(struct file *file, unsigned long addr,
+		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
+		struct list_head *uf)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = NULL;
+	int error;
+	VMA_ITERATOR(vmi, mm, addr);
+	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vm_flags, file);
+
+	error = __mmap_prepare(&map, uf);
+	if (error)
+		goto abort_munmap;
+
+	/* Attempt to merge with adjacent VMAs... */
+	if (map.prev || map.next) {
+		VMG_MMAP_STATE(vmg, &map, /* vma = */ NULL);
+
+		vma = vma_merge_new_range(&vmg);
+	}
+
+	/* ...but if we can't, allocate a new VMA. */
+	if (!vma) {
+		error = __mmap_new_vma(&map, &vma);
+		if (error)
+			goto unacct_error;
+	}
+
+	__mmap_complete(&map, vma);
 
 	return addr;
 
-unmap_and_free_file_vma:
-	fput(vma->vm_file);
-	vma->vm_file = NULL;
-
-	vma_iter_set(&vmi, vma->vm_end);
-	/* Undo any partial mapping done by a device driver. */
-	unmap_region(&vmi.mas, vma, vmg.prev, vmg.next);
-free_iter_vma:
-	vma_iter_free(&vmi);
-free_vma:
-	vm_area_free(vma);
+	/* Accounting was done by __mmap_prepare(). */
 unacct_error:
-	if (charged)
-		vm_unacct_memory(charged);
-
+	if (map.charged)
+		vm_unacct_memory(map.charged);
 abort_munmap:
-	vms_abort_munmap_vmas(&vms, &mas_detach);
-gather_failed:
+	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

