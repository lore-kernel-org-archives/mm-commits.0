Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D23C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbjFIXaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjFIX2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C857D3AB1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84B063EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B287C433EF;
        Fri,  9 Jun 2023 23:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353295;
        bh=5o4aCqmpbSJaDplimjkD9sW9FPWUh2Ek/Col9a9bCDU=;
        h=Date:To:From:Subject:From;
        b=R6wIYD2y/UTtTZhXvfskkBoxN96+3+5AC+rtj9WzFtGtHaL1RWSZOKdOahFEnHvGk
         giZSwHv2fws1QZpo1XCv22Hgo4btoCy8fLZyyksR4nS9TMvHNgWpBsIC0/MpbtRk+p
         gpnNs7fFlbvnk/JfYdxFRvpQzZoQ/BVYJxhSBKOg=
Date:   Fri, 09 Jun 2023 16:28:14 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch removed from -mm tree
Message-Id: <20230609232815.0B287C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: use MAS_BUG_ON() when setting a leaf node as a parent
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: use MAS_BUG_ON() when setting a leaf node as a parent
Date: Thu, 18 May 2023 10:55:19 -0400

Use MAS_BUG_ON() to dump the maple state and tree in the unlikely event of
an issue.

Link: https://lkml.kernel.org/r/20230518145544.1722059-11-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent
+++ a/lib/maple_tree.c
@@ -453,7 +453,7 @@ enum maple_type mas_parent_type(struct m
 }
 
 /*
- * mte_set_parent() - Set the parent node and encode the slot
+ * mas_set_parent() - Set the parent node and encode the slot
  * @enode: The encoded maple node.
  * @parent: The encoded maple node that is the parent of @enode.
  * @slot: The slot that @enode resides in @parent.
@@ -462,16 +462,16 @@ enum maple_type mas_parent_type(struct m
  * parent type.
  */
 static inline
-void mte_set_parent(struct maple_enode *enode, const struct maple_enode *parent,
-		    unsigned char slot)
+void mas_set_parent(struct ma_state *mas, struct maple_enode *enode,
+		    const struct maple_enode *parent, unsigned char slot)
 {
 	unsigned long val = (unsigned long)parent;
 	unsigned long shift;
 	unsigned long type;
 	enum maple_type p_type = mte_node_type(parent);
 
-	BUG_ON(p_type == maple_dense);
-	BUG_ON(p_type == maple_leaf_64);
+	MAS_BUG_ON(mas, p_type == maple_dense);
+	MAS_BUG_ON(mas, p_type == maple_leaf_64);
 
 	switch (p_type) {
 	case maple_range_64:
@@ -1740,7 +1740,7 @@ static inline void mas_adopt_children(st
 	offset = ma_data_end(node, type, pivots, mas->max);
 	do {
 		child = mas_slot_locked(mas, slots, offset);
-		mte_set_parent(child, parent, offset);
+		mas_set_parent(mas, child, parent, offset);
 	} while (offset--);
 }
 
@@ -2705,9 +2705,9 @@ static inline void mas_set_split_parent(
 		return;
 
 	if ((*slot) <= split)
-		mte_set_parent(mas->node, left, *slot);
+		mas_set_parent(mas, mas->node, left, *slot);
 	else if (right)
-		mte_set_parent(mas->node, right, (*slot) - split - 1);
+		mas_set_parent(mas, mas->node, right, (*slot) - split - 1);
 
 	(*slot)++;
 }
@@ -3104,12 +3104,12 @@ static int mas_spanning_rebalance(struct
 				mte_node_type(mast->orig_l->node));
 	mast->orig_l->depth++;
 	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, &l_mas, true);
-	mte_set_parent(left, l_mas.node, slot);
+	mas_set_parent(mas, left, l_mas.node, slot);
 	if (middle)
-		mte_set_parent(middle, l_mas.node, ++slot);
+		mas_set_parent(mas, middle, l_mas.node, ++slot);
 
 	if (right)
-		mte_set_parent(right, l_mas.node, ++slot);
+		mas_set_parent(mas, right, l_mas.node, ++slot);
 
 	if (mas_is_root_limits(mast->l)) {
 new_root:
@@ -3336,8 +3336,8 @@ static inline bool mas_split_final_node(
 	 * The Big_node data should just fit in a single node.
 	 */
 	ancestor = mas_new_ma_node(mas, mast->bn);
-	mte_set_parent(mast->l->node, ancestor, mast->l->offset);
-	mte_set_parent(mast->r->node, ancestor, mast->r->offset);
+	mas_set_parent(mas, mast->l->node, ancestor, mast->l->offset);
+	mas_set_parent(mas, mast->r->node, ancestor, mast->r->offset);
 	mte_to_node(ancestor)->parent = mas_mn(mas)->parent;
 
 	mast->l->node = ancestor;
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

