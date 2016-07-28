From: akpm@linux-foundation.org
Subject: [patch 052/101] mm, page_alloc: fix dirtyable highmem calculation
Date: Thu, 28 Jul 2016 15:47:08 -0700
Message-ID: <579a8b6c.KCOUvMYYg+Ht7bAS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcG1WrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm, page_alloc: fix dirtyable highmem calculation

When I tested vmscale in mmtest in 32bit, I found the benchmark was slow
down 0.5 times.

                base        node
                   1    global-1
User           12.98       16.04
System        147.61      166.42
Elapsed        26.48       38.08

With vmstat, I found IO wait avg is much increased compared to base.

The reason was highmem_dirtyable_memory accumulates free pages and
highmem_file_pages from HIGHMEM to MOVABLE zones which was wrong. With
that, dirth_thresh in throtlle_vm_write is always 0 so that it calls
congestion_wait frequently if writeback starts.

With this patch, it is much recovered.

                base        node          fi
                   1    global-1         fix
User           12.98       16.04       13.78
System        147.61      166.42      143.92
Elapsed        26.48       38.08       29.64

Link: http://lkml.kernel.org/r/1468404004-5085-4-git-send-email-mgorman@techsingularity.net
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/page-writeback.c~mm-page_alloc-fix-dirtyable-highmem-calculation mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page_alloc-fix-dirtyable-highmem-calculation
+++ a/mm/page-writeback.c
@@ -307,27 +307,31 @@ static unsigned long highmem_dirtyable_m
 {
 #ifdef CONFIG_HIGHMEM
 	int node;
-	unsigned long x = 0;
+	unsigned long x;
 	int i;
-	unsigned long dirtyable = atomic_read(&highmem_file_pages);
+	unsigned long dirtyable = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
 		for (i = ZONE_NORMAL + 1; i < MAX_NR_ZONES; i++) {
 			struct zone *z;
+			unsigned long nr_pages;
 
 			if (!is_highmem_idx(i))
 				continue;
 
 			z = &NODE_DATA(node)->node_zones[i];
-			dirtyable += zone_page_state(z, NR_FREE_PAGES);
+			if (!populated_zone(z))
+				continue;
 
+			nr_pages = zone_page_state(z, NR_FREE_PAGES);
 			/* watch for underflows */
-			dirtyable -= min(dirtyable, high_wmark_pages(z));
