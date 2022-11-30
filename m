Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349FCC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 22:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiK3WrQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiK3WrQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 17:47:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32178DBDD
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 14:47:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5B6061E1C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 22:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3245BC433D6;
        Wed, 30 Nov 2022 22:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848434;
        bh=/Y9lLeEZer9R/Kv7DW3URBmraLfZR+EM0wFY59w/W4E=;
        h=Date:To:From:Subject:From;
        b=qS/qDw8HW+/MZyolvhHYT6oRInqblaJ4+c7AdrfjCjyzychfzU7KlE5ck5x7Iq04D
         o2IAmnKIgOYrYn4s+4Di2u9Lc5rrD8i22stnubjncesKkEycnm2Bfb2wBZn88XRBxs
         5YEpjjpNQQN8rJ3F+g72SlOiAculV1rfuZh5Ek7E=
Date:   Wed, 30 Nov 2022 14:47:13 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com, mhocko@suse.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch removed from -mm tree
Message-Id: <20221130224714.3245BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: replace VM_WARN_ON to pr_warn if the node is offline with __GFP_THISNODE
has been removed from the -mm tree.  Its filename was
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch

This patch was dropped because it was folded into mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: replace VM_WARN_ON to pr_warn if the node is offline with __GFP_THISNODE
Date: Wed, 23 Nov 2022 11:30:14 -0800

renamed nid to this_node and gfp to warn_gfp to make the code more
readable per Michal.

Link: https://lkml.kernel.org/r/20221123193014.153983-1-shy828301@gmail.com
Reported-by: syzbot+0044b22d177870ee974f@syzkaller.appspotmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/gfp.h~mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4
+++ a/include/linux/gfp.h
@@ -210,14 +210,18 @@ alloc_pages_bulk_array_node(gfp_t gfp, i
 	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
 }
 
-static inline void warn_if_node_offline(int nid, gfp_t gfp_mask)
+static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 {
-	gfp_t gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
+	gfp_t warn_gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
 
-	if ((gfp == (__GFP_THISNODE|__GFP_NOWARN)) && !node_online(nid)) {
-		pr_warn("%pGg allocation from offline node %d\n", &gfp, nid);
-		dump_stack();
-	}
+	if (warn_gfp != (__GFP_THISNODE|__GFP_NOWARN))
+		return;
+
+	if(node_online(this_node))
+		return;
+
+	pr_warn("%pGg allocation from offline node %d\n", &warn_gfp, this_node);
+	dump_stack();
 }
 
 /*
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

