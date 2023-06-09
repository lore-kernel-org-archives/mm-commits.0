Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75446C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjFIXcz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjFIXbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB174697
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A0365D07
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EE8C433EF;
        Fri,  9 Jun 2023 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353369;
        bh=cN3f2dSDIHDgg7TqDyrHXu9CZjk1rvwiq7dVXFXXIag=;
        h=Date:To:From:Subject:From;
        b=fN8gIxmT3JpTODC61YSXbf1MyLBeyDclA08xNP2wosU50FG+TgDQErlzA1H8hDpMq
         dwMzVvCNWebwQH/Yq2C93CEKgTaC68pI2RstEb7XyEgaKVcO0FAqK9JYPBlgG/0MLY
         czj6XH3Oh85VcKuOOoEEVl8gZq1aQzs86caoqiBA=
Date:   Fri, 09 Jun 2023 16:29:29 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch removed from -mm tree
Message-Id: <20230609232929.C0EE8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: drop mas_{rev_}alloc() and mas_fill_gap()
has been removed from the -mm tree.  Its filename was
     maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


