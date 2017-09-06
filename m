From: akpm@linux-foundation.org
Subject: [patch 033/119] mm, memory_hotplug: drop zone from
 build_all_zonelists
Date: Wed, 06 Sep 2017 16:20:24 -0700
Message-ID: <20170906232024.o6E6l0f57%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753909AbdIFXUZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, shaohua.li@intel.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, wency@cn.fujitsu.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: drop zone from build_all_zonelists

build_all_zonelists gets a zone parameter to initialize zone's pagesets. 
There is only a single user which gives a non-NULL zone parameter and that
one doesn't really need the rest of the build_all_zonelists (see
6dcd73d7011b ("memory-hotplug: allocate zone's pcp before onlining
pages")).

Therefore remove setup_zone_pageset from build_all_zonelists and call it
from its only user directly.  This will also remove a pointless zonlists
rebuilding which is always good.

Link: http://lkml.kernel.org/r/20170721143915.14161-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 init/main.c            |    2 +-
 mm/internal.h          |    1 +
 mm/memory_hotplug.c    |   10 +++++-----
 mm/page_alloc.c        |   13 +++----------
 5 files changed, 11 insertions(+), 17 deletions(-)

diff -puN include/linux/mmzone.h~mm-memory_hotplug-drop-zone-from-build_all_zonelists include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-memory_hotplug-drop-zone-from-build_all_zonelists
+++ a/include/linux/mmzone.h
@@ -771,7 +771,7 @@ static inline bool is_dev_zone(const str
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
+void build_all_zonelists(pg_data_t *pgdat);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int classzone_idx, unsigned int alloc_flags,
diff -puN init/main.c~mm-memory_hotplug-drop-zone-from-build_all_zonelists init/main.c
--- a/init/main.c~mm-memory_hotplug-drop-zone-from-build_all_zonelists
+++ a/init/main.c
@@ -542,7 +542,7 @@ asmlinkage __visible void __init start_k
 	boot_cpu_state_init();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
-	build_all_zonelists(NULL, NULL);
+	build_all_zonelists(NULL);
 	page_alloc_init();
 
 	pr_notice("Kernel command line: %s\n", boot_command_line);
diff -puN mm/internal.h~mm-memory_hotplug-drop-zone-from-build_all_zonelists mm/internal.h
--- a/mm/internal.h~mm-memory_hotplug-drop-zone-from-build_all_zonelists
+++ a/mm/internal.h
@@ -525,4 +525,5 @@ static inline bool is_migrate_highatomic
 	return get_pageblock_migratetype(page) == MIGRATE_HIGHATOMIC;
 }
 
+void setup_zone_pageset(struct zone *zone);
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-drop-zone-from-build_all_zonelists mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-zone-from-build_all_zonelists
+++ a/mm/memory_hotplug.c
@@ -929,7 +929,7 @@ int __ref online_pages(unsigned long pfn
 	mutex_lock(&zonelists_mutex);
 	if (!populated_zone(zone)) {
 		need_zonelists_rebuild = 1;
-		build_all_zonelists(NULL, zone);
+		setup_zone_pageset(zone);
 	}
 
 	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
@@ -950,7 +950,7 @@ int __ref online_pages(unsigned long pfn
 	if (onlined_pages) {
 		node_states_set_node(nid, &arg);
 		if (need_zonelists_rebuild)
-			build_all_zonelists(NULL, NULL);
+			build_all_zonelists(NULL);
 		else
 			zone_pcp_update(zone);
 	}
@@ -1028,7 +1028,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 	 * to access not-initialized zonelist, build here.
 	 */
 	mutex_lock(&zonelists_mutex);
-	build_all_zonelists(pgdat, NULL);
+	build_all_zonelists(pgdat);
 	mutex_unlock(&zonelists_mutex);
 
 	/*
@@ -1084,7 +1084,7 @@ int try_online_node(int nid)
 
 	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
 		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL, NULL);
+		build_all_zonelists(NULL);
 		mutex_unlock(&zonelists_mutex);
 	}
 
@@ -1704,7 +1704,7 @@ repeat:
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL, NULL);
+		build_all_zonelists(NULL);
 		mutex_unlock(&zonelists_mutex);
 	} else
 		zone_pcp_update(zone);
diff -puN mm/page_alloc.c~mm-memory_hotplug-drop-zone-from-build_all_zonelists mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-drop-zone-from-build_all_zonelists
+++ a/mm/page_alloc.c
@@ -5129,7 +5129,6 @@ static void build_zonelists(pg_data_t *p
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
-static void setup_zone_pageset(struct zone *zone);
 
 /*
  * Global mutex to protect against size modification of zonelists
@@ -5209,20 +5208,14 @@ build_all_zonelists_init(void)
  * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
  *
- * __ref due to (1) call of __meminit annotated setup_zone_pageset
- * [we're only called with non-NULL zone through __meminit paths] and
- * (2) call of __init annotated helper build_all_zonelists_init
+ * __ref due to call of __init annotated helper build_all_zonelists_init
  * [protected by SYSTEM_BOOTING].
  */
-void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
+void __ref build_all_zonelists(pg_data_t *pgdat)
 {
 	if (system_state == SYSTEM_BOOTING) {
 		build_all_zonelists_init();
 	} else {
-#ifdef CONFIG_MEMORY_HOTPLUG
-		if (zone)
-			setup_zone_pageset(zone);
-#endif
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
 		stop_machine_cpuslocked(__build_all_zonelists, pgdat, NULL);
@@ -5496,7 +5489,7 @@ static void __meminit zone_pageset_init(
 	pageset_set_high_and_batch(zone, pcp);
 }
 
-static void __meminit setup_zone_pageset(struct zone *zone)
+void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 	zone->pageset = alloc_percpu(struct per_cpu_pageset);
_
