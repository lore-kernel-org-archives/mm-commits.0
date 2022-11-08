Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189E9C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiKHX7S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiKHX6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76CDB7DC
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21205617EA
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB66C433D7;
        Tue,  8 Nov 2022 23:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951907;
        bh=etmIW+8e2VZ5KvTe5VOaq3OPMJV0F65w4Cb8yBnOBAQ=;
        h=Date:To:From:Subject:From;
        b=DQDqf/Ta7BnTDv2m1bzpaZZl3Gw8UwFQQBbwm1aZ2FYq6NPlU/XkqfP3rRzyMUtsD
         dlfde9/HdmsktYoo7VZx7l35PoLEoWEXmF8zFnfBEQy/3UbMfRRVFgnDIQd20bHbeO
         IfyWtRQYdYtcwx5pMGVXJ3MgLDuFs93CZQh1DaW8=
Date:   Tue, 08 Nov 2022 15:58:27 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-depth-tracking-in-maple_state.patch removed from -mm tree
Message-Id: <20221108235827.7CB66C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix depth tracking in maple_state
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-depth-tracking-in-maple_state.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

