Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE276C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjJYXhx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjJYXhw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:37:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167A013A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:37:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FE9C433C7;
        Wed, 25 Oct 2023 23:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277070;
        bh=k/VjVJ+QV5fcIpJt7dQ8LHx4xDUZK5Jz91PL/YjTTkk=;
        h=Date:To:From:Subject:From;
        b=LGbfJF6CLY4BNjDiPKGTQI9gqua49eTUIbi0jP/McwHhY05QwEIUE0iPlgKmAl6wv
         ee8mGgkeN8TkbvKZ3uJBY3OyYIKbxJS4skozN5WhNmV9UCIafGRx/b1kktNBm5N9vu
         KiNZkAK/THKtnYFhUBFEBDBHH72Szn6dBEXq9xds=
Date:   Wed, 25 Oct 2023 16:37:50 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, rppt@kernel.org,
        osalvador@suse.de, mingo@kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-skip-memoryless-nodes-entirely-v4.patch removed from -mm tree
Message-Id: <20231025233750.A1FE9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: skip memoryless nodes entirely
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-memoryless-nodes-entirely-v4.patch

This patch was dropped because it was folded into mm-page_alloc-skip-memoryless-nodes-entirely.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: page_alloc: skip memoryless nodes entirely
Date: Fri, 20 Oct 2023 19:04:45 +0800

update comment, per Ingo

Link: https://lkml.kernel.org/r/7300fc00a057eefeb9a68c8ad28171c3f0ce66ce.1697799303.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-memoryless-nodes-entirely-v4
+++ a/mm/page_alloc.c
@@ -5053,8 +5053,8 @@ int find_next_best_node(int node, nodema
 	int best_node = NUMA_NO_NODE;
 
 	/*
-	 * Use the local node if we haven't already. But for memoryless local
-	 * node, we should skip it and fallback to other nodes.
+	 * Use the local node if we haven't already, but for memoryless local
+	 * node, we should skip it and fall back to other nodes.
 	 */
 	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
 		node_set(node, *used_node_mask);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-page_alloc-skip-memoryless-nodes-entirely.patch
mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

