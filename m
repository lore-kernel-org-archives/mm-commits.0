From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:05:21 -0700
Message-ID: <573f7c11.1F1zXByHbcnmZp4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETVFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: make node_page_state() handles all zones by itself
has been removed from the -mm tree.  Its filename was
     mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/vmstat: make node_page_state() handles all zones by itself

node_page_state() manually adds statistics per each zone and returns total
value for all zones.  Whenever we add a new zone, we need to consider this
function and it's really troublesome.  Make it handle all zones by itself.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-make-node_page_state-handles-all-zones-by-itself mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-make-node_page_state-handles-all-zones-by-itself
+++ a/mm/vmstat.c
@@ -600,19 +600,13 @@ void zone_statistics(struct zone *prefer
 unsigned long node_page_state(int node, enum zone_stat_item item)
 {
 	struct zone *zones = NODE_DATA(node)->node_zones;
+	int i;
+	unsigned long count = 0;
 
-	return
-#ifdef CONFIG_ZONE_DMA
-		zone_page_state(&zones[ZONE_DMA], item) +
-#endif
-#ifdef CONFIG_ZONE_DMA32
-		zone_page_state(&zones[ZONE_DMA32], item) +
-#endif
-#ifdef CONFIG_HIGHMEM
-		zone_page_state(&zones[ZONE_HIGHMEM], item) +
-#endif
-		zone_page_state(&zones[ZONE_NORMAL], item) +
-		zone_page_state(&zones[ZONE_MOVABLE], item);
+	for (i = 0; i < MAX_NR_ZONES; i++)
+		count += zone_page_state(zones + i, item);
+
+	return count;
 }
 
 #endif
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


