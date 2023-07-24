Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2883CEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 18:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjGXS7Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjGXS7X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8C3188
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F655613B3
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 18:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF372C433C7;
        Mon, 24 Jul 2023 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225160;
        bh=8Y8kpeBIk9XXRROdATu8FDleM7XCZSli9twqp4HO4jY=;
        h=Date:To:From:Subject:From;
        b=jipkDpNUpIf/eF06uZtrCSAkrA6Ny+IFEeq5ouYseujPalNVIhYO3RMCGANErJfDL
         rRlCVY/uaisvP6o5yWdu2WC7ZtBSQdQp96/xZf3/0jDsKiCuZ+4VcLCwkywiKoNHy9
         MdSkeYspBV7LP0KlRIc0UhCcsk0gZjeTOSQi25v8=
Date:   Mon, 24 Jul 2023 11:59:19 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch added to mm-unstable branch
Message-Id: <20230724185919.DF372C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change do_vmi_align_munmap() tracking of VMAs to remove
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch

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
Subject: mm: change do_vmi_align_munmap() tracking of VMAs to remove
Date: Mon, 24 Jul 2023 14:31:45 -0400

The majority of the calls to munmap a vm range is within a single vma.
The maple tree is able to store a single entry at 0, with a size of 1 as
a pointer and avoid any allocations.  Change do_vmi_align_munmap() to
store the VMAs being munmap()'ed into a tree indexed by the count.  This
will leverage the ability to store the first entry without a node
allocation.

Storing the entries into a tree by the count and not the vma start and
end means changing the functions which iterate over the entries.  Update
unmap_vmas() and free_pgtables() to take a maple state and a tree end
address to support this functionality.

Passing through the same maple state to unmap_vmas() and free_pgtables()
means the state needs to be reset between calls.  This happens in the
static unmap_region() and exit_mmap().

Link: https://lkml.kernel.org/r/20230724183157.3939892-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 mm/internal.h      |    2 +-
 mm/memory.c        |   16 +++++++---------
 mm/mmap.c          |   41 ++++++++++++++++++++++++-----------------
 4 files changed, 34 insertions(+), 29 deletions(-)

--- a/include/linux/mm.h~mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove
+++ a/include/linux/mm.h
@@ -2332,9 +2332,9 @@ static inline void zap_vma_pages(struct
 	zap_page_range_single(vma, vma->vm_start,
 			      vma->vm_end - vma->vm_start, NULL);
 }
-void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
+void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, bool mm_wr_locked);
+		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
 
 struct mmu_notifier_range;
 
--- a/mm/internal.h~mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove
+++ a/mm/internal.h
@@ -109,7 +109,7 @@ bool __folio_end_writeback(struct folio
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
-void free_pgtables(struct mmu_gather *tlb, struct maple_tree *mt,
+void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *start_vma, unsigned long floor,
 		   unsigned long ceiling, bool mm_wr_locked);
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
--- a/mm/memory.c~mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove
+++ a/mm/memory.c
@@ -361,12 +361,10 @@ void free_pgd_range(struct mmu_gather *t
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
@@ -375,7 +373,7 @@ void free_pgtables(struct mmu_gather *tl
 		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
 		 * be 0.  This will underflow and is okay.
 		 */
-		next = mas_find(&mas, ceiling - 1);
+		next = mas_find(mas, ceiling - 1);
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -396,7 +394,7 @@ void free_pgtables(struct mmu_gather *tl
 			while (next && next->vm_start <= vma->vm_end + PMD_SIZE
 			       && !is_vm_hugetlb_page(next)) {
 				vma = next;
-				next = mas_find(&mas, ceiling - 1);
+				next = mas_find(mas, ceiling - 1);
 				if (mm_wr_locked)
 					vma_start_write(vma);
 				unlink_anon_vmas(vma);
@@ -1833,9 +1831,10 @@ static void unmap_single_vma(struct mmu_
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
@@ -1843,7 +1842,6 @@ void unmap_vmas(struct mmu_gather *tlb,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
 				start_addr, end_addr);
@@ -1851,7 +1849,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 	do {
 		unmap_single_vma(tlb, vma, start_addr, end_addr, &details,
 				 mm_wr_locked);
-	} while ((vma = mas_find(&mas, end_addr - 1)) != NULL);
+	} while ((vma = mas_find(mas, tree_end - 1)) != NULL);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
--- a/mm/mmap.c~mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove
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
@@ -2293,18 +2293,20 @@ static inline void remove_mt(struct mm_s
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
@@ -2472,7 +2474,7 @@ do_vmi_align_munmap(struct vma_iterator
 				goto end_split_failed;
 		}
 		vma_start_write(next);
-		mas_set_range(&mas_detach, next->vm_start, next->vm_end - 1);
+		mas_set(&mas_detach, count);
 		error = mas_store_gfp(&mas_detach, next, GFP_KERNEL);
 		if (error)
 			goto munmap_gather_failed;
@@ -2511,17 +2513,17 @@ do_vmi_align_munmap(struct vma_iterator
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
@@ -2542,9 +2544,11 @@ do_vmi_align_munmap(struct vma_iterator
 	 * We can free page tables without write-locking mmap_lock because VMAs
 	 * were isolated before we downgraded mmap_lock.
 	 */
-	unmap_region(mm, &mt_detach, vma, prev, next, start, end, !unlock);
+	mas_set(&mas_detach, 1);
+	unmap_region(mm, &mas_detach, vma, prev, next, start, end, count,
+		     !unlock);
 	/* Statistics and freeing VMAs */
-	mas_set(&mas_detach, start);
+	mas_set(&mas_detach, 0);
 	remove_mt(mm, &mas_detach);
 	validate_mm(mm);
 	if (unlock)
@@ -2864,9 +2868,10 @@ unmap_and_free_vma:
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
@@ -3185,7 +3190,7 @@ void exit_mmap(struct mm_struct *mm)
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX, false);
+	unmap_vmas(&tlb, &mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
 	mmap_read_unlock(mm);
 
 	/*
@@ -3195,7 +3200,8 @@ void exit_mmap(struct mm_struct *mm)
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
 	mt_clear_in_rcu(&mm->mm_mt);
-	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
+	mas_set(&mas, vma->vm_end);
+	free_pgtables(&tlb, &mas, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
@@ -3204,6 +3210,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * enabled, without holding any MM locks besides the unreachable
 	 * mmap_write_lock.
 	 */
+	mas_set(&mas, vma->vm_end);
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

