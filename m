Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350D3C04FE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbjHKXOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2CC3AAF
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D32D67B04
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C411CC433C7;
        Fri, 11 Aug 2023 23:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794972;
        bh=uaZZESeH0ZX2VYk+nq6B1V6ZaU09rt5xGrQnxWqYbGU=;
        h=Date:To:From:Subject:From;
        b=S49mE1Isyjk3lcEFHP3e+pM1ZqQyvnVn8PWg5BJ0RjnHSew2nALr/Vj5HMwdKP2Fg
         KdGBmRzj39mMun7c9IwrtsM1w/GNDauXu/i4EAencSUS5yJCoFTMRtJqhW1OFaOAjS
         3eJYsHoz76YzMR7RGl/HpgzZzpIrI+82vpG+nPtA=
Date:   Fri, 11 Aug 2023 16:02:52 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-refine-mas_preallocate-node-calculations.patch removed from -mm tree
Message-Id: <20230811230252.C411CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: refine mas_preallocate() node calculations
has been removed from the -mm tree.  Its filename was
     maple_tree-refine-mas_preallocate-node-calculations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: refine mas_preallocate() node calculations
Date: Mon, 24 Jul 2023 14:31:55 -0400

Calculate the number of nodes based on the pending write action instead
of assuming the worst case.

This addresses a performance regression introduced in platforms that
have longer allocation timing.

Link: https://lkml.kernel.org/r/20230724183157.3939892-14-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-refine-mas_preallocate-node-calculations
+++ a/lib/maple_tree.c
@@ -5535,9 +5535,51 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
  */
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
+	MA_WR_STATE(wr_mas, mas, entry);
+	unsigned char node_size;
+	int request = 1;
 	int ret;
 
-	mas_node_count_gfp(mas, 1 + mas_mt_height(mas) * 3, gfp);
+
+	if (unlikely(!mas->index && mas->last == ULONG_MAX))
+		goto ask_now;
+
+	mas_wr_store_setup(&wr_mas);
+	wr_mas.content = mas_start(mas);
+	/* Root expand */
+	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
+		goto ask_now;
+
+	if (unlikely(!mas_wr_walk(&wr_mas))) {
+		/* Spanning store, use worst case for now */
+		request = 1 + mas_mt_height(mas) * 3;
+		goto ask_now;
+	}
+
+	/* At this point, we are at the leaf node that needs to be altered. */
+	/* Exact fit, no nodes needed. */
+	if (wr_mas.r_min == mas->index && wr_mas.r_max == mas->last)
+		return 0;
+
+	mas_wr_end_piv(&wr_mas);
+	node_size = mas_wr_new_end(&wr_mas);
+	if (node_size >= mt_slots[wr_mas.type]) {
+		/* Split, worst case for now. */
+		request = 1 + mas_mt_height(mas) * 2;
+		goto ask_now;
+	}
+
+	/* New root needs a singe node */
+	if (unlikely(mte_is_root(mas->node)))
+		goto ask_now;
+
+	/* Potential spanning rebalance collapsing a node, use worst-case */
+	if (node_size  - 1 <= mt_min_slots[wr_mas.type])
+		request = mas_mt_height(mas) * 2 - 1;
+
+	/* node store, slot store needs one node */
+ask_now:
+	mas_node_count_gfp(mas, request, gfp);
 	mas->mas_flags |= MA_STATE_PREALLOC;
 	if (likely(!mas_is_err(mas)))
 		return 0;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

