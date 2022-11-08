Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F072C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiKHX70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiKHX6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FE91147E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6775B81CC6
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8357BC433D6;
        Tue,  8 Nov 2022 23:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951908;
        bh=+xUBuoXH3ccGwhmjddKPUgVlFSAxDs1e3ss2n74uLRI=;
        h=Date:To:From:Subject:From;
        b=joDgxPL2dNDJ8CEW6puhlJLff8CBiTPr9dFQnT1NMdCK1ci/rsCUVuqNtPb0kYt1P
         klu2hXcvnq0lnPUAAMBDw4vRt6B+npG69ZPxioYxwcWnyXm0KXE384/TK0jdy2ArkW
         t2Qy7VnDINCy9r62s7ZoO1DDjM2EGbIARl0j3AXU=
Date:   Tue, 08 Nov 2022 15:58:28 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch removed from -mm tree
Message-Id: <20221108235828.8357BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: don't set a new maximum on the node when not reusing nodes
has been removed from the -mm tree.  Its filename was
     maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

