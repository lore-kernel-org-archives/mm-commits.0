From: akpm@linux-foundation.org
Subject: [merged] memory_hotplug-ensure-every-online-node-has-normal-memory.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:39 -0800
Message-ID: <20121212200140.A04DD200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58071 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2LLUBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:01:45 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so65838eei.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:01:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, greg@kroah.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rusty@rustcorp.com.au, wency@cn.fujitsu.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug: ensure every online node has NORMAL memory
has been removed from the -mm tree.  Its filename was
     memory_hotplug-ensure-every-online-node-has-normal-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: memory_hotplug: ensure every online node has NORMAL memory

Old memory hotplug code and new online/movable may cause a online node
don't have any normal memory, but memory-management acts bad when we have
nodes which is online but don't have any normal memory.  Example: it may
cause a bound task fail on all kernel allocation and cause the task can't
create task or create other kernel object.

So we disable non-normal-memory-node here, we will enable it when we
prepared.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN mm/memory_hotplug.c~memory_hotplug-ensure-every-online-node-has-normal-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-ensure-every-online-node-has-normal-memory
+++ a/mm/memory_hotplug.c
@@ -581,6 +581,12 @@ static int online_pages_range(unsigned l
 	return 0;
 }
 
+/* ensure every online node has NORMAL memory */
+static bool can_online_high_movable(struct zone *zone)
+{
+	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+}
+
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
 	struct zone *zone, struct memory_notify *arg)
@@ -646,6 +652,12 @@ int __ref online_pages(unsigned long pfn
 	 */
 	zone = page_zone(pfn_to_page(pfn));
 
+	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
+	    !can_online_high_movable(zone)) {
+		unlock_memory_hotplug();
+		return -1;
+	}
+
 	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
 		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages)) {
 			unlock_memory_hotplug();
@@ -1054,6 +1066,30 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
+/* ensure the node has NORMAL memory if it is still online */
+static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
+{
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	unsigned long present_pages = 0;
+	enum zone_type zt;
+
+	for (zt = 0; zt <= ZONE_NORMAL; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+
+	if (present_pages > nr_pages)
+		return true;
+
+	present_pages = 0;
+	for (; zt <= ZONE_MOVABLE; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+
+	/*
+	 * we can't offline the last normal memory until all
+	 * higher memory is offlined.
+	 */
+	return present_pages == 0;
+}
+
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
 		struct zone *zone, struct memory_notify *arg)
@@ -1141,6 +1177,10 @@ static int __ref __offline_pages(unsigne
 	node = zone_to_nid(zone);
 	nr_pages = end_pfn - start_pfn;
 
+	ret = -EINVAL;
+	if (zone_idx(zone) <= ZONE_NORMAL && !can_offline_normal(zone, nr_pages))
+		goto out;
+
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE, true);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
linux-next.patch

