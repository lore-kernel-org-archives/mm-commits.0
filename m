From: akpm@linux-foundation.org
Subject: [merged] page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:06 -0700
Message-ID: <200906171836.n5HIa6Hf002089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757229AbZFQSrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, Yinghai@kernel.org, cl@linux-foundation.org, mel@csn.ul.ie, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: clear N_HIGH_MEMORY map before we set it again
has been removed from the -mm tree.  Its filename was
     page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: clear N_HIGH_MEMORY map before we set it again
From: Yinghai Lu <yinghai@kernel.org>

SRAT tables may contains nodes of very small size.  The arch code may
decide to not activate such a node.  However, currently the early boot
code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
active although these nodes have no present pages.

For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too

Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~page-allocator-clear-n_high_memory-map-before-se-set-it-again mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-clear-n_high_memory-map-before-se-set-it-again
+++ a/mm/page_alloc.c
@@ -4204,6 +4204,11 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
+	/*
+	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
+	 * that node_mask, clear it at first
+	 */
+	nodes_clear(node_states[N_HIGH_MEMORY]);
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch

