From: akpm@linux-foundation.org
Subject: [merged] mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:55 -0700
Message-ID: <20120801201456.5035E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61449 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:59 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr14so198985wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@huawei.com, Bessel.Wang@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hotplug: mark memory hotplug code in page_alloc.c as __meminit
has been removed from the -mm tree.  Its filename was
     mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <jiang.liu@huawei.com>
Subject: mm/hotplug: mark memory hotplug code in page_alloc.c as __meminit

Mark functions used by both boot and memory hotplug as __meminit to reduce
memory footprint when memory hotplug is disabled.

Alos guard zone_pcp_update() with CONFIG_MEMORY_HOTPLUG because it's only
used by memory hotplug code.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Cc: Wei Wang <Bessel.Wang@huawei.com>
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

 mm/page_alloc.c |   66 +++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff -puN mm/page_alloc.c~mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit
+++ a/mm/page_alloc.c
@@ -3411,7 +3411,7 @@ static void setup_zone_pageset(struct zo
 DEFINE_MUTEX(zonelists_mutex);
 
 /* return values int ....just for stop_machine() */
-static __init_refok int __build_all_zonelists(void *data)
+static int __build_all_zonelists(void *data)
 {
 	int nid;
 	int cpu;
@@ -3755,7 +3755,7 @@ static void __meminit zone_init_free_lis
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int zone_batchsize(struct zone *zone)
+static int __meminit zone_batchsize(struct zone *zone)
 {
 #ifdef CONFIG_MMU
 	int batch;
@@ -3837,7 +3837,7 @@ static void setup_pagelist_highmark(stru
 		pcp->batch = PAGE_SHIFT * 8;
 }
 
-static void setup_zone_pageset(struct zone *zone)
+static void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 
@@ -3910,33 +3910,6 @@ int zone_wait_table_init(struct zone *zo
 	return 0;
 }
 
-static int __zone_pcp_update(void *data)
-{
-	struct zone *zone = data;
-	int cpu;
-	unsigned long batch = zone_batchsize(zone), flags;
-
-	for_each_possible_cpu(cpu) {
-		struct per_cpu_pageset *pset;
-		struct per_cpu_pages *pcp;
-
-		pset = per_cpu_ptr(zone->pageset, cpu);
-		pcp = &pset->pcp;
-
-		local_irq_save(flags);
-		if (pcp->count > 0)
-			free_pcppages_bulk(zone, pcp->count, pcp);
-		setup_pageset(pset, batch);
-		local_irq_restore(flags);
-	}
-	return 0;
-}
-
-void zone_pcp_update(struct zone *zone)
-{
-	stop_machine(__zone_pcp_update, zone, NULL);
-}
-
 static __meminit void zone_pcp_init(struct zone *zone)
 {
 	/*
@@ -3952,7 +3925,7 @@ static __meminit void zone_pcp_init(stru
 					 zone_batchsize(zone));
 }
 
-__meminit int init_currently_empty_zone(struct zone *zone,
+int __meminit init_currently_empty_zone(struct zone *zone,
 					unsigned long zone_start_pfn,
 					unsigned long size,
 					enum memmap_context context)
@@ -4765,7 +4738,7 @@ out:
 }
 
 /* Any regular memory on that node ? */
-static void check_for_regular_memory(pg_data_t *pgdat)
+static void __init check_for_regular_memory(pg_data_t *pgdat)
 {
 #ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
@@ -5893,6 +5866,35 @@ void free_contig_range(unsigned long pfn
 }
 #endif
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int __meminit __zone_pcp_update(void *data)
+{
+	struct zone *zone = data;
+	int cpu;
+	unsigned long batch = zone_batchsize(zone), flags;
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_pageset *pset;
+		struct per_cpu_pages *pcp;
+
+		pset = per_cpu_ptr(zone->pageset, cpu);
+		pcp = &pset->pcp;
+
+		local_irq_save(flags);
+		if (pcp->count > 0)
+			free_pcppages_bulk(zone, pcp->count, pcp);
+		setup_pageset(pset, batch);
+		local_irq_restore(flags);
+	}
+	return 0;
+}
+
+void __meminit zone_pcp_update(struct zone *zone)
+{
+	stop_machine(__zone_pcp_update, zone, NULL);
+}
+#endif
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 void zone_pcp_reset(struct zone *zone)
 {
_

Patches currently in -mm which might be from jiang.liu@huawei.com are

origin.patch

