Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F6D20EB
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044810; cv=none; b=teF9TzV8CIlTXZ67Rfpx7A7oajojqT2hxU8kC8XbtZkbV+LmwLn9Qr3EpI8fPTrDd+4AF9n35aaT3xMmocUYUu4msJUy86DDS3ImMytP8Emha8Y13+w6eoFCnWurgEfc2dFdPW+Cn4Q1UF9jyW5Ra9tHkdQ3ymrRIlbbDTOmL60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044810; c=relaxed/simple;
	bh=ezTBoH/0Y1391pQobPjtpAbp4g3GYxMfDAy2iSWWZOw=;
	h=Date:To:From:Subject:Message-Id; b=AkUfkagrXXdHuhMt4zWAfkV2FwlaS7dKmsIhP95XqR6C2DyTK9nFZbW1/UNXyr3qjUQw0yFjdQFzXFhQ1sFGkXdeRE+SAucRk4xAf8odoIOSifDPsQ2ds2t6KlcZZ2fQxDSvp9JXQ1Dk3HDxcbYwGtiXHnoczAVaTQpJlzbBVdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y4a0bcXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y4a0bcXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701B6C4CEE8;
	Mon,  3 Mar 2025 23:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741044810;
	bh=ezTBoH/0Y1391pQobPjtpAbp4g3GYxMfDAy2iSWWZOw=;
	h=Date:To:From:Subject:From;
	b=Y4a0bcXzgXx/Mlp31pmoWsUkksHgrf2j0i8kTdQbP8HJ2fv7jnO6YtMMdDAHtiS1N
	 EOZb7SYUe+jf6Iuf3LxVoJwU1Os/xmiXSjEwuZpgPy1EWlgXXhp7iWO1m3rUc5r3Qp
	 gPompGFwfjoXfPhblTHsLvJLPHfHCwn6W0iv/w0k=
Date: Mon, 03 Mar 2025 15:33:29 -0800
To: mm-commits@vger.kernel.org,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-complete-refactor-of-move_vma.patch added to mm-unstable branch
Message-Id: <20250303233330.701B6C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: complete refactor of move_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-complete-refactor-of-move_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-complete-refactor-of-move_vma.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: complete refactor of move_vma()
Date: Mon, 3 Mar 2025 11:08:35 +0000

We invoke ksm_madvise() with an intentionally dummy flags field, so no
need to pass around.

Additionally, the code tries to be 'clever' with account_start,
account_end, using these to both check that vma->vm_start != 0 and that we
ought to account the newly split portion of VMA post-move, either before
or after it.

We need to do this because we intentionally removed VM_ACCOUNT on the VMA
prior to unmapping, so we don't erroneously unaccount memory (we have
already calculated the correct amount to account and accounted it, any
subsequent subtraction will be incorrect).

This patch significantly expands the comment (from 2002!) about
'concealing' the flag to make it abundantly clear what's going on, as well
as adding and expanding a number of other comments also.

We can remove account_start, account_end by instead tracking when we
account (i.e.  vma->vm_flags has the VM_ACCOUNT flag set, and this is not
an MREMAP_DONTUNMAP operation), and figuring out when to reinstate the
VM_ACCOUNT flag on prior/subsequent VMAs separately.

We additionally break the function into logical pieces and attack the very
confusing error handling logic (where, for instance, new_addr is set to
err).

After this change the code is considerably more readable and easy to
manipulate.

Link: https://lkml.kernel.org/r/61a8071433adf3815713523a5c1db62cbe1e55a1.1740911247.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  292 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 203 insertions(+), 89 deletions(-)

--- a/mm/mremap.c~mm-mremap-complete-refactor-of-move_vma
+++ a/mm/mremap.c
@@ -889,13 +889,13 @@ static void vrm_stat_account(struct vma_
  * Perform checks  before attempting to write a VMA prior to it being
  * moved.
  */
-static unsigned long prep_move_vma(struct vma_remap_struct *vrm,
-				   unsigned long *vm_flags_ptr)
+static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 {
 	unsigned long err;
 	struct vm_area_struct *vma = vrm->vma;
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
+	unsigned long dummy = vma->vm_flags;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -921,56 +921,150 @@ static unsigned long prep_move_vma(struc
 	 * so KSM can come around to merge on vma and new_vma afterwards.
 	 */
 	err = ksm_madvise(vma, old_addr, old_addr + old_len,
-			  MADV_UNMERGEABLE, vm_flags_ptr);
+			  MADV_UNMERGEABLE, &dummy);
 	if (err)
 		return err;
 
 	return 0;
 }
 
-static unsigned long move_vma(struct vma_remap_struct *vrm)
+/*
+ * Unmap source VMA for VMA move, turning it from a copy to a move, being
+ * careful to ensure we do not underflow memory account while doing so if an
+ * accountable move.
+ *
+ * This is best effort, if we fail to unmap then we simply try
+ */
+static void unmap_source_vma(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
+	unsigned long addr = vrm->addr;
+	unsigned long len = vrm->old_len;
 	struct vm_area_struct *vma = vrm->vma;
-	struct vm_area_struct *new_vma;
-	unsigned long vm_flags = vma->vm_flags;
-	unsigned long old_addr = vrm->addr, new_addr = vrm->new_addr;
-	unsigned long old_len = vrm->old_len, new_len = vrm->new_len;
-	unsigned long new_pgoff;
-	unsigned long moved_len;
-	unsigned long account_start = false;
-	unsigned long account_end = false;
-	unsigned long hiwater_vm;
+	VMA_ITERATOR(vmi, mm, addr);
 	int err;
-	bool need_rmap_locks;
-	struct vma_iterator vmi;
+	unsigned long vm_start;
+	unsigned long vm_end;
+	/*
+	 * It might seem odd that we check for MREMAP_DONTUNMAP here, given this
+	 * function implies that we unmap the original VMA, which seems
+	 * contradictory.
+	 *
+	 * However, this occurs when this operation was attempted and an error
+	 * arose, in which case we _do_ wish to unmap the _new_ VMA, which means
+	 * we actually _do_ want it be unaccounted.
+	 */
+	bool accountable_move = (vma->vm_flags & VM_ACCOUNT) &&
+		!(vrm->flags & MREMAP_DONTUNMAP);
 
-	err = prep_move_vma(vrm, &vm_flags);
-	if (err)
-		return err;
+	/*
+	 * So we perform a trick here to prevent incorrect accounting. Any merge
+	 * or new VMA allocation performed in copy_vma() does not adjust
+	 * accounting, it is expected that callers handle this.
+	 *
+	 * And indeed we already have, accounting appropriately in the case of
+	 * both in vrm_charge().
+	 *
+	 * However, when we unmap the existing VMA (to effect the move), this
+	 * code will, if the VMA has VM_ACCOUNT set, attempt to unaccount
+	 * removed pages.
+	 *
+	 * To avoid this we temporarily clear this flag, reinstating on any
+	 * portions of the original VMA that remain.
+	 */
+	if (accountable_move) {
+		vm_flags_clear(vma, VM_ACCOUNT);
+		/* We are about to split vma, so store the start/end. */
+		vm_start = vma->vm_start;
+		vm_end = vma->vm_end;
+	}
 
-	/* If accounted, charge the number of bytes the operation will use. */
-	if (!vrm_charge(vrm))
-		return -ENOMEM;
+	err = do_vmi_munmap(&vmi, mm, addr, len, vrm->uf_unmap, /* unlock= */false);
+	vrm->vma = NULL; /* Invalidated. */
+	if (err) {
+		/* OOM: unable to split vma, just get accounts right */
+		vm_acct_memory(len >> PAGE_SHIFT);
+		return;
+	}
+
+	/*
+	 * If we mremap() from a VMA like this:
+	 *
+	 *    addr  end
+	 *     |     |
+	 *     v     v
+	 * |-------------|
+	 * |             |
+	 * |-------------|
+	 *
+	 * Having cleared VM_ACCOUNT from the whole VMA, after we unmap above
+	 * we'll end up with:
+	 *
+	 *    addr  end
+	 *     |     |
+	 *     v     v
+	 * |---|     |---|
+	 * | A |     | B |
+	 * |---|     |---|
+	 *
+	 * The VMI is still pointing at addr, so vma_prev() will give us A, and
+	 * a subsequent or lone vma_next() will give as B.
+	 *
+	 * do_vmi_munmap() will have restored the VMI back to addr.
+	 */
+	if (accountable_move) {
+		unsigned long end = addr + len;
+
+		if (vm_start < addr) {
+			struct vm_area_struct *prev = vma_prev(&vmi);
+
+			vm_flags_set(prev, VM_ACCOUNT); /* Acquires VMA lock. */
+		}
+
+		if (vm_end > end) {
+			struct vm_area_struct *next = vma_next(&vmi);
+
+			vm_flags_set(next, VM_ACCOUNT); /* Acquires VMA lock. */
+		}
+	}
+}
+
+/*
+ * Copy vrm->vma over to vrm->new_addr possibly adjusting size as part of the
+ * process. Additionally handle an error occurring on moving of page tables,
+ * where we reset vrm state to cause unmapping of the new VMA.
+ *
+ * Outputs the newly installed VMA to new_vma_ptr. Returns 0 on success or an
+ * error code.
+ */
+static int copy_vma_and_data(struct vma_remap_struct *vrm,
+			     struct vm_area_struct **new_vma_ptr)
+{
+	unsigned long internal_offset = vrm->addr - vrm->vma->vm_start;
+	unsigned long internal_pgoff = internal_offset >> PAGE_SHIFT;
+	unsigned long new_pgoff = vrm->vma->vm_pgoff + internal_pgoff;
+	unsigned long moved_len;
+	bool need_rmap_locks;
+	struct vm_area_struct *vma;
+	struct vm_area_struct *new_vma;
+	int err = 0;
 
-	vma_start_write(vma);
-	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
-	new_vma = copy_vma(&vrm->vma, new_addr, new_len, new_pgoff,
+	new_vma = copy_vma(&vrm->vma, vrm->new_addr, vrm->new_len, new_pgoff,
 			   &need_rmap_locks);
-	/* This may have been updated. */
-	vma = vrm->vma;
 	if (!new_vma) {
 		vrm_uncharge(vrm);
+		*new_vma_ptr = NULL;
 		return -ENOMEM;
 	}
+	vma = vrm->vma;
 
-	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len,
-				     need_rmap_locks, false);
-	if (moved_len < old_len) {
+	moved_len = move_page_tables(vma, vrm->addr, new_vma,
+				     vrm->new_addr, vrm->old_len,
+				     need_rmap_locks, /* for_stack= */false);
+	if (moved_len < vrm->old_len)
 		err = -ENOMEM;
-	} else if (vma->vm_ops && vma->vm_ops->mremap) {
+	else if (vma->vm_ops && vma->vm_ops->mremap)
 		err = vma->vm_ops->mremap(new_vma);
-	}
 
 	if (unlikely(err)) {
 		/*
@@ -978,28 +1072,84 @@ static unsigned long move_vma(struct vma
 		 * which will succeed since page tables still there,
 		 * and then proceed to unmap new area instead of old.
 		 */
-		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len,
-				 true, false);
-		vma = new_vma;
-		old_len = new_len;
-		old_addr = new_addr;
-		new_addr = err;
+		move_page_tables(new_vma, vrm->new_addr, vma, vrm->addr,
+				 moved_len, /* need_rmap_locks = */true,
+				 /* for_stack= */false);
+		vrm->vma = new_vma;
+		vrm->old_len = vrm->new_len;
+		vrm->addr = vrm->new_addr;
 	} else {
 		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
-	if (is_vm_hugetlb_page(vma)) {
+	if (is_vm_hugetlb_page(vma))
 		clear_vma_resv_huge_pages(vma);
-	}
 
-	/* Conceal VM_ACCOUNT so old reservation is not undone */
-	if (vm_flags & VM_ACCOUNT && !(vrm->flags & MREMAP_DONTUNMAP)) {
-		vm_flags_clear(vma, VM_ACCOUNT);
-		if (vma->vm_start < old_addr)
-			account_start = true;
-		if (vma->vm_end > old_addr + old_len)
-			account_end = true;
-	}
+	/* Tell pfnmap has moved from this vma */
+	if (unlikely(vma->vm_flags & VM_PFNMAP))
+		untrack_pfn_clear(vma);
+
+	*new_vma_ptr = new_vma;
+	return err;
+}
+
+/*
+ * Perform final tasks for MADV_DONTUNMAP operation, clearing mlock() and
+ * account flags on remaining VMA by convention (it cannot be mlock()'d any
+ * longer, as pages in range are no longer mapped), and removing anon_vma_chain
+ * links from it (if the entire VMA was copied over).
+ */
+static void dontunmap_complete(struct vma_remap_struct *vrm,
+			       struct vm_area_struct *new_vma)
+{
+	unsigned long start = vrm->addr;
+	unsigned long end = vrm->addr + vrm->old_len;
+	unsigned long old_start = vrm->vma->vm_start;
+	unsigned long old_end = vrm->vma->vm_end;
+
+	/*
+	 * We always clear VM_LOCKED[ONFAULT] | VM_ACCOUNT on the old
+	 * vma.
+	 */
+	vm_flags_clear(vrm->vma, VM_LOCKED_MASK | VM_ACCOUNT);
+
+	/*
+	 * anon_vma links of the old vma is no longer needed after its page
+	 * table has been moved.
+	 */
+	if (new_vma != vrm->vma && start == old_start && end == old_end)
+		unlink_anon_vmas(vrm->vma);
+
+	/* Because we won't unmap we don't need to touch locked_vm. */
+}
+
+static unsigned long move_vma(struct vma_remap_struct *vrm)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *new_vma;
+	unsigned long hiwater_vm;
+	int err;
+
+	err = prep_move_vma(vrm);
+	if (err)
+		return err;
+
+	/* If accounted, charge the number of bytes the operation will use. */
+	if (!vrm_charge(vrm))
+		return -ENOMEM;
+
+	/* We don't want racing faults. */
+	vma_start_write(vrm->vma);
+
+	/* Perform copy step. */
+	err = copy_vma_and_data(vrm, &new_vma);
+	/*
+	 * If we established the copied-to VMA, we attempt to recover from the
+	 * error by setting the destination VMA to the source VMA and unmapping
+	 * it below.
+	 */
+	if (err && !new_vma)
+		return err;
 
 	/*
 	 * If we failed to move page tables we still do total_vm increment
@@ -1012,51 +1162,15 @@ static unsigned long move_vma(struct vma
 	 */
 	hiwater_vm = mm->hiwater_vm;
 
-	/* Tell pfnmap has moved from this vma */
-	if (unlikely(vma->vm_flags & VM_PFNMAP))
-		untrack_pfn_clear(vma);
-
-	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP))) {
-		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
-		vm_flags_clear(vma, VM_LOCKED_MASK);
-
-		/*
-		 * anon_vma links of the old vma is no longer needed after its page
-		 * table has been moved.
-		 */
-		if (new_vma != vma && vma->vm_start == old_addr &&
-			vma->vm_end == (old_addr + old_len))
-			unlink_anon_vmas(vma);
-
-		/* Because we won't unmap we don't need to touch locked_vm */
-		vrm_stat_account(vrm, new_len);
-		return new_addr;
-	}
-
-	vrm_stat_account(vrm, new_len);
-
-	vma_iter_init(&vmi, mm, old_addr);
-	if (do_vmi_munmap(&vmi, mm, old_addr, old_len, vrm->uf_unmap, false) < 0) {
-		/* OOM: unable to split vma, just get accounts right */
-		if (vm_flags & VM_ACCOUNT && !(vrm->flags & MREMAP_DONTUNMAP))
-			vm_acct_memory(old_len >> PAGE_SHIFT);
-		account_start = account_end = false;
-	}
+	vrm_stat_account(vrm, vrm->new_len);
+	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
+		dontunmap_complete(vrm, new_vma);
+	else
+		unmap_source_vma(vrm);
 
 	mm->hiwater_vm = hiwater_vm;
 
-	/* Restore VM_ACCOUNT if one or two pieces of vma left */
-	if (account_start) {
-		vma = vma_prev(&vmi);
-		vm_flags_set(vma, VM_ACCOUNT);
-	}
-
-	if (account_end) {
-		vma = vma_next(&vmi);
-		vm_flags_set(vma, VM_ACCOUNT);
-	}
-
-	return new_addr;
+	return err ? (unsigned long)err : vrm->new_addr;
 }
 
 /*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-abort-vma_modify-on-merge-out-of-memory-failure.patch
mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

