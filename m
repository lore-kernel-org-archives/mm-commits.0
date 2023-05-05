Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E311C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjEETbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbjEETbL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E72C5FD6
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98B9264026
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFD5C433D2;
        Fri,  5 May 2023 19:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315062;
        bh=OhztJ0CrtjQzzLg3IPOJiYDll9eM9+DpHFwCPzLZZ8Q=;
        h=Date:To:From:Subject:From;
        b=GCMV4ceyR1wHGdMPs2kPhLg4ZIZnyw/2a9U1tNPN+WIcYBtjFpr8xCewcddJtMaQ2
         VRGmqywQy/lx8JoiYi9BCltlwkrCPECMhoS5mEIzWBEIMlGLtvuDxmGFcgz7ryLZ5t
         /T1YlubqS8L9lTe78sgnEz+OX5TNtZFB4vZMwzZI=
Date:   Fri, 05 May 2023 12:31:01 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        dcb314@hotmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-try-harder-to-keep-active-node-after-mas_next.patch added to mm-unstable branch
Message-Id: <20230505193101.EDFD5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: try harder to keep active node after mas_next()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-try-harder-to-keep-active-node-after-mas_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-try-harder-to-keep-active-node-after-mas_next.patch

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
Subject: maple_tree: try harder to keep active node after mas_next()
Date: Fri, 5 May 2023 13:41:51 -0400

Clean up the mas_next() call to try and keep a node reference when
possible.  This will avoid re-walking the tree in most cases.

Also clean up the single entry tree handling to ensure index/last are
consistent with what one would expect.  (returning NULL with limit of
1-oo).

Link: https://lkml.kernel.org/r/20230505174204.2665599-24-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   89 +++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 42 deletions(-)

--- a/lib/maple_tree.c~maple_tree-try-harder-to-keep-active-node-after-mas_next
+++ a/lib/maple_tree.c
@@ -4726,33 +4726,25 @@ static inline void *mas_next_nentry(stru
 		if (ma_dead_node(node))
 			return NULL;
 
+		mas->last = pivot;
 		if (entry)
-			goto found;
+			return entry;
 
 		if (pivot >= max)
 			return NULL;
 
+		if (pivot >= mas->max)
+			return NULL;
+
 		mas->index = pivot + 1;
 		mas->offset++;
 	}
 
-	if (mas->index > mas->max) {
-		mas->index = mas->last;
-		return NULL;
-	}
-
-	pivot = mas_safe_pivot(mas, pivots, mas->offset, type);
+	pivot = mas_logical_pivot(mas, pivots, mas->offset, type);
 	entry = mas_slot(mas, slots, mas->offset);
 	if (ma_dead_node(node))
 		return NULL;
 
-	if (!pivot)
-		return NULL;
-
-	if (!entry)
-		return NULL;
-
-found:
 	mas->last = pivot;
 	return entry;
 }
@@ -4781,21 +4773,15 @@ retry:
 static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
 {
 	void *entry = NULL;
-	struct maple_enode *prev_node;
 	struct maple_node *node;
-	unsigned char offset;
 	unsigned long last;
 	enum maple_type mt;
 
-	if (mas->index > limit) {
-		mas->index = mas->last = limit;
-		mas_pause(mas);
+	if (mas->last >= limit)
 		return NULL;
-	}
+
 	last = mas->last;
 retry:
-	offset = mas->offset;
-	prev_node = mas->node;
 	node = mas_mn(mas);
 	mt = mte_node_type(mas->node);
 	mas->offset++;
@@ -4814,12 +4800,10 @@ retry:
 		if (likely(entry))
 			return entry;
 
-		if (unlikely((mas->index > limit)))
-			break;
+		if (unlikely((mas->last >= limit)))
+			return NULL;
 
 next_node:
-		prev_node = mas->node;
-		offset = mas->offset;
 		if (unlikely(mas_next_node(mas, node, limit))) {
 			mas_rewalk(mas, last);
 			goto retry;
@@ -4829,9 +4813,6 @@ next_node:
 		mt = mte_node_type(mas->node);
 	}
 
-	mas->index = mas->last = limit;
-	mas->offset = offset;
-	mas->node = prev_node;
 	return NULL;
 }
 
@@ -5919,6 +5900,8 @@ EXPORT_SYMBOL_GPL(mas_expected_entries);
  */
 void *mas_next(struct ma_state *mas, unsigned long max)
 {
+	bool was_none = mas_is_none(mas);
+
 	if (mas_is_none(mas) || mas_is_paused(mas))
 		mas->node = MAS_START;
 
@@ -5926,16 +5909,16 @@ void *mas_next(struct ma_state *mas, uns
 		mas_walk(mas); /* Retries on dead nodes handled by mas_walk */
 
 	if (mas_is_ptr(mas)) {
-		if (!mas->index) {
-			mas->index = 1;
-			mas->last = ULONG_MAX;
+		if (was_none && mas->index == 0) {
+			mas->index = mas->last = 0;
+			return mas_root(mas);
 		}
+		mas->index = 1;
+		mas->last = ULONG_MAX;
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 
-	if (mas->last == ULONG_MAX)
-		return NULL;
-
 	/* Retries on dead nodes handled by mas_next_entry */
 	return mas_next_entry(mas, max);
 }
@@ -6059,17 +6042,25 @@ EXPORT_SYMBOL_GPL(mas_pause);
  */
 void *mas_find(struct ma_state *mas, unsigned long max)
 {
+	if (unlikely(mas_is_none(mas))) {
+		if (unlikely(mas->last >= max))
+			return NULL;
+
+		mas->index = mas->last;
+		mas->node = MAS_START;
+	}
+
 	if (unlikely(mas_is_paused(mas))) {
-		if (unlikely(mas->last == ULONG_MAX)) {
-			mas->node = MAS_NONE;
+		if (unlikely(mas->last >= max))
 			return NULL;
-		}
+
 		mas->node = MAS_START;
 		mas->index = ++mas->last;
 	}
 
-	if (unlikely(mas_is_none(mas)))
-		mas->node = MAS_START;
+
+	if (unlikely(mas_is_ptr(mas)))
+		goto ptr_out_of_range;
 
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
@@ -6081,13 +6072,27 @@ void *mas_find(struct ma_state *mas, uns
 		entry = mas_walk(mas);
 		if (entry)
 			return entry;
+
 	}
 
-	if (unlikely(!mas_searchable(mas)))
+	if (unlikely(!mas_searchable(mas))) {
+		if (unlikely(mas_is_ptr(mas)))
+			goto ptr_out_of_range;
+
+		return NULL;
+	}
+
+	if (mas->index == max)
 		return NULL;
 
 	/* Retries on dead nodes handled by mas_next_entry */
 	return mas_next_entry(mas, max);
+
+ptr_out_of_range:
+	mas->node = MAS_NONE;
+	mas->index = 1;
+	mas->last = ULONG_MAX;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(mas_find);
 
@@ -6518,7 +6523,7 @@ retry:
 	if (entry)
 		goto unlock;
 
-	while (mas_searchable(&mas) && (mas.index < max)) {
+	while (mas_searchable(&mas) && (mas.last < max)) {
 		entry = mas_next_entry(&mas, max);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
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

