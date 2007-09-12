From: akpm@linux-foundation.org
Subject: + memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch added to -mm tree
Date: Wed, 12 Sep 2007 15:04:08 -0700
Message-ID: <200709122204.l8CM48KG021431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47372 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbXILWE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 18:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, balbir@linux.vnet.ibm.com, lee.schermerhorn@hp.com


The patch titled
     Memory Controller: initialize all scan_control's isolate_pages member
has been added to the -mm tree.  Its filename is
     memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memory Controller: initialize all scan_control's isolate_pages member
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

We need to initialize all scan_controls' isolate_pages member.  Otherwise,
shrink_active_list() attempts to execute at undefined location.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-fix-2
+++ a/mm/vmscan.c
@@ -1751,6 +1751,7 @@ unsigned long shrink_all_memory(unsigned
 		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
 		.swappiness = vm_swappiness,
+		.isolate_pages = isolate_pages_global,
 	};
 
 	current->reclaim_state = &reclaim_state;
@@ -1934,6 +1935,7 @@ static int __zone_reclaim(struct zone *z
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
+		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
