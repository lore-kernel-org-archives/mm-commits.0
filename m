Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B7AC7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjB0WHV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjB0WG5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C5A298FD
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8DB160F2E
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29573C433D2;
        Mon, 27 Feb 2023 22:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535615;
        bh=QMojpJenmQAXseUngZ7uj8qnTUV/XN/nA1+Av1vel3I=;
        h=Date:To:From:Subject:From;
        b=ri3IPha81S38uOk5aqnA2WbKp2NaifyMkUUHaNGNKCyXTyIDso2QifzmYVuu+V0Mx
         LRh/MlTCcPsBJmRr6q77jESKicKThNc1ABqbqBk6hKR/YTtn9p7z2FW2d0vHmxxG7V
         dwbzQREcpJ4IvOKOcXGq+DQPYqGzrCHvYYMTvtys=
Date:   Mon, 27 Feb 2023 14:06:54 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch added to mm-unstable branch
Message-Id: <20230227220655.29573C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: free vm_area_struct without call_rcu in exit_mmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch

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
Subject: mm/mmap: free vm_area_struct without call_rcu in exit_mmap
Date: Mon, 27 Feb 2023 09:36:31 -0800

call_rcu() can take a long time when callback offloading is enabled.  Its
use in the vm_area_free can cause regressions in the exit path when
multiple VMAs are being freed.

Because exit_mmap() is called only after the last mm user drops its
refcount, the page fault handlers can't be racing with it.  Any other
possible user like oom-reaper or process_mrelease are already synchronized
using mmap_lock.  Therefore exit_mmap() can free VMAs directly, without
the use of call_rcu().

Expose __vm_area_free() and use it from exit_mmap() to avoid possible
call_rcu() floods and performance regressions caused by it.

Link: https://lkml.kernel.org/r/20230227173632.3292573-33-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap
+++ a/include/linux/mm.h
@@ -256,6 +256,8 @@ void setup_initial_init_mm(void *start_c
 struct vm_area_struct *vm_area_alloc(struct mm_struct *);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *);
 void vm_area_free(struct vm_area_struct *);
+/* Use only if VMA has no other users */
+void __vm_area_free(struct vm_area_struct *vma);
 
 #ifndef CONFIG_MMU
 extern struct rb_root nommu_region_tree;
--- a/kernel/fork.c~mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap
+++ a/kernel/fork.c
@@ -480,7 +480,7 @@ struct vm_area_struct *vm_area_dup(struc
 	return new;
 }
 
-static void __vm_area_free(struct vm_area_struct *vma)
+void __vm_area_free(struct vm_area_struct *vma)
 {
 	free_anon_vma_name(vma);
 	kmem_cache_free(vm_area_cachep, vma);
--- a/mm/mmap.c~mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap
+++ a/mm/mmap.c
@@ -133,7 +133,7 @@ void unlink_file_vma(struct vm_area_stru
 /*
  * Close a vm structure and free it.
  */
-static void remove_vma(struct vm_area_struct *vma)
+static void remove_vma(struct vm_area_struct *vma, bool unreachable)
 {
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
@@ -141,7 +141,10 @@ static void remove_vma(struct vm_area_st
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
-	vm_area_free(vma);
+	if (unreachable)
+		__vm_area_free(vma);
+	else
+		vm_area_free(vma);
 }
 
 static inline struct vm_area_struct *vma_prev_limit(struct vma_iterator *vmi,
@@ -2130,7 +2133,7 @@ static inline void remove_mt(struct mm_s
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += nrpages;
 		vm_stat_account(mm, vma->vm_flags, -nrpages);
-		remove_vma(vma);
+		remove_vma(vma, false);
 	}
 	vm_unacct_memory(nr_accounted);
 	validate_mm(mm);
@@ -3070,7 +3073,7 @@ void exit_mmap(struct mm_struct *mm)
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
-		remove_vma(vma);
+		remove_vma(vma, true);
 		count++;
 		cond_resched();
 	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
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

