Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E9EC38141
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjAUBH2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjAUBHM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFBC73ED4
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B930BCE1F9A
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC62C433EF;
        Sat, 21 Jan 2023 01:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263225;
        bh=Z0wBTXPciiyOtu+j45mxJ1AMxk7+IjEjqjmiLuCTKHo=;
        h=Date:To:From:Subject:From;
        b=RHf8p/ykIxEjVEzAW8wNu/FhisLwqdRJqRgOkXcw7TbJosyiq2NEpIq2KUoKKGiNW
         /VT8TtOyc+jSvyQwLn5uNjO7NAUzJKwHUOqIKWMKifc5U0BT0yFIJtybjK65DfocuK
         t0ImNOq7bKVkzaOGpY0MyWY62XYFiudmQuZAKHkY=
Date:   Fri, 20 Jan 2023 17:07:04 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-vma-iterator-through-to-__vma_adjust.patch added to mm-unstable branch
Message-Id: <20230121010704.EBC62C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass vma iterator through to __vma_adjust()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-vma-iterator-through-to-__vma_adjust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-vma-iterator-through-to-__vma_adjust.patch

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
Subject: mm: pass vma iterator through to __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:36 -0500

Pass the iterator through to be used in __vma_adjust().  The state of the
iterator needs to be correct for the operation that will occur so make the
adjustments.

Link: https://lkml.kernel.org/r/20230120162650.984577-36-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-pass-vma-iterator-through-to-__vma_adjust
+++ a/mm/mmap.c
@@ -528,6 +528,10 @@ inline int vma_expand(struct vma_iterato
 		vma_interval_tree_remove(vma, root);
 	}
 
+	/* VMA iterator points to previous, so set to start if necessary */
+	if (vma_iter_addr(vmi) != start)
+		vma_iter_set(vmi, start);
+
 	vma->vm_start = start;
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
@@ -2167,13 +2171,13 @@ static void unmap_region(struct mm_struc
 /*
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
  * has already been checked or doesn't make sense to fail.
+ * VMA Iterator will point to the end VMA.
  */
 int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
 	int err;
-	unsigned long end = vma->vm_end;
 
 	validate_mm_mt(vma->vm_mm);
 
@@ -2209,14 +2213,17 @@ int __split_vma(struct vma_iterator *vmi
 		new->vm_ops->open(new);
 
 	if (new_below)
-		err = vma_adjust(vma, addr, vma->vm_end, vma->vm_pgoff +
-			((addr - new->vm_start) >> PAGE_SHIFT), new);
+		err = __vma_adjust(vmi, vma, addr, vma->vm_end,
+		   vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
+		   new, NULL);
 	else
-		err = vma_adjust(vma, vma->vm_start, addr, vma->vm_pgoff, new);
+		err = __vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
+				 new, NULL);
 
 	/* Success. */
 	if (!err) {
-		vma_iter_set(vmi, end);
+		if (new_below)
+			vma_next(vmi);
 		return 0;
 	}
 
@@ -2311,8 +2318,7 @@ do_vmi_align_munmap(struct vma_iterator
 		if (error)
 			goto start_split_failed;
 
-		vma_iter_set(vmi, start);
-		vma = vma_find(vmi, end);
+		vma = vma_iter_load(vmi);
 	}
 
 	prev = vma_prev(vmi);
@@ -2332,7 +2338,6 @@ do_vmi_align_munmap(struct vma_iterator
 			if (error)
 				goto end_split_failed;
 
-			vma_iter_set(vmi, end);
 			split = vma_prev(vmi);
 			error = munmap_sidetree(split, &mas_detach);
 			if (error)
@@ -2576,6 +2581,7 @@ cannot_expand:
 		goto unacct_error;
 	}
 
+	vma_iter_set(&vmi, addr);
 	vma->vm_start = addr;
 	vma->vm_end = end;
 	vma->vm_flags = vm_flags;
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

