Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C6E2D46D9
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 19:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542455; cv=none; b=bJiUpqCucPvjoejSy64VTS1rhRjjJuIH2pdgxrXIqFx+5N/6vmxAlLH8nCpsF+Q4gwYo5+bFOCaSCFky+EzV5o0nURkXn/19MBuF9Re+q0+HnTHAyCRWhEHjuMuF2jLwpXIdVovr/VzSHxWapDtr3pGPYJylYufzUlqB8HEwGGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542455; c=relaxed/simple;
	bh=i+97Zz+0wTlpv6VUaTdA1mtI66UmZZnBj2XgFJlOOrc=;
	h=Date:To:From:Subject:Message-Id; b=mkudXYwmVnYlN2BiRxR7nIWNNJahfbo4vnsMwV1RngwOupSKgVPf09XWBY7vE6Vm2eCB+rReG83IxIARUEheuySn9waqAhkxKwScpaYK72mJsqsUBPePv+1oBbLW1K8dclt71eWZnP4XW1vkdcvvXfHIKi8ONGz70A5wG2/J39o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PVhdmivu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PVhdmivu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D758C4CEF7;
	Fri,  7 Nov 2025 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762542454;
	bh=i+97Zz+0wTlpv6VUaTdA1mtI66UmZZnBj2XgFJlOOrc=;
	h=Date:To:From:Subject:From;
	b=PVhdmivuwVyjqKuieL5zEljvifdmx4BiIlFU2yLjongaKfO/FCNV86P6mK29WVS/3
	 HKZgvl096dIuR/rYcST7gmliKyLso7FxVXN1ENsKb1v8NZksNUjstqO5cyDe72t9xn
	 Z29eZ5mvTbM9RgCKNQ09oCyg/H/EuBRoJcBdvBjo=
Date: Fri, 07 Nov 2025 11:07:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-sticky-vma-flags.patch added to mm-new branch
Message-Id: <20251107190734.7D758C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: implement sticky VMA flags
has been added to the -mm mm-new branch.  Its filename is
     mm-implement-sticky-vma-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-sticky-vma-flags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: implement sticky VMA flags
Date: Fri, 7 Nov 2025 16:11:48 +0000

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

We also update the VMA userland tests to account for the changes.

Link: https://lkml.kernel.org/r/1ee529ff912f71b3460d0d21bc5b32ca89d63513.1762531708.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   29 +++++++++++++++++++++++++++++
 mm/vma.c                         |   22 ++++++++++++----------
 tools/testing/vma/vma_internal.h |   29 +++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-implement-sticky-vma-flags
+++ a/include/linux/mm.h
@@ -528,6 +528,35 @@ extern unsigned int kobjsize(const void
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
+ *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *                which should propagate to all VMAs, but the other does not,
+ *                the merge should still proceed with the merge logic applying
+ *                sticky flags to the final VMA.
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
@@ -1902,7 +1904,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_SOFTDIRTY)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_IGNORE_MERGE)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
--- a/tools/testing/vma/vma_internal.h~mm-implement-sticky-vma-flags
+++ a/tools/testing/vma/vma_internal.h
@@ -117,6 +117,35 @@ extern unsigned long dac_mmap_min_addr;
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
+ *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *                which should propagate to all VMAs, but the other does not,
+ *                the merge should still proceed with the merge logic applying
+ *                sticky flags to the final VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-uses-of-is_swap_pte-when-leafent_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd-fix.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-leafent_from_pte.patch
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

