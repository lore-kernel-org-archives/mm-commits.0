Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825D5C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbjAFAgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbjAFAfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C248154DBA
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8384DB81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA1C433D2;
        Fri,  6 Jan 2023 00:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965330;
        bh=inEt2NhvTPbcqisJfhz+XUKq7H2wbUHzpN/uj63tyiE=;
        h=Date:To:From:Subject:From;
        b=yhZkb44XxCRC1SBPVf1MMdRofFFNvs++7h0KOvKCs76epJu30GocPDOFTjyA2BClE
         sCOVXYeLErhSm+8XaehSqS8/4UhmLagi4GkyV2jJNV0XfqGAs7t7V4JnrusnyhHu68
         DahyF6OBVPRDdk1oTp/k2SFl6jNQoVpmrpjLwb8A=
Date:   Thu, 05 Jan 2023 16:35:29 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mlock-convert-mlock-to-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230106003530.33CA1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mlock: convert mlock to vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mlock-convert-mlock-to-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mlock-convert-mlock-to-vma-iterator.patch

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
Subject: mlock: convert mlock to vma iterator
Date: Thu, 5 Jan 2023 19:15:57 +0000

Use the vma iterator so that the iterator can be invalidated or updated
to avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230105191517.3099082-17-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   57 +++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

--- a/mm/mlock.c~mlock-convert-mlock-to-vma-iterator
+++ a/mm/mlock.c
@@ -401,8 +401,9 @@ static void mlock_vma_pages_range(struct
  *
  * For vmas that pass the filters, merge/split as appropriate.
  */
-static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
-	unsigned long start, unsigned long end, vm_flags_t newflags)
+static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       struct vm_area_struct **prev, unsigned long start,
+	       unsigned long end, vm_flags_t newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgoff_t pgoff;
@@ -417,22 +418,22 @@ static int mlock_fixup(struct vm_area_st
 		goto out;
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
-	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
-			  vma->vm_file, pgoff, vma_policy(vma),
-			  vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	*prev = vmi_vma_merge(vmi, mm, *prev, start, end, newflags,
+			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
+			vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (*prev) {
 		vma = *prev;
 		goto success;
 	}
 
 	if (start != vma->vm_start) {
-		ret = split_vma(mm, vma, start, 1);
+		ret = vmi_split_vma(vmi, mm, vma, start, 1);
 		if (ret)
 			goto out;
 	}
 
 	if (end != vma->vm_end) {
-		ret = split_vma(mm, vma, end, 0);
+		ret = vmi_split_vma(vmi, mm, vma, end, 0);
 		if (ret)
 			goto out;
 	}
@@ -471,7 +472,7 @@ static int apply_vma_lock_flags(unsigned
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct *vma, *prev;
 	int error;
-	MA_STATE(mas, &current->mm->mm_mt, start, start);
+	VMA_ITERATOR(vmi, current->mm, start);
 
 	VM_BUG_ON(offset_in_page(start));
 	VM_BUG_ON(len != PAGE_ALIGN(len));
@@ -480,39 +481,37 @@ static int apply_vma_lock_flags(unsigned
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	vma = mas_walk(&mas);
+	vma = vma_find(&vmi, end);
 	if (!vma)
 		return -ENOMEM;
 
+	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
-	else
-		prev = mas_prev(&mas, 0);
 
-	for (nstart = start ; ; ) {
-		vm_flags_t newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+	nstart = start;
+	tmp = vma->vm_start;
+	for_each_vma_range(vmi, vma, end) {
+		vm_flags_t newflags;
 
-		newflags |= flags;
+		if (vma->vm_start != tmp)
+			return -ENOMEM;
 
+		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+		newflags |= flags;
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mlock_fixup(vma, &prev, nstart, tmp, newflags);
+		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
 		if (error)
 			break;
 		nstart = tmp;
-		if (nstart < prev->vm_end)
-			nstart = prev->vm_end;
-		if (nstart >= end)
-			break;
-
-		vma = find_vma(prev->vm_mm, prev->vm_end);
-		if (!vma || vma->vm_start != nstart) {
-			error = -ENOMEM;
-			break;
-		}
 	}
+
+	if (vma_iter_end(&vmi) < end)
+		return -ENOMEM;
+
 	return error;
 }
 
@@ -658,7 +657,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  */
 static int apply_mlockall_flags(int flags)
 {
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, current->mm, 0);
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
@@ -679,15 +678,15 @@ static int apply_mlockall_flags(int flag
 			to_add |= VM_LOCKONFAULT;
 	}
 
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
 		newflags |= to_add;
 
 		/* Ignore errors */
-		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
-		mas_pause(&mas);
+		mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
+			    newflags);
 		cond_resched();
 	}
 out:
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

