Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FF835E93D
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388501; cv=none; b=cRRem1CUKD8HtP/sAgph2vcgksQudMDVCM2pY7W/4dOKED2Cq3vvJ22L5xahceFMvIp+iXGOZkK6B6cPPMtNSxgxYpJems2F3rGjzIyo8JJBKBSpqE5SmJopbfqPtWIG2Afi3M6uMuL5kLZ5TO6p+8GMPqJ1vtar9pMKq31MNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388501; c=relaxed/simple;
	bh=74fwF2e2rGxqI4OiPPfq41kg/Roazxea0UNOkqYMz2I=;
	h=Date:To:From:Subject:Message-Id; b=ElIrUxxrwzOXZPrJxptU06K8mM6LWftF1iAPjlMLi1Wfdy2eHLQqacbyAfTFeSlz1JVUengubaHgJ/mRdI6qMQjFHEyjTJqNc2Flp5wo552hmqO7rMeX62RzWGrFOmqk8orfncmWjpqGGYo7mZc4xET+voj5BURlPx3A2zWRx9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/FnTIhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/FnTIhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9755C2BCB1;
	Tue, 24 Mar 2026 21:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388500;
	bh=74fwF2e2rGxqI4OiPPfq41kg/Roazxea0UNOkqYMz2I=;
	h=Date:To:From:Subject:From;
	b=h/FnTIhiW3b7nGhcAy81O1OQC/wMLxNYXJk6/VvLvlaV7w1hXjZr/FlRY8dLqqERR
	 zLv8QIhdgOwKyCCzAVTOehUkgZI6KHC7X+zyCzmzI9JcktK2CGkLjKya5AsO4IANaR
	 6J2GdE4s3XkxcJX1bOj0HMmj+f9gS0IxD4lVVaHY=
Date: Tue, 24 Mar 2026 14:41:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-maple_copy-node-and-use-it-in-mas_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214140.B9755C2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: introduce maple_copy node and use it in mas_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-maple_copy-node-and-use-it-in-mas_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: introduce maple_copy node and use it in mas_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:16 -0500

Introduce an internal-memory only node type called maple_copy to
facilitate internal copy operations.  Use it in mas_spanning_rebalance()
for just the leaf nodes.  Initially, the maple_copy node is used to
configure the source nodes and copy the data into the big_node.

The maple_copy contains a list of source entries with start and end
offsets.  One of the maple_copy entries can be itself with an offset of 0
to 2, representing the data where the store partially overwrites entries,
or fully overwrites the entry.  The side effect is that the source nodes
no longer have to worry about partially copying the existing offset if it
is not fully overwritten.

This is in preparation of removal of the maple big_node, but for the time
being the data is copied to the big node to limit the change size.

Link: https://lkml.kernel.org/r/20260130205935.2559335-12-Liam.Howlett@oracle.com
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

 include/linux/maple_tree.h |   26 ++++++
 lib/maple_tree.c           |  140 ++++++++++++++++++++++++++++++++---
 2 files changed, 157 insertions(+), 9 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-introduce-maple_copy-node-and-use-it-in-mas_spanning_rebalance
+++ a/include/linux/maple_tree.h
@@ -139,6 +139,7 @@ enum maple_type {
 	maple_leaf_64,
 	maple_range_64,
 	maple_arange_64,
+	maple_copy,
 };
 
 enum store_type {
@@ -154,6 +155,30 @@ enum store_type {
 	wr_slot_store,
 };
 
+struct maple_copy {
+	struct {
+		struct maple_node *node;
+		unsigned long max;
+		unsigned char start;
+		unsigned char end;
+		enum maple_type mt;
+	} src[4];
+	/* Simulated node */
+	void __rcu *slot[3];
+	unsigned long min;
+	union {
+		unsigned long pivot[3];
+		struct {
+			void *_pad[2];
+			unsigned long max;
+		};
+	};
+	unsigned char end;
+
+	/*Avoid passing these around */
+	unsigned char s_count;
+};
+
 /**
  * DOC: Maple tree flags
  *
@@ -299,6 +324,7 @@ struct maple_node {
 		};
 		struct maple_range_64 mr64;
 		struct maple_arange_64 ma64;
+		struct maple_copy cp;
 	};
 };
 
--- a/lib/maple_tree.c~maple_tree-introduce-maple_copy-node-and-use-it-in-mas_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -605,6 +605,8 @@ static inline unsigned long *ma_pivots(s
 	case maple_range_64:
 	case maple_leaf_64:
 		return node->mr64.pivot;
+	case maple_copy:
+		return node->cp.pivot;
 	case maple_dense:
 		return NULL;
 	}
@@ -624,6 +626,7 @@ static inline unsigned long *ma_gaps(str
 	switch (type) {
 	case maple_arange_64:
 		return node->ma64.gap;
+	case maple_copy:
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
@@ -690,6 +693,7 @@ static inline void mte_set_pivot(struct
 	case maple_arange_64:
 		node->ma64.pivot[piv] = val;
 		break;
+	case maple_copy:
 	case maple_dense:
 		break;
 	}
@@ -711,6 +715,8 @@ static inline void __rcu **ma_slots(stru
 	case maple_range_64:
 	case maple_leaf_64:
 		return mn->mr64.slot;
+	case maple_copy:
+		return mn->cp.slot;
 	case maple_dense:
 		return mn->slot;
 	}
@@ -2595,6 +2601,110 @@ dead_node:
 	return NULL;
 }
 
+/*
+ * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
+ * spanning store
+ * @cp: The maple copy node
+ * @mas: The maple state
+ * @l_wr_mas: The left write state of the spanning store
+ * @r_wr_mas: The right write state of the spanning store
+ */
+static inline void cp_leaf_init(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas)
+{
+	unsigned char end = 0;
+
+	/*
+	 * WARNING: The use of RCU_INIT_POINTER() makes it extremely important
+	 * to not expose the maple_copy node to any readers.  Exposure may
+	 * result in buggy code when a compiler reorders the instructions.
+	 */
+
+	/* Create entries to insert including split entries to left and right */
+	if (l_wr_mas->r_min < mas->index) {
+		end++;
+		RCU_INIT_POINTER(cp->slot[0], l_wr_mas->content);
+		cp->pivot[0] = mas->index - 1;
+	}
+	RCU_INIT_POINTER(cp->slot[end], l_wr_mas->entry);
+	cp->pivot[end] = mas->last;
+
+	if (r_wr_mas->end_piv > mas->last) {
+		end++;
+		RCU_INIT_POINTER(cp->slot[end],
+				 r_wr_mas->slots[r_wr_mas->offset_end]);
+		cp->pivot[end] = r_wr_mas->end_piv;
+	}
+
+	cp->min = l_wr_mas->r_min;
+	cp->max = cp->pivot[end];
+	cp->end = end;
+}
+
+static inline void append_wr_mas_cp(struct maple_copy *cp,
+	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
+{
+	unsigned char count;
+
+	count = cp->s_count;
+	cp->src[count].node = wr_mas->node;
+	cp->src[count].mt = wr_mas->type;
+	if (wr_mas->mas->end <= end)
+		cp->src[count].max = wr_mas->mas->max;
+	else
+		cp->src[count].max = wr_mas->pivots[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
+static inline void init_cp_src(struct maple_copy *cp)
+{
+	cp->src[cp->s_count].node = ma_mnode_ptr(cp);
+	cp->src[cp->s_count].mt = maple_copy;
+	cp->src[cp->s_count].max = cp->max;
+	cp->src[cp->s_count].start = 0;
+	cp->src[cp->s_count].end = cp->end;
+	cp->s_count++;
+}
+
+static inline
+void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
+{
+	struct maple_node *src;
+	unsigned char s;
+	unsigned char src_end, s_offset;
+	unsigned long *b_pivots, *cp_pivots;
+	void __rcu **b_slots, **cp_slots;
+	enum maple_type s_mt;
+
+	b_node->b_end = 0;
+
+	s = 0;
+	b_pivots = b_node->pivot;
+	b_slots = (void __rcu **)b_node->slot;
+	do {
+		unsigned char size;
+
+		src = cp->src[s].node;
+		s_mt = cp->src[s].mt;
+		s_offset = cp->src[s].start;
+		src_end = cp->src[s].end;
+		size = src_end - s_offset + 1;
+		cp_pivots = ma_pivots(src, s_mt) + s_offset;
+		cp_slots = ma_slots(src, s_mt) + s_offset;
+		memcpy(b_slots, cp_slots, size * sizeof(void __rcu *));
+		if (size > 1)
+			memcpy(b_pivots, cp_pivots, (size - 1) * sizeof(unsigned long));
+		b_pivots[size - 1] = cp->src[s].max;
+		b_pivots += size;
+		b_slots += size;
+		b_node->b_end += size;
+	} while (++s < cp->s_count);
+}
+
 static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
@@ -2750,10 +2860,11 @@ static void mas_spanning_rebalance(struc
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
+	struct maple_copy cp;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
@@ -2765,15 +2876,26 @@ static noinline void mas_wr_spanning_reb
 	mast.orig_l = &mast_l_mas;
 	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast.orig_r->max > mast.orig_r->last)
-		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
-			   mast.orig_r->end, &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
+	cp.s_count = 0;
+	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
+		cp.src[cp.s_count - 1].max = cp.min - 1;
+	}
+
+	init_cp_src(&cp);
+
+	/* Copy right from offset_end + 1 to end */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
 
+	b_node.type = l_wr_mas->type;
+	cp_data_write(&cp, &b_node);
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


