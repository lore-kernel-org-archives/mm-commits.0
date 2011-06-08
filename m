From: akpm@linux-foundation.org
Subject: + mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch added to -mm tree
Date: Tue, 07 Jun 2011 18:36:20 -0700
Message-ID: <201106080135.p581ZGDQ007973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab1FHBfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 21:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, dave@linux.vnet.ibm.com, mel@csn.ul.ie


The patch titled
     mm/memory_hotplug.c: fix building of node hotplug zonelist
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memory_hotplug.c: fix building of node hotplug zonelist
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

During memory hotplug we refresh zonelists when we online a page in a new
zone.  It means that the node's zonelist is not initialized until pages
are onlined.  So for example, "nid" passed by MEM_GOING_ONLINE notifier
will point to NODE_DATA(nid) which has no zone fallback list.  Moreover,
if we hot-add cpu-only nodes, alloc_pages() will do no fallback.

This patch makes a zonelist when a new pgdata is available.

Note: in production, at fujitsu, memory should be onlined before cpu
      and our server didn't have any memory-less nodes and had no problems.

      But recent changes in MEM_GOING_ONLINE+page_cgroup
      will access not initialized zonelist of node.
      Anyway, there are memory-less node and we need some care.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist
+++ a/mm/memory_hotplug.c
@@ -494,6 +494,12 @@ static pg_data_t __ref *hotadd_new_pgdat
 	/* init node's zones as empty zones, we don't have any present pages.*/
 	free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 
+	/*
+	 * The node we allocated has no zone fallback lists. For avoiding
+	 * to access not-initialized zonelist, build here.
+	 */
+	build_all_zonelists(NULL);
+
 	return pgdat;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch

