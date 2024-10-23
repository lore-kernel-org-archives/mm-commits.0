Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BA919E7F9
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 10:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678925; cv=none; b=RmK7glxwnMjjQOexH6lLXEthzj5CDVz/BGd7Bu9hkkL0I9uFQSPVZSfB/iWbyODOV+KF6RfcJ4wQkKK7IQyPkW9Ha9/jTl5vPL5J1cGVv7LR4qCd0vyFTGbBku7sdu21bzNNRR2hLMqSNUZVSYh+2/H+i5TUb0GzU05m7gnXuFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678925; c=relaxed/simple;
	bh=CmTV/NMT62nHLx+UJQjN62e74yCZSb1v5QqaKQ9HAsU=;
	h=Date:To:From:Subject:Message-Id; b=Q3votisTtwrUyelzDMrvDnYuttdbam3upAYzITScCOHpBVxlqx2lHK381JPpWB9ugc4o4w26JVpqeBDSajLr50Vs47waFs3gHLgp2TkdmwZN3VRVp2r+PR9Yy0Y8LQO3VxcXFctcYPu1k3Gfh27r5yzxDKWcFb8e9QFIRoOmga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DgtNoxgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DgtNoxgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36818C4CEC6;
	Wed, 23 Oct 2024 10:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729678925;
	bh=CmTV/NMT62nHLx+UJQjN62e74yCZSb1v5QqaKQ9HAsU=;
	h=Date:To:From:Subject:From;
	b=DgtNoxgghr5xrATDeqKS7EwIpALeiYAE3daCnyZnI6G8eeuJQhJ0g7APvkXTSNtbW
	 mC7pMiUqxh5rF7fna3DAHsuVlyQwgLLCvjJlAbZTyPBFnOP0uSW67Otkp6U6QtF5tA
	 mdXniMSYHW4HHKSJdwoCjScVVUYLHZTAuDIo36gw=
Date: Wed, 23 Oct 2024 03:22:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@kernel.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-attempt-second-merge-for-file-backed-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023102205.36818C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not attempt second merge for file-backed VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-do-not-attempt-second-merge-for-file-backed-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-attempt-second-merge-for-file-backed-vmas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: do not attempt second merge for file-backed VMAs
Date: Tue, 22 Oct 2024 21:40:59 +0100

Previously, we'd always try to merge a file-backed VMA if its flags were
changed by the driver.

This however is rarely meaningful as typically the flags would be changed
to VM_PFNMAP or other VM_SPECIAL flags which are inherently unmergable.

In cases where it is meaningful (for instance DAX) it is doubtful that this
optimisation is worth the effort and maintenance risk of having to unwind
state and perform a merge.

Since we've observed bugs and resource leaks due to complexity in this
area, it is simply not acceptable to have a 'nice to have' optimisation
like this complicating an already very complicated code path, so let's
simply eliminate it.

Link: https://lkml.kernel.org/r/7b6bf6165080505feb5e00b313d2c84c25015e45.1729628198.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   39 ++-------------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

--- a/mm/vma.c~mm-do-not-attempt-second-merge-for-file-backed-vmas
+++ a/mm/vma.c
@@ -2260,8 +2260,7 @@ static int __mmap_prepare(struct mmap_st
 	return 0;
 }
 
-static int __mmap_new_file_vma(struct mmap_state *map, struct vm_area_struct *vma,
-			       struct vm_area_struct **mergep)
+static int __mmap_new_file_vma(struct mmap_state *map, struct vm_area_struct *vma)
 {
 	struct vma_iterator *vmi = map->vmi;
 	struct vma_merge_struct *vmg = map->vmg;
@@ -2291,34 +2290,6 @@ static int __mmap_new_file_vma(struct mm
 			(vma->vm_flags & VM_MAYWRITE));
 
 	vma_iter_config(vmi, vmg->start, vmg->end);
-	/*
-	 * If flags changed after mmap_file(), we should try merge
-	 * vma again as we may succeed this time.
-	 */
-	if (unlikely(map->flags != vma->vm_flags && vmg->prev)) {
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
-			vma_iter_free(vmi);
-			*mergep = merge;
-		} else {
-			vma_iter_config(vmi, vmg->start, vmg->end);
-		}
-	}
-
 	map->flags = vma->vm_flags;
 	return 0;
 }
@@ -2341,7 +2312,6 @@ static int __mmap_new_vma(struct mmap_st
 {
 	struct vma_iterator *vmi = map->vmi;
 	struct vma_merge_struct *vmg = map->vmg;
-	struct vm_area_struct *merge = NULL;
 	int error = 0;
 	struct vm_area_struct *vma;
 
@@ -2365,7 +2335,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	if (vmg->file)
-		error = __mmap_new_file_vma(map, vma, &merge);
+		error = __mmap_new_file_vma(map, vma);
 	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
 	else
@@ -2374,9 +2344,6 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
-	if (merge)
-		goto file_expanded;
-
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
@@ -2393,8 +2360,6 @@ static int __mmap_new_vma(struct mmap_st
 	 * call covers the non-merge case.
 	 */
 	khugepaged_enter_vma(vma, map->flags);
-
-file_expanded:
 	ksm_add_vma(vma);
 
 	*vmap = vma;
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
tools-testing-add-additional-vma_internalh-stubs.patch
mm-insolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-do-not-attempt-second-merge-for-file-backed-vmas.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

