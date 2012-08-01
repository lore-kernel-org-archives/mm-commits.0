From: akpm@linux-foundation.org
Subject: [merged] mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:51 -0700
Message-ID: <20120801201451.EFFF4100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:53 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@huawei.com, Bessel.Wang@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hotplug: free zone->pageset when a zone becomes empty
has been removed from the -mm tree.  Its filename was
     mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <jiang.liu@huawei.com>
Subject: mm/hotplug: free zone->pageset when a zone becomes empty

When a zone becomes empty after memory offlining, free zone->pageset. 
Otherwise it will cause memory leak when adding memory to the empty zone
again because build_all_zonelists() will allocate zone->pageset for an
empty zone.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Wei Wang <Bessel.Wang@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Keping Chen <chenkeping@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 +
 mm/memory_hotplug.c |    3 +++
 mm/page_alloc.c     |   13 +++++++++++++
 3 files changed, 17 insertions(+)

diff -puN include/linux/mm.h~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty include/linux/mm.h
--- a/include/linux/mm.h~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty
+++ a/include/linux/mm.h
@@ -1331,6 +1331,7 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 extern void setup_per_cpu_pageset(void);
 
 extern void zone_pcp_update(struct zone *zone);
+extern void zone_pcp_reset(struct zone *zone);
 
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
diff -puN mm/memory_hotplug.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty
+++ a/mm/memory_hotplug.c
@@ -966,6 +966,9 @@ repeat:
 
 	init_per_zone_wmark_min();
 
+	if (!populated_zone(zone))
+		zone_pcp_reset(zone);
+
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
 		kswapd_stop(node);
diff -puN mm/page_alloc.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty
+++ a/mm/page_alloc.c
@@ -5894,6 +5894,19 @@ void free_contig_range(unsigned long pfn
 #endif
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+void zone_pcp_reset(struct zone *zone)
+{
+	unsigned long flags;
+
+	/* avoid races with drain_pages()  */
+	local_irq_save(flags);
+	if (zone->pageset != &boot_pageset) {
+		free_percpu(zone->pageset);
+		zone->pageset = &boot_pageset;
+	}
+	local_irq_restore(flags);
+}
+
 /*
  * All pages in the range must be isolated before calling this.
  */
_

Patches currently in -mm which might be from jiang.liu@huawei.com are

origin.patch

