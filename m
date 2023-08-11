Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57B4C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbjHKXNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbjHKXN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B994691
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F70963F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FBAC433C7;
        Fri, 11 Aug 2023 23:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794958;
        bh=BPtB9sZEAP0aIek6JfSqOB+b1LPAi9H9Jju8y+4RwPs=;
        h=Date:To:From:Subject:From;
        b=ts0Hf5LxGJdhRtJudQ4+J8rw331lPmOYpuvsg5Frzn2sPwp8FA7dbiet3jhrhxhZN
         8mF8iD4nXCnH/9po7GFvL+U30T2YXGxAXjuPYPJvB6f/XOmbxtRv7fu/cXyJSNgLrK
         NZuUuIm3lehcvTCx63czmIVndVu6qYgmcGBMxk6A=
Date:   Fri, 11 Aug 2023 16:02:38 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-benchmarking-for-mas_prev.patch removed from -mm tree
Message-Id: <20230811230238.91FBAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add benchmarking for mas_prev()
has been removed from the -mm tree.  Its filename was
     maple_tree-add-benchmarking-for-mas_prev.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add benchmarking for mas_prev()
Date: Mon, 24 Jul 2023 14:31:44 -0400

Add some benchmarking functions in testing for mas_prev().  This is
useful to ensure there are no regressions added during modifications.

Link: https://lkml.kernel.org/r/20230724183157.3939892-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-benchmarking-for-mas_prev
+++ a/lib/test_maple_tree.c
@@ -45,6 +45,7 @@ atomic_t maple_tree_tests_passed;
 /* #define BENCH_MT_FOR_EACH */
 /* #define BENCH_FORK */
 /* #define BENCH_MAS_FOR_EACH */
+/* #define BENCH_MAS_PREV */
 
 #ifdef __KERNEL__
 #define mt_set_non_kernel(x)		do {} while (0)
@@ -1801,7 +1802,36 @@ static noinline void __init bench_mas_fo
 
 }
 #endif
+#if defined(BENCH_MAS_PREV)
+static noinline void __init bench_mas_prev(struct maple_tree *mt)
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
+		unsigned long j = 2495;
+
+		mas_set(&mas, ULONG_MAX);
+		while ((entry = mas_prev(&mas, 0)) != NULL) {
+			MT_BUG_ON(mt, entry != xa_mk_value(j));
+			j -= 5;
+		}
+	}
+	rcu_read_unlock();
 
+}
+#endif
 /* check_forking - simulate the kernel forking sequence with the tree. */
 static noinline void __init check_forking(struct maple_tree *mt)
 {
@@ -3537,6 +3567,13 @@ static int __init maple_tree_seed(void)
 	mtree_destroy(&tree);
 	goto skip;
 #endif
+#if defined(BENCH_MAS_PREV)
+#define BENCH
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	bench_mas_prev(&tree);
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

