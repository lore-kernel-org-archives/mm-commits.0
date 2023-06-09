Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DEEC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjFIX3l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjFIX22 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654FE30F9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F386565CD2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D4FC433D2;
        Fri,  9 Jun 2023 23:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353285;
        bh=m48+GmigUgb9japbI3GSiPJTTjHBqBYUhMQMpRPcy/U=;
        h=Date:To:From:Subject:From;
        b=RZkg7CTx5MwNi8oWaYADR2ipv7uPz6ciI//qNSHI/bjirWZm2XsCmJI+e1uHMdR9G
         r0KGrnxTE+T7nMsDbOlkX7obAZqCPGoNcFYnz3g35UgZpGNKCGRofhMAAPY7ujio3M
         gW0h0KCnPrHPW4KkzvURRwM+TxTEKgZmrDbZn2rk=
Date:   Fri, 09 Jun 2023 16:28:04 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, Liam.Howlett@oracle.com,
        dcb314@hotmail.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type.patch removed from -mm tree
Message-Id: <20230609232805.50D4FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: clean up mas_parent_enum() and rename to mas_parent_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: clean up mas_parent_enum() and rename to mas_parent_type()
Date: Thu, 18 May 2023 10:55:11 -0400

mas_parent_enum() is a simple wrapper for mte_parent_enum() which is only
called from that wrapper.  Remove the wrapper and inline mte_parent_enum()
into mas_parent_enum().

At the same time, clean up the bit masking of the root pointer since it
cannot be set by the time the bit masking occurs.  Change the check on the
root bit to a WARN_ON(), and fix the verification code to not trigger the
WARN_ON() before checking if the node is root.

Align the name to mas_parent_type() since mas_node_type() exists already.

Link: https://lkml.kernel.org/r/20230518145544.1722059-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   50 +++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type
+++ a/lib/maple_tree.c
@@ -425,28 +425,26 @@ static inline unsigned long mte_parent_s
 }
 
 /*
- * mas_parent_enum() - Return the maple_type of the parent from the stored
+ * mas_parent_type() - Return the maple_type of the parent from the stored
  * parent type.
  * @mas: The maple state
- * @node: The maple_enode to extract the parent's enum
+ * @enode: The maple_enode to extract the parent's enum
  * Return: The node->parent maple_type
  */
 static inline
-enum maple_type mte_parent_enum(struct maple_enode *p_enode,
-				struct maple_tree *mt)
+enum maple_type mas_parent_type(struct ma_state *mas, struct maple_enode *enode)
 {
 	unsigned long p_type;
 
-	p_type = (unsigned long)p_enode;
-	if (p_type & MAPLE_PARENT_ROOT)
-		return 0; /* Validated in the caller. */
+	p_type = (unsigned long)mte_to_node(enode)->parent;
+	if (WARN_ON(p_type & MAPLE_PARENT_ROOT))
+		return 0;
 
 	p_type &= MAPLE_NODE_MASK;
-	p_type = p_type & ~(MAPLE_PARENT_ROOT | mte_parent_slot_mask(p_type));
-
+	p_type &= ~mte_parent_slot_mask(p_type);
 	switch (p_type) {
 	case MAPLE_PARENT_RANGE64: /* or MAPLE_PARENT_ARANGE64 */
-		if (mt_is_alloc(mt))
+		if (mt_is_alloc(mas->tree))
 			return maple_arange_64;
 		return maple_range_64;
 	}
@@ -454,12 +452,6 @@ enum maple_type mte_parent_enum(struct m
 	return 0;
 }
 
-static inline
-enum maple_type mas_parent_enum(struct ma_state *mas, struct maple_enode *enode)
-{
-	return mte_parent_enum(ma_enode_ptr(mte_to_node(enode)->parent), mas->tree);
-}
-
 /*
  * mte_set_parent() - Set the parent node and encode the slot
  * @enode: The encoded maple node.
@@ -1123,7 +1115,7 @@ static int mas_ascend(struct ma_state *m
 	p_node = mte_parent(mas->node);
 	if (unlikely(a_node == p_node))
 		return 1;
-	a_type = mas_parent_enum(mas, mas->node);
+	a_type = mas_parent_type(mas, mas->node);
 	offset = mte_parent_slot(mas->node);
 	a_enode = mt_mk_node(p_node, a_type);
 
@@ -1144,7 +1136,7 @@ static int mas_ascend(struct ma_state *m
 	max = ULONG_MAX;
 	do {
 		p_enode = a_enode;
-		a_type = mas_parent_enum(mas, p_enode);
+		a_type = mas_parent_type(mas, p_enode);
 		a_node = mte_parent(p_enode);
 		a_slot = mte_parent_slot(p_enode);
 		a_enode = mt_mk_node(a_node, a_type);
@@ -1659,7 +1651,7 @@ static inline void mas_parent_gap(struct
 	enum maple_type pmt;
 
 	pnode = mte_parent(mas->node);
-	pmt = mas_parent_enum(mas, mas->node);
+	pmt = mas_parent_type(mas, mas->node);
 	penode = mt_mk_node(pnode, pmt);
 	pgaps = ma_gaps(pnode, pmt);
 
@@ -1691,7 +1683,7 @@ ascend:
 
 	/* Go to the parent node. */
 	pnode = mte_parent(penode);
-	pmt = mas_parent_enum(mas, penode);
+	pmt = mas_parent_type(mas, penode);
 	pgaps = ma_gaps(pnode, pmt);
 	offset = mte_parent_slot(penode);
 	penode = mt_mk_node(pnode, pmt);
@@ -1718,7 +1710,7 @@ static inline void mas_update_gap(struct
 
 	pslot = mte_parent_slot(mas->node);
 	p_gap = ma_gaps(mte_parent(mas->node),
-			mas_parent_enum(mas, mas->node))[pslot];
+			mas_parent_type(mas, mas->node))[pslot];
 
 	if (p_gap != max_gap)
 		mas_parent_gap(mas, pslot, max_gap);
@@ -1767,7 +1759,7 @@ static inline void mas_replace(struct ma
 	} else {
 		offset = mte_parent_slot(mas->node);
 		slots = ma_slots(mte_parent(mas->node),
-				 mas_parent_enum(mas, mas->node));
+				 mas_parent_type(mas, mas->node));
 		old_enode = mas_slot_locked(mas, slots, offset);
 	}
 
@@ -3251,7 +3243,7 @@ static inline void mas_destroy_rebalance
 	l_mas.max = l_pivs[split];
 	mas->min = l_mas.max + 1;
 	eparent = mt_mk_node(mte_parent(l_mas.node),
-			     mas_parent_enum(&l_mas, l_mas.node));
+			     mas_parent_type(&l_mas, l_mas.node));
 	tmp += end;
 	if (!in_rcu) {
 		unsigned char max_p = mt_pivots[mt];
@@ -3294,7 +3286,7 @@ static inline void mas_destroy_rebalance
 
 	/* replace parent. */
 	offset = mte_parent_slot(mas->node);
-	mt = mas_parent_enum(&l_mas, l_mas.node);
+	mt = mas_parent_type(&l_mas, l_mas.node);
 	parent = mas_pop_node(mas);
 	slots = ma_slots(parent, mt);
 	pivs = ma_pivots(parent, mt);
@@ -6990,27 +6982,29 @@ counted:
 	p_slot = mte_parent_slot(mas->node);
 	p_mn = mte_parent(mte);
 	MT_BUG_ON(mas->tree, max_gap > mas->max);
-	if (ma_gaps(p_mn, mas_parent_enum(mas, mte))[p_slot] != max_gap) {
+	if (ma_gaps(p_mn, mas_parent_type(mas, mte))[p_slot] != max_gap) {
 		pr_err("gap %p[%u] != %lu\n", p_mn, p_slot, max_gap);
 		mt_dump(mas->tree);
 	}
 
 	MT_BUG_ON(mas->tree,
-		  ma_gaps(p_mn, mas_parent_enum(mas, mte))[p_slot] != max_gap);
+		  ma_gaps(p_mn, mas_parent_type(mas, mte))[p_slot] != max_gap);
 }
 
 static void mas_validate_parent_slot(struct ma_state *mas)
 {
 	struct maple_node *parent;
 	struct maple_enode *node;
-	enum maple_type p_type = mas_parent_enum(mas, mas->node);
-	unsigned char p_slot = mte_parent_slot(mas->node);
+	enum maple_type p_type;
+	unsigned char p_slot;
 	void __rcu **slots;
 	int i;
 
 	if (mte_is_root(mas->node))
 		return;
 
+	p_slot = mte_parent_slot(mas->node);
+	p_type = mas_parent_type(mas, mas->node);
 	parent = mte_parent(mas->node);
 	slots = ma_slots(parent, p_type);
 	MT_BUG_ON(mas->tree, mas_mn(mas) == parent);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


