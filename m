From: akpm@linux-foundation.org
Subject: [merged] x86-only-clear-node_states-for-64bit.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:25 -0700
Message-ID: <200907011727.n61HRPi0002237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670AbZGAR2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, cl@linux-foundation.org, mingo@elte.hu, ntl@pobox.com, mm-commits@vger.kernel.org


The patch titled
     x86: only clear node_states for 64bit
has been removed from the -mm tree.  Its filename was
     x86-only-clear-node_states-for-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: only clear node_states for 64bit
From: Yinghai Lu <yinghai@kernel.org>

Nathan reported that

| commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
| Author: Yinghai Lu <yinghai@kernel.org>
| Date:   Tue Jun 16 15:33:00 2009 -0700
|
|    page-allocator: clear N_HIGH_MEMORY map before we set it again
|
|    SRAT tables may contains nodes of very small size.  The arch code may
|    decide to not activate such a node.  However, currently the early boot
|    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
|    active although these nodes have no present pages.
|
|    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too

unintentionally and incorrectly clears the cpuset.mems cgroup attribute on
an i386 kvm guest, meaning that cpuset.mems can not be used.

Fix this by only clearing node_states[N_NORMAL_MEMORY] for 64bit only. 
and need to do save/restore for that in find_zone_movable_pfn

Reported-by: Nathan Lynch <ntl@pobox.com>
Tested-by: Nathan Lynch <ntl@pobox.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 ++
 mm/page_alloc.c       |   13 +++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-only-clear-node_states-for-64bit arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-only-clear-node_states-for-64bit
+++ a/arch/x86/mm/init_64.c
@@ -598,6 +598,8 @@ void __init paging_init(void)
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
+	/* clear the default setting with node 0 */
+	nodes_clear(node_states[N_NORMAL_MEMORY]);
 	free_area_init_nodes(max_zone_pfns);
 }
 
diff -puN mm/page_alloc.c~x86-only-clear-node_states-for-64bit mm/page_alloc.c
--- a/mm/page_alloc.c~x86-only-clear-node_states-for-64bit
+++ a/mm/page_alloc.c
@@ -4032,6 +4032,8 @@ static void __init find_zone_movable_pfn
 	int i, nid;
 	unsigned long usable_startpfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
+	/* save the state before borrow the nodemask */
+	nodemask_t saved_node_state = node_states[N_HIGH_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
 
@@ -4059,7 +4061,7 @@ static void __init find_zone_movable_pfn
 
 	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
 	if (!required_kernelcore)
-		return;
+		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
 	find_usable_zone_for_movable();
@@ -4158,6 +4160,10 @@ restart:
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
+
+out:
+	/* restore the node_state */
+	node_states[N_HIGH_MEMORY] = saved_node_state;
 }
 
 /* Any regular memory on that node ? */
@@ -4242,11 +4248,6 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
-	/*
-	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
-	 * that node_mask, clear it at first
-	 */
-	nodes_clear(node_states[N_HIGH_MEMORY]);
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch

