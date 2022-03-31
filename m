Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E294DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 01:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352337AbiCaBql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352346AbiCaBql (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 21:46:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A0648886
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 18:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABF1B6192C
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 01:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7EFC340EC;
        Thu, 31 Mar 2022 01:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648691094;
        bh=DsyRBFPtM/lBf+ZS5jJ51H69Gql3P9D45gQP557Op3E=;
        h=Date:To:From:Subject:From;
        b=yN4gwVPuwF2Sxzv45529fWvh6dJdinaYvZz5Zt5x9+8ZPxDcF2ElxzqAhpzIake1h
         xxpdBMoWH9SudyXKsyEfnz1n+ySYQdunLNpg1rmULUVljiKlB5BPoIc5ov4gsoTkCn
         cl3eCkJw8s1VKH3ue0TT8EU5mPbK0VkQs109DxwY=
Date:   Wed, 30 Mar 2022 18:44:53 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        hannes@cmpxchg.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-move-generation-assignment-and-comparison-together.patch added to -mm tree
Message-Id: <20220331014454.0F7EFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: move generation assignment and comparison together
has been added to the -mm tree.  Its filename is
     mm-memcg-move-generation-assignment-and-comparison-together.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-move-generation-assignment-and-comparison-together.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-move-generation-assignment-and-comparison-together.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: move generation assignment and comparison together

For each round-trip, we assign generation on first invocation and compare
it on subsequent invocations.

Let's move them together to make it more self-explaining. Also this
reduce a check on prev.

[hannes@cmpxchg.org: better comment to explain reclaim model]
Link: https://lkml.kernel.org/r/20220330234719.18340-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-generation-assignment-and-comparison-together
+++ a/mm/memcontrol.c
@@ -1021,7 +1021,13 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
-		if (prev && reclaim->generation != iter->generation)
+		/*
+		 * On start, join the current reclaim iteration cycle.
+		 * Exit when a concurrent walker completes it.
+		 */
+		if (!prev)
+			reclaim->generation = iter->generation;
+		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
 		while (1) {
@@ -1083,8 +1089,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 		if (!memcg)
 			iter->generation++;
-		else if (!prev)
-			reclaim->generation = iter->generation;
 	}
 
 out_unlock:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

