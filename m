Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1304AC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 19:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjKHTxD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 14:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjKHTxD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 14:53:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEA31FC3
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 11:53:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF52C433C8;
        Wed,  8 Nov 2023 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699473180;
        bh=QdxFRmGD3+6fj2XOHt1H/Fs42AgNNYI05IGAu6A9EWc=;
        h=Date:To:From:Subject:From;
        b=m4y5w3FDlF0ypREBZQ8rMm0otaC5k6jbxecyZaCW8v1BPAWd7x0vGnkxFc8zGLYV8
         O03ST5FXCLOGVDl9/FLzY8JCAfpZUkNujB91XRpew6CJVmXBrmPPR840vwwdamqQ1D
         g/LwQnfJTs/joRDthwUdB7rHSUJ206ANkM3mmDrc=
Date:   Wed, 08 Nov 2023 11:53:00 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch added to mm-unstable branch
Message-Id: <20231108195300.DDF52C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: don't find node end in mtree_lookup_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch

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
@@ -3618,6 +3632,13 @@ static int __init maple_tree_seed(void)
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

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

