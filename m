Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB5D5258
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752360912; cv=none; b=rlApXJeEijN6j7keCnERcckSwDooARUo9n8AP7hNFGBaXP81Mh5K5PfJcryIitQKdc7sfyyroB6RzZ48r2Ariud+yeSlNA7bJA8ZGeWBY9Fnxy/luCDKwuF3SB8c4hHroMpZni7+dQIHYIixabUQuz1N9wznKmGXry759Yli2mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752360912; c=relaxed/simple;
	bh=XLofsZTlEjw4ArMVqnUZ87AJppv35paZiw8fjTXAqsU=;
	h=Date:To:From:Subject:Message-Id; b=FHYPHiz2BCP2UwXMshx0PFBtWk9uQN9N+qlX0OwwXd5PeRh9QDjreF44wqh2nk862YY/25KA7kLMqeqoclnT9N1cZYbdkAeUMsY+E+IJJp9EygC5aqqDzde3txHdHLn/UJH+f3anzeuI/8JJg1ArKIRZcAgl9taGYAqr24WhT60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xXD1HegC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xXD1HegC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E64C4CEEF;
	Sat, 12 Jul 2025 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752360912;
	bh=XLofsZTlEjw4ArMVqnUZ87AJppv35paZiw8fjTXAqsU=;
	h=Date:To:From:Subject:From;
	b=xXD1HegC/jzaMHKcoHkH3PJjG82joTiHZ1MFB/p4q7bHZb5FCCLIDlrcFE+CNTBCT
	 pAjctGVT9PlXsqjf/BlCrPra1BZlA+bDYH/wFvalF3NkDlNNZIRjGyTJ3nwiFSrS+W
	 ZZBHQtUVW4eBZBOh+tM7Xv31X9exPWj/Cd1Tu7y0=
Date: Sat, 12 Jul 2025 15:55:11 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-permit-mremap-move-of-multiple-vmas.patch added to mm-unstable branch
Message-Id: <20250712225511.E8E64C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: permit mremap() move of multiple VMAs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-permit-mremap-move-of-multiple-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-permit-mremap-move-of-multiple-vmas.patch

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
Subject: mm/mremap: permit mremap() move of multiple VMAs
Date: Fri, 11 Jul 2025 12:38:23 +0100

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

Link: https://lkml.kernel.org/r/8f41e72b0543953d277e96d5e67a52f287cdbac3.1752232673.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  157 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 150 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-mremap-permit-mremap-move-of-multiple-vmas
+++ a/mm/mremap.c
@@ -69,6 +69,8 @@ struct vma_remap_struct {
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
+	bool seen_vma;			/* Is >1 VMA being moved? */
+	bool vmi_needs_reset;		/* Was the VMA iterator invalidated? */
 };
 
 static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
@@ -1186,6 +1188,9 @@ static int copy_vma_and_data(struct vma_
 		*new_vma_ptr = NULL;
 		return -ENOMEM;
 	}
+	if (vma != vrm->vma)
+		vrm->vmi_needs_reset = true;
+
 	vrm->vma = vma;
 	pmc.old = vma;
 	pmc.new = new_vma;
@@ -1581,6 +1586,18 @@ static bool vrm_will_map_new(struct vma_
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
@@ -1595,6 +1612,32 @@ static void notify_uffd(struct vma_remap
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
@@ -1644,7 +1687,19 @@ static int check_prep_vma(struct vma_rem
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
 
@@ -1744,6 +1799,90 @@ static unsigned long check_mremap_params
 	return 0;
 }
 
+static unsigned long remap_move(struct vma_remap_struct *vrm)
+{
+	struct vm_area_struct *vma;
+	unsigned long start = vrm->addr;
+	unsigned long end = vrm->addr + vrm->old_len;
+	unsigned long new_addr = vrm->new_addr;
+	unsigned long target_addr = new_addr;
+	unsigned long res = -EFAULT;
+	unsigned long last_end;
+	bool allowed = true;
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
+		if (!vrm->seen_vma && start < vma->vm_start)
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
+		offset = vrm->seen_vma ? vma->vm_start - last_end : 0;
+		last_end = vma->vm_end;
+
+		vrm->vma = vma;
+		vrm->addr = addr;
+		vrm->new_addr = target_addr + offset;
+		vrm->old_len = vrm->new_len = len;
+
+		allowed = vma_multi_allowed(vma);
+		if (vrm->seen_vma && !allowed)
+			return -EFAULT;
+
+		res_vma = check_prep_vma(vrm);
+		if (!res_vma)
+			res_vma = mremap_to(vrm);
+		if (IS_ERR_VALUE(res_vma))
+			return res_vma;
+
+		if (!vrm->seen_vma) {
+			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
+			res = res_vma;
+		}
+
+		/* mmap lock is only dropped on shrink. */
+		VM_WARN_ON_ONCE(!vrm->mmap_locked);
+		/* This is a move, no expand should occur. */
+		VM_WARN_ON_ONCE(vrm->populate_expand);
+
+		if (vrm->vmi_needs_reset) {
+			vma_iter_reset(&vmi);
+			vrm->vmi_needs_reset = false;
+		}
+		vrm->seen_vma = true;
+		target_addr = res_vma + vrm->new_len;
+	}
+
+	return res;
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
@@ -1761,13 +1900,17 @@ static unsigned long do_mremap(struct vm
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
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

