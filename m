Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAB013B58A
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788151; cv=none; b=OJiVJm+mI/jmi8hPUEPuu8B8lQXUy9b6FCjw50ioX9GMNb9dSepFnF2Miqdux677m6MyesN5dkdqT90eRfdV1vNP1KKEABnGPYLWHYMDgGIPvP8P+7JV/JuErreYLzQQPz90dOPiZqI0TvVzR6iRrcRyGDXgOorkLUnHAFXqsQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788151; c=relaxed/simple;
	bh=RdH9yCncOqDrqHknxSVQVCSXM5ZmfrgE4LE5BnOvFMg=;
	h=Date:To:From:Subject:Message-Id; b=VM+bt+Sg0EiwxWTVB44forVPS2ucYfgcune2MjXPSYkDlRQcoIu+wPfSFvo079B70mVXYu6WGfy5C13+QWBmQpGmV5JN/fI+bqWNdGc8VQbv7n2Bt+OYrW9q+TP6+JRu3oCLuWT2ov1PU4UPCbAfExHGiTP3DKGQPT5FS70e+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tK11YO2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tK11YO2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0636C4CEE3;
	Thu, 17 Jul 2025 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752788150;
	bh=RdH9yCncOqDrqHknxSVQVCSXM5ZmfrgE4LE5BnOvFMg=;
	h=Date:To:From:Subject:From;
	b=tK11YO2KIFbElMDIFbISa5KSosPic4z6sbxezbA/xbIpdsFr1vc8XYoxTFKAlUJ0Y
	 OMUbd6K/UC9IWbqjtCFNAFkgmGFXEpg8/EE1Fj/YRwfHnm96Lkcu8N2QYKyjRyNMJK
	 IDHZeZpsj6MJPbe+phDtVwXYuU1pD+w7r4ydASHE=
Date: Thu, 17 Jul 2025 14:35:50 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-move-remap_is_valid-into-check_prep_vma.patch added to mm-new branch
Message-Id: <20250717213550.A0636C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: move remap_is_valid() into check_prep_vma()
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-move-remap_is_valid-into-check_prep_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-move-remap_is_valid-into-check_prep_vma.patch

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
Subject: mm/mremap: move remap_is_valid() into check_prep_vma()
Date: Thu, 17 Jul 2025 17:55:57 +0100

Group parameter check logic together, moving check_mremap_params() next to
it.

This puts all such checks into a single place, and invokes them early so
we can simply bail out as soon as we are aware that a condition is not
met.

No functional change intended.

Link: https://lkml.kernel.org/r/4d0669c23531629d8ead42aa701c6237bd6bf012.1752770784.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |  273 +++++++++++++++++++++++---------------------------
 1 file changed, 131 insertions(+), 142 deletions(-)

--- a/mm/mremap.c~mm-mremap-move-remap_is_valid-into-check_prep_vma
+++ a/mm/mremap.c
@@ -1307,64 +1307,6 @@ static unsigned long move_vma(struct vma
 }
 
 /*
- * remap_is_valid() - Ensure the VMA can be moved or resized to the new length,
- * at the given address.
- *
- * Return 0 on success, error otherwise.
- */
-static int remap_is_valid(struct vma_remap_struct *vrm)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = vrm->vma;
-	unsigned long addr = vrm->addr;
-	unsigned long old_len = vrm->old_len;
-	unsigned long new_len = vrm->new_len;
-	unsigned long pgoff;
-
-	/*
-	 * !old_len is a special case where an attempt is made to 'duplicate'
-	 * a mapping.  This makes no sense for private mappings as it will
-	 * instead create a fresh/new mapping unrelated to the original.  This
-	 * is contrary to the basic idea of mremap which creates new mappings
-	 * based on the original.  There are no known use cases for this
-	 * behavior.  As a result, fail such attempts.
-	 */
-	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
-		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n",
-			     current->comm, current->pid);
-		return -EINVAL;
-	}
-
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
-		return -EINVAL;
-
-	/* We can't remap across vm area boundaries */
-	if (old_len > vma->vm_end - addr)
-		return -EFAULT;
-
-	if (new_len <= old_len)
-		return 0;
-
-	/* Need to be careful about a growing mapping */
-	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
-	pgoff += vma->vm_pgoff;
-	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
-		return -EINVAL;
-
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
-		return -EFAULT;
-
-	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
-		return -EAGAIN;
-
-	if (!may_expand_vm(mm, vma->vm_flags, vrm->delta >> PAGE_SHIFT))
-		return -ENOMEM;
-
-	return 0;
-}
-
-/*
  * The user has requested that the VMA be shrunk (i.e., old_len > new_len), so
  * execute this, optionally dropping the mmap lock when we do so.
  *
@@ -1491,77 +1433,6 @@ static bool vrm_can_expand_in_place(stru
 }
 
 /*
- * Are the parameters passed to mremap() valid? If so return 0, otherwise return
- * error.
- */
-static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
-
-{
-	unsigned long addr = vrm->addr;
-	unsigned long flags = vrm->flags;
-
-	/* Ensure no unexpected flag values. */
-	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP))
-		return -EINVAL;
-
-	/* Start address must be page-aligned. */
-	if (offset_in_page(addr))
-		return -EINVAL;
-
-	/*
-	 * We allow a zero old-len as a special case
-	 * for DOS-emu "duplicate shm area" thing. But
-	 * a zero new-len is nonsensical.
-	 */
-	if (!vrm->new_len)
-		return -EINVAL;
-
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
-		return -EINVAL;
-
-	/* Remainder of checks are for cases with specific new_addr. */
-	if (!vrm_implies_new_addr(vrm))
-		return 0;
-
-	/* The new address must be page-aligned. */
-	if (offset_in_page(vrm->new_addr))
-		return -EINVAL;
-
-	/* A fixed address implies a move. */
-	if (!(flags & MREMAP_MAYMOVE))
-		return -EINVAL;
-
-	/* MREMAP_DONTUNMAP does not allow resizing in the process. */
-	if (flags & MREMAP_DONTUNMAP && vrm->old_len != vrm->new_len)
-		return -EINVAL;
-
-	/* Target VMA must not overlap source VMA. */
-	if (vrm_overlaps(vrm))
-		return -EINVAL;
-
-	/*
-	 * move_vma() need us to stay 4 maps below the threshold, otherwise
-	 * it will bail out at the very beginning.
-	 * That is a problem if we have already unmaped the regions here
-	 * (new_addr, and old_addr), because userspace will not know the
-	 * state of the vma's after it gets -ENOMEM.
-	 * So, to avoid such scenario we can pre-compute if the whole
-	 * operation has high chances to success map-wise.
-	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
-	 * split in 3 before unmapping it.
-	 * That means 2 more maps (1 for each) to the ones we already hold.
-	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
-	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/*
  * We know we can expand the VMA in-place by delta pages, so do so.
  *
  * If we discover the VMA is locked, update mm_struct statistics accordingly and
@@ -1712,9 +1583,26 @@ static bool vrm_will_map_new(struct vma_
 	return false;
 }
 
+static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
+{
+	struct mm_struct *mm = current->mm;
+
+	/* Regardless of success/failure, we always notify of any unmaps. */
+	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
+	if (failed)
+		mremap_userfaultfd_fail(vrm->uf);
+	else
+		mremap_userfaultfd_complete(vrm->uf, vrm->addr,
+			vrm->new_addr, vrm->old_len);
+	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
+}
+
 static int check_prep_vma(struct vma_remap_struct *vrm)
 {
 	struct vm_area_struct *vma = vrm->vma;
+	struct mm_struct *mm = current->mm;
+	unsigned long addr = vrm->addr;
+	unsigned long old_len, new_len, pgoff;
 
 	if (!vma)
 		return -EFAULT;
@@ -1731,26 +1619,127 @@ static int check_prep_vma(struct vma_rem
 	vrm->remap_type = vrm_remap_type(vrm);
 	/* For convenience, we set new_addr even if VMA won't move. */
 	if (!vrm_implies_new_addr(vrm))
-		vrm->new_addr = vrm->addr;
+		vrm->new_addr = addr;
+
+	/* Below only meaningful if we expand or move a VMA. */
+	if (!vrm_will_map_new(vrm))
+		return 0;
+
+	old_len = vrm->old_len;
+	new_len = vrm->new_len;
+
+	/*
+	 * !old_len is a special case where an attempt is made to 'duplicate'
+	 * a mapping.  This makes no sense for private mappings as it will
+	 * instead create a fresh/new mapping unrelated to the original.  This
+	 * is contrary to the basic idea of mremap which creates new mappings
+	 * based on the original.  There are no known use cases for this
+	 * behavior.  As a result, fail such attempts.
+	 */
+	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
+		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n",
+			     current->comm, current->pid);
+		return -EINVAL;
+	}
+
+	if ((vrm->flags & MREMAP_DONTUNMAP) &&
+			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
+		return -EINVAL;
+
+	/* We can't remap across vm area boundaries */
+	if (old_len > vma->vm_end - addr)
+		return -EFAULT;
+
+	if (new_len <= old_len)
+		return 0;
+
+	/* Need to be careful about a growing mapping */
+	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+	pgoff += vma->vm_pgoff;
+	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
+		return -EINVAL;
+
+	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
+		return -EFAULT;
+
+	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
+		return -EAGAIN;
 
-	if (vrm_will_map_new(vrm))
-		return remap_is_valid(vrm);
+	if (!may_expand_vm(mm, vma->vm_flags, vrm->delta >> PAGE_SHIFT))
+		return -ENOMEM;
 
 	return 0;
 }
 
-static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
+/*
+ * Are the parameters passed to mremap() valid? If so return 0, otherwise return
+ * error.
+ */
+static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
+
 {
-	struct mm_struct *mm = current->mm;
+	unsigned long addr = vrm->addr;
+	unsigned long flags = vrm->flags;
 
-	/* Regardless of success/failure, we always notify of any unmaps. */
-	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
-	if (failed)
-		mremap_userfaultfd_fail(vrm->uf);
-	else
-		mremap_userfaultfd_complete(vrm->uf, vrm->addr,
-			vrm->new_addr, vrm->old_len);
-	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
+	/* Ensure no unexpected flag values. */
+	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP))
+		return -EINVAL;
+
+	/* Start address must be page-aligned. */
+	if (offset_in_page(addr))
+		return -EINVAL;
+
+	/*
+	 * We allow a zero old-len as a special case
+	 * for DOS-emu "duplicate shm area" thing. But
+	 * a zero new-len is nonsensical.
+	 */
+	if (!vrm->new_len)
+		return -EINVAL;
+
+	/* Is the new length or address silly? */
+	if (vrm->new_len > TASK_SIZE ||
+	    vrm->new_addr > TASK_SIZE - vrm->new_len)
+		return -EINVAL;
+
+	/* Remainder of checks are for cases with specific new_addr. */
+	if (!vrm_implies_new_addr(vrm))
+		return 0;
+
+	/* The new address must be page-aligned. */
+	if (offset_in_page(vrm->new_addr))
+		return -EINVAL;
+
+	/* A fixed address implies a move. */
+	if (!(flags & MREMAP_MAYMOVE))
+		return -EINVAL;
+
+	/* MREMAP_DONTUNMAP does not allow resizing in the process. */
+	if (flags & MREMAP_DONTUNMAP && vrm->old_len != vrm->new_len)
+		return -EINVAL;
+
+	/* Target VMA must not overlap source VMA. */
+	if (vrm_overlaps(vrm))
+		return -EINVAL;
+
+	/*
+	 * move_vma() need us to stay 4 maps below the threshold, otherwise
+	 * it will bail out at the very beginning.
+	 * That is a problem if we have already unmaped the regions here
+	 * (new_addr, and old_addr), because userspace will not know the
+	 * state of the vma's after it gets -ENOMEM.
+	 * So, to avoid such scenario we can pre-compute if the whole
+	 * operation has high chances to success map-wise.
+	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
+	 * split in 3 before unmapping it.
+	 * That means 2 more maps (1 for each) to the ones we already hold.
+	 * Check whether current map count plus 2 still leads us to 4 maps below
+	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 */
+	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+		return -ENOMEM;
+
+	return 0;
 }
 
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
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

