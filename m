Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA71BC7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjFAWqi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjFAWqf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE11137
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11C9F649EB
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FB4C433EF;
        Thu,  1 Jun 2023 22:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685659592;
        bh=KiW//kRaiRkUUAGfFVDXAp5iHcArQLwv1Wpr7HciUqk=;
        h=Date:To:From:Subject:From;
        b=d5ufv7de8UCBv43eBEoZ22YDTCgcVAyUcaQt3TaYx8tdhQsfR6PV3HjsihPoBcqna
         I51JDvl5A/j083Tqtt4G+8lw192Z9mZGwY5ecsxs6qtmPU8tV0PnO1AG1waTlc1MtI
         zL0710D9xVskiddSZkhQx0OTosT2DaIm6e+1pBwE=
Date:   Thu, 01 Jun 2023 15:46:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch added to mm-unstable branch
Message-Id: <20230601224632.63FB4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: fix regression in userfaultfd_unmap_prep()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

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
Subject: userfaultfd: fix regression in userfaultfd_unmap_prep()
Date: Wed, 31 May 2023 21:54:02 -0400

Android reported a performance regression in the userfaultfd unmap path. 
A closer inspection on the userfaultfd_unmap_prep() change showed that a
second tree walk would be necessary in the reworked code.

Fix the regression by passing each VMA that will be unmapped through to
the userfaultfd_unmap_prep() function as they are added to the unmap list,
instead of re-walking the tree for the VMA.

Link: https://lkml.kernel.org/r/20230601015402.2819343-1-Liam.Howlett@oracle.com
Fixes: 69dbe6daf104 ("userfaultfd: use maple tree iterator to iterate VMAs")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   39 +++++++++++++-------------------
 include/linux/userfaultfd_k.h |    6 ++--
 mm/mmap.c                     |   31 ++++++++++++-------------
 3 files changed, 35 insertions(+), 41 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-fix-regression-in-userfaultfd_unmap_prep
+++ a/fs/userfaultfd.c
@@ -857,31 +857,26 @@ static bool has_unmap_ctx(struct userfau
 	return false;
 }
 
-int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
+int userfaultfd_unmap_prep(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct list_head *unmaps)
 {
-	VMA_ITERATOR(vmi, mm, start);
-	struct vm_area_struct *vma;
+	struct userfaultfd_unmap_ctx *unmap_ctx;
+	struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
 
-	for_each_vma_range(vmi, vma, end) {
-		struct userfaultfd_unmap_ctx *unmap_ctx;
-		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
-
-		if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
-		    has_unmap_ctx(ctx, unmaps, start, end))
-			continue;
-
-		unmap_ctx = kzalloc(sizeof(*unmap_ctx), GFP_KERNEL);
-		if (!unmap_ctx)
-			return -ENOMEM;
-
-		userfaultfd_ctx_get(ctx);
-		atomic_inc(&ctx->mmap_changing);
-		unmap_ctx->ctx = ctx;
-		unmap_ctx->start = start;
-		unmap_ctx->end = end;
-		list_add_tail(&unmap_ctx->list, unmaps);
-	}
+	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
+	    has_unmap_ctx(ctx, unmaps, start, end))
+		return 0;
+
+	unmap_ctx = kzalloc(sizeof(*unmap_ctx), GFP_KERNEL);
+	if (!unmap_ctx)
+		return -ENOMEM;
+
+	userfaultfd_ctx_get(ctx);
+	atomic_inc(&ctx->mmap_changing);
+	unmap_ctx->ctx = ctx;
+	unmap_ctx->start = start;
+	unmap_ctx->end = end;
+	list_add_tail(&unmap_ctx->list, unmaps);
 
 	return 0;
 }
--- a/include/linux/userfaultfd_k.h~userfaultfd-fix-regression-in-userfaultfd_unmap_prep
+++ a/include/linux/userfaultfd_k.h
@@ -188,8 +188,8 @@ extern bool userfaultfd_remove(struct vm
 			       unsigned long start,
 			       unsigned long end);
 
-extern int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, struct list_head *uf);
+extern int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, struct list_head *uf);
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
@@ -271,7 +271,7 @@ static inline bool userfaultfd_remove(st
 	return true;
 }
 
-static inline int userfaultfd_unmap_prep(struct mm_struct *mm,
+static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start, unsigned long end,
 					 struct list_head *uf)
 {
--- a/mm/mmap.c~userfaultfd-fix-regression-in-userfaultfd_unmap_prep
+++ a/mm/mmap.c
@@ -2418,28 +2418,27 @@ do_vmi_align_munmap(struct vma_iterator
 			goto munmap_sidetree_failed;
 
 		count++;
+		if (unlikely(uf)) {
+			/*
+			 * If userfaultfd_unmap_prep returns an error the vmas
+			 * will remain split, but userland will get a
+			 * highly unexpected error anyway. This is no
+			 * different than the case where the first of the two
+			 * __split_vma fails, but we don't undo the first
+			 * split, despite we could. This is unlikely enough
+			 * failure that it's not worth optimizing it for.
+			 */
+			error = userfaultfd_unmap_prep(next, start, end, uf);
+
+			if (error)
+				goto userfaultfd_error;
+		}
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 		BUG_ON(next->vm_start < start);
 		BUG_ON(next->vm_start > end);
 #endif
 	} for_each_vma_range(*vmi, next, end);
 
-	if (unlikely(uf)) {
-		/*
-		 * If userfaultfd_unmap_prep returns an error the vmas
-		 * will remain split, but userland will get a
-		 * highly unexpected error anyway. This is no
-		 * different than the case where the first of the two
-		 * __split_vma fails, but we don't undo the first
-		 * split, despite we could. This is unlikely enough
-		 * failure that it's not worth optimizing it for.
-		 */
-		error = userfaultfd_unmap_prep(mm, start, end, uf);
-
-		if (error)
-			goto userfaultfd_error;
-	}
-
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
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
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

