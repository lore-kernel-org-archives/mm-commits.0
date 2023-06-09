Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260FEC87FDC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjFIXaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFIX25 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6754210
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4233963EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A372C4339B;
        Fri,  9 Jun 2023 23:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353311;
        bh=BSUAhefUO02siazgTd551U7g81ruhozJHFEKZ/8EzqA=;
        h=Date:To:From:Subject:From;
        b=NiIjLWSNWcYsb4UK/fF2sNESc/ZnX7c+nomTXeAMLHfS6xgA2xlapIVyuwakPpuoT
         jQufpT7Z1HXcjAwz9Yw7xqYd5Yl9h+MuhJw6VH0SpqXZU68HMQwR3fSNCPTf7MNqgq
         3yy0Reh9PgXg5xuIcl1zEIlrv0N4aqZbXX55NLmE=
Date:   Fri, 09 Jun 2023 16:28:30 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-try-harder-to-keep-active-node-after-mas_next.patch removed from -mm tree
Message-Id: <20230609232831.9A372C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: try harder to keep active node after mas_next()
has been removed from the -mm tree.  Its filename was
     maple_tree-try-harder-to-keep-active-node-after-mas_next.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: try harder to keep active node after mas_next()
Date: Thu, 18 May 2023 10:55:32 -0400

Clean up the mas_next() call to try and keep a node reference when
possible.  This will avoid re-walking the tree in most cases.

Also clean up the single entry tree handling to ensure index/last are
consistent with what one would expect.  (returning NULL with limit of
1-oo).

Link: https://lkml.kernel.org/r/20230518145544.1722059-24-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   89 +++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 42 deletions(-)

--- a/lib/maple_tree.c~maple_tree-try-harder-to-keep-active-node-after-mas_next
+++ a/lib/maple_tree.c
@@ -4727,33 +4727,25 @@ static inline void *mas_next_nentry(stru
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
@@ -4782,21 +4774,15 @@ retry:
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
@@ -4815,12 +4801,10 @@ retry:
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
@@ -4830,9 +4814,6 @@ next_node:
 		mt = mte_node_type(mas->node);
 	}
 
-	mas->index = mas->last = limit;
-	mas->offset = offset;
-	mas->node = prev_node;
 	return NULL;
 }
 
@@ -5914,6 +5895,8 @@ EXPORT_SYMBOL_GPL(mas_expected_entries);
  */
 void *mas_next(struct ma_state *mas, unsigned long max)
 {
+	bool was_none = mas_is_none(mas);
+
 	if (mas_is_none(mas) || mas_is_paused(mas))
 		mas->node = MAS_START;
 
@@ -5921,16 +5904,16 @@ void *mas_next(struct ma_state *mas, uns
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
@@ -6054,17 +6037,25 @@ EXPORT_SYMBOL_GPL(mas_pause);
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
@@ -6076,13 +6067,27 @@ void *mas_find(struct ma_state *mas, uns
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
 
@@ -6513,7 +6518,7 @@ retry:
 	if (entry)
 		goto unlock;
 
-	while (mas_searchable(&mas) && (mas.index < max)) {
+	while (mas_searchable(&mas) && (mas.last < max)) {
 		entry = mas_next_entry(&mas, max);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
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

