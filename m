Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D883C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 23:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiG1X1H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 19:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiG1X1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 19:27:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA171731
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 16:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DDEAB82623
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 23:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3806FC433D6;
        Thu, 28 Jul 2022 23:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659050822;
        bh=+xTPVjKAYpnB27QgnGuBGH4QmdEPBJk0R0dC+CB0Skg=;
        h=Date:To:From:Subject:From;
        b=x54xCCX3eS1H2+Q0gYC/b5PTiUdV1pOc9pjl9A/a1pQ6p5yjoZcs+iUdPS1Y8l2J8
         eQHLZSmQiS7/Fj8t6H+ZgCFQXgbfhrSfoQ/2ug/jEJmEP49na5SOMoQOim+/3V0yJs
         WLeo8rtyCkBPgaHJ3d9Qn3qOm/ZyKJ0wNQwcUnSc=
Date:   Thu, 28 Jul 2022 16:27:01 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-2.patch added to mm-unstable branch
Message-Id: <20220728232702.3806FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add a mas_destroy() call to mas_expected_entries() failure path
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-2.patch

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
Subject: maple_tree: add a mas_destroy() call to mas_expected_entries() failure path
Date: Thu, 21 Jul 2022 00:58:43 +0000

In an exceedingly rare case, there is a possibility that allocating all of
the nodes may fail in a way that the maple state is left with some
allocations completed.  This would happen if the single allocation
succeeds but bulk allocation fails, or if multiple bulk allocations are
required and somewhere along the way one fails.  The partial return is
already cleaned up, but the successful allocations will remain in the
maple state.  When this happens, mas_expected_entries() may leak memory. 
Fix this by moving mas_destroy() above mas_expected_entries() and add a
call to mas_destroy() to clear out all allocated memory.

Link: https://lkml.kernel.org/r/20220721005828.379405-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   89 ++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-2
+++ a/lib/maple_tree.c
@@ -5706,6 +5706,50 @@ int mas_preallocate(struct ma_state *mas
 }
 
 /*
+ * mas_destroy() - destroy a maple state.
+ * @mas: The maple state
+ *
+ * Upon completion, check the left-most node and rebalance against the node to
+ * the right if necessary.  Frees any allocated nodes associated with this maple
+ * state.
+ */
+void mas_destroy(struct ma_state *mas)
+{
+	struct maple_alloc *node;
+
+	/*
+	 * When using mas_for_each() to insert an expected number of elements,
+	 * it is possible that the number inserted is less than the expected
+	 * number.  To fix an invalid final node, a check is performed here to
+	 * rebalance the previous node with the final node.
+	 */
+	if (mas->mas_flags & MA_STATE_REBALANCE) {
+		unsigned char end;
+
+		if (mas_is_start(mas))
+			mas_start(mas);
+
+		mtree_range_walk(mas);
+		end = mas_data_end(mas) + 1;
+		if (end < mt_min_slot_count(mas->node) - 1)
+			mas_destroy_rebalance(mas, end);
+
+		mas->mas_flags &= ~MA_STATE_REBALANCE;
+	}
+	mas->mas_flags &= ~MA_STATE_BULK;
+
+	while (mas->alloc && !((unsigned long)mas->alloc & 0x1)) {
+		node = mas->alloc;
+		mas->alloc = node->slot[0];
+		if (node->node_count > 0)
+			mt_free_bulk(node->node_count,
+				     (void __rcu **)&node->slot[1]);
+		kmem_cache_free(maple_node_cache, node);
+	}
+	mas->alloc = NULL;
+}
+
+/*
  * mas_expected_entries() - Set the expected number of entries that will be inserted.
  * @mas: The maple state
  * @nr_entries: The number of expected entries.
@@ -5758,54 +5802,11 @@ int mas_expected_entries(struct ma_state
 
 	ret = xa_err(mas->node);
 	mas->node = enode;
+	mas_destroy(mas);
 	return ret;
 
 }
 
-/*
- * mas_destroy() - destroy a maple state.
- * @mas: The maple state
- *
- * Upon completion, check the left-most node and rebalance against the node to
- * the right if necessary.  Frees any allocated nodes associated with this maple
- * state.
- */
-void mas_destroy(struct ma_state *mas)
-{
-	struct maple_alloc *node;
-
-	/*
-	 * When using mas_for_each() to insert an expected number of elements,
-	 * it is possible that the number inserted is less than the expected
-	 * number.  To fix an invalid final node, a check is performed here to
-	 * rebalance the previous node with the final node.
-	 */
-	if (mas->mas_flags & MA_STATE_REBALANCE) {
-		unsigned char end;
-
-		if (mas_is_start(mas))
-			mas_start(mas);
-
-		mtree_range_walk(mas);
-		end = mas_data_end(mas) + 1;
-		if (end < mt_min_slot_count(mas->node) - 1)
-			mas_destroy_rebalance(mas, end);
-
-		mas->mas_flags &= ~MA_STATE_REBALANCE;
-	}
-	mas->mas_flags &= ~MA_STATE_BULK;
-
-	while (mas->alloc && !((unsigned long)mas->alloc & 0x1)) {
-		node = mas->alloc;
-		mas->alloc = node->slot[0];
-		if (node->node_count > 0)
-			mt_free_bulk(node->node_count,
-				     (void __rcu **)&node->slot[1]);
-		kmem_cache_free(maple_node_cache, node);
-	}
-	mas->alloc = NULL;
-}
-
 /**
  * mas_next() - Get the next entry.
  * @mas: The maple state
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch
maple_tree-do-not-inline-write-slow-path.patch

