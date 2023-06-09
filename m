Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB7CC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjFIXaU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjFIX3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4154211
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E5463E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CBAC433EF;
        Fri,  9 Jun 2023 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353313;
        bh=UbG8/YpRINjOegTF1FDyG/jxqWKZv9BDp/I4EuZiFi0=;
        h=Date:To:From:Subject:From;
        b=mtU/tgJtDQ356e9kiS8U3NZxy2nB34BXii5PihTNnFlaO+PkEcW/GKcXr46bdBt2G
         EZ3/nblbGpT6xO6P3lw4JmN2E/Xb4xRP6Ale9o8dbmdSF0Ong6KvyQxc8Cra6th5yI
         tQPGZhV/T/H+twi7u+r3Ilry/k18ygn4L8DguA8o=
Date:   Fri, 09 Jun 2023 16:28:32 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch removed from -mm tree
Message-Id: <20230609232832.D9CBAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: try harder to keep active node with mas_prev()
has been removed from the -mm tree.  Its filename was
     maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: try harder to keep active node with mas_prev()
Date: Thu, 18 May 2023 10:55:33 -0400

Keep a reference to the node when possible with mas_prev().  This will
avoid re-walking the tree.  In keeping a reference to the node, keep the
last/index accurate to the range being referenced.  This means the limit
may be within the range, but the range may extend outside of the limit.

Also fix the single entry tree to respect the range (of 0), or set the
node to MAS_NONE in the case of shifting beyond 0.

Link: https://lkml.kernel.org/r/20230518145544.1722059-25-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  125 +++++++++++++++++++++++++++++----------------
 1 file changed, 83 insertions(+), 42 deletions(-)

--- a/lib/maple_tree.c~maple_tree-try-harder-to-keep-active-node-with-mas_prev
+++ a/lib/maple_tree.c
@@ -4828,7 +4828,7 @@ static inline void *mas_prev_nentry(stru
 				    unsigned long index)
 {
 	unsigned long pivot, min;
-	unsigned char offset;
+	unsigned char offset, count;
 	struct maple_node *mn;
 	enum maple_type mt;
 	unsigned long *pivots;
@@ -4842,29 +4842,42 @@ retry:
 	mn = mas_mn(mas);
 	mt = mte_node_type(mas->node);
 	offset = mas->offset - 1;
-	if (offset >= mt_slots[mt])
-		offset = mt_slots[mt] - 1;
-
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
+	count = ma_data_end(mn, mt, pivots, mas->max);
 	if (unlikely(ma_dead_node(mn))) {
 		mas_rewalk(mas, index);
 		goto retry;
 	}
 
-	if (offset == mt_pivots[mt])
+	offset = mas->offset - 1;
+	if (offset >= mt_slots[mt])
+		offset = mt_slots[mt] - 1;
+
+	if (offset >= count) {
 		pivot = mas->max;
-	else
+		offset = count;
+	} else {
 		pivot = pivots[offset];
+	}
 
 	if (unlikely(ma_dead_node(mn))) {
 		mas_rewalk(mas, index);
 		goto retry;
 	}
 
-	while (offset && ((!mas_slot(mas, slots, offset) && pivot >= limit) ||
-	       !pivot))
+	while (offset && !mas_slot(mas, slots, offset)) {
 		pivot = pivots[--offset];
+		if (pivot >= limit)
+			break;
+	}
+
+	/*
+	 * If the slot was null but we've shifted outside the limits, then set
+	 * the range to the last NULL.
+	 */
+	if (unlikely((pivot < limit) && (offset < mas->offset)))
+		pivot = pivots[++offset];
 
 	min = mas_safe_min(mas, pivots, offset);
 	entry = mas_slot(mas, slots, offset);
@@ -4873,32 +4886,33 @@ retry:
 		goto retry;
 	}
 
-	if (likely(entry)) {
-		mas->offset = offset;
-		mas->last = pivot;
-		mas->index = min;
-	}
+	mas->offset = offset;
+	mas->last = pivot;
+	mas->index = min;
 	return entry;
 }
 
 static inline void *mas_prev_entry(struct ma_state *mas, unsigned long min)
 {
 	void *entry;
+	struct maple_enode *prev_enode;
+	unsigned char prev_offset;
 
-	if (mas->index < min) {
-		mas->index = mas->last = min;
-		mas->node = MAS_NONE;
+	if (mas->index < min)
 		return NULL;
-	}
+
 retry:
+	prev_enode = mas->node;
+	prev_offset = mas->offset;
 	while (likely(!mas_is_none(mas))) {
 		entry = mas_prev_nentry(mas, min, mas->index);
-		if (unlikely(mas->last < min))
-			goto not_found;
 
 		if (likely(entry))
 			return entry;
 
+		if (unlikely(mas->index <= min))
+			return NULL;
+
 		if (unlikely(mas_prev_node(mas, min))) {
 			mas_rewalk(mas, mas->index);
 			goto retry;
@@ -4907,9 +4921,8 @@ retry:
 		mas->offset++;
 	}
 
-	mas->offset--;
-not_found:
-	mas->index = mas->last = min;
+	mas->node = prev_enode;
+	mas->offset = prev_offset;
 	return NULL;
 }
 
@@ -5952,15 +5965,8 @@ EXPORT_SYMBOL_GPL(mt_next);
  */
 void *mas_prev(struct ma_state *mas, unsigned long min)
 {
-	if (!mas->index) {
-		/* Nothing comes before 0 */
-		mas->last = 0;
-		mas->node = MAS_NONE;
-		return NULL;
-	}
-
-	if (unlikely(mas_is_ptr(mas)))
-		return NULL;
+	if (mas->index <= min)
+		goto none;
 
 	if (mas_is_none(mas) || mas_is_paused(mas))
 		mas->node = MAS_START;
@@ -5968,19 +5974,30 @@ void *mas_prev(struct ma_state *mas, uns
 	if (mas_is_start(mas)) {
 		mas_walk(mas);
 		if (!mas->index)
-			return NULL;
+			goto none;
 	}
 
-	if (mas_is_ptr(mas)) {
-		if (!mas->index) {
-			mas->last = 0;
-			return NULL;
-		}
-
+	if (unlikely(mas_is_ptr(mas))) {
+		if (!mas->index)
+			goto none;
 		mas->index = mas->last = 0;
-		return mas_root_locked(mas);
+		return mas_root(mas);
+	}
+
+	if (mas_is_none(mas)) {
+		if (mas->index) {
+			/* Walked to out-of-range pointer? */
+			mas->index = mas->last = 0;
+			mas->node = MAS_ROOT;
+			return mas_root(mas);
+		}
+		return NULL;
 	}
 	return mas_prev_entry(mas, min);
+
+none:
+	mas->node = MAS_NONE;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(mas_prev);
 
@@ -6106,8 +6123,16 @@ EXPORT_SYMBOL_GPL(mas_find);
  */
 void *mas_find_rev(struct ma_state *mas, unsigned long min)
 {
+	if (unlikely(mas_is_none(mas))) {
+		if (mas->index <= min)
+			goto none;
+
+		mas->last = mas->index;
+		mas->node = MAS_START;
+	}
+
 	if (unlikely(mas_is_paused(mas))) {
-		if (unlikely(mas->last == ULONG_MAX)) {
+		if (unlikely(mas->index <= min)) {
 			mas->node = MAS_NONE;
 			return NULL;
 		}
@@ -6127,14 +6152,30 @@ void *mas_find_rev(struct ma_state *mas,
 			return entry;
 	}
 
-	if (unlikely(!mas_searchable(mas)))
-		return NULL;
+	if (unlikely(!mas_searchable(mas))) {
+		if (mas_is_ptr(mas))
+			goto none;
+
+		if (mas_is_none(mas)) {
+			/*
+			 * Walked to the location, and there was nothing so the
+			 * previous location is 0.
+			 */
+			mas->last = mas->index = 0;
+			mas->node = MAS_ROOT;
+			return mas_root(mas);
+		}
+	}
 
 	if (mas->index < min)
 		return NULL;
 
 	/* Retries on dead nodes handled by mas_prev_entry */
 	return mas_prev_entry(mas, min);
+
+none:
+	mas->node = MAS_NONE;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(mas_find_rev);
 
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

