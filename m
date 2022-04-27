Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16339C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbiD0XAw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiD0W5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B648D6BE
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B63D161E7A
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F61C385AE;
        Wed, 27 Apr 2022 22:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100029;
        bh=Mqx6uETpxL1h7lJwnDRWeswKT3JeCjdzReBCcvlkZDc=;
        h=Date:To:From:Subject:From;
        b=M66EKXhNeXmAydIvLiw4PE8NnS0104HwXlT/b9kKWYQbagthO2rhmaY+dxNACRB/k
         RC1VnGe5R8PD7tV3s4mjf7NJipfFsaDFqJN6SPnBkdLRcalr7pedii94y+6YpD2Osw
         75JjczJScNdwkL5+FLCd3UJOVpvJH35140rw1VU8=
Date:   Wed, 27 Apr 2022 15:53:48 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-khugepaged-make-khugepaged_enter-void-function.patch removed from -mm tree
Message-Id: <20220427225348.E1F61C385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: make khugepaged_enter() void function
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-make-khugepaged_enter-void-function.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: make khugepaged_enter() void function

The most callers of khugepaged_enter() don't care about the return value. 
Only dup_mmap(), anonymous THP page fault and MADV_HUGEPAGE handle the
error by returning -ENOMEM.  Actually it is not harmful for them to ignore
the error case either.  It also sounds overkilling to fail fork() and page
fault early due to khugepaged_enter() error, and MADV_HUGEPAGE does set
VM_HUGEPAGE flag regardless of the error.

Link: https://lkml.kernel.org/r/20220404200250.321455-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -612,9 +612,7 @@ static __latent_entropy int dup_mmap(str
 	retval = ksm_fork(mm, oldmm);
 	if (retval)
 		goto out;
-	retval = khugepaged_fork(mm, oldmm);
-	if (retval)
-		goto out;
+	khugepaged_fork(mm, oldmm);
 
 	prev = NULL;
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
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

mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

