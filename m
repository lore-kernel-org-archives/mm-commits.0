Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4F75258
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752360895; cv=none; b=DF1mpmvNGJ7zqzsixI14Iwimz1BqU8JP7z/G3SVpeHl2AZ8cT56g+S4s527ZX5RFuGnmDN+Xo6D9dLTW13GKMm7bIsng6OCAl8jHbXGG0elR2wpbo10k5WFpSTlkPg2QgV0ir6/vo7L1jlXVA91SkvQNIxyUDwIE4XI0i6o+znI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752360895; c=relaxed/simple;
	bh=5gnftqKgtZwr8j1x+9GFcTz+QwmYqgpt9WCyxBub/bM=;
	h=Date:To:From:Subject:Message-Id; b=S2kr+k0PSU5SACTubNUb7wpM4fd9yDQ6TMSeWRpxChMrmGlt08p7Sq2t3x5l18f9pk61oSMUoRQ6bE8Agw4Me+4rfj44AARuirHpyHBB1JtVZCgkFKeGcU4mM6FEJP+bM8taOItepy8tphtnm+/4Zt0pEfUDS21hrCRzULq4M/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecoD5D/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecoD5D/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC8EC4CEEF;
	Sat, 12 Jul 2025 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752360895;
	bh=5gnftqKgtZwr8j1x+9GFcTz+QwmYqgpt9WCyxBub/bM=;
	h=Date:To:From:Subject:From;
	b=ecoD5D/KpyOG+ywO511Ci4Gg8rcndzfN8WYga31N6A6bLxBzVFdXjjjR/YNnoIOTE
	 R3MkaTV3f+r4eA6AdHzEx5DNSMd5Z/Ag6iPPHcxkxbH8Gfbl82W5jVJmrknkqESzMY
	 CuUvgc7DHmamSbXQbgv8QePumSF5eDcKur7/b+IQ=
Date: Sat, 12 Jul 2025 15:54:54 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-perform-some-simple-cleanups.patch added to mm-unstable branch
Message-Id: <20250712225454.DAC8EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: perform some simple cleanups
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-perform-some-simple-cleanups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-perform-some-simple-cleanups.patch

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
Subject: mm/mremap: perform some simple cleanups
Date: Fri, 11 Jul 2025 12:38:15 +0100

Patch series "mm/mremap: permit mremap() move of multiple VMAs", v3.

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

In order to do this, this series performs a large amount of refactoring,
most pertinently - grouping sanity checks together, separately those that
check input parameters and those relating to VMAs.

we also simplify the post-mmap lock drop processing for uffd and mlock()'d
VMAs.

With this done, we can then fairly straightforwardly implement this
functionality.

This works exclusively for mremap() invocations which specify
MREMAP_FIXED.  It is not compatible with VMAs which use userfaultfd, as
the notification of the userland fault handler would require us to drop
the mmap lock.

It is also not compatible with file-backed mappings with customised
get_unmapped_area() handlers as these may not honour MREMAP_FIXED.

The input and output addresses ranges must not overlap.  We carefully
account for moves which would result in VMA iterator invalidation.

While there can be gaps between VMAs in the input range, there can be no
gap before the first VMA in the range.


This patch (of 10):

We const-ify the vrm flags parameter to indicate this will never change.

We rename resize_is_valid() to remap_is_valid(), as this function does not
only apply to cases where we resize, so it's simply confusing to refer to
that here.

We remove the BUG() from mremap_at(), as we should not BUG() unless we are
certain it'll result in system instability.

We rename vrm_charge() to vrm_calc_charge() to make it clear this simply
calculates the charged number of pages rather than actually adjusting any
state.

We update the comment for vrm_implies_new_addr() to explain that
MREMAP_DONTUNMAP does not require a set address, but will always be moved.

Additionally consistently use 'res' rather than 'ret' for result values.

No functional change intended.

Link: https://lkml.kernel.org/r/cover.1752232673.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/e123452fec4eca6592d97f55f37af30416e46e38.1752232673.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |   55 +++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

--- a/mm/mremap.c~mm-mremap-perform-some-simple-cleanups
+++ a/mm/mremap.c
@@ -52,7 +52,7 @@ struct vma_remap_struct {
 	unsigned long addr;	/* User-specified address from which we remap. */
 	unsigned long old_len;	/* Length of range being remapped. */
 	unsigned long new_len;	/* Desired new length of mapping. */
-	unsigned long flags;	/* user-specified MREMAP_* flags. */
+	const unsigned long flags; /* user-specified MREMAP_* flags. */
 	unsigned long new_addr;	/* Optionally, desired new address. */
 
 	/* uffd state. */
@@ -909,7 +909,11 @@ static bool vrm_overlaps(struct vma_rema
 	return false;
 }
 
-/* Do the mremap() flags require that the new_addr parameter be specified? */
+/*
+ * Will a new address definitely be assigned? This either if the user specifies
+ * it via MREMAP_FIXED, or if MREMAP_DONTUNMAP is used, indicating we will
+ * always detemrine a target address.
+ */
 static bool vrm_implies_new_addr(struct vma_remap_struct *vrm)
 {
 	return vrm->flags & (MREMAP_FIXED | MREMAP_DONTUNMAP);
@@ -955,7 +959,7 @@ static unsigned long vrm_set_new_addr(st
  *
  * Returns true on success, false if insufficient memory to charge.
  */
-static bool vrm_charge(struct vma_remap_struct *vrm)
+static bool vrm_calc_charge(struct vma_remap_struct *vrm)
 {
 	unsigned long charged;
 
@@ -1260,8 +1264,11 @@ static unsigned long move_vma(struct vma
 	if (err)
 		return err;
 
-	/* If accounted, charge the number of bytes the operation will use. */
-	if (!vrm_charge(vrm))
+	/*
+	 * If accounted, determine the number of bytes the operation will
+	 * charge.
+	 */
+	if (!vrm_calc_charge(vrm))
 		return -ENOMEM;
 
 	/* We don't want racing faults. */
@@ -1300,12 +1307,12 @@ static unsigned long move_vma(struct vma
 }
 
 /*
- * resize_is_valid() - Ensure the vma can be resized to the new length at the give
- * address.
+ * remap_is_valid() - Ensure the VMA can be moved or resized to the new length,
+ * at the given address.
  *
  * Return 0 on success, error otherwise.
  */
-static int resize_is_valid(struct vma_remap_struct *vrm)
+static int remap_is_valid(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = vrm->vma;
@@ -1444,7 +1451,7 @@ static unsigned long mremap_to(struct vm
 		vrm->old_len = vrm->new_len;
 	}
 
-	err = resize_is_valid(vrm);
+	err = remap_is_valid(vrm);
 	if (err)
 		return err;
 
@@ -1569,7 +1576,7 @@ static unsigned long expand_vma_in_place
 	struct vm_area_struct *vma = vrm->vma;
 	VMA_ITERATOR(vmi, mm, vma->vm_end);
 
-	if (!vrm_charge(vrm))
+	if (!vrm_calc_charge(vrm))
 		return -ENOMEM;
 
 	/*
@@ -1630,7 +1637,7 @@ static unsigned long expand_vma(struct v
 	unsigned long err;
 	unsigned long addr = vrm->addr;
 
-	err = resize_is_valid(vrm);
+	err = remap_is_valid(vrm);
 	if (err)
 		return err;
 
@@ -1703,18 +1710,20 @@ static unsigned long mremap_at(struct vm
 		return expand_vma(vrm);
 	}
 
-	BUG();
+	/* Should not be possible. */
+	WARN_ON_ONCE(1);
+	return -EINVAL;
 }
 
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long ret;
+	unsigned long res;
 
-	ret = check_mremap_params(vrm);
-	if (ret)
-		return ret;
+	res = check_mremap_params(vrm);
+	if (res)
+		return res;
 
 	vrm->old_len = PAGE_ALIGN(vrm->old_len);
 	vrm->new_len = PAGE_ALIGN(vrm->new_len);
@@ -1726,41 +1735,41 @@ static unsigned long do_mremap(struct vm
 
 	vma = vrm->vma = vma_lookup(mm, vrm->addr);
 	if (!vma) {
-		ret = -EFAULT;
+		res = -EFAULT;
 		goto out;
 	}
 
 	/* If mseal()'d, mremap() is prohibited. */
 	if (!can_modify_vma(vma)) {
-		ret = -EPERM;
+		res = -EPERM;
 		goto out;
 	}
 
 	/* Align to hugetlb page size, if required. */
 	if (is_vm_hugetlb_page(vma) && !align_hugetlb(vrm)) {
-		ret = -EINVAL;
+		res = -EINVAL;
 		goto out;
 	}
 
 	vrm->remap_type = vrm_remap_type(vrm);
 
 	/* Actually execute mremap. */
-	ret = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
+	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
 
 out:
 	if (vrm->mmap_locked) {
 		mmap_write_unlock(mm);
 		vrm->mmap_locked = false;
 
-		if (!offset_in_page(ret) && vrm->mlocked && vrm->new_len > vrm->old_len)
+		if (!offset_in_page(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
 			mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 	}
 
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
-	mremap_userfaultfd_complete(vrm->uf, vrm->addr, ret, vrm->old_len);
+	mremap_userfaultfd_complete(vrm->uf, vrm->addr, res, vrm->old_len);
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
 
-	return ret;
+	return res;
 }
 
 /*
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

