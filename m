Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4E6C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbjJYXu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbjJYXtP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3F410D5
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9628CC433C7;
        Wed, 25 Oct 2023 23:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277740;
        bh=3Gijs/OWgyn1D+fO2+mOJ5JRCO96ppMqLZhQRGcWzEc=;
        h=Date:To:From:Subject:From;
        b=HBubiHRLLDsS4LbG587bm/OPsTr4wF3wGynHQvsD9B0wzM1WyyaY4J8X2OgQf2J3Z
         JwG/YWDoySYftEL2qPE7aTSGtXpcOpHrjSiS1JkbnEPjxaYFXsNNlJEm37pAavagFM
         DXzMF6QYdI3nY7ZulHOCqTAvPMKbSUWaHYSXUamU=
Date:   Wed, 25 Oct 2023 16:49:00 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, rppt@kernel.org,
        osalvador@suse.de, mingo@kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-skip-memoryless-nodes-entirely.patch removed from -mm tree
Message-Id: <20231025234900.9628CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: skip memoryless nodes entirely
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-memoryless-nodes-entirely.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: page_alloc: skip memoryless nodes entirely
Date: Thu, 19 Oct 2023 18:43:54 +0800

Patch series "handle memoryless nodes more appropriately", v3.

Currently, in the process of initialization or offline memory, memoryless
nodes will still be built into the fallback list of itself or other nodes.

This is not what we expected, so this patch series removes memoryless
nodes from the fallback list entirely.


This patch (of 2):

In find_next_best_node(), we skipped the memoryless nodes when building
the zonelists of other normal nodes (N_NORMAL), but did not skip the
memoryless node itself when building the zonelist.  This will cause it to
be traversed at runtime.

For example, say we have node0 and node1, node0 is memoryless
node, then the fallback order of node0 and node1 as follows:

[    0.153005] Fallback order for Node 0: 0 1
[    0.153564] Fallback order for Node 1: 1

After this patch, we skip memoryless node0 entirely, then
the fallback order of node0 and node1 as follows:

[    0.155236] Fallback order for Node 0: 1
[    0.155806] Fallback order for Node 1: 1

So it becomes completely invisible, which will reduce runtime
overhead.

And in this way, we will not try to allocate pages from memoryless node0,
then the panic mentioned in [1] will also be fixed.  Even though this
problem has been solved by dropping the NODE_MIN_SIZE constrain in x86
[2], it would be better to fix it in core MM as well.

[1]. https://lore.kernel.org/all/20230212110305.93670-1-zhengqi.arch@bytedance.com/
[2]. https://lore.kernel.org/all/20231017062215.171670-1-rppt@kernel.org/

[zhengqi.arch@bytedance.com: update comment, per Ingo]
  Link: https://lkml.kernel.org/r/7300fc00a057eefeb9a68c8ad28171c3f0ce66ce.1697799303.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/cover.1697799303.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/cover.1697711415.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/157013e978468241de4a4c05d5337a44638ecb0e.1697711415.git.zhengqi.arch@bytedance.com
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

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-memoryless-nodes-entirely
+++ a/mm/page_alloc.c
@@ -5020,8 +5020,11 @@ int find_next_best_node(int node, nodema
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
 
-	/* Use the local node if we haven't already */
-	if (!node_isset(node, *used_node_mask)) {
+	/*
+	 * Use the local node if we haven't already, but for memoryless local
+	 * node, we should skip it and fall back to other nodes.
+	 */
+	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
 		node_set(node, *used_node_mask);
 		return node;
 	}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


