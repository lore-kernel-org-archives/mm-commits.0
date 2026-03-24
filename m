Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AA535F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388516; cv=none; b=SlxCSJBxCPshJwgupQ/zsfUkI0pFQjReqKN1QBLOI32lZlM6VfaX5HoIq3Sv17v40HrWG8OpdAWJFQaabkCa4dS3fHmeb0GHjZ8vcjIdcazH5+dyBdAYOOwxZeu6TU2rMTNrziuZa1uUnXzfsFbQC0ERXw5qLuXmWz3kCZS7orM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388516; c=relaxed/simple;
	bh=v5fYTJAB9UCZ97Iqm4BEiZgaqVNGXa3yU+urM7J4uXc=;
	h=Date:To:From:Subject:Message-Id; b=VvxGL+xD8VS7NNy5akEB0G1DCqsX5MQRUCRh8C5z/d12vLdOW6Db1PYbuyyDmAYNtqVJD0j3PLxpyajIThBBS+7CId5Da7e/z/ZLTeaeSZe+34fnUR1KAaZ9pFWyLevm0qmpSdKmGrh4FNxdYRZhSrrpEF+ilKt9DFPE5npWhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZlQ12UF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZlQ12UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E82C19424;
	Tue, 24 Mar 2026 21:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388516;
	bh=v5fYTJAB9UCZ97Iqm4BEiZgaqVNGXa3yU+urM7J4uXc=;
	h=Date:To:From:Subject:From;
	b=QZlQ12UFX2Zxtv4wA7LzwytP95WBWZ4OUc3k+/aPuMqIyr/gDm25x3BgKkHTd5tcj
	 xpBdo4CChZXplrQ7AsQp9nH2JC2jIIvOlO4mAlohZyslElFguWmM0eF0Rn95YkfjLL
	 I+tz+JyBXhoW41Fcu/s1BNbCsAtteuiW/GB9f7gM=
Date: Tue, 24 Mar 2026 14:41:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-separate-wr_split_store-and-wr_rebalance-store-type-code-path.patch removed from -mm tree
Message-Id: <20260324214155.E0E82C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: separate wr_split_store and wr_rebalance store type code path
has been removed from the -mm tree.  Its filename was
     maple_tree-separate-wr_split_store-and-wr_rebalance-store-type-code-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: separate wr_split_store and wr_rebalance store type code path
Date: Fri, 30 Jan 2026 15:59:25 -0500

The split and rebalance store types both go through the same function that
uses the big node.  Separate the code paths so that each can be updated
independently.

No functional change intended

Link: https://lkml.kernel.org/r/20260130205935.2559335-21-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   47 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- a/lib/maple_tree.c~maple_tree-separate-wr_split_store-and-wr_rebalance-store-type-code-path
+++ a/lib/maple_tree.c
@@ -3720,24 +3720,6 @@ static void mas_split(struct ma_state *m
 }
 
 /*
- * mas_commit_b_node() - Commit the big node into the tree.
- * @wr_mas: The maple write state
- * @b_node: The maple big node
- */
-static noinline_for_kasan void mas_commit_b_node(struct ma_wr_state *wr_mas,
-			    struct maple_big_node *b_node)
-{
-	enum store_type type = wr_mas->mas->store_type;
-
-	WARN_ON_ONCE(type != wr_rebalance && type != wr_split_store);
-
-	if (type == wr_rebalance)
-		return mas_rebalance(wr_mas->mas, b_node);
-
-	return mas_split(wr_mas->mas, b_node);
-}
-
-/*
  * mas_root_expand() - Expand a root to a node
  * @mas: The maple state
  * @entry: The entry to store into the tree
@@ -4373,19 +4355,34 @@ static inline void mas_wr_append(struct
 }
 
 /*
- * mas_wr_bnode() - Slow path for a modification.
+ * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
- *
- * This is where split, rebalance end up.
  */
-static void mas_wr_bnode(struct ma_wr_state *wr_mas)
+static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	mas_commit_b_node(wr_mas, &b_node);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
+	return mas_split(wr_mas->mas, &b_node);
+}
+
+/*
+ * mas_wr_rebalance() - Insufficient data in one node needs to either get data
+ * from a sibling or absorb a sibling all together.
+ * @wr_mas: The write maple state
+ */
+static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+{
+	struct maple_big_node b_node;
+
+	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
+	return mas_rebalance(wr_mas->mas, &b_node);
 }
 
 /*
@@ -4416,8 +4413,10 @@ static inline void mas_wr_store_entry(st
 		mas_wr_spanning_store(wr_mas);
 		break;
 	case wr_split_store:
+		mas_wr_split(wr_mas);
+		break;
 	case wr_rebalance:
-		mas_wr_bnode(wr_mas);
+		mas_wr_rebalance(wr_mas);
 		break;
 	case wr_new_root:
 		mas_new_root(mas, wr_mas->entry);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


