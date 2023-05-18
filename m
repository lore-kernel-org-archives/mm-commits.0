Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B5EC77B7D
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjERVct (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjERVcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ABA198D
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D35765266
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB64C433EF;
        Thu, 18 May 2023 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445392;
        bh=NIt6o5ALsNpj8cAML+WblSnjW7n9JA5lLJxwL8s2TuY=;
        h=Date:To:From:Subject:From;
        b=2vDOhznCblW86XXekX0LpPJyHAggIf1qSSD9cCs37T9BVTqOtRcFXZipMAPPZTjpX
         s+u0rUq6ZsEiiqkk/IqouGqWR/VT/5gsPDJ7E/3Y10TcsxGhpsWW+DcTGbkDajz5N3
         Rtfe2P+pjFTyHtKJFqFucfpcbZsL/5uZUH21rP6Y=
Date:   Thu, 18 May 2023 14:29:52 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-mas_prev_slot-interface.patch added to mm-unstable branch
Message-Id: <20230518212952.AEB64C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: introduce mas_prev_slot() interface
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-mas_prev_slot-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-mas_prev_slot-interface.patch

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
Subject: maple_tree: introduce mas_prev_slot() interface
Date: Thu, 18 May 2023 10:55:39 -0400

Sometimes the user needs to revert to the previous slot, regardless of if
it is empty or not.  Add an interface to go to the previous slot.

Since there can't be two consecutive NULLs in the tree, the mas_prev()
function can be implemented by calling mas_prev_slot() a maximum of 2
times.  Change the underlying interface to use mas_prev_slot() to align
the code.

Link: https://lkml.kernel.org/r/20230518145544.1722059-31-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  232 +++++++++++++++++----------------------------
 1 file changed, 90 insertions(+), 142 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_prev_slot-interface
+++ a/lib/maple_tree.c
@@ -4532,15 +4532,19 @@ static inline int mas_prev_node(struct m
 	int offset, level;
 	void __rcu **slots;
 	struct maple_node *node;
-	struct maple_enode *enode;
 	unsigned long *pivots;
+	unsigned long max;
 
-	if (mas_is_none(mas))
-		return 0;
+	node = mas_mn(mas);
+	if (!mas->min)
+		goto no_entry;
+
+	max = mas->min - 1;
+	if (max < min)
+		goto no_entry;
 
 	level = 0;
 	do {
-		node = mas_mn(mas);
 		if (ma_is_root(node))
 			goto no_entry;
 
@@ -4549,64 +4553,41 @@ static inline int mas_prev_node(struct m
 			return 1;
 		offset = mas->offset;
 		level++;
+		node = mas_mn(mas);
 	} while (!offset);
 
 	offset--;
 	mt = mte_node_type(mas->node);
-	node = mas_mn(mas);
-	slots = ma_slots(node, mt);
-	pivots = ma_pivots(node, mt);
-	if (unlikely(ma_dead_node(node)))
-		return 1;
-
-	mas->max = pivots[offset];
-	if (offset)
-		mas->min = pivots[offset - 1] + 1;
-	if (unlikely(ma_dead_node(node)))
-		return 1;
-
-	if (mas->max < min)
-		goto no_entry_min;
-
 	while (level > 1) {
 		level--;
-		enode = mas_slot(mas, slots, offset);
+		slots = ma_slots(node, mt);
+		mas->node = mas_slot(mas, slots, offset);
 		if (unlikely(ma_dead_node(node)))
 			return 1;
 
-		mas->node = enode;
 		mt = mte_node_type(mas->node);
 		node = mas_mn(mas);
-		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
-		offset = ma_data_end(node, mt, pivots, mas->max);
+		offset = ma_data_end(node, mt, pivots, max);
 		if (unlikely(ma_dead_node(node)))
 			return 1;
-
-		if (offset)
-			mas->min = pivots[offset - 1] + 1;
-
-		if (offset < mt_pivots[mt])
-			mas->max = pivots[offset];
-
-		if (mas->max < min)
-			goto no_entry;
 	}
 
+	slots = ma_slots(node, mt);
 	mas->node = mas_slot(mas, slots, offset);
+	pivots = ma_pivots(node, mt);
 	if (unlikely(ma_dead_node(node)))
 		return 1;
 
+	if (likely(offset))
+		mas->min = pivots[offset - 1] + 1;
+	mas->max = max;
 	mas->offset = mas_data_end(mas);
 	if (unlikely(mte_dead_node(mas->node)))
 		return 1;
 
 	return 0;
 
-no_entry_min:
-	mas->offset = offset;
-	if (offset)
-		mas->min = pivots[offset - 1] + 1;
 no_entry:
 	if (unlikely(ma_dead_node(node)))
 		return 1;
@@ -4616,6 +4597,76 @@ no_entry:
 }
 
 /*
+ * mas_prev_slot() - Get the entry in the previous slot
+ *
+ * @mas: The maple state
+ * @max: The minimum starting range
+ *
+ * Return: The entry in the previous slot which is possibly NULL
+ */
+static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
+{
+	void *entry;
+	void __rcu **slots;
+	unsigned long pivot;
+	enum maple_type type;
+	unsigned long *pivots;
+	struct maple_node *node;
+	unsigned long save_point = mas->index;
+
+retry:
+	node = mas_mn(mas);
+	type = mte_node_type(mas->node);
+	pivots = ma_pivots(node, type);
+	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
+		goto retry;
+
+again:
+	if (mas->min <= min) {
+		pivot = mas_safe_min(mas, pivots, mas->offset);
+
+		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
+			goto retry;
+
+		if (pivot <= min)
+			return NULL;
+	}
+
+	if (likely(mas->offset)) {
+		mas->offset--;
+		mas->last = mas->index - 1;
+		mas->index = mas_safe_min(mas, pivots, mas->offset);
+	} else  {
+		if (mas_prev_node(mas, min)) {
+			mas_rewalk(mas, save_point);
+			goto retry;
+		}
+
+		if (mas_is_none(mas))
+			return NULL;
+
+		mas->last = mas->max;
+		node = mas_mn(mas);
+		type = mte_node_type(mas->node);
+		pivots = ma_pivots(node, type);
+		mas->index = pivots[mas->offset - 1] + 1;
+	}
+
+	slots = ma_slots(node, type);
+	entry = mas_slot(mas, slots, mas->offset);
+	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
+		goto retry;
+
+	if (likely(entry))
+		return entry;
+
+	if (!empty)
+		goto again;
+
+	return entry;
+}
+
+/*
  * mas_next_node() - Get the next node at the same level in the tree.
  * @mas: The maple state
  * @max: The maximum pivot value to check.
@@ -4800,109 +4851,6 @@ static inline void *mas_next_entry(struc
 }
 
 /*
- * mas_prev_nentry() - Get the previous node entry.
- * @mas: The maple state.
- * @limit: The lower limit to check for a value.
- *
- * Return: the entry, %NULL otherwise.
- */
-static inline void *mas_prev_nentry(struct ma_state *mas, unsigned long limit,
-				    unsigned long index)
-{
-	unsigned long pivot, min;
-	unsigned char offset, count;
-	struct maple_node *mn;
-	enum maple_type mt;
-	unsigned long *pivots;
-	void __rcu **slots;
-	void *entry;
-
-retry:
-	if (!mas->offset)
-		return NULL;
-
-	mn = mas_mn(mas);
-	mt = mte_node_type(mas->node);
-	offset = mas->offset - 1;
-	slots = ma_slots(mn, mt);
-	pivots = ma_pivots(mn, mt);
-	count = ma_data_end(mn, mt, pivots, mas->max);
-	if (unlikely(mas_rewalk_if_dead(mas, mn, index)))
-		goto retry;
-
-	offset = mas->offset - 1;
-	if (offset >= mt_slots[mt])
-		offset = mt_slots[mt] - 1;
-
-	if (offset >= count) {
-		pivot = mas->max;
-		offset = count;
-	} else {
-		pivot = pivots[offset];
-	}
-
-	if (unlikely(mas_rewalk_if_dead(mas, mn, index)))
-		goto retry;
-
-	while (offset && !mas_slot(mas, slots, offset)) {
-		pivot = pivots[--offset];
-		if (pivot >= limit)
-			break;
-	}
-
-	/*
-	 * If the slot was null but we've shifted outside the limits, then set
-	 * the range to the last NULL.
-	 */
-	if (unlikely((pivot < limit) && (offset < mas->offset)))
-		pivot = pivots[++offset];
-
-	min = mas_safe_min(mas, pivots, offset);
-	entry = mas_slot(mas, slots, offset);
-	if (unlikely(mas_rewalk_if_dead(mas, mn, index)))
-		goto retry;
-
-	mas->offset = offset;
-	mas->last = pivot;
-	mas->index = min;
-	return entry;
-}
-
-static inline void *mas_prev_entry(struct ma_state *mas, unsigned long min)
-{
-	void *entry;
-	struct maple_enode *prev_enode;
-	unsigned char prev_offset;
-
-	if (mas->index < min)
-		return NULL;
-
-retry:
-	prev_enode = mas->node;
-	prev_offset = mas->offset;
-	while (likely(!mas_is_none(mas))) {
-		entry = mas_prev_nentry(mas, min, mas->index);
-
-		if (likely(entry))
-			return entry;
-
-		if (unlikely(mas->index <= min))
-			return NULL;
-
-		if (unlikely(mas_prev_node(mas, min))) {
-			mas_rewalk(mas, mas->index);
-			goto retry;
-		}
-
-		mas->offset++;
-	}
-
-	mas->node = prev_enode;
-	mas->offset = prev_offset;
-	return NULL;
-}
-
-/*
  * mas_rev_awalk() - Internal function.  Reverse allocation walk.  Find the
  * highest gap address of a given size in a given node and descend.
  * @mas: The maple state
@@ -6012,7 +5960,7 @@ void *mas_prev(struct ma_state *mas, uns
 		}
 		return NULL;
 	}
-	return mas_prev_entry(mas, min);
+	return mas_prev_slot(mas, min, false);
 
 none:
 	mas->node = MAS_NONE;
@@ -6227,8 +6175,8 @@ void *mas_find_rev(struct ma_state *mas,
 	if (mas->index < min)
 		return NULL;
 
-	/* Retries on dead nodes handled by mas_prev_entry */
-	return mas_prev_entry(mas, min);
+	/* Retries on dead nodes handled by mas_prev_slot */
+	return mas_prev_slot(mas, min, false);
 
 none:
 	mas->node = MAS_NONE;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch

