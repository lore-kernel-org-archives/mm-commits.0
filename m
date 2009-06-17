From: akpm@linux-foundation.org
Subject: [merged] page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:39 -0700
Message-ID: <200906171835.n5HIZd48001601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755459AbZFQSvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: add inactive ratio calculation function of each zone
has been removed from the -mm tree.  Its filename was
     page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: add inactive ratio calculation function of each zone
From: Minchan Kim <minchan.kim@gmail.com>

Factor the per-zone arithemetic inside setup_per_zone_inactive_ratio()'s
loop into a a separate function, calculate_zone_inactive_ratio().  This
function will be used in a later patch

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~page-allocator-add-inactive-ratio-calculation-function-of-each-zone include/linux/mm.h
--- a/include/linux/mm.h~page-allocator-add-inactive-ratio-calculation-function-of-each-zone
+++ a/include/linux/mm.h
@@ -1053,6 +1053,7 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
+extern void calculate_zone_inactive_ratio(struct zone *zone);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff -puN mm/page_alloc.c~page-allocator-add-inactive-ratio-calculation-function-of-each-zone mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-add-inactive-ratio-calculation-function-of-each-zone
+++ a/mm/page_alloc.c
@@ -4478,22 +4478,26 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void __init setup_per_zone_inactive_ratio(void)
+void calculate_zone_inactive_ratio(struct zone *zone)
 {
-	struct zone *zone;
+	unsigned int gb, ratio;
 
-	for_each_zone(zone) {
-		unsigned int gb, ratio;
+	/* Zone size in gigabytes */
+	gb = zone->present_pages >> (30 - PAGE_SHIFT);
+	if (gb)
+		ratio = int_sqrt(10 * gb);
+	else
+		ratio = 1;
 
-		/* Zone size in gigabytes */
-		gb = zone->present_pages >> (30 - PAGE_SHIFT);
-		if (gb)
-			ratio = int_sqrt(10 * gb);
-		else
-			ratio = 1;
+	zone->inactive_ratio = ratio;
+}
 
-		zone->inactive_ratio = ratio;
-	}
+static void __init setup_per_zone_inactive_ratio(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone)
+		calculate_zone_inactive_ratio(zone);
 }
 
 /*
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

