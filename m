Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58CE78F26
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388507; cv=none; b=KXCGiiG9pPvGk2dcuL5bAq5C6zw4f2tlbgvFEgtAtenxi5V6SVhauS/fBGEeRSbbLSv2gUNZcChfk0F04KQch8jylf+sHdNLSJUr73rAVrDWw2JYJiGicpsd6G9sXiFyIzV/pp0diH95AyTrUYzqPPXh/Pz77X/3mcJGVFohgfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388507; c=relaxed/simple;
	bh=ikT/EDSxtQGN7UAHmdth2cwXTP61ha4vC2XzaTww67k=;
	h=Date:To:From:Subject:Message-Id; b=P2XM7+2AO7BlHb5hbiivh7viOQgz/PZ0t0vWnOqmKvM3TGZyxQEk+J4Kw/BgiXfKsXj5uMH1q2nL7VUK5fK6J+MVWb8aNDLj5CGmeu/CVFvjLnFqodKNrdtPv3fISrxRnbgRYR4VFe/aK3y97vpPfBixO+Ww+JkfsyIga7b0UMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oHQ+qw0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oHQ+qw0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74018C19424;
	Tue, 24 Mar 2026 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388507;
	bh=ikT/EDSxtQGN7UAHmdth2cwXTP61ha4vC2XzaTww67k=;
	h=Date:To:From:Subject:From;
	b=oHQ+qw0w6q8IJ50RNG1rhpoLPpXBdOvN7op74S/b5sN229EPO8JIXuiy01CwF6k1I
	 F7gysp0Bvj1t+/TBEJgHfvPY/nUEr0mjgI2YprFrD6YzNiX4cBa11wEuiq1O8VuQyA
	 y9VkyDGKHV4aOa32Y7xgA1cNbIxt5R4d6xrEqs+U=
Date: Tue, 24 Mar 2026 14:41:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-ma_leaf_max_gap.patch removed from -mm tree
Message-Id: <20260324214147.74018C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: introduce ma_leaf_max_gap()
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-ma_leaf_max_gap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: introduce ma_leaf_max_gap()
Date: Fri, 30 Jan 2026 15:59:20 -0500

This is the same as mas_leaf_max_gap(), but the information necessary is
known without a maple state in future code.  Adding this function now
simplifies the review for a subsequent patch.

Link: https://lkml.kernel.org/r/20260130205935.2559335-16-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   48 ++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-ma_leaf_max_gap
+++ a/lib/maple_tree.c
@@ -1315,26 +1315,14 @@ void wr_mas_setup(struct ma_wr_state *wr
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
-
-/*
- * mas_leaf_max_gap() - Returns the largest gap in a leaf node
- * @mas: the maple state
- *
- * Return: The maximum gap in the leaf.
- */
-static unsigned long mas_leaf_max_gap(struct ma_state *mas)
+static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
+		enum maple_type mt, unsigned long min, unsigned long max,
+		unsigned long *pivots, void __rcu **slots)
 {
-	enum maple_type mt;
 	unsigned long pstart, gap, max_gap;
-	struct maple_node *mn;
-	unsigned long *pivots;
-	void __rcu **slots;
 	unsigned char i;
 	unsigned char max_piv;
 
-	mt = mte_node_type(mas->node);
-	mn = mas_mn(mas);
-	slots = ma_slots(mn, mt);
 	max_gap = 0;
 	if (unlikely(ma_is_dense(mt))) {
 		gap = 0;
@@ -1356,26 +1344,25 @@ static unsigned long mas_leaf_max_gap(st
 	 * Check the first implied pivot optimizes the loop below and slot 1 may
 	 * be skipped if there is a gap in slot 0.
 	 */
-	pivots = ma_pivots(mn, mt);
 	if (likely(!slots[0])) {
-		max_gap = pivots[0] - mas->min + 1;
+		max_gap = pivots[0] - min + 1;
 		i = 2;
 	} else {
 		i = 1;
 	}
 
 	/* reduce max_piv as the special case is checked before the loop */
-	max_piv = ma_data_end(mn, mt, pivots, mas->max) - 1;
+	max_piv = ma_data_end(mn, mt, pivots, max) - 1;
 	/*
 	 * Check end implied pivot which can only be a gap on the right most
 	 * node.
 	 */
-	if (unlikely(mas->max == ULONG_MAX) && !slots[max_piv + 1]) {
+	if (unlikely(max == ULONG_MAX) && !slots[max_piv + 1]) {
 		gap = ULONG_MAX - pivots[max_piv];
 		if (gap > max_gap)
 			max_gap = gap;
 
-		if (max_gap > pivots[max_piv] - mas->min)
+		if (max_gap > pivots[max_piv] - min)
 			return max_gap;
 	}
 
@@ -1396,6 +1383,27 @@ static unsigned long mas_leaf_max_gap(st
 }
 
 /*
+ * mas_leaf_max_gap() - Returns the largest gap in a leaf node
+ * @mas: the maple state
+ *
+ * Return: The maximum gap in the leaf.
+ */
+static inline unsigned long mas_leaf_max_gap(struct ma_state *mas)
+{
+	enum maple_type mt;
+	struct maple_node *mn;
+	unsigned long *pivots;
+	void __rcu **slots;
+
+	mn = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	slots = ma_slots(mn, mt);
+	pivots = ma_pivots(mn, mt);
+
+	return ma_leaf_max_gap(mn, mt, mas->min, mas->max, pivots, slots);
+}
+
+/*
  * ma_max_gap() - Get the maximum gap in a maple node (non-leaf)
  * @node: The maple node
  * @gaps: The pointer to the gaps
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


