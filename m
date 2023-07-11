Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08E3C001B0
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjGKTOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjGKTOV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FE5EA
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 001A5615CD
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503A5C433C8;
        Tue, 11 Jul 2023 19:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102859;
        bh=Co/0RROED7zHvD+KVGbRpqDnX8JoaDWlk+0ve5kvRj0=;
        h=Date:To:From:Subject:From;
        b=vXIJ9Jdd1k+z2liHTOdDLyia19p4jexOC+UW4suSMh0if9/rv/OxjPYN3Hg15VIAE
         fiNqY3El+5JZl94iDyjbaybk4uR30103hvYtAMJjgC8VRMrRTsZpKFrM8NL5FOpNKw
         lApn5fqUnuQDQEmRnPVW4CUeDVbg8OKtQu5nylu4=
Date:   Tue, 11 Jul 2023 12:14:18 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-make-mas_validate_gaps-to-check-metadata.patch added to mm-unstable branch
Message-Id: <20230711191419.503A5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: make mas_validate_gaps() to check metadata
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-make-mas_validate_gaps-to-check-metadata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-make-mas_validate_gaps-to-check-metadata.patch

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
Subject: maple_tree: make mas_validate_gaps() to check metadata
Date: Tue, 11 Jul 2023 11:54:39 +0800

Make mas_validate_gaps() check whether the offset in the metadata points
to the largest gap.  By the way, simplify this function.

Add the verification that gaps beyond the node limit are zero.

Link: https://lkml.kernel.org/r/20230711035444.526-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
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

