From: akpm@linux-foundation.org
Subject: - memoryless-nodes-no-need-for-kswapd.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:15 -0700
Message-ID: <200708040515.l745FFC2011720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbXHDFPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless Nodes: No need for kswapd
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-no-need-for-kswapd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Memoryless Nodes: No need for kswapd
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

A node without memory does not need a kswapd.  So use the memory map instead
of the online map when starting kswapd.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~memoryless-nodes-no-need-for-kswapd mm/vmscan.c
--- a/mm/vmscan.c~memoryless-nodes-no-need-for-kswapd
+++ a/mm/vmscan.c
@@ -1705,7 +1705,7 @@ static int __init kswapd_init(void)
 	int nid;
 
 	swap_setup();
-	for_each_online_node(nid)
+	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	hotcpu_notifier(cpu_callback, 0);
 	return 0;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
