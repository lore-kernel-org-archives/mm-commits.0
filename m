Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C29C38141
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjAUBGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjAUBGU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386F2613D8
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7B59B82AA3
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE2C433D2;
        Sat, 21 Jan 2023 01:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263175;
        bh=UDa+HLC/+BIHKPu9lGyfaBWB7Jv4PZflI+zhoZR5i7s=;
        h=Date:To:From:Subject:From;
        b=1NT/xuLsIxFzoUvDZ4MTWN1147SAfumVoOU+44KgjZ/rzrNNXFVp3t0y3+e1eELpD
         hDzNBmn+XuWnFKJ3LnOUMmF+HEgDOkS0mKlhwOavusfp3Jm5hDBwBvw7i1rG+cyM7u
         wBWDdJwhthMeGT9QvTQqYUSfWwF4IwSQMQj5Sicg=
Date:   Fri, 20 Jan 2023 17:06:14 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-convert-brk-to-use-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230121010615.36BE2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: convert brk to use vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-convert-brk-to-use-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-convert-brk-to-use-vma-iterator.patch

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
Subject: mm/mmap: convert brk to use vma iterator
Date: Fri, 20 Jan 2023 11:26:09 -0500

Use the vma iterator API for the brk() system call.  This will provide
type safety at compile time.

Link: https://lkml.kernel.org/r/20230120162650.984577-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-convert-brk-to-use-vma-iterator
+++ a/mm/mmap.c
@@ -180,10 +180,10 @@ static int check_brk_limits(unsigned lon
 
 	return mlock_future_check(current->mm, current->mm->def_flags, len);
 }
-static int do_brk_munmap(struct ma_state *mas, struct vm_area_struct *vma,
+static int do_brk_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			 unsigned long newbrk, unsigned long oldbrk,
 			 struct list_head *uf);
-static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *brkvma,
+static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		unsigned long addr, unsigned long request, unsigned long flags);
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
@@ -194,7 +194,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	bool populate;
 	bool downgraded = false;
 	LIST_HEAD(uf);
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
@@ -242,8 +242,8 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		int ret;
 
 		/* Search one past newbrk */
-		mas_set(&mas, newbrk);
-		brkvma = mas_find(&mas, oldbrk);
+		vma_iter_init(&vmi, mm, newbrk);
+		brkvma = vma_find(&vmi, oldbrk);
 		if (!brkvma || brkvma->vm_start >= oldbrk)
 			goto out; /* mapping intersects with an existing non-brk vma. */
 		/*
@@ -252,7 +252,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		 * before calling do_brk_munmap().
 		 */
 		mm->brk = brk;
-		ret = do_brk_munmap(&mas, brkvma, newbrk, oldbrk, &uf);
+		ret = do_brk_munmap(&vmi, brkvma, newbrk, oldbrk, &uf);
 		if (ret == 1)  {
 			downgraded = true;
 			goto success;
@@ -270,14 +270,14 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * Only check if the next VMA is within the stack_guard_gap of the
 	 * expansion area
 	 */
-	mas_set(&mas, oldbrk);
-	next = mas_find(&mas, newbrk - 1 + PAGE_SIZE + stack_guard_gap);
+	vma_iter_init(&vmi, mm, oldbrk);
+	next = vma_find(&vmi, newbrk + PAGE_SIZE + stack_guard_gap);
 	if (next && newbrk + PAGE_SIZE > vm_start_gap(next))
 		goto out;
 
-	brkvma = mas_prev(&mas, mm->start_brk);
+	brkvma = vma_prev_limit(&vmi, mm->start_brk);
 	/* Ok, looks good - let it rip. */
-	if (do_brk_flags(&mas, brkvma, oldbrk, newbrk - oldbrk, 0) < 0)
+	if (do_brk_flags(&vmi, brkvma, oldbrk, newbrk - oldbrk, 0) < 0)
 		goto out;
 
 	mm->brk = brk;
@@ -2917,8 +2917,8 @@ out:
 }
 
 /*
- * brk_munmap() - Unmap a partial vma.
- * @mas: The maple tree state.
+ * brk_munmap() - Unmap a full or partial vma.
+ * @vmi: The vma iterator
  * @vma: The vma to be modified
  * @newbrk: the start of the address to unmap
  * @oldbrk: The end of the address to unmap
@@ -2928,7 +2928,7 @@ out:
  * unmaps a partial VMA mapping.  Does not handle alignment, downgrades lock if
  * possible.
  */
-static int do_brk_munmap(struct ma_state *mas, struct vm_area_struct *vma,
+static int do_brk_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			 unsigned long newbrk, unsigned long oldbrk,
 			 struct list_head *uf)
 {
@@ -2936,14 +2936,14 @@ static int do_brk_munmap(struct ma_state
 	int ret;
 
 	arch_unmap(mm, newbrk, oldbrk);
-	ret = do_mas_align_munmap(mas, vma, mm, newbrk, oldbrk, uf, true);
+	ret = do_mas_align_munmap(&vmi->mas, vma, mm, newbrk, oldbrk, uf, true);
 	validate_mm_mt(mm);
 	return ret;
 }
 
 /*
  * do_brk_flags() - Increase the brk vma if the flags match.
- * @mas: The maple tree state.
+ * @vmi: The vma iterator
  * @addr: The start address
  * @len: The length of the increase
  * @vma: The vma,
@@ -2953,7 +2953,7 @@ static int do_brk_munmap(struct ma_state
  * do not match then create a new anonymous VMA.  Eventually we may be able to
  * do some brk-specific accounting here.
  */
-static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
+static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		unsigned long addr, unsigned long len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
@@ -2980,8 +2980,7 @@ static int do_brk_flags(struct ma_state
 	if (vma && vma->vm_end == addr && !vma_policy(vma) &&
 	    can_vma_merge_after(vma, flags, NULL, NULL,
 				addr >> PAGE_SHIFT, NULL_VM_UFFD_CTX, NULL)) {
-		mas_set_range(mas, vma->vm_start, addr + len - 1);
-		if (mas_preallocate(mas, GFP_KERNEL))
+		if (vma_iter_prealloc(vmi))
 			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
@@ -2991,7 +2990,7 @@ static int do_brk_flags(struct ma_state
 		}
 		vma->vm_end = addr + len;
 		vma->vm_flags |= VM_SOFTDIRTY;
-		mas_store_prealloc(mas, vma);
+		vma_iter_store(vmi, vma);
 
 		if (vma->anon_vma) {
 			anon_vma_interval_tree_post_update_vma(vma);
@@ -3012,8 +3011,7 @@ static int do_brk_flags(struct ma_state
 	vma->vm_pgoff = addr >> PAGE_SHIFT;
 	vma->vm_flags = flags;
 	vma->vm_page_prot = vm_get_page_prot(flags);
-	mas_set_range(mas, vma->vm_start, addr + len - 1);
-	if (mas_store_gfp(mas, vma, GFP_KERNEL))
+	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
 	mm->map_count++;
@@ -3042,7 +3040,7 @@ int vm_brk_flags(unsigned long addr, uns
 	int ret;
 	bool populate;
 	LIST_HEAD(uf);
-	MA_STATE(mas, &mm->mm_mt, addr, addr);
+	VMA_ITERATOR(vmi, mm, addr);
 
 	len = PAGE_ALIGN(request);
 	if (len < request)
@@ -3061,12 +3059,12 @@ int vm_brk_flags(unsigned long addr, uns
 	if (ret)
 		goto limits_failed;
 
-	ret = do_mas_munmap(&mas, mm, addr, len, &uf, 0);
+	ret = do_mas_munmap(&vmi.mas, mm, addr, len, &uf, 0);
 	if (ret)
 		goto munmap_failed;
 
-	vma = mas_prev(&mas, 0);
-	ret = do_brk_flags(&mas, vma, addr, len, flags);
+	vma = vma_prev(&vmi);
+	ret = do_brk_flags(&vmi, vma, addr, len, flags);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	mmap_write_unlock(mm);
 	userfaultfd_unmap_complete(mm, &uf);
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

