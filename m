Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD19C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjERVah (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjERVaQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9B61FC4
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8F3E61CC8
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298C6C433EF;
        Thu, 18 May 2023 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445337;
        bh=9MWK74Hs24cCLfBMsj3/BkdQ703X1yIkV9JYBDUJxRE=;
        h=Date:To:From:Subject:From;
        b=czNIN3200Px7kfsOGys/EY4OyLoaOg9LseR/704YOj9kXU8moT/ciMlq2u1VIu2LU
         8LMHqx/C+7RT2gqiCTq42ufvgGHvZBYt0r2eoRcmTpbZivR/iAfHNRev7ifQZm1UQR
         rNwpSw0ctwL2gpDgLFWisVrnGbIYHGBG1dfjoqSs=
Date:   Thu, 18 May 2023 14:28:56 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-avoid-unnecessary-ascending.patch added to mm-unstable branch
Message-Id: <20230518212857.298C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: avoid unnecessary ascending
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-avoid-unnecessary-ascending.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-avoid-unnecessary-ascending.patch

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
Subject: maple_tree: avoid unnecessary ascending
Date: Thu, 18 May 2023 10:55:12 -0400

The maple tree node limits are implied by the parent.  When walking up the
tree, the limit may not be known until a slot that does not have implied
limits are encountered.  However, if the node is the left-most or
right-most node, the walking up to find that limit can be skipped.

This commit also fixes the debug/testing code that was not setting the
limit on walking down the tree as that optimization is not compatible with
this change.

Link: https://lkml.kernel.org/r/20230518145544.1722059-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   11 ++++++++---
 tools/testing/radix-tree/maple.c |    4 ++++
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-unnecessary-ascending
+++ a/lib/maple_tree.c
@@ -1103,7 +1103,6 @@ static int mas_ascend(struct ma_state *m
 	enum maple_type a_type;
 	unsigned long min, max;
 	unsigned long *pivots;
-	unsigned char offset;
 	bool set_max = false, set_min = false;
 
 	a_node = mas_mn(mas);
@@ -1115,8 +1114,9 @@ static int mas_ascend(struct ma_state *m
 	p_node = mte_parent(mas->node);
 	if (unlikely(a_node == p_node))
 		return 1;
+
 	a_type = mas_parent_type(mas, mas->node);
-	offset = mte_parent_slot(mas->node);
+	mas->offset = mte_parent_slot(mas->node);
 	a_enode = mt_mk_node(p_node, a_type);
 
 	/* Check to make sure all parent information is still accurate */
@@ -1124,7 +1124,6 @@ static int mas_ascend(struct ma_state *m
 		return 1;
 
 	mas->node = a_enode;
-	mas->offset = offset;
 
 	if (mte_is_root(a_enode)) {
 		mas->max = ULONG_MAX;
@@ -1132,6 +1131,12 @@ static int mas_ascend(struct ma_state *m
 		return 0;
 	}
 
+	if (!mas->min)
+		set_min = true;
+
+	if (mas->max == ULONG_MAX)
+		set_max = true;
+
 	min = 0;
 	max = ULONG_MAX;
 	do {
--- a/tools/testing/radix-tree/maple.c~maple_tree-avoid-unnecessary-ascending
+++ a/tools/testing/radix-tree/maple.c
@@ -35259,6 +35259,7 @@ static void mas_dfs_preorder(struct ma_s
 
 	struct maple_enode *prev;
 	unsigned char end, slot = 0;
+	unsigned long *pivots;
 
 	if (mas->node == MAS_START) {
 		mas_start(mas);
@@ -35291,6 +35292,9 @@ walk_up:
 		mas_ascend(mas);
 		goto walk_up;
 	}
+	pivots = ma_pivots(mte_to_node(prev), mte_node_type(prev));
+	mas->max = mas_safe_pivot(mas, pivots, slot, mte_node_type(prev));
+	mas->min = mas_safe_min(mas, pivots, slot);
 
 	return;
 done:
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

