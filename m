Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BB8C64ED9
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjB0WGx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjB0WGb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E06F265AE
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC52CCE107B
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E16C433EF;
        Mon, 27 Feb 2023 22:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535584;
        bh=xXgTmc/QYAYKgmdrje4HbwSyVRNxUUWYDSCTJPV1bBQ=;
        h=Date:To:From:Subject:From;
        b=AhkX3fHzqrAphJIyjeDfBacoyXSAeXKntKJz1eISFdLyo4gkeR32atvIT9wi5CuYd
         0gvASkRenbehdasnkoRpqCP5O6hMoI4chY6dw95Yd3R1n1VPPUgHm9IHE+zE1igX9i
         8BUiRIMZXFue+ptK6avAW35XHB15sA99XIftJR7E=
Date:   Mon, 27 Feb 2023 14:06:23 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch added to mm-unstable branch
Message-Id: <20230227220624.06E16C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: write-lock VMAs in vma_prepare before modifying them
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch

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
Subject: mm/mmap: write-lock VMAs in vma_prepare before modifying them
Date: Mon, 27 Feb 2023 09:36:15 -0800

Write-lock all VMAs which might be affected by a merge, split, expand or
shrink operations.  All these operations use vma_prepare() before making
the modifications, therefore it provides a centralized place to perform
VMA locking.

Link: https://lkml.kernel.org/r/20230227173632.3292573-17-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them
+++ a/mm/mmap.c
@@ -502,6 +502,16 @@ static inline void init_vma_prep(struct
  */
 static inline void vma_prepare(struct vma_prepare *vp)
 {
+	if (vp->vma)
+		vma_start_write(vp->vma);
+	if (vp->adj_next)
+		vma_start_write(vp->adj_next);
+	/* vp->insert is always a newly created VMA, no need for locking */
+	if (vp->remove)
+		vma_start_write(vp->remove);
+	if (vp->remove2)
+		vma_start_write(vp->remove2);
+
 	if (vp->file) {
 		uprobe_munmap(vp->vma, vp->vma->vm_start, vp->vma->vm_end);
 
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

