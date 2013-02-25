From: akpm@linux-foundation.org
Subject: [merged] mempolicy-fix-is_valid_nodemask.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:39 -0800
Message-ID: <20130225205039.F3D0C31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42559 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:41 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347367vch.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: fix is_valid_nodemask()
has been removed from the -mm tree.  Its filename was
     mempolicy-fix-is_valid_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: mempolicy: fix is_valid_nodemask()

is_valid_nodemask() was introduced by 19770b32 ("mm: filter based on a
nodemask as well as a gfp_mask").  but it does not match its comments,
because it does not check the zone which > policy_zone.

Also in b377fd ("Apply memory policies to top two highest zones when
highest zone is ZONE_MOVABLE"), this commits told us, if highest zone is
ZONE_MOVABLE, we should also apply memory policies to it.  so ZONE_MOVABLE
should be valid zone for policies.  is_valid_nodemask() need to be changed
to match it.

Fix: check all zones, even its zoneid > policy_zone.  Use
nodes_intersects() instead open code to check it.

Reported-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-fix-is_valid_nodemask mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-is_valid_nodemask
+++ a/mm/mempolicy.c
@@ -161,19 +161,7 @@ static const struct mempolicy_operations
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(const nodemask_t *nodemask)
 {
-	int nd, k;
-
-	for_each_node_mask(nd, *nodemask) {
-		struct zone *z;
-
-		for (k = 0; k <= policy_zone; k++) {
-			z = &NODE_DATA(nd)->node_zones[k];
-			if (z->present_pages > 0)
-				return 1;
-		}
-	}
-
-	return 0;
+	return nodes_intersects(*nodemask, node_states[N_MEMORY]);
 }
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
@@ -1644,6 +1632,26 @@ struct mempolicy *get_vma_policy(struct 
 	return pol;
 }
 
+static int apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
+{
+	enum zone_type dynamic_policy_zone = policy_zone;
+
+	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
+
+	/*
+	 * if policy->v.nodes has movable memory only,
+	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
+	 *
+	 * policy->v.nodes is intersect with node_states[N_MEMORY].
+	 * so if the following test faile, it implies
+	 * policy->v.nodes has movable memory only.
+	 */
+	if (!nodes_intersects(policy->v.nodes, node_states[N_HIGH_MEMORY]))
+		dynamic_policy_zone = ZONE_MOVABLE;
+
+	return zone >= dynamic_policy_zone;
+}
+
 /*
  * Return a nodemask representing a mempolicy for filtering nodes for
  * page allocation
@@ -1652,7 +1660,7 @@ static nodemask_t *policy_nodemask(gfp_t
 {
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->mode == MPOL_BIND) &&
-			gfp_zone(gfp) >= policy_zone &&
+			apply_policy_zone(policy, gfp_zone(gfp)) &&
 			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
 		return &policy->v.nodes;
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch

