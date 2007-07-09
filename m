From: akpm@linux-foundation.org
Subject: - change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:34:25 -0700
Message-ID: <200707092034.l69KYQOC009723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbXGIUei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     add check_highest_zone to build_zonelists_in_zone_order
has been removed from the -mm tree.  Its filename was
     change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch

This patch was dropped because it was folded into change-zonelist-order-zonelist-order-selection-logic.patch

------------------------------------------------------
Subject: add check_highest_zone to build_zonelists_in_zone_order
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

We missed this in the "change zone order" series.  We need to record the
highest populated zone, just as build_zonelists_node() does.  Memory
policies apply only to this zone.  Without this, we'll be applying policy
to all zones, including DMA, I think.  Not having thought about it much, I
can't claim to understand the downside of doing so.

Also, display selected "policy zone" during boot or reconfig of zonelist
order, if 'NUMA.  Inquiring minds [might] want to know...

Cleanup: remove stale comment in set_zonelist_order()

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order mm/page_alloc.c
--- a/mm/page_alloc.c~change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order
+++ a/mm/page_alloc.c
@@ -1663,7 +1663,7 @@ static char zonelist_order_name[3][8] = 
 
 
 #ifdef CONFIG_NUMA
-/* The vaule user specified ....changed by config */
+/* The value user specified ....changed by config */
 static int user_zonelist_order = ZONELIST_ORDER_DEFAULT;
 /* string for sysctl */
 #define NUMA_ZONELIST_ORDER_LEN	16
@@ -1841,8 +1841,10 @@ static void build_zonelists_in_zone_orde
 			for (j = 0; j < nr_nodes; j++) {
 				node = node_order[j];
 				z = &NODE_DATA(node)->node_zones[zone_type];
-				if (populated_zone(z))
+				if (populated_zone(z)) {
 					zonelist->zones[pos++] = z;
+					check_highest_zone(zone_type);
+				}
 			}
 		}
 		zonelist->zones[pos] = NULL;
@@ -1857,7 +1859,6 @@ static int default_zonelist_order(void)
 
 static void set_zonelist_order(void)
 {
-	/* dummy, just select node order. */
 	if (user_zonelist_order == ZONELIST_ORDER_DEFAULT)
 		current_zonelist_order = default_zonelist_order();
 	else
@@ -2024,6 +2025,9 @@ void build_all_zonelists(void)
 	printk("Built %i zonelists in %s order.  Total pages: %ld\n",
 			zonelist_order_name[current_zonelist_order],
 			num_online_nodes(), vm_total_pages);
+#ifdef CONFIG_NUMA
+	printk("Policy zone: %s\n", zone_names[policy_zone]);
+#endif
 }
 
 /*
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
