Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28826C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbjHKXBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3982D3C07
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A15634A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD5C433C8;
        Fri, 11 Aug 2023 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794817;
        bh=2taF2E0Fwc1FBvnyTEMQO4NL4FV8msSdFWP0l4cO5Fs=;
        h=Date:To:From:Subject:From;
        b=cHwAyjIbM1cY8m+FTRkTNHj8Y7kWLJdb7AxdkhaR5CNb76BFzjQT9DfhY+orOFJSO
         dIVdFq6OGd41E4tsiIhQ4DNqyEoLzRovwAvtIJVyL320Ec9PpqoQHyc3HSN51cavbK
         hwjlkACbTIUiRkNOXZoisIAms2TItk8JYs+eJd5o=
Date:   Fri, 11 Aug 2023 16:00:16 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-make-mas_validate_gaps-to-check-metadata.patch removed from -mm tree
Message-Id: <20230811230017.26BD5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: make mas_validate_gaps() to check metadata
has been removed from the -mm tree.  Its filename was
     maple_tree-make-mas_validate_gaps-to-check-metadata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: make mas_validate_gaps() to check metadata
Date: Tue, 11 Jul 2023 11:54:39 +0800

Make mas_validate_gaps() check whether the offset in the metadata points
to the largest gap.  By the way, simplify this function.

Add the verification that gaps beyond the node limit are zero.

Link: https://lkml.kernel.org/r/20230711035444.526-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   78 ++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-mas_validate_gaps-to-check-metadata
+++ a/lib/maple_tree.c
@@ -6957,15 +6957,16 @@ EXPORT_SYMBOL_GPL(mt_dump);
 static void mas_validate_gaps(struct ma_state *mas)
 {
 	struct maple_enode *mte = mas->node;
-	struct maple_node *p_mn;
+	struct maple_node *p_mn, *node = mte_to_node(mte);
+	enum maple_type mt = mte_node_type(mas->node);
 	unsigned long gap = 0, max_gap = 0;
 	unsigned long p_end, p_start = mas->min;
-	unsigned char p_slot;
+	unsigned char p_slot, offset;
 	unsigned long *gaps = NULL;
-	unsigned long *pivots = ma_pivots(mte_to_node(mte), mte_node_type(mte));
-	int i;
+	unsigned long *pivots = ma_pivots(node, mt);
+	unsigned int i;
 
-	if (ma_is_dense(mte_node_type(mte))) {
+	if (ma_is_dense(mt)) {
 		for (i = 0; i < mt_slot_count(mte); i++) {
 			if (mas_get_slot(mas, i)) {
 				if (gap > max_gap)
@@ -6978,52 +6979,59 @@ static void mas_validate_gaps(struct ma_
 		goto counted;
 	}
 
-	gaps = ma_gaps(mte_to_node(mte), mte_node_type(mte));
+	gaps = ma_gaps(node, mt);
 	for (i = 0; i < mt_slot_count(mte); i++) {
-		p_end = mas_logical_pivot(mas, pivots, i, mte_node_type(mte));
+		p_end = mas_logical_pivot(mas, pivots, i, mt);
 
 		if (!gaps) {
-			if (mas_get_slot(mas, i)) {
-				gap = 0;
-				goto not_empty;
-			}
-
-			gap += p_end - p_start + 1;
+			if (!mas_get_slot(mas, i))
+				gap = p_end - p_start + 1;
 		} else {
 			void *entry = mas_get_slot(mas, i);
 
 			gap = gaps[i];
-			if (!entry) {
-				if (gap != p_end - p_start + 1) {
-					pr_err("%p[%u] -> %p %lu != %lu - %lu + 1\n",
-						mas_mn(mas), i,
-						mas_get_slot(mas, i), gap,
-						p_end, p_start);
-					mt_dump(mas->tree, mt_dump_hex);
-
-					MT_BUG_ON(mas->tree,
-						gap != p_end - p_start + 1);
-				}
-			} else {
-				if (gap > p_end - p_start + 1) {
-					pr_err("%p[%u] %lu >= %lu - %lu + 1 (%lu)\n",
-					mas_mn(mas), i, gap, p_end, p_start,
-					p_end - p_start + 1);
-					MT_BUG_ON(mas->tree,
-						gap > p_end - p_start + 1);
-				}
+			MT_BUG_ON(mas->tree, !entry);
+
+			if (gap > p_end - p_start + 1) {
+				pr_err("%p[%u] %lu >= %lu - %lu + 1 (%lu)\n",
+				       mas_mn(mas), i, gap, p_end, p_start,
+				       p_end - p_start + 1);
+				MT_BUG_ON(mas->tree, gap > p_end - p_start + 1);
 			}
 		}
 
 		if (gap > max_gap)
 			max_gap = gap;
-not_empty:
+
 		p_start = p_end + 1;
 		if (p_end >= mas->max)
 			break;
 	}
 
 counted:
+	if (mt == maple_arange_64) {
+		offset = ma_meta_gap(node, mt);
+		if (offset > i) {
+			pr_err("gap offset %p[%u] is invalid\n", node, offset);
+			MT_BUG_ON(mas->tree, 1);
+		}
+
+		if (gaps[offset] != max_gap) {
+			pr_err("gap %p[%u] is not the largest gap %lu\n",
+			       node, offset, max_gap);
+			MT_BUG_ON(mas->tree, 1);
+		}
+
+		MT_BUG_ON(mas->tree, !gaps);
+		for (i++ ; i < mt_slot_count(mte); i++) {
+			if (gaps[i] != 0) {
+				pr_err("gap %p[%u] beyond node limit != 0\n",
+				       node, i);
+				MT_BUG_ON(mas->tree, 1);
+			}
+		}
+	}
+
 	if (mte_is_root(mte))
 		return;
 
@@ -7033,10 +7041,8 @@ counted:
 	if (ma_gaps(p_mn, mas_parent_type(mas, mte))[p_slot] != max_gap) {
 		pr_err("gap %p[%u] != %lu\n", p_mn, p_slot, max_gap);
 		mt_dump(mas->tree, mt_dump_hex);
+		MT_BUG_ON(mas->tree, 1);
 	}
-
-	MT_BUG_ON(mas->tree,
-		  ma_gaps(p_mn, mas_parent_type(mas, mte))[p_slot] != max_gap);
 }
 
 static void mas_validate_parent_slot(struct ma_state *mas)
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


