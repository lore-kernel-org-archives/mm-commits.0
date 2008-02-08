From: akpm@linux-foundation.org
Subject: - memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:04 -0800
Message-ID: <200802080803.m1883joc014148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933233AbYBHIY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:24:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     memory cgroup enhancements: fix zone handling in try_to_free_mem_cgroup_page
has been removed from the -mm tree.  Its filename was
     memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory cgroup enhancements: fix zone handling in try_to_free_mem_cgroup_page
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Because NODE_DATA(node)->node_zonelists[] is guaranteed to contain all
necessary zones, it is not necessary to use for_each_online_node.

And this for_each_online_node() makes reclaim routine start always
from node 0. This is not good. This patch makes reclaim start from
caller's node and just use usual (default) zonelist order.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page mm/vmscan.c
--- a/mm/vmscan.c~memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page
+++ a/mm/vmscan.c
@@ -1365,15 +1365,12 @@ unsigned long try_to_free_mem_cgroup_pag
 		.mem_cgroup = mem_cont,
 		.isolate_pages = mem_cgroup_isolate_pages,
 	};
-	int node;
 	struct zone **zones;
 	int target_zone = gfp_zone(GFP_HIGHUSER_MOVABLE);
 
-	for_each_online_node(node) {
-		zones = NODE_DATA(node)->node_zonelists[target_zone].zones;
-		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
-			return 1;
-	}
+	zones = NODE_DATA(numa_node_id())->node_zonelists[target_zone].zones;
+	if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
+		return 1;
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
