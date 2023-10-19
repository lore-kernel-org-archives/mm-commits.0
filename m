Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDAFCDB483
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 16:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjJSQ1i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQ1h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2023 12:27:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B9D9B
        for <mm-commits@vger.kernel.org>; Thu, 19 Oct 2023 09:27:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E31AC433C8;
        Thu, 19 Oct 2023 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697732855;
        bh=QvC5COQhXBk4OZjzZRM2VWKSIRQcA10oQmbsrPQKbQ0=;
        h=Date:To:From:Subject:From;
        b=loCAtEaR1KQ5qlCB7MqgLASolQU+PPr1JpYU/XGW3K3TWTZT0NEBjPMogIk2c8mM+
         fk68eyLQSZs/oRprXEOHo3iL9pKBg7JERnDz0jZJRduSZ8KELr3EE+/ei+LrXzJUqb
         KzhsfrkXt3vDOQRLvYC+DKjpClNw7Uyuo+WTHxz0=
Date:   Thu, 19 Oct 2023 09:27:34 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, rppt@kernel.org,
        osalvador@suse.de, mingo@kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-skip-memoryless-nodes-entirely.patch added to mm-unstable branch
Message-Id: <20231019162735.5E31AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: skip memoryless nodes entirely
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-skip-memoryless-nodes-entirely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-skip-memoryless-nodes-entirely.patch

This patch will later appear in the mm-unstable branch at
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

Link: https://lkml.kernel.org/r/cover.1697711415.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/157013e978468241de4a4c05d5337a44638ecb0e.1697711415.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
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
@@ -5052,8 +5052,11 @@ int find_next_best_node(int node, nodema
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
 
-	/* Use the local node if we haven't already */
-	if (!node_isset(node, *used_node_mask)) {
+	/*
+	 * Use the local node if we haven't already. But for memoryless local
+	 * node, we should skip it and fallback to other nodes.
+	 */
+	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
 		node_set(node, *used_node_mask);
 		return node;
 	}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-page_alloc-skip-memoryless-nodes-entirely.patch
mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

