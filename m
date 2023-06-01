Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3158AC77B7A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjFAWqG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjFAWqB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989381A4
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 361E564A88
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84513C433D2;
        Thu,  1 Jun 2023 22:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685659558;
        bh=NViBr7yiUhye5p6zsIlIwlK9oG3Q2EjhiAuKiFYtWws=;
        h=Date:To:From:Subject:From;
        b=1cr7+ovtIpQZRaltm6VKrPoB3TY7Gi9x6VFeCPrv6p0vX9vSL7VBnZ1Q+n3Fa8Vus
         7tg7o8JAPojQTvvFn7t7gZG+SfhLXKgpWEdKijkfX8QGAJBXiqHo7gr+zbwst4K28R
         ubRraP0ozx3gJPDXh5mpmlbyzBNfP+PglwqBRPlM=
Date:   Thu, 01 Jun 2023 15:45:57 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch added to mm-unstable branch
Message-Id: <20230601224558.84513C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: change vma iteration order in do_vmi_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

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
Subject: mm/mmap: change vma iteration order in do_vmi_align_munmap()
Date: Wed, 31 May 2023 22:16:05 -0400

By delaying the setting of prev/next VMA until after the write of NULL,
the probability of the prev/next VMA already being in the CPU cache is
significantly increased, especially for larger munmap operations.  It also
means that prev/next will be loaded closer to when they are used.

This has the consequence of needing to change the for_each() to a do {}
for_each() when writing to the side tree.

Since prev will be set later in the function, it is better to reverse the
splitting direction of the start VMA (modify the new_below argument to
__split_vma).

Using the vma_iter_prev_range() to walk back to the correct location in
the tree will, on the most part, mean walking within the CPU cache. 
Usually, this is two steps vs a node reset and a tree re-walk.

Link: https://lkml.kernel.org/r/20230601021605.2823123-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/mm/mmap.c~mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap
+++ a/mm/mmap.c
@@ -2395,20 +2395,17 @@ do_vmi_align_munmap(struct vma_iterator
 		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
 			goto map_count_exceeded;
 
-		error = __split_vma(vmi, vma, start, 0);
+		error = __split_vma(vmi, vma, start, 1);
 		if (error)
 			goto start_split_failed;
-
-		vma = vma_iter_load(vmi);
 	}
 
-	prev = vma_prev(vmi);
-
 	/*
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
 	 * it is always overwritten.
 	 */
-	for_each_vma_range(*vmi, next, end) {
+	next = vma;
+	do {
 		/* Does it split the end? */
 		if (next->vm_end > end) {
 			error = __split_vma(vmi, next, end, 0);
@@ -2425,13 +2422,7 @@ do_vmi_align_munmap(struct vma_iterator
 		BUG_ON(next->vm_start < start);
 		BUG_ON(next->vm_start > end);
 #endif
-	}
-
-	if (vma_iter_end(vmi) > end)
-		next = vma_iter_load(vmi);
-
-	if (!next)
-		next = vma_next(vmi);
+	} for_each_vma_range(*vmi, next, end);
 
 	if (unlikely(uf)) {
 		/*
@@ -2468,12 +2459,18 @@ do_vmi_align_munmap(struct vma_iterator
 		BUG_ON(count != test_count);
 	}
 #endif
-	/* Point of no return */
-	vma_iter_set(vmi, start);
+	while (vma_iter_addr(vmi) > start)
+		vma_iter_prev_range(vmi);
+
 	if (vma_iter_clear_gfp(vmi, start, end, GFP_KERNEL))
 		return -ENOMEM;
 
 	mm->map_count -= count;
+	prev = vma_iter_prev_range(vmi);
+	next = vma_next(vmi);
+	if (next)
+		vma_iter_prev_range(vmi);
+
 	/*
 	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
 	 * VM_GROWSUP VMA. Such VMAs can change their size under
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

