Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FC1C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjFIXdF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjFIXb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292B346A8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C49765D0C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A60C433EF;
        Fri,  9 Jun 2023 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353376;
        bh=LcoMkEcN0QrTEQ8GqevLeo4JZV6x0f8hOhFYvxYxJws=;
        h=Date:To:From:Subject:From;
        b=VOvbCnsMu7tpKUIQ7Hs9svncgOhNdo4sE/SdjVgIM+FVMogyQZ0r3scOchhHeEWp5
         61LSqIjayo2bMWvNN2ip3hbl2jIG7CF9Hkkn1p0yKPI8FhHgtxhvMrJ9nDWWjrLJjf
         wLK1eLIJ/72jEepJQeydjouJl8FEKKNxZGA6lYOI=
Date:   Fri, 09 Jun 2023 16:29:35 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch removed from -mm tree
Message-Id: <20230609232936.02A60C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: rework mas_wr_slot_store() to be cleaner and more efficient.
has been removed from the -mm tree.  Its filename was
     maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: rework mas_wr_slot_store() to be cleaner and more efficient.
Date: Wed, 24 May 2023 11:12:45 +0800

Get whether the two gaps to be overwritten are empty to avoid calling
mas_update_gap() all the time.  Also clean up the code and add comments.

Link: https://lkml.kernel.org/r/20230524031247.65949-9-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   53 ++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

--- a/lib/maple_tree.c~maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient
+++ a/lib/maple_tree.c
@@ -4202,49 +4202,34 @@ done:
 static inline bool mas_wr_slot_store(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned long lmax; /* Logical max. */
 	unsigned char offset = mas->offset;
+	bool gap = false;
 
-	if ((wr_mas->r_max > mas->last) && ((wr_mas->r_min != mas->index) ||
-				  (offset != wr_mas->node_end)))
+	if (wr_mas->offset_end - offset != 1)
 		return false;
 
-	if (offset == wr_mas->node_end - 1)
-		lmax = mas->max;
-	else
-		lmax = wr_mas->pivots[offset + 1];
-
-	/* going to overwrite too many slots. */
-	if (lmax < mas->last)
-		return false;
+	gap |= !mt_slot_locked(mas->tree, wr_mas->slots, offset);
+	gap |= !mt_slot_locked(mas->tree, wr_mas->slots, offset + 1);
 
-	if (wr_mas->r_min == mas->index) {
-		/* overwriting two or more ranges with one. */
-		if (lmax == mas->last)
-			return false;
-
-		/* Overwriting all of offset and a portion of offset + 1. */
+	if (mas->index == wr_mas->r_min) {
+		/* Overwriting the range and over a part of the next range. */
 		rcu_assign_pointer(wr_mas->slots[offset], wr_mas->entry);
 		wr_mas->pivots[offset] = mas->last;
-		goto done;
+	} else {
+		/* Overwriting a part of the range and over the next range */
+		rcu_assign_pointer(wr_mas->slots[offset + 1], wr_mas->entry);
+		wr_mas->pivots[offset] = mas->index - 1;
+		mas->offset++; /* Keep mas accurate. */
 	}
 
-	/* Doesn't end on the next range end. */
-	if (lmax != mas->last)
-		return false;
-
-	/* Overwriting a portion of offset and all of offset + 1 */
-	if ((offset + 1 < mt_pivots[wr_mas->type]) &&
-	    (wr_mas->entry || wr_mas->pivots[offset + 1]))
-		wr_mas->pivots[offset + 1] = mas->last;
-
-	rcu_assign_pointer(wr_mas->slots[offset + 1], wr_mas->entry);
-	wr_mas->pivots[offset] = mas->index - 1;
-	mas->offset++; /* Keep mas accurate. */
-
-done:
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
-	mas_update_gap(mas);
+	/*
+	 * Only update gap when the new entry is empty or there is an empty
+	 * entry in the original two ranges.
+	 */
+	if (!wr_mas->entry || gap)
+		mas_update_gap(mas);
+
 	return true;
 }
 
@@ -4391,7 +4376,7 @@ static inline void mas_wr_modify(struct
 	if (new_end == wr_mas->node_end + 1 && mas_wr_append(wr_mas))
 		return;
 
-	if ((wr_mas->offset_end - mas->offset <= 1) && mas_wr_slot_store(wr_mas))
+	if (new_end == wr_mas->node_end && mas_wr_slot_store(wr_mas))
 		return;
 	else if (mas_wr_node_store(wr_mas))
 		return;
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


