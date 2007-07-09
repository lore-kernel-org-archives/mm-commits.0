From: akpm@linux-foundation.org
Subject: - change-zonelist-order-auto-configuration.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:34:54 -0700
Message-ID: <200707092034.l69KYsnR009733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34702 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbXGIUfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, ak@suse.de, clameter@sgi.com, jesse.barnes@intel.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     change zonelist order: auto configuration
has been removed from the -mm tree.  Its filename was
     change-zonelist-order-auto-configuration.patch

This patch was dropped because it was folded into change-zonelist-order-zonelist-order-selection-logic.patch

------------------------------------------------------
Subject: change zonelist order: auto configuration
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add auto zone ordering configuration.

This function will select ZONE_ORDER_NODE when

There are only ZONE_DMA or ZONE_DMA32.
|| size of (ZONE_DMA/DMA32) > (System Total Memory)/2
|| Assume Node(A)
	Node (A) is enough big &&
	Node (A)'s ZONE_DMA/DMA32 occupies 60% of Node(A)'s memory.
	(In this case, ZONE_ORDER_ZONE may not offer enough locality...)

otherwise, ZONE_ORDER_ZONE is selected.

Maybe there is no best way to configure zone order. I wrote this base on
my experience and discussion on the list.

Anyway, a user can specifiy zone order from boot option/sysctl.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "jesse.barnes@intel.com" <jesse.barnes@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   51 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~change-zonelist-order-auto-configuration mm/page_alloc.c
--- a/mm/page_alloc.c~change-zonelist-order-auto-configuration
+++ a/mm/page_alloc.c
@@ -1853,8 +1853,55 @@ static void build_zonelists_in_zone_orde
 
 static int default_zonelist_order(void)
 {
-	/* dummy, just select node order. */
-	return ZONELIST_ORDER_NODE;
+	int nid, zone_type;
+	unsigned long low_kmem_size,total_size;
+	struct zone *z;
+	int average_size;
+	/*
+         * ZONE_DMA and ZONE_DMA32 can be very small area in the sytem.
+	 * If they are really small and used heavily, the system can fall
+	 * into OOM very easily.
+	 * This function detect ZONE_DMA/DMA32 size and confgigures zone order.
+	 */
+	/* Is there ZONE_NORMAL ? (ex. ppc has only DMA zone..) */
+	low_kmem_size = 0;
+	total_size = 0;
+	for_each_online_node(nid) {
+		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+			z = &NODE_DATA(nid)->node_zones[zone_type];
+			if (populated_zone(z)) {
+				if (zone_type < ZONE_NORMAL)
+					low_kmem_size += z->present_pages;
+				total_size += z->present_pages;
+			}
+		}
+	}
+	if (!low_kmem_size ||  /* there are no DMA area. */
+	    low_kmem_size > total_size/2) /* DMA/DMA32 is big. */
+		return ZONELIST_ORDER_NODE;
+	/*
+	 * look into each node's config.
+  	 * If there is a node whose DMA/DMA32 memory is very big area on
+ 	 * local memory, NODE_ORDER may be suitable.
+         */
+	average_size = total_size / (num_online_nodes() + 1);
+	for_each_online_node(nid) {
+		low_kmem_size = 0;
+		total_size = 0;
+		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+			z = &NODE_DATA(nid)->node_zones[zone_type];
+			if (populated_zone(z)) {
+				if (zone_type < ZONE_NORMAL)
+					low_kmem_size += z->present_pages;
+				total_size += z->present_pages;
+			}
+		}
+		if (low_kmem_size &&
+		    total_size > average_size && /* ignore small node */
+		    low_kmem_size > total_size * 70/100)
+			return ZONELIST_ORDER_NODE;
+	}
+	return ZONELIST_ORDER_ZONE;
 }
 
 static void set_zonelist_order(void)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
