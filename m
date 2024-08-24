Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CBF257D
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 06:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724480532; cv=none; b=lgn8mfRHKUBR1v4k1VvA6qyQdSEUhfnPe+m2TBsK/bJntdL+T0WYE0IpOzQriToch2SHDacpL1XA2ADvDaOtuthE8DfD6VsIhBbJAYsquRR7Tr3PBIBeIe/QeOOJpWPl7/njhT4Tmwu5gTyEe6+BAPaWldVOrs+bZMVGzlNYfIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724480532; c=relaxed/simple;
	bh=pEPOH7hgaqksY4K/xTXabk0J7ZyIZYfKDU/vCKGHJQ8=;
	h=Date:To:From:Subject:Message-Id; b=osP+lN1wZGkGvpn8I/Gmbm1790cis6fWJFgVRZoHXGvyWo9J6KZd3Vl+O5b518VqPnc1w3YbNcc5zcWvaOayP5fa1I20ExDoKxY2+f7Emtqdz9/cTPcjCeHCOajU8dBa6cNyI50SrzC3WN/qoF+YkGAjQmOEdMhoe9/xUm3UTQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p5FRb4eN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p5FRb4eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8F5C32781;
	Sat, 24 Aug 2024 06:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724480532;
	bh=pEPOH7hgaqksY4K/xTXabk0J7ZyIZYfKDU/vCKGHJQ8=;
	h=Date:To:From:Subject:From;
	b=p5FRb4eNIPuxYE5PuWuyg25NnHPRTh4HNC/J4sUhx774MdJQGaSaRhGUS5SnEteB3
	 iJp83ebIY0bKq+AAhMiTMOBtjoA6UWFRNdxhD251joH5S7GP3eUZBsfHW+QG+GXmZz
	 9SN3qPsMYBQtYK5wJvoNGlaaz/RhF3qZdd3LR3QI=
Date: Fri, 23 Aug 2024 23:22:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-vma_expand-to-use-vma_merge_struct.patch added to mm-unstable branch
Message-Id: <20240824062211.EC8F5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: abstract vma_expand() to use vma_merge_struct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-vma_expand-to-use-vma_merge_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-vma_expand-to-use-vma_merge_struct.patch

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
Subject: mm: abstract vma_expand() to use vma_merge_struct
Date: Fri, 23 Aug 2024 21:07:00 +0100

The purpose of the vmg is to thread merge state through functions and avoid
egregious parameter lists. We expand this to vma_expand(), which is used
for a number of merge cases.

Accordingly, adjust its callers, mmap_region() and relocate_vma_down(), to
use a vmg.

An added purpose of this change is the ability in a future commit to
perform all new VMA range merging using vma_expand().

Link: https://lkml.kernel.org/r/0cc0e4d1af6722b3b0d121647089659bd8060087.1724441678.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c               |   16 ++++++++-------
 mm/vma.c                |   39 ++++++++++++++++----------------------
 mm/vma.h                |    5 ----
 tools/testing/vma/vma.c |    3 --
 4 files changed, 28 insertions(+), 35 deletions(-)

--- a/mm/mmap.c~mm-abstract-vma_expand-to-use-vma_merge_struct
+++ a/mm/mmap.c
@@ -1371,7 +1371,6 @@ unsigned long mmap_region(struct file *f
 	struct ma_state mas_detach;
 	struct maple_tree mt_detach;
 	unsigned long end = addr + len;
-	unsigned long merge_start = addr, merge_end = end;
 	bool writable_file_mapping = false;
 	int error = -ENOMEM;
 	VMA_ITERATOR(vmi, mm, addr);
@@ -1424,8 +1423,8 @@ unsigned long mmap_region(struct file *f
 	/* Attempt to expand an old mapping */
 	/* Check next */
 	if (next && next->vm_start == end && can_vma_merge_before(&vmg)) {
-		merge_end = next->vm_end;
-		vma = next;
+		vmg.end = next->vm_end;
+		vma = vmg.vma = next;
 		vmg.pgoff = next->vm_pgoff - pglen;
 		/*
 		 * We set this here so if we will merge with the previous VMA in
@@ -1438,15 +1437,15 @@ unsigned long mmap_region(struct file *f
 
 	/* Check prev */
 	if (prev && prev->vm_end == addr && can_vma_merge_after(&vmg)) {
-		merge_start = prev->vm_start;
-		vma = prev;
+		vmg.start = prev->vm_start;
+		vma = vmg.vma = prev;
 		vmg.pgoff = prev->vm_pgoff;
 		vma_prev(&vmi); /* Equivalent to going to the previous range */
 	}
 
 	if (vma) {
 		/* Actually expand, if possible */
-		if (!vma_expand(&vmi, vma, merge_start, merge_end, vmg.pgoff, next)) {
+		if (!vma_expand(&vmg)) {
 			khugepaged_enter_vma(vma, vm_flags);
 			goto expanded;
 		}
@@ -2319,6 +2318,7 @@ int relocate_vma_down(struct vm_area_str
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
 	VMA_ITERATOR(vmi, mm, new_start);
+	VMG_STATE(vmg, mm, &vmi, new_start, old_end, 0, vma->vm_pgoff);
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 
@@ -2335,7 +2335,8 @@ int relocate_vma_down(struct vm_area_str
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_expand(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
+	vmg.vma = vma;
+	if (vma_expand(&vmg))
 		return -ENOMEM;
 
 	/*
@@ -2368,6 +2369,7 @@ int relocate_vma_down(struct vm_area_str
 	tlb_finish_mmu(&tlb);
 
 	vma_prev(&vmi);
+
 	/* Shrink the vma to just the new range */
 	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
 }
--- a/mm/vma.c~mm-abstract-vma_expand-to-use-vma_merge_struct
+++ a/mm/vma.c
@@ -467,30 +467,25 @@ void validate_mm(struct mm_struct *mm)
 /*
  * vma_expand - Expand an existing VMA
  *
- * @vmi: The vma iterator
- * @vma: The vma to expand
- * @start: The start of the vma
- * @end: The exclusive end of the vma
- * @pgoff: The page offset of vma
- * @next: The current of next vma.
+ * @vmg: Describes a VMA expansion operation.
  *
- * Expand @vma to @start and @end.  Can expand off the start and end.  Will
- * expand over @next if it's different from @vma and @end == @next->vm_end.
- * Checking if the @vma can expand and merge with @next needs to be handled by
- * the caller.
+ * Expand @vma to vmg->start and vmg->end.  Can expand off the start and end.
+ * Will expand over vmg->next if it's different from vmg->vma and vmg->end ==
+ * vmg->next->vm_end.  Checking if the vmg->vma can expand and merge with
+ * vmg->next needs to be handled by the caller.
  *
  * Returns: 0 on success
  */
-int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff,
-	       struct vm_area_struct *next)
+int vma_expand(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *anon_dup = NULL;
 	bool remove_next = false;
+	struct vm_area_struct *vma = vmg->vma;
+	struct vm_area_struct *next = vmg->next;
 	struct vma_prepare vp;
 
 	vma_start_write(vma);
-	if (next && (vma != next) && (end == next->vm_end)) {
+	if (next && (vma != next) && (vmg->end == next->vm_end)) {
 		int ret;
 
 		remove_next = true;
@@ -503,21 +498,21 @@ int vma_expand(struct vma_iterator *vmi,
 	init_multi_vma_prep(&vp, vma, NULL, remove_next ? next : NULL, NULL);
 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON(next && !vp.remove &&
-		  next != vma && end > next->vm_start);
+		  next != vma && vmg->end > next->vm_start);
 	/* Only handles expanding */
-	VM_WARN_ON(vma->vm_start < start || vma->vm_end > end);
+	VM_WARN_ON(vma->vm_start < vmg->start || vma->vm_end > vmg->end);
 
 	/* Note: vma iterator must be pointing to 'start' */
-	vma_iter_config(vmi, start, end);
-	if (vma_iter_prealloc(vmi, vma))
+	vma_iter_config(vmg->vmi, vmg->start, vmg->end);
+	if (vma_iter_prealloc(vmg->vmi, vma))
 		goto nomem;
 
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, 0);
-	vma_set_range(vma, start, end, pgoff);
-	vma_iter_store(vmi, vma);
+	vma_adjust_trans_huge(vma, vmg->start, vmg->end, 0);
+	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
+	vma_iter_store(vmg->vmi, vma);
 
-	vma_complete(&vp, vmi, vma->vm_mm);
+	vma_complete(&vp, vmg->vmi, vma->vm_mm);
 	return 0;
 
 nomem:
--- a/mm/vma.h~mm-abstract-vma_expand-to-use-vma_merge_struct
+++ a/mm/vma.h
@@ -128,10 +128,7 @@ void init_vma_prep(struct vma_prepare *v
 void vma_complete(struct vma_prepare *vp,
 		  struct vma_iterator *vmi, struct mm_struct *mm);
 
-int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff,
-	       struct vm_area_struct *next);
-
+int vma_expand(struct vma_merge_struct *vmg);
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
 
--- a/tools/testing/vma/vma.c~mm-abstract-vma_expand-to-use-vma_merge_struct
+++ a/tools/testing/vma/vma.c
@@ -121,8 +121,7 @@ static struct vm_area_struct *merge_exis
  */
 static int expand_existing(struct vma_merge_struct *vmg)
 {
-	return vma_expand(vmg->vmi, vmg->vma, vmg->start, vmg->end, vmg->pgoff,
-			  vmg->next);
+	return vma_expand(vmg);
 }
 
 /*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

