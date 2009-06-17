From: akpm@linux-foundation.org
Subject: [merged] page-allocator-clean-up-functions-related-to-pages_min.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:36 -0700
Message-ID: <200906171835.n5HIZaW5001596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005AbZFQSzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: clean up functions related to pages_min
has been removed from the -mm tree.  Its filename was
     page-allocator-clean-up-functions-related-to-pages_min.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: clean up functions related to pages_min
From: Minchan Kim <minchan.kim@gmail.com>

Change the names of two functions. It doesn't affect behavior. 

Presently, setup_per_zone_pages_min() changes low, high of zone as well as
min.  So a better name is setup_per_zone_wmarks().  That's because Mel
changed zone->pages_[hig/low/min] to zone->watermark array in "page
allocator: replace the watermark-related union in struct zone with a
watermark[] array".

 * setup_per_zone_pages_min => setup_per_zone_wmarks

Of course, we have to change init_per_zone_pages_min, too.  There are not
pages_min any more.  

 * init_per_zone_pages_min => init_per_zone_wmark_min

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |   17 +++++++++--------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff -puN include/linux/mm.h~page-allocator-clean-up-functions-related-to-pages_min include/linux/mm.h
--- a/include/linux/mm.h~page-allocator-clean-up-functions-related-to-pages_min
+++ a/include/linux/mm.h
@@ -1052,7 +1052,7 @@ extern int __meminit __early_pfn_to_nid(
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
-extern void setup_per_zone_pages_min(void);
+extern void setup_per_zone_wmarks(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff -puN mm/memory_hotplug.c~page-allocator-clean-up-functions-related-to-pages_min mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~page-allocator-clean-up-functions-related-to-pages_min
+++ a/mm/memory_hotplug.c
@@ -422,7 +422,7 @@ int online_pages(unsigned long pfn, unsi
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
-	setup_per_zone_pages_min();
+	setup_per_zone_wmarks();
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
diff -puN mm/page_alloc.c~page-allocator-clean-up-functions-related-to-pages_min mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-clean-up-functions-related-to-pages_min
+++ a/mm/page_alloc.c
@@ -4396,12 +4396,13 @@ static void setup_per_zone_lowmem_reserv
 }
 
 /**
- * setup_per_zone_pages_min - called when min_free_kbytes changes.
+ * setup_per_zone_wmarks - called when min_free_kbytes changes
+ * or when memory is hot-added
  *
- * Ensures that the pages_{min,low,high} values for each zone are set correctly
- * with respect to min_free_kbytes.
+ * Ensures that the watermark[min,low,high] values for each zone are set
+ * correctly with respect to min_free_kbytes.
  */
-void setup_per_zone_pages_min(void)
+void setup_per_zone_wmarks(void)
 {
 	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
 	unsigned long lowmem_pages = 0;
@@ -4519,7 +4520,7 @@ static void __init setup_per_zone_inacti
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-static int __init init_per_zone_pages_min(void)
+static int __init init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
 
@@ -4530,12 +4531,12 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 128;
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
-	setup_per_zone_pages_min();
+	setup_per_zone_wmarks();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();
 	return 0;
 }
-module_init(init_per_zone_pages_min)
+module_init(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
@@ -4547,7 +4548,7 @@ int min_free_kbytes_sysctl_handler(ctl_t
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (write)
-		setup_per_zone_pages_min();
+		setup_per_zone_wmarks();
 	return 0;
 }
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

