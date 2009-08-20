From: akpm@linux-foundation.org
Subject: [merged] mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:13:04 -0700
Message-ID: <200908202013.n7KKD4wr016035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbZHTUTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bo-liu@hotmail.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()
has been removed from the -mm tree.  Its filename was
     mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()
From: Bo Liu <bo-liu@hotmail.com>

If node_load[] is cleared everytime build_zonelists() is
called,node_load[] will have no help to find the next node that should
appear in the given node's fallback list.

Because of the bug, zonelist's node_order is not calculated as expected. 
This bug affects on big machine, which has asynmetric node distance.

[synmetric NUMA's node distance]
     0    1    2
0   10   12   12
1   12   10   12
2   12   12   10

[asynmetric NUMA's node distance]
     0    1    2
0   10   12   20
1   12   10   14
2   20   14   10


This (my bug) is very old but no one has reported this for a long time. 
Maybe because the number of asynmetric NUMA is very small and they use
cpuset for customizing node memory allocation fallback.

[akpm@linux-foundation.org: fix CONFIG_NUMA=n build]
Signed-off-by: Bo Liu <bo-liu@hotmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists mm/page_alloc.c
--- a/mm/page_alloc.c~mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists
+++ a/mm/page_alloc.c
@@ -2544,7 +2544,6 @@ static void build_zonelists(pg_data_t *p
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
-	memset(node_load, 0, sizeof(node_load));
 	memset(node_order, 0, sizeof(node_order));
 	j = 0;
 
@@ -2653,6 +2652,9 @@ static int __build_all_zonelists(void *d
 {
 	int nid;
 
+#ifdef CONFIG_NUMA
+	memset(node_load, 0, sizeof(node_load));
+#endif
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 
_

Patches currently in -mm which might be from bo-liu@hotmail.com are

origin.patch

