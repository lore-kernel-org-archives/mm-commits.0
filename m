From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-use-ensure_zone_is_initialized.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:44 -0800
Message-ID: <20130225205444.ADCF231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60777 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3BYUyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:45 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348089yhz.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use ensure_zone_is_initialized()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-use-ensure_zone_is_initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/memory_hotplug: use ensure_zone_is_initialized()

Remove open coding of ensure_zone_is_initialzied().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-use-ensure_zone_is_initialized mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-ensure_zone_is_initialized
+++ a/mm/memory_hotplug.c
@@ -300,12 +300,9 @@ static int __meminit move_pfn_range_left
 	unsigned long flags;
 	unsigned long z1_start_pfn;
 
-	if (!z1->wait_table) {
-		ret = init_currently_empty_zone(z1, start_pfn,
-			end_pfn - start_pfn, MEMMAP_HOTPLUG);
-		if (ret)
-			return ret;
-	}
+	ret = ensure_zone_is_initialized(z1, start_pfn, end_pfn - start_pfn);
+	if (ret)
+		return ret;
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -345,12 +342,9 @@ static int __meminit move_pfn_range_righ
 	unsigned long flags;
 	unsigned long z2_end_pfn;
 
-	if (!z2->wait_table) {
-		ret = init_currently_empty_zone(z2, start_pfn,
-			end_pfn - start_pfn, MEMMAP_HOTPLUG);
-		if (ret)
-			return ret;
-	}
+	ret = ensure_zone_is_initialized(z2, start_pfn, end_pfn - start_pfn);
+	if (ret)
+		return ret;
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -403,16 +397,13 @@ static int __meminit __add_zone(struct z
 	int nid = pgdat->node_id;
 	int zone_type;
 	unsigned long flags;
+	int ret;
 
 	zone_type = zone - pgdat->node_zones;
-	if (!zone->wait_table) {
-		int ret;
+	ret = ensure_zone_is_initialized(zone, phys_start_pfn, nr_pages);
+	if (ret)
+		return ret;
 
-		ret = init_currently_empty_zone(zone, phys_start_pfn,
-						nr_pages, MEMMAP_HOTPLUG);
-		if (ret)
-			return ret;
-	}
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
 	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

