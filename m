Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52E5C77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjEETbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjEETar (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E264214
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9DCF64021
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B552C433D2;
        Fri,  5 May 2023 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315045;
        bh=Zk01oMS4pMkL4s3YJbwIxT1JIfOAs0KWj3vge7cO6g0=;
        h=Date:To:From:Subject:From;
        b=L0fxjWzg17oEp/oF2xvS7cycVcjXM+iWHWbB9LFwL1asud4g8BZ8xKNHSWYMeAUQy
         gc4DcLdGsV9diOQ5Gm2W534nduLpACMEwQIFvAsz8pwBoIz5W39CUYdV8d5cxi8g+l
         iWRvY3NrbIoGrFFkHYNckegkukIJjx1sdq8UXrus=
Date:   Fri, 05 May 2023 12:30:44 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        dcb314@hotmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-return-error-on-mte_pivots-out-of-range.patch added to mm-unstable branch
Message-Id: <20230505193045.0B552C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: return error on mte_pivots() out of range
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-return-error-on-mte_pivots-out-of-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-return-error-on-mte_pivots-out-of-range.patch

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
Subject: maple_tree: return error on mte_pivots() out of range
Date: Fri, 5 May 2023 13:41:43 -0400

Rename mte_pivots() to mas_pivots() and pass through the ma_state to set
the error code to -EIO when the offset is out of range for the node type. 
Change the WARN_ON() to MAS_WARN_ON() to log the maple state.

Link: https://lkml.kernel.org/r/20230505174204.2665599-16-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-return-error-on-mte_pivots-out-of-range
+++ a/lib/maple_tree.c
@@ -663,22 +663,22 @@ static inline unsigned long *ma_gaps(str
 }
 
 /*
- * mte_pivot() - Get the pivot at @piv of the maple encoded node.
- * @mn: The maple encoded node.
+ * mas_pivot() - Get the pivot at @piv of the maple encoded node.
+ * @mas: The maple state.
  * @piv: The pivot.
  *
  * Return: the pivot at @piv of @mn.
  */
-static inline unsigned long mte_pivot(const struct maple_enode *mn,
-				 unsigned char piv)
+static inline unsigned long mas_pivot(struct ma_state *mas, unsigned char piv)
 {
-	struct maple_node *node = mte_to_node(mn);
-	enum maple_type type = mte_node_type(mn);
+	struct maple_node *node = mas_mn(mas);
+	enum maple_type type = mte_node_type(mas->node);
 
-	if (piv >= mt_pivots[type]) {
-		WARN_ON(1);
+	if (MAS_WARN_ON(mas, piv >= mt_pivots[type])) {
+		mas_set_err(mas, -EIO);
 		return 0;
 	}
+
 	switch (type) {
 	case maple_arange_64:
 		return node->ma64.pivot[piv];
@@ -5399,8 +5399,8 @@ static inline int mas_alloc(struct ma_st
 			return xa_err(mas->node);
 
 		if (!mas->index)
-			return mte_pivot(mas->node, 0);
-		return mte_pivot(mas->node, 1);
+			return mas_pivot(mas, 0);
+		return mas_pivot(mas, 1);
 	}
 
 	/* Must be walking a tree. */
@@ -5417,7 +5417,10 @@ static inline int mas_alloc(struct ma_st
 	 */
 	min = mas->min;
 	if (mas->offset)
-		min = mte_pivot(mas->node, mas->offset - 1) + 1;
+		min = mas_pivot(mas, mas->offset - 1) + 1;
+
+	if (mas_is_err(mas))
+		return xa_err(mas->node);
 
 	if (mas->index < min)
 		mas->index = min;
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
maple_tree-add-gap-to-check_alloc_rev_range-testcase.patch

