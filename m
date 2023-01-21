Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9A2C38A23
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjAUBH2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjAUBHM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3719E73ED7
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA335620DC
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28419C433EF;
        Sat, 21 Jan 2023 01:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263229;
        bh=IgfPeVizrJEg5wdNPkI/cRTqS/q/LacX/V6MR0JP2rA=;
        h=Date:To:From:Subject:From;
        b=Crz2QT0crU+L2W4H8G8CSqZcJEiucr5tGki5RpM0iD9q/lHkOi+ra2LCC1+ek0Sbp
         a5c+eKtWsN1sTRwCAUn2peoc9yNOlOr3qVcBUzxBRAC1OnKHBjnYCWM6iMRMWXliSh
         GkPUdgg0mFSw5pSGr8c+2vuR3hnYn2LDmZmOIxoE=
Date:   Fri, 20 Jan 2023 17:07:08 -0800
To:     mm-commits@vger.kernel.org, lizetao1@huawei.com,
        Liam.Howlett@oracle.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-clean-up-mmap_region-unrolling.patch added to mm-unstable branch
Message-Id: <20230121010709.28419C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: clean up mmap_region() unrolling
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-clean-up-mmap_region-unrolling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-clean-up-mmap_region-unrolling.patch

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
Subject: mmap: clean up mmap_region() unrolling
Date: Fri, 20 Jan 2023 11:26:38 -0500

Move logic of unrolling to the error path as apposed to duplicating it
within the function body.  This reduces the potential of missing an update
to one path when making changes.

Link: https://lkml.kernel.org/r/20230120162650.984577-38-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mmap-clean-up-mmap_region-unrolling
+++ a/mm/mmap.c
@@ -2604,12 +2604,11 @@ cannot_expand:
 		 * Expansion is handled above, merging is handled below.
 		 * Drivers should not alter the address of the VMA.
 		 */
-		if (WARN_ON((addr != vma->vm_start))) {
-			error = -EINVAL;
+		error = -EINVAL;
+		if (WARN_ON((addr != vma->vm_start)))
 			goto close_and_free_vma;
-		}
-		vma_iter_set(&vmi, addr);
 
+		vma_iter_set(&vmi, addr);
 		/*
 		 * If vm_flags changed after call_mmap(), we should try merge
 		 * vma again as we may succeed this time.
@@ -2656,25 +2655,13 @@ cannot_expand:
 	}
 
 	/* Allow architectures to sanity-check the vm_flags */
-	if (!arch_validate_flags(vma->vm_flags)) {
-		error = -EINVAL;
-		if (file)
-			goto close_and_free_vma;
-		else if (vma->vm_file)
-			goto unmap_and_free_vma;
-		else
-			goto free_vma;
-	}
-
-	if (vma_iter_prealloc(&vmi)) {
-		error = -ENOMEM;
-		if (file)
-			goto close_and_free_vma;
-		else if (vma->vm_file)
-			goto unmap_and_free_vma;
-		else
-			goto free_vma;
-	}
+	error = -EINVAL;
+	if (!arch_validate_flags(vma->vm_flags))
+		goto close_and_free_vma;
+
+	error = -ENOMEM;
+	if (vma_iter_prealloc(&vmi))
+		goto close_and_free_vma;
 
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
@@ -2733,14 +2720,18 @@ expanded:
 	return addr;
 
 close_and_free_vma:
-	if (vma->vm_ops && vma->vm_ops->close)
+	if (file && vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
+
+	if (file || vma->vm_file) {
 unmap_and_free_vma:
-	fput(vma->vm_file);
-	vma->vm_file = NULL;
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
 
-	/* Undo any partial mapping done by a device driver. */
-	unmap_region(mm, &mm->mm_mt, vma, prev, next, vma->vm_start, vma->vm_end);
+		/* Undo any partial mapping done by a device driver. */
+		unmap_region(mm, &mm->mm_mt, vma, prev, next, vma->vm_start,
+			     vma->vm_end);
+	}
 	if (file && (vm_flags & VM_SHARED))
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
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

