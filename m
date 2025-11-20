Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FD92E92B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675090; cv=none; b=rBy8Uv5/OvlAwgF08gmID1eE2aIT+ILArt386ajpJGOI8qluwmx8qN/3aNC+XX7pArDF454tvOQAWH9184fQUnY5a4IqnUgPbqGkAMPHOBuQb4J6qyGYowbn/nwq0XK3w9BM3kkbl2vfFwlsU+ynrckpzGUshTU7P8xOpNf+tp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675090; c=relaxed/simple;
	bh=aKpS3eyRHmDxcG3/QrudK6hm8+wy41zK2J9Ff6Rq8KI=;
	h=Date:To:From:Subject:Message-Id; b=VDbZrGuUCltM6k/TS+Qy0Zr1Xq1FaYDO3mFJRUiRZ35h99d0g9RX88RiiYnc90HaQNELYAaC0v8A5KJAddxXRamofc4voEU59oocfAIb8oZbByYD9wXeVfVmHqPQzNwk8V3Vcgqi6sA/lebvnvftYoGNBJMP0M3PdAff02uCncs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omLOB5WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omLOB5WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B5EC4CEF1;
	Thu, 20 Nov 2025 21:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675090;
	bh=aKpS3eyRHmDxcG3/QrudK6hm8+wy41zK2J9Ff6Rq8KI=;
	h=Date:To:From:Subject:From;
	b=omLOB5WNLqBlNvU73LEbPR3Y9ITrPwTLubXKYc0E5CxOSEQFc9N4SQ621QAmjHL5z
	 vA2DnH6b5tuKy3g0Cf+8xOKL5jOKTesosWw7jKU+bidXYbIlYFqh5u19PN408QXyCD
	 31vWcAmRowBqcgxXlanxmP63n7gAuvDXiCFQETUk=
Date: Thu, 20 Nov 2025 13:44:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,avagin@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-implement-sticky-vma-flags.patch removed from -mm tree
Message-Id: <20251120214450.30B5EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: implement sticky VMA flags
has been removed from the -mm tree.  Its filename was
     mm-implement-sticky-vma-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: implement sticky VMA flags
Date: Tue, 18 Nov 2025 10:17:46 +0000

It is useful to be able to designate that certain flags are 'sticky', that
is, if two VMAs are merged one with a flag of this nature and one without,
the merged VMA sets this flag.

As a result we ignore these flags for the purposes of determining VMA flag
differences between VMAs being considered for merge.

This patch therefore updates the VMA merge logic to perform this action,
with flags possessing this property being described in the VM_STICKY
bitmap.

Those flags which ought to be ignored for the purposes of VMA merge are
described in the VM_IGNORE_MERGE bitmap, which the VMA merge logic is also
updated to use.

As part of this change we place VM_SOFTDIRTY in VM_IGNORE_MERGE as it
already had this behaviour, alongside VM_STICKY as sticky flags by
implication must not disallow merge.

Ultimately it seems that we should make VM_SOFTDIRTY a sticky flag in its
own right, but this change is out of scope for this series.

The only sticky flag designated as such is VM_MAYBE_GUARD, so as a result
of this change, once the VMA flag is set upon guard region installation,
VMAs with guard ranges will now not have their merge behaviour impacted as
a result and can be freely merged with other VMAs without VM_MAYBE_GUARD
set.

Also update the comments for vma_modify_flags() to directly reference
sticky flags now we have established the concept.

We also update the VMA userland tests to account for the changes.

Link: https://lkml.kernel.org/r/22ad5269f7669d62afb42ce0c79bad70b994c58d.1763460113.git.lorenzo.stoakes@oracle.com
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

 include/linux/mm.h               |   28 ++++++++++++++++++++++++++++
 mm/vma.c                         |   28 +++++++++++++++-------------
 mm/vma.h                         |   10 ++++------
 tools/testing/vma/vma_internal.h |   28 ++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-implement-sticky-vma-flags
+++ a/include/linux/mm.h
@@ -528,6 +528,34 @@ extern unsigned int kobjsize(const void
 #define VM_FLAGS_CLEAR	(ARCH_VM_PKEY_FLAGS | VM_ARCH_CLEAR)
 
 /*
+ * Flags which should be 'sticky' on merge - that is, flags which, when one VMA
+ * possesses it but the other does not, the merged VMA should nonetheless have
+ * applied to it:
+ *
+ * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
+ *                  mapped page tables may contain metadata not described by the
+ *                  VMA and thus any merged VMA may also contain this metadata,
+ *                  and thus we must make this flag sticky.
+ */
+#define VM_STICKY VM_MAYBE_GUARD
+
+/*
+ * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
+ * of these flags and the other not does not preclude a merge.
+ *
+ * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
+ *                dirty bit -- the caller should mark merged VMA as dirty. If
+ *                dirty bit won't be excluded from comparison, we increase
+ *                pressure on the memory system forcing the kernel to generate
+ *                new VMAs when old one could be extended instead.
+ *
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+
+/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
--- a/mm/vma.c~mm-implement-sticky-vma-flags
+++ a/mm/vma.c
@@ -89,15 +89,7 @@ static inline bool is_mergeable_vma(stru
 
 	if (!mpol_equal(vmg->policy, vma_policy(vma)))
 		return false;
-	/*
-	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
-	 * match the flags but dirty bit -- the caller should mark
-	 * merged VMA as dirty. If dirty bit won't be excluded from
-	 * comparison, we increase pressure on the memory system forcing
-	 * the kernel to generate new VMAs when old one could be
-	 * extended instead.
-	 */
-	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_SOFTDIRTY)
+	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_IGNORE_MERGE)
 		return false;
 	if (vma->vm_file != vmg->file)
 		return false;
@@ -808,6 +800,7 @@ static bool can_merge_remove_vma(struct
 static __must_check struct vm_area_struct *vma_merge_existing_range(
 		struct vma_merge_struct *vmg)
 {
+	vm_flags_t sticky_flags = vmg->vm_flags & VM_STICKY;
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next;
@@ -900,11 +893,13 @@ static __must_check struct vm_area_struc
 	if (merge_right) {
 		vma_start_write(next);
 		vmg->target = next;
+		sticky_flags |= (next->vm_flags & VM_STICKY);
 	}
 
 	if (merge_left) {
 		vma_start_write(prev);
 		vmg->target = prev;
+		sticky_flags |= (prev->vm_flags & VM_STICKY);
 	}
 
 	if (merge_both) {
@@ -974,6 +969,7 @@ static __must_check struct vm_area_struc
 	if (err || commit_merge(vmg))
 		goto abort;
 
+	vm_flags_set(vmg->target, sticky_flags);
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1124,6 +1120,10 @@ int vma_expand(struct vma_merge_struct *
 	bool remove_next = false;
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
+	vm_flags_t sticky_flags;
+
+	sticky_flags = vmg->vm_flags & VM_STICKY;
+	sticky_flags |= target->vm_flags & VM_STICKY;
 
 	VM_WARN_ON_VMG(!target, vmg);
 
@@ -1133,6 +1133,7 @@ int vma_expand(struct vma_merge_struct *
 	if (next && (target != next) && (vmg->end == next->vm_end)) {
 		int ret;
 
+		sticky_flags |= next->vm_flags & VM_STICKY;
 		remove_next = true;
 		/* This should already have been checked by this point. */
 		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
@@ -1159,6 +1160,7 @@ int vma_expand(struct vma_merge_struct *
 	if (commit_merge(vmg))
 		goto nomem;
 
+	vm_flags_set(target, sticky_flags);
 	return 0;
 
 nomem:
@@ -1654,9 +1656,9 @@ struct vm_area_struct *vma_modify_flags(
 		return ret;
 
 	/*
-	 * For a merge to succeed, the flags must match those requested. For
-	 * flags which do not obey typical merge rules (i.e. do not need to
-	 * match), we must let the caller know about them.
+	 * For a merge to succeed, the flags must match those
+	 * requested. However, sticky flags may have been retained, so propagate
+	 * them to the caller.
 	 */
 	if (vmg.state == VMA_MERGE_SUCCESS)
 		*vm_flags_ptr = ret->vm_flags;
@@ -1906,7 +1908,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_SOFTDIRTY)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_IGNORE_MERGE)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
--- a/mm/vma.h~mm-implement-sticky-vma-flags
+++ a/mm/vma.h
@@ -273,17 +273,15 @@ void unmap_region(struct ma_state *mas,
  * @start: The start of the range to update. May be offset within @vma.
  * @end: The exclusive end of the range to update, may be offset within @vma.
  * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
- * about to be set to. On merge, this will be updated to include any additional
- * flags which remain in place.
+ * about to be set to. On merge, this will be updated to include sticky flags.
  *
  * IMPORTANT: The actual modification being requested here is NOT applied,
  * rather the VMA is perhaps split, perhaps merged to accommodate the change,
  * and the caller is expected to perform the actual modification.
  *
- * In order to account for VMA flags which may persist (e.g. soft-dirty), the
- * @vm_flags_ptr parameter points to the requested flags which are then updated
- * so the caller, should they overwrite any existing flags, correctly retains
- * these.
+ * In order to account for sticky VMA flags, the @vm_flags_ptr parameter points
+ * to the requested flags which are then updated so the caller, should they
+ * overwrite any existing flags, correctly retains these.
  *
  * Returns: A VMA which contains the range @start to @end ready to have its
  * flags altered to *@vm_flags.
--- a/tools/testing/vma/vma_internal.h~mm-implement-sticky-vma-flags
+++ a/tools/testing/vma/vma_internal.h
@@ -117,6 +117,34 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_SEALED	VM_NONE
 #endif
 
+/*
+ * Flags which should be 'sticky' on merge - that is, flags which, when one VMA
+ * possesses it but the other does not, the merged VMA should nonetheless have
+ * applied to it:
+ *
+ * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
+ *                  mapped page tables may contain metadata not described by the
+ *                  VMA and thus any merged VMA may also contain this metadata,
+ *                  and thus we must make this flag sticky.
+ */
+#define VM_STICKY VM_MAYBE_GUARD
+
+/*
+ * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
+ * of these flags and the other not does not preclude a merge.
+ *
+ * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
+ *                dirty bit -- the caller should mark merged VMA as dirty. If
+ *                dirty bit won't be excluded from comparison, we increase
+ *                pressure on the memory system forcing the kernel to generate
+ *                new VMAs when old one could be extended instead.
+ *
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
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

