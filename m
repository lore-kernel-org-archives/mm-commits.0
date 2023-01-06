Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D69C4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbjAFAfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbjAFAfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEE954724
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63724B81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0475DC433D2;
        Fri,  6 Jan 2023 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965306;
        bh=ovDm4jCPofGeyOUzLn7CtucQqtoxDTOHu7R3TtPC92M=;
        h=Date:To:From:Subject:From;
        b=mhHr6vzZ9w1FhOvo9kdK1Ka0PS8Em9zF3V6hV12HOqUpdQN7prvMsf8l1xIrH0ps0
         wvHQcU/gs2PduKmspdQXm4Yt2MFkpYGDCTy4n6t7UQa26FeG1wLduPWv0EIM7Y2FHE
         6W9TXd8pRJ2JSwQAW2AbGxfN5Mkiq2J+Fk2cELnk=
Date:   Thu, 05 Jan 2023 16:35:05 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-expand-vma-iterator-interface.patch added to mm-unstable branch
Message-Id: <20230106003506.0475DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: expand vma iterator interface
has been added to the -mm mm-unstable branch.  Its filename is
     mm-expand-vma-iterator-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-expand-vma-iterator-interface.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: expand vma iterator interface
Date: Thu, 5 Jan 2023 19:15:53 +0000

Add wrappers for the maple tree to the vma iterator.  This will provide
type safety at compile time.

Link: https://lkml.kernel.org/r/20230105191517.3099082-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   46 ++++++++++++++++++++--
 include/linux/mm_types.h |    4 -
 mm/mmap.c                |   77 +++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-expand-vma-iterator-interface
+++ a/include/linux/mm.h
@@ -665,16 +665,16 @@ static inline bool vma_is_accessible(str
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
-	return mas_find(&vmi->mas, max);
+	return mas_find(&vmi->mas, max - 1);
 }
 
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 {
 	/*
-	 * Uses vma_find() to get the first VMA when the iterator starts.
+	 * Uses mas_find() to get the first VMA when the iterator starts.
 	 * Calling mas_next() could skip the first entry.
 	 */
-	return vma_find(vmi, ULONG_MAX);
+	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
 static inline struct vm_area_struct *vma_prev(struct vma_iterator *vmi)
@@ -687,12 +687,50 @@ static inline unsigned long vma_iter_add
 	return vmi->mas.index;
 }
 
+static inline unsigned long vma_iter_end(struct vma_iterator *vmi)
+{
+	return vmi->mas.last + 1;
+}
+static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
+				      unsigned long count)
+{
+	return mas_expected_entries(&vmi->mas, count);
+}
+
+/* Free any unused preallocations */
+static inline void vma_iter_free(struct vma_iterator *vmi)
+{
+	mas_destroy(&vmi->mas);
+}
+
+static inline int vma_iter_bulk_store(struct vma_iterator *vmi,
+				      struct vm_area_struct *vma)
+{
+	vmi->mas.index = vma->vm_start;
+	vmi->mas.last = vma->vm_end - 1;
+	mas_store(&vmi->mas, vma);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void vma_iter_invalidate(struct vma_iterator *vmi)
+{
+	mas_pause(&vmi->mas);
+}
+
+static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
+{
+	mas_set(&vmi->mas, addr);
+}
+
 #define for_each_vma(__vmi, __vma)					\
 	while (((__vma) = vma_next(&(__vmi))) != NULL)
 
 /* The MM code likes to work with exclusive end addresses */
 #define for_each_vma_range(__vmi, __vma, __end)				\
-	while (((__vma) = vma_find(&(__vmi), (__end) - 1)) != NULL)
+	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
 
 #ifdef CONFIG_SHMEM
 /*
--- a/include/linux/mm_types.h~mm-expand-vma-iterator-interface
+++ a/include/linux/mm_types.h
@@ -909,9 +909,7 @@ struct vma_iterator {
 static inline void vma_iter_init(struct vma_iterator *vmi,
 		struct mm_struct *mm, unsigned long addr)
 {
-	vmi->mas.tree = &mm->mm_mt;
-	vmi->mas.index = addr;
-	vmi->mas.node = MAS_START;
+	mas_init(&vmi->mas, &mm->mm_mt, addr);
 }
 
 struct mmu_gather;
--- a/mm/mmap.c~mm-expand-vma-iterator-interface
+++ a/mm/mmap.c
@@ -144,6 +144,83 @@ static void remove_vma(struct vm_area_st
 	vm_area_free(vma);
 }
 
+static inline struct vm_area_struct *vma_iter_load(struct vma_iterator *vmi)
+{
+	return mas_walk(&vmi->mas);
+}
+
+static inline struct vm_area_struct *vma_prev_limit(struct vma_iterator *vmi,
+						    unsigned long min)
+{
+	return mas_prev(&vmi->mas, min);
+}
+
+static inline int vma_iter_prealloc(struct vma_iterator *vmi,
+				    struct vm_area_struct *vma)
+{
+	return mas_preallocate(&vmi->mas, vma, GFP_KERNEL);
+}
+
+/* Store a VMA with preallocated memory */
+static inline void vma_iter_store(struct vma_iterator *vmi,
+				  struct vm_area_struct *vma)
+{
+
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.index > vma->vm_start)) {
+		printk("%lu > %lu\n", vmi->mas.index, vma->vm_start);
+		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
+		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
+		mt_dump(vmi->mas.tree);
+	}
+	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.last <  vma->vm_start)) {
+		printk("%lu < %lu\n", vmi->mas.last, vma->vm_start);
+		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
+		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
+		mt_dump(vmi->mas.tree);
+	}
+#endif
+
+	if (vmi->mas.node != MAS_START &&
+	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
+		vma_iter_invalidate(vmi);
+
+	vmi->mas.index = vma->vm_start;
+	vmi->mas.last = vma->vm_end - 1;
+	mas_store_prealloc(&vmi->mas, vma);
+}
+
+static inline void vma_iter_clear(struct vma_iterator *vmi,
+				  unsigned long start, unsigned long end)
+{
+	mas_set_range(&vmi->mas, start, end - 1);
+	mas_store_prealloc(&vmi->mas, NULL);
+}
+
+static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
+			struct vm_area_struct *vma, gfp_t gfp)
+{
+	vmi->mas.index = vma->vm_start;
+	vmi->mas.last = vma->vm_end - 1;
+	mas_store_gfp(&vmi->mas, vma, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
+			unsigned long start, unsigned long end, gfp_t gfp)
+{
+	vmi->mas.index = start;
+	vmi->mas.last = end - 1;
+	mas_store_gfp(&vmi->mas, NULL, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * check_brk_limits() - Use platform specific check of range & verify mlock
  * limits.
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-add-mas_init-function.patch
maple_tree-fix-potential-rcu-issue.patch
maple_tree-reduce-user-error-potential.patch
test_maple_tree-test-modifications-while-iterating.patch
mm-expand-vma-iterator-interface.patch
mm-mmap-convert-brk-to-use-vma-iterator.patch
kernel-fork-convert-forking-to-using-the-vmi-iterator.patch
mmap-convert-vma_link-vma-iterator.patch
mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch
mmap-change-do_mas_munmap-and-do_mas_aligned_munmap-to-use-vma-iterator.patch
mmap-convert-vma_expand-to-use-vma-iterator.patch
mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch
ipc-shm-use-the-vma-iterator-for-munmap-calls.patch
userfaultfd-use-vma-iterator.patch
mm-change-mprotect_fixup-to-vma-iterator.patch
mlock-convert-mlock-to-vma-iterator.patch
coredump-convert-to-vma-iterator.patch
mempolicy-convert-to-vma-iterator.patch
task_mmu-convert-to-vma-iterator.patch
sched-convert-to-vma-iterator.patch
madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch
mmap-pass-through-vmi-iterator-to-__split_vma.patch
mmap-use-vmi-version-of-vma_merge.patch
mm-mremap-use-vmi-version-of-vma_merge.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator.patch
mmap-convert-__vma_adjust-to-use-vma-iterator.patch
mm-pass-through-vma-iterator-to-__vma_adjust.patch
madvise-use-split_vma-instead-of-__split_vma.patch
mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch
mm-pass-vma-iterator-through-to-__vma_adjust.patch
mm-add-vma-iterator-to-vma_adjust-arguments.patch
mmap-clean-up-mmap_region-unrolling.patch
mm-change-munmap-splitting-order-and-move_vma.patch
mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch
mm-mmap-refactor-locking-out-of-__vma_adjust.patch
mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch
mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch
mm-dont-use-__vma_adjust-in-__split_vma.patch
mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch
mm-mmap-introduce-dup_vma_anon-helper.patch
mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch
mm-mmap-remove-__vma_adjust.patch
vma_merge-set-vma-iterator-to-correct-position.patch

