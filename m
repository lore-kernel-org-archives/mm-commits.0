Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BA4C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbjAFAhk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbjAFAgM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8326954DBA
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 316C1B81C10
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6654C433EF;
        Fri,  6 Jan 2023 00:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965368;
        bh=g4HtcLNnCJJ48XTk4N29ul+VwB5Y3du3ctMJjLDIV9s=;
        h=Date:To:From:Subject:From;
        b=xNGSwhJO0llA3v2UAfrhPGhZ5z9YLhdAIXVHGlm32xm4NkgBudxnXOTwAyQY3dr37
         yAZO4o/jxtDeRcgKbAFOFdpcXDYcP5JWMYsTHCLIRVf+8wkcpoM2BC4mJgo5dnoe4Q
         274zAunHBGGdOYMyzKMBS1/egVkv9FzBPumSIXjY=
Date:   Thu, 05 Jan 2023 16:36:08 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-munmap-splitting-order-and-move_vma.patch added to mm-unstable branch
Message-Id: <20230106003608.C6654C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change munmap splitting order and move_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-munmap-splitting-order-and-move_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-munmap-splitting-order-and-move_vma.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: change munmap splitting order and move_vma()
Date: Thu, 5 Jan 2023 19:16:02 +0000

Splitting can be more efficient when the order is not of concern.
Change do_vmi_align_munmap() to reduce walking of the tree during split
operations.

move_vma() must also be altered to remove the dependency of keeping the
original VMA as the active part of the split.  Transition to using vma
iterator to look up the prev and/or next vma after munmap.

Link: https://lkml.kernel.org/r/20230105191517.3099082-35-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c   |   18 ++----------------
 mm/mremap.c |   27 ++++++++++++++++-----------
 2 files changed, 18 insertions(+), 27 deletions(-)

--- a/mm/mmap.c~mm-change-munmap-splitting-order-and-move_vma
+++ a/mm/mmap.c
@@ -2391,21 +2391,9 @@ do_vmi_align_munmap(struct vma_iterator
 	for_each_vma_range(*vmi, next, end) {
 		/* Does it split the end? */
 		if (next->vm_end > end) {
-			struct vm_area_struct *split;
-
-			error = __split_vma(vmi, next, end, 1);
+			error = __split_vma(vmi, next, end, 0);
 			if (error)
 				goto end_split_failed;
-
-			split = vma_prev(vmi);
-			error = munmap_sidetree(split, &mas_detach);
-			if (error)
-				goto munmap_sidetree_failed;
-
-			count++;
-			if (vma == next)
-				vma = split;
-			break;
 		}
 		error = munmap_sidetree(next, &mas_detach);
 		if (error)
@@ -2418,9 +2406,7 @@ do_vmi_align_munmap(struct vma_iterator
 #endif
 	}
 
-	if (!next)
-		next = vma_next(vmi);
-
+	next = vma_next(vmi);
 	if (unlikely(uf)) {
 		/*
 		 * If userfaultfd_unmap_prep returns an error the vmas
--- a/mm/mremap.c~mm-change-munmap-splitting-order-and-move_vma
+++ a/mm/mremap.c
@@ -580,11 +580,12 @@ static unsigned long move_vma(struct vm_
 	unsigned long vm_flags = vma->vm_flags;
 	unsigned long new_pgoff;
 	unsigned long moved_len;
-	unsigned long excess = 0;
+	unsigned long account_start = 0;
+	unsigned long account_end = 0;
 	unsigned long hiwater_vm;
-	int split = 0;
 	int err = 0;
 	bool need_rmap_locks;
+	VMA_ITERATOR(vmi, mm, old_addr);
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -662,10 +663,10 @@ static unsigned long move_vma(struct vm_
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
 	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
 		vma->vm_flags &= ~VM_ACCOUNT;
-		excess = vma->vm_end - vma->vm_start - old_len;
-		if (old_addr > vma->vm_start &&
-		    old_addr + old_len < vma->vm_end)
-			split = 1;
+		if (vma->vm_start < old_addr)
+			account_start = vma->vm_start;
+		if (vma->vm_end > old_addr + old_len)
+			account_end = vma->vm_end;
 	}
 
 	/*
@@ -700,11 +701,11 @@ static unsigned long move_vma(struct vm_
 		return new_addr;
 	}
 
-	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
+	if (do_vmi_munmap(&vmi, mm, old_addr, old_len, uf_unmap, false) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
 			vm_acct_memory(old_len >> PAGE_SHIFT);
-		excess = 0;
+		account_start = account_end = 0;
 	}
 
 	if (vm_flags & VM_LOCKED) {
@@ -715,10 +716,14 @@ static unsigned long move_vma(struct vm_
 	mm->hiwater_vm = hiwater_vm;
 
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
-	if (excess) {
+	if (account_start) {
+		vma = vma_prev(&vmi);
+		vma->vm_flags |= VM_ACCOUNT;
+	}
+
+	if (account_end) {
+		vma = vma_next(&vmi);
 		vma->vm_flags |= VM_ACCOUNT;
-		if (split)
-			find_vma(mm, vma->vm_end)->vm_flags |= VM_ACCOUNT;
 	}
 
 	return new_addr;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-add-mas_init-function.patch
maple_tree-fix-potential-rcu-issue.patch
maple_tree-reduce-user-error-potential.patch
test_maple_tree-test-modifications-while-iterating.patch
mm-expand-vma-iterator-interface.patch
mm-mmap-convert-brk-to-use-vma-iterator.patch
kernel-fork-convert-forking-to-using-the-vmi-iterator.patch
mmap-convert-vma_link-vma-iterator.patch
mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch
mmap-change-do_mas_munmap-and-do_mas_aligned_munmap-to-use-vma-iterator.patch
mmap-convert-vma_expand-to-use-vma-iterator.patch
mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch
ipc-shm-use-the-vma-iterator-for-munmap-calls.patch
userfaultfd-use-vma-iterator.patch
mm-change-mprotect_fixup-to-vma-iterator.patch
mlock-convert-mlock-to-vma-iterator.patch
coredump-convert-to-vma-iterator.patch
mempolicy-convert-to-vma-iterator.patch
task_mmu-convert-to-vma-iterator.patch
sched-convert-to-vma-iterator.patch
madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch
mmap-pass-through-vmi-iterator-to-__split_vma.patch
mmap-use-vmi-version-of-vma_merge.patch
mm-mremap-use-vmi-version-of-vma_merge.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator.patch
mmap-convert-__vma_adjust-to-use-vma-iterator.patch
mm-pass-through-vma-iterator-to-__vma_adjust.patch
madvise-use-split_vma-instead-of-__split_vma.patch
mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch
mm-pass-vma-iterator-through-to-__vma_adjust.patch
mm-add-vma-iterator-to-vma_adjust-arguments.patch
mmap-clean-up-mmap_region-unrolling.patch
mm-change-munmap-splitting-order-and-move_vma.patch
mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch
mm-mmap-refactor-locking-out-of-__vma_adjust.patch
mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch
mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch
mm-dont-use-__vma_adjust-in-__split_vma.patch
mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch
mm-mmap-introduce-dup_vma_anon-helper.patch
mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch
mm-mmap-remove-__vma_adjust.patch
vma_merge-set-vma-iterator-to-correct-position.patch

