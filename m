Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C935BDA7
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388506; cv=none; b=utHOqRMElROIZlaXxY0tcWrnniZtFpBHXTo9T+tiyHyaoGYNEmgyKUEa7MiySuUvaN5u5ljnRDJFpHiQMPt4OtcUpYcSiXZjR4cKQ7pi06QFhKUqeX6ikdxwtW9Y/JOKBvo8oFl/RqkekFZecgRdKrYWt29ApyThG7kP4XX2Hhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388506; c=relaxed/simple;
	bh=AHLwL6dF1EF+D+LVSVZZC9SRdylR2Ne0Kj7mJXeE09w=;
	h=Date:To:From:Subject:Message-Id; b=Ekv4fG2AR7GN2oxL/mMfMB2/eqOuEa4Gy+IdxcXNQuB9HzW3kb32omrdQGnI8b2lnXFk75G9VWgbg2ke1/vfs5SnZlAm5sWYf/0u/gu0rw0lp+IXOzV88a5vVzeIb2zorcSZMBH32l0sLQBfGrk5oThpRptMO5b1Pj1I5kfqzaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y7NNaRM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y7NNaRM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38A1C19424;
	Tue, 24 Mar 2026 21:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388505;
	bh=AHLwL6dF1EF+D+LVSVZZC9SRdylR2Ne0Kj7mJXeE09w=;
	h=Date:To:From:Subject:From;
	b=Y7NNaRM0YXrbjFtVevUS50D2BgmjpchZYY3kqPgOX5vBZsgB0bLNaOL/hdSZSLEbX
	 unnpa/QfxW5r0hRxh6lvwIfM2YhPdsI2ph3Cb1/bJ24ZpNk7bHtt59GY2+Ldg6RWoi
	 /hAwz2GR76CMzPVRXPqR8JwYFvBLNS8xZdxzGRGQ=
Date: Tue, 24 Mar 2026 14:41:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-change-initial-big-node-setup-in-mas_wr_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214145.C38A1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: change initial big node setup in mas_wr_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-change-initial-big-node-setup-in-mas_wr_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: change initial big node setup in mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:19 -0500

Instead of copying the data into the big node and finding out that the
data may need to be moved or appended to, calculate the data space up
front (in the maple copy node) and set up another source for the copy.

The additional copy source is tracked in the maple state sib (short for
sibling), and is put into the maple write states for future operations
after the data is in the big node.

To facilitate the newly moved node, some initial setup of the maple
subtree state are relocated after the potential shift caused by the new
way of rebalancing against a sibling.

Link: https://lkml.kernel.org/r/20260130205935.2559335-15-Liam.Howlett@oracle.com
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

 include/linux/maple_tree.h |    1 
 lib/maple_tree.c           |  175 ++++++++++++++++++++++++++++++-----
 2 files changed, 153 insertions(+), 23 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-change-initial-big-node-setup-in-mas_wr_spanning_rebalance
+++ a/include/linux/maple_tree.h
@@ -177,6 +177,7 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char data;
 };
 
 /**
--- a/lib/maple_tree.c~maple_tree-change-initial-big-node-setup-in-mas_wr_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -1304,6 +1304,18 @@ static inline unsigned char mas_data_end
 	return mt_pivots[type];
 }
 
+static inline
+void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
+{
+	wr_mas->node = mas_mn(mas);
+	wr_mas->type = mte_node_type(mas->node);
+	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
+	wr_mas->slots = ma_slots(wr_mas->node, wr_mas->type);
+	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, mas->offset);
+	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
+				       wr_mas->type);
+}
+
 /*
  * mas_leaf_max_gap() - Returns the largest gap in a leaf node
  * @mas: the maple state
@@ -2258,6 +2270,44 @@ static inline void mte_mid_split_check(s
 	*split = mid_split;
 }
 
+static inline
+void spanning_sib(struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
+{
+	struct ma_state l_tmp = *l_wr_mas->mas;
+	struct ma_state r_tmp = *r_wr_mas->mas;
+	unsigned char depth = 0;
+
+	do {
+		mas_ascend(&r_tmp);
+		mas_ascend(&l_tmp);
+		depth++;
+		if (r_tmp.offset < mas_data_end(&r_tmp)) {
+			r_tmp.offset++;
+			mas_descend(&r_tmp);
+			r_tmp.offset = 0;
+			while (--depth)
+				mas_descend(&r_tmp);
+
+			r_tmp.end = mas_data_end(&r_tmp);
+			*nneighbour = r_tmp;
+			return;
+		} else if (l_tmp.offset) {
+			l_tmp.offset--;
+			do {
+				mas_descend(&l_tmp);
+				l_tmp.offset = mas_data_end(&l_tmp);
+			} while (--depth);
+
+			l_tmp.end = l_tmp.offset;
+			*nneighbour = l_tmp;
+			return;
+		}
+	} while (!mte_is_root(r_tmp.node));
+
+	WARN_ON_ONCE(1);
+}
+
 /*
  * mast_set_split_parents() - Helper function to set three nodes parents.  Slot
  * is taken from @mast->l.
@@ -2642,6 +2692,49 @@ static inline void cp_leaf_init(struct m
 	cp->end = end;
 }
 
+/*
+ * cp_data_calc() - Calculate the size of the data (1 indexed).
+ * @cp: The maple copy struct with the new data populated.
+ * @l_wr_mas: The maple write state containing the data to the left of the write
+ * @r_wr_mas: The maple write state containing the data to the right of the
+ * write
+ *
+ * cp->data is a size (not indexed by 0).
+ */
+static inline void cp_data_calc(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+{
+
+	/* Add 1 every time for the 0th element */
+	cp->data = l_wr_mas->mas->offset;
+	/* Add the new data and any partial overwrites */
+	cp->data += cp->end + 1;
+	/* Data from right (offset + 1 to end), +1 for zero */
+	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
+}
+
+static inline void append_mas_cp(struct maple_copy *cp,
+	struct ma_state *mas, unsigned char start, unsigned char end)
+{
+	struct maple_node *node;
+	enum maple_type mt;
+	unsigned char count;
+
+	count = cp->s_count;
+	node = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	cp->src[count].node = node;
+	cp->src[count].mt = mt;
+	if (mas->end <= end)
+		cp->src[count].max = mas->max;
+	else
+		cp->src[count].max = ma_pivots(node, mt)[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
 static inline void append_wr_mas_cp(struct maple_copy *cp,
 	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
 {
@@ -2670,6 +2763,42 @@ static inline void init_cp_src(struct ma
 	cp->s_count++;
 }
 
+/*
+ * multi_src_setup() - Set the @cp node up with multiple sources to copy from.
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The sibling maple state
+ *
+ * Note: @sib->end == 0 indicates no sibling will be used.
+ */
+static inline
+void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *sib)
+{
+	cp->s_count = 0;
+	if (sib->end && sib->max < l_wr_mas->mas->min)
+		append_mas_cp(cp, sib, 0, sib->end);
+
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(cp, l_wr_mas, 0, off);
+		cp->src[cp->s_count - 1].max = cp->min - 1;
+	}
+
+	init_cp_src(cp);
+
+	/* Copy right either from offset or offset + 1 pending on r_max */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
+	if (sib->end && sib->min > r_wr_mas->mas->max)
+		append_mas_cp(cp, sib, 0, sib->end);
+}
+
 static inline
 void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
 {
@@ -2873,36 +3002,42 @@ static noinline void mas_wr_spanning_reb
 	struct maple_big_node b_node;
 	struct maple_copy cp;
 	unsigned char height;
+	struct ma_state sib;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(mast_l_mas, NULL, 0, 0);
 
 
-	mast_l_mas = *mas;
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mast_l_mas = *mas;
 	cp.s_count = 0;
 	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	/* Copy left 0 - offset */
-	if (l_wr_mas->mas->offset) {
-		unsigned char off = l_wr_mas->mas->offset - 1;
-
-		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
-		cp.src[cp.s_count - 1].max = cp.min - 1;
+	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, &sib);
+		cp.data += sib.end + 1;
+	} else {
+		sib.end = 0;
 	}
 
-	init_cp_src(&cp);
-
-	/* Copy right from offset_end + 1 to end */
-	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
-		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
-			       r_wr_mas->mas->end);
-
-
+	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
 	b_node.type = l_wr_mas->type;
 	cp_data_write(&cp, &b_node);
+	if (sib.end) {
+		if (sib.max < l_wr_mas->mas->min) {
+			*l_wr_mas->mas = sib;
+			wr_mas_setup(l_wr_mas, &sib);
+			mast_l_mas = sib;
+		} else {
+			*r_wr_mas->mas = sib;
+			wr_mas_setup(r_wr_mas, &sib);
+		}
+	}
+
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
@@ -2917,12 +3052,6 @@ static noinline void mas_wr_spanning_reb
 	mast.m = &m_mas;
 	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
-		mast_spanning_rebalance(&mast);
-
 	height = mas_mt_height(mas) + 1;
 
 	/*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


