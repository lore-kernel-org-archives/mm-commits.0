Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECC974040
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409673; cv=none; b=bPbHZ86LGdDunJpaOoWbUCjyD6jEH4IM5Pzue+DFBTkP9v8eDjPzbSrCFSpH7keo04F0TsBNXcAJZQHDz8CJPasiy7ifsWAOrGgxvwWjlqyof21w/cR4vzkuaV4vrod5/Vr9aJLXW1uNjy7f+qHBvLLGij0nsA4HuHMUUxjedss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409673; c=relaxed/simple;
	bh=lspdX82c+JKF4LXs9Ar/MM6UKoio6Bl3xvhpC/qY9Eo=;
	h=Date:To:From:Subject:Message-Id; b=kCh7gDAd3an+GIQ8/XP7+4bXBb5ziLuYwn8s584ed9ZtrhdKLjhKZFyn1xKo1DiiIQnhUpJIzry4lVpuBodnnwcjtS1sbo6km4w03lMqGgfQAxIsUMeSzZJpyj2Ry/Cc6pzzCCTniHkOPrDyVTCbPAro0+p/gcSm8fDOLkA4/TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gCs9GWId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gCs9GWId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67C8C4CEED;
	Fri, 25 Jul 2025 02:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409673;
	bh=lspdX82c+JKF4LXs9Ar/MM6UKoio6Bl3xvhpC/qY9Eo=;
	h=Date:To:From:Subject:From;
	b=gCs9GWIdcwA2VA5MtaO9FLUkk2dgWbFjIOuO4a8TKjA+NVazceYoUPTPqfk+hJdg7
	 ZWjglrF+e2pPrzqml5cluVg6sxKC32NSmiAexwC1Mrx9II9yh61KfMB1sd0oLmcREy
	 2DJG/Qd7JeOF5OeB22S40CCleSs1V8NuEzWPuzt4=
Date: Thu, 24 Jul 2025 19:14:32 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-permit-mremap-move-of-multiple-vmas.patch removed from -mm tree
Message-Id: <20250725021432.E67C8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: permit mremap() move of multiple VMAs
has been removed from the -mm tree.  Its filename was
     mm-mremap-permit-mremap-move-of-multiple-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1651,7 +1696,19 @@ static int check_prep_vma(struct vma_rem
 	if (vrm->remap_type == MREMAP_SHRINK)
 		old_len = new_len;
 
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
 
@@ -1751,6 +1808,90 @@ static unsigned long check_mremap_params
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
@@ -1768,13 +1909,17 @@ static unsigned long do_mremap(struct vm
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

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

