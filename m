Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F915205AC0;
	Thu,  6 Mar 2025 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741299484; cv=none; b=iz5sfLh76Uo5QW4MW5ZeD4aDo6G9bglxSQZKxZc6FeIclBwWK7In2vQ8rDCsxFKdrrq2AUxi5ezJrf/vtbwJnNETeZCwGLGnTic6+3aWlrNeAL1eym4FoyPb1oeO3pT6UJSLkWg9lRb2xA7PTpaZr2JolVxWS9h6w/y56jWvNMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741299484; c=relaxed/simple;
	bh=/XemML4mcWHVZ9HCmXU9SOO4LTBBwmRNCIcxd2MamzY=;
	h=Date:To:From:Subject:Message-Id; b=Z8W8Lc+ouqq9HCaeZl7d9eWZ47wmNVLgOK89npG1FXgymdO7dWxjhU3aGzuKZ3iHNJ41J+zqCvCTjwJGIl4IGCBiTV7F4X2oTZV8tdP//PR6DswGNFVJTGuiDHB1HtXleRK68t9DHhkHTi7lE1HwqpetlcEH8TTbluutsKjBZyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OAqWPL8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OAqWPL8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074EAC4CEE0;
	Thu,  6 Mar 2025 22:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741299484;
	bh=/XemML4mcWHVZ9HCmXU9SOO4LTBBwmRNCIcxd2MamzY=;
	h=Date:To:From:Subject:From;
	b=OAqWPL8i9UT2JEnXot52L3Kyf4mbOZgmN4+BIprH1PXHYNcCMYAnRn10me0U/Ui0i
	 xd63BttlB19cYw2PHkGwz281pLTJM3c6h5UMdlT7R0ie3uNA4pZB2cTgf1LtlTeIID
	 JW3NGuEtBpE3o5BDfGSLg23BFMAbrx2XzS/g08G0=
Date: Thu, 06 Mar 2025 14:18:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch added to mm-unstable branch
Message-Id: <20250306221804.074EAC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: correctly handle partial mremap() of VMA starting at 0
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch

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
Subject: mm/mremap: correctly handle partial mremap() of VMA starting at 0
Date: Thu, 6 Mar 2025 10:33:57 +0000

Patch series "refactor mremap and fix bug", v2.

The existing mremap() logic has grown organically over a very long period
of time, resulting in code that is in many parts, very difficult to follow
and full of subtleties and sources of confusion.

In addition, it is difficult to thread state through the operation
correctly, as function arguments have expanded, some parameters are
expected to be temporarily altered during the operation, others are
intended to remain static and some can be overridden.

This series completely refactors the mremap implementation, sensibly
separating functions, adding comments to explain the more subtle aspects
of the implementation and making use of small structs to thread state
through everything.

The reason for doing so is to lay the groundwork for planned future
changes to the mremap logic, changes which require the ability to easily
pass around state.

Additionally, it would be unhelpful to add yet more logic to code that is
already difficult to follow without first refactoring it like this.

The first patch in this series additionally fixes a bug when a VMA with
start address zero is partially remapped.

Tested on real hardware under heavy workload and all self tests are
passing.


This patch (of 7):

Consider the case of a partial mremap() (that results in a VMA split) of
an accountable VMA (i.e.  which has the VM_ACCOUNT flag set) whose start
address is zero, with the MREMAP_MAYMOVE flag specified and a scenario
where a move does in fact occur:

       addr  end
        |     |
        v     v
    |-------------|
    |     vma     |
    |-------------|
    0

This move is affected by unmapping the range [addr, end).  In order to
prevent an incorrect decrement of accounted memory which has already been
determined, the mremap() code in move_vma() clears VM_ACCOUNT from the VMA
prior to doing so, before reestablishing it in each of the VMAs
post-split:

    addr  end
     |     |
     v     v
 |---|     |---|
 | A |     | B |
 |---|     |---|

Commit 6b73cff239e5 ("mm: change munmap splitting order and move_vma()")
changed this logic such as to determine whether there is a need to do so
by establishing account_start and account_end and, in the instance where
such an operation is required, assigning them to vma->vm_start and
vma->vm_end.

Later the code checks if the operation is required for 'A' referenced
above thusly:

	if (account_start) {
		...
	}

However, if the VMA described above has vma->vm_start == 0, which is now
assigned to account_start, this branch will not be executed.

As a result, the VMA 'A' above will remain stripped of its VM_ACCOUNT
flag, incorrectly.

The fix is to simply convert these variables to booleans and set them as
required.

Link: https://lkml.kernel.org/r/cover.1741256580.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/94681428faba4c34a76e2de1c875629372aae3d5.1741256580.git.lorenzo.stoakes@oracle.com
Fixes: 6b73cff239e5 ("mm: change munmap splitting order and move_vma()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0
+++ a/mm/mremap.c
@@ -705,8 +705,8 @@ static unsigned long move_vma(struct vm_
 	unsigned long vm_flags = vma->vm_flags;
 	unsigned long new_pgoff;
 	unsigned long moved_len;
-	unsigned long account_start = 0;
-	unsigned long account_end = 0;
+	bool account_start = false;
+	bool account_end = false;
 	unsigned long hiwater_vm;
 	int err = 0;
 	bool need_rmap_locks;
@@ -790,9 +790,9 @@ static unsigned long move_vma(struct vm_
 	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
 		vm_flags_clear(vma, VM_ACCOUNT);
 		if (vma->vm_start < old_addr)
-			account_start = vma->vm_start;
+			account_start = true;
 		if (vma->vm_end > old_addr + old_len)
-			account_end = vma->vm_end;
+			account_end = true;
 	}
 
 	/*
@@ -832,7 +832,7 @@ static unsigned long move_vma(struct vm_
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
 			vm_acct_memory(old_len >> PAGE_SHIFT);
-		account_start = account_end = 0;
+		account_start = account_end = false;
 	}
 
 	if (vm_flags & VM_LOCKED) {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
selftests-mm-rename-guard-pages-to-guard-regions-fix.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

