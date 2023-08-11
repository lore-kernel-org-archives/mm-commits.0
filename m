Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B935C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237190AbjHKXNa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbjHKXNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9CA4692
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F054365772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B6AC433C8;
        Fri, 11 Aug 2023 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794966;
        bh=FrzjFMVLxqx6ZQcklho4Rv2s6iAr7ibHAvmsQwOTO7A=;
        h=Date:To:From:Subject:From;
        b=VhW7rVAqj49y2R7DxLDYd2ggJ52GKCiQgQelFXCr749gV0nZ1/sI6Sx80AWLT1I6U
         +dDGel6uCeyzPWH5mTZDSqAAyFD/Cry9zBxfQ1LsVBhYwXfn/GnsEFKzrgOpMpUU5V
         qCiIGTdB+kgLHCnuNFswij/th+CEp94jjd6ozLDQ=
Date:   Fri, 11 Aug 2023 16:02:45 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-adjust-node-allocation-on-mas_rebalance.patch removed from -mm tree
Message-Id: <20230811230246.51B6AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: adjust node allocation on mas_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-adjust-node-allocation-on-mas_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: adjust node allocation on mas_rebalance()
Date: Mon, 24 Jul 2023 14:31:50 -0400

mas_rebalance() is called to rebalance an insufficient node into a
single node or two sufficient nodes.  The preallocation estimate is
always too many in this case as the height of the tree will never grow
and there is no possibility to have a three way split in this case, so
revise the node allocation count.

Link: https://lkml.kernel.org/r/20230724183157.3939892-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-adjust-node-allocation-on-mas_rebalance
+++ a/lib/maple_tree.c
@@ -3136,7 +3136,7 @@ static inline int mas_rebalance(struct m
 	 * tries to combine the data in the same way.  If one node contains the
 	 * entire range of the tree, then that node is used as a new root node.
 	 */
-	mas_node_count(mas, 1 + empty_count * 3);
+	mas_node_count(mas, empty_count * 2 - 1);
 	if (mas_is_err(mas))
 		return 0;
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

