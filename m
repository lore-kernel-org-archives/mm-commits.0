Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AE3C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbjDFC6s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjDFC6r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:58:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB63D6598
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5802664125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD29DC433D2;
        Thu,  6 Apr 2023 02:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749925;
        bh=Lztus5CZngRA/yQCWZ4GvXY1PDdKRhBjpYZ/boeNs2g=;
        h=Date:To:From:Subject:From;
        b=gq5ne+9VDleLwmUX6480nUjIvRQV9AkrtVwjGsSndqXBRTq4bgLbAN3fHOyihrNQ1
         cYOalNCpCM9LxsaaofMG+con18/8Q9Ml/ynIT95DZHzo8L1EaDdVCYURVIPy81sJVL
         sJAINvNnKgfFMDVof48XUZZonheEjzz4N3xUlQhY=
Date:   Wed, 05 Apr 2023 19:58:45 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, 42.hyeyoo@gmail.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch removed from -mm tree
Message-Id: <20230406025845.AD29DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/nommu: remove unnecessary VMA locking
has been removed from the -mm tree.  Its filename was
     mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch

This patch was dropped because it was folded into mm-write-lock-vmas-before-removing-them-from-vma-tree.patch

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

 mm/nommu.c |    5 -----
 1 file changed, 5 deletions(-)

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

