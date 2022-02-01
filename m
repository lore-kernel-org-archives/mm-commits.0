Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E38FC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 22:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242079AbiBAWxA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:53:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58992 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiBAWw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 17:52:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1515CE1AEA
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 22:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45A1C340EB;
        Tue,  1 Feb 2022 22:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643755976;
        bh=ZOXeNgTsvQgWAGc5i80QNw0QwW4vsgAARg4ZxFXoou0=;
        h=Date:To:From:Subject:From;
        b=xc3c0TDBvW14VQUz8bVnSzWRfXJocWgIb4iQgnjt1GjDPmqH3nXp5QkdOzh+dpyTT
         YfMrtM16ruxA+HeFDzbKMOW7EYaXWY+W0itWovNQOYy/BdWbSKZbLMkIcA5dn8+7Lc
         86ahvyIU6n+BvwFsMZAmDtmRDiPxBcXDN5C0JDVA=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 14:52:54 -0800
Date:   Tue, 01 Feb 2022 14:52:54 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, xlpang@linux.alibaba.com,
        shy828301@gmail.com, osalvador@suse.de,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmigrate-fix-establishing-demotion-target.patch added to -mm tree
Message-Id: <20220201225254.C45A1C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,migrate: fix establishing demotion target
has been added to the -mm tree.  Its filename is
     mmmigrate-fix-establishing-demotion-target.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmigrate-fix-establishing-demotion-target.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmigrate-fix-establishing-demotion-target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mmmigrate-fix-establishing-demotion-target
+++ a/mm/migrate.c
@@ -3083,18 +3083,21 @@ static int establish_migrate_target(int
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

mmmigrate-fix-establishing-demotion-target.patch
numa-balancing-add-page-promotion-counter.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
memory-tiering-skip-to-scan-fast-memory.patch

