Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F017F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZrKWPPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE2DC433C9;
	Tue, 12 Dec 2023 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407549;
	bh=yXgVEnX4JkoJQsTnqaThYI7y82veYCgEIA41T6/OQk0=;
	h=Date:To:From:Subject:From;
	b=QZrKWPPdJDJvg1WzvfESxDYbjrry1g2onud324IgS4KzcygnQvBYq2qWgD6cKhMVH
	 ciZFB6JN98ySrpfghA29hazxQsyKlapFun3ZnCx/imQJXeGXtL7p5gP86ROcahL6pA
	 tfnF6dGAUgvs+QeGEFL7KYFruUfeRxi+0ycUYqDg=
Date: Tue, 12 Dec 2023 10:59:09 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch removed from -mm tree
Message-Id: <20231212185909.CCE2DC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: don't find node end in mtree_lookup_walk()
has been removed from the -mm tree.  Its filename was
     maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: don't find node end in mtree_lookup_walk()
Date: Wed, 1 Nov 2023 13:16:28 -0400

Since the pivot being set is now reliable, the optimized loop no longer
needs to find the node end.  The redundant check for a dead node can also
be avoided as there is no danger of using the wrong pivot since the
results will be thrown out in the case of a dead node by the later check.

This patch also adds a benchmark test for the function to the maple tree
test framework.  The benchmark shows an average increase performance of
5.98% over 3 runs with this commit.

Link: https://lkml.kernel.org/r/20231101171629.3612299-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |   12 +++---------
 lib/test_maple_tree.c |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-dont-find-node-end-in-mtree_lookup_walk
+++ a/lib/maple_tree.c
@@ -3742,23 +3742,17 @@ static inline void *mtree_lookup_walk(st
 	enum maple_type type;
 	void __rcu **slots;
 	unsigned char end;
-	unsigned long max;
 
 	next = mas->node;
-	max = ULONG_MAX;
 	do {
-		offset = 0;
 		node = mte_to_node(next);
 		type = mte_node_type(next);
 		pivots = ma_pivots(node, type);
-		end = ma_data_end(node, type, pivots, max);
-		if (unlikely(ma_dead_node(node)))
-			goto dead_node;
+		end = mt_pivots[type];
+		offset = 0;
 		do {
-			if (pivots[offset] >= mas->index) {
-				max = pivots[offset];
+			if (pivots[offset] >= mas->index)
 				break;
-			}
 		} while (++offset < end);
 
 		slots = ma_slots(node, type);
--- a/lib/test_maple_tree.c~maple_tree-dont-find-node-end-in-mtree_lookup_walk
+++ a/lib/test_maple_tree.c
@@ -43,6 +43,7 @@ atomic_t maple_tree_tests_passed;
 /* #define BENCH_NODE_STORE */
 /* #define BENCH_AWALK */
 /* #define BENCH_WALK */
+/* #define BENCH_LOAD */
 /* #define BENCH_MT_FOR_EACH */
 /* #define BENCH_FORK */
 /* #define BENCH_MAS_FOR_EACH */
@@ -1754,6 +1755,19 @@ static noinline void __init bench_walk(s
 }
 #endif
 
+#if defined(BENCH_LOAD)
+static noinline void __init bench_load(struct maple_tree *mt)
+{
+	int i, max = 2500, count = 550000000;
+
+	for (i = 0; i < max; i += 10)
+		mtree_store_range(mt, i, i + 5, xa_mk_value(i), GFP_KERNEL);
+
+	for (i = 0; i < count; i++)
+		mtree_load(mt, 1470);
+}
+#endif
+
 #if defined(BENCH_MT_FOR_EACH)
 static noinline void __init bench_mt_for_each(struct maple_tree *mt)
 {
@@ -3623,6 +3637,13 @@ static int __init maple_tree_seed(void)
 	mtree_destroy(&tree);
 	goto skip;
 #endif
+#if defined(BENCH_LOAD)
+#define BENCH
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	bench_load(&tree);
+	mtree_destroy(&tree);
+	goto skip;
+#endif
 #if defined(BENCH_FORK)
 #define BENCH
 	bench_forking();
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


