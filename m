Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E097FC27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjAUBGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjAUBGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B666ACA2
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9408B82AA3
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6998BC433D2;
        Sat, 21 Jan 2023 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263191;
        bh=x8Htc5if/OlmAV6e8ito3Ujxc7PmkEPw5LZ7JEGCp8E=;
        h=Date:To:From:Subject:From;
        b=qxpcPYPxC4BD6zFlxsfjOB7e4KTVxHOFOznHT/iQ2FYo9e5vRVLu1hYKP+g2uhIEk
         V2im9CyF7LTK3qzjJirjfLtc9lI45z5lV3EAii78y13uYvKPjbVGmzc5P7dYvHwuFn
         iPaj5jUzkBAno9X81a/ZvJY+cY8KLP+tmhRG2OSA=
Date:   Fri, 20 Jan 2023 17:06:30 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-mprotect_fixup-to-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230121010631.6998BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change mprotect_fixup to vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-mprotect_fixup-to-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-mprotect_fixup-to-vma-iterator.patch

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
Subject: mm: change mprotect_fixup to vma iterator
Date: Fri, 20 Jan 2023 11:26:18 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-18-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/exec.c~mm-change-mprotect_fixup-to-vma-iterator
+++ a/fs/exec.c
@@ -758,6 +758,7 @@ int setup_arg_pages(struct linux_binprm
 	unsigned long stack_expand;
 	unsigned long rlim_stack;
 	struct mmu_gather tlb;
+	struct vma_iterator vmi;
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size */
@@ -812,8 +813,10 @@ int setup_arg_pages(struct linux_binprm
 	vm_flags |= mm->def_flags;
 	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
 
+	vma_iter_init(&vmi, mm, vma->vm_start);
+
 	tlb_gather_mmu(&tlb, mm);
-	ret = mprotect_fixup(&tlb, vma, &prev, vma->vm_start, vma->vm_end,
+	ret = mprotect_fixup(&vmi, &tlb, vma, &prev, vma->vm_start, vma->vm_end,
 			vm_flags);
 	tlb_finish_mmu(&tlb);
 
--- a/include/linux/mm.h~mm-change-mprotect_fixup-to-vma-iterator
+++ a/include/linux/mm.h
@@ -2197,9 +2197,9 @@ bool can_change_pte_writable(struct vm_a
 extern long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, unsigned long cp_flags);
-extern int mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			  struct vm_area_struct **pprev, unsigned long start,
-			  unsigned long end, unsigned long newflags);
+extern int mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
+	  struct vm_area_struct *vma, struct vm_area_struct **pprev,
+	  unsigned long start, unsigned long end, unsigned long newflags);
 
 /*
  * doesn't attempt to fault and will return short.
--- a/mm/mprotect.c~mm-change-mprotect_fixup-to-vma-iterator
+++ a/mm/mprotect.c
@@ -585,9 +585,9 @@ static const struct mm_walk_ops prot_non
 };
 
 int
-mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
-	       struct vm_area_struct **pprev, unsigned long start,
-	       unsigned long end, unsigned long newflags)
+mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
+	       struct vm_area_struct *vma, struct vm_area_struct **pprev,
+	       unsigned long start, unsigned long end, unsigned long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long oldflags = vma->vm_flags;
@@ -642,7 +642,7 @@ mprotect_fixup(struct mmu_gather *tlb, s
 	 * First try to merge with previous and/or next vma.
 	 */
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
-	*pprev = vma_merge(mm, *pprev, start, end, newflags,
+	*pprev = vmi_vma_merge(vmi, mm, *pprev, start, end, newflags,
 			   vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
 			   vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (*pprev) {
@@ -654,13 +654,13 @@ mprotect_fixup(struct mmu_gather *tlb, s
 	*pprev = vma;
 
 	if (start != vma->vm_start) {
-		error = split_vma(mm, vma, start, 1);
+		error = vmi_split_vma(vmi, mm, vma, start, 1);
 		if (error)
 			goto fail;
 	}
 
 	if (end != vma->vm_end) {
-		error = split_vma(mm, vma, end, 0);
+		error = vmi_split_vma(vmi, mm, vma, end, 0);
 		if (error)
 			goto fail;
 	}
@@ -709,7 +709,7 @@ static int do_mprotect_pkey(unsigned lon
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
 	struct mmu_gather tlb;
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	start = untagged_addr(start);
 
@@ -741,8 +741,8 @@ static int do_mprotect_pkey(unsigned lon
 	if ((pkey != -1) && !mm_pkey_is_allocated(current->mm, pkey))
 		goto out;
 
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma_iter_init(&vmi, current->mm, start);
+	vma = vma_find(&vmi, end);
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
@@ -765,18 +765,22 @@ static int do_mprotect_pkey(unsigned lon
 		}
 	}
 
+	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
-	else
-		prev = mas_prev(&mas, 0);
 
 	tlb_gather_mmu(&tlb, current->mm);
-	for (nstart = start ; ; ) {
+	nstart = start;
+	tmp = vma->vm_start;
+	for_each_vma_range(vmi, vma, end) {
 		unsigned long mask_off_old_flags;
 		unsigned long newflags;
 		int new_vma_pkey;
 
-		/* Here we know that vma->vm_start <= nstart < vma->vm_end. */
+		if (vma->vm_start != tmp) {
+			error = -ENOMEM;
+			break;
+		}
 
 		/* Does the application expect PROT_READ to imply PROT_EXEC */
 		if (rier && (vma->vm_flags & VM_MAYEXEC))
@@ -824,25 +828,18 @@ static int do_mprotect_pkey(unsigned lon
 				break;
 		}
 
-		error = mprotect_fixup(&tlb, vma, &prev, nstart, tmp, newflags);
+		error = mprotect_fixup(&vmi, &tlb, vma, &prev, nstart, tmp, newflags);
 		if (error)
 			break;
 
 		nstart = tmp;
-
-		if (nstart < prev->vm_end)
-			nstart = prev->vm_end;
-		if (nstart >= end)
-			break;
-
-		vma = find_vma(current->mm, prev->vm_end);
-		if (!vma || vma->vm_start != nstart) {
-			error = -ENOMEM;
-			break;
-		}
 		prot = reqprot;
 	}
 	tlb_finish_mmu(&tlb);
+
+	if (vma_iter_end(&vmi) < end)
+		error = -ENOMEM;
+
 out:
 	mmap_write_unlock(current->mm);
 	return error;
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
nommu-convert-nommu-to-using-the-vma-iterator.patch
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

