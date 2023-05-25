Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30785C7EE2F
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjEYVE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjEYVEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B8DE53
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 270F964B1F
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C820C4339B;
        Thu, 25 May 2023 21:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048666;
        bh=kaurJEPVk2uC7PWRaugD6MdT0lfkPCJEVP4IfxNWCDI=;
        h=Date:To:From:Subject:From;
        b=xV1+0KPlQVgE4i7eBU9Qn6UN1vDj4J7VmQk1l3JsW29+Kg1Z2LdgxMla5Ovc1f/AX
         76oHh5r7pfWRtChnUEn8Ya1DJZMmID85A44ybSAbrgDvnpB/+MFJpuT4yIJTj6b+tS
         sjKzJIuUsyNG4L90cGbW9CTOFPYEC8BoKdO2at4w=
Date:   Thu, 25 May 2023 14:04:25 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch added to mm-unstable branch
Message-Id: <20230525210426.7C820C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: drop mas_{rev_}alloc() and mas_fill_gap()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: drop mas_{rev_}alloc() and mas_fill_gap()
Date: Wed, 24 May 2023 11:12:39 +0800

mas_{rev_}alloc() and mas_fill_gap() are no longer used, delete them.

Link: https://lkml.kernel.org/r/20230524031247.65949-3-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  108 ---------------------------------------------
 1 file changed, 108 deletions(-)

--- a/lib/maple_tree.c~maple_tree-drop-mas_rev_alloc-and-mas_fill_gap
+++ a/lib/maple_tree.c
@@ -5121,46 +5121,6 @@ static inline void mas_awalk(struct ma_s
 }
 
 /*
- * mas_fill_gap() - Fill a located gap with @entry.
- * @mas: The maple state
- * @entry: The value to store
- * @slot: The offset into the node to store the @entry
- * @size: The size of the entry
- * @index: The start location
- */
-static inline void mas_fill_gap(struct ma_state *mas, void *entry,
-		unsigned char slot, unsigned long size, unsigned long *index)
-{
-	MA_WR_STATE(wr_mas, mas, entry);
-	unsigned char pslot = mte_parent_slot(mas->node);
-	struct maple_enode *mn = mas->node;
-	unsigned long *pivots;
-	enum maple_type ptype;
-	/*
-	 * mas->index is the start address for the search
-	 *  which may no longer be needed.
-	 * mas->last is the end address for the search
-	 */
-
-	*index = mas->index;
-	mas->last = mas->index + size - 1;
-
-	/*
-	 * It is possible that using mas->max and mas->min to correctly
-	 * calculate the index and last will cause an issue in the gap
-	 * calculation, so fix the ma_state here
-	 */
-	mas_ascend(mas);
-	ptype = mte_node_type(mas->node);
-	pivots = ma_pivots(mas_mn(mas), ptype);
-	mas->max = mas_safe_pivot(mas, pivots, pslot, ptype);
-	mas->min = mas_safe_min(mas, pivots, pslot);
-	mas->node = mn;
-	mas->offset = slot;
-	mas_wr_store_entry(&wr_mas);
-}
-
-/*
  * mas_sparse_area() - Internal function.  Return upper or lower limit when
  * searching for a gap in an empty tree.
  * @mas: The maple state
@@ -5307,74 +5267,6 @@ int mas_empty_area_rev(struct ma_state *
 }
 EXPORT_SYMBOL_GPL(mas_empty_area_rev);
 
-static inline int mas_alloc(struct ma_state *mas, void *entry,
-		unsigned long size, unsigned long *index)
-{
-	unsigned long min;
-
-	mas_start(mas);
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_root_expand(mas, entry);
-		if (mas_is_err(mas))
-			return xa_err(mas->node);
-
-		if (!mas->index)
-			return mas_pivot(mas, 0);
-		return mas_pivot(mas, 1);
-	}
-
-	/* Must be walking a tree. */
-	mas_awalk(mas, size);
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
-
-	if (mas->offset == MAPLE_NODE_SLOTS)
-		goto no_gap;
-
-	/*
-	 * At this point, mas->node points to the right node and we have an
-	 * offset that has a sufficient gap.
-	 */
-	min = mas->min;
-	if (mas->offset)
-		min = mas_pivot(mas, mas->offset - 1) + 1;
-
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
-
-	if (mas->index < min)
-		mas->index = min;
-
-	mas_fill_gap(mas, entry, mas->offset, size, index);
-	return 0;
-
-no_gap:
-	return -EBUSY;
-}
-
-static inline int mas_rev_alloc(struct ma_state *mas, unsigned long min,
-				unsigned long max, void *entry,
-				unsigned long size, unsigned long *index)
-{
-	int ret = 0;
-
-	ret = mas_empty_area_rev(mas, min, max, size);
-	if (ret)
-		return ret;
-
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
-
-	if (mas->offset == MAPLE_NODE_SLOTS)
-		goto no_gap;
-
-	mas_fill_gap(mas, entry, mas->offset, size, index);
-	return 0;
-
-no_gap:
-	return -EBUSY;
-}
-
 /*
  * mte_dead_leaves() - Mark all leaves of a node as dead.
  * @mas: The maple state
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

radix-tree-move-declarations-to-header-fix.patch
maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch
maple_tree-rework-mtree_alloc_rangerrange.patch
maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch
maple_tree-fix-the-arguments-to-__must_hold.patch
maple_tree-simplify-mas_is_span_wr.patch
maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null.patch
maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately.patch
maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch
maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch
maple_tree-simplify-and-clean-up-mas_wr_node_store.patch
maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

