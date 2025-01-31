Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD2E1494AD
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 22:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738363202; cv=none; b=SbpQceNaiUhvzrhgWed+t8kW1xAk+G38bd4+ZdmI9e6a5mzuev78aqbY6BWmf9yGPo94D89hP13NFYxzU9oq0rEPS1WhjvQkhBAC1p+V/P2AxKK/CHAW4wCCgFm81ffugsV/mWjLrwcVZyVAYMYiHIw5BNu3AczfJQgM3p5D67Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738363202; c=relaxed/simple;
	bh=xua5VjFV0o65qu9abE27Et1feD+7J2vrvd5FegqIQwQ=;
	h=Date:To:From:Subject:Message-Id; b=gv52rYxOvI1lvxRDvAikRnVxoMb4+BBM4ZCUaBx4/J46Q+oEG3LAfrNXf05gV/v1KDC5daPr5Ui+XzD/cy1hsqDt7ohJQwC12g3e8HRpamUMujDp5IfFTWadK0EBH6rDbVVZDab1Fa1X5VRTv6zHW1qQk1svweKEn3ibFy+nPMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c2dpIQWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c2dpIQWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E60C4CED1;
	Fri, 31 Jan 2025 22:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738363201;
	bh=xua5VjFV0o65qu9abE27Et1feD+7J2vrvd5FegqIQwQ=;
	h=Date:To:From:Subject:From;
	b=c2dpIQWWfFtWu4QZmUbOrGegg3CtWWEROaQfEBjFlFzv+LZrQQ4AEO2kqP2S+b3qq
	 XtLofSUTEM0P54QwdAOSh03ViGaoD8IJ3k/ORgmFSRuSBbBeoHXABvyu/1fgB4Xa+j
	 Zwe5yw+ePics6NJJ80nkKY1TKuPJQRRllYtiipQo=
Date: Fri, 31 Jan 2025 14:40:00 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-completely-abstract-unnecessary-adj_start-calculation.patch added to mm-unstable branch
Message-Id: <20250131224001.64E60C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: completely abstract unnecessary adj_start calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-completely-abstract-unnecessary-adj_start-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-completely-abstract-unnecessary-adj_start-calculation.patch

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
Subject: mm: completely abstract unnecessary adj_start calculation
Date: Fri, 31 Jan 2025 12:31:53 +0000

The adj_start calculation has been a constant source of confusion in the
VMA merge code.

There are two cases to consider, one where we adjust the start of the
vmg->middle VMA (i.e.  the vmg->__adjust_middle_start merge flag is set),
in which case adj_start is calculated as:

(1) adj_start = vmg->end - vmg->middle->vm_start

And the case where we adjust the start of the vmg->next VMA (i.e.  the
vmg->__adjust_next_start merge flag is set), in which case adj_start is
calculated as:

(2) adj_start = -(vmg->middle->vm_end - vmg->end)

We apply (1) thusly:

vmg->middle->vm_start =
	vmg->middle->vm_start + vmg->end - vmg->middle->vm_start

Which simplifies to:

vmg->middle->vm_start = vmg->end

Similarly, we apply (2) as:

vmg->next->vm_start =
	vmg->next->vm_start + -(vmg->middle->vm_end - vmg->end)

Noting that for these VMAs to be mergeable vmg->middle->vm_end ==
vmg->next->vm_start and so this simplifies to:

vmg->next->vm_start =
	vmg->next->vm_start + -(vmg->next->vm_start - vmg->end)

Which simplifies to:

vmg->next->vm_start = vmg->end

Therefore in each case, we simply need to adjust the start of the VMA to
vmg->end (!) and can do away with this adj_start calculation.  The only
caveat is that we must ensure we update the vm_pgoff field correctly.

We therefore abstract this entire calculation to a new function
vmg_adjust_set_range() which performs this calculation and sets the
adjusted VMA's new range using the general vma_set_range() function.

We also must update vma_adjust_trans_huge() which expects the
now-abstracted adj_start parameter.  It turns out this is wholly
unnecessary.

In vma_adjust_trans_huge() the relevant code is:

	if (adjust_next > 0) {
		struct vm_area_struct *next = find_vma(vma->vm_mm, vma->vm_end);
		unsigned long nstart = next->vm_start;
		nstart += adjust_next;
		split_huge_pmd_if_needed(next, nstart);
	}

The only case where this is relevant is when vmg->__adjust_middle_start is
specified (in which case adj_next would have been positive), i.e.  the one
in which the vma specified is vmg->prev and this the sought 'next' VMA
would be vmg->middle.

We can therefore eliminate the find_vma() invocation altogether and simply
provide the vmg->middle VMA in this instance, or NULL otherwise.

Again we have an adj_next offset calculation:

next->vm_start + vmg->end - vmg->middle->vm_start

Where next == vmg->middle this simplifies to vmg->end as previously
demonstrated.

Therefore nstart is equal to vmg->end, which is already passed to
vma_adjust_trans_huge() via the 'end' parameter and so this code (rather
delightfully) simplifies to:

	if (next)
		split_huge_pmd_if_needed(next, end);

With these changes in place, it becomes silly for commit_merge() to return
vmg->target, as it is always the same and threaded through vmg, so we
finally change commit_merge() to return an error value once again.

This patch has no change in functional behaviour.

Link: https://lkml.kernel.org/r/7bce2cd4b5afb56211822835d145471280c3dccc.1738326519.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h          |    4 -
 mm/huge_memory.c                 |   19 +----
 mm/vma.c                         |   99 +++++++++++++----------------
 tools/testing/vma/vma_internal.h |    4 -
 4 files changed, 57 insertions(+), 69 deletions(-)

--- a/include/linux/huge_mm.h~mm-completely-abstract-unnecessary-adj_start-calculation
+++ a/include/linux/huge_mm.h
@@ -404,7 +404,7 @@ int madvise_collapse(struct vm_area_stru
 		     struct vm_area_struct **prev,
 		     unsigned long start, unsigned long end);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
-			   unsigned long end, long adjust_next);
+			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
 spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma);
 
@@ -571,7 +571,7 @@ static inline int madvise_collapse(struc
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
-					 long adjust_next)
+					 struct vm_area_struct *next)
 {
 }
 static inline int is_swap_pmd(pmd_t pmd)
--- a/mm/huge_memory.c~mm-completely-abstract-unnecessary-adj_start-calculation
+++ a/mm/huge_memory.c
@@ -3017,9 +3017,9 @@ static inline void split_huge_pmd_if_nee
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
-			     unsigned long start,
-			     unsigned long end,
-			     long adjust_next)
+			   unsigned long start,
+			   unsigned long end,
+			   struct vm_area_struct *next)
 {
 	/* Check if we need to split start first. */
 	split_huge_pmd_if_needed(vma, start);
@@ -3027,16 +3027,9 @@ void vma_adjust_trans_huge(struct vm_are
 	/* Check if we need to split end next. */
 	split_huge_pmd_if_needed(vma, end);
 
-	/*
-	 * If we're also updating the next vma vm_start,
-	 * check if we need to split it.
-	 */
-	if (adjust_next > 0) {
-		struct vm_area_struct *next = find_vma(vma->vm_mm, vma->vm_end);
-		unsigned long nstart = next->vm_start;
-		nstart += adjust_next;
-		split_huge_pmd_if_needed(next, nstart);
-	}
+	/* If we're incrementing next->vm_start, we might need to split it. */
+	if (next)
+		split_huge_pmd_if_needed(next, end);
 }
 
 static void unmap_folio(struct folio *folio)
--- a/mm/vma.c~mm-completely-abstract-unnecessary-adj_start-calculation
+++ a/mm/vma.c
@@ -513,7 +513,7 @@ __split_vma(struct vma_iterator *vmi, st
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
+	vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
 
 	if (new_below) {
 		vma->vm_start = addr;
@@ -644,46 +644,44 @@ void validate_mm(struct mm_struct *mm)
 #endif /* CONFIG_DEBUG_VM_MAPLE_TREE */
 
 /*
- * Actually perform the VMA merge operation.
- *
- * On success, returns the merged VMA. Otherwise returns NULL.
+ * Based on the vmg flag indicating whether we need to adjust the vm_start field
+ * for the middle or next VMA, we calculate what the range of the newly adjusted
+ * VMA ought to be, and set the VMA's range accordingly.
  */
-static struct vm_area_struct *commit_merge(struct vma_merge_struct *vmg)
+static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 {
-	struct vm_area_struct *vma;
-	struct vma_prepare vp;
 	struct vm_area_struct *adjust;
-	long adj_start;
+	pgoff_t pgoff;
 
-	/*
-	 * If modifying an existing VMA and we don't remove vmg->middle, then we
-	 * shrink the adjacent VMA.
-	 */
 	if (vmg->__adjust_middle_start) {
-		vma = vmg->target;
 		adjust = vmg->middle;
-		/* The POSITIVE value by which we offset vmg->middle->vm_start. */
-		adj_start = vmg->end - vmg->middle->vm_start;
-
-		 /* Note: vma iterator must be pointing to 'start'. */
-		vma_iter_config(vmg->vmi, vmg->start, vmg->end);
+		pgoff = adjust->vm_pgoff + PHYS_PFN(vmg->end - adjust->vm_start);
 	} else if (vmg->__adjust_next_start) {
-		/*
-		 * In this case alone, the VMA we manipulate is vmg->middle, but
-		 * we ultimately return vmg->next.
-		 */
-		vma = vmg->middle;
 		adjust = vmg->next;
-		/* The NEGATIVE value by which we offset vmg->next->vm_start. */
-		adj_start = -(vmg->middle->vm_end - vmg->end);
+		pgoff = adjust->vm_pgoff - PHYS_PFN(adjust->vm_start - vmg->end);
+	} else {
+		return;
+	}
+
+	vma_set_range(adjust, vmg->end, adjust->vm_end, pgoff);
+}
+
+/*
+ * Actually perform the VMA merge operation.
+ *
+ * Returns 0 on success, or an error value on failure.
+ */
+static int commit_merge(struct vma_merge_struct *vmg)
+{
+	struct vm_area_struct *vma;
+	struct vma_prepare vp;
 
-		vma_iter_config(vmg->vmi, vmg->next->vm_start + adj_start,
-				vmg->next->vm_end);
+	if (vmg->__adjust_next_start) {
+		/* We manipulate middle and adjust next, which is the target. */
+		vma = vmg->middle;
+		vma_iter_config(vmg->vmi, vmg->end, vmg->next->vm_end);
 	} else {
 		vma = vmg->target;
-		adjust = NULL;
-		adj_start = 0;
-
 		 /* Note: vma iterator must be pointing to 'start'. */
 		vma_iter_config(vmg->vmi, vmg->start, vmg->end);
 	}
@@ -691,22 +689,22 @@ static struct vm_area_struct *commit_mer
 	init_multi_vma_prep(&vp, vma, vmg);
 
 	if (vma_iter_prealloc(vmg->vmi, vma))
-		return NULL;
+		return -ENOMEM;
 
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, vmg->start, vmg->end, adj_start);
+	/*
+	 * THP pages may need to do additional splits if we increase
+	 * middle->vm_start.
+	 */
+	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
+			      vmg->__adjust_middle_start ? vmg->middle : NULL);
 	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
-
-	if (adj_start) {
-		adjust->vm_start += adj_start;
-		adjust->vm_pgoff += PHYS_PFN(adj_start);
-	}
-
+	vmg_adjust_set_range(vmg);
 	vma_iter_store(vmg->vmi, vmg->target);
 
 	vma_complete(&vp, vmg->vmi, vma->vm_mm);
 
-	return vmg->target;
+	return 0;
 }
 
 /* We can only remove VMAs when merging if they do not have a close hook. */
@@ -749,7 +747,7 @@ static __must_check struct vm_area_struc
 {
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
-	struct vm_area_struct *next, *res;
+	struct vm_area_struct *next;
 	struct vm_area_struct *anon_dup = NULL;
 	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
@@ -900,12 +898,7 @@ static __must_check struct vm_area_struc
 			vmg->end = next->vm_end;
 			vmg->pgoff = next->vm_pgoff - pglen;
 		} else {
-			/*
-			 * We shrink middle and expand next.
-			 *
-			 * IMPORTANT: This is the ONLY case where the final
-			 * merged VMA is NOT vmg->target, but rather vmg->next.
-			 */
+			/* We shrink middle and expand next. */
 			vmg->__adjust_next_start = true;
 			vmg->start = middle->vm_start;
 			vmg->end = start;
@@ -918,8 +911,10 @@ static __must_check struct vm_area_struc
 	if (err)
 		goto abort;
 
-	res = commit_merge(vmg);
-	if (!res) {
+	err = commit_merge(vmg);
+	if (err) {
+		VM_WARN_ON(err != -ENOMEM);
+
 		if (anon_dup)
 			unlink_anon_vmas(anon_dup);
 
@@ -927,9 +922,9 @@ static __must_check struct vm_area_struc
 		return NULL;
 	}
 
-	khugepaged_enter_vma(res, vmg->flags);
+	khugepaged_enter_vma(vmg->target, vmg->flags);
 	vmg->state = VMA_MERGE_SUCCESS;
-	return res;
+	return vmg->target;
 
 abort:
 	vma_iter_set(vmg->vmi, start);
@@ -1092,7 +1087,7 @@ int vma_expand(struct vma_merge_struct *
 	if (remove_next)
 		vmg->__remove_next = true;
 
-	if (!commit_merge(vmg))
+	if (commit_merge(vmg))
 		goto nomem;
 
 	return 0;
@@ -1132,7 +1127,7 @@ int vma_shrink(struct vma_iterator *vmi,
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, 0);
+	vma_adjust_trans_huge(vma, start, end, NULL);
 
 	vma_iter_clear(vmi);
 	vma_set_range(vma, start, end, pgoff);
--- a/tools/testing/vma/vma_internal.h~mm-completely-abstract-unnecessary-adj_start-calculation
+++ a/tools/testing/vma/vma_internal.h
@@ -796,12 +796,12 @@ static inline void vma_start_write(struc
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
-					 long adjust_next)
+					 struct vm_area_struct *next)
 {
 	(void)vma;
 	(void)start;
 	(void)end;
-	(void)adjust_next;
+	(void)next;
 }
 
 static inline void vma_iter_free(struct vma_iterator *vmi)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_page-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch

