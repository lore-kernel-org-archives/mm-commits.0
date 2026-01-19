Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A343328689A
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851265; cv=none; b=gzsU0n7PdjwYiJEppYogrrOx7OhMV+oaeUJeCYD5TFLtATcsXri/zZK428svfcAUOAZv5tXlvsNsMoFdVLvg8fUuHIc8Rru+Z+ukuW6LWcuUIZpB26ox4svwuTgwPiilOHqnS5/9q599s16VJd0G+MGtVfIbbQpyW0FvD+l+lvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851265; c=relaxed/simple;
	bh=q+/SvHGxBCoQBq1/1sQievoS17ToCPyHUCbrdrKkANQ=;
	h=Date:To:From:Subject:Message-Id; b=kxJIdUNPxhydVyht+2IKFq6LxgAoRoCNfRj+0IRI7uvhhbW4MF5zHPQ/Ty+XpPqM34MTetr8wIPH+Sl2LEnnl2NJkpqJVEUfCMa+UjxqP82ni260tqtgFVhIymhgfDz86BLVJT7szrabvEuNI4pZvS3ek4aAvnjckLzswd3btNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1IJOpb0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1IJOpb0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E636C116C6;
	Mon, 19 Jan 2026 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851265;
	bh=q+/SvHGxBCoQBq1/1sQievoS17ToCPyHUCbrdrKkANQ=;
	h=Date:To:From:Subject:From;
	b=1IJOpb0GbZ/y1OC+dpWoJnyRKk0l3MOWbc1rD4o4cddj3+95S01PbwMi/s7th03ig
	 /2KaRDghAvksGMG+T+m5mI4rFObotiOjqGDqYc2rBPtA1yj1bCX+UXGRStvn0NmRgd
	 ROXBi9tsQpS+5IksgtoljOP5OU235myEq4uwGI2A=
Date: Mon, 19 Jan 2026 11:34:24 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch added to mm-new branch
Message-Id: <20260119193425.2E636C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update secretmem to use VMA flags on mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update secretmem to use VMA flags on mmap_prepare
Date: Mon, 19 Jan 2026 14:48:57 +0000

This patch updates secretmem to use the new vma_flags_t type which will
soon supersede vm_flags_t altogether.

In order to make this change we also have to update mlock_future_ok(), we
replace the vm_flags_t parameter with a simple boolean is_vma_locked one,
which also simplifies the invocation here.

This is laying the groundwork for eliminating the vm_flags_t in
vm_area_desc and more broadly throughout the kernel.

No functional changes intended.

Link: https://lkml.kernel.org/r/669265753a1ec8d75a1a0893babfaf19a973a7b9.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    2 +-
 mm/mmap.c      |    8 ++++----
 mm/mremap.c    |    2 +-
 mm/secretmem.c |    7 +++----
 mm/vma.c       |    2 +-
 5 files changed, 10 insertions(+), 11 deletions(-)

--- a/mm/internal.h~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/internal.h
@@ -1046,7 +1046,7 @@ extern long populate_vma_page_range(stru
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
-bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
+bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
 
 /*
--- a/mm/mmap.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/mmap.c
@@ -225,12 +225,12 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
-			unsigned long bytes)
+bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
+		     unsigned long bytes)
 {
 	unsigned long locked_pages, limit_pages;
 
-	if (!(vm_flags & VM_LOCKED) || capable(CAP_IPC_LOCK))
+	if (!is_vma_locked || capable(CAP_IPC_LOCK))
 		return true;
 
 	locked_pages = bytes >> PAGE_SHIFT;
@@ -416,7 +416,7 @@ unsigned long do_mmap(struct file *file,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (!mlock_future_ok(mm, vm_flags, len))
+	if (!mlock_future_ok(mm, vm_flags & VM_LOCKED, len))
 		return -EAGAIN;
 
 	if (file) {
--- a/mm/mremap.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/mremap.c
@@ -1740,7 +1740,7 @@ static int check_prep_vma(struct vma_rem
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return -EFAULT;
 
-	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
+	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, vrm->delta))
 		return -EAGAIN;
 
 	if (!may_expand_vm(mm, vma->vm_flags, vrm->delta >> PAGE_SHIFT))
--- a/mm/secretmem.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/secretmem.c
@@ -122,13 +122,12 @@ static int secretmem_mmap_prepare(struct
 {
 	const unsigned long len = vma_desc_size(desc);
 
-	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
+	if (!vma_desc_test_flags(desc, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))
 		return -EINVAL;
 
-	if (!mlock_future_ok(desc->mm, desc->vm_flags | VM_LOCKED, len))
+	vma_desc_set_flags(desc, VMA_LOCKED_BIT, VMA_DONTDUMP_BIT);
+	if (!mlock_future_ok(desc->mm, /*is_vma_locked=*/ true, len))
 		return -EAGAIN;
-
-	desc->vm_flags |= VM_LOCKED | VM_DONTDUMP;
 	desc->vm_ops = &secretmem_vm_ops;
 
 	return 0;
--- a/mm/vma.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/vma.c
@@ -3053,7 +3053,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (!mlock_future_ok(mm, vma->vm_flags, grow << PAGE_SHIFT))
+	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, grow << PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch
mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
locking-add-rwsem_is_write_locked-update-non-lockdep-asserts.patch
mm-vma-add-vma_is__locked-helpers.patch
mm-add-use-vma_is_stabilised-vma_assert_stabilised-helpers.patch
selftests-mm-remove-virtual_address_range-test.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

