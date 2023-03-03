Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4879FC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjCCCQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCCQC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:16:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D3639BBD
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 307696170E
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824D3C433D2;
        Fri,  3 Mar 2023 02:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809759;
        bh=se5DsEhD2yKnneXP3WiDdzzOZOTmtyf7RTce+RgN00k=;
        h=Date:To:From:Subject:From;
        b=J3yCSLc/AjmJoOygBePPs6xsiXUcsItazGgEyZtreywiSTzDBb9InHPcMe6W4ZIJo
         uwyMQACgCG97wK5vW7X3XtCQDNccqXertlHxSjq0EMMAsZXsRcAOddaiWZnIXPJLoO
         +PYqW8+QjeTo1gbGa5WecnMY40/O9g9/CEpqTf8Y=
Date:   Thu, 02 Mar 2023 18:15:58 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, 42.hyeyoo@gmail.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch added to mm-unstable branch
Message-Id: <20230303021559.824D3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: remove unnecessary VMA locking
has been added to the -mm mm-unstable branch.  Its filename is
     mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch

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
Subject: mm/nommu: remove unnecessary VMA locking
Date: Wed, 1 Mar 2023 11:04:57 -0800

Since CONFIG_PER_VMA_LOCK depends on CONFIG_MMU, the changes in nommu are
not needed.  Remove them.

Link: https://lkml.kernel.org/r/20230301190457.1498985-1-surenb@google.com
Fixes: bad94decd6a4 ("mm: write-lock VMAs before removing them from VMA tree")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
  Link: https://lore.kernel.org/all/Y%2F8CJQGNuMUTdLwP@localhost/
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/nommu.c~mm-write-lock-vmas-before-removing-them-from-vma-tree-fix
+++ a/mm/nommu.c
@@ -588,7 +588,6 @@ static int delete_vma_from_mm(struct vm_
 		       current->pid);
 		return -ENOMEM;
 	}
-	vma_start_write(vma);
 	cleanup_vma_from_mm(vma);
 
 	/* remove from the MM's tree and list */
@@ -1520,10 +1519,6 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
-		/*
-		 * No need to lock VMA because this is the only mm user and no
-		 * page fault handled can race with it.
-		 */
 		cleanup_vma_from_mm(vma);
 		delete_vma(mm, vma);
 		cond_resched();
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
mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch
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

