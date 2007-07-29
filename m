From: akpm@linux-foundation.org
Subject: + memoryless-nodes-drop-one-memoryless-node-boot-warning.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:16:16 -0700
Message-ID: <200707290716.l6T7GGme013260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760255AbXG2HQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com


The patch titled
     Memoryless nodes: drop one memoryless node boot warning
has been added to the -mm tree.  Its filename is
     memoryless-nodes-drop-one-memoryless-node-boot-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

numa-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior.patch
oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch
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
