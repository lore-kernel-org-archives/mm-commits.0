From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
 added to -mm tree
Date: Fri, 21 Jul 2017 12:12:10 -0700
Message-ID: <5972520a.zvEUP/0RN7HrD+QQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753527AbdGUTML (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: drop zone from build_all_zonelists
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -541,7 +541,7 @@ asmlinkage __visible void __init start_k
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
@@ -933,7 +933,7 @@ int __ref online_pages(unsigned long pfn
 	mutex_lock(&zonelists_mutex);
 	if (!populated_zone(zone)) {
 		need_zonelists_rebuild = 1;
-		build_all_zonelists(NULL, zone);
+		setup_zone_pageset(zone);
 	}
 
 	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
@@ -954,7 +954,7 @@ int __ref online_pages(unsigned long pfn
 	if (onlined_pages) {
 		node_states_set_node(nid, &arg);
 		if (need_zonelists_rebuild)
-			build_all_zonelists(NULL, NULL);
+			build_all_zonelists(NULL);
 		else
 			zone_pcp_update(zone);
 	}
@@ -1032,7 +1032,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 	 * to access not-initialized zonelist, build here.
 	 */
 	mutex_lock(&zonelists_mutex);
-	build_all_zonelists(pgdat, NULL);
+	build_all_zonelists(pgdat);
 	mutex_unlock(&zonelists_mutex);
 
 	/*
@@ -1088,7 +1088,7 @@ int try_online_node(int nid)
 
 	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
 		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL, NULL);
+		build_all_zonelists(NULL);
 		mutex_unlock(&zonelists_mutex);
 	}
 
@@ -1710,7 +1710,7 @@ repeat:
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
@@ -5065,7 +5065,6 @@ static void build_zonelists(pg_data_t *p
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
-static void setup_zone_pageset(struct zone *zone);
 
 /*
  * Global mutex to protect against size modification of zonelists
@@ -5145,20 +5144,14 @@ build_all_zonelists_init(void)
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
@@ -5432,7 +5425,7 @@ static void __meminit zone_pageset_init(
 	pageset_set_high_and_batch(zone, pcp);
 }
 
-static void __meminit setup_zone_pageset(struct zone *zone)
+void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 	zone->pageset = alloc_percpu(struct per_cpu_pageset);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch

