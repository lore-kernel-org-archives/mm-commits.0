Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567F2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiEJVKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiEJVKe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:10:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E5A294481
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9580AB81FE8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490FCC385CD;
        Tue, 10 May 2022 21:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652217029;
        bh=sIqAU3Xd4QO4A1BIDYb2sb7sm99shc7661L3t2VbPIc=;
        h=Date:To:From:Subject:From;
        b=WDAajvZAk/Ou0HtXzTlwR94IGiyxspTQyBwXpLas+yHtqE22XWg0r6GAzD3jdCq2X
         5+PwHfPDVZCz4No7A6WVgAMLGQoUgr3ihOttLfO0BFX2VeUYE++X+3cYeCP8MZaXj+
         tAdDHMT+tua5C0eeZ+7xi/fKbCTL2ls4Y9boD7BA=
Date:   Tue, 10 May 2022 14:10:28 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-make-khugepaged_enter-void-function.patch added to mm-unstable branch
Message-Id: <20220510211029.490FCC385CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: make khugepaged_enter() void function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-make-khugepaged_enter-void-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-make-khugepaged_enter-void-function.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: make khugepaged_enter() void function

The most callers of khugepaged_enter() don't care about the return value. 
Only dup_mmap(), anonymous THP page fault and MADV_HUGEPAGE handle the
error by returning -ENOMEM.  Actually it is not harmful for them to ignore
the error case either.  It also sounds overkilling to fail fork() and page
fault early due to khugepaged_enter() error, and MADV_HUGEPAGE does set
VM_HUGEPAGE flag regardless of the error.

Link: https://lkml.kernel.org/r/20220510203222.24246-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Vlastmil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |   30 ++++++++++++------------------
 kernel/fork.c              |    4 +---
 mm/huge_memory.c           |    4 ++--
 mm/khugepaged.c            |   18 +++++++-----------
 4 files changed, 22 insertions(+), 34 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-make-khugepaged_enter-void-function
+++ a/include/linux/khugepaged.h
@@ -12,10 +12,10 @@ extern struct attribute_group khugepaged
 extern int khugepaged_init(void);
 extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
-extern int __khugepaged_enter(struct mm_struct *mm);
+extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-				      unsigned long vm_flags);
+extern void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+				       unsigned long vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 #ifdef CONFIG_SHMEM
 extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr);
@@ -40,11 +40,10 @@ static inline void collapse_pte_mapped_t
 	(transparent_hugepage_flags &				\
 	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
 
-static inline int khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags))
-		return __khugepaged_enter(mm);
-	return 0;
+		__khugepaged_enter(mm);
 }
 
 static inline void khugepaged_exit(struct mm_struct *mm)
@@ -53,7 +52,7 @@ static inline void khugepaged_exit(struc
 		__khugepaged_exit(mm);
 }
 
-static inline int khugepaged_enter(struct vm_area_struct *vma,
+static inline void khugepaged_enter(struct vm_area_struct *vma,
 				   unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
@@ -62,27 +61,22 @@ static inline int khugepaged_enter(struc
 		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
 		    !(vm_flags & VM_NOHUGEPAGE) &&
 		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-			if (__khugepaged_enter(vma->vm_mm))
-				return -ENOMEM;
-	return 0;
+			__khugepaged_enter(vma->vm_mm);
 }
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
-static inline int khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	return 0;
 }
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline int khugepaged_enter(struct vm_area_struct *vma,
-				   unsigned long vm_flags)
+static inline void khugepaged_enter(struct vm_area_struct *vma,
+				    unsigned long vm_flags)
 {
-	return 0;
 }
-static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-					     unsigned long vm_flags)
+static inline void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+					      unsigned long vm_flags)
 {
-	return 0;
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
 					   unsigned long addr)
--- a/kernel/fork.c~mm-khugepaged-make-khugepaged_enter-void-function
+++ a/kernel/fork.c
@@ -608,9 +608,7 @@ static __latent_entropy int dup_mmap(str
 	retval = ksm_fork(mm, oldmm);
 	if (retval)
 		goto out;
-	retval = khugepaged_fork(mm, oldmm);
-	if (retval)
-		goto out;
+	khugepaged_fork(mm, oldmm);
 
 	retval = mas_expected_entries(&mas, oldmm->map_count);
 	if (retval)
--- a/mm/huge_memory.c~mm-khugepaged-make-khugepaged_enter-void-function
+++ a/mm/huge_memory.c
@@ -726,8 +726,8 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
-	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
-		return VM_FAULT_OOM;
+	khugepaged_enter(vma, vma->vm_flags);
+
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_enter-void-function
+++ a/mm/khugepaged.c
@@ -365,8 +365,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (khugepaged_enter_vma_merge(vma, *vm_flags))
-			return -ENOMEM;
+		khugepaged_enter_vma_merge(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
@@ -475,20 +474,20 @@ static bool hugepage_vma_check(struct vm
 	return true;
 }
 
-int __khugepaged_enter(struct mm_struct *mm)
+void __khugepaged_enter(struct mm_struct *mm)
 {
 	struct mm_slot *mm_slot;
 	int wakeup;
 
 	mm_slot = alloc_mm_slot();
 	if (!mm_slot)
-		return -ENOMEM;
+		return;
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
-		return 0;
+		return;
 	}
 
 	spin_lock(&khugepaged_mm_lock);
@@ -504,11 +503,9 @@ int __khugepaged_enter(struct mm_struct
 	mmgrab(mm);
 	if (wakeup)
 		wake_up_interruptible(&khugepaged_wait);
-
-	return 0;
 }
 
-int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
 			       unsigned long vm_flags)
 {
 	unsigned long hstart, hend;
@@ -519,13 +516,12 @@ int khugepaged_enter_vma_merge(struct vm
 	 * file-private shmem THP is not supported.
 	 */
 	if (!hugepage_vma_check(vma, vm_flags))
-		return 0;
+		return;
 
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
-		return khugepaged_enter(vma, vm_flags);
-	return 0;
+		khugepaged_enter(vma, vm_flags);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
_

Patches currently in -mm which might be from shy828301@gmail.com are

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

