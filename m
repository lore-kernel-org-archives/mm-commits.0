From: akpm@linux-foundation.org
Subject: - memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:48:54 -0700
Message-ID: <200710212348.l9LNmsrR000743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbXJUXz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, balbir@linux.vnet.ibm.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     Memory Controller: initialize all scan_control's isolate_pages member
has been removed from the -mm tree.  Its filename was
     memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch

This patch was dropped because it was folded into memory-controller-add-per-container-lru-and-reclaim-v7.patch

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
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-fix-2
+++ a/mm/vmscan.c
@@ -1728,6 +1728,7 @@ unsigned long shrink_all_memory(unsigned
 		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
 		.swappiness = vm_swappiness,
+		.isolate_pages = isolate_pages_global,
 	};
 
 	current->reclaim_state = &reclaim_state;
@@ -1913,6 +1914,7 @@ static int __zone_reclaim(struct zone *z
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
+		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
