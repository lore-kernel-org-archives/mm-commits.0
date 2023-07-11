Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F21C001DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjGKTOa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjGKTO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60991711
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29A17615DC
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC62C433C9;
        Tue, 11 Jul 2023 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102866;
        bh=gyLiTVA6c/QexrccOdP5EiOlE+XqL0bGJsPO7J3+4Dk=;
        h=Date:To:From:Subject:From;
        b=Z9kzVi5xHxtzUmtpBvRn74ONddtfNflOFbt7bSvVUEgkmfMCJoLKLhh68LaHIbJJI
         zLSFUrsyXfoiQL8oRTnNNNsJbnNwRZ4GVkVs2B0LVXMNasYn2Yrq/9afjQrex3pf2o
         YymoMVG7aQsbQ4I2gAL1rPJA/2ha8AWOVP2t5eiA=
Date:   Tue, 11 Jul 2023 12:14:25 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot.patch added to mm-unstable branch
Message-Id: <20230711191426.7AC62C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: replace mas_logical_pivot() with mas_safe_pivot()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot.patch

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
Subject: maple_tree: replace mas_logical_pivot() with mas_safe_pivot()
Date: Tue, 11 Jul 2023 11:54:43 +0800

Replace mas_logical_pivot() with mas_safe_pivot() and drop
mas_logical_pivot() since it won't be used anymore.  We can do this since
now all nodes will have node limit pivot (if it is not full node).

Link: https://lkml.kernel.org/r/20230711035444.526-8-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

--- a/lib/maple_tree.c~maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot
+++ a/lib/maple_tree.c
@@ -729,33 +729,6 @@ mas_safe_min(struct ma_state *mas, unsig
 }
 
 /*
- * mas_logical_pivot() - Get the logical pivot of a given offset.
- * @mas: The maple state
- * @pivots: The pointer to the maple node pivots
- * @offset: The offset into the pivot array
- * @type: The maple node type
- *
- * When there is no value at a pivot (beyond the end of the data), then the
- * pivot is actually @mas->max.
- *
- * Return: the logical pivot of a given @offset.
- */
-static inline unsigned long
-mas_logical_pivot(struct ma_state *mas, unsigned long *pivots,
-		  unsigned char offset, enum maple_type type)
-{
-	unsigned long lpiv = mas_safe_pivot(mas, pivots, offset, type);
-
-	if (likely(lpiv))
-		return lpiv;
-
-	if (likely(offset))
-		return mas->max;
-
-	return lpiv;
-}
-
-/*
  * mte_set_pivot() - Set a pivot to a value in an encoded maple node.
  * @mn: The encoded maple node
  * @piv: The pivot offset
@@ -2202,7 +2175,7 @@ static noinline_for_kasan void mas_store
 		goto b_end;
 
 	/* Handle new range ending before old range ends */
-	piv = mas_logical_pivot(mas, wr_mas->pivots, offset_end, wr_mas->type);
+	piv = mas_safe_pivot(mas, wr_mas->pivots, offset_end, wr_mas->type);
 	if (piv > mas->last) {
 		if (piv == ULONG_MAX)
 			mas_bulk_rebalance(mas, b_node->b_end, wr_mas->type);
@@ -4935,7 +4908,7 @@ static inline bool mas_anode_descend(str
 	min = mas_safe_min(mas, pivots, offset);
 	data_end = ma_data_end(node, type, pivots, mas->max);
 	for (; offset <= data_end; offset++) {
-		pivot = mas_logical_pivot(mas, pivots, offset, type);
+		pivot = mas_safe_pivot(mas, pivots, offset, type);
 
 		/* Not within lower bounds */
 		if (mas->index > pivot)
@@ -6981,7 +6954,7 @@ static void mas_validate_gaps(struct ma_
 
 	gaps = ma_gaps(node, mt);
 	for (i = 0; i < mt_slot_count(mte); i++) {
-		p_end = mas_logical_pivot(mas, pivots, i, mt);
+		p_end = mas_safe_pivot(mas, pivots, i, mt);
 
 		if (!gaps) {
 			if (!mas_get_slot(mas, i))
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

