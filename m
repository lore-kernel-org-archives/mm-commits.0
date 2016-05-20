From: akpm@linux-foundation.org
Subject: [merged]
 mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch removed from -mm tree
Date: Fri, 20 May 2016 14:05:18 -0700
Message-ID: <573f7c0e.4eDdWgv3WBYLC1zU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETVFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: make nr_free_highpages() handles all highmem zones by itself
has been removed from the -mm tree.  Its filename was
     mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/highmem: make nr_free_highpages() handles all highmem zones by itself

nr_free_highpages() manually adds statistics per each highmem zone and
returns a total value for them.  Whenever we add a new highmem zone, we
need to consider this function and it's really troublesome.  Make it
handle all highmem zones by itself.

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

 mm/highmem.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/highmem.c~mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself mm/highmem.c
--- a/mm/highmem.c~mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself
+++ a/mm/highmem.c
@@ -112,16 +112,12 @@ EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx)
 
 unsigned int nr_free_highpages (void)
 {
-	pg_data_t *pgdat;
+	struct zone *zone;
 	unsigned int pages = 0;
 
-	for_each_online_pgdat(pgdat) {
-		pages += zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
-			NR_FREE_PAGES);
-		if (zone_movable_is_highmem())
-			pages += zone_page_state(
-					&pgdat->node_zones[ZONE_MOVABLE],
-					NR_FREE_PAGES);
+	for_each_populated_zone(zone) {
+		if (is_highmem(zone))
+			pages += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
 	return pages;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


