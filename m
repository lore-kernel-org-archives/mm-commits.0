Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCC22E92B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675089; cv=none; b=IMZ+w57tjF9R8OSeUd0dtMR5g0czhtvJbsrEBoIBVx1ALD05GHmF+vd6IsCvTbai7qzSxnDtHjtEjVsvrqXVQpOELZTUl0TbJ4vtPBgh6mTU4sel9xU/+VXQsz08kKdEyrlcDsuyEk7Mz1cJpWKqMLCn3E39K+6QmZVfrEH4Q0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675089; c=relaxed/simple;
	bh=Ds0bh5KO5SLQh7Jk3C6Qyg2fQQf4Bio5x2qYi4LtNEo=;
	h=Date:To:From:Subject:Message-Id; b=kIJmM7DAzcH8qCxscb0J+iToUxyR5GV3z1uw4v47D20P0td7MZwAba5SxV0Iry12/0/Yv9EdJJTO8LCXFMhRfzRSnIWEUdbLAhFEwpI5FdBwNk0Rk1nI7pAzrAA3iA9BqDhHVUVEc+jExpwDTLol011FvHZqLi4PFiws3diJ4EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wjIN4fDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wjIN4fDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C6DC4CEF1;
	Thu, 20 Nov 2025 21:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675089;
	bh=Ds0bh5KO5SLQh7Jk3C6Qyg2fQQf4Bio5x2qYi4LtNEo=;
	h=Date:To:From:Subject:From;
	b=wjIN4fDgKuHMq6g40snE/4+VMQY1ZbhNY/EnAzi546pnB/bxnrwZpNMb1Vamf+cXK
	 WVrXymkUP/Y6wY8Trh8LRs+cH/BTq+Ro3icpSsABXh77p0MG/b1BNY5o+Vuyug4WLB
	 5za/hGfPzyaH4XauhgYJT/E7JFo9wEO++Uyea8e0=
Date: Thu, 20 Nov 2025 13:44:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,avagin@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-vma_modify_flags-to-handle-residual-flags-document.patch removed from -mm tree
Message-Id: <20251120214449.27C6DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update vma_modify_flags() to handle residual flags, document
has been removed from the -mm tree.  Its filename was
     mm-update-vma_modify_flags-to-handle-residual-flags-document.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update vma_modify_flags() to handle residual flags, document
Date: Tue, 18 Nov 2025 10:17:45 +0000

The vma_modify_*() family of functions each either perform splits, a merge
or no changes at all in preparation for the requested modification to
occur.

When doing so for a VMA flags change, we currently don't account for any
flags which may remain (for instance, VM_SOFTDIRTY) despite the requested
change in the case that a merge succeeded.

This is made more important by subsequent patches which will introduce the
concept of sticky VMA flags which rely on this behaviour.

This patch fixes this by passing the VMA flags parameter as a pointer and
updating it accordingly on merge and updating callers to accommodate for
this.

Additionally, while we are here, we add kdocs for each of the
vma_modify_*() functions, as the fact that the requested modification is
not performed is confusing so it is useful to make this abundantly clear.

We also update the VMA userland tests to account for this change.

Link: https://lkml.kernel.org/r/23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c            |    2 
 mm/mlock.c              |    2 
 mm/mprotect.c           |    2 
 mm/mseal.c              |    9 +-
 mm/vma.c                |   56 ++++++++-------
 mm/vma.h                |  138 ++++++++++++++++++++++++++++----------
 tools/testing/vma/vma.c |    3 
 7 files changed, 143 insertions(+), 69 deletions(-)

--- a/mm/madvise.c~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/mm/madvise.c
@@ -167,7 +167,7 @@ static int madvise_update_vma(vm_flags_t
 			range->start, range->end, anon_name);
 	else
 		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
-			range->start, range->end, new_flags);
+			range->start, range->end, &new_flags);
 
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
--- a/mm/mlock.c~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/mm/mlock.c
@@ -478,7 +478,7 @@ static int mlock_fixup(struct vma_iterat
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, newflags);
+	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
--- a/mm/mprotect.c~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/mm/mprotect.c
@@ -756,7 +756,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 		newflags &= ~VM_ACCOUNT;
 	}
 
-	vma = vma_modify_flags(vmi, *pprev, vma, start, end, newflags);
+	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
 	if (IS_ERR(vma)) {
 		error = PTR_ERR(vma);
 		goto fail;
--- a/mm/mseal.c~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/mm/mseal.c
@@ -66,12 +66,13 @@ static int mseal_apply(struct mm_struct
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
-		unsigned long curr_end = MIN(vma->vm_end, end);
+		const unsigned long curr_end = MIN(vma->vm_end, end);
 
 		if (!(vma->vm_flags & VM_SEALED)) {
-			vma = vma_modify_flags(&vmi, prev, vma,
-					curr_start, curr_end,
-					vma->vm_flags | VM_SEALED);
+			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
+
+			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
+					       curr_end, &vm_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
 			vm_flags_set(vma, VM_SEALED);
--- a/mm/vma.c~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/mm/vma.c
@@ -1638,25 +1638,35 @@ static struct vm_area_struct *vma_modify
 	return vma;
 }
 
-struct vm_area_struct *vma_modify_flags(
-	struct vma_iterator *vmi, struct vm_area_struct *prev,
-	struct vm_area_struct *vma, unsigned long start, unsigned long end,
-	vm_flags_t vm_flags)
+struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		vm_flags_t *vm_flags_ptr)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
+	const vm_flags_t vm_flags = *vm_flags_ptr;
+	struct vm_area_struct *ret;
 
 	vmg.vm_flags = vm_flags;
 
-	return vma_modify(&vmg);
+	ret = vma_modify(&vmg);
+	if (IS_ERR(ret))
+		return ret;
+
+	/*
+	 * For a merge to succeed, the flags must match those requested. For
+	 * flags which do not obey typical merge rules (i.e. do not need to
+	 * match), we must let the caller know about them.
+	 */
+	if (vmg.state == VMA_MERGE_SUCCESS)
+		*vm_flags_ptr = ret->vm_flags;
+	return ret;
 }
 
-struct vm_area_struct
-*vma_modify_name(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start,
-		       unsigned long end,
-		       struct anon_vma_name *new_name)
+struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct anon_vma_name *new_name)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
@@ -1665,12 +1675,10 @@ struct vm_area_struct
 	return vma_modify(&vmg);
 }
 
-struct vm_area_struct
-*vma_modify_policy(struct vma_iterator *vmi,
-		   struct vm_area_struct *prev,
-		   struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   struct mempolicy *new_pol)
+struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct mempolicy *new_pol)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
@@ -1679,14 +1687,10 @@ struct vm_area_struct
 	return vma_modify(&vmg);
 }
 
-struct vm_area_struct
-*vma_modify_flags_uffd(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct vm_userfaultfd_ctx new_ctx,
-		       bool give_up_on_oom)
+struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
--- a/mm/vma.h~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/mm/vma.h
@@ -263,47 +263,115 @@ void remove_vma(struct vm_area_struct *v
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
-/* We are about to modify the VMA's flags. */
-__must_check struct vm_area_struct
-*vma_modify_flags(struct vma_iterator *vmi,
+/**
+ * vma_modify_flags() - Peform any necessary split/merge in preparation for
+ * setting VMA flags to *@vm_flags in the range @start to @end contained within
+ * @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
+ * about to be set to. On merge, this will be updated to include any additional
+ * flags which remain in place.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * In order to account for VMA flags which may persist (e.g. soft-dirty), the
+ * @vm_flags_ptr parameter points to the requested flags which are then updated
+ * so the caller, should they overwrite any existing flags, correctly retains
+ * these.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * flags altered to *@vm_flags.
+ */
+__must_check struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
-		vm_flags_t vm_flags);
+		vm_flags_t *vm_flags_ptr);
 
-/* We are about to modify the VMA's anon_name. */
-__must_check struct vm_area_struct
-*vma_modify_name(struct vma_iterator *vmi,
-		 struct vm_area_struct *prev,
-		 struct vm_area_struct *vma,
-		 unsigned long start,
-		 unsigned long end,
-		 struct anon_vma_name *new_name);
-
-/* We are about to modify the VMA's memory policy. */
-__must_check struct vm_area_struct
-*vma_modify_policy(struct vma_iterator *vmi,
-		   struct vm_area_struct *prev,
-		   struct vm_area_struct *vma,
+/**
+ * vma_modify_name() - Peform any necessary split/merge in preparation for
+ * setting anonymous VMA name to @new_name in the range @start to @end contained
+ * within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @new_name: The anonymous VMA name that the @start to @end range is about to
+ * be set to.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * anonymous VMA name changed to @new_name.
+ */
+__must_check struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct anon_vma_name *new_name);
+
+/**
+ * vma_modify_policy() - Peform any necessary split/merge in preparation for
+ * setting NUMA policy to @new_pol in the range @start to @end contained
+ * within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @new_pol: The NUMA policy that the @start to @end range is about to be set
+ * to.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * NUMA policy changed to @new_pol.
+ */
+__must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
+		   struct vm_area_struct *prev, struct vm_area_struct *vma,
 		   unsigned long start, unsigned long end,
 		   struct mempolicy *new_pol);
 
-/* We are about to modify the VMA's flags and/or uffd context. */
-__must_check struct vm_area_struct
-*vma_modify_flags_uffd(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct vm_userfaultfd_ctx new_ctx,
-		       bool give_up_on_oom);
-
-__must_check struct vm_area_struct
-*vma_merge_new_range(struct vma_merge_struct *vmg);
-
-__must_check struct vm_area_struct
-*vma_merge_extend(struct vma_iterator *vmi,
-		  struct vm_area_struct *vma,
-		  unsigned long delta);
+/**
+ * vma_modify_flags_uffd() - Peform any necessary split/merge in preparation for
+ * setting VMA flags to @vm_flags and UFFD context to @new_ctx in the range
+ * @start to @end contained within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @vm_flags: The VMA flags that the @start to @end range is about to be set to.
+ * @new_ctx: The userfaultfd context that the @start to @end range is about to
+ * be set to.
+ * @give_up_on_oom: If an out of memory condition occurs on merge, simply give
+ * up on it and treat the merge as best-effort.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its VMA
+ * flags changed to @vm_flags and its userfaultfd context changed to @new_ctx.
+ */
+__must_check struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom);
+
+__must_check struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
+
+__must_check struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
+		  struct vm_area_struct *vma, unsigned long delta);
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb);
 
--- a/tools/testing/vma/vma.c~mm-update-vma_modify_flags-to-handle-residual-flags-document
+++ a/tools/testing/vma/vma.c
@@ -339,6 +339,7 @@ static bool test_simple_modify(void)
 	struct mm_struct mm = {};
 	struct vm_area_struct *init_vma = alloc_vma(&mm, 0, 0x3000, 0, vm_flags);
 	VMA_ITERATOR(vmi, &mm, 0x1000);
+	vm_flags_t flags = VM_READ | VM_MAYREAD;
 
 	ASSERT_FALSE(attach_vma(&mm, init_vma));
 
@@ -347,7 +348,7 @@ static bool test_simple_modify(void)
 	 * performs the merge/split only.
 	 */
 	vma = vma_modify_flags(&vmi, init_vma, init_vma,
-			       0x1000, 0x2000, VM_READ | VM_MAYREAD);
+			       0x1000, 0x2000, &flags);
 	ASSERT_NE(vma, NULL);
 	/* We modify the provided VMA, and on split allocate new VMAs. */
 	ASSERT_EQ(vma, init_vma);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch

