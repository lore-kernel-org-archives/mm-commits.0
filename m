Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835DEC27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAUBGs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjAUBGn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A56771BE7
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D4CB829E7
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7663C433D2;
        Sat, 21 Jan 2023 01:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263198;
        bh=paPkb7QsRu8ZfRWhSs+6VDU3VoGEeycorlYXGMYMJnE=;
        h=Date:To:From:Subject:From;
        b=kwDiXg3AC+ygkXOczp2Su7xwKs9tcdXmufuf/w72aID4KeKsvdPsXUxDeybeQgARU
         UMhRx8Kde8KGtibFM4rxhiZqRI+f5r8nXnRCTtTFTNR34XfqKzy04yzcPjmle3Q84w
         EVsqwlieOHTZpGUerv6PLo3aVa4hXgLcpXUOjacU=
Date:   Fri, 20 Jan 2023 17:06:38 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + task_mmu-convert-to-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230121010638.A7663C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: task_mmu: convert to vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     task_mmu-convert-to-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_mmu-convert-to-vma-iterator.patch

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
Subject: task_mmu: convert to vma iterator
Date: Fri, 20 Jan 2023 11:26:22 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Update the comments to how the vma iterator works.  The vma iterator will
keep track of the last vm_end and start the search from vm_end + 1.

Link: https://lkml.kernel.org/r/20230120162650.984577-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/task_mmu.c~task_mmu-convert-to-vma-iterator
+++ a/fs/proc/task_mmu.c
@@ -892,7 +892,7 @@ static int show_smaps_rollup(struct seq_
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
@@ -910,7 +910,7 @@ static int show_smaps_rollup(struct seq_
 		goto out_put_mm;
 
 	hold_task_mempolicy(priv);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma = vma_next(&vmi);
 
 	if (unlikely(!vma))
 		goto empty_set;
@@ -925,7 +925,7 @@ static int show_smaps_rollup(struct seq_
 		 * access it for write request.
 		 */
 		if (mmap_lock_is_contended(mm)) {
-			mas_pause(&mas);
+			vma_iter_invalidate(&vmi);
 			mmap_read_unlock(mm);
 			ret = mmap_read_lock_killable(mm);
 			if (ret) {
@@ -950,31 +950,31 @@ static int show_smaps_rollup(struct seq_
 			 *
 			 * 1) VMA2 is freed, but VMA3 exists:
 			 *
-			 *    find_vma(mm, 16k - 1) will return VMA3.
+			 *    vma_next(vmi) will return VMA3.
 			 *    In this case, just continue from VMA3.
 			 *
 			 * 2) VMA2 still exists:
 			 *
-			 *    find_vma(mm, 16k - 1) will return VMA2.
-			 *    Iterate the loop like the original one.
+			 *    vma_next(vmi) will return VMA3.
+			 *    In this case, just continue from VMA3.
 			 *
 			 * 3) No more VMAs can be found:
 			 *
-			 *    find_vma(mm, 16k - 1) will return NULL.
+			 *    vma_next(vmi) will return NULL.
 			 *    No more things to do, just break.
 			 *
 			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
 			 *
-			 *    find_vma(mm, 16k - 1) will return VMA' whose range
+			 *    vma_next(vmi) will return VMA' whose range
 			 *    contains last_vma_end.
 			 *    Iterate VMA' from last_vma_end.
 			 */
-			vma = mas_find(&mas, ULONG_MAX);
+			vma = vma_next(&vmi);
 			/* Case 3 above */
 			if (!vma)
 				break;
 
-			/* Case 1 above */
+			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end)
 				continue;
 
@@ -982,8 +982,7 @@ static int show_smaps_rollup(struct seq_
 			if (vma->vm_end > last_vma_end)
 				smap_gather_stats(vma, &mss, last_vma_end);
 		}
-		/* Case 2 above */
-	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
+	} for_each_vma(vmi, vma);
 
 empty_set:
 	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
@@ -1279,7 +1278,7 @@ static ssize_t clear_refs_write(struct f
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
-		MA_STATE(mas, &mm->mm_mt, 0, 0);
+		VMA_ITERATOR(vmi, mm, 0);
 		struct mmu_notifier_range range;
 		struct clear_refs_private cp = {
 			.type = type,
@@ -1299,7 +1298,7 @@ static ssize_t clear_refs_write(struct f
 		}
 
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
-			mas_for_each(&mas, vma, ULONG_MAX) {
+			for_each_vma(vmi, vma) {
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
 				vma->vm_flags &= ~VM_SOFTDIRTY;
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

