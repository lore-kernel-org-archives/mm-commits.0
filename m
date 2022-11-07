Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647AEC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 20:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKGUGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 15:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiKGUGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 15:06:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C1E2A43B
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 12:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D1E61182
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 20:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06864C433D6;
        Mon,  7 Nov 2022 20:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667851579;
        bh=e9z9so9Kntn9qpGvCuW7g3uklI0F0Rk1nVKxwWWihWM=;
        h=Date:To:From:Subject:From;
        b=cJCVO+nHAElbkoogD/rLIPHMR3SXt/GN/devm/DTlAU77/zUkEaJFOaTsEwaA5yuc
         gzi/QqsqEF5cYW25ZMk7wfHeRgZNveKCjNtG3MyqXIIjWbjQ5k43q4+0AhJ051gCon
         pLjF50aYvBmdZgoQhhrILQDCodR20qhXxcU6+P/8=
Date:   Mon, 07 Nov 2022 12:06:18 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20221107200619.06864C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: don't set a new maximum on the node when not reusing nodes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: don't set a new maximum on the node when not reusing nodes
Date: Mon, 7 Nov 2022 16:39:02 +0000

In RCU mode, the node limits were being updated to the last pivot which
may not be correct and would cause the metadata to be set when it
shouldn't.  Fix this by not setting a new limit in this case.

Link: https://lkml.kernel.org/r/20221107163857.867377-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes
+++ a/lib/maple_tree.c
@@ -3603,8 +3603,7 @@ static inline int mas_commit_b_node(stru
 	node = mas_pop_node(wr_mas->mas);
 	node->parent = mas_mn(wr_mas->mas)->parent;
 	wr_mas->mas->node = mt_mk_node(node, b_type);
-	mab_mas_cp(b_node, 0, b_end, wr_mas->mas, true);
-
+	mab_mas_cp(b_node, 0, b_end, wr_mas->mas, false);
 	mas_replace(wr_mas->mas, false);
 reuse_node:
 	mas_update_gap(wr_mas->mas);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch
maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch
maple_tree-reorganize-testing-to-restore-module-testing.patch
maple_tree-fix-depth-tracking-in-maple_state.patch
maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

