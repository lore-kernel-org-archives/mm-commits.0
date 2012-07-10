From: akpm@linux-foundation.org
Subject: + mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch added to -mm tree
Date: Tue, 10 Jul 2012 13:58:39 -0700
Message-ID: <20120710205840.0A92C200072@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48028 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2GJU6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 16:58:44 -0400
Received: by fat25 with SMTP id 25so19147fat.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 13:58:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiang.liu@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, qiuxishi@huawei.com, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, yinghai@kernel.org


The patch titled
     Subject: mm/hotplug: correctly setup fallback zonelists when creating new pgdat
has been added to the -mm tree.  Its filename is
     mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch

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
Subject: mm/hotplug: correctly setup fallback zonelists when creating new pgdat

When hotadd_new_pgdat() is called to create new pgdat for a new node, a
fallback zonelist should be created for the new node.  There's code to try
to achieve that in hotadd_new_pgdat() as below:

	/*
	 * The node we allocated has no zone fallback lists. For avoiding
	 * to access not-initialized zonelist, build here.
	 */
	mutex_lock(&zonelists_mutex);
	build_all_zonelists(pgdat, NULL);
	mutex_unlock(&zonelists_mutex);

But it doesn't work as expected.  When hotadd_new_pgdat() is called, the
new node is still in offline state because node_set_online(nid) hasn't
been called yet.  And build_all_zonelists() only builds zonelists for
online nodes as:

        for_each_online_node(nid) {
                pg_data_t *pgdat = NODE_DATA(nid);

                build_zonelists(pgdat);
                build_zonelist_cache(pgdat);
        }

Though we hope to create zonelist for the new pgdat, but it doesn't.  So
add a new parameter "pgdat" the build_all_zonelists() to build pgdat for
the new pgdat too.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
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

 include/linux/mmzone.h |    2 +-
 init/main.c            |    2 +-
 kernel/cpu.c           |    2 +-
 mm/memory_hotplug.c    |    4 ++--
 mm/page_alloc.c        |   17 ++++++++++++-----
 5 files changed, 17 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat
+++ a/include/linux/mmzone.h
@@ -720,7 +720,7 @@ typedef struct pglist_data {
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-void build_all_zonelists(void *data);
+void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
 bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		int classzone_idx, int alloc_flags);
diff -puN init/main.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat init/main.c
--- a/init/main.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat
+++ a/init/main.c
@@ -506,7 +506,7 @@ asmlinkage void __init start_kernel(void
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
-	build_all_zonelists(NULL);
+	build_all_zonelists(NULL, NULL);
 	page_alloc_init();
 
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
diff -puN kernel/cpu.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat kernel/cpu.c
--- a/kernel/cpu.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat
+++ a/kernel/cpu.c
@@ -416,7 +416,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 
 	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
 		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL);
+		build_all_zonelists(NULL, NULL);
 		mutex_unlock(&zonelists_mutex);
 	}
 #endif
diff -puN mm/memory_hotplug.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat
+++ a/mm/memory_hotplug.c
@@ -513,7 +513,7 @@ int __ref online_pages(unsigned long pfn
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 	if (need_zonelists_rebuild)
-		build_all_zonelists(zone);
+		build_all_zonelists(NULL, zone);
 	else
 		zone_pcp_update(zone);
 
@@ -562,7 +562,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 	 * to access not-initialized zonelist, build here.
 	 */
 	mutex_lock(&zonelists_mutex);
-	build_all_zonelists(NULL);
+	build_all_zonelists(pgdat, NULL);
 	mutex_unlock(&zonelists_mutex);
 
 	return pgdat;
diff -puN mm/page_alloc.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat
+++ a/mm/page_alloc.c
@@ -3031,7 +3031,7 @@ int numa_zonelist_order_handler(ctl_tabl
 			user_zonelist_order = oldval;
 		} else if (oldval != user_zonelist_order) {
 			mutex_lock(&zonelists_mutex);
-			build_all_zonelists(NULL);
+			build_all_zonelists(NULL, NULL);
 			mutex_unlock(&zonelists_mutex);
 		}
 	}
@@ -3414,10 +3414,17 @@ static __init_refok int __build_all_zone
 {
 	int nid;
 	int cpu;
+	pg_data_t *self = data;
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
 #endif
+
+	if (self && !node_online(self->node_id)) {
+		build_zonelists(self);
+		build_zonelist_cache(self);
+	}
+
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 
@@ -3462,7 +3469,7 @@ static __init_refok int __build_all_zone
  * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
  */
-void __ref build_all_zonelists(void *data)
+void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
 {
 	set_zonelist_order();
 
@@ -3474,10 +3481,10 @@ void __ref build_all_zonelists(void *dat
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
 #ifdef CONFIG_MEMORY_HOTPLUG
-		if (data)
-			setup_zone_pageset((struct zone *)data);
+		if (zone)
+			setup_zone_pageset(zone);
 #endif
-		stop_machine(__build_all_zonelists, NULL, NULL);
+		stop_machine(__build_all_zonelists, pgdat, NULL);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
_
Subject: Subject: mm/hotplug: correctly setup fallback zonelists when creating new pgdat

Patches currently in -mm which might be from jiang.liu@huawei.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

