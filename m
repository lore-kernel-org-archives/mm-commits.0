From: akpm@linux-foundation.org
Subject: + change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch added to -mm tree
Date: Thu, 17 May 2007 11:50:37 -0700
Message-ID: <200705171850.l4HIobdA030387@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51077 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbXEQSxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     add check_highest_zone to build_zonelists_in_zone_order
has been added to the -mm tree.  Its filename is
     change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order mm/page_alloc.c
--- a/mm/page_alloc.c~change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order
+++ a/mm/page_alloc.c
@@ -1678,7 +1678,7 @@ static char zonelist_order_name[3][8] = 
 
 
 #ifdef CONFIG_NUMA
-/* The vaule user specified ....changed by config */
+/* The value user specified ....changed by config */
 static int user_zonelist_order = ZONELIST_ORDER_DEFAULT;
 /* string for sysctl */
 #define NUMA_ZONELIST_ORDER_LEN	16
@@ -1856,8 +1856,10 @@ static void build_zonelists_in_zone_orde
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
@@ -1872,7 +1874,6 @@ static int default_zonelist_order(void)
 
 static void set_zonelist_order(void)
 {
-	/* dummy, just select node order. */
 	if (user_zonelist_order == ZONELIST_ORDER_DEFAULT)
 		current_zonelist_order = default_zonelist_order();
 	else
@@ -2039,6 +2040,9 @@ void build_all_zonelists(void)
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

change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
