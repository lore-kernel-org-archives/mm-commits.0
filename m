Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F6BC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjAFAhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbjAFAgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508CD50F4A
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E155D61C39
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43305C433D2;
        Fri,  6 Jan 2023 00:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965364;
        bh=4RNUedmW73V1uSk+tmTHJY28Q/i8XWqOP9930Z1OrBI=;
        h=Date:To:From:Subject:From;
        b=gdygZxnt9heic8RVCIBDLXskqrxZlqyvrV7QtFENsqDu6fs6rYcCtG6xvDcE7hr3A
         cubD0GXzpcz0yhU6uemYB1U2RXQCfG/Vwe9/b17y/W5NB8kdFE5EKZ/BH3A9gTKxyR
         LHxYXUqvA+FOxfN9zXE6YhgcvZlhk0G1NPWNG63M=
Date:   Thu, 05 Jan 2023 16:36:03 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vma-iterator-to-vma_adjust-arguments.patch added to mm-unstable branch
Message-Id: <20230106003604.43305C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vma iterator to vma_adjust() arguments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-vma-iterator-to-vma_adjust-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vma-iterator-to-vma_adjust-arguments.patch

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
Subject: mm: add vma iterator to vma_adjust() arguments
Date: Thu, 5 Jan 2023 19:16:02 +0000

Change the vma_adjust() function definition to accept the vma iterator
and pass it through to __vma_adjust().

Update fs/exec to use the new vma_adjust() function parameters.

Revert the __split_vma() calls back from __vma_adjust() to vma_adjust()
and pass through the vma iterator.

Link: https://lkml.kernel.org/r/20230105191517.3099082-33-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |   11 ++++-------
 include/linux/mm.h |    9 ++++-----
 mm/mmap.c          |   10 +++++-----
 3 files changed, 13 insertions(+), 17 deletions(-)

--- a/fs/exec.c~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/fs/exec.c
@@ -699,7 +699,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL))
+	if (vma_adjust(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
 		return -ENOMEM;
 
 	/*
@@ -731,12 +731,9 @@ static int shift_arg_pages(struct vm_are
 	}
 	tlb_finish_mmu(&tlb);
 
-	/*
-	 * Shrink the vma to just the new range.  Always succeeds.
-	 */
-	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
-
-	return 0;
+	vma_prev(&vmi);
+	/* Shrink the vma to just the new range */
+	return vma_adjust(&vmi, vma, new_start, new_end, vma->vm_pgoff, NULL);
 }
 
 /*
--- a/include/linux/mm.h~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/include/linux/mm.h
@@ -2810,12 +2810,11 @@ extern int __vm_enough_memory(struct mm_
 extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
 	struct vm_area_struct *expand);
-static inline int vma_adjust(struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
+static inline int vma_adjust(struct vma_iterator *vmi,
+	struct vm_area_struct *vma, unsigned long start, unsigned long end,
+	pgoff_t pgoff, struct vm_area_struct *insert)
 {
-	VMA_ITERATOR(vmi, vma->vm_mm, start);
-
-	return __vma_adjust(&vmi, vma, start, end, pgoff, insert, NULL);
+	return __vma_adjust(vmi, vma, start, end, pgoff, insert, NULL);
 }
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
--- a/mm/mmap.c~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/mm/mmap.c
@@ -2272,12 +2272,12 @@ int __split_vma(struct vma_iterator *vmi
 		new->vm_ops->open(new);
 
 	if (new_below)
-		err = __vma_adjust(vmi, vma, addr, vma->vm_end,
-		   vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
-		   new, NULL);
+		err = vma_adjust(vmi, vma, addr, vma->vm_end,
+			vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
+			new);
 	else
-		err = __vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
-				 new, NULL);
+		err = vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
+				 new);
 
 	/* Success. */
 	if (!err) {
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

