Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27ADCC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Mar 2022 21:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiCUVGe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Mar 2022 17:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiCUVGd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2022 17:06:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF964326D5
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 14:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F2861248
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 21:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8B8C340E8;
        Mon, 21 Mar 2022 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647896706;
        bh=kL3bynOSYGzyKK5bpaiMMOGySh+7eWaGvRzm3IzDAXo=;
        h=Date:To:From:Subject:From;
        b=leGlC6wcb1JWVyj7nH1K6bZ8hNlR1AaWnMvuUkU5IJ+FlzJm+uwHJ+fBsex4SEExQ
         B/m5kg9NKmiuie+QDiH1OjUQxchGJLucnrgZ43iVZrwYv45m3tGcQeHlqTtW2ohlNx
         KdAJzf3DYWHpUqTAe+QXRD6MJ7MfNf2GZ7KB0ENE=
Date:   Mon, 21 Mar 2022 14:05:06 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-memcg-move-generation-assignment-and-comparison-together.patch removed from -mm tree
Message-Id: <20220321210506.8F8B8C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: move generation assignment and comparison together
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-generation-assignment-and-comparison-together.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: move generation assignment and comparison together

For each round-trip, we assign generation on first invocation and compare
it on subsequent invocations.

Let's move them together to make it more self-explaining.  Also this
reduces a check on prev.

Link: https://lkml.kernel.org/r/20220225003437.12620-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-generation-assignment-and-comparison-together
+++ a/mm/memcontrol.c
@@ -1006,7 +1006,14 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
-		if (prev && reclaim->generation != iter->generation)
+		/*
+		 * On first invocation, assign iter->generation to
+		 * reclaim->generation.
+		 * On subsequent invocations, make sure no one else jump in.
+		 */
+		if (!prev)
+			reclaim->generation = iter->generation;
+		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
 		while (1) {
@@ -1066,8 +1073,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 		if (!memcg)
 			iter->generation++;
-		else if (!prev)
-			reclaim->generation = iter->generation;
 	}
 
 out_unlock:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

