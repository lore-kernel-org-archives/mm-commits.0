Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4222F1E8339
	for <mm-commits@vger.kernel.org>; Mon, 10 Mar 2025 22:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741645340; cv=none; b=Ve95abQxoOuVmN2LanjIyonvzcSz3ckHTv5ljlTAWKti+Boyir8nh+jI8VdRpG8D7r919UBc/+6N2ftKqYFRSw6KlufgpCsNGPOCcpEp822QcdNudjBxocbOPJ/r0/pb3FtSqxhpB6rRPQoyMCJ6tROny8YN8yOh3krg632eb3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741645340; c=relaxed/simple;
	bh=7p951Z99XAWhAF8imlSZG2R2126E6uSAJruQHrMyt9U=;
	h=Date:To:From:Subject:Message-Id; b=EWmg5zACqzZlF8T+JbeJcDxHX6qsKuS47UbvgN6Doc0UpHMa08PnSNTYU91e9MMg6O4npgcrljbSN03OsGts9L+mhJk9WbCmzQ3QE7DXkVPj0wJ6Cl+5cUJfbeqyh3ndqIeOXhGGpZ/5G0qQVcs1beGHV2GTRZ9Yer8WmKClohE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JwJ6F+pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JwJ6F+pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF001C4CEE5;
	Mon, 10 Mar 2025 22:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741645339;
	bh=7p951Z99XAWhAF8imlSZG2R2126E6uSAJruQHrMyt9U=;
	h=Date:To:From:Subject:From;
	b=JwJ6F+pqb6g1kHiXWRozeAY0v91ydCK+M+l20c66aRkruiDSw9XugEI5cf3Vq2072
	 oeOjt0QcK7Mo5fTtuBlJEjH3dawUqoVC8tV5Akjfremwielq1Q8saV67Y3kfpH7hcf
	 uzcyUDJgnedGcektVwZ6XmpWbGbP+ZuWqJ2KmT0Y=
Date: Mon, 10 Mar 2025 15:22:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,harry.yoo@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-initial-refactor-of-move_vma.patch added to mm-unstable branch
Message-Id: <20250310222219.AF001C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: initial refactor of move_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-initial-refactor-of-move_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-initial-refactor-of-move_vma.patch

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
Subject: mm/mremap: initial refactor of move_vma()
Date: Mon, 10 Mar 2025 20:50:37 +0000

Update move_vma() to use the threaded VRM object, de-duplicate code and
separate into smaller functions to aid readability and debug-ability.

This in turn allows further simplification of expand_vma() as we can
simply thread VRM through the function.

We also take the opportunity to abstract the account charging page count
into the VRM in order that we can correctly thread this through the
operation.

We additionally do the same for tracking mm statistics - exec_vm,
stack_vm, data_vm, and locked_vm.

As part of this change, we slightly modify when locked pages statistics
are counted for in mm_struct statistics.  However this should cause no
issues, as there is no chance of underflow, nor will any rlimit failures
occur as a result.

This is an intermediate step before a further refactoring of move_vma() in
order to aid review.

Link: https://lkml.kernel.org/r/ab611d6efae11bddab2db2b8bb3925b1d1954c7d.1741639347.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  186 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 122 insertions(+), 64 deletions(-)

--- a/mm/mremap.c~mm-mremap-initial-refactor-of-move_vma
+++ a/mm/mremap.c
@@ -68,6 +68,7 @@ struct vma_remap_struct {
 	bool mlocked;			/* Was the VMA mlock()'d? */
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
+	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
 };
 
 static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
@@ -816,35 +817,88 @@ static unsigned long vrm_set_new_addr(st
 	return 0;
 }
 
-static unsigned long move_vma(struct vm_area_struct *vma,
-		unsigned long old_addr, unsigned long old_len,
-		unsigned long new_len, unsigned long new_addr,
-		bool *mlocked, unsigned long flags,
-		struct vm_userfaultfd_ctx *uf, struct list_head *uf_unmap)
+/*
+ * Keep track of pages which have been added to the memory mapping. If the VMA
+ * is accounted, also check to see if there is sufficient memory.
+ *
+ * Returns true on success, false if insufficient memory to charge.
+ */
+static bool vrm_charge(struct vma_remap_struct *vrm)
 {
-	long to_account = new_len - old_len;
-	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *new_vma;
-	unsigned long vm_flags = vma->vm_flags;
-	unsigned long new_pgoff;
-	unsigned long moved_len;
-	bool account_start = false;
-	bool account_end = false;
-	unsigned long hiwater_vm;
-	int err = 0;
-	bool need_rmap_locks;
-	struct vma_iterator vmi;
+	unsigned long charged;
+
+	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
+		return true;
+
+	/*
+	 * If we don't unmap the old mapping, then we account the entirety of
+	 * the length of the new one. Otherwise it's just the delta in size.
+	 */
+	if (vrm->flags & MREMAP_DONTUNMAP)
+		charged = vrm->new_len >> PAGE_SHIFT;
+	else
+		charged = vrm->delta >> PAGE_SHIFT;
+
+
+	/* This accounts 'charged' pages of memory. */
+	if (security_vm_enough_memory_mm(current->mm, charged))
+		return false;
+
+	vrm->charged = charged;
+	return true;
+}
+
+/*
+ * an error has occurred so we will not be using vrm->charged memory. Unaccount
+ * this memory if the VMA is accounted.
+ */
+static void vrm_uncharge(struct vma_remap_struct *vrm)
+{
+	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
+		return;
+
+	vm_unacct_memory(vrm->charged);
+	vrm->charged = 0;
+}
+
+/*
+ * Update mm exec_vm, stack_vm, data_vm, and locked_vm fields as needed to
+ * account for 'bytes' memory used, and if locked, indicate this in the VRM so
+ * we can handle this correctly later.
+ */
+static void vrm_stat_account(struct vma_remap_struct *vrm,
+			     unsigned long bytes)
+{
+	unsigned long pages = bytes >> PAGE_SHIFT;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = vrm->vma;
+
+	vm_stat_account(mm, vma->vm_flags, pages);
+	if (vma->vm_flags & VM_LOCKED) {
+		mm->locked_vm += pages;
+		vrm->mlocked = true;
+	}
+}
+
+/*
+ * Perform checks before attempting to write a VMA prior to it being
+ * moved.
+ */
+static unsigned long prep_move_vma(struct vma_remap_struct *vrm,
+				   unsigned long *vm_flags_ptr)
+{
+	unsigned long err = 0;
+	struct vm_area_struct *vma = vrm->vma;
+	unsigned long old_addr = vrm->addr;
+	unsigned long old_len = vrm->old_len;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (mm->map_count >= sysctl_max_map_count - 3)
+	if (current->mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
-	if (unlikely(flags & MREMAP_DONTUNMAP))
-		to_account = new_len;
-
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		if (vma->vm_start != old_addr)
 			err = vma->vm_ops->may_split(vma, old_addr);
@@ -862,22 +916,46 @@ static unsigned long move_vma(struct vm_
 	 * so KSM can come around to merge on vma and new_vma afterwards.
 	 */
 	err = ksm_madvise(vma, old_addr, old_addr + old_len,
-						MADV_UNMERGEABLE, &vm_flags);
+			  MADV_UNMERGEABLE, vm_flags_ptr);
 	if (err)
 		return err;
 
-	if (vm_flags & VM_ACCOUNT) {
-		if (security_vm_enough_memory_mm(mm, to_account >> PAGE_SHIFT))
-			return -ENOMEM;
-	}
+	return 0;
+}
+
+static unsigned long move_vma(struct vma_remap_struct *vrm)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = vrm->vma;
+	struct vm_area_struct *new_vma;
+	unsigned long vm_flags = vma->vm_flags;
+	unsigned long old_addr = vrm->addr, new_addr = vrm->new_addr;
+	unsigned long old_len = vrm->old_len, new_len = vrm->new_len;
+	unsigned long new_pgoff;
+	unsigned long moved_len;
+	unsigned long account_start = false;
+	unsigned long account_end = false;
+	unsigned long hiwater_vm;
+	int err;
+	bool need_rmap_locks;
+	struct vma_iterator vmi;
+
+	err = prep_move_vma(vrm, &vm_flags);
+	if (err)
+		return err;
+
+	/* If accounted, charge the number of bytes the operation will use. */
+	if (!vrm_charge(vrm))
+		return -ENOMEM;
 
 	vma_start_write(vma);
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
-	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
+	new_vma = copy_vma(&vrm->vma, new_addr, new_len, new_pgoff,
 			   &need_rmap_locks);
+	/* This may have been updated. */
+	vma = vrm->vma;
 	if (!new_vma) {
-		if (vm_flags & VM_ACCOUNT)
-			vm_unacct_memory(to_account >> PAGE_SHIFT);
+		vrm_uncharge(vrm);
 		return -ENOMEM;
 	}
 
@@ -902,7 +980,7 @@ static unsigned long move_vma(struct vm_
 		old_addr = new_addr;
 		new_addr = err;
 	} else {
-		mremap_userfaultfd_prep(new_vma, uf);
+		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
 	if (is_vm_hugetlb_page(vma)) {
@@ -910,7 +988,7 @@ static unsigned long move_vma(struct vm_
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
-	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
+	if (vm_flags & VM_ACCOUNT && !(vrm->flags & MREMAP_DONTUNMAP)) {
 		vm_flags_clear(vma, VM_ACCOUNT);
 		if (vma->vm_start < old_addr)
 			account_start = true;
@@ -928,13 +1006,12 @@ static unsigned long move_vma(struct vm_
 	 * If this were a serious issue, we'd add a flag to do_munmap().
 	 */
 	hiwater_vm = mm->hiwater_vm;
-	vm_stat_account(mm, vma->vm_flags, new_len >> PAGE_SHIFT);
 
 	/* Tell pfnmap has moved from this vma */
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
 		untrack_pfn_clear(vma);
 
-	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
+	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP))) {
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vm_flags_clear(vma, VM_LOCKED_MASK);
 
@@ -947,22 +1024,20 @@ static unsigned long move_vma(struct vm_
 			unlink_anon_vmas(vma);
 
 		/* Because we won't unmap we don't need to touch locked_vm */
+		vrm_stat_account(vrm, new_len);
 		return new_addr;
 	}
 
+	vrm_stat_account(vrm, new_len);
+
 	vma_iter_init(&vmi, mm, old_addr);
-	if (do_vmi_munmap(&vmi, mm, old_addr, old_len, uf_unmap, false) < 0) {
+	if (do_vmi_munmap(&vmi, mm, old_addr, old_len, vrm->uf_unmap, false) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
-		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
+		if (vm_flags & VM_ACCOUNT && !(vrm->flags & MREMAP_DONTUNMAP))
 			vm_acct_memory(old_len >> PAGE_SHIFT);
 		account_start = account_end = false;
 	}
 
-	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += new_len >> PAGE_SHIFT;
-		*mlocked = true;
-	}
-
 	mm->hiwater_vm = hiwater_vm;
 
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
@@ -1141,9 +1216,7 @@ static unsigned long mremap_to(struct vm
 	if (err)
 		return err;
 
-	return move_vma(vrm->vma, vrm->addr, vrm->old_len, vrm->new_len,
-			vrm->new_addr, &vrm->mlocked, vrm->flags,
-			vrm->uf, vrm->uf_unmap);
+	return move_vma(vrm);
 }
 
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
@@ -1248,17 +1321,11 @@ static unsigned long check_mremap_params
 static unsigned long expand_vma_in_place(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
-	long pages = vrm->delta >> PAGE_SHIFT;
 	struct vm_area_struct *vma = vrm->vma;
 	VMA_ITERATOR(vmi, mm, vma->vm_end);
-	long charged = 0;
-
-	if (vma->vm_flags & VM_ACCOUNT) {
-		if (security_vm_enough_memory_mm(mm, pages))
-			return -ENOMEM;
 
-		charged = pages;
-	}
+	if (!vrm_charge(vrm))
+		return -ENOMEM;
 
 	/*
 	 * Function vma_merge_extend() is called on the
@@ -1271,15 +1338,11 @@ static unsigned long expand_vma_in_place
 	 */
 	vma = vrm->vma = vma_merge_extend(&vmi, vma, vrm->delta);
 	if (!vma) {
-		vm_unacct_memory(charged);
+		vrm_uncharge(vrm);
 		return -ENOMEM;
 	}
 
-	vm_stat_account(mm, vma->vm_flags, pages);
-	if (vma->vm_flags & VM_LOCKED) {
-		mm->locked_vm += pages;
-		vrm->mlocked = true;
-	}
+	vrm_stat_account(vrm, vrm->delta);
 
 	return 0;
 }
@@ -1319,11 +1382,7 @@ static bool align_hugetlb(struct vma_rem
 static unsigned long expand_vma(struct vma_remap_struct *vrm)
 {
 	unsigned long err;
-	struct vm_area_struct *vma = vrm->vma;
 	unsigned long addr = vrm->addr;
-	unsigned long old_len = vrm->old_len;
-	unsigned long new_len = vrm->new_len;
-	unsigned long flags = vrm->flags;
 
 	err = resize_is_valid(vrm);
 	if (err)
@@ -1356,7 +1415,7 @@ static unsigned long expand_vma(struct v
 	 */
 
 	/* We're not allowed to move the VMA, so error out. */
-	if (!(flags & MREMAP_MAYMOVE))
+	if (!(vrm->flags & MREMAP_MAYMOVE))
 		return -ENOMEM;
 
 	/* Find a new location to move the VMA to. */
@@ -1364,8 +1423,7 @@ static unsigned long expand_vma(struct v
 	if (err)
 		return err;
 
-	return move_vma(vma, addr, old_len, new_len, vrm->new_addr,
-			&vrm->mlocked, flags, vrm->uf, vrm->uf_unmap);
+	return move_vma(vrm);
 }
 
 /*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

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
selftests-mm-rename-guard-pages-to-guard-regions-fix.patch
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

