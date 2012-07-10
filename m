From: akpm@linux-foundation.org
Subject: + mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch added to -mm tree
Date: Tue, 10 Jul 2012 13:58:45 -0700
Message-ID: <20120710205845.7B1231E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48006 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2GJU6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 16:58:47 -0400
Received: by ggeh3 with SMTP id h3so51541gge.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 13:58:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiang.liu@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, wujianguo@huawei.com, yinghai@kernel.org


The patch titled
     Subject: mm/hotplug: correctly add new zone to all other nodes' zone lists
has been added to the -mm tree.  Its filename is
     mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch

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
Subject: Subject: mm/hotplug: correctly add new zone to all other nodes' zone lists

Patches currently in -mm which might be from jiang.liu@huawei.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

