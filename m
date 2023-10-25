Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8A5C25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbjJYXub (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbjJYXtQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF96110D9
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5402C433C8;
        Wed, 25 Oct 2023 23:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277741;
        bh=jIrfE5yJ4dQwQM2Q+iRAEk2ZqDpU7GF7L8xibDxWSk8=;
        h=Date:To:From:Subject:From;
        b=Ud4Docr9gTWvOc0sc6Gz1/yj85AkzxpReiGZ7bBoZbuVZLVpfDYbYRu/zbZfR33ee
         kzGiusSvIkF55CrLHlnPQtOYbd65j4EmGqI0dmqXRbkffHSeuFsBXd71N7q7Lwm6Dv
         2CzBEQ14Af8tYQhlJyHOzl981xG3vBTNTxPwanOA=
Date:   Wed, 25 Oct 2023 16:49:01 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, rppt@kernel.org,
        osalvador@suse.de, mingo@kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch removed from -mm tree
Message-Id: <20231025234901.B5402C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory_hotplug: drop memoryless node from fallback lists
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memory_hotplug: drop memoryless node from fallback lists
Date: Thu, 19 Oct 2023 18:43:55 +0800

In offline_pages(), if a node becomes memoryless, we will clear its
N_MEMORY state by calling node_states_clear_node().  But we do this
after rebuilding the zonelists by calling build_all_zonelists(), which
will cause this memoryless node to still be in the fallback nodes
(node_order[]) of other nodes.

To drop memoryless nodes from fallback nodes in this case, just call
node_states_clear_node() before calling build_all_zonelists().

In this way, we will not try to allocate pages from memoryless node0,
then the panic mentioned in [1] will also be fixed.  Even though this
problem has been solved by dropping the NODE_MIN_SIZE constrain in x86
[2], it would be better to fix it in the core MM as well.

https://lore.kernel.org/all/20230212110305.93670-1-zhengqi.arch@bytedance.com/ [1]
https://lore.kernel.org/all/20231017062215.171670-1-rppt@kernel.org/ [2]

Link: https://lkml.kernel.org/r/9f1dbe7ee1301c7163b2770e32954ff5e3ecf2c4.1697711415.git.zhengqi.arch@bytedance.com
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

 mm/memory_hotplug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-memoryless-node-from-fallback-lists
+++ a/mm/memory_hotplug.c
@@ -2012,12 +2012,16 @@ int __ref offline_pages(unsigned long st
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
+	/*
+	 * Make sure to mark the node as memory-less before rebuilding the zone
+	 * list. Otherwise this node would still appear in the fallback lists.
+	 */
+	node_states_clear_node(node, &arg);
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
 	}
 
-	node_states_clear_node(node, &arg);
 	if (arg.status_change_nid >= 0) {
 		kcompactd_stop(node);
 		kswapd_stop(node);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


