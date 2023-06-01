Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025FAC7EE2F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjFAWqE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjFAWp6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA4213D
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 870F864A88
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB82CC4339B;
        Thu,  1 Jun 2023 22:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685659555;
        bh=UseIbCuA9rbj7VTKPii9ugOZJePEJmP6ZnaFbGp8sn0=;
        h=Date:To:From:Subject:From;
        b=NuzeKyfe/r5PqmCcTYbmaIgflvoLxxzxjhYv0vBzUJifeKmlkExmzNKKvb2+vW2jG
         lXmi90J9M4hrjPzyZyn+qLWjEWdhK/HT9+j+hF4rdm+CQKcxJDYHzbvJGlujQzuNhs
         e9o6om2ujHcGxJC3rIfzXGPTPW1TNRXLb/p3zspQ=
Date:   Thu, 01 Jun 2023 15:45:54 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-mas_preallocate-testing.patch added to mm-unstable branch
Message-Id: <20230601224554.DB82CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: update mas_preallocate() testing
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-update-mas_preallocate-testing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-mas_preallocate-testing.patch

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
Subject: maple_tree: update mas_preallocate() testing
Date: Wed, 31 May 2023 22:16:03 -0400

Link: https://lkml.kernel.org/r/20230601021605.2823123-13-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-update-mas_preallocate-testing
+++ a/tools/testing/radix-tree/maple.c
@@ -35383,6 +35383,8 @@ static noinline void __init check_preall
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
 
+	/* Spanning store */
+	mas_set_range(&mas, 470, 500);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
@@ -35406,7 +35408,6 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
@@ -35420,7 +35421,6 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
@@ -35434,7 +35434,6 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
@@ -35448,33 +35447,37 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
+	/* Slot store does not need allocations */
+	mas_set_range(&mas, 6, 9);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
-	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	MT_BUG_ON(mt, allocated != 0);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
+
+	mas_set_range(&mas, 6, 10);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	MT_BUG_ON(mt, allocated != 1);
 	mas_store_prealloc(&mas, ptr);
+	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
+	/* Split */
+	mas_set_range(&mas, 54, 54);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated == 0);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	MT_BUG_ON(mt, allocated != 1 + height * 2);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mt_set_non_kernel(1);
+	/* Spanning store */
+	mas_set_range(&mas, 1, 100);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
@@ -35482,6 +35485,7 @@ static noinline void __init check_preall
 	mas_destroy(&mas);
 
 
+	/* Spanning store */
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
@@ -35489,6 +35493,7 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
+	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
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

