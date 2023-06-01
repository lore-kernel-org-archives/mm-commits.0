Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7318AC7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjFAWqD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjFAWp4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:45:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252D2138
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6C5E649EB
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C145C433EF;
        Thu,  1 Jun 2023 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685659553;
        bh=/78SriBm7WP5yrvvLxfWkE96BEo3wKhJXeVwpsJ37lA=;
        h=Date:To:From:Subject:From;
        b=CPZPc/7gpYuAHe1wVd0gi6kV9giVf+AZFWjzV6Ufi4jeNRpzss6INWuNW6P6tBNOl
         f30L4F4Rv9l/N6VMISdbkDbBLR6AR5pkDvDZ113U4vbL5H4HkLtKViJr+WJZdA6GOE
         17CpwPLfZvRl7LyT1B6K64Nmr4/G1ElOMH+HjQu0=
Date:   Thu, 01 Jun 2023 15:45:52 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch added to mm-unstable branch
Message-Id: <20230601224553.1C145C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: move mas_wr_end_piv() below mas_wr_extend_null()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch

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
Subject: maple_tree: move mas_wr_end_piv() below mas_wr_extend_null()
Date: Wed, 31 May 2023 22:16:02 -0400

Relocate it and call mas_wr_extend_null() from within mas_wr_end_piv(). 
Extending the NULL may affect the end pivot value so call
mas_wr_endtend_null() from within mas_wr_end_piv() to keep it all
together.

Link: https://lkml.kernel.org/r/20230601021605.2823123-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/lib/maple_tree.c~maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null
+++ a/lib/maple_tree.c
@@ -4197,18 +4197,6 @@ static inline bool mas_wr_slot_store(str
 	return true;
 }
 
-static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
-{
-	while ((wr_mas->offset_end < wr_mas->node_end) &&
-	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
-		wr_mas->offset_end++;
-
-	if (wr_mas->offset_end < wr_mas->node_end)
-		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
-	else
-		wr_mas->end_piv = wr_mas->mas->max;
-}
-
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
@@ -4245,6 +4233,21 @@ static inline void mas_wr_extend_null(st
 	}
 }
 
+static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
+{
+	while ((wr_mas->offset_end < wr_mas->node_end) &&
+	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
+		wr_mas->offset_end++;
+
+	if (wr_mas->offset_end < wr_mas->node_end)
+		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
+	else
+		wr_mas->end_piv = wr_mas->mas->max;
+
+	if (!wr_mas->entry)
+		mas_wr_extend_null(wr_mas);
+}
+
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
@@ -4377,10 +4380,6 @@ static inline void *mas_wr_store_entry(s
 
 	/* At this point, we are at the leaf node that needs to be altered. */
 	mas_wr_end_piv(wr_mas);
-
-	if (!wr_mas->entry)
-		mas_wr_extend_null(wr_mas);
-
 	/* New root for a single pointer */
 	if (unlikely(!mas->index && mas->last == ULONG_MAX)) {
 		mas_new_root(mas, wr_mas->entry);
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

