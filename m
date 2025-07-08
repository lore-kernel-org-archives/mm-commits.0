Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ADB23DE
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 01:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751939922; cv=none; b=YN8apq2r+IZgbr/BMwd0GCRniHKXp0x6xAiLIitkVuLc1k5Iz6b3grhCjdjP7UY7pxXRhRL67FbXkdxDScc1eOwy8M5oePjVKNQKrmoFLtS4z2rOp3W8nUYL6S5Uq2t5bk8nMnbfh9jFKrMkVjIgYl8cMLDzJ/5xRtNokCaxnng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751939922; c=relaxed/simple;
	bh=RuUqkGIzpjMzYNUtWV7NX6HWVhWzrQqco8El2SwoClA=;
	h=Date:To:From:Subject:Message-Id; b=aCjIPbwADhRQjOyIYSNEX6Mwkw/9SrUmHfSqiSM63UYWjpWF0eXkLFhiCA5Ln0ccOiga87J7UZHpYuHb4j76Twwip1JQ/+Gf+QZeoJ4GNB30arNJ+ymOqu+3MPDeNX/3BzsNI7C0nkdo3atHHqkq1mRGvGKvQklTB1Kp+sMqRtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b4gy8xiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b4gy8xiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FF9C4CEE3;
	Tue,  8 Jul 2025 01:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751939921;
	bh=RuUqkGIzpjMzYNUtWV7NX6HWVhWzrQqco8El2SwoClA=;
	h=Date:To:From:Subject:From;
	b=b4gy8xiP9yIenYe7wAcT7wBB6xpKBxNUvrcbh7RbFTGu/2MWn4SeruisKQY6Jmp3p
	 J9Sd8M9IsSv5fSJk8xtWMmpmXxHk0LNNCqgH07supNnGHHDGFrx3ZysOPhk7U1mYs6
	 1b0OwxPQpiMU4BIyOdsOAq8pqTmfHb/OnQ9HB/2s=
Date: Mon, 07 Jul 2025 18:58:40 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,lkp@intel.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-permit-mremap-move-of-multiple-vmas.patch added to mm-new branch
Message-Id: <20250708015841.14FF9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: permit mremap() move of multiple VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-permit-mremap-move-of-multiple-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-permit-mremap-move-of-multiple-vmas.patch

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
Subject: mm/mremap: permit mremap() move of multiple VMAs
Date: Mon, 7 Jul 2025 06:27:52 +0100

Historically we've made it a uAPI requirement that mremap() may only
operate on a single VMA at a time.

For instances where VMAs need to be resized, this makes sense, as it
becomes very difficult to determine what a user actually wants should they
indicate a desire to expand or shrink the size of multiple VMAs (truncate?
Adjust sizes individually? Some other strategy?).

However, in instances where a user is moving VMAs, it is restrictive to
disallow this.

This is especially the case when anonymous mapping remap may or may not be
mergeable depending on whether VMAs have or have not been faulted due to
anon_vma assignment and folio index alignment with vma->vm_pgoff.

Often this can result in surprising impact where a moved region is faulted,
then moved back and a user fails to observe a merge from otherwise
compatible, adjacent VMAs.

This change allows such cases to work without the user having to be
cognizant of whether a prior mremap() move or other VMA operations has
resulted in VMA fragmentation.

Having refactored mremap code to aggregate per-VMA and parameter checks, we
are now in a position to permit this kind of move.

We do so by detecting if this is a move-only operation up-front, and then
utilising a separate code path via remap_move() rather than the ordinary
single-VMA path.

There are two tasks that occur outside of the mmap write lock - userfaultfd
notification and population of unmapped regions of expanded VMAs should the
VMA be mlock()'d.

The latter doesn't apply, as this is logic for a move only and thus no
expansion can take place. In the former case, we explicitly disallow
multi-VMA operations on uffd-armed VMAs.

The mmap lock is never dropped in the move-only case, this only occurs on a
VMA shrink.

We take care to handle cases where a VMA merge has occurred, by resetting
the VMA iterator in such instances.

We needn't worry about self-merges, as in those cases we would, by
definition, not be spanning multiple VMAs. The overlapping range test is
performed on the whole range so specifically disallows this.

Link: https://lkml.kernel.org/r/6797c4613e2b65f64def79acc4621e0fe42ef311.1751865330.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-mremap-permit-mremap-move-of-multiple-vmas
+++ a/mm/mremap.c
@@ -69,6 +69,8 @@ struct vma_remap_struct {
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
+	bool multi_vma;			/* Is >1 VMA being moved? */
+	bool vma_reset;			/* Was the VMA merged/unmap occur? */
 };
 
 static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
@@ -1111,6 +1113,7 @@ static void unmap_source_vma(struct vma_
 
 	err = do_vmi_munmap(&vmi, mm, addr, len, vrm->uf_unmap, /* unlock= */false);
 	vrm->vma = NULL; /* Invalidated. */
+	vrm->vma_reset = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_acct_memory(len >> PAGE_SHIFT);
@@ -1181,6 +1184,7 @@ static int copy_vma_and_data(struct vma_
 
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
 			   &pmc.need_rmap_locks);
+	vrm->vma_reset = vma != vrm->vma;
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
@@ -1325,6 +1329,7 @@ static unsigned long shrink_vma(struct v
 	res = do_vmi_munmap(&vmi, mm, unmap_start, unmap_bytes,
 			    vrm->uf_unmap, drop_lock);
 	vrm->vma = NULL; /* Invalidated. */
+	vrm->vma_reset = true;
 	if (res)
 		return res;
 
@@ -1362,6 +1367,7 @@ static unsigned long mremap_to(struct vm
 		err = do_munmap(mm, vrm->new_addr, vrm->new_len,
 				vrm->uf_unmap_early);
 		vrm->vma = NULL; /* Invalidated. */
+		vrm->vma_reset = true;
 		if (err)
 			return err;
 
@@ -1581,6 +1587,18 @@ static bool vrm_will_map_new(struct vma_
 	return false;
 }
 
+/* Does this remap ONLY move mappings? */
+static bool vrm_move_only(struct vma_remap_struct *vrm)
+{
+	if (!vrm_implies_new_addr(vrm))
+		return false;
+
+	if (vrm->old_len != vrm->new_len)
+		return false;
+
+	return true;
+}
+
 static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
 {
 	struct mm_struct *mm = current->mm;
@@ -1644,10 +1662,29 @@ static int check_prep_vma(struct vma_rem
 			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
 		return -EINVAL;
 
-	/* We can't remap across vm area boundaries */
+	/*
+	 * We can't remap across the end of VMAs, as another VMA may be
+	 * adjacent:
+	 *
+	 *       addr   vma->vm_end
+	 *  |-----.----------|
+	 *  |     .          |
+	 *  |-----.----------|
+	 *        .<--------->xxx>
+	 *            old_len
+	 *
+	 * We also require that vma->vm_start <= addr < vma->vm_end.
+	 */
 	if (old_len > vma->vm_end - addr)
 		return -EFAULT;
 
+	/*
+	 * We can't support moving multiple uffd VMAs as notify requires mmap
+	 * lock to be dropped.
+	 */
+	if (vrm->multi_vma && userfaultfd_armed(vma))
+		return -EINVAL;
+
 	if (new_len <= old_len)
 		return 0;
 
@@ -1744,6 +1781,57 @@ static unsigned long check_mremap_params
 	return 0;
 }
 
+static unsigned long remap_move(struct vma_remap_struct *vrm)
+{
+	struct vm_area_struct *vma;
+	unsigned long start = vrm->addr;
+	unsigned long end = vrm->addr + vrm->old_len;
+	unsigned long new_addr = vrm->new_addr;
+	unsigned long prev_addr = start;
+	VMA_ITERATOR(vmi, current->mm, start);
+
+	/*
+	 * When moving VMAs we allow for batched moves across multiple VMAs,
+	 * with all VMAs in the input range [addr, addr + old_len) being moved
+	 * (and split as necessary).
+	 */
+	for_each_vma_range(vmi, vma, end) {
+		unsigned long addr = max(vma->vm_start, start);
+		unsigned long len = min(end, vma->vm_end) - addr;
+		unsigned long offset = addr - start;
+		unsigned long res;
+
+		/* Merged with self, move on. */
+		if (vrm->multi_vma && prev_addr == addr)
+			continue;
+
+		vrm->vma = vma;
+		vrm->addr = addr;
+		vrm->new_addr = new_addr + offset;
+		vrm->old_len = vrm->new_len = len;
+
+		res = check_prep_vma(vrm);
+		if (!res)
+			res = mremap_to(vrm);
+		if (IS_ERR_VALUE(res))
+			return res;
+
+		/* mmap lock is only dropped on shrink. */
+		VM_WARN_ON_ONCE(!vrm->mmap_locked);
+		/* This is a move, no expand should occur. */
+		VM_WARN_ON_ONCE(vrm->populate_expand);
+
+		if (vrm->vma_reset) {
+			vma_iter_reset(&vmi);
+			vrm->vma_reset = false;
+		}
+		vrm->multi_vma = true;
+		prev_addr = addr;
+	}
+
+	return new_addr;
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
@@ -1761,13 +1849,17 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	vrm->vma = vma_lookup(current->mm, vrm->addr);
-	res = check_prep_vma(vrm);
-	if (res)
-		goto out;
+	if (vrm_move_only(vrm)) {
+		res = remap_move(vrm);
+	} else {
+		vrm->vma = vma_lookup(current->mm, vrm->addr);
+		res = check_prep_vma(vrm);
+		if (res)
+			goto out;
 
-	/* Actually execute mremap. */
-	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
+		/* Actually execute mremap. */
+		res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
+	}
 
 out:
 	failed = IS_ERR_VALUE(res);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

