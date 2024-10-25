Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C621312F
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 22:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729895575; cv=none; b=Ze6G0x/7yHG3R/WNF7RSVF2V+wcITqKYNhQLDTeOGVzkP0WAFRwJIsWvs5jYxjhpvLuBltR6O2WkOQ0i4khPkT2iLzn+j5cTMsbfO5YybPfamxrlu/GLy3cW3H6aAa0yvbno/QnEDnMGZbLCLtQ8CXeOuW4PoeuamqOUPkKojB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729895575; c=relaxed/simple;
	bh=24WDKEGK32yMe0APNyizBerf7QB15JIok9CZVhVIJ0k=;
	h=Date:To:From:Subject:Message-Id; b=Otr++PeECp6FzW06jLJLcBjSTjtHr5CocP0Qda8o8dCE1EJKcPLBMBMP4+lNvGeAi5F549g0iU6pbOQMHgK6JJNq1J26I51j+ZnqYJe6mytnXU4c9Q6wT2hRKOTMupLFHOKtTgg4IqiAu+jdqkDNjs6HbHQHRXM2oQ1S6lJvWDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X66B+x99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X66B+x99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BABC4CEE4;
	Fri, 25 Oct 2024 22:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729895575;
	bh=24WDKEGK32yMe0APNyizBerf7QB15JIok9CZVhVIJ0k=;
	h=Date:To:From:Subject:From;
	b=X66B+x99d/lNr3hucp7F2VHZgs0DOrPeNKtHkRGWw9GjTT69By8vOYmO9J3AXFmY3
	 yJ7egDBsGZiwQsRxeC7rqxPaRhhYX2V8apmlVKEfEz5T6ob5Upu0B1yfTvfAeG8Fk4
	 8zArWoFwJ6MrGBI4K9Pim4clS3hDJwBgMReKY5HM=
Date: Fri, 25 Oct 2024 15:32:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-defer-second-attempt-at-merge-on-mmap.patch added to mm-unstable branch
Message-Id: <20241025223255.31BABC4CEE4@smtp.kernel.org>
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
Date: Fri, 25 Oct 2024 13:26:27 +0100

Rather than trying to merge again when ostensibly allocating a new VMA,
instead defer until the VMA is added and attempt to merge the existing
range.

This way we have no complicated unwinding logic midway through the process
of mapping the VMA.

In addition this removes limitations on the VMA not being able to be the
first in the virtual memory address space which was previously implicitly
required.

In theory, for this very same reason, we should unconditionally attempt
merge here, however this is likely to have a performance impact so it is
better to avoid this given the unlikely outcome of a merge.

Link: https://lkml.kernel.org/r/d4f84502605d7651ac114587f507395c0fc76004.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   55 +++++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

--- a/mm/vma.c~mm-defer-second-attempt-at-merge-on-mmap
+++ a/mm/vma.c
@@ -19,6 +19,7 @@ struct mmap_state {
 	struct file *file;
 
 	unsigned long charged;
+	bool retry_merge;
 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *next;
@@ -2278,8 +2279,9 @@ static int __mmap_prepare(struct mmap_st
 	return 0;
 }
 
+
 static int __mmap_new_file_vma(struct mmap_state *map,
-			       struct vm_area_struct **vmap, bool *mergedp)
+			       struct vm_area_struct **vmap)
 {
 	struct vma_iterator *vmi = map->vmi;
 	struct vm_area_struct *vma = *vmap;
@@ -2308,37 +2310,10 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
-	/* mmap_file() might have changed VMA flags. */
+	/* If the flags change (and are mergeable), let's retry later. */
+	map->retry_merge = vma->vm_flags != map->flags && !(vma->vm_flags & VM_SPECIAL);
 	map->flags = vma->vm_flags;
 
-	vma_iter_config(vmi, map->addr, map->end);
-	/*
-	 * If flags changed after mmap_file(), we should try merge
-	 * vma again as we may succeed this time.
-	 */
-	if (unlikely(map->flags != vma->vm_flags && map->prev)) {
-		struct vm_area_struct *merge;
-		VMG_MMAP_STATE(vmg, map, /* vma = */ NULL);
-
-		merge = vma_merge_new_range(&vmg);
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
-
-	*vmap = vma;
 	return 0;
 }
 
@@ -2346,10 +2321,6 @@ static int __mmap_new_file_vma(struct mm
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
  *
- * An exception to this is if the mapping is file-backed, and the underlying
- * driver changes the VMA flags, permitting a subsequent merge of the VMA, in
- * which case the returned VMA is one that was merged on a second attempt.
- *
  * @map:  Mapping state.
  * @vmap: Output pointer for the new VMA.
  *
@@ -2359,7 +2330,6 @@ static int __mmap_new_vma(struct mmap_st
 {
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
-	bool merged = false;
 	struct vm_area_struct *vma;
 
 	/*
@@ -2382,7 +2352,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	if (map->file)
-		error = __mmap_new_file_vma(map, &vma, &merged);
+		error = __mmap_new_file_vma(map, &vma);
 	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
 	else
@@ -2391,9 +2361,6 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
-	if (merged)
-		goto file_expanded;
-
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
@@ -2410,8 +2377,6 @@ static int __mmap_new_vma(struct mmap_st
 	 * call covers the non-merge case.
 	 */
 	khugepaged_enter_vma(vma, map->flags);
-
-file_expanded:
 	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
@@ -2493,6 +2458,14 @@ unsigned long __mmap_region(struct file
 			goto unacct_error;
 	}
 
+	/* If flags changed, we might be able to merge, so try again. */
+	if (map.retry_merge) {
+		VMG_MMAP_STATE(vmg, &map, vma);
+
+		vma_iter_config(map.vmi, map.addr, map.end);
+		vma_merge_existing_range(&vmg);
+	}
+
 	__mmap_complete(&map, vma);
 
 	return addr;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

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
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

