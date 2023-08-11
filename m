Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90966C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjHKXCD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbjHKXAg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3512A3C0C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE06C6492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0EAC433C8;
        Fri, 11 Aug 2023 23:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794822;
        bh=Ssmjhxq8htxlIHYogQElRimUl5ShcEPJD2FdqyfcaYY=;
        h=Date:To:From:Subject:From;
        b=zdJwCFhkHb8BpiStNqpEerQmxzkObvRqzAyAsx+CSrGkMF+0GRrcG1N0psziBqj0z
         nN8Y0JTeE//XQegfLR+E6zo0GfMh86rHjRrLmncd9t/CKMqj6Mz4Q9IxRnAFRRoV5t
         /fFP7elFamOWnL0QntNlHVDBzWfnOBo36i5e4qJM=
Date:   Fri, 11 Aug 2023 16:00:21 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-drop-mas_first_entry.patch removed from -mm tree
Message-Id: <20230811230022.1D0EAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: drop mas_first_entry()
has been removed from the -mm tree.  Its filename was
     maple_tree-drop-mas_first_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: drop mas_first_entry()
Date: Tue, 11 Jul 2023 11:54:44 +0800

The internal function mas_first_entry() is no longer used, so drop it.

Link: https://lkml.kernel.org/r/20230711035444.526-9-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   72 ---------------------------------------------
 1 file changed, 72 deletions(-)

--- a/lib/maple_tree.c~maple_tree-drop-mas_first_entry
+++ a/lib/maple_tree.c
@@ -6636,78 +6636,6 @@ static inline struct maple_enode *mas_ge
 			offset);
 }
 
-
-/*
- * mas_first_entry() - Go the first leaf and find the first entry.
- * @mas: the maple state.
- * @limit: the maximum index to check.
- * @*r_start: Pointer to set to the range start.
- *
- * Sets mas->offset to the offset of the entry, r_start to the range minimum.
- *
- * Return: The first entry or MAS_NONE.
- */
-static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
-		unsigned long limit, enum maple_type mt)
-
-{
-	unsigned long max;
-	unsigned long *pivots;
-	void __rcu **slots;
-	void *entry = NULL;
-
-	mas->index = mas->min;
-	if (mas->index > limit)
-		goto none;
-
-	max = mas->max;
-	mas->offset = 0;
-	while (likely(!ma_is_leaf(mt))) {
-		MAS_WARN_ON(mas, mte_dead_node(mas->node));
-		slots = ma_slots(mn, mt);
-		entry = mas_slot(mas, slots, 0);
-		pivots = ma_pivots(mn, mt);
-		if (unlikely(ma_dead_node(mn)))
-			return NULL;
-		max = pivots[0];
-		mas->node = entry;
-		mn = mas_mn(mas);
-		mt = mte_node_type(mas->node);
-	}
-	MAS_WARN_ON(mas, mte_dead_node(mas->node));
-
-	mas->max = max;
-	slots = ma_slots(mn, mt);
-	entry = mas_slot(mas, slots, 0);
-	if (unlikely(ma_dead_node(mn)))
-		return NULL;
-
-	/* Slot 0 or 1 must be set */
-	if (mas->index > limit)
-		goto none;
-
-	if (likely(entry))
-		return entry;
-
-	mas->offset = 1;
-	entry = mas_slot(mas, slots, 1);
-	pivots = ma_pivots(mn, mt);
-	if (unlikely(ma_dead_node(mn)))
-		return NULL;
-
-	mas->index = pivots[0] + 1;
-	if (mas->index > limit)
-		goto none;
-
-	if (likely(entry))
-		return entry;
-
-none:
-	if (likely(!ma_dead_node(mn)))
-		mas->node = MAS_NONE;
-	return NULL;
-}
-
 /* Depth first search, post-order */
 static void mas_dfs_postorder(struct ma_state *mas, unsigned long max)
 {
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


