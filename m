Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1ABEB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjGKTO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjGKTOY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F85EA
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0B9615D1
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2271C433C8;
        Tue, 11 Jul 2023 19:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102863;
        bh=N8edoGUZMZYb7uB0MqefdhnHO4VIuTDYN9JyCFN4UiI=;
        h=Date:To:From:Subject:From;
        b=UMca7dZKweBzZzGCzlbUu7c31y/w6OGBgkjbccVOT+3nnYO1s6ytiuzbdlptzfLBI
         rlrM+as5GF2Fojz4QDgvOeT47f4rgkA4snuo2papQcH9w2M/RWsvhmbgp3SwGv/J7z
         EEHNeTPu/zW5GCXlx2lyQ90a3ycskQU0btC8uhlM=
Date:   Tue, 11 Jul 2023 12:14:22 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch added to mm-unstable branch
Message-Id: <20230711191422.E2271C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: make mas_validate_limits() check root node and node limit
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch

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
Subject: maple_tree: make mas_validate_limits() check root node and node limit
Date: Tue, 11 Jul 2023 11:54:41 +0800

Update mas_validate_limits() to check root node, check node limit pivot if
there is enough room for it to exist and check data_end.  Remove the check
for child existence as it is done in mas_validate_child_slot().

Link: https://lkml.kernel.org/r/20230711035444.526-6-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-mas_validate_limits-check-root-node-and-node-limit
+++ a/lib/maple_tree.c
@@ -7120,7 +7120,9 @@ static void mas_validate_child_slot(stru
 }
 
 /*
- * Validate all pivots are within mas->min and mas->max.
+ * Validate all pivots are within mas->min and mas->max, check metadata ends
+ * where the maximum ends and ensure there is no slots or pivots set outside of
+ * the end of the data.
  */
 static void mas_validate_limits(struct ma_state *mas)
 {
@@ -7130,26 +7132,15 @@ static void mas_validate_limits(struct m
 	void __rcu **slots = ma_slots(mte_to_node(mas->node), type);
 	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
 
-	/* all limits are fine here. */
-	if (mte_is_root(mas->node))
-		return;
-
 	for (i = 0; i < mt_slots[type]; i++) {
 		unsigned long piv;
 
 		piv = mas_safe_pivot(mas, pivots, i, type);
 
-		if (!piv && (i != 0))
-			break;
-
-		if (!mte_is_leaf(mas->node)) {
-			void *entry = mas_slot(mas, slots, i);
-
-			if (!entry)
-				pr_err("%p[%u] cannot be null\n",
-				       mas_mn(mas), i);
-
-			MT_BUG_ON(mas->tree, !entry);
+		if (!piv && (i != 0)) {
+			pr_err("Missing node limit pivot at %p[%u]",
+			       mas_mn(mas), i);
+			MAS_WARN_ON(mas, 1);
 		}
 
 		if (prev_piv > piv) {
@@ -7172,6 +7163,13 @@ static void mas_validate_limits(struct m
 		if (piv == mas->max)
 			break;
 	}
+
+	if (mas_data_end(mas) != i) {
+		pr_err("node%p: data_end %u != the last slot offset %u\n",
+		       mas_mn(mas), mas_data_end(mas), i);
+		MT_BUG_ON(mas->tree, 1);
+	}
+
 	for (i += 1; i < mt_slots[type]; i++) {
 		void *entry = mas_slot(mas, slots, i);
 
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

