Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20964770E8
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247837; cv=none; b=Jq7/JqidxS6jMv9szZq1cAcbhHLqUFNCQmCu0ri5DN1FHEUtposPi+gWK7iusasd8AkeqtnSVQZoI1Bb2t7qtCLaGbUxrMG6mKkGHA0de7arjv6PurV2TutehQavi2fCxmB46YrVqbkQmzyXEGKX+Iy7QLt5VxVr9DolL4DD5S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247837; c=relaxed/simple;
	bh=sVwn89znvSf4ij/r8Dgg9gmynv0BgM9EXQS2S6hwAl8=;
	h=Date:To:From:Subject:Message-Id; b=ivzWW3z81K8dK3+6o28oNKctQx8kKoZHpqkaK6ZlqhSglrB5Wy0A7Xny74gFRiZD6JiC+N/O3Gn2sq8RsjKrt4dyUGNt1U0ACsBdl5VUiGEcQZ9WUGNK3pmeATk3U07fewJOKiVtb30RebBequvJXOmSLyRoUvLrMx/JOVejWEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPHbOiuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPHbOiuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1E4C4CEC2;
	Mon,  2 Sep 2024 03:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247837;
	bh=sVwn89znvSf4ij/r8Dgg9gmynv0BgM9EXQS2S6hwAl8=;
	h=Date:To:From:Subject:From;
	b=XPHbOiuh+TE4IZFpVN58B/lgsiuxL9R2cz15fnSJYgq7KvAB6L69HXwkNSEU5bnMC
	 MdZs7s3f6RvwKX3nQlXxQcewmWNGESPobZ2xvMwS0FilqRb5OM+JQnDzr7XTP9lF2k
	 5rHfwCSHjtj4Wrr7l/P911kNMmht2givGsY9QVOc=
Date: Sun, 01 Sep 2024 20:30:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-mas_commit_b_node.patch removed from -mm tree
Message-Id: <20240902033036.EE1E4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: simplify mas_commit_b_node()
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-mas_commit_b_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: simplify mas_commit_b_node()
Date: Wed, 14 Aug 2024 12:19:38 -0400

The only callers of mas_commit_b_node() are those with store type of
wr_rebalance and wr_split_store. Use mas->store_type to dispatch to the
correct helper function. This allows the removal of mas_reuse_node() as
it is no longer used.

Link: https://lkml.kernel.org/r/20240814161944.55347-12-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   64 ++++-----------------------------------------
 1 file changed, 7 insertions(+), 57 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_commit_b_node
+++ a/lib/maple_tree.c
@@ -3396,71 +3396,21 @@ static int mas_split(struct ma_state *ma
 }
 
 /*
- * mas_reuse_node() - Reuse the node to store the data.
- * @wr_mas: The maple write state
- * @bn: The maple big node
- * @end: The end of the data.
- *
- * Will always return false in RCU mode.
- *
- * Return: True if node was reused, false otherwise.
- */
-static inline bool mas_reuse_node(struct ma_wr_state *wr_mas,
-			  struct maple_big_node *bn, unsigned char end)
-{
-	/* Need to be rcu safe. */
-	if (mt_in_rcu(wr_mas->mas->tree))
-		return false;
-
-	if (end > bn->b_end) {
-		int clear = mt_slots[wr_mas->type] - bn->b_end;
-
-		memset(wr_mas->slots + bn->b_end, 0, sizeof(void *) * clear--);
-		memset(wr_mas->pivots + bn->b_end, 0, sizeof(void *) * clear);
-	}
-	mab_mas_cp(bn, 0, bn->b_end, wr_mas->mas, false);
-	return true;
-}
-
-/*
  * mas_commit_b_node() - Commit the big node into the tree.
  * @wr_mas: The maple write state
  * @b_node: The maple big node
- * @end: The end of the data.
  */
 static noinline_for_kasan int mas_commit_b_node(struct ma_wr_state *wr_mas,
-			    struct maple_big_node *b_node, unsigned char end)
+			    struct maple_big_node *b_node)
 {
-	struct maple_node *node;
-	struct maple_enode *old_enode;
-	unsigned char b_end = b_node->b_end;
-	enum maple_type b_type = b_node->type;
-
-	old_enode = wr_mas->mas->node;
-	if ((b_end < mt_min_slots[b_type]) &&
-	    (!mte_is_root(old_enode)) &&
-	    (mas_mt_height(wr_mas->mas) > 1))
-		return mas_rebalance(wr_mas->mas, b_node);
+	enum store_type type = wr_mas->mas->store_type;
 
-	if (b_end >= mt_slots[b_type])
-		return mas_split(wr_mas->mas, b_node);
+	WARN_ON_ONCE(type != wr_rebalance && type != wr_split_store);
 
-	if (mas_reuse_node(wr_mas, b_node, end))
-		goto reuse_node;
-
-	mas_node_count(wr_mas->mas, 1);
-	if (mas_is_err(wr_mas->mas))
-		return 0;
+	if (type == wr_rebalance)
+		return mas_rebalance(wr_mas->mas, b_node);
 
-	node = mas_pop_node(wr_mas->mas);
-	node->parent = mas_mn(wr_mas->mas)->parent;
-	wr_mas->mas->node = mt_mk_node(node, b_type);
-	mab_mas_cp(b_node, 0, b_end, wr_mas->mas, false);
-	mas_replace_node(wr_mas->mas, old_enode);
-reuse_node:
-	mas_update_gap(wr_mas->mas);
-	wr_mas->mas->end = b_end;
-	return 1;
+	return mas_split(wr_mas->mas, b_node);
 }
 
 /*
@@ -4155,7 +4105,7 @@ static void mas_wr_bnode(struct ma_wr_st
 	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	mas_commit_b_node(wr_mas, &b_node, wr_mas->mas->end);
+	mas_commit_b_node(wr_mas, &b_node);
 }
 
 static inline void mas_wr_modify(struct ma_wr_state *wr_mas)
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


