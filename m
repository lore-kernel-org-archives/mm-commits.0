Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F50AC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbjFIXdL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjFIXb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ADC3C26
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A541A65D09
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E8C433EF;
        Fri,  9 Jun 2023 23:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353377;
        bh=s/YX36qzzQCqw+ijb54VYjIojXysvKzm066h+/FRLyg=;
        h=Date:To:From:Subject:From;
        b=X2jBcxbAShUFKDNpmlp07JMcjscKClNh0Bt8HoQSkXY+kpZ0XvLWYN8/rJTHeyuvu
         bbV/wdwFwkPbmBk/NkTWv3+ihe/BU9mVvPxPN5sWSJ1YXZLJxOb7fVRTAHmcG2z37D
         FKhPeJkuz34xutIZbDrloH6Al2TR8/eTdvrIofRE=
Date:   Fri, 09 Jun 2023 16:29:36 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-and-clean-up-mas_wr_node_store.patch removed from -mm tree
Message-Id: <20230609232937.070E8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: simplify and clean up mas_wr_node_store()
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-and-clean-up-mas_wr_node_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: simplify and clean up mas_wr_node_store()
Date: Wed, 24 May 2023 11:12:46 +0800

Simplify and clean up mas_wr_node_store(), remove unnecessary code.

Link: https://lkml.kernel.org/r/20230524031247.65949-10-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   87 +++++++++++++--------------------------------
 1 file changed, 26 insertions(+), 61 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-and-clean-up-mas_wr_node_store
+++ a/lib/maple_tree.c
@@ -4074,52 +4074,27 @@ static inline int mas_wr_spanning_store(
  *
  * Return: True if stored, false otherwise
  */
-static inline bool mas_wr_node_store(struct ma_wr_state *wr_mas)
+static inline bool mas_wr_node_store(struct ma_wr_state *wr_mas,
+				     unsigned char new_end)
 {
 	struct ma_state *mas = wr_mas->mas;
 	void __rcu **dst_slots;
 	unsigned long *dst_pivots;
-	unsigned char dst_offset;
-	unsigned char new_end = wr_mas->node_end;
-	unsigned char offset;
-	unsigned char node_slots = mt_slots[wr_mas->type];
+	unsigned char dst_offset, offset_end = wr_mas->offset_end;
 	struct maple_node reuse, *newnode;
-	unsigned char copy_size, max_piv = mt_pivots[wr_mas->type];
+	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
 	bool in_rcu = mt_in_rcu(mas->tree);
 
-	offset = mas->offset;
-	if (mas->last == wr_mas->r_max) {
-		/* runs right to the end of the node */
-		if (mas->last == mas->max)
-			new_end = offset;
-		/* don't copy this offset */
-		wr_mas->offset_end++;
-	} else if (mas->last < wr_mas->r_max) {
-		/* new range ends in this range */
-		if (unlikely(wr_mas->r_max == ULONG_MAX))
-			mas_bulk_rebalance(mas, wr_mas->node_end, wr_mas->type);
-
-		new_end++;
-	} else {
-		if (wr_mas->end_piv == mas->last)
-			wr_mas->offset_end++;
-
-		new_end -= wr_mas->offset_end - offset - 1;
-	}
-
-	/* new range starts within a range */
-	if (wr_mas->r_min < mas->index)
-		new_end++;
-
-	/* Not enough room */
-	if (new_end >= node_slots)
-		return false;
-
-	/* Not enough data. */
+	/* Check if there is enough data. The room is enough. */
 	if (!mte_is_root(mas->node) && (new_end <= mt_min_slots[wr_mas->type]) &&
 	    !(mas->mas_flags & MA_STATE_BULK))
 		return false;
 
+	if (mas->last == wr_mas->end_piv)
+		offset_end++; /* don't copy this offset */
+	else if (unlikely(wr_mas->r_max == ULONG_MAX))
+		mas_bulk_rebalance(mas, wr_mas->node_end, wr_mas->type);
+
 	/* set up node. */
 	if (in_rcu) {
 		mas_node_count(mas, 1);
@@ -4136,47 +4111,36 @@ static inline bool mas_wr_node_store(str
 	dst_pivots = ma_pivots(newnode, wr_mas->type);
 	dst_slots = ma_slots(newnode, wr_mas->type);
 	/* Copy from start to insert point */
-	memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * (offset + 1));
-	memcpy(dst_slots, wr_mas->slots, sizeof(void *) * (offset + 1));
-	dst_offset = offset;
+	memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
+	memcpy(dst_slots, wr_mas->slots, sizeof(void *) * mas->offset);
 
 	/* Handle insert of new range starting after old range */
 	if (wr_mas->r_min < mas->index) {
-		mas->offset++;
-		rcu_assign_pointer(dst_slots[dst_offset], wr_mas->content);
-		dst_pivots[dst_offset++] = mas->index - 1;
+		rcu_assign_pointer(dst_slots[mas->offset], wr_mas->content);
+		dst_pivots[mas->offset++] = mas->index - 1;
 	}
 
 	/* Store the new entry and range end. */
-	if (dst_offset < max_piv)
-		dst_pivots[dst_offset] = mas->last;
-	mas->offset = dst_offset;
-	rcu_assign_pointer(dst_slots[dst_offset], wr_mas->entry);
+	if (mas->offset < node_pivots)
+		dst_pivots[mas->offset] = mas->last;
+	rcu_assign_pointer(dst_slots[mas->offset], wr_mas->entry);
 
 	/*
 	 * this range wrote to the end of the node or it overwrote the rest of
 	 * the data
 	 */
-	if (wr_mas->offset_end > wr_mas->node_end || mas->last >= mas->max) {
-		new_end = dst_offset;
+	if (offset_end > wr_mas->node_end)
 		goto done;
-	}
 
-	dst_offset++;
+	dst_offset = mas->offset + 1;
 	/* Copy to the end of node if necessary. */
-	copy_size = wr_mas->node_end - wr_mas->offset_end + 1;
-	memcpy(dst_slots + dst_offset, wr_mas->slots + wr_mas->offset_end,
+	copy_size = wr_mas->node_end - offset_end + 1;
+	memcpy(dst_slots + dst_offset, wr_mas->slots + offset_end,
 	       sizeof(void *) * copy_size);
-	if (dst_offset < max_piv) {
-		if (copy_size > max_piv - dst_offset)
-			copy_size = max_piv - dst_offset;
-
-		memcpy(dst_pivots + dst_offset,
-		       wr_mas->pivots + wr_mas->offset_end,
-		       sizeof(unsigned long) * copy_size);
-	}
+	memcpy(dst_pivots + dst_offset, wr_mas->pivots + offset_end,
+	       sizeof(unsigned long) * (copy_size - 1));
 
-	if ((wr_mas->node_end == node_slots - 1) && (new_end < node_slots - 1))
+	if (new_end < node_pivots)
 		dst_pivots[new_end] = mas->max;
 
 done:
@@ -4378,7 +4342,8 @@ static inline void mas_wr_modify(struct
 
 	if (new_end == wr_mas->node_end && mas_wr_slot_store(wr_mas))
 		return;
-	else if (mas_wr_node_store(wr_mas))
+
+	if (mas_wr_node_store(wr_mas, new_end))
 		return;
 
 	if (mas_is_err(mas))
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


