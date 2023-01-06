Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F78C53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbjAFAfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbjAFAf2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B0553721
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D6261AED
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974E7C433F0;
        Fri,  6 Jan 2023 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965325;
        bh=2Pi9Vabox8GM/SpBYKWT634aFwdKJlLBbJqlQ1ayFBI=;
        h=Date:To:From:Subject:From;
        b=DkxxyvPxwXqDCi7ingPnh7lj2bxl9KQcJfk06ZaosgzMqOdqkD1v6Eo2B5avdC09l
         9ysGDeXS7eJaTV6CGaZRO1DDUWPM5OgrI99Oo8wLt5IBFU7DPbwJ1QtKDdPrkESy7i
         wcvNe6yzM7hdcPTU83mY7avDD0tp3+imZxURmJyQ=
Date:   Thu, 05 Jan 2023 16:35:24 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230106003525.974E7C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: use vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-vma-iterator.patch

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
Subject: userfaultfd: use vma iterator
Date: Thu, 5 Jan 2023 19:15:56 +0000

Use the vma iterator so that the iterator can be invalidated or updated
to avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230105191517.3099082-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   88 +++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 54 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-use-vma-iterator
+++ a/fs/userfaultfd.c
@@ -883,7 +883,7 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -900,7 +900,7 @@ static int userfaultfd_release(struct in
 	 */
 	mmap_write_lock(mm);
 	prev = NULL;
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 		cond_resched();
 		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
 		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
@@ -909,13 +909,12 @@ static int userfaultfd_release(struct in
 			continue;
 		}
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
+		prev = vmi_vma_merge(&vmi, mm, prev, vma->vm_start, vma->vm_end,
 				 new_flags, vma->anon_vma,
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev) {
-			mas_pause(&mas);
 			vma = prev;
 		} else {
 			prev = vma;
@@ -1302,7 +1301,7 @@ static int userfaultfd_register(struct u
 	bool found;
 	bool basic_ioctls;
 	unsigned long start, end, vma_end;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
 
@@ -1344,17 +1343,13 @@ static int userfaultfd_register(struct u
 	if (!mmget_not_zero(mm))
 		goto out;
 
+	ret = -EINVAL;
 	mmap_write_lock(mm);
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma_iter_init(&vmi, mm, start);
+	vma = vma_find(&vmi, end);
 	if (!vma)
 		goto out_unlock;
 
-	/* check that there's at least one vma in the range */
-	ret = -EINVAL;
-	if (vma->vm_start >= end)
-		goto out_unlock;
-
 	/*
 	 * If the first vma contains huge pages, make sure start address
 	 * is aligned to huge page size.
@@ -1371,7 +1366,8 @@ static int userfaultfd_register(struct u
 	 */
 	found = false;
 	basic_ioctls = false;
-	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
+	cur = vma;
+	do {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1428,16 +1424,14 @@ static int userfaultfd_register(struct u
 			basic_ioctls = true;
 
 		found = true;
-	}
+	} for_each_vma_range(vmi, cur, end);
 	BUG_ON(!found);
 
-	mas_set(&mas, start);
-	prev = mas_prev(&mas, 0);
-	if (prev != vma)
-		mas_next(&mas, ULONG_MAX);
+	vma_iter_set(&vmi, start);
+	prev = vma_prev(&vmi);
 
 	ret = 0;
-	do {
+	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1458,30 +1452,25 @@ static int userfaultfd_register(struct u
 		vma_end = min(end, vma->vm_end);
 
 		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
-		prev = vma_merge(mm, prev, start, vma_end, new_flags,
+		prev = vmi_vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 ((struct vm_userfaultfd_ctx){ ctx }),
 				 anon_vma_name(vma));
 		if (prev) {
 			/* vma_merge() invalidated the mas */
-			mas_pause(&mas);
 			vma = prev;
 			goto next;
 		}
 		if (vma->vm_start < start) {
-			ret = split_vma(mm, vma, start, 1);
+			ret = vmi_split_vma(&vmi, mm, vma, start, 1);
 			if (ret)
 				break;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
-			ret = split_vma(mm, vma, end, 0);
+			ret = vmi_split_vma(&vmi, mm, vma, end, 0);
 			if (ret)
 				break;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
 		}
 	next:
 		/*
@@ -1498,8 +1487,8 @@ static int userfaultfd_register(struct u
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = mas_next(&mas, end - 1);
-	} while (vma);
+	}
+
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
@@ -1543,7 +1532,7 @@ static int userfaultfd_unregister(struct
 	bool found;
 	unsigned long start, end, vma_end;
 	const void __user *buf = (void __user *)arg;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
@@ -1562,14 +1551,10 @@ static int userfaultfd_unregister(struct
 		goto out;
 
 	mmap_write_lock(mm);
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
-	if (!vma)
-		goto out_unlock;
-
-	/* check that there's at least one vma in the range */
 	ret = -EINVAL;
-	if (vma->vm_start >= end)
+	vma_iter_init(&vmi, mm, start);
+	vma = vma_find(&vmi, end);
+	if (!vma)
 		goto out_unlock;
 
 	/*
@@ -1587,8 +1572,8 @@ static int userfaultfd_unregister(struct
 	 * Search for not compatible vmas.
 	 */
 	found = false;
-	ret = -EINVAL;
-	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
+	cur = vma;
+	do {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1605,16 +1590,13 @@ static int userfaultfd_unregister(struct
 			goto out_unlock;
 
 		found = true;
-	}
+	} for_each_vma_range(vmi, cur, end);
 	BUG_ON(!found);
 
-	mas_set(&mas, start);
-	prev = mas_prev(&mas, 0);
-	if (prev != vma)
-		mas_next(&mas, ULONG_MAX);
-
+	vma_iter_set(&vmi, start);
+	prev = vma_prev(&vmi);
 	ret = 0;
-	do {
+	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vma->vm_flags));
@@ -1650,26 +1632,24 @@ static int userfaultfd_unregister(struct
 			uffd_wp_range(mm, vma, start, vma_end - start, false);
 
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		prev = vma_merge(mm, prev, start, vma_end, new_flags,
+		prev = vmi_vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
-			mas_pause(&mas);
 			goto next;
 		}
 		if (vma->vm_start < start) {
-			ret = split_vma(mm, vma, start, 1);
+			ret = vmi_split_vma(&vmi, mm, vma, start, 1);
 			if (ret)
 				break;
-			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
-			ret = split_vma(mm, vma, end, 0);
+			vma_iter_set(&vmi, vma->vm_end);
+			ret = vmi_split_vma(&vmi, mm, vma, end, 0);
 			if (ret)
 				break;
-			mas_pause(&mas);
 		}
 	next:
 		/*
@@ -1683,8 +1663,8 @@ static int userfaultfd_unregister(struct
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = mas_next(&mas, end - 1);
-	} while (vma);
+	}
+
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
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

