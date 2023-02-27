Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBCFC64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjB0WHJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjB0WGs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03070298F0
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFA9FB80DC3
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580EFC433EF;
        Mon, 27 Feb 2023 22:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535604;
        bh=fRoxlDZ11JgyrNqbumozKZYRxTPoXm3f/e63BN+TrsQ=;
        h=Date:To:From:Subject:From;
        b=qHSfNDn27pZRCTGrsc/gWVb/CkQraLVP4xx97oOJjIJhZIULZJe21si+56WbZFsOo
         qCfxmg9M73LQIDYh8Oj0G9Gd2Jw37gI/WHIeY/zCvdq83rqlfliuVkZGmI7ALxrAQr
         TQTZv0h5Y38ZGdWhDCeVjlbtpUkUli8qmPpbAxao=
Date:   Mon, 27 Feb 2023 14:06:43 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch added to mm-unstable branch
Message-Id: <20230227220644.580EFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent userfaults to be handled under per-vma lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch

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
Subject: mm: prevent userfaults to be handled under per-vma lock
Date: Mon, 27 Feb 2023 09:36:26 -0800

Due to the possibility of handle_userfault dropping mmap_lock, avoid fault
handling under VMA lock and retry holding mmap_lock.  This can be handled
more gracefully in the future.

Link: https://lkml.kernel.org/r/20230227173632.3292573-28-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-prevent-userfaults-to-be-handled-under-per-vma-lock
+++ a/mm/memory.c
@@ -5255,6 +5255,15 @@ retry:
 	if (!vma_start_read(vma))
 		goto inval;
 
+	/*
+	 * Due to the possibility of userfault handler dropping mmap_lock, avoid
+	 * it for now and fall back to page fault handling under mmap_lock.
+	 */
+	if (userfaultfd_armed(vma)) {
+		vma_end_read(vma);
+		goto inval;
+	}
+
 	/* Check since vm_start/vm_end might change before we lock the VMA */
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
 		vma_end_read(vma);
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

