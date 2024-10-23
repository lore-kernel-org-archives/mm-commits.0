Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9623A15F330
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678915; cv=none; b=epghSqlQePXtUDYA/ezH+v9WlKE4H4Lb2hErXH8RsjaBlSX0unyb9tbYkLWtF7RBdvGjd/rSVqCIytP/JsNLUYJFehYvWApisnuoPUQkddu/2iJIFYD8vsI+VHh/fKGMqFGyaIQxVcxMS56+gOubYHRo51ILianJUeajocDgZ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678915; c=relaxed/simple;
	bh=zHsGyomEKJwPAyUQzYGpC0LoRwguceTZJL2YJxn0aCE=;
	h=Date:To:From:Subject:Message-Id; b=otFtyAUckPr21IVRUF+9SOOM2LpJmAwqUU71YYH97/3sxbcVPIPbROvxDO6plWHrao3HxEGLoyHPmBfDNQd4zE5rutZBY/nr4330qfgu1Wg3xYw1bFcjKdlAlFi3IxG25EWB360wLs3KnTcN/kjlVzNgPIvkTjNzGX5J6Y8bCM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jYE69qkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jYE69qkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FD6C4CEC6;
	Wed, 23 Oct 2024 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729678915;
	bh=zHsGyomEKJwPAyUQzYGpC0LoRwguceTZJL2YJxn0aCE=;
	h=Date:To:From:Subject:From;
	b=jYE69qkhVp/jyMnmS6yw2BMLrx/ejpry5HnxycfmiQry9L8mlrxGPSIiq4wn6U6Nc
	 v8lM992aaz+QyR6psqrUXBOpC8pn5MXvpl9MqQ6LWsa4aGugqY30j23A/oFJhsrd2v
	 ixKaASmIyKk6AA18uImO1GNX7fh0uq4ptO4qKg1s=
Date: Wed, 23 Oct 2024 03:21:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@kernel.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-resolve-faulty-mmap_region-error-path-behaviour.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023102155.23FD6C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: resolve faulty mmap_region() error path behaviour
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-resolve-faulty-mmap_region-error-path-behaviour.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-resolve-faulty-mmap_region-error-path-behaviour.patch

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
Subject: mm: resolve faulty mmap_region() error path behaviour
Date: Tue, 22 Oct 2024 21:40:55 +0100

The mmap_region() function is somewhat terrifying, with spaghetti-like
control flow and numerous means by which issues can arise and incomplete
state, memory leaks and other unpleasantness can occur.

A large amount of the complexity arises from trying to handle errors late
in the process of mapping a VMA, which forms the basis of recently
observed issues with resource leaks and observable inconsistent state.

Taking advantage of previous patches in this series we move a number of
checks earlier in the code, simplifying things by moving the core of the
logic into a static internal function __mmap_region().

Doing this allows us to perform a number of checks up front before we do
any real work, and allows us to unwind the writable unmap check
unconditionally as required and to perform a CONFIG_DEBUG_VM_MAPLE_TREE
validation unconditionally also.

We move a number of things here:

1. We preallocate memory for the iterator before we call the file-backed
   memory hook, allowing us to exit early and avoid having to perform
   complicated and error-prone close/free logic. We carefully free
   iterator state on both success and error paths.

2. The enclosing mmap_region() function handles the mapping_map_writable()
   logic early. Previously the logic had the mapping_map_writable() at the
   point of mapping a newly allocated file-backed VMA, and a matching
   mapping_unmap_writable() on success and error paths.

   We now do this unconditionally if this is a file-backed, shared writable
   mapping. If a driver changes the flags to eliminate VM_MAYWRITE, however
   doing so does not invalidate the seal check we just performed, and we in
   any case always decrement the counter in the wrapper.

   We perform a debug assert to ensure a driver does not attempt to do the
   opposite.

3. We also move arch_validate_flags() up into the mmap_region()
   function. This is only relevant on arm64 and sparc64, and the check is
   only meaningful for SPARC with ADI enabled. We explicitly add a warning
   for this arch if a driver invalidates this check, though the code ought
   eventually to be fixed to eliminate the need for this.

With all of these measures in place, we no longer need to explicitly close
the VMA on error paths, as we place all checks which might fail prior to a
call to any driver mmap hook.

This eliminates an entire class of errors, makes the code easier to reason
about and more robust.

Link: https://lkml.kernel.org/r/3bc3ef7520eed73472f7ffdce044f2e94f809b32.1729628198.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: <stable@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |  122 ++++++++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 55 deletions(-)

--- a/mm/mmap.c~mm-resolve-faulty-mmap_region-error-path-behaviour
+++ a/mm/mmap.c
@@ -1357,20 +1357,18 @@ int do_munmap(struct mm_struct *mm, unsi
 	return do_vmi_munmap(&vmi, mm, start, len, uf, false);
 }
 
-unsigned long mmap_region(struct file *file, unsigned long addr,
+static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
 		struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	pgoff_t pglen = PHYS_PFN(len);
-	struct vm_area_struct *merge;
 	unsigned long charged = 0;
 	struct vma_munmap_struct vms;
 	struct ma_state mas_detach;
 	struct maple_tree mt_detach;
 	unsigned long end = addr + len;
-	bool writable_file_mapping = false;
 	int error;
 	VMA_ITERATOR(vmi, mm, addr);
 	VMG_STATE(vmg, mm, &vmi, addr, end, vm_flags, pgoff);
@@ -1444,28 +1442,26 @@ unsigned long mmap_region(struct file *f
 	vm_flags_init(vma, vm_flags);
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 
+	if (vma_iter_prealloc(&vmi, vma)) {
+		error = -ENOMEM;
+		goto free_vma;
+	}
+
 	if (file) {
 		vma->vm_file = get_file(file);
 		error = mmap_file(file, vma);
 		if (error)
-			goto unmap_and_free_vma;
-
-		if (vma_is_shared_maywrite(vma)) {
-			error = mapping_map_writable(file->f_mapping);
-			if (error)
-				goto close_and_free_vma;
-
-			writable_file_mapping = true;
-		}
+			goto unmap_and_free_file_vma;
 
+		/* Drivers cannot alter the address of the VMA. */
+		WARN_ON_ONCE(addr != vma->vm_start);
 		/*
-		 * Expansion is handled above, merging is handled below.
-		 * Drivers should not alter the address of the VMA.
+		 * Drivers should not permit writability when previously it was
+		 * disallowed.
 		 */
-		if (WARN_ON((addr != vma->vm_start))) {
-			error = -EINVAL;
-			goto close_and_free_vma;
-		}
+		VM_WARN_ON_ONCE(vm_flags != vma->vm_flags &&
+				!(vm_flags & VM_MAYWRITE) &&
+				(vma->vm_flags & VM_MAYWRITE));
 
 		vma_iter_config(&vmi, addr, end);
 		/*
@@ -1473,6 +1469,8 @@ unsigned long mmap_region(struct file *f
 		 * vma again as we may succeed this time.
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && vmg.prev)) {
+			struct vm_area_struct *merge;
+
 			vmg.flags = vma->vm_flags;
 			/* If this fails, state is reset ready for a reattempt. */
 			merge = vma_merge_new_range(&vmg);
@@ -1487,10 +1485,11 @@ unsigned long mmap_region(struct file *f
 				 */
 				fput(vma->vm_file);
 				vm_area_free(vma);
+				vma_iter_free(&vmi);
 				vma = merge;
 				/* Update vm_flags to pick up the change. */
 				vm_flags = vma->vm_flags;
-				goto unmap_writable;
+				goto file_expanded;
 			}
 			vma_iter_config(&vmi, addr, end);
 		}
@@ -1499,26 +1498,15 @@ unsigned long mmap_region(struct file *f
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
-			goto free_vma;
+			goto free_iter_vma;
 	} else {
 		vma_set_anonymous(vma);
 	}
 
-	if (map_deny_write_exec(vma->vm_flags, vma->vm_flags)) {
-		error = -EACCES;
-		goto close_and_free_vma;
-	}
-
-	/* Allow architectures to sanity-check the vm_flags */
-	if (!arch_validate_flags(vma->vm_flags)) {
-		error = -EINVAL;
-		goto close_and_free_vma;
-	}
-
-	if (vma_iter_prealloc(&vmi, vma)) {
-		error = -ENOMEM;
-		goto close_and_free_vma;
-	}
+#ifdef CONFIG_SPARC64
+	/* TODO: Fix SPARC ADI! */
+	WARN_ON_ONCE(!arch_validate_flags(vm_flags));
+#endif
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
@@ -1532,10 +1520,7 @@ unsigned long mmap_region(struct file *f
 	 */
 	khugepaged_enter_vma(vma, vma->vm_flags);
 
-	/* Once vma denies write, undo our temporary denial count */
-unmap_writable:
-	if (writable_file_mapping)
-		mapping_unmap_writable(file->f_mapping);
+file_expanded:
 	file = vma->vm_file;
 	ksm_add_vma(vma);
 expanded:
@@ -1568,23 +1553,17 @@ expanded:
 
 	vma_set_page_prot(vma);
 
-	validate_mm(mm);
 	return addr;
 
-close_and_free_vma:
-	vma_close(vma);
-
-	if (file || vma->vm_file) {
-unmap_and_free_vma:
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
-
-		vma_iter_set(&vmi, vma->vm_end);
-		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi.mas, vma, vmg.prev, vmg.next);
-	}
-	if (writable_file_mapping)
-		mapping_unmap_writable(file->f_mapping);
+unmap_and_free_file_vma:
+	fput(vma->vm_file);
+	vma->vm_file = NULL;
+
+	vma_iter_set(&vmi, vma->vm_end);
+	/* Undo any partial mapping done by a device driver. */
+	unmap_region(&vmi.mas, vma, vmg.prev, vmg.next);
+free_iter_vma:
+	vma_iter_free(&vmi);
 free_vma:
 	vm_area_free(vma);
 unacct_error:
@@ -1594,10 +1573,43 @@ unacct_error:
 abort_munmap:
 	vms_abort_munmap_vmas(&vms, &mas_detach);
 gather_failed:
-	validate_mm(mm);
 	return error;
 }
 
+unsigned long mmap_region(struct file *file, unsigned long addr,
+			  unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
+			  struct list_head *uf)
+{
+	unsigned long ret;
+	bool writable_file_mapping = false;
+
+	/* Allow architectures to sanity-check the vm_flags. */
+	if (!arch_validate_flags(vm_flags))
+		return -EINVAL;
+
+	/* Check to see if MDWE is applicable. */
+	if (map_deny_write_exec(vm_flags, vm_flags))
+		return -EACCES;
+
+	/* Map writable and ensure this isn't a sealed memfd. */
+	if (file && is_shared_maywrite(vm_flags)) {
+		int error = mapping_map_writable(file->f_mapping);
+
+		if (error)
+			return error;
+		writable_file_mapping = true;
+	}
+
+	ret = __mmap_region(file, addr, len, vm_flags, pgoff, uf);
+
+	/* Clear our write mapping regardless of error. */
+	if (writable_file_mapping)
+		mapping_unmap_writable(file->f_mapping);
+
+	validate_mm(current->mm);
+	return ret;
+}
+
 static int __vm_munmap(unsigned long start, size_t len, bool unlock)
 {
 	int ret;
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

