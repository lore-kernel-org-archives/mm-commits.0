Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EA3C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjKFReT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjKFReR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D2BD4D
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EFAC433C8;
        Mon,  6 Nov 2023 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292054;
        bh=pvTXr9D0D1zV/XdHCWPKPH8ChyKGul/9uTK3ZdF5Xiw=;
        h=Date:To:From:Subject:From;
        b=YDT6SjePJB07bz6je+8jOvJp+IdwpkMgpbVvW3u7x0j/4TJ2L2N8hPvzh69TSAXwe
         GMHISL216V5G6/+KM/8zXtVbw2z/wx1b6us2Qpt/wWnp9WTKOU6kvk8Gx9VpBew75L
         9O+bq9skMUrfcG+eRFrdVIb3WmKGEWFOevfvhIbY=
Date:   Mon, 06 Nov 2023 09:34:14 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-cached-node-end-in-mas_next.patch added to mm-unstable branch
Message-Id: <20231106173414.A9EFAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use cached node end in mas_next()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-cached-node-end-in-mas_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-cached-node-end-in-mas_next.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: use cached node end in mas_next()
Date: Wed, 1 Nov 2023 13:16:22 -0400

When looking for the next entry, don't recalculate the node end as it is
now tracked in the maple state.

Link: https://lkml.kernel.org/r/20231101171629.3612299-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-cached-node-end-in-mas_next
+++ a/lib/maple_tree.c
@@ -4539,6 +4539,7 @@ static inline int mas_next_node(struct m
 	unsigned long min;
 	unsigned long *pivots;
 	struct maple_enode *enode;
+	struct maple_node *tmp;
 	int level = 0;
 	unsigned char node_end;
 	enum maple_type mt;
@@ -4591,6 +4592,10 @@ static inline int mas_next_node(struct m
 		pivots = ma_pivots(node, mt);
 
 	mas->max = mas_safe_pivot(mas, pivots, mas->offset, mt);
+	tmp = mte_to_node(enode);
+	mt = mte_node_type(enode);
+	pivots = ma_pivots(tmp, mt);
+	mas->end = ma_data_end(tmp, mt, pivots, mas->max);
 	if (unlikely(ma_dead_node(node)))
 		return 1;
 
@@ -4625,7 +4630,6 @@ static void *mas_next_slot(struct ma_sta
 	unsigned long pivot;
 	enum maple_type type;
 	struct maple_node *node;
-	unsigned char data_end;
 	unsigned long save_point = mas->last;
 	void *entry;
 
@@ -4633,12 +4637,11 @@ retry:
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	data_end = ma_data_end(node, type, pivots, mas->max);
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
 	if (mas->max >= max) {
-		if (likely(mas->offset < data_end))
+		if (likely(mas->offset < mas->end))
 			pivot = pivots[mas->offset];
 		else
 			goto overflow;
@@ -4650,11 +4653,11 @@ retry:
 			goto overflow;
 	}
 
-	if (likely(mas->offset < data_end)) {
+	if (likely(mas->offset < mas->end)) {
 		mas->index = pivots[mas->offset] + 1;
 again:
 		mas->offset++;
-		if (likely(mas->offset < data_end))
+		if (likely(mas->offset < mas->end))
 			mas->last = pivots[mas->offset];
 		else
 			mas->last = mas->max;
@@ -4691,7 +4694,6 @@ again:
 			goto overflow;
 
 		mas->index = mas->last + 1;
-		/* Node cannot end on NULL, so it's safe to short-cut here */
 		goto again;
 	}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

