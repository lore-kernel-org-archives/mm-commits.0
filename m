Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE9BC77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjEYVE7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbjEYVEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B861A8
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4591C64B2B
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9850CC4339B;
        Thu, 25 May 2023 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048675;
        bh=JbPw5HRHqgfY6gAvHD2wAQ/Mkcu5GR2VXsUQSJljvuM=;
        h=Date:To:From:Subject:From;
        b=fnzn3HkBulBTCNIWhfTpgUPKy5wkBF927YmaBFOXOfETymUOYq7mKBQqBmwp5r97f
         +zdW3bnU6nDYaYwWidCDxJnJvrar15fYWviLdUU4haYNp/uVTsxd8VHkzAaaMArUbr
         L94I41t340ClC7bLTb/NQwUISTF3SrU/yQfzQceM=
Date:   Thu, 25 May 2023 14:04:35 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch added to mm-unstable branch
Message-Id: <20230525210435.9850CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add comments and some minor cleanups to mas_wr_append()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch

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
Subject: maple_tree: add comments and some minor cleanups to mas_wr_append()
Date: Wed, 24 May 2023 11:12:44 +0800

Add comment for mas_wr_append(), move mas_update_gap() into
mas_wr_append(), and other cleanups to make mas_wr_modify() cleaner.

Link: https://lkml.kernel.org/r/20230524031247.65949-8-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   47 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append
+++ a/lib/maple_tree.c
@@ -4311,6 +4311,12 @@ static inline unsigned char mas_wr_new_e
 	return new_end;
 }
 
+/*
+ * mas_wr_append: Attempt to append
+ * @wr_mas: the maple write state
+ *
+ * Return: True if appended, false otherwise
+ */
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas)
 {
 	unsigned char end = wr_mas->node_end;
@@ -4318,34 +4324,30 @@ static inline bool mas_wr_append(struct
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char node_pivots = mt_pivots[wr_mas->type];
 
-	if ((mas->index != wr_mas->r_min) && (mas->last == wr_mas->r_max)) {
-		if (new_end < node_pivots)
-			wr_mas->pivots[new_end] = wr_mas->pivots[end];
+	if (mas->offset != wr_mas->node_end)
+		return false;
 
-		if (new_end < node_pivots)
-			ma_set_meta(wr_mas->node, maple_leaf_64, 0, new_end);
+	if (new_end < node_pivots) {
+		wr_mas->pivots[new_end] = wr_mas->pivots[end];
+		ma_set_meta(wr_mas->node, maple_leaf_64, 0, new_end);
+	}
 
+	if (mas->last == wr_mas->r_max) {
+		/* Append to end of range */
 		rcu_assign_pointer(wr_mas->slots[new_end], wr_mas->entry);
-		mas->offset = new_end;
 		wr_mas->pivots[end] = mas->index - 1;
-
-		return true;
-	}
-
-	if ((mas->index == wr_mas->r_min) && (mas->last < wr_mas->r_max)) {
-		if (new_end < node_pivots)
-			wr_mas->pivots[new_end] = wr_mas->pivots[end];
-
+		mas->offset = new_end;
+	} else {
+		/* Append to start of range */
 		rcu_assign_pointer(wr_mas->slots[new_end], wr_mas->content);
-		if (new_end < node_pivots)
-			ma_set_meta(wr_mas->node, maple_leaf_64, 0, new_end);
-
 		wr_mas->pivots[end] = mas->last;
 		rcu_assign_pointer(wr_mas->slots[end], wr_mas->entry);
-		return true;
 	}
 
-	return false;
+	if (!wr_mas->content || !wr_mas->entry)
+		mas_update_gap(mas);
+
+	return  true;
 }
 
 /*
@@ -4385,12 +4387,9 @@ static inline void mas_wr_modify(struct
 	if (new_end >= mt_slots[wr_mas->type])
 		goto slow_path;
 
-	if (wr_mas->entry && (wr_mas->node_end < mt_slots[wr_mas->type] - 1) &&
-	    (mas->offset == wr_mas->node_end) && mas_wr_append(wr_mas)) {
-		if (!wr_mas->content || !wr_mas->entry)
-			mas_update_gap(mas);
+	/* Attempt to append */
+	if (new_end == wr_mas->node_end + 1 && mas_wr_append(wr_mas))
 		return;
-	}
 
 	if ((wr_mas->offset_end - mas->offset <= 1) && mas_wr_slot_store(wr_mas))
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

