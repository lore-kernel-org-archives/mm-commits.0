Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D77EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjGKTO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjGKTO1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC2D1710
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C779614AE
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12FEC433C8;
        Tue, 11 Jul 2023 19:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102864;
        bh=wu1uXMhXUVilJ5JwIUDL5AGWUgta/pr3qmzqApv0k7A=;
        h=Date:To:From:Subject:From;
        b=K8B37Sj6CbQ+eg2ScFLUyjU8jTxnlC9Ex+dWiihREOud0/Iw4eJNpRkpTKcYuRZdE
         jeGnjDz7MXAx8LyIsP1aUbnL2GpZk7KCZYl9GnJMM7AexBHLdpCE8/ffq8Z4bCigqP
         2FtTwxcR++cw/u2Kz0sN81rt87cAl1rkUJ/fcNhI=
Date:   Tue, 11 Jul 2023 12:14:24 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-mt_validate.patch added to mm-unstable branch
Message-Id: <20230711191424.B12FEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: update mt_validate()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-update-mt_validate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-mt_validate.patch

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
Subject: maple_tree: update mt_validate()
Date: Tue, 11 Jul 2023 11:54:42 +0800

Instead of using mas_first_entry() to find the leftmost leaf, use a simple
loop instead.  Remove an unneeded check for root node.  To make the error
message more accurate, check pivots first and then slots, because checking
slots depend on the node limit pivot to break the loop.

Link: https://lkml.kernel.org/r/20230711035444.526-7-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-update-mt_validate
+++ a/lib/maple_tree.c
@@ -7244,21 +7244,20 @@ void mt_validate(struct maple_tree *mt)
 	if (!mas_searchable(&mas))
 		goto done;
 
-	mas_first_entry(&mas, mas_mn(&mas), ULONG_MAX, mte_node_type(mas.node));
+	while (!mte_is_leaf(mas.node))
+		mas_descend(&mas);
+
 	while (!mas_is_none(&mas)) {
 		MAS_WARN_ON(&mas, mte_dead_node(mas.node));
-		if (!mte_is_root(mas.node)) {
-			end = mas_data_end(&mas);
-			if (MAS_WARN_ON(&mas,
-					(end < mt_min_slot_count(mas.node)) &&
-					(mas.max != ULONG_MAX))) {
-				pr_err("Invalid size %u of %p\n", end,
-				       mas_mn(&mas));
-			}
+		end = mas_data_end(&mas);
+		if (MAS_WARN_ON(&mas, (end < mt_min_slot_count(mas.node)) &&
+				(mas.max != ULONG_MAX))) {
+			pr_err("Invalid size %u of %p\n", end, mas_mn(&mas));
 		}
+
 		mas_validate_parent_slot(&mas);
-		mas_validate_child_slot(&mas);
 		mas_validate_limits(&mas);
+		mas_validate_child_slot(&mas);
 		if (mt_is_alloc(mt))
 			mas_validate_gaps(&mas);
 		mas_dfs_postorder(&mas, ULONG_MAX);
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

