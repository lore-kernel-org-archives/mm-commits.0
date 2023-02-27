Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9753CC64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjB0WHD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjB0WGb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262EB26CC8
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D21E1B80DBF
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866E3C433D2;
        Mon, 27 Feb 2023 22:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535587;
        bh=vh/j3gPtoVuqdbCQjwRFRI8oEsAen+GdpoD9zO9EDkg=;
        h=Date:To:From:Subject:From;
        b=JHJTmRHhlmwFDMR1pkM6rhgkH963s7MotJ802Ko9cjgkwmd5eB0snxSZKCO/UR8fZ
         Rk6sQ0YiRv6S+v3QNhPBOgZKuQtmx1X3PTJrw+XC4m/yhSe0ENwsVZWJpkAQvLJBzm
         WqeTlI9gDNqTT/61ThGePqiNPjBaj7L674KPUlKw=
Date:   Mon, 27 Feb 2023 14:06:27 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-write-lock-vmas-before-removing-them-from-vma-tree.patch added to mm-unstable branch
Message-Id: <20230227220627.866E3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: write-lock VMAs before removing them from VMA tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-write-lock-vmas-before-removing-them-from-vma-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-write-lock-vmas-before-removing-them-from-vma-tree.patch

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
Subject: mm: write-lock VMAs before removing them from VMA tree
Date: Mon, 27 Feb 2023 09:36:17 -0800

Write-locking VMAs before isolating them ensures that page fault handlers
don't operate on isolated VMAs.

Link: https://lkml.kernel.org/r/20230227173632.3292573-19-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-write-lock-vmas-before-removing-them-from-vma-tree
+++ a/mm/mmap.c
@@ -2255,6 +2255,7 @@ int split_vma(struct vma_iterator *vmi,
 static inline int munmap_sidetree(struct vm_area_struct *vma,
 				   struct ma_state *mas_detach)
 {
+	vma_start_write(vma);
 	mas_set_range(mas_detach, vma->vm_start, vma->vm_end - 1);
 	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
 		return -ENOMEM;
--- a/mm/nommu.c~mm-write-lock-vmas-before-removing-them-from-vma-tree
+++ a/mm/nommu.c
@@ -588,6 +588,7 @@ static int delete_vma_from_mm(struct vm_
 		       current->pid);
 		return -ENOMEM;
 	}
+	vma_start_write(vma);
 	cleanup_vma_from_mm(vma);
 
 	/* remove from the MM's tree and list */
@@ -1519,6 +1520,10 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
+		/*
+		 * No need to lock VMA because this is the only mm user and no
+		 * page fault handled can race with it.
+		 */
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

