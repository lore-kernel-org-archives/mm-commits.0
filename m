Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C41EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjGKTOh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjGKTOa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FE61710
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D8F614AE
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E62C433C7;
        Tue, 11 Jul 2023 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102868;
        bh=nWbe3HiLBVtkAHQKOp7xEEaUGZQjoLx4hmDlipfO2Ro=;
        h=Date:To:From:Subject:From;
        b=bBT3trPU7fZK9nyZCUPBUTdc2gvee5oPlPvf8uPHeyi9lb3V9tOQU36B3n65B1X7C
         pmfpYRnB76Lp+/MFDnfEkfiOPZ8AfVHmTkBZLuyjyUlri55Wm22WGa6uylWbaJ4IcI
         vIr6UcPnL3fLkG4JmYPOKkaYkQ4d1+HOPeNI4Z7k=
Date:   Tue, 11 Jul 2023 12:14:27 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-drop-mas_first_entry.patch added to mm-unstable branch
Message-Id: <20230711191428.33E62C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: drop mas_first_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-drop-mas_first_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-drop-mas_first_entry.patch

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

maple_tree-set-the-node-limit-when-creating-a-new-root-node.patch
maple_tree-add-test-for-mas_wr_modify-fast-path.patch
maple_tree-add-test-for-expanding-range-in-rcu-mode.patch
maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch
maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch
maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch
maple_tree-make-mas_validate_gaps-to-check-metadata.patch
maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch
maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch
maple_tree-update-mt_validate.patch
maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot.patch
maple_tree-drop-mas_first_entry.patch

