Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DC1C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 21:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiGYV4R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGYV4R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 17:56:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D056544
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 14:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A920960FF9
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 21:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F70C341C6;
        Mon, 25 Jul 2022 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658786175;
        bh=/uKKmeqVEFPQH63rhvFFBJZE+pSzuJ13bwO08FZXvlw=;
        h=Date:To:From:Subject:From;
        b=sCJ9twG4GUf90GyiaDi0e7zfdgm0TAj0DkkJyJxxW0QxidEkUtSRj9uI72REdMdOS
         EJJO0f7pN6bjZLkF4pt25VHUYVD7AQ8w/M1v+lqJUhc/jTeUHozssHmCexM0ftPnJN
         Zz878dw/ULLO7snewG23TLd0HFmSF9ILp4Ok3ZbY=
Date:   Mon, 25 Jul 2022 14:56:14 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-a-mas_destroy-call-to-mas_expected_entries-failure-path.patch added to mm-unstable branch
Message-Id: <20220725215615.04F70C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add a mas_destroy() call to mas_expected_entries() failure path
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-a-mas_destroy-call-to-mas_expected_entries-failure-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-a-mas_destroy-call-to-mas_expected_entries-failure-path.patch

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

 lib/maple_tree.c |   90 ++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-a-mas_destroy-call-to-mas_expected_entries-failure-path
+++ a/lib/maple_tree.c
@@ -5731,6 +5731,50 @@ int mas_preallocate(struct ma_state *mas
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
@@ -5786,52 +5830,8 @@ int mas_expected_entries(struct ma_state
 
 	ret = xa_err(mas->node);
 	mas->node = enode;
+	mas_destroy(mas);
 	return ret;
-
-}
-
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
-	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
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
 }
 
 /**
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch
maple_tree-do-not-inline-write-slow-path.patch
maple_tree-add-a-mas_destroy-call-to-mas_expected_entries-failure-path.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

