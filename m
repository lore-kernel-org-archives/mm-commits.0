From: akpm@linux-foundation.org
Subject: [patch 089/117] mm, page_alloc: reduce branches in
 zone_statistics
Date: Thu, 19 May 2016 17:13:24 -0700
Message-ID: <573e56a4.noU8GqDO/QQgKDfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbcETANZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: reduce branches in zone_statistics

zone_statistics has more branches than it really needs to take an unlikely
GFP flag into account.  Reduce the number and annotate the unlikely flag.

The performance difference on a page allocator microbenchmark is;

                                           4.6.0-rc2                  4.6.0-rc2
                                    nocompound-v1r10           statbranch-v1r10
Min      alloc-odr0-1               417.00 (  0.00%)           419.00 ( -0.48%)
Min      alloc-odr0-2               308.00 (  0.00%)           305.00 (  0.97%)
Min      alloc-odr0-4               253.00 (  0.00%)           250.00 (  1.19%)
Min      alloc-odr0-8               221.00 (  0.00%)           219.00 (  0.90%)
Min      alloc-odr0-16              205.00 (  0.00%)           203.00 (  0.98%)
Min      alloc-odr0-32              199.00 (  0.00%)           195.00 (  2.01%)
Min      alloc-odr0-64              193.00 (  0.00%)           191.00 (  1.04%)
Min      alloc-odr0-128             191.00 (  0.00%)           189.00 (  1.05%)
Min      alloc-odr0-256             200.00 (  0.00%)           198.00 (  1.00%)
Min      alloc-odr0-512             212.00 (  0.00%)           210.00 (  0.94%)
Min      alloc-odr0-1024            219.00 (  0.00%)           216.00 (  1.37%)
Min      alloc-odr0-2048            225.00 (  0.00%)           221.00 (  1.78%)
Min      alloc-odr0-4096            231.00 (  0.00%)           227.00 (  1.73%)
Min      alloc-odr0-8192            234.00 (  0.00%)           232.00 (  0.85%)
Min      alloc-odr0-16384           234.00 (  0.00%)           232.00 (  0.85%)

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/vmstat.c~mm-page_alloc-reduce-branches-in-zone_statistics mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-reduce-branches-in-zone_statistics
+++ a/mm/vmstat.c
@@ -581,17 +581,21 @@ void drain_zonestat(struct zone *zone, s
  */
 void zone_statistics(struct zone *preferred_zone, struct zone *z, gfp_t flags)
 {
-	if (z->zone_pgdat == preferred_zone->zone_pgdat) {
+	int local_nid = numa_node_id();
+	enum zone_stat_item local_stat = NUMA_LOCAL;
+
+	if (unlikely(flags & __GFP_OTHER_NODE)) {
+		local_stat = NUMA_OTHER;
+		local_nid = preferred_zone->node;
+	}
+
+	if (z->node == local_nid) {
 		__inc_zone_state(z, NUMA_HIT);
+		__inc_zone_state(z, local_stat);
 	} else {
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
-	if (z->node == ((flags & __GFP_OTHER_NODE) ?
-			preferred_zone->node : numa_node_id()))
-		__inc_zone_state(z, NUMA_LOCAL);
-	else
-		__inc_zone_state(z, NUMA_OTHER);
 }
 
 /*
_
