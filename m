Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EAFC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbjAFAg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbjAFAgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786AB61338
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DF33B81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD755C433F1;
        Fri,  6 Jan 2023 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965353;
        bh=TxAGwc6iqaPju5C0EzXCM1YAK6GUIPbCrAH0H7dp3YY=;
        h=Date:To:From:Subject:From;
        b=JWjWCr9lwanYU8TlkSTib/wjPAK1p6hjOuIBTuqqXbuvXqRRDu3/HsRNy01k2BhdN
         GXxFBtGDGUnZ15zTYTa3tRUYUoqSzUyLbaask7qTKSdmeLpncJNyNGC2+MLbVC7PAf
         weumb9EK76OJzcInrXIa2Sa7mqzM7gl1Zg6rwajA=
Date:   Thu, 05 Jan 2023 16:35:53 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-convert-__vma_adjust-to-use-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230106003553.BD755C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: convert __vma_adjust() to use vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-convert-__vma_adjust-to-use-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-convert-__vma_adjust-to-use-vma-iterator.patch

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
Subject: mmap: convert __vma_adjust() to use vma iterator
Date: Thu, 5 Jan 2023 19:16:00 +0000

Use the vma iterator internally for __vma_adjust().  Avoid using the
maple tree interface directly for type safety.

Link: https://lkml.kernel.org/r/20230105191517.3099082-28-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 -
 mm/mmap.c          |   75 +++++++------------------------------------
 2 files changed, 13 insertions(+), 65 deletions(-)

--- a/include/linux/mm.h~mmap-convert-__vma_adjust-to-use-vma-iterator
+++ a/include/linux/mm.h
@@ -2832,9 +2832,6 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
-void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas);
-
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
 				    unsigned long start,
--- a/mm/mmap.c~mmap-convert-__vma_adjust-to-use-vma-iterator
+++ a/mm/mmap.c
@@ -494,56 +494,6 @@ static void __vma_link_file(struct vm_ar
 	flush_dcache_mmap_unlock(mapping);
 }
 
-/*
- * vma_mas_store() - Store a VMA in the maple tree.
- * @vma: The vm_area_struct
- * @mas: The maple state
- *
- * Efficient way to store a VMA in the maple tree when the @mas has already
- * walked to the correct location.
- *
- * Note: the end address is inclusive in the maple tree.
- */
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
-{
-	trace_vma_store(mas->tree, vma);
-	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
-	mas_store_prealloc(mas, vma);
-}
-
-/*
- * vma_mas_remove() - Remove a VMA from the maple tree.
- * @vma: The vm_area_struct
- * @mas: The maple state
- *
- * Efficient way to remove a VMA from the maple tree when the @mas has already
- * been established and points to the correct location.
- * Note: the end address is inclusive in the maple tree.
- */
-void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
-{
-	trace_vma_mas_szero(mas->tree, vma->vm_start, vma->vm_end - 1);
-	mas->index = vma->vm_start;
-	mas->last = vma->vm_end - 1;
-	mas_store_prealloc(mas, NULL);
-}
-
-/*
- * vma_mas_szero() - Set a given range to zero.  Used when modifying a
- * vm_area_struct start or end.
- *
- * @mas: The maple tree ma_state
- * @start: The start address to zero
- * @end: The end address to zero.
- */
-static inline void vma_mas_szero(struct ma_state *mas, unsigned long start,
-				unsigned long end)
-{
-	trace_vma_mas_szero(mas->tree, start, end - 1);
-	mas_set_range(mas, start, end - 1);
-	mas_store_prealloc(mas, NULL);
-}
-
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
@@ -703,7 +653,7 @@ int __vma_adjust(struct vm_area_struct *
 	bool vma_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 
 	if (next && !insert) {
@@ -788,7 +738,7 @@ int __vma_adjust(struct vm_area_struct *
 		}
 	}
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
@@ -834,7 +784,7 @@ int __vma_adjust(struct vm_area_struct *
 	if (start != vma->vm_start) {
 		if ((vma->vm_start < start) &&
 		    (!insert || (insert->vm_end != start))) {
-			vma_mas_szero(&mas, vma->vm_start, start);
+			vma_iter_clear(&vmi, vma->vm_start, start);
 			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
 		} else {
 			vma_changed = true;
@@ -844,8 +794,8 @@ int __vma_adjust(struct vm_area_struct *
 	if (end != vma->vm_end) {
 		if (vma->vm_end > end) {
 			if (!insert || (insert->vm_start != end)) {
-				vma_mas_szero(&mas, end, vma->vm_end);
-				mas_reset(&mas);
+				vma_iter_clear(&vmi, end, vma->vm_end);
+				vma_iter_set(&vmi, vma->vm_end);
 				VM_WARN_ON(insert &&
 					   insert->vm_end < vma->vm_end);
 			}
@@ -856,13 +806,13 @@ int __vma_adjust(struct vm_area_struct *
 	}
 
 	if (vma_changed)
-		vma_mas_store(vma, &mas);
+		vma_iter_store(&vmi, vma);
 
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		vma_mas_store(next, &mas);
+		vma_iter_store(&vmi, next);
 	}
 
 	if (file) {
@@ -882,8 +832,7 @@ int __vma_adjust(struct vm_area_struct *
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		mas_reset(&mas);
-		vma_mas_store(insert, &mas);
+		vma_iter_store(&vmi, insert);
 		mm->map_count++;
 	}
 
@@ -929,7 +878,7 @@ again:
 	if (insert && file)
 		uprobe_mmap(insert);
 
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 	validate_mm(mm);
 
 	return 0;
@@ -2061,7 +2010,8 @@ int expand_upwards(struct vm_area_struct
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
-				vma_mas_store(vma, &mas);
+				mas_set_range(&mas, vma->vm_start, address - 1);
+				mas_store_prealloc(&mas, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 				spin_unlock(&mm->page_table_lock);
 
@@ -2143,7 +2093,8 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
-				vma_mas_store(vma, &mas);
+				mas_set_range(&mas, address, vma->vm_end - 1);
+				mas_store_prealloc(&mas, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 				spin_unlock(&mm->page_table_lock);
 
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

