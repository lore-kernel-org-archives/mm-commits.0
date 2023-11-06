Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D62C4167D
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjKFR2Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbjKFR2Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:28:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7494D45
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:28:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F3FC433C7;
        Mon,  6 Nov 2023 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699291692;
        bh=Bh1r62s4mdjcfvKBrBOTRB4GOKb9e3u76fMo8IrF1K4=;
        h=Date:To:From:Subject:From;
        b=O4QBkgJkbEpLofXGPrS/I+yy2nWC7H4nNOqv9Jtkl72XDNFW4uJeoiHhcv7d8BZ9D
         fvW85fqOrABIogcYGjVxSzmp0+ZZy1m/gFKKvmVh80T5WhQ1h4HX652edlSy/SGfVQ
         cRAi1sO8IbjcCHTigA9oIWZOytBjj6tTh2CNvBdA=
Date:   Mon, 06 Nov 2023 09:28:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        peterz@infradead.org, npiggin@gmail.com, mst@redhat.com,
        mjguzik@gmail.com, michael.christie@oracle.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        corbet@lwn.net, brauner@kernel.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-check_forking-and-bench_forking.patch added to mm-unstable branch
Message-Id: <20231106172812.54F3FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: update check_forking() and bench_forking()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-update-check_forking-and-bench_forking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-check_forking-and-bench_forking.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: update check_forking() and bench_forking()
Date: Fri, 27 Oct 2023 11:38:43 +0800

Updated check_forking() and bench_forking() to use __mt_dup() to duplicate
maple tree.

Link: https://lkml.kernel.org/r/20231027033845.90608-9-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c       |  117 ++++++++++++++++------------------
 tools/include/linux/rwsem.h |    4 +
 2 files changed, 62 insertions(+), 59 deletions(-)

--- a/lib/test_maple_tree.c~maple_tree-update-check_forking-and-bench_forking
+++ a/lib/test_maple_tree.c
@@ -1834,47 +1834,48 @@ static noinline void __init bench_mas_pr
 }
 #endif
 /* check_forking - simulate the kernel forking sequence with the tree. */
-static noinline void __init check_forking(struct maple_tree *mt)
+static noinline void __init check_forking(void)
 {
-
-	struct maple_tree newmt;
-	int i, nr_entries = 134;
+	struct maple_tree mt, newmt;
+	int i, nr_entries = 134, ret;
 	void *val;
-	MA_STATE(mas, mt, 0, 0);
-	MA_STATE(newmas, mt, 0, 0);
-	struct rw_semaphore newmt_lock;
+	MA_STATE(mas, &mt, 0, 0);
+	MA_STATE(newmas, &newmt, 0, 0);
+	struct rw_semaphore mt_lock, newmt_lock;
 
+	init_rwsem(&mt_lock);
 	init_rwsem(&newmt_lock);
 
-	for (i = 0; i <= nr_entries; i++)
-		mtree_store_range(mt, i*10, i*10 + 5,
-				  xa_mk_value(i), GFP_KERNEL);
+	mt_init_flags(&mt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&mt, &mt_lock);
 
-	mt_set_non_kernel(99999);
 	mt_init_flags(&newmt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
 	mt_set_external_lock(&newmt, &newmt_lock);
-	newmas.tree = &newmt;
-	mas_reset(&newmas);
-	mas_reset(&mas);
-	down_write(&newmt_lock);
-	mas.index = 0;
-	mas.last = 0;
-	if (mas_expected_entries(&newmas, nr_entries)) {
+
+	down_write(&mt_lock);
+	for (i = 0; i <= nr_entries; i++) {
+		mas_set_range(&mas, i*10, i*10 + 5);
+		mas_store_gfp(&mas, xa_mk_value(i), GFP_KERNEL);
+	}
+
+	down_write_nested(&newmt_lock, SINGLE_DEPTH_NESTING);
+	ret = __mt_dup(&mt, &newmt, GFP_KERNEL);
+	if (ret) {
 		pr_err("OOM!");
 		BUG_ON(1);
 	}
-	rcu_read_lock();
-	mas_for_each(&mas, val, ULONG_MAX) {
-		newmas.index = mas.index;
-		newmas.last = mas.last;
+
+	mas_set(&newmas, 0);
+	mas_for_each(&newmas, val, ULONG_MAX)
 		mas_store(&newmas, val);
-	}
-	rcu_read_unlock();
+
 	mas_destroy(&newmas);
+	mas_destroy(&mas);
 	mt_validate(&newmt);
-	mt_set_non_kernel(0);
 	__mt_destroy(&newmt);
+	__mt_destroy(&mt);
 	up_write(&newmt_lock);
+	up_write(&mt_lock);
 }
 
 static noinline void __init check_iteration(struct maple_tree *mt)
@@ -1977,49 +1978,51 @@ static noinline void __init check_mas_st
 }
 
 #if defined(BENCH_FORK)
-static noinline void __init bench_forking(struct maple_tree *mt)
+static noinline void __init bench_forking(void)
 {
-
-	struct maple_tree newmt;
-	int i, nr_entries = 134, nr_fork = 80000;
+	struct maple_tree mt, newmt;
+	int i, nr_entries = 134, nr_fork = 80000, ret;
 	void *val;
-	MA_STATE(mas, mt, 0, 0);
-	MA_STATE(newmas, mt, 0, 0);
-	struct rw_semaphore newmt_lock;
+	MA_STATE(mas, &mt, 0, 0);
+	MA_STATE(newmas, &newmt, 0, 0);
+	struct rw_semaphore mt_lock, newmt_lock;
 
+	init_rwsem(&mt_lock);
 	init_rwsem(&newmt_lock);
-	mt_set_external_lock(&newmt, &newmt_lock);
 
-	for (i = 0; i <= nr_entries; i++)
-		mtree_store_range(mt, i*10, i*10 + 5,
-				  xa_mk_value(i), GFP_KERNEL);
+	mt_init_flags(&mt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&mt, &mt_lock);
+
+	down_write(&mt_lock);
+	for (i = 0; i <= nr_entries; i++) {
+		mas_set_range(&mas, i*10, i*10 + 5);
+		mas_store_gfp(&mas, xa_mk_value(i), GFP_KERNEL);
+	}
 
 	for (i = 0; i < nr_fork; i++) {
-		mt_set_non_kernel(99999);
-		mt_init_flags(&newmt, MT_FLAGS_ALLOC_RANGE);
-		newmas.tree = &newmt;
-		mas_reset(&newmas);
-		mas_reset(&mas);
-		mas.index = 0;
-		mas.last = 0;
-		rcu_read_lock();
-		down_write(&newmt_lock);
-		if (mas_expected_entries(&newmas, nr_entries)) {
-			printk("OOM!");
+		mt_init_flags(&newmt,
+			      MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
+		mt_set_external_lock(&newmt, &newmt_lock);
+
+		down_write_nested(&newmt_lock, SINGLE_DEPTH_NESTING);
+		ret = __mt_dup(&mt, &newmt, GFP_KERNEL);
+		if (ret) {
+			pr_err("OOM!");
 			BUG_ON(1);
 		}
-		mas_for_each(&mas, val, ULONG_MAX) {
-			newmas.index = mas.index;
-			newmas.last = mas.last;
+
+		mas_set(&newmas, 0);
+		mas_for_each(&newmas, val, ULONG_MAX)
 			mas_store(&newmas, val);
-		}
+
 		mas_destroy(&newmas);
-		rcu_read_unlock();
 		mt_validate(&newmt);
-		mt_set_non_kernel(0);
 		__mt_destroy(&newmt);
 		up_write(&newmt_lock);
 	}
+	mas_destroy(&mas);
+	__mt_destroy(&mt);
+	up_write(&mt_lock);
 }
 #endif
 
@@ -3615,9 +3618,7 @@ static int __init maple_tree_seed(void)
 #endif
 #if defined(BENCH_FORK)
 #define BENCH
-	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
-	bench_forking(&tree);
-	mtree_destroy(&tree);
+	bench_forking();
 	goto skip;
 #endif
 #if defined(BENCH_MT_FOR_EACH)
@@ -3650,9 +3651,7 @@ static int __init maple_tree_seed(void)
 	check_iteration(&tree);
 	mtree_destroy(&tree);
 
-	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
-	check_forking(&tree);
-	mtree_destroy(&tree);
+	check_forking();
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_mas_store_gfp(&tree);
--- a/tools/include/linux/rwsem.h~maple_tree-update-check_forking-and-bench_forking
+++ a/tools/include/linux/rwsem.h
@@ -37,4 +37,8 @@ static inline int up_write(struct rw_sem
 {
 	return pthread_rwlock_unlock(&sem->lock);
 }
+
+#define down_read_nested(sem, subclass)		down_read(sem)
+#define down_write_nested(sem, subclass)	down_write(sem)
+
 #endif /* _TOOLS_RWSEM_H */
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-mt_free_one-and-mt_attr-helpers.patch
maple_tree-introduce-mtreemas_lock_nested.patch
maple_tree-introduce-interfaces-__mt_dup-and-mtree_dup.patch
radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch
maple_tree-add-test-for-mtree_dup.patch
maple_tree-update-the-documentation-of-maple-tree.patch
maple_tree-skip-other-tests-when-bench-is-enabled.patch
maple_tree-update-check_forking-and-bench_forking.patch
maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch
fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch

