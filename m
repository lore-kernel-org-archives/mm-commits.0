Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D4CC64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjB0WGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjB0WGX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827FB298E9
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DDAB60F12
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799EAC433EF;
        Mon, 27 Feb 2023 22:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535580;
        bh=89l2V8EmgaBAvT7YMAvV0hle9r5MOv/+C8BNehfiXqY=;
        h=Date:To:From:Subject:From;
        b=YUHrDvsP+IDAdp5U0VcmSsHmezByT2iORomRDbc3MODFgjkIoBBuM8VprzIoGkhC9
         abQseGDVmJKesXx/A2v8xUoe8clOZiiOtbu9G1gGTxTdyydEgmi56wXPLVaANN2KF1
         RsXxk4qYmC5iE3dVAGlssbhSlr5LROINuGon+B0Q=
Date:   Mon, 27 Feb 2023 14:06:19 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch added to mm-unstable branch
Message-Id: <20230227220620.799EAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: move vma_prepare before vma_adjust_trans_huge
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mmap: move vma_prepare before vma_adjust_trans_huge
Date: Mon, 27 Feb 2023 09:36:13 -0800

vma_prepare() acquires all locks required before VMA modifications.  Move
vma_prepare() before vma_adjust_trans_huge() so that VMA is locked before
any modification.

Link: https://lkml.kernel.org/r/20230227173632.3292573-15-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge
+++ a/mm/mmap.c
@@ -683,12 +683,12 @@ int vma_expand(struct vma_iterator *vmi,
 	if (vma_iter_prealloc(vmi))
 		goto nomem;
 
+	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, 0);
 	/* VMA iterator points to previous, so set to start if necessary */
 	if (vma_iter_addr(vmi) != start)
 		vma_iter_set(vmi, start);
 
-	vma_prepare(&vp);
 	vma->vm_start = start;
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
@@ -723,8 +723,8 @@ int vma_shrink(struct vma_iterator *vmi,
 		return -ENOMEM;
 
 	init_vma_prep(&vp, vma);
-	vma_adjust_trans_huge(vma, start, end, 0);
 	vma_prepare(&vp);
+	vma_adjust_trans_huge(vma, start, end, 0);
 
 	if (vma->vm_start < start)
 		vma_iter_clear(vmi, vma->vm_start, start);
@@ -994,12 +994,12 @@ struct vm_area_struct *vma_merge(struct
 	if (vma_iter_prealloc(vmi))
 		return NULL;
 
-	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_next);
 	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
 		   vp.anon_vma != adjust->anon_vma);
 
 	vma_prepare(&vp);
+	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_next);
 	if (vma_start < vma->vm_start || vma_end > vma->vm_end)
 		vma_expanded = true;
 
@@ -2198,10 +2198,10 @@ int __split_vma(struct vma_iterator *vmi
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
+	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
 
 	if (new_below) {
 		vma->vm_start = addr;
@@ -2910,9 +2910,9 @@ static int do_brk_flags(struct vma_itera
 		if (vma_iter_prealloc(vmi))
 			goto unacct_fail;
 
-		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		init_vma_prep(&vp, vma);
 		vma_prepare(&vp);
+		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		vma->vm_end = addr + len;
 		vm_flags_set(vma, VM_SOFTDIRTY);
 		vma_iter_store(vmi, vma);
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-config_per_vma_lock.patch
mm-move-mmap_lock-assert-function-definitions.patch
mm-add-per-vma-lock-and-helper-functions-to-control-it.patch
mm-mark-vma-as-being-written-when-changing-vm_flags.patch
mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch
mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree.patch
mm-conditionally-write-lock-vma-in-free_pgtables.patch
kernel-fork-assert-no-vma-readers-during-its-destruction.patch
mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch
mm-introduce-vma-detached-flag.patch
mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch
mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch
mm-add-fault_flag_vma_lock-flag.patch
mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch
mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch
mm-introduce-per-vma-lock-statistics.patch
x86-mm-try-vma-lock-based-page-fault-handling-first.patch
arm64-mm-try-vma-lock-based-page-fault-handling-first.patch
mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch
mm-separate-vma-lock-from-vm_area_struct.patch
per-vma-locks.patch

