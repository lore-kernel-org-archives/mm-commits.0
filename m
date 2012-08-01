From: akpm@linux-foundation.org
Subject: [merged] mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:45 -0700
Message-ID: <20120801201446.5DFC75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65135 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:49 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so342543wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, wujianguo@huawei.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hotplug: correctly add new zone to all other nodes' zone lists
has been removed from the -mm tree.  Its filename was
     mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <jiang.liu@huawei.com>
Subject: mm/hotplug: correctly add new zone to all other nodes' zone lists

When online_pages() is called to add new memory to an empty zone, it
rebuilds all zone lists by calling build_all_zonelists().  But there's a
bug which prevents the new zone to be added to other nodes' zone lists.

online_pages() {
	build_all_zonelists()
	.....
	node_set_state(zone_to_nid(zone), N_HIGH_MEMORY)
}

Here the node of the zone is put into N_HIGH_MEMORY state after calling
build_all_zonelists(), but build_all_zonelists() only adds zones from
nodes in N_HIGH_MEMORY state to the fallback zone lists. 
build_all_zonelists()

    ->__build_all_zonelists()
	->build_zonelists()
	    ->find_next_best_node()
		->for_each_node_state(n, N_HIGH_MEMORY)

So memory in the new zone will never be used by other nodes, and it may
cause strange behavor when system is under memory pressure.  So put node
into N_HIGH_MEMORY state before calling build_all_zonelists().

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
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

 mm/memory_hotplug.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists
+++ a/mm/memory_hotplug.c
@@ -512,19 +512,20 @@ int __ref online_pages(unsigned long pfn
 
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
-	if (need_zonelists_rebuild)
-		build_all_zonelists(NULL, zone);
-	else
-		zone_pcp_update(zone);
+	if (onlined_pages) {
+		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+		if (need_zonelists_rebuild)
+			build_all_zonelists(NULL, zone);
+		else
+			zone_pcp_update(zone);
+	}
 
 	mutex_unlock(&zonelists_mutex);
 
 	init_per_zone_wmark_min();
 
-	if (onlined_pages) {
+	if (onlined_pages)
 		kswapd_run(zone_to_nid(zone));
-		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
-	}
 
 	vm_total_pages = nr_free_pagecache_pages();
 
_

Patches currently in -mm which might be from jiang.liu@huawei.com are

origin.patch

