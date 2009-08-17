From: akpm@linux-foundation.org
Subject: + mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:35:07 -0700
Message-ID: <200908172135.n7HLZ73J012800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbZHQVfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bo-liu@hotmail.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()
has been added to the -mm tree.  Its filename is
     mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists.patch

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
Subject: mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()
From: Bo Liu <bo-liu@hotmail.com>

If node_load[] is cleared everytime build_zonelists() is
called,node_load[] will have no help to find the next node that should
appear in the given node's fallback list.

Signed-off-by: Bo Liu <bo-liu@hotmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists mm/page_alloc.c
--- a/mm/page_alloc.c~mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists
+++ a/mm/page_alloc.c
@@ -2620,7 +2620,6 @@ static void build_zonelists(pg_data_t *p
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
-	memset(node_load, 0, sizeof(node_load));
 	memset(node_order, 0, sizeof(node_order));
 	j = 0;
 
@@ -2729,6 +2728,7 @@ static int __build_all_zonelists(void *d
 {
 	int nid;
 
+	memset(node_load, 0, sizeof(node_load));
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 
_

Patches currently in -mm which might be from bo-liu@hotmail.com are

mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists.patch

