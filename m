From: akpm@linux-foundation.org
Subject: + memory_hotplug-fix-possible-incorrect-node_states.patch added to -mm tree
Date: Wed, 24 Oct 2012 13:17:35 -0700
Message-ID: <20121024201736.4CA471E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44049 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789Ab2JXURi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 16:17:38 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so106175ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 13:17:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, gregkh@suse.de, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kay.sievers@vrfy.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rob@landley.net, wency@cn.fujitsu.com


The patch titled
     Subject: memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMORY]
has been added to the -mm tree.  Its filename is
     memory_hotplug-fix-possible-incorrect-node_states.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMORY]

Currently memory_hotplug only manages the node_states[N_HIGH_MEMORY], it
forgets to manage node_states[N_NORMAL_MEMORY].  This may cause
node_states[N_NORMAL_MEMORY] to become incorrect.

Example, if a node is empty before online, and we online a memory which is
in ZONE_NORMAL.  And after online, node_states[N_HIGH_MEMORY] is correct,
but node_states[N_NORMAL_MEMORY] is incorrect, the online code doesn't set
the new online node to node_states[N_NORMAL_MEMORY].

The same thing will happen when offlining (the offline code doesn't clear
the node from node_states[N_NORMAL_MEMORY] when needed).  Some memory
managment code depends node_states[N_NORMAL_MEMORY], so we have to fix up
the node_states[N_NORMAL_MEMORY].

We add node_states_check_changes_online() and
node_states_check_changes_offline() to detect whether
node_states[N_HIGH_MEMORY] and node_states[N_NORMAL_MEMORY] are changed
while hotpluging.

Also add @status_change_nid_normal to struct memory_notify, thus the
memory hotplug callbacks know whether the node_states[N_NORMAL_MEMORY] are
changed.  (We can add a @flags and reuse @status_change_nid instead of
introducing @status_change_nid_normal, but it will add much more
complexity in memory hotplug callback in every subsystem.  So introducing
@status_change_nid_normal is better and it doesn't change the sematics of
@status_change_nid)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Rob Landley <rob@landley.net>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |    5 -
 include/linux/memory.h           |    1 
 mm/memory_hotplug.c              |  136 +++++++++++++++++++++++++----
 3 files changed, 125 insertions(+), 17 deletions(-)

diff -puN Documentation/memory-hotplug.txt~memory_hotplug-fix-possible-incorrect-node_states Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory_hotplug-fix-possible-incorrect-node_states
+++ a/Documentation/memory-hotplug.txt
@@ -377,15 +377,18 @@ The third argument is passed by pointer 
 struct memory_notify {
        unsigned long start_pfn;
        unsigned long nr_pages;
+       int status_change_nid_normal;
        int status_change_nid;
 }
 
 start_pfn is start_pfn of online/offline memory.
 nr_pages is # of pages of online/offline memory.
+status_change_nid_normal is set node id when N_NORMAL_MEMORY of nodemask
+is (will be) set/clear, if this is -1, then nodemask status is not changed.
 status_change_nid is set node id when N_HIGH_MEMORY of nodemask is (will be)
 set/clear. It means a new(memoryless) node gets new memory by online and a
 node loses all memory. If this is -1, then nodemask status is not changed.
-If status_changed_nid >= 0, callback should create/discard structures for the
+If status_changed_nid* >= 0, callback should create/discard structures for the
 node if necessary.
 
 --------------
diff -puN include/linux/memory.h~memory_hotplug-fix-possible-incorrect-node_states include/linux/memory.h
--- a/include/linux/memory.h~memory_hotplug-fix-possible-incorrect-node_states
+++ a/include/linux/memory.h
@@ -53,6 +53,7 @@ int arch_get_memory_phys_device(unsigned
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
+	int status_change_nid_normal;
 	int status_change_nid;
 };
 
diff -puN mm/memory_hotplug.c~memory_hotplug-fix-possible-incorrect-node_states mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-fix-possible-incorrect-node_states
+++ a/mm/memory_hotplug.c
@@ -467,6 +467,53 @@ static int online_pages_range(unsigned l
 	return 0;
 }
 
+/* check which state of node_states will be changed when online memory */
+static void node_states_check_changes_online(unsigned long nr_pages,
+	struct zone *zone, struct memory_notify *arg)
+{
+	int nid = zone_to_nid(zone);
+	enum zone_type zone_last = ZONE_NORMAL;
+
+	/*
+	 * If we have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
+	 * which have 0...ZONE_NORMAL, set zone_last to ZONE_NORMAL.
+	 *
+	 * If we don't have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
+	 * which have 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
+	 */
+	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
+		zone_last = ZONE_MOVABLE;
+
+	/*
+	 * if the memory to be online is in a zone of 0...zone_last, and
+	 * the zones of 0...zone_last don't have memory before online, we will
+	 * need to set the node to node_states[N_NORMAL_MEMORY] after
+	 * the memory is online.
+	 */
+	if (zone_idx(zone) <= zone_last && !node_state(nid, N_NORMAL_MEMORY))
+		arg->status_change_nid_normal = nid;
+	else
+		arg->status_change_nid_normal = -1;
+
+	/*
+	 * if the node don't have memory befor online, we will need to
+	 * set the node to node_states[N_HIGH_MEMORY] after the memory
+	 * is online.
+	 */
+	if (!node_state(nid, N_HIGH_MEMORY))
+		arg->status_change_nid = nid;
+	else
+		arg->status_change_nid = -1;
+}
+
+static void node_states_set_node(int node, struct memory_notify *arg)
+{
+	if (arg->status_change_nid_normal >= 0)
+		node_set_state(node, N_NORMAL_MEMORY);
+
+	node_set_state(node, N_HIGH_MEMORY);
+}
+
 
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 {
@@ -478,13 +525,18 @@ int __ref online_pages(unsigned long pfn
 	struct memory_notify arg;
 
 	lock_memory_hotplug();
+	/*
+	 * This doesn't need a lock to do pfn_to_page().
+	 * The section can't be removed here because of the
+	 * memory_block->state_mutex.
+	 */
+	zone = page_zone(pfn_to_page(pfn));
+
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
-	arg.status_change_nid = -1;
+	node_states_check_changes_online(nr_pages, zone, &arg);
 
 	nid = page_to_nid(pfn_to_page(pfn));
-	if (node_present_pages(nid) == 0)
-		arg.status_change_nid = nid;
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
@@ -494,12 +546,6 @@ int __ref online_pages(unsigned long pfn
 		return ret;
 	}
 	/*
-	 * This doesn't need a lock to do pfn_to_page().
-	 * The section can't be removed here because of the
-	 * memory_block->state_mutex.
-	 */
-	zone = page_zone(pfn_to_page(pfn));
-	/*
 	 * If this zone is not populated, then it is not in zonelist.
 	 * This means the page allocator ignores this zone.
 	 * So, zonelist must be updated after online.
@@ -528,7 +574,7 @@ int __ref online_pages(unsigned long pfn
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 	if (onlined_pages) {
-		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+		node_states_set_node(zone_to_nid(zone), &arg);
 		if (need_zonelists_rebuild)
 			build_all_zonelists(NULL, NULL);
 		else
@@ -878,6 +924,67 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
+/* check which state of node_states will be changed when offline memory */
+static void node_states_check_changes_offline(unsigned long nr_pages,
+		struct zone *zone, struct memory_notify *arg)
+{
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	unsigned long present_pages = 0;
+	enum zone_type zt, zone_last = ZONE_NORMAL;
+
+	/*
+	 * If we have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
+	 * which have 0...ZONE_NORMAL, set zone_last to ZONE_NORMAL.
+	 *
+	 * If we don't have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
+	 * which have 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
+	 */
+	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
+		zone_last = ZONE_MOVABLE;
+
+	/*
+	 * check whether node_states[N_NORMAL_MEMORY] will be changed.
+	 * If the memory to be offline is in a zone of 0...zone_last,
+	 * and it is the last present memory, 0...zone_last will
+	 * become empty after offline , thus we can determind we will
+	 * need to clear the node from node_states[N_NORMAL_MEMORY].
+	 */
+	for (zt = 0; zt <= zone_last; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+	if (zone_idx(zone) <= zone_last && nr_pages >= present_pages)
+		arg->status_change_nid_normal = zone_to_nid(zone);
+	else
+		arg->status_change_nid_normal = -1;
+
+	/*
+	 * node_states[N_HIGH_MEMORY] contains nodes which have 0...ZONE_MOVABLE
+	 */
+	zone_last = ZONE_MOVABLE;
+
+	/*
+	 * check whether node_states[N_HIGH_MEMORY] will be changed
+	 * If we try to offline the last present @nr_pages from the node,
+	 * we can determind we will need to clear the node from
+	 * node_states[N_HIGH_MEMORY].
+	 */
+	for (; zt <= zone_last; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+	if (nr_pages >= present_pages)
+		arg->status_change_nid = zone_to_nid(zone);
+	else
+		arg->status_change_nid = -1;
+}
+
+static void node_states_clear_node(int node, struct memory_notify *arg)
+{
+	if (arg->status_change_nid_normal >= 0)
+		node_clear_state(node, N_NORMAL_MEMORY);
+
+	if ((N_HIGH_MEMORY != N_NORMAL_MEMORY) &&
+	    (arg->status_change_nid >= 0))
+		node_clear_state(node, N_HIGH_MEMORY);
+}
+
 static int __ref __offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
@@ -912,9 +1019,7 @@ static int __ref __offline_pages(unsigne
 
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
-	arg.status_change_nid = -1;
-	if (nr_pages >= node_present_pages(node))
-		arg.status_change_nid = node;
+	node_states_check_changes_offline(nr_pages, zone, &arg);
 
 	ret = memory_notify(MEM_GOING_OFFLINE, &arg);
 	ret = notifier_to_errno(ret);
@@ -987,10 +1092,9 @@ repeat:
 	} else
 		zone_pcp_update(zone);
 
-	if (!node_present_pages(node)) {
-		node_clear_state(node, N_HIGH_MEMORY);
+	node_states_clear_node(node, &arg);
+	if (arg.status_change_nid >= 0)
 		kswapd_stop(node);
-	}
 
 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch

