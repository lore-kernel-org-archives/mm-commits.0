Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839E835BDA7
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388504; cv=none; b=IDczBRNmb5FxTHJdpMr5yL98WcdzbFNDupu3E3Okz1PjWuYO/4qW5Lct9RAFB+7ajhnZ+aerWyP38hUY4XTQ8G1ZigCK0dnUUlyfZSUXGgSkrcMMjzqnqtYVet1vB3/iSmL4h12GeN7nSEhQtmC2NyweuL/GUz/UC90/o/mMiOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388504; c=relaxed/simple;
	bh=SJHxBgyRsjhJVvBmcK+ppdPe4zU/G2/kHdWmRGNjRX0=;
	h=Date:To:From:Subject:Message-Id; b=EbKFjf/hecqEW7Mh+BshoXLSBXXDu1ab2nAWvDIt9b3YgMs/PFxdGMtx/QPrhgd3FYAz0S1EB67bl1vDMSeK7NiLs2sPH9uqrpeVj0rphM3rvi8sT+mG3oThizvC6AjREGIx7s7F4snuFJA5Z65b1ibBp1Ukj1zGLX+Cknx/pBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ccr3NPbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ccr3NPbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6F7C19424;
	Tue, 24 Mar 2026 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388504;
	bh=SJHxBgyRsjhJVvBmcK+ppdPe4zU/G2/kHdWmRGNjRX0=;
	h=Date:To:From:Subject:From;
	b=ccr3NPbX9SPnw3ncON4Kt7vCAqgIPgtlgAb4lL1wm2e+Qmxv/VsoeSt6hTdcjpGW3
	 FkMIE3RH0HvyvLIHfrpjZ+nNi9R4WQcx0lKWYQtcZrrYkGAGuTMwOS09Sgkk4/isga
	 c5PgD+mnvG03CzGgjlinnh/znrB2euy9S+vnIb+Y=
Date: Tue, 24 Mar 2026 14:41:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-inline-mas_spanning_rebalance_loop-into-mas_wr_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214144.1C6F7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-inline-mas_spanning_rebalance_loop-into-mas_wr_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:18 -0500

Just copy the code and replace count with height.  This is done to avoid
affecting other code paths into mas_spanning_rebalance_loop() for the next
change.

No functional change intended.

Link: https://lkml.kernel.org/r/20260130205935.2559335-14-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  108 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-inline-mas_spanning_rebalance_loop-into-mas_wr_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2862,6 +2862,13 @@ static void mas_spanning_rebalance(struc
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
+
+	unsigned char split, mid_split;
+	unsigned char slot = 0;
+	unsigned char new_height = 0; /* used if node is a new root */
+	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
+	struct maple_enode *old_enode;
+
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	struct maple_copy cp;
@@ -2917,7 +2924,106 @@ static noinline void mas_wr_spanning_reb
 		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, &mast, height);
+
+	/*
+	 * Each level of the tree is examined and balanced, pushing data to the left or
+	 * right, or rebalancing against left or right nodes is employed to avoid
+	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
+	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
+	 * will have the incorrect parent pointers and currently be in two trees: the
+	 * original tree and the partially new tree.  To remedy the parent pointers in
+	 * the old tree, the new data is swapped into the active tree and a walk down
+	 * the tree is performed and the parent pointers are updated.
+	 * See mas_topiary_replace() for more information.
+	 */
+	while (height--) {
+		mast.bn->b_end--;
+		mast.bn->type = mte_node_type(mast.orig_l->node);
+		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
+					&mid_split);
+		mast_set_split_parents(&mast, left, middle, right, split,
+				       mid_split);
+		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
+		new_height++;
+
+		/*
+		 * Copy data from next level in the tree to mast.bn from next
+		 * iteration
+		 */
+		memset(mast.bn, 0, sizeof(struct maple_big_node));
+		mast.bn->type = mte_node_type(left);
+
+		/* Root already stored in l->node. */
+		if (mas_is_root_limits(mast.l))
+			goto new_root;
+
+		mast_ascend(&mast);
+		mast_combine_cp_left(&mast);
+		mast.l->offset = mast.bn->b_end;
+		mab_set_b_end(mast.bn, mast.l, left);
+		mab_set_b_end(mast.bn, mast.m, middle);
+		mab_set_b_end(mast.bn, mast.r, right);
+
+		/* Copy anything necessary out of the right node. */
+		mast_combine_cp_right(&mast);
+		mast.orig_l->last = mast.orig_l->max;
+
+		if (mast_sufficient(&mast)) {
+			if (mast_overflow(&mast))
+				continue;
+
+			if (mast.orig_l->node == mast.orig_r->node) {
+			       /*
+				* The data in b_node should be stored in one
+				* node and in the tree
+				*/
+				slot = mast.l->offset;
+				break;
+			}
+
+			continue;
+		}
+
+		/* May be a new root stored in mast.bn */
+		if (mas_is_root_limits(mast.orig_l))
+			break;
+
+		mast_spanning_rebalance(&mast);
+
+		/* rebalancing from other nodes may require another loop. */
+		if (!height)
+			height++;
+	}
+
+	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+				mte_node_type(mast.orig_l->node));
+
+	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
+	new_height++;
+	mas_set_parent(mas, left, mast.l->node, slot);
+	if (middle)
+		mas_set_parent(mas, middle, mast.l->node, ++slot);
+
+	if (right)
+		mas_set_parent(mas, right, mast.l->node, ++slot);
+
+	if (mas_is_root_limits(mast.l)) {
+new_root:
+		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
+		while (!mte_is_root(mast.orig_l->node))
+			mast_ascend(&mast);
+	} else {
+		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
+	}
+
+	old_enode = mast.orig_l->node;
+	mas->depth = mast.l->depth;
+	mas->node = mast.l->node;
+	mas->min = mast.l->min;
+	mas->max = mast.l->max;
+	mas->offset = mast.l->offset;
+	mas_wmb_replace(mas, old_enode, new_height);
+	mtree_range_walk(mas);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


