From: akpm@linux-foundation.org
Subject: - memoryless-nodes-drop-one-memoryless-node-boot-warning.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:33 -0700
Message-ID: <200708040515.l745FXqW011748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbXHDFPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless nodes: drop one memoryless node boot warning
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-drop-one-memoryless-node-boot-warning.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Memoryless nodes: drop one memoryless node boot warning
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

get_pfn_range_for_nid() is called multiple times for each node at boot time. 
Each time, it will warn about nodes with no memory, resulting in boot messages
like:

	Node 0 active with no memory
	Node 0 active with no memory
	Node 0 active with no memory
	Node 0 active with no memory
	Node 0 active with no memory
	Node 0 active with no memory
	On node 0 totalpages: 0
	Node 0 active with no memory
	Node 0 active with no memory
	  DMA zone: 0 pages used for memmap
	Node 0 active with no memory
	Node 0 active with no memory
	  Normal zone: 0 pages used for memmap
	Node 0 active with no memory
	Node 0 active with no memory
	  Movable zone: 0 pages used for memmap

and so on for each memoryless node.

We already have the "On node N totalpages: ..." and other related messages, so
drop the "Node N active with no memory" warnings.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~memoryless-nodes-drop-one-memoryless-node-boot-warning mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-drop-one-memoryless-node-boot-warning
+++ a/mm/page_alloc.c
@@ -3020,10 +3020,8 @@ void __meminit get_pfn_range_for_nid(uns
 		*end_pfn = max(*end_pfn, early_node_map[i].end_pfn);
 	}
 
-	if (*start_pfn == -1UL) {
-		printk(KERN_WARNING "Node %u active with no memory\n", nid);
+	if (*start_pfn == -1UL)
 		*start_pfn = 0;
-	}
 
 	/* Push the node boundaries out if requested */
 	account_node_boundary(nid, start_pfn, end_pfn);
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
