Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6C5C678DB
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 23:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCDX3B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 18:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCDX3A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 18:29:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E45BEB78
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 15:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3967FB802C5
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 23:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD36BC433D2;
        Sat,  4 Mar 2023 23:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677972536;
        bh=quExMn9VrcTyBDQH+aQTW2nID1IK5TLHHCu4VrVe8qg=;
        h=Date:To:From:Subject:From;
        b=WQwfd9rrBkovsKzFipPgvlNcUjZL2/uAUHaY5tX06mdiPmukO/BM9iA7+Sv3zdb2T
         ROWnCL/Vrd2fdfarD2zmdoPhLS/fq+TNG4sKhFA8zroX0W/72yLZylVIVBB2Zkkod4
         e7MvBaT/+oRKVQ3QqbFkdXY95m3hzRCoNBv/RRJ8=
Date:   Sat, 04 Mar 2023 15:28:56 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch added to mm-unstable branch
Message-Id: <20230304232856.DD36BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch

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
Subject: txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix
Date: Sat, 4 Mar 2023 15:24:15 -0800

I missed vma_try_start_write() definition for CONFIG_PER_VMA_LOCK=n
configuration.

Link: https://lkml.kernel.org/r/CAJuCfpFjWhtzRE1X=J+_JjgJzNKhq-=JT8yTBSTHthwp0pqWZw@mail.gmail.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix
+++ a/include/linux/mm.h
@@ -717,6 +717,8 @@ static inline bool vma_start_read(struct
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline bool vma_try_start_write(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
 
 #endif /* CONFIG_PER_VMA_LOCK */
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-config_per_vma_lock.patch
mm-move-mmap_lock-assert-function-definitions.patch
mm-add-per-vma-lock-and-helper-functions-to-control-it.patch
mm-mark-vma-as-being-written-when-changing-vm_flags.patch
mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix.patch
txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix.patch
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
mm-add-fault_flag_vma_lock-flag-fix.patch
mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch
mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch
mm-introduce-per-vma-lock-statistics.patch
x86-mm-try-vma-lock-based-page-fault-handling-first.patch
arm64-mm-try-vma-lock-based-page-fault-handling-first.patch
mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch
mm-separate-vma-lock-from-vm_area_struct.patch

