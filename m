Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23C9C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjKFRed (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjKFReb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555EFD69
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:28 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA549C433CA;
        Mon,  6 Nov 2023 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292068;
        bh=/muvX9YxGXrztxjsUvbAubhDMPSDK01JfP/ZUfAkR7s=;
        h=Date:To:From:Subject:From;
        b=zH1NoPaqwwu8JsvsnOn6fysGQgKLNGeTQ7G3EPg6Yfw4/nygrB/3ZnhC+VDhY4yzG
         ilFobG7UdBPtiPpLrs5TWJVFH9iFFszXFCpkqKX4LR13xpQ+n17IBYZmgOQHmXcmPC
         aMudrPDM7yBZ/Cp5VbmshCKUugRbNBJlIulagJ/M=
Date:   Mon, 06 Nov 2023 09:34:27 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-mas_searchable.patch added to mm-unstable branch
Message-Id: <20231106173427.EA549C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove mas_searchable()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-mas_searchable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-mas_searchable.patch

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
Subject: maple_tree: remove mas_searchable()
Date: Wed, 1 Nov 2023 13:16:26 -0400

Now that the status of the maple state is outside of the node, the
mas_searchable() function can be dropped for easier open-coding of what is
going on.

Link: https://lkml.kernel.org/r/20231101171629.3612299-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   66 +++++++----------------------
 tools/testing/radix-tree/maple.c |    4 +
 2 files changed, 19 insertions(+), 51 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-mas_searchable
+++ a/lib/maple_tree.c
@@ -285,17 +285,6 @@ static inline bool mas_is_underflow(stru
 	return mas->status == ma_underflow;
 }
 
-static inline bool mas_searchable(struct ma_state *mas)
-{
-	if (mas_is_none(mas))
-		return false;
-
-	if (mas_is_ptr(mas))
-		return false;
-
-	return true;
-}
-
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -6022,12 +6011,11 @@ static __always_inline bool mas_find_set
 
 	}
 
-	if (unlikely(!mas_searchable(mas))) {
-		if (unlikely(mas_is_ptr(mas)))
-			goto ptr_out_of_range;
+	if (unlikely(mas_is_ptr(mas)))
+		goto ptr_out_of_range;
 
+	if (unlikely(mas_is_none(mas)))
 		return true;
-	}
 
 	if (mas->index == max)
 		return true;
@@ -6154,20 +6142,18 @@ static bool mas_find_rev_setup(struct ma
 			return true;
 	}
 
-	if (unlikely(!mas_searchable(mas))) {
-		if (mas_is_ptr(mas))
-			goto none;
+	if (unlikely(mas_is_ptr(mas)))
+		goto none;
 
-		if (mas_is_none(mas)) {
-			/*
-			 * Walked to the location, and there was nothing so the
-			 * previous location is 0.
-			 */
-			mas->last = mas->index = 0;
-			mas->status = ma_root;
-			*entry = mas_root(mas);
-			return true;
-		}
+	if (unlikely(mas_is_none(mas))) {
+		/*
+		 * Walked to the location, and there was nothing so the previous
+		 * location is 0.
+		 */
+		mas->last = mas->index = 0;
+		mas->status = ma_root;
+		*entry = mas_root(mas);
+		return true;
 	}
 
 active:
@@ -6897,7 +6883,7 @@ retry:
 	if (entry)
 		goto unlock;
 
-	while (mas_searchable(&mas) && (mas.last < max)) {
+	while (mas_is_active(&mas) && (mas.last < max)) {
 		entry = mas_next_entry(&mas, max);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
@@ -6979,26 +6965,6 @@ unsigned int mt_nr_allocated(void)
 	return kmem_cache_nr_allocated(maple_node_cache);
 }
 
-/*
- * mas_dead_node() - Check if the maple state is pointing to a dead node.
- * @mas: The maple state
- * @index: The index to restore in @mas.
- *
- * Used in test code.
- * Return: 1 if @mas has been reset to MAS_START, 0 otherwise.
- */
-static inline int mas_dead_node(struct ma_state *mas, unsigned long index)
-{
-	if (unlikely(!mas_searchable(mas) || mas_is_start(mas)))
-		return 0;
-
-	if (likely(!mte_dead_node(mas->node)))
-		return 0;
-
-	mas_rewalk(mas, index);
-	return 1;
-}
-
 void mt_cache_shrink(void)
 {
 }
@@ -7550,7 +7516,7 @@ void mt_validate(struct maple_tree *mt)
 	MA_STATE(mas, mt, 0, 0);
 	rcu_read_lock();
 	mas_start(&mas);
-	if (!mas_searchable(&mas))
+	if (!mas_is_active(&mas))
 		goto done;
 
 	while (!mte_is_leaf(mas.node))
--- a/tools/testing/radix-tree/maple.c~maple_tree-remove-mas_searchable
+++ a/tools/testing/radix-tree/maple.c
@@ -974,8 +974,10 @@ retry:
 	if (likely(mas->offset != MAPLE_NODE_SLOTS))
 		entry = mas_get_slot(mas, mas->offset);
 
-	if (mas_dead_node(mas, index))
+	if (mas_is_active(mas) && mte_dead_node(mas->node)) {
+		mas_set(mas, index);
 		goto retry;
+	}
 
 	return entry;
 }
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

