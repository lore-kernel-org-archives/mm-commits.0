Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0C7C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjHDRn6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjHDRnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:43:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377434C01
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0537620D1
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F318C433C8;
        Fri,  4 Aug 2023 17:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691171033;
        bh=QaX9z6c6KJGqf+lzSpDBL6ewxbc9PsLV0biNPbLzgCE=;
        h=Date:To:From:Subject:From;
        b=FyW/NcB9J03hmpd6LFqNVVWuo09rx/3v3FkTIywaI+QKHbnNXBhgKMuUqXvvX0aHI
         4iAb7u+fenY7KCLIiSgDqUNjVJV+SYDZ5uMUUQjY/Wvy6jhAbt3pcvyP8VLlvWnTkT
         63jmiL+B/pvpb1phqVbhxagiK3uwKuU/wIRhTcPM=
Date:   Fri, 04 Aug 2023 10:43:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        paulmck@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch added to mm-unstable branch
Message-Id: <20230804174353.0F318C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: reorder replacement of nodes to avoid live lock
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch

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
Subject: maple_tree: reorder replacement of nodes to avoid live lock
Date: Fri, 4 Aug 2023 12:59:47 -0400

Replacing nodes may cause a live lock-up if CPU resources are saturated by
write operations on the tree by continuously retrying on dead nodes.  To
avoid the continuous retry scenario, ensure the new node is inserted into
the tree prior to marking the old data as dead.  This will define a window
where old and new data is swapped.

When reusing lower level nodes, ensure the parent pointer is updated after
the parent is marked dead.  This ensures that the child is still reachable
from the top of the tree, but walking up to a dead node will result in a
single retry that will start a fresh walk from the top down through the
new node.

Link: https://lkml.kernel.org/r/20230804165951.2661157-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   56 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock
+++ a/lib/maple_tree.c
@@ -1757,6 +1757,36 @@ static inline void mas_replace(struct ma
 }
 
 /*
+ * mas_replace_node() - Replace a node by putting it in the tree, marking it
+ * dead, and freeing it.
+ * the parent encoding to locate the maple node in the tree.
+ * @mas - the ma_state with @mas->node pointing to the new node.
+ * @old_enode - The old maple encoded node.
+ */
+static inline void mas_replace_node(struct ma_state *mas,
+		struct maple_enode *old_enode)
+	__must_hold(mas->tree->ma_lock)
+{
+	if (mte_is_root(mas->node)) {
+		mas_mn(mas)->parent = ma_parent_ptr(
+			      ((unsigned long)mas->tree | MA_ROOT_PARENT));
+		rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
+		mas_set_height(mas);
+	} else {
+		unsigned char offset = 0;
+		void __rcu **slots = NULL;
+
+		offset = mte_parent_slot(mas->node);
+		slots = ma_slots(mte_parent(mas->node),
+				 mas_parent_type(mas, mas->node));
+		rcu_assign_pointer(slots[offset], mas->node);
+	}
+
+	mte_set_node_dead(old_enode);
+	mas_free(mas, old_enode);
+}
+
+/*
  * mas_new_child() - Find the new child of a node.
  * @mas: the maple state
  * @child: the maple state to store the child.
@@ -3176,7 +3206,7 @@ static inline void mas_destroy_rebalance
 {
 	enum maple_type mt = mte_node_type(mas->node);
 	struct maple_node reuse, *newnode, *parent, *new_left, *left, *node;
-	struct maple_enode *eparent;
+	struct maple_enode *eparent, *old_eparent;
 	unsigned char offset, tmp, split = mt_slots[mt] / 2;
 	void __rcu **l_slots, **slots;
 	unsigned long *l_pivs, *pivs, gap;
@@ -3218,7 +3248,7 @@ static inline void mas_destroy_rebalance
 
 	l_mas.max = l_pivs[split];
 	mas->min = l_mas.max + 1;
-	eparent = mt_mk_node(mte_parent(l_mas.node),
+	old_eparent = mt_mk_node(mte_parent(l_mas.node),
 			     mas_parent_type(&l_mas, l_mas.node));
 	tmp += end;
 	if (!in_rcu) {
@@ -3234,7 +3264,7 @@ static inline void mas_destroy_rebalance
 
 		memcpy(node, newnode, sizeof(struct maple_node));
 		ma_set_meta(node, mt, 0, tmp - 1);
-		mte_set_pivot(eparent, mte_parent_slot(l_mas.node),
+		mte_set_pivot(old_eparent, mte_parent_slot(l_mas.node),
 			      l_pivs[split]);
 
 		/* Remove data from l_pivs. */
@@ -3242,6 +3272,7 @@ static inline void mas_destroy_rebalance
 		memset(l_pivs + tmp, 0, sizeof(unsigned long) * (max_p - tmp));
 		memset(l_slots + tmp, 0, sizeof(void *) * (max_s - tmp));
 		ma_set_meta(left, mt, 0, split);
+		eparent = old_eparent;
 
 		goto done;
 	}
@@ -3266,7 +3297,7 @@ static inline void mas_destroy_rebalance
 	parent = mas_pop_node(mas);
 	slots = ma_slots(parent, mt);
 	pivs = ma_pivots(parent, mt);
-	memcpy(parent, mte_to_node(eparent), sizeof(struct maple_node));
+	memcpy(parent, mte_to_node(old_eparent), sizeof(struct maple_node));
 	rcu_assign_pointer(slots[offset], mas->node);
 	rcu_assign_pointer(slots[offset - 1], l_mas.node);
 	pivs[offset - 1] = l_mas.max;
@@ -3278,8 +3309,10 @@ done:
 	mte_set_gap(eparent, mte_parent_slot(l_mas.node), gap);
 	mas_ascend(mas);
 
-	if (in_rcu)
-		mas_replace(mas, false);
+	if (in_rcu) {
+		mas_replace_node(mas, old_eparent);
+		mas_adopt_children(mas, mas->node);
+	}
 
 	mas_update_gap(mas);
 }
@@ -3596,11 +3629,13 @@ static noinline_for_kasan int mas_commit
 			    struct maple_big_node *b_node, unsigned char end)
 {
 	struct maple_node *node;
+	struct maple_enode *old_enode;
 	unsigned char b_end = b_node->b_end;
 	enum maple_type b_type = b_node->type;
 
+	old_enode = wr_mas->mas->node;
 	if ((b_end < mt_min_slots[b_type]) &&
-	    (!mte_is_root(wr_mas->mas->node)) &&
+	    (!mte_is_root(old_enode)) &&
 	    (mas_mt_height(wr_mas->mas) > 1))
 		return mas_rebalance(wr_mas->mas, b_node);
 
@@ -3618,7 +3653,7 @@ static noinline_for_kasan int mas_commit
 	node->parent = mas_mn(wr_mas->mas)->parent;
 	wr_mas->mas->node = mt_mk_node(node, b_type);
 	mab_mas_cp(b_node, 0, b_end, wr_mas->mas, false);
-	mas_replace(wr_mas->mas, false);
+	mas_replace_node(wr_mas->mas, old_enode);
 reuse_node:
 	mas_update_gap(wr_mas->mas);
 	return 1;
@@ -4117,9 +4152,10 @@ static inline bool mas_wr_node_store(str
 done:
 	mas_leaf_set_meta(mas, newnode, dst_pivots, maple_leaf_64, new_end);
 	if (in_rcu) {
-		mte_set_node_dead(mas->node);
+		struct maple_enode *old_enode = mas->node;
+
 		mas->node = mt_mk_node(newnode, wr_mas->type);
-		mas_replace(mas, false);
+		mas_replace_node(mas, old_enode);
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maintainers-add-maple-tree-mailing-list.patch
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
maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

