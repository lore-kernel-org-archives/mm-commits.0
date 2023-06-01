Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE61C7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjFAWpo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjFAWpk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159E813D
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B2164A7A
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B58C433EF;
        Thu,  1 Jun 2023 22:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685659537;
        bh=r0fOCnB3g7EMutcAXZrkPsInRLVuC2jM7aQJvsgfMak=;
        h=Date:To:From:Subject:From;
        b=oT7p30a0ZwfL2EE+OyfdiI9GzePdX5m/GTqu7PLVBZl0m7BjTMCuR2xHwAITvBTxg
         0PzBpr1pdCsPssxY/x1oXTho530NqmCEwH44a3b9QeSujlDkfG6QveXz1oilzAeBU1
         ndhT3Zrxy+k9H6nllpC0bqT7HaXQIefYFUyls9Jo=
Date:   Thu, 01 Jun 2023 15:45:36 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-do_vmi_align_munmap-side-tree-index.patch added to mm-unstable branch
Message-Id: <20230601224536.E5B58C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change do_vmi_align_munmap() side tree index
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-do_vmi_align_munmap-side-tree-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-do_vmi_align_munmap-side-tree-index.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: change do_vmi_align_munmap() side tree index
Date: Wed, 31 May 2023 22:15:55 -0400

The majority of the calls to munmap a VMA is for a single vma.  The maple
tree is able to store a single entry at 0, with a size of 1 as a pointer
and avoid any allocations.  Change do_vmi_align_munmap() to store the VMAs
being munmap()'ed into a tree indexed by the count.  This will leverage
the ability to store the first entry without a node allocation.

Storing the entries into a tree by the count and not the vma start and end
means changing the functions which iterate over the entries.  Update
unmap_vmas() and free_pgtables() to take a maple state and a tree end
address to support this functionality.

Passing through the same maple state to unmap_vmas() and free_pgtables()
means the state needs to be reset between calls.  This happens in the
static unmap_region() and exit_mmap().

Link: https://lkml.kernel.org/r/20230601021605.2823123-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++----
 mm/memory.c   |   16 +++++++---------
 mm/mmap.c     |   41 ++++++++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 30 deletions(-)

--- a/mm/internal.h~mm-change-do_vmi_align_munmap-side-tree-index
+++ a/mm/internal.h
@@ -103,7 +103,7 @@ bool __folio_end_writeback(struct folio
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
-void free_pgtables(struct mmu_gather *tlb, struct maple_tree *mt,
+void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *start_vma, unsigned long floor,
 		   unsigned long ceiling, bool mm_wr_locked);
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
@@ -1099,9 +1099,9 @@ static inline int vma_iter_store_gfp(str
 	return 0;
 }
 
-void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, bool mm_wr_locked);
+void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
+		struct vm_area_struct *start_vma, unsigned long start,
+		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
 
 /*
  * VMA lock generalization
--- a/mm/memory.c~mm-change-do_vmi_align_munmap-side-tree-index
+++ a/mm/memory.c
@@ -360,12 +360,10 @@ void free_pgd_range(struct mmu_gather *t
 	} while (pgd++, addr = next, addr != end);
 }
 
-void free_pgtables(struct mmu_gather *tlb, struct maple_tree *mt,
+void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
 		   unsigned long ceiling, bool mm_wr_locked)
 {
-	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
-
 	do {
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
@@ -374,7 +372,7 @@ void free_pgtables(struct mmu_gather *tl
 		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
 		 * be 0.  This will underflow and is okay.
 		 */
-		next = mas_find(&mas, ceiling - 1);
+		next = mas_find(mas, ceiling - 1);
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -395,7 +393,7 @@ void free_pgtables(struct mmu_gather *tl
 			while (next && next->vm_start <= vma->vm_end + PMD_SIZE
 			       && !is_vm_hugetlb_page(next)) {
 				vma = next;
-				next = mas_find(&mas, ceiling - 1);
+				next = mas_find(mas, ceiling - 1);
 				if (mm_wr_locked)
 					vma_start_write(vma);
 				unlink_anon_vmas(vma);
@@ -1700,9 +1698,10 @@ static void unmap_single_vma(struct mmu_
  * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  * drops the lock and schedules.
  */
-void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
+void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, bool mm_wr_locked)
+		unsigned long end_addr, unsigned long tree_end,
+		bool mm_wr_locked)
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
@@ -1710,7 +1709,6 @@ void unmap_vmas(struct mmu_gather *tlb,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
 				start_addr, end_addr);
@@ -1718,7 +1716,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 	do {
 		unmap_single_vma(tlb, vma, start_addr, end_addr, &details,
 				 mm_wr_locked);
-	} while ((vma = mas_find(&mas, end_addr - 1)) != NULL);
+	} while ((vma = mas_find(mas, tree_end - 1)) != NULL);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
--- a/mm/mmap.c~mm-change-do_vmi_align_munmap-side-tree-index
+++ a/mm/mmap.c
@@ -76,10 +76,10 @@ int mmap_rnd_compat_bits __read_mostly =
 static bool ignore_rlimit_data;
 core_param(ignore_rlimit_data, ignore_rlimit_data, bool, 0644);
 
-static void unmap_region(struct mm_struct *mm, struct maple_tree *mt,
+static void unmap_region(struct mm_struct *mm, struct ma_state *mas,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		struct vm_area_struct *next, unsigned long start,
-		unsigned long end, bool mm_wr_locked);
+		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
 
 static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
 {
@@ -2221,18 +2221,20 @@ static inline void remove_mt(struct mm_s
  *
  * Called with the mm semaphore held.
  */
-static void unmap_region(struct mm_struct *mm, struct maple_tree *mt,
+static void unmap_region(struct mm_struct *mm, struct ma_state *mas,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
-		struct vm_area_struct *next,
-		unsigned long start, unsigned long end, bool mm_wr_locked)
+		struct vm_area_struct *next, unsigned long start,
+		unsigned long end, unsigned long tree_end, bool mm_wr_locked)
 {
 	struct mmu_gather tlb;
+	unsigned long mt_start = mas->index;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mt, vma, start, end, mm_wr_locked);
-	free_pgtables(&tlb, mt, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
+	unmap_vmas(&tlb, mas, vma, start, end, tree_end, mm_wr_locked);
+	mas_set(mas, mt_start);
+	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING,
 				 mm_wr_locked);
 	tlb_finish_mmu(&tlb);
@@ -2338,7 +2340,6 @@ static inline int munmap_sidetree(struct
 				   struct ma_state *mas_detach)
 {
 	vma_start_write(vma);
-	mas_set_range(mas_detach, vma->vm_start, vma->vm_end - 1);
 	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
 		return -ENOMEM;
 
@@ -2415,6 +2416,7 @@ do_vmi_align_munmap(struct vma_iterator
 			if (error)
 				goto end_split_failed;
 		}
+		mas_set(&mas_detach, count);
 		error = munmap_sidetree(next, &mas_detach);
 		if (error)
 			goto munmap_sidetree_failed;
@@ -2451,17 +2453,17 @@ do_vmi_align_munmap(struct vma_iterator
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
-		MA_STATE(test, &mt_detach, start, end - 1);
+		MA_STATE(test, &mt_detach, 0, 0);
 		struct vm_area_struct *vma_mas, *vma_test;
 		int test_count = 0;
 
 		vma_iter_set(vmi, start);
 		rcu_read_lock();
-		vma_test = mas_find(&test, end - 1);
+		vma_test = mas_find(&test, count - 1);
 		for_each_vma_range(*vmi, vma_mas, end) {
 			BUG_ON(vma_mas != vma_test);
 			test_count++;
-			vma_test = mas_next(&test, end - 1);
+			vma_test = mas_next(&test, count - 1);
 		}
 		rcu_read_unlock();
 		BUG_ON(count != test_count);
@@ -2491,9 +2493,11 @@ do_vmi_align_munmap(struct vma_iterator
 	 * We can free page tables without write-locking mmap_lock because VMAs
 	 * were isolated before we downgraded mmap_lock.
 	 */
-	unmap_region(mm, &mt_detach, vma, prev, next, start, end, !downgrade);
+	mas_set(&mas_detach, 1);
+	unmap_region(mm, &mas_detach, vma, prev, next, start, end, count,
+		     !downgrade);
 	/* Statistics and freeing VMAs */
-	mas_set(&mas_detach, start);
+	mas_set(&mas_detach, 0);
 	remove_mt(mm, &mas_detach);
 	__mt_destroy(&mt_detach);
 
@@ -2801,9 +2805,10 @@ unmap_and_free_vma:
 		fput(vma->vm_file);
 		vma->vm_file = NULL;
 
+		vma_iter_set(&vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(mm, &mm->mm_mt, vma, prev, next, vma->vm_start,
-			     vma->vm_end, true);
+		unmap_region(mm, &vmi.mas, vma, prev, next, vma->vm_start,
+			     vma->vm_end, vma->vm_end, true);
 	}
 	if (file && (vm_flags & VM_SHARED))
 		mapping_unmap_writable(file->f_mapping);
@@ -3132,7 +3137,7 @@ void exit_mmap(struct mm_struct *mm)
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX, false);
+	unmap_vmas(&tlb, &mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
 	mmap_read_unlock(mm);
 
 	/*
@@ -3142,7 +3147,8 @@ void exit_mmap(struct mm_struct *mm)
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
 	mt_clear_in_rcu(&mm->mm_mt);
-	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
+	mas_set(&mas, vma->vm_end);
+	free_pgtables(&tlb, &mas, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
@@ -3151,6 +3157,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * enabled, without holding any MM locks besides the unreachable
 	 * mmap_write_lock.
 	 */
+	mas_set(&mas, vma->vm_end);
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

