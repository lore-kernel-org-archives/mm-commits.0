Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE253C43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346681AbiFOUNf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiFOUNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:13:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23B424F28
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E17614CF
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731EAC3411A;
        Wed, 15 Jun 2022 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655323999;
        bh=UMIqyP1u9lzRMjuNPN7DxL5z0WmETxPDouIoTr2DBTo=;
        h=Date:To:From:Subject:From;
        b=EJHIXpT4GKeAN5rtjTas0MvZbfJCC5tVwgLKJIgO1Giwn7ZCC+OxsFgp8BpuO5tRD
         kTXXPnPV1GK+u7nBaUb2DzUC9OxjNwLu+neUSzPgKCocKghq6eb4QSz8K69nggv+MF
         yiz4eOzTJ3Klia8FWOvFZJZRsTLB6mUZ5aZsaZHs=
Date:   Wed, 15 Jun 2022 13:13:18 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch added to mm-unstable branch
Message-Id: <20220615201319.731EAC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_maple_tree: add tests for preallocations and large spanning writes
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: test_maple_tree: add tests for preallocations and large spanning writes
Date: Wed, 15 Jun 2022 14:19:40 +0000

Add test cases to ensure preallocaion works.

Add more tests for spanning writes which alter tress with many levels
and covers more corner cases.

Link: https://lkml.kernel.org/r/20220615141921.417598-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |  277 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 277 insertions(+)

--- a/lib/test_maple_tree.c~lib-test_maple_tree-add-testing-for-maple-tree-fix-2
+++ a/lib/test_maple_tree.c
@@ -35537,6 +35537,275 @@ static noinline void check_root_expand(s
 	mas_unlock(&mas);
 }
 
+static noinline void check_prealloc(struct maple_tree *mt)
+{
+	unsigned long i, max = 100;
+	unsigned long allocated;
+	unsigned char height;
+	struct maple_node *mn;
+	void *ptr= check_prealloc;
+	MA_STATE(mas, mt, 10, 20);
+
+	mt_set_non_kernel(1000);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mas_destroy(&mas);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	mas_destroy(&mas);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mn = mas_pop_node(&mas);
+	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
+	ma_free_rcu(mn);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	mas_destroy(&mas);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mn = mas_pop_node(&mas);
+	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	mas_destroy(&mas);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+	ma_free_rcu(mn);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mn = mas_pop_node(&mas);
+	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
+	mas_push_node(&mas, mn);
+	MT_BUG_ON(mt, mas_allocated(&mas) != allocated);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	mas_destroy(&mas);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mas_store_prealloc(&mas, ptr);
+	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mas_store_prealloc(&mas, ptr);
+	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mas_store_prealloc(&mas, ptr);
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mas_store_prealloc(&mas, ptr);
+	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
+	mt_set_non_kernel(1);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+	mas_destroy(&mas);
+
+
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated == 0);
+	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	mas_store_prealloc(&mas, ptr);
+	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
+	mt_set_non_kernel(1);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	allocated = mas_allocated(&mas);
+	height = mas_mt_height(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+}
+
+static noinline void check_spanning_write(struct maple_tree *mt)
+{
+	unsigned long i, max = 5000;
+	MA_STATE(mas, mt, 1200, 2380);
+
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 1205);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test spanning store that requires a right cousin rebalance */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mas_set_range(&mas, 0, 12900); /* Spans more than 2 levels */
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 1205);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test non-alloc tree spanning store */
+	mt_init_flags(mt, 0);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mas_set_range(&mas, 0, 300);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 15);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test spanning store that requires a right sibling rebalance */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mas_set_range(&mas, 0, 12865);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 15);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test spanning store that requires a left sibling rebalance */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mas_set_range(&mas, 90, 13665);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 95);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test spanning store that requires a left cousin rebalance */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mas_set_range(&mas, 46805, 49995);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 46815);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/*
+	 * Test spanning store that requires a left cousin rebalance all the way
+	 * to root
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mas_set_range(&mas, 32395, 49995);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 46815);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/*
+	 * Test spanning store that requires a right cousin rebalance all the
+	 * way to root
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+	mas_set_range(&mas, 38875, 43190);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 38900);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test spanning store ending at full node (depth 2)*/
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+	mtree_lock(mt);
+	mas_set(&mas, 47606);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	mas_set(&mas, 47607);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	mas_set(&mas, 47608);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	mas_set(&mas, 47609);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	/* Ensure the parent node is full */
+	mas_ascend(&mas);
+	MT_BUG_ON(mt, (mas_data_end(&mas)) != mt_slot_count(mas.node) - 1);
+	mas_set_range(&mas, 11516,48940);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	/* Test spanning write with many many levels of no siblings */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+	mas_set_range(&mas, 43200, 49999);
+	mtree_lock(mt);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 43200);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+}
+
 static noinline void check_null_expand(struct maple_tree *mt)
 {
 	unsigned long i, max = 100;
@@ -37679,6 +37948,14 @@ static int maple_tree_seed(void)
 	mtree_destroy(&tree);
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_prealloc(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_spanning_write(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_null_expand(&tree);
 	mtree_destroy(&tree);
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch

