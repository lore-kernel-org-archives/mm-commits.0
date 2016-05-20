From: akpm@linux-foundation.org
Subject: [patch 068/117] mm/writeback: correct dirty page calculation for
 highmem
Date: Thu, 19 May 2016 17:12:20 -0700
Message-ID: <573e5664.DWJUVbvp/JfL3EE9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcETAMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/writeback: correct dirty page calculation for highmem

ZONE_MOVABLE could be treated as highmem so we need to consider it for
accurate calculation of dirty pages.  And, in following patches, ZONE_CMA
will be introduced and it can be treated as highmem, too.  So, instead of
manually adding stat of ZONE_MOVABLE, looping all zones and check whether
the zone is highmem or not and add stat of the zone which can be treated
as highmem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-writeback-correct-dirty-page-calculation-for-highmem mm/page-writeback.c
--- a/mm/page-writeback.c~mm-writeback-correct-dirty-page-calculation-for-highmem
+++ a/mm/page-writeback.c
@@ -296,11 +296,15 @@ static unsigned long highmem_dirtyable_m
 #ifdef CONFIG_HIGHMEM
 	int node;
 	unsigned long x = 0;
+	int i;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z = &NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			struct zone *z = &NODE_DATA(node)->node_zones[i];
 
-		x += zone_dirtyable_memory(z);
+			if (is_highmem(z))
+				x += zone_dirtyable_memory(z);
+		}
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
_
