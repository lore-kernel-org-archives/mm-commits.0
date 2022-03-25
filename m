Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E98EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356334AbiCYBfE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357365AbiCYBdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678FC3DA66
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18EDCB82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB649C340ED;
        Fri, 25 Mar 2022 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171937;
        bh=7Uees5Qr4/e5SzPArRidgqC6gK1CvOrY5Ft02nG9JSU=;
        h=Date:To:From:Subject:From;
        b=EdwffoqokjJAvrTQ3VCnnL7LbHkXYGKpEHwTVfiPH7WhWGzOuUzdHxfRqxwoW92gm
         vCU79C9Z+U0UN2r8Rb54BljpMI3ypuC4ae8uoVo2PvVLBZ2mtEBKp8HlZyRCnWwlBe
         jSLPjZDO3xJl/+Fq4lIlG5qNRrl7ItGWu47c62wA=
Date:   Thu, 24 Mar 2022 18:32:17 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, xlpang@linux.alibaba.com,
        shy828301@gmail.com, osalvador@suse.de,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mmmigrate-fix-establishing-demotion-target.patch removed from -mm tree
Message-Id: <20220325013217.AB649C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,migrate: fix establishing demotion target
has been removed from the -mm tree.  Its filename was
     mmmigrate-fix-establishing-demotion-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,migrate: fix establishing demotion target

In commit ac16ec835314 ("mm: migrate: support multiple target nodes
demotion"), after the first demotion target node is found, we will
continue to check the next candidate obtained via find_next_best_node(). 
This is to find all demotion target nodes with same NUMA distance.  But
one side effect of find_next_best_node() is that the candidate node
returned will be set in "used" parameter, even if the candidate node isn't
passed in the following NUMA distance checking, the candidate node will
not be used as demotion target node for the following nodes.  For example,
for system as follows,

node distances:
node   0   1   2   3
  0:  10  21  17  28
  1:  21  10  28  17
  2:  17  28  10  28
  3:  28  17  28  10

when we establish demotion target node for node 0, in the first round node
2 is added to the demotion target node set.  Then in the second round,
node 3 is checked and failed because distance(0, 3) > distance(0, 2).  But
node 3 is set in "used" nodemask too.  When we establish demotion target
node for node 1, there is no available node.  This is wrong, node 3 should
be set as the demotion target of node 1.

To fix this, if the candidate node is failed to pass the distance
checking, it will be cleared in "used" nodemask.  So that it can be used
for the following node.

The bug can be reproduced and fixed with this patch on a 2 socket server
machine with DRAM and PMEM.

Link: https://lkml.kernel.org/r/20220128055940.1792614-1-ying.huang@intel.com
Fixes: ac16ec835314 ("mm: migrate: support multiple target nodes demotion")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mmmigrate-fix-establishing-demotion-target
+++ a/mm/migrate.c
@@ -3079,18 +3079,21 @@ static int establish_migrate_target(int
 	if (best_distance != -1) {
 		val = node_distance(node, migration_target);
 		if (val > best_distance)
-			return NUMA_NO_NODE;
+			goto out_clear;
 	}
 
 	index = nd->nr;
 	if (WARN_ONCE(index >= DEMOTION_TARGET_NODES,
 		      "Exceeds maximum demotion target nodes\n"))
-		return NUMA_NO_NODE;
+		goto out_clear;
 
 	nd->nodes[index] = migration_target;
 	nd->nr++;
 
 	return migration_target;
+out_clear:
+	node_clear(migration_target, *used);
+	return NUMA_NO_NODE;
 }
 
 /*
_

Patches currently in -mm which might be from ying.huang@intel.com are


