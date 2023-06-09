Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8D3C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjFIXbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjFIX3D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3203ABF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D210A65CF2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9DBC433D2;
        Fri,  9 Jun 2023 23:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353320;
        bh=ozsngqXkHvriAEpNG//LIZ6wGZbeR807vdtftV+SjaQ=;
        h=Date:To:From:Subject:From;
        b=ZghOn7TnB9coaGAW9uwRjT9ii47KuOk3Y94Kh5havtVGTx6rg/M1/0Sca+vv48A+l
         P3uQUnLXV3IACWu8e2itfuqClNRWd1GgbLIr1faDN4HaVkDpKZy2dHxhzFf67eqmL+
         xujuNbp71HpsJlO2T6/1tqBxkA5OtSYhc061T778=
Date:   Fri, 09 Jun 2023 16:28:39 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-mas_prev_slot-interface.patch removed from -mm tree
Message-Id: <20230609232840.2E9DBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: introduce mas_prev_slot() interface
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-mas_prev_slot-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

