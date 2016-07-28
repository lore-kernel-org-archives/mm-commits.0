From: akpm@linux-foundation.org
Subject: [patch 054/101] mm: show node_pages_scanned per node, not zone
Date: Thu, 28 Jul 2016 15:47:14 -0700
Message-ID: <579a8b72.0o55wLn4eMMwcX2/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcG1WrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, mgorman@techsingularity.net

From: Minchan Kim <minchan@kernel.org>
Subject: mm: show node_pages_scanned per node, not zone

The node_pages_scanned represents the number of scanned pages of node for
reclaim so it's pointless to show it as kilobytes.

As well, node_pages_scanned is per-node value, not per-zone.

This patch changes node_pages_scanned per-zone-killobytes
with per-node-count.

[minchan@kernel.org: fix node_pages_scanned]
  Link: http://lkml.kernel.org/r/20160716101431.GA10305@bbox
Link: http://lkml.kernel.org/r/1468588165-12461-5-git-send-email-mgorman@techsingularity.net
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone
+++ a/mm/page_alloc.c
@@ -4313,6 +4313,7 @@ void show_free_areas(unsigned int filter
 #endif
 			" writeback_tmp:%lukB"
 			" unstable:%lukB"
+			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -4335,6 +4336,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
+			node_page_state(pgdat, NR_PAGES_SCANNED),
 			!pgdat_reclaimable(pgdat) ? "yes" : "no");
 	}
 
@@ -4365,7 +4367,6 @@ void show_free_areas(unsigned int filter
 			" free_pcp:%lukB"
 			" local_pcp:%ukB"
 			" free_cma:%lukB"
-			" node_pages_scanned:%lu"
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
@@ -4383,8 +4384,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
 			K(this_cpu_read(zone->pageset->pcp.count)),
-			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
-			K(node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED)));
+			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
 			printk(" %ld", zone->lowmem_reserve[i]);
_
