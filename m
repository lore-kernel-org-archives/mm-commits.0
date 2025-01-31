Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A054E182
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 00:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738284759; cv=none; b=IYTblm/UNdoo1BC9GpPC/dfZZIRmlT4UVyX9vfoaY9pYSMDKVdZlhJ81Ekdh3WDh9dfr7/QBi1dvyVYj5Zc0IXzfigogy+tyRxUFqBDyyBN042o9TCnfyQUu08ApxprlxQJps+izGm4GtnFWsYFT82oUjDaEuit8qW7tsfMmBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738284759; c=relaxed/simple;
	bh=EMKRgr6KV+jPSJWsfhodt1Nha0XSp3Vh+fM/lLgWdG8=;
	h=Date:To:From:Subject:Message-Id; b=rhce3IlYrZQGhgaDhTvOBImvGERm0o9qr1BAyJ2Shk0ikmbhFdW0n1W/bXpAVFhGBJb78PoMDPFB0pX6iptVoNv9KoYpjHO07db/hRYdsGjmLo+9g4iyA0inF8jdVdOv1CmBmbqYghkZrKT3NUbI2iNISKbbae2zscUPX1sNE1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kWzr+4os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kWzr+4os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631F5C4CED2;
	Fri, 31 Jan 2025 00:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738284759;
	bh=EMKRgr6KV+jPSJWsfhodt1Nha0XSp3Vh+fM/lLgWdG8=;
	h=Date:To:From:Subject:From;
	b=kWzr+4os3NvFQffrc6K0+Uhlb805vGz8rF2MVxE90d7UBCoE39R0/BXW5NkjC9vWy
	 jwonIjTIGElH/FhQEbU+6RoLPqGwz1jL9vQxHmBrNrgSC7DzvO/CEFh7bQ8F2C+xhp
	 e+fcgh6LZNHImf76GLShurBt7oT1UxQdwmyBe6sU=
Date: Thu, 30 Jan 2025 16:52:38 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-eliminate-adj_start-parameter-from-commit_merge.patch added to mm-unstable branch
Message-Id: <20250131005239.631F5C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: eliminate adj_start parameter from commit_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-eliminate-adj_start-parameter-from-commit_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-eliminate-adj_start-parameter-from-commit_merge.patch

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
Subject: mm: eliminate adj_start parameter from commit_merge()
Date: Wed, 29 Jan 2025 18:16:37 +0000

Introduce internal vmg->__adjust_middle_start and vmg->__adjust_next_start
merge flags, enabling us to indicate to commit_merge() that we are
performing a merge which either spans only part of vmg->middle, or part of
vmg->next respectively.

In the former instance, we change the start of vmg->middle to match the
attributes of vmg->prev, without spanning all of vmg->middle.

This implies that vmg->prev->vm_end and vmg->middle->vm_start are both
increased to form the new merged VMA (vmg->prev) and the new subsequent
VMA (vmg->middle).

In the latter case, we change the end of vmg->middle to match the
attributes of vmg->next, without spanning all of vmg->next.

This implies that vmg->middle->vm_end and vmg->next->vm_start are both
decreased to form the new merged VMA (vmg->next) and the new prior VMA
(vmg->middle).

Since we now have a stable set of prev, middle, next VMAs threaded through
vmg and with these flags set know what is happening, we can perform the
calculation in commit_merge() instead.

This allows us to drop the confusing adj_start parameter and instead pass
semantic information to commit_merge().

In the latter case the -(middle->vm_end - start) calculation becomes
-(middle->vm-end - vmg->end), however this is correct as vmg->end is set
to the start parameter.

This is because in this case (rather confusingly), we manipulate
vmg->middle, but ultimately return vmg->next, whose range will be
correctly specified.  At this point vmg->start, end is the new range for
the prior VMA rather than the merged one.

This patch has no change in functional behaviour.

Link: https://lkml.kernel.org/r/5a12615fc1432f353c4424ef58d4ebbda7a08b14.1738172812.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c              |    8 ++++--
 mm/vma.c                |   50 ++++++++++++++++++++++----------------
 mm/vma.h                |   10 +++++++
 tools/testing/vma/vma.c |    2 +
 4 files changed, 48 insertions(+), 22 deletions(-)

--- a/mm/debug.c~mm-eliminate-adj_start-parameter-from-commit_merge
+++ a/mm/debug.c
@@ -267,7 +267,9 @@ void dump_vmg(const struct vma_merge_str
 		"uffd_ctx %px\n"
 		"anon_name %px\n"
 		"state %x\n"
-		"just_expand %b __remove_middle %b __remove_next %b\n",
+		"just_expand %b\n"
+		"__adjust_middle_start %b __adjust_next_start %b\n"
+		"__remove_middle %b __remove_next %b\n",
 		vmg, vmg->mm, vmg->pgoff,
 		vmg->vmi, vmg->vmi ? vma_iter_addr(vmg->vmi) : 0,
 		vmg->vmi ? vma_iter_end(vmg->vmi) : 0,
@@ -281,7 +283,9 @@ void dump_vmg(const struct vma_merge_str
 #endif
 		vmg->anon_name,
 		(int)vmg->state,
-		vmg->just_expand, vmg->__remove_middle, vmg->__remove_next);
+		vmg->just_expand,
+		vmg->__adjust_middle_start, vmg->__adjust_next_start,
+		vmg->__remove_middle, vmg->__remove_next);
 
 	if (vmg->mm) {
 		pr_warn("vmg %px mm:\n", vmg);
--- a/mm/vma.c~mm-eliminate-adj_start-parameter-from-commit_merge
+++ a/mm/vma.c
@@ -632,29 +632,44 @@ void validate_mm(struct mm_struct *mm)
  *
  * On success, returns the merged VMA. Otherwise returns NULL.
  */
-static struct vm_area_struct *commit_merge(struct vma_merge_struct *vmg,
-		long adj_start)
+static struct vm_area_struct *commit_merge(struct vma_merge_struct *vmg)
 {
-	struct vma_prepare vp;
 	struct vm_area_struct *remove = NULL;
 	struct vm_area_struct *remove2 = NULL;
+	struct vma_prepare vp;
 	struct vm_area_struct *adjust = NULL;
+	long adj_start;
+	bool merge_target;
+
 	/*
-	 * In all cases but that of merge right, shrink next, we write
-	 * vmg->target to the maple tree and return this as the merged VMA.
+	 * If modifying an existing VMA and we don't remove vmg->middle, then we
+	 * shrink the adjacent VMA.
 	 */
-	bool merge_target = adj_start >= 0;
+	if (vmg->__adjust_middle_start) {
+		adjust = vmg->middle;
+		/* The POSITIVE value by which we offset vmg->middle->vm_start. */
+		adj_start = vmg->end - vmg->middle->vm_start;
+		merge_target = true;
+	} else if (vmg->__adjust_next_start) {
+		adjust = vmg->next;
+		/* The NEGATIVE value by which we offset vmg->next->vm_start. */
+		adj_start = -(vmg->middle->vm_end - vmg->end);
+		/*
+		 * In all cases but this - merge right, shrink next - we write
+		 * vmg->target to the maple tree and return this as the merged VMA.
+		 */
+		merge_target = false;
+	} else {
+		adjust = NULL;
+		adj_start = 0;
+		merge_target = true;
+	}
 
 	if (vmg->__remove_middle)
 		remove = vmg->middle;
 	if (vmg->__remove_next)
 		remove2 = vmg->next;
 
-	if (adj_start > 0)
-		adjust = vmg->middle;
-	else if (adj_start < 0)
-		adjust = vmg->next;
-
 	init_multi_vma_prep(&vp, vmg->target, adjust, remove, remove2);
 
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
@@ -738,7 +753,6 @@ static __must_check struct vm_area_struc
 	bool left_side = middle && start == middle->vm_start;
 	bool right_side = middle && end == middle->vm_end;
 	int err = 0;
-	long adj_start = 0;
 	bool merge_left, merge_right, merge_both;
 
 	mmap_assert_write_locked(vmg->mm);
@@ -858,11 +872,8 @@ static __must_check struct vm_area_struc
 		vmg->start = prev->vm_start;
 		vmg->pgoff = prev->vm_pgoff;
 
-		/*
-		 * We both expand prev and shrink middle.
-		 */
 		if (!vmg->__remove_middle)
-			adj_start = vmg->end - middle->vm_start;
+			vmg->__adjust_middle_start = true;
 
 		err = dup_anon_vma(prev, middle, &anon_dup);
 	} else { /* merge_right */
@@ -891,12 +902,11 @@ static __must_check struct vm_area_struc
 			 * IMPORTANT: This is the ONLY case where the final
 			 * merged VMA is NOT vmg->target, but rather vmg->next.
 			 */
+			vmg->__adjust_next_start = true;
 			vmg->target = middle;
 			vmg->start = middle->vm_start;
 			vmg->end = start;
 			vmg->pgoff = middle->vm_pgoff;
-
-			adj_start = -(middle->vm_end - start);
 		}
 
 		err = dup_anon_vma(next, middle, &anon_dup);
@@ -905,7 +915,7 @@ static __must_check struct vm_area_struc
 	if (err)
 		goto abort;
 
-	res = commit_merge(vmg, adj_start);
+	res = commit_merge(vmg);
 	if (!res) {
 		if (anon_dup)
 			unlink_anon_vmas(anon_dup);
@@ -1079,7 +1089,7 @@ int vma_expand(struct vma_merge_struct *
 	if (remove_next)
 		vmg->__remove_next = true;
 
-	if (!commit_merge(vmg, 0))
+	if (!commit_merge(vmg))
 		goto nomem;
 
 	return 0;
--- a/mm/vma.h~mm-eliminate-adj_start-parameter-from-commit_merge
+++ a/mm/vma.h
@@ -121,6 +121,16 @@ struct vma_merge_struct {
 	/* Internal flags set during merge process: */
 
 	/*
+	 * Internal flag indicating the merge increases vmg->middle->vm_start
+	 * (and thereby, vmg->prev->vm_end).
+	 */
+	bool __adjust_middle_start :1;
+	/*
+	 * Internal flag indicating the merge decreases vmg->next->vm_start
+	 * (and thereby, vmg->middle->vm_end).
+	 */
+	bool __adjust_next_start :1;
+	/*
 	 * Internal flag used during the merge operation to indicate we will
 	 * remove vmg->middle.
 	 */
--- a/tools/testing/vma/vma.c~mm-eliminate-adj_start-parameter-from-commit_merge
+++ a/tools/testing/vma/vma.c
@@ -159,6 +159,8 @@ static void vmg_set_range(struct vma_mer
 	vmg->just_expand = false;
 	vmg->__remove_middle = false;
 	vmg->__remove_next = false;
+	vmg->__adjust_middle_start = false;
+	vmg->__adjust_next_start = false;
 }
 
 /*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch

