Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66868C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjFIXdM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjFIXb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0870F46A6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B5465D09
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE7FC433D2;
        Fri,  9 Jun 2023 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353375;
        bh=uQCOUQTljYMDokXMHxVLhTAWordHbPPbh15rA8ReuFQ=;
        h=Date:To:From:Subject:From;
        b=yEFiwTOM74B5nkKNb+uG80tO8djWpmPd04TZit57SY/EUbH/Orbss70/2pev4u5rg
         yV8zzQ5PG4EGzD3nRNJwDC2fYOvnnArLJNUMB/3ivldnsMeYF+ptwD4s5NTcop6sUK
         JOfrH0SUdUM4ntz8uu+B/GwuCNlD0Fb9+qR3l+Lk=
Date:   Fri, 09 Jun 2023 16:29:34 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch removed from -mm tree
Message-Id: <20230609232934.EEE7FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add comments and some minor cleanups to mas_wr_append()
has been removed from the -mm tree.  Its filename was
     maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


