Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BC83321A9
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 18:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762800668; cv=none; b=ADPF9tGe/9Q1uvGfQRkLifNX06j1/tjHqu+j7VDM5diJdyDtTiWmQbuvL3sGHzrh5PItPFStFJM0LzBYVz/s2xM/TSn1cX1JXU2q9Qe/cBpbHnGPTca22HZTbsi00m5IG3cBv2vYFFwYpDCLILyHKmPKSqK43IScu2Oat7C3Di0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762800668; c=relaxed/simple;
	bh=BpDtdik1r6MYyL0+Rli0UOpKoUNaMa+61QPAIboGoHE=;
	h=Date:To:From:Subject:Message-Id; b=iUkQGVOvtOHLSWaOyvzDyUSb3xNeT4St3A/wiviYzNXI5bi7FTYJimnf3i9CBp30vjT1F0VCCWnJmTpfLDj2+06CUvFTr/JodtYI0NfvnPqPNHve0RGQaSqi76CtOUbBE+MjiQkuD7+UBOMS51lN82pT+mj1//aRweNbdgxFH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1Lf9zOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1Lf9zOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0339FC2BC9E;
	Mon, 10 Nov 2025 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762800668;
	bh=BpDtdik1r6MYyL0+Rli0UOpKoUNaMa+61QPAIboGoHE=;
	h=Date:To:From:Subject:From;
	b=n1Lf9zOSXlaMqr+W//5qtTgPDBnezUdM2FHFqBHdYNiOmzA0QZrHV39yBpw8gIi+p
	 QDN6bCbrCZ4sG+yCUtYC7C7Iy9GdGhHEu9ejkcDwZbQo5tTW1TNFEaWIMN59cl3E8X
	 xBLVzbEPc0xt78womiTCNobtHDCTzf1jLfw5c5oY=
Date: Mon, 10 Nov 2025 10:51:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-walk_page_range_mm.patch added to mm-new branch
Message-Id: <20251110185108.0339FC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename walk_page_range_mm()
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-walk_page_range_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-walk_page_range_mm.patch

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
Subject: mm: rename walk_page_range_mm()
Date: Mon, 10 Nov 2025 17:22:57 +0000

Patch series "mm: perform guard region install/remove under VMA lock", v2.

There is no reason why can't perform guard region operations under the VMA
lock, as long we take proper precautions to ensure that we do so in a safe
manner.

This is fine, as VMA lock acquisition is always best-effort, so if we are
unable to do so, we can simply fall back to using the mmap read lock.

Doing so will reduce mmap lock contention for callers performing guard
region operations and help establish a precedent of trying to use the VMA
lock where possible.

As part of this change we perform a trivial rename of page walk functions
which bypass safety checks (i.e.  whether or not mm_walk_ops->install_pte
is specified) in order that we can keep naming consistent with the mm
walk.

This is because we need to expose a VMA-specific walk that still allows us
to install PTE entries.


This patch (of 2):

Make it clear we're referencing an unsafe variant of this function
explicitly.

This is laying the foundation for exposing more such functions and
maintaining a consistent naming scheme.

As a part of this change, rename check_ops_valid() to check_ops_safe() for
consistency.

Link: https://lkml.kernel.org/r/cover.1762795245.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/c684d91464a438d6e31172c9450416a373f10649.1762795245.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/madvise.c  |    4 ++--
 mm/pagewalk.c |   22 +++++++++++-----------
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-rename-walk_page_range_mm
+++ a/mm/internal.h
@@ -1652,7 +1652,7 @@ static inline void accept_page(struct pa
 #endif /* CONFIG_UNACCEPTED_MEMORY */
 
 /* pagewalk.c */
-int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
+int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
--- a/mm/madvise.c~mm-rename-walk_page_range_mm
+++ a/mm/madvise.c
@@ -1171,8 +1171,8 @@ static long madvise_guard_install(struct
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm(vma->vm_mm, range->start, range->end,
-					 &guard_install_walk_ops, &nr_pages);
+		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
+				range->end, &guard_install_walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
 
--- a/mm/pagewalk.c~mm-rename-walk_page_range_mm
+++ a/mm/pagewalk.c
@@ -452,7 +452,7 @@ static inline void process_vma_walk_lock
  * We usually restrict the ability to install PTEs, but this functionality is
  * available to internal memory management code and provided in mm/internal.h.
  */
-int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
+int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private)
 {
@@ -518,10 +518,10 @@ int walk_page_range_mm(struct mm_struct
  * This check is performed on all functions which are parameterised by walk
  * operations and exposed in include/linux/pagewalk.h.
  *
- * Internal memory management code can use the walk_page_range_mm() function to
- * be able to use all page walking operations.
+ * Internal memory management code can use *_unsafe() functions to be able to
+ * use all page walking operations.
  */
-static bool check_ops_valid(const struct mm_walk_ops *ops)
+static bool check_ops_safe(const struct mm_walk_ops *ops)
 {
 	/*
 	 * The installation of PTEs is solely under the control of memory
@@ -579,10 +579,10 @@ int walk_page_range(struct mm_struct *mm
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private)
 {
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
-	return walk_page_range_mm(mm, start, end, ops, private);
+	return walk_page_range_mm_unsafe(mm, start, end, ops, private);
 }
 
 /**
@@ -639,7 +639,7 @@ int walk_kernel_page_table_range_lockles
 
 	if (start >= end)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	return walk_pgd_range(start, end, &walk);
@@ -678,7 +678,7 @@ int walk_page_range_debug(struct mm_stru
 						    pgd, private);
 	if (start >= end || !walk.mm)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	/*
@@ -709,7 +709,7 @@ int walk_page_range_vma(struct vm_area_s
 		return -EINVAL;
 	if (start < vma->vm_start || end > vma->vm_end)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
@@ -729,7 +729,7 @@ int walk_page_vma(struct vm_area_struct
 
 	if (!walk.mm)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
@@ -780,7 +780,7 @@ int walk_page_mapping(struct address_spa
 	unsigned long start_addr, end_addr;
 	int err = 0;
 
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	lockdep_assert_held(&mapping->i_mmap_rwsem);
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
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch

