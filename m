Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FD7C77B7F
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbjEETb6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbjEETbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C7665AC
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C4A63F9E
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D88C4339B;
        Fri,  5 May 2023 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315069;
        bh=CB6Lktp09/UPcOFih6AKsfTBwpWWREeEO9891+MJt4s=;
        h=Date:To:From:Subject:From;
        b=O8JFwgKvu1Svnl6iTHGGl3E5dAMJDoBArNzlwisEowntLMlT+d/bF5HYh9jI3V+NY
         NLVUpzyB2+4/119UQrtwy9Uwp0xrXwC6f0Yfz3WJlpDTXNM7Gt5mk7qKaZQCk9H9vk
         6o5dBS7kl/GanbM7XRmtaj1myEJuS1AkAux2a+uI=
Date:   Fri, 05 May 2023 12:31:08 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        dcb314@hotmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-mas_next_slot-interface.patch added to mm-unstable branch
Message-Id: <20230505193109.47D88C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: introduce mas_next_slot() interface
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-mas_next_slot-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-mas_next_slot-interface.patch

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
Subject: maple_tree: introduce mas_next_slot() interface
Date: Fri, 5 May 2023 13:41:55 -0400

Sometimes, during a tree walk, the user needs the next slot regardless of
if it is empty or not.  Add an interface to get the next slot.

Since there are no consecutive NULLs allowed in the tree, the mas_next()
function can only advance two slots at most.  So use the new
mas_next_slot() interface to align both implementations.  Use this method
for mas_find() as well.

Link: https://lkml.kernel.org/r/20230505174204.2665599-28-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  229 ++++++++++++++++++++-------------------------
 1 file changed, 104 insertions(+), 125 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_next_slot-interface
+++ a/lib/maple_tree.c
@@ -4606,11 +4606,10 @@ no_entry:
 static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 				unsigned long max)
 {
-	unsigned long min, pivot;
+	unsigned long min;
 	unsigned long *pivots;
 	struct maple_enode *enode;
 	int level = 0;
-	unsigned char offset;
 	unsigned char node_end;
 	enum maple_type mt;
 	void __rcu **slots;
@@ -4618,19 +4617,16 @@ static inline int mas_next_node(struct m
 	if (mas->max >= max)
 		goto no_entry;
 
+	min = mas->max + 1;
 	level = 0;
 	do {
 		if (ma_is_root(node))
 			goto no_entry;
 
-		min = mas->max + 1;
-		if (min > max)
-			goto no_entry;
-
+		/* Walk up. */
 		if (unlikely(mas_ascend(mas)))
 			return 1;
 
-		offset = mas->offset;
 		level++;
 		node = mas_mn(mas);
 		mt = mte_node_type(mas->node);
@@ -4639,36 +4635,37 @@ static inline int mas_next_node(struct m
 		if (unlikely(ma_dead_node(node)))
 			return 1;
 
-	} while (unlikely(offset == node_end));
+	} while (unlikely(mas->offset == node_end));
 
 	slots = ma_slots(node, mt);
-	pivot = mas_safe_pivot(mas, pivots, ++offset, mt);
-	while (unlikely(level > 1)) {
-		/* Descend, if necessary */
-		enode = mas_slot(mas, slots, offset);
-		if (unlikely(ma_dead_node(node)))
-			return 1;
+	mas->offset++;
+	enode = mas_slot(mas, slots, mas->offset);
+	if (unlikely(ma_dead_node(node)))
+		return 1;
 
-		mas->node = enode;
+	if (level > 1)
+		mas->offset = 0;
+
+	while (unlikely(level > 1)) {
 		level--;
+		mas->node = enode;
 		node = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 		slots = ma_slots(node, mt);
-		pivots = ma_pivots(node, mt);
+		enode = mas_slot(mas, slots, 0);
 		if (unlikely(ma_dead_node(node)))
 			return 1;
-
-		offset = 0;
-		pivot = pivots[0];
 	}
 
-	enode = mas_slot(mas, slots, offset);
+	if (!mas->offset)
+		pivots = ma_pivots(node, mt);
+
+	mas->max = mas_safe_pivot(mas, pivots, mas->offset, mt);
 	if (unlikely(ma_dead_node(node)))
 		return 1;
 
 	mas->node = enode;
 	mas->min = min;
-	mas->max = pivot;
 	return 0;
 
 no_entry:
@@ -4679,83 +4676,106 @@ no_entry:
 	return 0;
 }
 
+static inline void mas_rewalk(struct ma_state *mas, unsigned long index)
+{
+retry:
+	mas_set(mas, index);
+	mas_state_walk(mas);
+	if (mas_is_start(mas))
+		goto retry;
+}
+
+static inline bool mas_rewalk_if_dead(struct ma_state *mas,
+		struct maple_node *node, const unsigned long index)
+{
+	if (unlikely(ma_dead_node(node))) {
+		mas_rewalk(mas, index);
+		return true;
+	}
+	return false;
+}
+
 /*
- * mas_next_nentry() - Get the next node entry
- * @mas: The maple state
- * @max: The maximum value to check
- * @*range_start: Pointer to store the start of the range.
+ * mas_next_slot() - Get the entry in the next slot
  *
- * Sets @mas->offset to the offset of the next node entry, @mas->last to the
- * pivot of the entry.
+ * @mas: The maple state
+ * @max: The maximum starting range
+ * @empty: Can be empty
  *
- * Return: The next entry, %NULL otherwise
+ * Return: The entry in the next slot which is possibly NULL
  */
-static inline void *mas_next_nentry(struct ma_state *mas,
-	    struct maple_node *node, unsigned long max, enum maple_type type)
+void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 {
-	unsigned char count;
-	unsigned long pivot;
-	unsigned long *pivots;
 	void __rcu **slots;
+	unsigned long *pivots;
+	unsigned long pivot;
+	enum maple_type type;
+	struct maple_node *node;
+	unsigned char data_end;
+	unsigned long save_point = mas->last;
 	void *entry;
 
-	if (mas->last == mas->max) {
-		mas->index = mas->max;
-		return NULL;
-	}
-
-	slots = ma_slots(node, type);
+retry:
+	node = mas_mn(mas);
+	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	count = ma_data_end(node, type, pivots, mas->max);
-	if (unlikely(ma_dead_node(node)))
-		return NULL;
-
-	mas->index = mas_safe_min(mas, pivots, mas->offset);
-	if (unlikely(ma_dead_node(node)))
-		return NULL;
-
-	if (mas->index > max)
-		return NULL;
-
-	if (mas->offset > count)
-		return NULL;
+	data_end = ma_data_end(node, type, pivots, mas->max);
+	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
+		goto retry;
 
-	while (mas->offset < count) {
-		pivot = pivots[mas->offset];
-		entry = mas_slot(mas, slots, mas->offset);
-		if (ma_dead_node(node))
-			return NULL;
+again:
+	if (mas->max >= max) {
+		if (likely(mas->offset < data_end))
+			pivot = pivots[mas->offset];
+		else
+			return NULL; /* must be mas->max */
 
-		mas->last = pivot;
-		if (entry)
-			return entry;
+		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
+			goto retry;
 
 		if (pivot >= max)
 			return NULL;
+	}
+
+	if (likely(mas->offset < data_end)) {
+		mas->index = pivots[mas->offset] + 1;
+		mas->offset++;
+		if (likely(mas->offset < data_end))
+			mas->last = pivots[mas->offset];
+		else
+			mas->last = mas->max;
+	} else  {
+		if (mas_next_node(mas, node, max)) {
+			mas_rewalk(mas, save_point);
+			goto retry;
+		}
 
-		if (pivot >= mas->max)
+		if (mas_is_none(mas))
 			return NULL;
 
-		mas->index = pivot + 1;
-		mas->offset++;
+		mas->offset = 0;
+		mas->index = mas->min;
+		node = mas_mn(mas);
+		type = mte_node_type(mas->node);
+		pivots = ma_pivots(node, type);
+		mas->last = pivots[0];
 	}
 
-	pivot = mas_logical_pivot(mas, pivots, mas->offset, type);
-	entry = mas_slot(mas, slots, mas->offset);
-	if (ma_dead_node(node))
-		return NULL;
+	slots = ma_slots(node, type);
+	entry = mt_slot(mas->tree, slots, mas->offset);
+	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
+		goto retry;
 
-	mas->last = pivot;
-	return entry;
-}
+	if (entry)
+		return entry;
 
-static inline void mas_rewalk(struct ma_state *mas, unsigned long index)
-{
-retry:
-	mas_set(mas, index);
-	mas_state_walk(mas);
-	if (mas_is_start(mas))
-		goto retry;
+	if (!empty) {
+		if (!mas->offset)
+			data_end = 2;
+		goto again;
+	}
+
+	return entry;
 }
 
 /*
@@ -4773,47 +4793,12 @@ retry:
 static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
 {
 	void *entry = NULL;
-	struct maple_node *node;
-	unsigned long last;
-	enum maple_type mt;
 
 	if (mas->last >= limit)
 		return NULL;
 
-	last = mas->last;
-retry:
-	node = mas_mn(mas);
-	mt = mte_node_type(mas->node);
-	mas->offset++;
-	if (unlikely(mas->offset >= mt_slots[mt])) {
-		mas->offset = mt_slots[mt] - 1;
-		goto next_node;
-	}
-
-	while (!mas_is_none(mas)) {
-		entry = mas_next_nentry(mas, node, limit, mt);
-		if (unlikely(ma_dead_node(node))) {
-			mas_rewalk(mas, last);
-			goto retry;
-		}
-
-		if (likely(entry))
-			return entry;
-
-		if (unlikely((mas->last >= limit)))
-			return NULL;
-
-next_node:
-		if (unlikely(mas_next_node(mas, node, limit))) {
-			mas_rewalk(mas, last);
-			goto retry;
-		}
-		mas->offset = 0;
-		node = mas_mn(mas);
-		mt = mte_node_type(mas->node);
-	}
-
-	return NULL;
+	entry = mas_next_slot(mas, limit, false);
+	return entry;
 }
 
 /*
@@ -4844,10 +4829,8 @@ retry:
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
 	count = ma_data_end(mn, mt, pivots, mas->max);
-	if (unlikely(ma_dead_node(mn))) {
-		mas_rewalk(mas, index);
+	if (unlikely(mas_rewalk_if_dead(mas, mn, index)))
 		goto retry;
-	}
 
 	offset = mas->offset - 1;
 	if (offset >= mt_slots[mt])
@@ -4860,10 +4843,8 @@ retry:
 		pivot = pivots[offset];
 	}
 
-	if (unlikely(ma_dead_node(mn))) {
-		mas_rewalk(mas, index);
+	if (unlikely(mas_rewalk_if_dead(mas, mn, index)))
 		goto retry;
-	}
 
 	while (offset && !mas_slot(mas, slots, offset)) {
 		pivot = pivots[--offset];
@@ -4880,10 +4861,8 @@ retry:
 
 	min = mas_safe_min(mas, pivots, offset);
 	entry = mas_slot(mas, slots, offset);
-	if (unlikely(ma_dead_node(mn))) {
-		mas_rewalk(mas, index);
+	if (unlikely(mas_rewalk_if_dead(mas, mn, index)))
 		goto retry;
-	}
 
 	mas->offset = offset;
 	mas->last = pivot;
@@ -6108,8 +6087,8 @@ void *mas_find(struct ma_state *mas, uns
 	if (mas->index == max)
 		return NULL;
 
-	/* Retries on dead nodes handled by mas_next_entry */
-	return mas_next_entry(mas, max);
+	/* Retries on dead nodes handled by mas_next_slot */
+	return mas_next_slot(mas, max, false);
 
 ptr_out_of_range:
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
maple_tree-add-gap-to-check_alloc_rev_range-testcase.patch

