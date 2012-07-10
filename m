From: akpm@linux-foundation.org
Subject: + mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch added to -mm tree
Date: Tue, 10 Jul 2012 13:58:50 -0700
Message-ID: <20120710205851.4FA991E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35490 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2GJU6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 16:58:53 -0400
Received: by yhl10 with SMTP id 10so51202yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 13:58:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiang.liu@huawei.com, Bessel.Wang@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, yinghai@kernel.org


The patch titled
     Subject: mm/hotplug: mark memory hotplug code in page_alloc.c as __meminit
has been added to the -mm tree.  Its filename is
     mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3410,7 +3410,7 @@ static void setup_zone_pageset(struct zo
 DEFINE_MUTEX(zonelists_mutex);
 
 /* return values int ....just for stop_machine() */
-static __init_refok int __build_all_zonelists(void *data)
+static int __build_all_zonelists(void *data)
 {
 	int nid;
 	int cpu;
@@ -3754,7 +3754,7 @@ static void __meminit zone_init_free_lis
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int zone_batchsize(struct zone *zone)
+static int __meminit zone_batchsize(struct zone *zone)
 {
 #ifdef CONFIG_MMU
 	int batch;
@@ -3836,7 +3836,7 @@ static void setup_pagelist_highmark(stru
 		pcp->batch = PAGE_SHIFT * 8;
 }
 
-static void setup_zone_pageset(struct zone *zone)
+static void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 
@@ -3909,33 +3909,6 @@ int zone_wait_table_init(struct zone *zo
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
@@ -3951,7 +3924,7 @@ static __meminit void zone_pcp_init(stru
 					 zone_batchsize(zone));
 }
 
-__meminit int init_currently_empty_zone(struct zone *zone,
+int __meminit init_currently_empty_zone(struct zone *zone,
 					unsigned long zone_start_pfn,
 					unsigned long size,
 					enum memmap_context context)
@@ -4764,7 +4737,7 @@ out:
 }
 
 /* Any regular memory on that node ? */
-static void check_for_regular_memory(pg_data_t *pgdat)
+static void __init check_for_regular_memory(pg_data_t *pgdat)
 {
 #ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
@@ -5892,6 +5865,35 @@ void free_contig_range(unsigned long pfn
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
Subject: Subject: mm/hotplug: mark memory hotplug code in page_alloc.c as __meminit

Patches currently in -mm which might be from jiang.liu@huawei.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

