Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FB6C27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAUBGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjAUBGT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F365B595
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E279620D5
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4482C4339B;
        Sat, 21 Jan 2023 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263177;
        bh=l12hCCwCmyp89yiYWz11tS5wF93HPsh4nvDAjtCmzts=;
        h=Date:To:From:Subject:From;
        b=S4py7S+pHLLPOCMh15m/7YUJPBEG5PxldQPhCioOe7GONEDGJzk47Wj5mEklQQ5iN
         mQCjxKGpwgZzoxOOLJKMvO9DBnUxal68ui3jZKQCYXM0vhaMR7cbj//iG9+QZ8R+6z
         IeHPt54ptU0MMBPJXh79FKuyc3sQzzswi7LjXjfk=
Date:   Fri, 20 Jan 2023 17:06:16 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-convert-forking-to-using-the-vmi-iterator.patch added to mm-unstable branch
Message-Id: <20230121010616.E4482C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: convert forking to using the vmi iterator
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-fork-convert-forking-to-using-the-vmi-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-convert-forking-to-using-the-vmi-iterator.patch

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
Subject: kernel/fork: convert forking to using the vmi iterator
Date: Fri, 20 Jan 2023 11:26:10 -0500

Avoid using the maple tree interface directly.  This gains type safety.

Link: https://lkml.kernel.org/r/20230120162650.984577-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/fork.c~kernel-fork-convert-forking-to-using-the-vmi-iterator
+++ a/kernel/fork.c
@@ -595,8 +595,8 @@ static __latent_entropy int dup_mmap(str
 	int retval;
 	unsigned long charge = 0;
 	LIST_HEAD(uf);
-	MA_STATE(old_mas, &oldmm->mm_mt, 0, 0);
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(old_vmi, oldmm, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	uprobe_start_dup_mmap();
 	if (mmap_write_lock_killable(oldmm)) {
@@ -623,11 +623,11 @@ static __latent_entropy int dup_mmap(str
 		goto out;
 	khugepaged_fork(mm, oldmm);
 
-	retval = mas_expected_entries(&mas, oldmm->map_count);
+	retval = vma_iter_bulk_alloc(&vmi, oldmm->map_count);
 	if (retval)
 		goto out;
 
-	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
+	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
 		if (mpnt->vm_flags & VM_DONTCOPY) {
@@ -693,11 +693,8 @@ static __latent_entropy int dup_mmap(str
 			hugetlb_dup_vma_private(tmp);
 
 		/* Link the vma into the MT */
-		mas.index = tmp->vm_start;
-		mas.last = tmp->vm_end - 1;
-		mas_store(&mas, tmp);
-		if (mas_is_err(&mas))
-			goto fail_nomem_mas_store;
+		if (vma_iter_bulk_store(&vmi, tmp))
+			goto fail_nomem_vmi_store;
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
@@ -712,7 +709,7 @@ static __latent_entropy int dup_mmap(str
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
@@ -722,7 +719,7 @@ fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
 
-fail_nomem_mas_store:
+fail_nomem_vmi_store:
 	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
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

