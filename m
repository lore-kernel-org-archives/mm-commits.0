Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13874D599;
	Wed, 23 Oct 2024 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729723444; cv=none; b=cId2yelayscxPw3c+nlcESzd0abueIOV006GFfFIghzrup9rgcoS4CI2bJ4/LhA+UoRv+1C2hc7eYvX22IgrnMsPyBbhVHkZ131u6XQEExyUJadDmkFTTqbNM/zPyXv1e4oLklLqoUFQKKOkiV9Ifi2YulL2SDnSQqQjkQA5Uqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729723444; c=relaxed/simple;
	bh=dkqkV0pcBml2njruK+5551NTdS3o0pn1qRy/UYWlQqM=;
	h=Date:To:From:Subject:Message-Id; b=naO54BPZ0ADxIn04vDdtcL2MSBD4+TSb4l3mM30BKC3eCg/QuvcM8sBqeSuP5XMnrb6aSodJ4B950gCDAeUQx/XyFGlouQJcTs0rRqo6VDk4inUXd7piC2gazaWCtv9QZaBY+imNmWnBtiEbtF8X7Et2wZXX3hFfXJ5s9GGkmh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=br02Ae4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="br02Ae4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B510C4CEC6;
	Wed, 23 Oct 2024 22:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729723443;
	bh=dkqkV0pcBml2njruK+5551NTdS3o0pn1qRy/UYWlQqM=;
	h=Date:To:From:Subject:From;
	b=br02Ae4Vi8IKsWa/xEC1C0d/WtOpqJcXdPw5pg0/Kscl0hlrPTQ2aoRcqdNG6CQqy
	 /RCHW2QHiZnIwnYdl4+FiJx8SgWcdewcZd9vlJPUKZG8wtkyBwv2C8MVsR9MjP6ebq
	 tYdLWuGwR/4cHHW5K1hSWCvr5rqOrG3yy7SR6XBQ=
Date: Wed, 23 Oct 2024 15:44:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@vger.kernel.org,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023224403.5B510C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid unsafe VMA hook invocation when error arises on mmap hook
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch

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
Subject: mm: avoid unsafe VMA hook invocation when error arises on mmap hook
Date: Wed, 23 Oct 2024 21:38:26 +0100

Patch series "fix error handling in mmap_region() and refactor", v2.

The mmap_region() function is somewhat terrifying, with spaghetti-like
control flow and numerous means by which issues can arise and incomplete
state, memory leaks and other unpleasantness can occur.

A large amount of the complexity arises from trying to handle errors late
in the process of mapping a VMA, which forms the basis of recently observed
issues with resource leaks and observable inconsistent state.

This series goes to great lengths to simplify how mmap_region() works and
to avoid unwinding errors late on in the process of setting up the VMA for
the new mapping, and equally avoids such operations occurring while the VMA
is in an inconsistent state.

The first four patches are intended for backporting to correct the
possibility of people encountering corrupted state while invoking mmap()
which is otherwise at risk of happening.

After this we go further, refactoring the code, placing it in mm/vma.c in
order to make it eventually userland testable, and significantly
simplifying the logic to avoid this issue arising in future.


This patch (of 4):

After an attempted mmap() fails, we are no longer in a situation where we
can safely interact with VMA hooks.  This is currently not enforced,
meaning that we need complicated handling to ensure we do not incorrectly
call these hooks.

We can avoid the whole issue by treating the VMA as suspect the moment
that the file->f_ops->mmap() function reports an error by replacing
whatever VMA operations were installed with a dummy empty set of VMA
operations.

We do so through a new helper function internal to mm - mmap_file() -
which is both more logically named than the existing call_mmap() function
and correctly isolates handling of the vm_op reassignment to mm.

All the existing invocations of call_mmap() outside of mm are ultimately
nested within the call_mmap() from mm, which we now replace.

It is therefore safe to leave call_mmap() in place as a convenience
function (and to avoid churn).  The invokers are:

     ovl_file_operations -> mmap -> ovl_mmap() -> backing_file_mmap()
    coda_file_operations -> mmap -> coda_file_mmap()
     shm_file_operations -> shm_mmap()
shm_file_operations_huge -> shm_mmap()
            dma_buf_fops -> dma_buf_mmap_internal -> i915_dmabuf_ops
	                    -> i915_gem_dmabuf_mmap()

None of these callers interact with vm_ops or mappings in a problematic way
on error, quickly exiting out.

Link: https://lkml.kernel.org/r/cover.1729715266.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/69f3c04df1ece2b7d402a29451ec19290ff429a4.1729715266.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   27 +++++++++++++++++++++++++++
 mm/mmap.c     |    6 +++---
 mm/nommu.c    |    4 ++--
 3 files changed, 32 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook
+++ a/mm/internal.h
@@ -108,6 +108,33 @@ static inline void *folio_raw_mapping(co
 	return (void *)(mapping & ~PAGE_MAPPING_FLAGS);
 }
 
+/*
+ * This is a file-backed mapping, and is about to be memory mapped - invoke its
+ * mmap hook and safely handle error conditions. On error, VMA hooks will be
+ * mutated.
+ *
+ * @file: File which backs the mapping.
+ * @vma:  VMA which we are mapping.
+ *
+ * Returns: 0 if success, error otherwise.
+ */
+static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
+{
+	int err = call_mmap(file, vma);
+
+	if (likely(!err))
+		return 0;
+
+	/*
+	 * OK, we tried to call the file hook for mmap(), but an error
+	 * arose. The mapping is in an inconsistent state and we most not invoke
+	 * any further hooks on it.
+	 */
+	vma->vm_ops = &vma_dummy_vm_ops;
+
+	return err;
+}
+
 #ifdef CONFIG_MMU
 
 /* Flags for folio_pte_batch(). */
--- a/mm/mmap.c~mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook
+++ a/mm/mmap.c
@@ -1421,7 +1421,7 @@ unsigned long mmap_region(struct file *f
 	/*
 	 * clear PTEs while the vma is still in the tree so that rmap
 	 * cannot race with the freeing later in the truncate scenario.
-	 * This is also needed for call_mmap(), which is why vm_ops
+	 * This is also needed for mmap_file(), which is why vm_ops
 	 * close function is called.
 	 */
 	vms_clean_up_area(&vms, &mas_detach);
@@ -1446,7 +1446,7 @@ unsigned long mmap_region(struct file *f
 
 	if (file) {
 		vma->vm_file = get_file(file);
-		error = call_mmap(file, vma);
+		error = mmap_file(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
 
@@ -1469,7 +1469,7 @@ unsigned long mmap_region(struct file *f
 
 		vma_iter_config(&vmi, addr, end);
 		/*
-		 * If vm_flags changed after call_mmap(), we should try merge
+		 * If vm_flags changed after mmap_file(), we should try merge
 		 * vma again as we may succeed this time.
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && vmg.prev)) {
--- a/mm/nommu.c~mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook
+++ a/mm/nommu.c
@@ -885,7 +885,7 @@ static int do_mmap_shared_file(struct vm
 {
 	int ret;
 
-	ret = call_mmap(vma->vm_file, vma);
+	ret = mmap_file(vma->vm_file, vma);
 	if (ret == 0) {
 		vma->vm_region->vm_top = vma->vm_region->vm_end;
 		return 0;
@@ -918,7 +918,7 @@ static int do_mmap_private(struct vm_are
 	 * happy.
 	 */
 	if (capabilities & NOMMU_MAP_DIRECT) {
-		ret = call_mmap(vma->vm_file, vma);
+		ret = mmap_file(vma->vm_file, vma);
 		/* shouldn't return success if we're not sharing */
 		if (WARN_ON_ONCE(!is_nommu_shared_mapping(vma->vm_flags)))
 			ret = -ENOSYS;
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
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

