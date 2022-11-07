Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6044EC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 20:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiKGUGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 15:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiKGUGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 15:06:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB8521829
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 12:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2870AB810B3
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 20:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27FEC433D6;
        Mon,  7 Nov 2022 20:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667851576;
        bh=Nxwx0us/G2lGai1FRmp7UYuL3aUDGEDwUImXnnZXDv4=;
        h=Date:To:From:Subject:From;
        b=AeCj6FhiN+4xxpBgHXpjHiDpNkGJPfl01ABc349gMCGANuef4XnVd//Gl6X6LOeqV
         l5NKVstmXFfQqdUdqg9rogSOFioyGboB0Y/XMEQrewg67kp8jJF3EJBFeRe3iVYI6o
         voyTtJZgkw4Yj9XOmAVwQLS3vLS1+7yZOO5Efk8M=
Date:   Mon, 07 Nov 2022 12:06:14 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-depth-tracking-in-maple_state.patch added to mm-hotfixes-unstable branch
Message-Id: <20221107200616.C27FEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix depth tracking in maple_state
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-depth-tracking-in-maple_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-depth-tracking-in-maple_state.patch

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
Subject: maple_tree: fix depth tracking in maple_state
Date: Mon, 7 Nov 2022 16:38:35 +0000

It is possible to confuse the depth tracking in the maple state by
searching the same node for values.  Fix the depth tracking by moving
where the depth is incremented closer to where the node changes level. 
Also change the initial depth setting when using the root node.

Link: https://lkml.kernel.org/r/20221107163814.866612-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-depth-tracking-in-maple_state
+++ a/lib/maple_tree.c
@@ -1351,6 +1351,7 @@ static inline struct maple_enode *mas_st
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
+			mas->depth = 1;
 			mas->node = mte_safe_root(root);
 			return NULL;
 		}
@@ -3727,7 +3728,6 @@ static bool mas_is_span_wr(struct ma_wr_
 
 static inline void mas_wr_walk_descend(struct ma_wr_state *wr_mas)
 {
-	wr_mas->mas->depth++;
 	wr_mas->type = mte_node_type(wr_mas->mas->node);
 	mas_wr_node_walk(wr_mas);
 	wr_mas->slots = ma_slots(wr_mas->node, wr_mas->type);
@@ -3739,6 +3739,7 @@ static inline void mas_wr_walk_traverse(
 	wr_mas->mas->min = wr_mas->r_min;
 	wr_mas->mas->node = wr_mas->content;
 	wr_mas->mas->offset = 0;
+	wr_mas->mas->depth++;
 }
 /*
  * mas_wr_walk() - Walk the tree for a write.
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

