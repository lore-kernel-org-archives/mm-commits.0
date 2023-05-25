Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE76EC77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241863AbjEYVFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241951AbjEYVEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6991B0
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BD5A64B3B
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AF5C433EF;
        Thu, 25 May 2023 21:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048677;
        bh=ZDLZGvHQoF5ZvumhJsvmged9geiu/UfxXeVf1Z71kxU=;
        h=Date:To:From:Subject:From;
        b=yJAQuKwTu59AoLqLwQNFLpnagCqf4tKe11MJfICVQUzwFAQTtYHDFyXiTYqkLMN8X
         pVWA+MBP28kK5ZQ1K86SKgGs0mXq2CsETehdwZgqZPN7OlOVNxgRAt3qKdaNmjgmNr
         gYf63Jh/RHGCZkUUPEl0j4rbTyKp09SVND55Zunw=
Date:   Thu, 25 May 2023 14:04:36 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch added to mm-unstable branch
Message-Id: <20230525210437.60AF5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: rework mas_wr_slot_store() to be cleaner and more efficient.
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch

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

