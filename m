Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4071AAE25
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583214; cv=none; b=q0Db7rxd26HUEgNL+aI0sXyLVEWMWhwA4R4vYUmTnFcfDI4ZlkFKg+cVh9gBiTA7t/OMGnBB2G3vLfTqMdrRN1kSlZLli9vjGYCqDziw21rRg/Qk7JSSzDKkAruAx4paLfrpMiNLi/3KXTn6bWnbsGLSs5Nui2Ye4C/3JlqyESo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583214; c=relaxed/simple;
	bh=pEMw7ZKL0XEZHaAW2O5FJE8lwD4cfesJpDUBKcSGKoE=;
	h=Date:To:From:Subject:Message-Id; b=Uhcqll52y8vEzYQKa39GAbktg2UdJZxDweA1Q67JbhSKRpzG8EWrlmJLiYNOE0CF2PuOiY/Nzbdc/Z5nl6XSOuYJz4YDdAM+r23sWrGjyVkeQ4u/PDxXMZQRbhGhiK8iNEMbPz5T5LvKBzNUdIhBWClQGgpGWXZ5kDpM07CwhUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MnGeBsIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MnGeBsIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50842C4AF10;
	Tue, 13 Aug 2024 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723583214;
	bh=pEMw7ZKL0XEZHaAW2O5FJE8lwD4cfesJpDUBKcSGKoE=;
	h=Date:To:From:Subject:From;
	b=MnGeBsIaGYWgkcsG91+1BytX4OyY83vyKhUgOs1X5tKnOdRC8QwvDbi2NdmcBNEqH
	 TGdvgvli/lqGjmlZLymsyi6vvCxIO+BYS8XLQrYzpatVo7ra1K6wB2G55XtBmhinIY
	 60ORgzEk3ks0goNP/oVUhSn/xE8Gh3zFM3clVxZA=
Date: Tue, 13 Aug 2024 14:06:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-test-to-replicate-low-memory-race-conditions.patch added to mm-unstable branch
Message-Id: <20240813210654.50842C4AF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add test to replicate low memory race conditions
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-test-to-replicate-low-memory-race-conditions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-test-to-replicate-low-memory-race-conditions.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: add test to replicate low memory race conditions
Date: Mon, 12 Aug 2024 15:05:43 -0400

Add new callback fields to the userspace implementation of struct
kmem_cache.  This allows for executing callback functions in order to
further test low memory scenarios where node allocation is retried.

This callback can help test race conditions by calling a function when a
low memory event is tested.

Link: https://lkml.kernel.org/r/20240812190543.71967-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   13 +++++
 tools/testing/radix-tree/maple.c |   63 +++++++++++++++++++++++++++++
 tools/testing/shared/linux.c     |   26 +++++++++++
 3 files changed, 101 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-add-test-to-replicate-low-memory-race-conditions
+++ a/lib/maple_tree.c
@@ -7005,6 +7005,19 @@ void mt_set_non_kernel(unsigned int val)
 	kmem_cache_set_non_kernel(maple_node_cache, val);
 }
 
+extern void kmem_cache_set_callback(struct kmem_cache *cachep,
+		void (*callback)(void *));
+void mt_set_callback(void (*callback)(void *))
+{
+	kmem_cache_set_callback(maple_node_cache, callback);
+}
+
+extern void kmem_cache_set_private(struct kmem_cache *cachep, void *private);
+void mt_set_private(void *private)
+{
+	kmem_cache_set_private(maple_node_cache, private);
+}
+
 extern unsigned long kmem_cache_get_alloc(struct kmem_cache *);
 unsigned long mt_get_alloc_size(void)
 {
--- a/tools/testing/radix-tree/maple.c~maple_tree-add-test-to-replicate-low-memory-race-conditions
+++ a/tools/testing/radix-tree/maple.c
@@ -36224,6 +36224,65 @@ static noinline void __init check_mtree_
 
 extern void test_kmem_cache_bulk(void);
 
+/* callback function used for check_nomem_writer_race() */
+static void writer2(void *maple_tree)
+{
+	struct maple_tree *mt = (struct maple_tree *)maple_tree;
+	MA_STATE(mas, mt, 6, 10);
+
+	mtree_lock(mas.tree);
+	mas_store(&mas, xa_mk_value(0xC));
+	mas_destroy(&mas);
+	mtree_unlock(mas.tree);
+}
+
+/*
+ * check_nomem_writer_race() - test a possible race in the mas_nomem() path
+ * @mt: The tree to build.
+ *
+ * There is a possible race condition in low memory conditions when mas_nomem()
+ * gives up its lock. A second writer can chagne the entry that the primary
+ * writer executing the mas_nomem() path is modifying. This test recreates this
+ * scenario to ensure we are handling it correctly.
+ */
+static void check_nomem_writer_race(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, 0, 5);
+
+	mt_set_non_kernel(0);
+	/* setup root with 2 values with NULL in between */
+	mtree_store_range(mt, 0, 5, xa_mk_value(0xA), GFP_KERNEL);
+	mtree_store_range(mt, 6, 10, NULL, GFP_KERNEL);
+	mtree_store_range(mt, 11, 15, xa_mk_value(0xB), GFP_KERNEL);
+
+	/* setup writer 2 that will trigger the race condition */
+	mt_set_private(mt);
+	mt_set_callback(writer2);
+
+	mtree_lock(mt);
+	/* erase 0-5 */
+	mas_erase(&mas);
+
+	/* index 6-10 should retain the value from writer 2 */
+	check_load(mt, 6, xa_mk_value(0xC));
+	mtree_unlock(mt);
+
+	/* test for the same race but with mas_store_gfp() */
+	mtree_store_range(mt, 0, 5, xa_mk_value(0xA), GFP_KERNEL);
+	mtree_store_range(mt, 6, 10, NULL, GFP_KERNEL);
+
+	mas_set_range(&mas, 0, 5);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+
+	/* ensure write made by writer 2 is retained */
+	check_load(mt, 6, xa_mk_value(0xC));
+
+	mt_set_private(NULL);
+	mt_set_callback(NULL);
+	mtree_unlock(mt);
+}
+
 void farmer_tests(void)
 {
 	struct maple_node *node;
@@ -36257,6 +36316,10 @@ void farmer_tests(void)
 	check_dfs_preorder(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_USE_RCU);
+	check_nomem_writer_race(&tree);
+	mtree_destroy(&tree);
+
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_prealloc(&tree);
 	mtree_destroy(&tree);
--- a/tools/testing/shared/linux.c~maple_tree-add-test-to-replicate-low-memory-race-conditions
+++ a/tools/testing/shared/linux.c
@@ -26,8 +26,21 @@ struct kmem_cache {
 	unsigned int non_kernel;
 	unsigned long nr_allocated;
 	unsigned long nr_tallocated;
+	bool exec_callback;
+	void (*callback)(void *);
+	void *private;
 };
 
+void kmem_cache_set_callback(struct kmem_cache *cachep, void (*callback)(void *))
+{
+	cachep->callback = callback;
+}
+
+void kmem_cache_set_private(struct kmem_cache *cachep, void *private)
+{
+	cachep->private = private;
+}
+
 void kmem_cache_set_non_kernel(struct kmem_cache *cachep, unsigned int val)
 {
 	cachep->non_kernel = val;
@@ -58,9 +71,17 @@ void *kmem_cache_alloc_lru(struct kmem_c
 {
 	void *p;
 
+	if (cachep->exec_callback) {
+		if (cachep->callback)
+			cachep->callback(cachep->private);
+		cachep->exec_callback = false;
+	}
+
 	if (!(gfp & __GFP_DIRECT_RECLAIM)) {
-		if (!cachep->non_kernel)
+		if (!cachep->non_kernel) {
+			cachep->exec_callback = true;
 			return NULL;
+		}
 
 		cachep->non_kernel--;
 	}
@@ -223,6 +244,9 @@ kmem_cache_create(const char *name, unsi
 	ret->objs = NULL;
 	ret->ctor = ctor;
 	ret->non_kernel = 0;
+	ret->exec_callback = false;
+	ret->callback = NULL;
+	ret->private = NULL;
 	return ret;
 }
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch
maple_tree-add-test-to-replicate-low-memory-race-conditions.patch

