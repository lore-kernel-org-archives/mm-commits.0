Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A186D7E0FF
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423585; cv=none; b=Jw/DUB43MdrtkgwB76dxL8CjYlKtTYfGjvApL2Z6WJpkVG96BAgtL6gRGxVLiNFENG0FUajRTxtIqhXI5uynXREeCLTg/e8xEvf8KR5wvL+hVSNDsW6PSLAZcYyjMG0pJ7+4PnzjEAjyqUeDZ3EMRnIeREyOp+NoQNtijLd7lhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423585; c=relaxed/simple;
	bh=R4rQTUCSa/rDFYv9jvPt/KLM1aCo2yafenHSRCNNbWI=;
	h=Date:To:From:Subject:Message-Id; b=aeuj0jroYVHs2lPUYVckc+2+rISCbugQTIFcb6xrnkGg7bNBRksBwY4+TKRt0rjo3+t1/QbxpXxG4SqIce+SvZ6fEX/3cbXrO/4hrk1s8dowffdYXib2AMGII+9bUwow32m3t6zIR68pFi/ysSDph6YmglNwJ/pkaa98jjuXzWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WD6+jJlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WD6+jJlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DC9C4CEC2;
	Wed,  4 Sep 2024 04:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423585;
	bh=R4rQTUCSa/rDFYv9jvPt/KLM1aCo2yafenHSRCNNbWI=;
	h=Date:To:From:Subject:From;
	b=WD6+jJlBsLbBetL41f4mis4IYVROFY7TAHCgXqp09b+A1aItN9g4cziDmK6y//594
	 H/DFFzXkLOV8U26PjAZ2+kcFFjSKnXZx0mgqd1ZSuoo02pZPn5iQfczh8x+GMlH7Zu
	 OPzarNI2VlaGa+S64a6TKCajdGp3cjswoB8Bd7vQ=
Date: Tue, 03 Sep 2024 21:19:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-abstract-vma_expand-to-use-vma_merge_struct.patch removed from -mm tree
Message-Id: <20240904041945.75DC9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: abstract vma_expand() to use vma_merge_struct
has been removed from the -mm tree.  Its filename was
     mm-abstract-vma_expand-to-use-vma_merge_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: abstract vma_expand() to use vma_merge_struct
Date: Fri, 30 Aug 2024 19:10:17 +0100

The purpose of the vmg is to thread merge state through functions and
avoid egregious parameter lists.  We expand this to vma_expand(), which is
used for a number of merge cases.

Accordingly, adjust its callers, mmap_region() and relocate_vma_down(), to
use a vmg.

An added purpose of this change is the ability in a future commit to
perform all new VMA range merging using vma_expand().

Link: https://lkml.kernel.org/r/4bc8c9dbc9ca52452ef8e587b28fe555854ceb38.1725040657.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c               |   15 +++++++-------
 mm/vma.c                |   39 ++++++++++++++++----------------------
 mm/vma.h                |    5 ----
 tools/testing/vma/vma.c |    3 --
 4 files changed, 27 insertions(+), 35 deletions(-)

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
@@ -2320,6 +2319,7 @@ int relocate_vma_down(struct vm_area_str
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
 	VMA_ITERATOR(vmi, mm, new_start);
+	VMG_STATE(vmg, mm, &vmi, new_start, old_end, 0, vma->vm_pgoff);
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 
@@ -2336,7 +2336,8 @@ int relocate_vma_down(struct vm_area_str
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_expand(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
+	vmg.vma = vma;
+	if (vma_expand(&vmg))
 		return -ENOMEM;
 
 	/*
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


