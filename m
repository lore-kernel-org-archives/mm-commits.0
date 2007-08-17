From: akpm@linux-foundation.org
Subject: + memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:32:46 -0700
Message-ID: <200708172032.l7HKWkDI028171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbXHQUc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     memoryless nodes: fixup uses of node_online_map in generic code
has been added to the -mm tree.  Its filename is
     memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memoryless nodes: fixup uses of node_online_map in generic code
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Here's a cut at fixing up uses of the online node map in generic code. 

mm/swap_prefetch.c:clear_last_prefetch_free()
                   clear_last_current_free()

	use nodes with memory for prefetch nodes.
	just in case ...

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_prefetch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swap_prefetch.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch
+++ a/mm/swap_prefetch.c
@@ -249,7 +249,7 @@ static void clear_last_prefetch_free(voi
 	 * Reset the nodes suitable for prefetching to all nodes. We could
 	 * update the data to take into account memory hotplug if desired..
 	 */
-	sp_stat.prefetch_nodes = node_online_map;
+	sp_stat.prefetch_nodes = node_states[N_HIGH_MEMORY];
 	for_each_node_mask(node, sp_stat.prefetch_nodes) {
 		struct node_stats *ns = &sp_stat.node[node];
 
@@ -261,7 +261,7 @@ static void clear_current_prefetch_free(
 {
 	int node;
 
-	sp_stat.prefetch_nodes = node_online_map;
+	sp_stat.prefetch_nodes = node_states[N_HIGH_MEMORY];
 	for_each_node_mask(node, sp_stat.prefetch_nodes) {
 		struct node_stats *ns = &sp_stat.node[node];
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

document-linux-memory-policy-v3.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
