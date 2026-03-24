Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565953612FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388521; cv=none; b=UHjJ22FlXGkeTaSdOlj09xy1iUEO8xGfO1E4BG3X1YJH05+n1bKfNe7NM2PlkkH/ARcKUki/PkA1PHdHO6U6E++FH02+0nDYaoTHWu1o0cD/pORqzCxh3qjhbeVaYW+4hTSPmZ4EuDnuDsCdEMND6GST8Q1xbN3Rhj0AiUYzQdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388521; c=relaxed/simple;
	bh=IBu/USu1zOldxApAhF2NXcwvvfq9O8Iiv7u8bhSQVU8=;
	h=Date:To:From:Subject:Message-Id; b=nt9I3kXOWcJaixsVUoN2TqrFFI+DLGKsjqTiczECqG9c0BJKNHPJeXh9+B9j2tWy80ffcrkEoIt9Xx0fGuYvLtEiecIPfOXQf3PQt8to5Ls9NJEZw6r/jN5D24awHNavy3mcXjbZe5X+GBAFqE/LGHXpU4nEKNdf1RiMwYs03dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WGYN76eT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WGYN76eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A85C19424;
	Tue, 24 Mar 2026 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388521;
	bh=IBu/USu1zOldxApAhF2NXcwvvfq9O8Iiv7u8bhSQVU8=;
	h=Date:To:From:Subject:From;
	b=WGYN76eTfwfAwECqlVFUNiQzMMt7DyZhTDeKvs63r6sclJUj+X0AIoxaFGhTqZmUR
	 pnv7cXt2uYec60wsdX8ne0iDFMLfCLtEbFHYBfEYDSKFYOtT12EBRQ5pLwIe/IEYz+
	 bvVt4LuT5nBC5UWulz4V5tfNj8HoyqVlNTtfWIgc=
Date: Tue, 24 Mar 2026 14:42:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-test-for-rebalance-calculation-off-by-one.patch removed from -mm tree
Message-Id: <20260324214200.E7A85C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add test for rebalance calculation off-by-one
has been removed from the -mm tree.  Its filename was
     maple_tree-add-test-for-rebalance-calculation-off-by-one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add test for rebalance calculation off-by-one
Date: Fri, 30 Jan 2026 15:59:28 -0500

During the big node removal, an incorrect rebalance step went too far up
the tree causing insufficient nodes.  Test the faulty condition by
recreating the scenario in the userspace testing.

Link: https://lkml.kernel.org/r/20260130205935.2559335-24-Liam.Howlett@oracle.com
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

 tools/testing/radix-tree/maple.c |  125 +++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-add-test-for-rebalance-calculation-off-by-one
+++ a/tools/testing/radix-tree/maple.c
@@ -35888,6 +35888,127 @@ unlock:
 	return ret;
 }
 
+static noinline void __init check_erase_rebalance(struct maple_tree *mt)
+{
+	unsigned long val;
+	void *enode;
+	int ret;
+
+	MA_STATE(mas, mt, 0, 0);
+
+	/*
+	 * During removal of big node, the rebalance started going too high,
+	 * which resulted in too many nodes trying to be used.
+	 *
+	 * Create a rebalance which results in an exactly full parent (0-9) that
+	 * does not need to be rebalanced.  This required two full levels,
+	 * followed by an insufficient level which will be rebalanced into two
+	 * nodes, finally leaves that need to be rebalanced into one node.
+	 *
+	 * The bugs tree:
+	 * root    4      Label     R
+	 *        /\               /\
+	 *       9   X            F
+	 *      /\   /\          /
+	 *     9   X            E
+	 *    /\   /\          /\
+	 *   4  8             C  D
+	 *  /\               /\
+	 * 6  9             A  B
+	 * ^ becomes 5 with the write.
+	 *
+	 * Below, the reconstruction leaves the root with 2 entries, the setup
+	 * uses the letter labels above.
+	 */
+
+	ret = build_full_tree(mt, MT_FLAGS_ALLOC_RANGE, 4);
+	MT_BUG_ON(mt, ret);
+
+	/* Cheap expansion to 5 levels */
+	mtree_store(mt, ULONG_MAX, xa_mk_value(0), GFP_KERNEL);
+	/* rcu is used to ensure node use */
+	mt_set_in_rcu(mt);
+	mas_lock(&mas);
+
+	/* Node A had 6 entries */
+	mas_walk(&mas);
+	MAS_BUG_ON(&mas, mas_data_end(&mas) < 6);
+	while (mas_data_end(&mas) > 6) {
+		mas_erase(&mas);
+		mas_next(&mas, ULONG_MAX);
+	}
+
+	/* Move to Node B */
+	enode = (void*) mas.node;
+	while (mas.node == enode)
+		mas_next(&mas, ULONG_MAX);
+
+	/* Node B had 9 entries */
+	MAS_BUG_ON(&mas, mas_data_end(&mas) < 9);
+	while (mas_data_end(&mas) > 9) {
+		mas_erase(&mas);
+		mas_next(&mas, ULONG_MAX);
+	}
+
+	/* Move to Node C */
+	mas_ascend(&mas);
+	val = mas.max;
+	/* Adjust entries to be 4 */
+	while (mas_data_end(&mas) > 4) {
+		mas_set(&mas, val);
+		mas_erase(&mas);
+		mas_prev(&mas, 0);
+		val = mas.index;
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node D */
+	mas_ascend(&mas);
+	mas.offset = 1;
+	mas_descend(&mas);
+	val = mas.max;
+	/* Adjust entries to be 8 */
+	while (mas_data_end(&mas) < 8) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node E */
+	mas_ascend(&mas);
+	val = mas.max;
+	MAS_BUG_ON(&mas, mas_data_end(&mas) > 9);
+	/* Adjust Node E to 9 entries */
+	while (mas_data_end(&mas) < 9) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node F */
+	mas_ascend(&mas);
+	val = mas.max;
+	MAS_BUG_ON(&mas, mas_data_end(&mas) > 9);
+	/* Adjust Node F to 9 entries */
+	while (mas_data_end(&mas) < 9) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+	}
+
+	/* Test is set up, walk to first entry */
+	mas_set(&mas, 0);
+	mas_next(&mas, ULONG_MAX);
+	/* overwrite the entry to cause a rebalance, which was 1 too few */
+	mas_set_range(&mas, 0, mas.last);
+	mas_preallocate(&mas, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas, NULL);
+	mas_unlock(&mas);
+}
+
 static noinline void __init check_mtree_dup(struct maple_tree *mt)
 {
 	DEFINE_MTREE(new);
@@ -36249,6 +36370,10 @@ void farmer_tests(void)
 	check_mtree_dup(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_erase_rebalance(&tree);
+	mtree_destroy(&tree);
+
 	/* RCU testing */
 	mt_init_flags(&tree, 0);
 	check_erase_testset(&tree);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


