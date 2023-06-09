Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E39BC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbjFIXaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjFIX2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2423F3C3A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE4B465CF6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120B8C433EF;
        Fri,  9 Jun 2023 23:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353301;
        bh=ecKEBo3BGYRFdakn/rB+xM8OzLm2jpohROIhgWvWqV4=;
        h=Date:To:From:Subject:From;
        b=AUUAB5YPtfq7ZLv7LwFT8qgonBoA/UMyeYc6GbmiLAseMsoxf/BACWr/Lzq/jiq1N
         JEr2hKDUHTrpbqCM0tidquYJ9q5lHM6X0kNTYOrxpB6ikDfwJt3ECKAGYeK+GdZwDQ
         k4OAt9jhGki0BxnbvT2hZJqJB7kaZzKav4Xmviso=
Date:   Fri, 09 Jun 2023 16:28:20 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-return-error-on-mte_pivots-out-of-range.patch removed from -mm tree
Message-Id: <20230609232821.120B8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: return error on mte_pivots() out of range
has been removed from the -mm tree.  Its filename was
     maple_tree-return-error-on-mte_pivots-out-of-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: return error on mte_pivots() out of range
Date: Thu, 18 May 2023 10:55:24 -0400

Rename mte_pivots() to mas_pivots() and pass through the ma_state to set
the error code to -EIO when the offset is out of range for the node type. 
Change the WARN_ON() to MAS_WARN_ON() to log the maple state.

Link: https://lkml.kernel.org/r/20230518145544.1722059-16-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
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
@@ -5394,8 +5394,8 @@ static inline int mas_alloc(struct ma_st
 			return xa_err(mas->node);
 
 		if (!mas->index)
-			return mte_pivot(mas->node, 0);
-		return mte_pivot(mas->node, 1);
+			return mas_pivot(mas, 0);
+		return mas_pivot(mas, 1);
 	}
 
 	/* Must be walking a tree. */
@@ -5412,7 +5412,10 @@ static inline int mas_alloc(struct ma_st
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

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
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

