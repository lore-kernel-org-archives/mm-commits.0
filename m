From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-zone_type-argument-of-build_zonelists_node.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:51 -0700
Message-ID: <51dc9a97.NmrC+ak8nZ6mIIEQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3GIXTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-remove-zone_type-argument-of-build_zonelists_node.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:51 -0700


The patch titled
     Subject: mm/page_alloc.c: remove zone_type argument of build_zonelists_node
has been removed from the -mm tree.  Its filename was
     mm-remove-zone_type-argument-of-build_zonelists_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/page_alloc.c: remove zone_type argument of build_zonelists_node

The callers of build_zonelists_node always pass MAX_NR_ZONES -1 as the
zone_type argument, so we can directly use the value in
build_zonelists_node and remove zone_type argument.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-zone_type-argument-of-build_zonelists_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-zone_type-argument-of-build_zonelists_node
+++ a/mm/page_alloc.c
@@ -3153,12 +3153,10 @@ static void zoneref_set_zone(struct zone
  * Add all populated zones of a node to the zonelist.
  */
 static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
-				int nr_zones, enum zone_type zone_type)
+				int nr_zones)
 {
 	struct zone *zone;
-
-	BUG_ON(zone_type >= MAX_NR_ZONES);
-	zone_type++;
+	enum zone_type zone_type = MAX_NR_ZONES;
 
 	do {
 		zone_type--;
@@ -3168,8 +3166,8 @@ static int build_zonelists_node(pg_data_
 				&zonelist->_zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
-
 	} while (zone_type);
+
 	return nr_zones;
 }
 
@@ -3363,8 +3361,7 @@ static void build_zonelists_in_node_orde
 	zonelist = &pgdat->node_zonelists[0];
 	for (j = 0; zonelist->_zonerefs[j].zone != NULL; j++)
 		;
-	j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+	j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
 }
@@ -3378,7 +3375,7 @@ static void build_thisnode_zonelists(pg_
 	struct zonelist *zonelist;
 
 	zonelist = &pgdat->node_zonelists[1];
-	j = build_zonelists_node(pgdat, zonelist, 0, MAX_NR_ZONES - 1);
+	j = build_zonelists_node(pgdat, zonelist, 0);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
 }
@@ -3586,7 +3583,7 @@ static void build_zonelists(pg_data_t *p
 	local_node = pgdat->node_id;
 
 	zonelist = &pgdat->node_zonelists[0];
-	j = build_zonelists_node(pgdat, zonelist, 0, MAX_NR_ZONES - 1);
+	j = build_zonelists_node(pgdat, zonelist, 0);
 
 	/*
 	 * Now we build the zonelist so that it contains the zones
@@ -3599,14 +3596,12 @@ static void build_zonelists(pg_data_t *p
 	for (node = local_node + 1; node < MAX_NUMNODES; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	}
 	for (node = 0; node < local_node; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	}
 
 	zonelist->_zonerefs[j].zone = NULL;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

