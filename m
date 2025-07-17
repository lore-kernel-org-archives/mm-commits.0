Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AFB13B58A
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788153; cv=none; b=rXKNcTPaYXvnEKqwEjxrDLhm5VZYG1nHU1eadbV06Ns0Vgq76CzU8wbgds1WYo75Yc5vqo5HTSh23p2tt9MYCYg0FdSLXxh/vGNaFetTvlWsccIGBDT8jMTU6P3hePIY4rxUIZukawfaj/fliBPV80S4c2YaXy7rRM/FYeFabS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788153; c=relaxed/simple;
	bh=drq8snPamobP2/kHnMbu5Ch+egOHe4Kz4pRy0Fwpca8=;
	h=Date:To:From:Subject:Message-Id; b=dSuE3y/muj8UsmKsXVe7jq6DFDgV0ftvXFsZoK56uk5Aktaoh7pyhYyFMgpDP/C8/MvuP9U1DREXCwvgYVTsr+epG02xWlRRsJ5Q3/bRGz2F7O69xmuoX/z/LPedBkLkWV/FbDJTqun6BQbznQhMOuJE/9CGwQ1Kh69a5blqXkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WtKKUPq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WtKKUPq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392A1C4CEE3;
	Thu, 17 Jul 2025 21:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752788153;
	bh=drq8snPamobP2/kHnMbu5Ch+egOHe4Kz4pRy0Fwpca8=;
	h=Date:To:From:Subject:From;
	b=WtKKUPq33JkXZiEzYWIOiak2Oax1UchDLgWb0vFiV0n0pvuNsvx4vrAUSSVahHPlL
	 LJ5gmHxIXNNXJUr8zUpA8LMeD1ascChYfNtgD1PIqBFdILP67b0JA5pM0c4XmhX7WJ
	 vClbyi7yGaY1e7cpS4LRfKGRCxF0To50hO+FvWE4=
Date: Thu, 17 Jul 2025 14:35:52 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-permit-mremap-move-of-multiple-vmas.patch added to mm-new branch
Message-Id: <20250717213553.392A1C4CEE3@smtp.kernel.org>
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
Date: Thu, 17 Jul 2025 17:55:59 +0100

Historically we've made it a uAPI requirement that mremap() may only
operate on a single VMA at a time.

For instances where VMAs need to be resized, this makes sense, as it
becomes very difficult to determine what a user actually wants should they
indicate a desire to expand or shrink the size of multiple VMAs (truncate?
Adjust sizes individually?  Some other strategy?).

However, in instances where a user is moving VMAs, it is restrictive to
disallow this.

This is especially the case when anonymous mapping remap may or may not be
mergeable depending on whether VMAs have or have not been faulted due to
anon_vma assignment and folio index alignment with vma->vm_pgoff.

Often this can result in surprising impact where a moved region is
faulted, then moved back and a user fails to observe a merge from
otherwise compatible, adjacent VMAs.

This change allows such cases to work without the user having to be
cognizant of whether a prior mremap() move or other VMA operations has
resulted in VMA fragmentation.

We only permit this for mremap() operations that do NOT change the size of
the VMA and DO specify MREMAP_MAYMOVE | MREMAP_FIXED.

Should no VMA exist in the range, -EFAULT is returned as usual.

If a VMA move spans a single VMA - then there is no functional change.

Otherwise, we place additional requirements upon VMAs:

* They must not have a userfaultfd context associated with them - this
  requires dropping the lock to notify users, and we want to perform the
  operation with the mmap write lock held throughout.

* If file-backed, they cannot have a custom get_unmapped_area handler -
  this might result in MREMAP_FIXED not being honoured, which could result
  in unexpected positioning of VMAs in the moved region.

There may be gaps in the range of VMAs that are moved:

                   X        Y                       X        Y
                 <--->     <->                    <--->     <->
         |-------|   |-----| |-----|      |-------|   |-----| |-----|
         |   A   |   |  B  | |  C  | ---> |   A'  |   |  B' | |  C' |
         |-------|   |-----| |-----|      |-------|   |-----| |-----|
        addr                           new_addr

The move will preserve the gaps between each VMA.

Note that any failures encountered will result in a partial move.  Since
an mremap() can fail at any time, this might result in only some of the
VMAs being moved.

Note that failures are very rare and typically require an out of a memory
condition or a mapping limit condition to be hit, assuming the VMAs being
moved are valid.

We don't try to assess ahead of time whether VMAs are valid according to
the multi VMA rules, as it would be rather unusual for a user to mix
uffd-enabled VMAs and/or VMAs which map unusual driver mappings that
specify custom get_unmapped_area() handlers in an aggregate operation.

So we optimise for the far, far more likely case of the operation being
entirely permissible.

In the case of the move of a single VMA, the above conditions are
permitted.  This makes the behaviour identical for a single VMA as before.

Link: https://lkml.kernel.org/r/8cab2f2c202c4208bdfdb562635748bea6eb37bf.1752770784.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  159 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 152 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-mremap-permit-mremap-move-of-multiple-vmas
+++ a/mm/mremap.c
@@ -69,6 +69,7 @@ struct vma_remap_struct {
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
+	bool vmi_needs_invalidate;	/* Is the VMA iterator invalidated? */
 };
 
 static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
@@ -1111,6 +1112,7 @@ static void unmap_source_vma(struct vma_
 
 	err = do_vmi_munmap(&vmi, mm, addr, len, vrm->uf_unmap, /* unlock= */false);
 	vrm->vma = NULL; /* Invalidated. */
+	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_acct_memory(len >> PAGE_SHIFT);
@@ -1186,6 +1188,10 @@ static int copy_vma_and_data(struct vma_
 		*new_vma_ptr = NULL;
 		return -ENOMEM;
 	}
+	/* By merging, we may have invalidated any iterator in use. */
+	if (vma != vrm->vma)
+		vrm->vmi_needs_invalidate = true;
+
 	vrm->vma = vma;
 	pmc.old = vma;
 	pmc.new = new_vma;
@@ -1362,6 +1368,7 @@ static unsigned long mremap_to(struct vm
 		err = do_munmap(mm, vrm->new_addr, vrm->new_len,
 				vrm->uf_unmap_early);
 		vrm->vma = NULL; /* Invalidated. */
+		vrm->vmi_needs_invalidate = true;
 		if (err)
 			return err;
 
@@ -1581,6 +1588,18 @@ static bool vrm_will_map_new(struct vma_
 	return false;
 }
 
+/* Does this remap ONLY move mappings? */
+static bool vrm_move_only(struct vma_remap_struct *vrm)
+{
+	if (!(vrm->flags & MREMAP_FIXED))
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
@@ -1595,6 +1614,32 @@ static void notify_uffd(struct vma_remap
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
 }
 
+static bool vma_multi_allowed(struct vm_area_struct *vma)
+{
+	struct file *file;
+
+	/*
+	 * We can't support moving multiple uffd VMAs as notify requires
+	 * mmap lock to be dropped.
+	 */
+	if (userfaultfd_armed(vma))
+		return false;
+
+	/*
+	 * Custom get unmapped area might result in MREMAP_FIXED not
+	 * being obeyed.
+	 */
+	file = vma->vm_file;
+	if (file && !vma_is_shmem(vma) && !is_vm_hugetlb_page(vma)) {
+		const struct file_operations *fop = file->f_op;
+
+		if (fop->get_unmapped_area)
+			return false;
+	}
+
+	return true;
+}
+
 static int check_prep_vma(struct vma_remap_struct *vrm)
 {
 	struct vm_area_struct *vma = vrm->vma;
@@ -1644,7 +1689,19 @@ static int check_prep_vma(struct vma_rem
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
 
@@ -1744,6 +1801,90 @@ static unsigned long check_mremap_params
 	return 0;
 }
 
+static unsigned long remap_move(struct vma_remap_struct *vrm)
+{
+	struct vm_area_struct *vma;
+	unsigned long start = vrm->addr;
+	unsigned long end = vrm->addr + vrm->old_len;
+	unsigned long new_addr = vrm->new_addr;
+	bool allowed = true, seen_vma = false;
+	unsigned long target_addr = new_addr;
+	unsigned long res = -EFAULT;
+	unsigned long last_end;
+	VMA_ITERATOR(vmi, current->mm, start);
+
+	/*
+	 * When moving VMAs we allow for batched moves across multiple VMAs,
+	 * with all VMAs in the input range [addr, addr + old_len) being moved
+	 * (and split as necessary).
+	 */
+	for_each_vma_range(vmi, vma, end) {
+		/* Account for start, end not aligned with VMA start, end. */
+		unsigned long addr = max(vma->vm_start, start);
+		unsigned long len = min(end, vma->vm_end) - addr;
+		unsigned long offset, res_vma;
+
+		if (!allowed)
+			return -EFAULT;
+
+		/* No gap permitted at the start of the range. */
+		if (!seen_vma && start < vma->vm_start)
+			return -EFAULT;
+
+		/*
+		 * To sensibly move multiple VMAs, accounting for the fact that
+		 * get_unmapped_area() may align even MAP_FIXED moves, we simply
+		 * attempt to move such that the gaps between source VMAs remain
+		 * consistent in destination VMAs, e.g.:
+		 *
+		 *           X        Y                       X        Y
+		 *         <--->     <->                    <--->     <->
+		 * |-------|   |-----| |-----|      |-------|   |-----| |-----|
+		 * |   A   |   |  B  | |  C  | ---> |   A'  |   |  B' | |  C' |
+		 * |-------|   |-----| |-----|      |-------|   |-----| |-----|
+		 *                               new_addr
+		 *
+		 * So we map B' at A'->vm_end + X, and C' at B'->vm_end + Y.
+		 */
+		offset = seen_vma ? vma->vm_start - last_end : 0;
+		last_end = vma->vm_end;
+
+		vrm->vma = vma;
+		vrm->addr = addr;
+		vrm->new_addr = target_addr + offset;
+		vrm->old_len = vrm->new_len = len;
+
+		allowed = vma_multi_allowed(vma);
+		if (seen_vma && !allowed)
+			return -EFAULT;
+
+		res_vma = check_prep_vma(vrm);
+		if (!res_vma)
+			res_vma = mremap_to(vrm);
+		if (IS_ERR_VALUE(res_vma))
+			return res_vma;
+
+		if (!seen_vma) {
+			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
+			res = res_vma;
+		}
+
+		/* mmap lock is only dropped on shrink. */
+		VM_WARN_ON_ONCE(!vrm->mmap_locked);
+		/* This is a move, no expand should occur. */
+		VM_WARN_ON_ONCE(vrm->populate_expand);
+
+		if (vrm->vmi_needs_invalidate) {
+			vma_iter_invalidate(&vmi);
+			vrm->vmi_needs_invalidate = false;
+		}
+		seen_vma = true;
+		target_addr = res_vma + vrm->new_len;
+	}
+
+	return res;
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
@@ -1761,13 +1902,17 @@ static unsigned long do_mremap(struct vm
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

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

