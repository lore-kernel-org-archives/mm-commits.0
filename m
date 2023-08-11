Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518D7C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbjHKXNh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbjHKXNF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871944690
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E1566464E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75549C433C8;
        Fri, 11 Aug 2023 23:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794957;
        bh=q6Gt6/iibWvqq+saC0qzHFXq6fhByyhssmjYjJAXVsI=;
        h=Date:To:From:Subject:From;
        b=Wsu5nQIe80m1vTRfOap4Ebd9Mwb8MHjlFZBz3FroDL41SddBshiTAsnPffxHsOYj9
         NVEAxc/TlRQ0arsZEJLerT56MckVSIngXGOL/4Kbfb2IuES5WXw4bOf+ek5QolVs7F
         C8S0DJw8llYwH2n4XDzKoQcY5T9AopcKnyjWx4NI=
Date:   Fri, 11 Aug 2023 16:02:36 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-benchmarking-for-mas_for_each.patch removed from -mm tree
Message-Id: <20230811230237.75549C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add benchmarking for mas_for_each
has been removed from the -mm tree.  Its filename was
     maple_tree-add-benchmarking-for-mas_for_each.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add benchmarking for mas_for_each
Date: Mon, 24 Jul 2023 14:31:43 -0400

Patch series "Reduce preallocations for maple tree", v3.

Initial work on preallocations showed no regression in performance during
testing, but recently some users (both on [1] and off [android] list) have
reported that preallocating the worst-case number of nodes has caused some
slow down.  This patch set addresses the number of allocations in a few
ways.

During munmap() most munmap() operations will remove a single VMA, so
leverage the fact that the maple tree can place a single pointer at range
0 - 0 without allocating.  This is done by changing the index of the VMAs
to be indexed by the count, starting at 0.

Re-introduce the entry argument to mas_preallocate() so that a more
intelligent guess of the node count can be made.

Implement the more intelligent guess of the node count, although there is
more work to be done.

During development of v2 of this patch set, I also noticed that the number
of nodes being allocated for a rebalance was beyond what could possibly be
needed.  This is addressed in patch 0008.


This patch (of 15):

Add a way to test the speed of mas_for_each() to the testing code.

Link: https://lkml.kernel.org/r/20230724183157.3939892-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230724183157.3939892-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-benchmarking-for-mas_for_each
+++ a/lib/test_maple_tree.c
@@ -44,6 +44,7 @@ atomic_t maple_tree_tests_passed;
 /* #define BENCH_WALK */
 /* #define BENCH_MT_FOR_EACH */
 /* #define BENCH_FORK */
+/* #define BENCH_MAS_FOR_EACH */
 
 #ifdef __KERNEL__
 #define mt_set_non_kernel(x)		do {} while (0)
@@ -1770,6 +1771,37 @@ static noinline void __init bench_mt_for
 }
 #endif
 
+#if defined(BENCH_MAS_FOR_EACH)
+static noinline void __init bench_mas_for_each(struct maple_tree *mt)
+{
+	int i, count = 1000000;
+	unsigned long max = 2500;
+	void *entry;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 0; i < max; i += 5) {
+		int gap = 4;
+
+		if (i % 30 == 0)
+			gap = 3;
+		mtree_store_range(mt, i, i + gap, xa_mk_value(i), GFP_KERNEL);
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < count; i++) {
+		unsigned long j = 0;
+
+		mas_for_each(&mas, entry, max) {
+			MT_BUG_ON(mt, entry != xa_mk_value(j));
+			j += 5;
+		}
+		mas_set(&mas, 0);
+	}
+	rcu_read_unlock();
+
+}
+#endif
+
 /* check_forking - simulate the kernel forking sequence with the tree. */
 static noinline void __init check_forking(struct maple_tree *mt)
 {
@@ -3498,6 +3530,13 @@ static int __init maple_tree_seed(void)
 	mtree_destroy(&tree);
 	goto skip;
 #endif
+#if defined(BENCH_MAS_FOR_EACH)
+#define BENCH
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	bench_mas_for_each(&tree);
+	mtree_destroy(&tree);
+	goto skip;
+#endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_iteration(&tree);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

