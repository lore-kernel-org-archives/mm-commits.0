Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA65EC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjFIXRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXRS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:17:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C3D2D74
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9174960AF2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77ADC433EF;
        Fri,  9 Jun 2023 23:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352636;
        bh=jQ6+XFhx3fBmO6tA0Jw/EJtaet+MNY+zb752GOjtXrA=;
        h=Date:To:From:Subject:From;
        b=rFN856q0EkCl37cBJs0z5LhcCGxyUTvZB82malB0WhFS0ynZisFwcTJndC5SxYnsd
         d/fsSAphRQXMAP+n+EpUrCa3aF4rayHtUuy4bm9hi/k3DzpnP1KFyVi71FXR1flPij
         WhVvJGAwiHmQdFf+1EstpX3IpD7l9cM6impHMDSc=
Date:   Fri, 09 Jun 2023 16:17:15 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-update-validate_mm-to-use-vma-iterator-fix.patch removed from -mm tree
Message-Id: <20230609231715.E77ADC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: update validate_mm() to use vma iterator CONFIG flag
has been removed from the -mm tree.  Its filename was
     mm-update-validate_mm-to-use-vma-iterator-fix.patch

This patch was dropped because it was folded into mm-update-validate_mm-to-use-vma-iterator.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: update validate_mm() to use vma iterator CONFIG flag
Date: Tue, 6 Jun 2023 14:35:38 -0400

The validate_mm() function was deemed too heavy to enable with
CONFIG_DEBUG_VM [1].  Revert the config option to
CONFIG_DEBUG_VM_MAPLE_TREE

Link: https://lkml.kernel.org/r/20230606183538.588190-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/mmap.c~mm-update-validate_mm-to-use-vma-iterator-fix
+++ a/mm/mmap.c
@@ -299,7 +299,7 @@ out:
 	return origbrk;
 }
 
-#if defined(CONFIG_DEBUG_VM)
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 static void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
@@ -307,10 +307,7 @@ static void validate_mm(struct mm_struct
 	struct vm_area_struct *vma;
 	VMA_ITERATOR(vmi, mm, 0);
 
-#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	mt_validate(&mm->mm_mt);
-#endif
-
 	for_each_vma(vmi, vma) {
 #ifdef CONFIG_DEBUG_VM_RB
 		struct anon_vma *anon_vma = vma->anon_vma;
@@ -353,9 +350,9 @@ static void validate_mm(struct mm_struct
 	VM_BUG_ON_MM(bug, mm);
 }
 
-#else /* !CONFIG_DEBUG_VM */
+#else /* !CONFIG_DEBUG_VM_MAPLE_TREE */
 #define validate_mm(mm) do { } while (0)
-#endif /* CONFIG_DEBUG_VM */
+#endif /* CONFIG_DEBUG_VM_MAPLE_TREE */
 
 /*
  * vma has some anon_vma assigned, and is already inserted on that
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
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

