Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91184C64ED9
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjB0WHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjB0WGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D557298EC
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1FC960F12
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237E3C433EF;
        Mon, 27 Feb 2023 22:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535599;
        bh=EEEF1pxB8jVdVebdBFXPNJo0n1e5fztu2HB1Os4B7Ps=;
        h=Date:To:From:Subject:From;
        b=MkrSI5G3Tv9p/7WrMNaS/rSrOjiHP279t7InmxgnyUUQPbv/d/jNcnZee/8Jp6mWC
         Tztvb8XeD0f4UzSvQ0kRUSfl8ys+SeHjbZFiHoZ3NxBUXgv9SLS9ayY3O0f6zvx862
         oIQC+BPZ8d7YDVq0IPUI4qEYfDp9oRgGTgzpxJeA=
Date:   Mon, 27 Feb 2023 14:06:38 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch added to mm-unstable branch
Message-Id: <20230227220639.237E3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fall back to mmap_lock if vma->anon_vma is not yet set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch

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
Subject: mm: fall back to mmap_lock if vma->anon_vma is not yet set
Date: Mon, 27 Feb 2023 09:36:23 -0800

When vma->anon_vma is not set, page fault handler will set it by either
reusing anon_vma of an adjacent VMA if VMAs are compatible or by
allocating a new one.  find_mergeable_anon_vma() walks VMA tree to find a
compatible adjacent VMA and that requires not only the faulting VMA to be
stable but also the tree structure and other VMAs inside that tree. 
Therefore locking just the faulting VMA is not enough for this search. 
Fall back to taking mmap_lock when vma->anon_vma is not set.  This
situation happens only on the first page fault and should not affect
overall performance.

Link: https://lkml.kernel.org/r/20230227173632.3292573-25-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set
+++ a/mm/memory.c
@@ -5243,6 +5243,10 @@ retry:
 	if (!vma_is_anonymous(vma))
 		goto inval;
 
+	/* find_mergeable_anon_vma uses adjacent vmas which are not locked */
+	if (!vma->anon_vma)
+		goto inval;
+
 	if (!vma_start_read(vma))
 		goto inval;
 
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

