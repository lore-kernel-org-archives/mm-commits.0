Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF08C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiCVVr7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiCVVrf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBEE6457
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D56F6119A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00702C340EE;
        Tue, 22 Mar 2022 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985566;
        bh=twgtnMsCKbLVHH5ZK/yXbLcXsd805xYGF/oG8kSHFMY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=X07MdqreJqPOBhicaHrfB0ohQzVYaAAIQ5g+s4jLo+7C93Bhh8qf19o7gq2o0pVCX
         5DJhtqRZ0dZyPMQCEafH1nIUEwJPmMBxsgAUr7LPps6vrFyCg0lMZ2Y7xZSmtAdX2+
         41mx0ZK59HcxuRtV8N4KGdZg0cfVQ9DZfKD9rzCc=
Date:   Tue, 22 Mar 2022 14:46:05 -0700
To:     ziy@nvidia.com, zhongjiang-ali@linux.alibaba.com,
        xlpang@linux.alibaba.com, shy828301@gmail.com, osalvador@suse.de,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 149/227] mm,migrate: fix establishing demotion target
Message-Id: <20220322214606.00702C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
