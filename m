From: akpm@linux-foundation.org
Subject: [patch 069/117] mm/page_alloc: correct highmem memory statistics
Date: Thu, 19 May 2016 17:12:23 -0700
Message-ID: <573e5667.47LOXon5hrXIbPvG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcETAMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: correct highmem memory statistics

ZONE_MOVABLE could be treated as highmem so we need to consider it for
accurate statistics.  And, in following patches, ZONE_CMA will be
introduced and it can be treated as highmem, too.  So, instead of manually
adding stat of ZONE_MOVABLE, looping all zones and check whether the zone
is highmem or not and add stat of the zone which can be treated as
highmem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-correct-highmem-memory-statistics mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-correct-highmem-memory-statistics
+++ a/mm/page_alloc.c
@@ -3793,6 +3793,8 @@ void si_meminfo_node(struct sysinfo *val
 {
 	int zone_type;		/* needs to be signed */
 	unsigned long managed_pages = 0;
+	unsigned long managed_highpages = 0;
+	unsigned long free_highpages = 0;
 	pg_data_t *pgdat = NODE_DATA(nid);
 
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
@@ -3801,12 +3803,19 @@ void si_meminfo_node(struct sysinfo *val
 	val->sharedram = node_page_state(nid, NR_SHMEM);
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
-	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
-	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
-			NR_FREE_PAGES);
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (is_highmem(zone)) {
+			managed_highpages += zone->managed_pages;
+			free_highpages += zone_page_state(zone, NR_FREE_PAGES);
+		}
+	}
+	val->totalhigh = managed_highpages;
+	val->freehigh = free_highpages;
 #else
-	val->totalhigh = 0;
-	val->freehigh = 0;
+	val->totalhigh = managed_highpages;
+	val->freehigh = free_highpages;
 #endif
 	val->mem_unit = PAGE_SIZE;
 }
_
