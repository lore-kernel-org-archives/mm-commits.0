Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C434DC7EE30
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjB0WHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjB0WGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B98B28879
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7295CE1142
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62FEC433A0;
        Mon, 27 Feb 2023 22:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535595;
        bh=2Y+MGv/8Qw33DQHoFGiuCv5vEDky2T0pFgaHxAPJtl4=;
        h=Date:To:From:Subject:From;
        b=nRiTGQDE6gd1AsIZO2/UA9Tl/GapXe+pujIurV2tjyg450ymj2VsL7CGUbUQrF8+6
         +MLfrMaSrKkbQ9/cUjifjx94OUWxsw5lRPhw3MKSQ+kfrINy+ffl7/3LTgBObBun8S
         fhmDaJ/pZzlUn+l6LaVD/I0ef/9FR27+Qatv9xRM=
Date:   Mon, 27 Feb 2023 14:06:34 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma-detached-flag.patch added to mm-unstable branch
Message-Id: <20230227220634.E62FEC433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce vma detached flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma-detached-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma-detached-flag.patch

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
Subject: mm: introduce vma detached flag
Date: Mon, 27 Feb 2023 09:36:21 -0800

Per-vma locking mechanism will search for VMA under RCU protection and
then after locking it, has to ensure it was not removed from the VMA tree
after we found it.  To make this check efficient, introduce a
vma->detached flag to mark VMAs which were removed from the VMA tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-23-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-introduce-vma-detached-flag
+++ a/include/linux/mm.h
@@ -693,6 +693,14 @@ static inline void vma_assert_write_lock
 	VM_BUG_ON_VMA(vma->vm_lock_seq != READ_ONCE(vma->vm_mm->mm_lock_seq), vma);
 }
 
+static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
+{
+	/* When detaching vma should be write-locked */
+	if (detached)
+		vma_assert_write_locked(vma);
+	vma->detached = detached;
+}
+
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_init_lock(struct vm_area_struct *vma) {}
@@ -701,6 +709,8 @@ static inline bool vma_start_read(struct
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
+static inline void vma_mark_detached(struct vm_area_struct *vma,
+				     bool detached) {}
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
@@ -712,6 +722,7 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+	vma_mark_detached(vma, false);
 	vma_init_lock(vma);
 }
 
--- a/include/linux/mm_types.h~mm-introduce-vma-detached-flag
+++ a/include/linux/mm_types.h
@@ -511,6 +511,9 @@ struct vm_area_struct {
 #ifdef CONFIG_PER_VMA_LOCK
 	int vm_lock_seq;
 	struct rw_semaphore lock;
+
+	/* Flag to indicate areas detached from the mm->mm_mt tree */
+	bool detached;
 #endif
 
 	/*
--- a/mm/mmap.c~mm-introduce-vma-detached-flag
+++ a/mm/mmap.c
@@ -600,6 +600,7 @@ static inline void vma_complete(struct v
 
 	if (vp->remove) {
 again:
+		vma_mark_detached(vp->remove, true);
 		if (vp->file) {
 			uprobe_munmap(vp->remove, vp->remove->vm_start,
 				      vp->remove->vm_end);
@@ -2261,6 +2262,7 @@ static inline int munmap_sidetree(struct
 	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
 		return -ENOMEM;
 
+	vma_mark_detached(vma, true);
 	if (vma->vm_flags & VM_LOCKED)
 		vma->vm_mm->locked_vm -= vma_pages(vma);
 
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

