Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6DFC7EE31
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjB0WHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjB0WGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8E729423
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7248CB80D58
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2888FC433D2;
        Mon, 27 Feb 2023 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535597;
        bh=BSUmVwu+aq/f5Xtg04ZA3qM4k1R0uzjM92M5Jq0eNUg=;
        h=Date:To:From:Subject:From;
        b=ljHq7obqiCxivM1NUNbPHRsJzYGK0hS/JrR9gVXLw0iCXywh7SedIuUco4ML2KcR9
         ibHCP8dqlhgqCypOtPsXsL07JnuOeIF/je+HO1I/7Ir1201vb1sj+lcXiYJZxXMpJn
         G3Uy0C1yEGF1g2nVO2EOWGr+wUCDEiobrI8muL68=
Date:   Mon, 27 Feb 2023 14:06:36 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch added to mm-unstable branch
Message-Id: <20230227220637.2888FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce lock_vma_under_rcu to be used from arch-specific code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch

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
Subject: mm: introduce lock_vma_under_rcu to be used from arch-specific code
Date: Mon, 27 Feb 2023 09:36:22 -0800

Introduce lock_vma_under_rcu function to lookup and lock a VMA during page
fault handling.  When VMA is not found, can't be locked or changes after
being locked, the function returns NULL.  The lookup is performed under
RCU protection to prevent the found VMA from being destroyed before the
VMA lock is acquired.  VMA lock statistics are updated according to the
results.  For now only anonymous VMAs can be searched this way.  In other
cases the function returns NULL.

Link: https://lkml.kernel.org/r/20230227173632.3292573-24-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code
+++ a/include/linux/mm.h
@@ -701,6 +701,9 @@ static inline void vma_mark_detached(str
 	vma->detached = detached;
 }
 
+struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
+					  unsigned long address);
+
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_init_lock(struct vm_area_struct *vma) {}
--- a/mm/memory.c~mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code
+++ a/mm/memory.c
@@ -5221,6 +5221,52 @@ vm_fault_t handle_mm_fault(struct vm_are
 }
 EXPORT_SYMBOL_GPL(handle_mm_fault);
 
+#ifdef CONFIG_PER_VMA_LOCK
+/*
+ * Lookup and lock a VMA under RCU protection. Returned VMA is guaranteed to be
+ * stable and not isolated. If the VMA is not found or is being modified the
+ * function returns NULL.
+ */
+struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
+					  unsigned long address)
+{
+	MA_STATE(mas, &mm->mm_mt, address, address);
+	struct vm_area_struct *vma;
+
+	rcu_read_lock();
+retry:
+	vma = mas_walk(&mas);
+	if (!vma)
+		goto inval;
+
+	/* Only anonymous vmas are supported for now */
+	if (!vma_is_anonymous(vma))
+		goto inval;
+
+	if (!vma_start_read(vma))
+		goto inval;
+
+	/* Check since vm_start/vm_end might change before we lock the VMA */
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
+		vma_end_read(vma);
+		goto inval;
+	}
+
+	/* Check if the VMA got isolated after we found it */
+	if (vma->detached) {
+		vma_end_read(vma);
+		/* The area was replaced with another one */
+		goto retry;
+	}
+
+	rcu_read_unlock();
+	return vma;
+inval:
+	rcu_read_unlock();
+	return NULL;
+}
+#endif /* CONFIG_PER_VMA_LOCK */
+
 #ifndef __PAGETABLE_P4D_FOLDED
 /*
  * Allocate p4d page table.
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

