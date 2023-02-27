Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C627CC64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjB0WGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjB0WGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAE925978
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D1D60F2E
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F098EC433D2;
        Mon, 27 Feb 2023 22:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535559;
        bh=EigdROoqfT8tplt6sohC0elxN9t9FEGAehkuaFmqzaw=;
        h=Date:To:From:Subject:From;
        b=M0ZO4geQpZIb90yhMq2Vyq5ZYpz+k+YJcBhc5kW8Ol9gAhJgAL+ZB7qqWMHe++2S8
         HRt72IH31QrmAKCiL3gF6J1051EyhWfPl4ybhzmD9Z3mua5FRu8SY97pD0KejXfBZw
         L/K6QGgoc6esPC/U8XODcBdyrOP0+ZiaOWL0gM68=
Date:   Mon, 27 Feb 2023 14:05:58 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch added to mm-unstable branch
Message-Id: <20230227220558.F098EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix freeing of nodes in rcu mode
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch

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
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: maple_tree: fix freeing of nodes in rcu mode
Date: Mon, 27 Feb 2023 09:36:02 -0800

The walk to destroy the nodes was not always setting the node type and
would result in a destroy method potentially using the values as nodes. 
Avoid this by setting the correct node types.  This is necessary for the
RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-4-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-fix-freeing-of-nodes-in-rcu-mode
+++ a/lib/maple_tree.c
@@ -903,6 +903,44 @@ static inline void ma_set_meta(struct ma
 }
 
 /*
+ * mas_clear_meta() - clear the metadata information of a node, if it exists
+ * @mas: The maple state
+ * @mn: The maple node
+ * @mt: The maple node type
+ * @offset: The offset of the highest sub-gap in this node.
+ * @end: The end of the data in this node.
+ */
+static inline void mas_clear_meta(struct ma_state *mas, struct maple_node *mn,
+				  enum maple_type mt)
+{
+	struct maple_metadata *meta;
+	unsigned long *pivots;
+	void __rcu **slots;
+	void *next;
+
+	switch (mt) {
+	case maple_range_64:
+		pivots = mn->mr64.pivot;
+		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
+			slots = mn->mr64.slot;
+			next = mas_slot_locked(mas, slots,
+					       MAPLE_RANGE64_SLOTS - 1);
+			if (unlikely((mte_to_node(next) && mte_node_type(next))))
+				return; /* The last slot is a node, no metadata */
+		}
+		fallthrough;
+	case maple_arange_64:
+		meta = ma_meta(mn, mt);
+		break;
+	default:
+		return;
+	}
+
+	meta->gap = 0;
+	meta->end = 0;
+}
+
+/*
  * ma_meta_end() - Get the data end of a node from the metadata
  * @mn: The maple node
  * @mt: The maple node type
@@ -5455,20 +5493,22 @@ no_gap:
  * mas_dead_leaves() - Mark all leaves of a node as dead.
  * @mas: The maple state
  * @slots: Pointer to the slot array
+ * @type: The maple node type
  *
  * Must hold the write lock.
  *
  * Return: The number of leaves marked as dead.
  */
 static inline
-unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots)
+unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
+			      enum maple_type mt)
 {
 	struct maple_node *node;
 	enum maple_type type;
 	void *entry;
 	int offset;
 
-	for (offset = 0; offset < mt_slot_count(mas->node); offset++) {
+	for (offset = 0; offset < mt_slots[mt]; offset++) {
 		entry = mas_slot_locked(mas, slots, offset);
 		type = mte_node_type(entry);
 		node = mte_to_node(entry);
@@ -5487,14 +5527,13 @@ unsigned char mas_dead_leaves(struct ma_
 
 static void __rcu **mas_dead_walk(struct ma_state *mas, unsigned char offset)
 {
-	struct maple_node *node, *next;
+	struct maple_node *next;
 	void __rcu **slots = NULL;
 
 	next = mas_mn(mas);
 	do {
-		mas->node = ma_enode_ptr(next);
-		node = mas_mn(mas);
-		slots = ma_slots(node, node->type);
+		mas->node = mt_mk_node(next, next->type);
+		slots = ma_slots(next, next->type);
 		next = mas_slot_locked(mas, slots, offset);
 		offset = 0;
 	} while (!ma_is_leaf(next->type));
@@ -5558,11 +5597,14 @@ static inline void __rcu **mas_destroy_d
 		node = mas_mn(mas);
 		slots = ma_slots(node, mte_node_type(mas->node));
 		next = mas_slot_locked(mas, slots, 0);
-		if ((mte_dead_node(next)))
+		if ((mte_dead_node(next))) {
+			mte_to_node(next)->type = mte_node_type(next);
 			next = mas_slot_locked(mas, slots, 1);
+		}
 
 		mte_set_node_dead(mas->node);
 		node->type = mte_node_type(mas->node);
+		mas_clear_meta(mas, node, node->type);
 		node->piv_parent = prev;
 		node->parent_slot = offset;
 		offset = 0;
@@ -5582,13 +5624,18 @@ static void mt_destroy_walk(struct maple
 
 	MA_STATE(mas, &mt, 0, 0);
 
-	if (mte_is_leaf(enode))
+	mas.node = enode;
+	if (mte_is_leaf(enode)) {
+		node->type = mte_node_type(enode);
 		goto free_leaf;
+	}
 
+	ma_flags &= ~MT_FLAGS_LOCK_MASK;
 	mt_init_flags(&mt, ma_flags);
 	mas_lock(&mas);
 
-	mas.node = start = enode;
+	mte_to_node(enode)->ma_flags = ma_flags;
+	start = enode;
 	slots = mas_destroy_descend(&mas, start, 0);
 	node = mas_mn(&mas);
 	do {
@@ -5596,7 +5643,8 @@ static void mt_destroy_walk(struct maple
 		unsigned char offset;
 		struct maple_enode *parent, *tmp;
 
-		node->slot_len = mas_dead_leaves(&mas, slots);
+		node->type = mte_node_type(mas.node);
+		node->slot_len = mas_dead_leaves(&mas, slots, node->type);
 		if (free)
 			mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
@@ -5620,7 +5668,8 @@ next:
 	} while (start != mas.node);
 
 	node = mas_mn(&mas);
-	node->slot_len = mas_dead_leaves(&mas, slots);
+	node->type = mte_node_type(mas.node);
+	node->slot_len = mas_dead_leaves(&mas, slots, node->type);
 	if (free)
 		mt_free_bulk(node->slot_len, slots);
 
@@ -5630,6 +5679,8 @@ start_slots_free:
 free_leaf:
 	if (free)
 		mt_free_rcu(&node->rcu);
+	else
+		mas_clear_meta(&mas, node, node->type);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch
maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

