From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-remove-explicit-build=5Fall=5Fzonelist?=
 =?US-ASCII?Q?s-from-try=5Fonline=5Fnode.patch?= removed from -mm tree
Date: Thu, 07 Sep 2017 11:38:04 -0700
Message-ID: <20170907183804.DTAs4T5SO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755722AbdIGSiF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz


The patch titled
     Subject: mm, memory_hotplug: remove explicit build_all_zonelists from try_online_node
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: remove explicit build_all_zonelists from try_online_node

try_online_node calls hotadd_new_pgdat which already calls
build_all_zonelists.  So the additional call is redundant.  Even though
hotadd_new_pgdat will only initialize zonelists of the new node this is
the right thing to do because such a node doesn't have any memory so other
zonelists would ignore all the zones from this node anyway.

Link: http://lkml.kernel.org/r/20170721143915.14161-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node
+++ a/mm/memory_hotplug.c
@@ -1081,13 +1081,6 @@ int try_online_node(int nid)
 	node_set_online(nid);
 	ret = register_one_node(nid);
 	BUG_ON(ret);
-
-	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
-		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL);
-		mutex_unlock(&zonelists_mutex);
-	}
