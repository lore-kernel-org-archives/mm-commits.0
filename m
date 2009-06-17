From: akpm@linux-foundation.org
Subject: [merged] page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:41 -0700
Message-ID: <200906171835.n5HIZfmk001741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbZFQSxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: reset wmark_min and inactive ratio of zone when hotplug happens
has been removed from the -mm tree.  Its filename was
     page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: reset wmark_min and inactive ratio of zone when hotplug happens
From: Minchan Kim <minchan.kim@gmail.com>

Solve two problems.

Whenever memory hotplug sucessfully happens, zone->present_pages
have to be changed.

1) Now memory hotplug calls setup_per_zone_wmark_min only when
   online_pages called, not offline_pages.

   It breaks balance.

2) If zone->present_pages is changed, we also have to change
   zone->inactive_ratio.  That's because inactive_ratio depends on
   zone->present_pages.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++++
 mm/page_alloc.c     |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens
+++ a/mm/memory_hotplug.c
@@ -423,6 +423,7 @@ int online_pages(unsigned long pfn, unsi
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
 	setup_per_zone_wmarks();
+	calculate_zone_inactive_ratio(zone);
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
@@ -832,6 +833,9 @@ repeat:
 	totalram_pages -= offlined_pages;
 	num_physpages -= offlined_pages;
 
+	setup_per_zone_wmarks();
+	calculate_zone_inactive_ratio(zone);
+
 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
 
diff -puN mm/page_alloc.c~page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens
+++ a/mm/page_alloc.c
@@ -4397,7 +4397,7 @@ static void setup_per_zone_lowmem_reserv
 
 /**
  * setup_per_zone_wmarks - called when min_free_kbytes changes
- * or when memory is hot-added
+ * or when memory is hot-{added|removed}
  *
  * Ensures that the watermark[min,low,high] values for each zone are set
  * correctly with respect to min_free_kbytes.
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

