Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE13C43334
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jul 2022 02:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiGFCy6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jul 2022 22:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGFCy6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2022 22:54:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F96E020
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 19:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC7CB81992
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 02:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2836FC341C7;
        Wed,  6 Jul 2022 02:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657076094;
        bh=kBkCIfXoDv7EkXNQnjWXtRYPpHrh8PgjUXfOmvhItN0=;
        h=Date:To:From:Subject:From;
        b=aoWfswXTd2vVMiNqMxa5+oWz4Pup15yksHFdszBQ7qsHErnmp0TcwadKpWf64gWMc
         BN7pwC2zdZ20x+WWZ+wrovErdT46wBBGXEDGkaBKRCBXeLzlWANUw3DMuA4Vmq+myY
         8lJooAYFdr6Ggf34kmYCp4YUim/TA+dmduZuXEws=
Date:   Tue, 05 Jul 2022 19:54:53 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-3.patch added to mm-unstable branch
Message-Id: <20220706025454.2836FC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: Fix use of node for global range in mas_wr_spanning_store()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-3.patch

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
Subject: maple_tree: Fix use of node for global range in mas_wr_spanning_store()
Date: Wed, 6 Jul 2022 02:05:37 +0000

When writing a range with a NULL which expands to 0 - ULONG_MAX, don't use
a node to store this value.  Instead, call mas_new_root() which will set
the tree pointer to NULL and free all the nodes.

Fix a comment for the allocations in mas_wr_spanning_store().

Add mas_node_count_gfp() and use it to clean up mas_preallocate().

Clean up mas_preallocate() and ensure the ma_state is safe on return.

Update maple_tree.h to set alloc = NULL.

Link: https://lkml.kernel.org/r/20220706020526.1869453-1-Liam.Howlett@oracle.com
Fixes: d0aac5e48048 (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    1 +
 lib/maple_tree.c           |   34 +++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix-3
+++ a/include/linux/maple_tree.h
@@ -434,6 +434,7 @@ struct ma_wr_state {
 		.node = MAS_START,					\
 		.min = 0,						\
 		.max = ULONG_MAX,					\
+		.alloc = NULL,						\
 	}
 
 #define MA_WR_STATE(name, ma_state, wr_entry)				\
--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-3
+++ a/lib/maple_tree.c
@@ -1293,18 +1293,32 @@ static inline void mas_free(struct ma_st
  * there is not enough nodes.
  * @mas: The maple state
  * @count: The number of nodes needed
+ * @gfp: the gfp flags
  */
-static void mas_node_count(struct ma_state *mas, int count)
+static void mas_node_count_gfp(struct ma_state *mas, int count, gfp_t gfp)
 {
 	unsigned long allocated = mas_allocated(mas);
 
 	if (allocated < count) {
 		mas_set_alloc_req(mas, count - allocated);
-		mas_alloc_nodes(mas, GFP_NOWAIT | __GFP_NOWARN);
+		mas_alloc_nodes(mas, gfp);
 	}
 }
 
 /*
+ * mas_node_count() - Check if enough nodes are allocated and request more if
+ * there is not enough nodes.
+ * @mas: The maple state
+ * @count: The number of nodes needed
+ *
+ * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
+ */
+static void mas_node_count(struct ma_state *mas, int count)
+{
+	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
+}
+
+/*
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
  *
@@ -3962,7 +3976,7 @@ static inline int mas_wr_spanning_store(
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		return mas_new_root(mas, wr_mas->entry);
 	/*
-	 * Node rebalancing may occur due to this store, so there may be two new
+	 * Node rebalancing may occur due to this store, so there may be three new
 	 * entries per level plus a new root.
 	 */
 	height = mas_mt_height(mas);
@@ -3995,6 +4009,12 @@ static inline int mas_wr_spanning_store(
 		mas->last = l_mas.last = r_mas.last;
 	}
 
+	/* expanding NULLs may make this cover the entire range */
+	if (!l_mas.index && r_mas.last == ULONG_MAX) {
+		mas_set_range(mas, 0, ULONG_MAX);
+		return mas_new_root(mas, wr_mas->entry);
+	}
+
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
 	mas_store_b_node(&l_wr_mas, &b_node, l_wr_mas.node_end);
@@ -5657,15 +5677,15 @@ int mas_preallocate(struct ma_state *mas
 {
 	int ret;
 
-	mas_set_alloc_req(mas, 1 + mas_mt_height(mas) * 3);
-	mas_alloc_nodes(mas, gfp);
+	mas_node_count_gfp(mas, 1 + mas_mt_height(mas) * 3, gfp);
 	if (likely(!mas_is_err(mas)))
 		return 0;
 
 	mas_set_alloc_req(mas, 0);
-	mas_destroy(mas);
 	ret = xa_err(mas->node);
-	mas->node = MAS_START;
+	mas_reset(mas);
+	mas_destroy(mas);
+	mas_reset(mas);
 	return ret;
 }
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

