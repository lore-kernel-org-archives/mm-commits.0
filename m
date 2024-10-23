Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3E2003DB
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 22:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729723476; cv=none; b=dF9Sx+iTh+qQGwvTV1njhbsA/EsxD+xKlZsg5x5DaHSaWMCG+b2X5PjEunB1+J19/iqx3ZgagBinKstVg7Goniacosl/nH+Kg3dEjcit+jcrrDtHukhQ/saCm4ezDbkOJ0FHHkJ6zm4p0qMvKPoW2jHYAEsdkJOFzR8Za71TgiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729723476; c=relaxed/simple;
	bh=DbgGB15XdkhgGLQ7TEpdc29v3eEwdlv2e+365XwT2jU=;
	h=Date:To:From:Subject:Message-Id; b=TEJVK3milS1s6hrdYtQ8yR7ztc96JIcFWJYPZr9h4YGOqF9vKSqQovEEpNFI8ZUClQGh6bPfQbH2yCkOeVXfKLb3j1XQ9n2H1jbRi3F37ur93Ag/7jb9dw1C+XBdtLkWmM/I7dxpR+GjJflbQr7dNzENO0yg38Zc9NVC9H3JdbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZInXFVJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZInXFVJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1590C4CEC6;
	Wed, 23 Oct 2024 22:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729723476;
	bh=DbgGB15XdkhgGLQ7TEpdc29v3eEwdlv2e+365XwT2jU=;
	h=Date:To:From:Subject:From;
	b=ZInXFVJ+FW6gz5Xef1h6rauHlS8/WHkuPBeeCaCrPtmpxIFwDBH2PJKFRDXTDqQDh
	 6/tRv1RKzeMcXq6EYzxwIgKZumDR9lc0XnSazM21YmXSTC31DMiBIe5tW0J1sqDCKg
	 sp6fVPcpr/1nzrUXrA6ywZ/akGAKQkb501s5NGsE=
Date: Wed, 23 Oct 2024 15:44:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-defer-second-attempt-at-merge-on-mmap.patch added to mm-unstable branch
Message-Id: <20241023224435.F1590C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: defer second attempt at merge on mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-defer-second-attempt-at-merge-on-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-defer-second-attempt-at-merge-on-mmap.patch

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
Subject: mm: defer second attempt at merge on mmap()
Date: Wed, 23 Oct 2024 21:38:33 +0100

Rather than trying to merge again when ostensibly allocating a new VMA,
instead defer until the VMA is added and attempt to merge the existing
range.

This way we have no complicated unwinding logic midway through the process
of mapping the VMA.

In addition this removes limitations on the VMA not being able to be the
first in the virtual memory address space which was previously implicitly
required.

It also performs this merge after the final flag adjustments are
performed, something that was not done previously and thus might have
prevented possibly valid merges in the past.

In theory, for this very same reason, we should unconditionally attempt
merge here, however this is likely to have a performance impact so it is
better to avoid this given the unlikely outcome of a merge.

The vmg state will already have been reset by the first attempt at a merge
so we only need to reset the iterator, set the vma and flags and try
again.

Link: https://lkml.kernel.org/r/e063d9d31a4dbd83c2d77a3f1e0114e6a0788724.1729715266.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   75 ++++++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 49 deletions(-)

--- a/mm/vma.c~mm-defer-second-attempt-at-merge-on-mmap
+++ a/mm/vma.c
@@ -19,6 +19,7 @@ struct mmap_state {
 	struct file *file;
 
 	unsigned long charged;
+	bool retry_merge;
 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *next;
@@ -2280,9 +2281,9 @@ static int __mmap_prepare(struct mmap_st
 	return 0;
 }
 
+
 static int __mmap_new_file_vma(struct mmap_state *map,
-			       struct vma_merge_struct *vmg,
-			       struct vm_area_struct **vmap, bool *mergedp)
+			       struct vm_area_struct **vmap)
 {
 	struct vma_iterator *vmi = map->vmi;
 	struct vm_area_struct *vma = *vmap;
@@ -2311,37 +2312,11 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
-	vma_iter_config(vmi, map->addr, map->end);
-	/*
-	 * If flags changed after mmap_file(), we should try merge
-	 * vma again as we may succeed this time.
-	 */
-	if (unlikely(map->flags != vma->vm_flags && map->prev)) {
-		struct vm_area_struct *merge;
-
-		vmg->flags = vma->vm_flags;
-		/* If this fails, state is reset ready for a reattempt. */
-		merge = vma_merge_new_range(vmg);
-
-		if (merge) {
-			/*
-			 * ->mmap() can change vma->vm_file and fput
-			 * the original file. So fput the vma->vm_file
-			 * here or we would add an extra fput for file
-			 * and cause general protection fault
-			 * ultimately.
-			 */
-			fput(vma->vm_file);
-			vm_area_free(vma);
-			vma = merge;
-			*mergedp = true;
-		} else {
-			vma_iter_config(vmi, map->addr, map->end);
-		}
-	}
+	/* If the flags change (and are mergeable), let's retry later. */
+	map->retry_merge = vma->vm_flags != map->flags && !(vma->vm_flags & VM_SPECIAL);
 
+	vma_iter_config(vmi, map->addr, map->end);
 	map->flags = vma->vm_flags;
-	*vmap = vma;
 	return 0;
 }
 
@@ -2349,22 +2324,15 @@ static int __mmap_new_file_vma(struct mm
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
  *
- * An exception to this is if the mapping is file-backed, and the underlying
- * driver changes the VMA flags, permitting a subsequent merge of the VMA, in
- * which case the returned VMA is one that was merged on a second attempt.
- *
  * @map:  Mapping state.
- * @vmg:  VMA merge state.
  * @vmap: Output pointer for the new VMA.
  *
  * Returns: Zero on success, or an error.
  */
-static int __mmap_new_vma(struct mmap_state *map, struct vma_merge_struct *vmg,
-			  struct vm_area_struct **vmap)
+static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 {
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
-	bool merged = false;
 	struct vm_area_struct *vma;
 
 	/*
@@ -2387,7 +2355,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	if (map->file)
-		error = __mmap_new_file_vma(map, vmg, &vma, &merged);
+		error = __mmap_new_file_vma(map, &vma);
 	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
 	else
@@ -2396,9 +2364,6 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
-	if (merged)
-		goto file_expanded;
-
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
@@ -2415,8 +2380,6 @@ static int __mmap_new_vma(struct mmap_st
 	 * call covers the non-merge case.
 	 */
 	khugepaged_enter_vma(vma, map->flags);
-
-file_expanded:
 	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
@@ -2430,13 +2393,17 @@ free_vma:
 
 /*
  * __mmap_complete() - Unmap any VMAs we overlap, account memory mapping
- *                     statistics, handle locking and finalise the VMA.
+ *                     statistics, handle locking and finalise the VMA,
+ *                     attempt a final merge if required.
  *
  * @map: Mapping state.
  * @vma: Merged or newly allocated VMA for the mmap()'d region.
+ * @vmg: VMA merge state.
  */
-static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
+static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma,
+			    struct vma_merge_struct *vmg)
 {
+
 	struct mm_struct *mm = map->mm;
 	unsigned long vm_flags = vma->vm_flags;
 
@@ -2468,6 +2435,16 @@ static void __mmap_complete(struct mmap_
 	vm_flags_set(vma, VM_SOFTDIRTY);
 
 	vma_set_page_prot(vma);
+
+	/* OK VMA flags changed in __mmap_new_vma(), try a merge again. */
+	if (map->retry_merge) {
+		vma_iter_config(map->vmi, map->addr, map->end);
+		vmg->vma = vma;
+		vmg->flags = map->flags;
+		vmg->next = NULL; /* Must be set by merge logic. */
+
+		vma_merge_existing_range(vmg);
+	}
 }
 
 unsigned long __mmap_region(struct file *file, unsigned long addr,
@@ -2490,12 +2467,12 @@ unsigned long __mmap_region(struct file
 	vma = vma_merge_new_range(&vmg);
 	if (!vma) {
 		/* ...but if we can't, allocate a new VMA. */
-		error = __mmap_new_vma(&map, &vmg, &vma);
+		error = __mmap_new_vma(&map, &vma);
 		if (error)
 			goto unacct_error;
 	}
 
-	__mmap_complete(&map, vma);
+	__mmap_complete(&map, vma, &vmg);
 
 	return addr;
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-defer-second-attempt-at-merge-on-mmap.patch

