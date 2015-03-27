From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch added to -mm tree
Date: Fri, 27 Mar 2015 15:33:34 -0700
Message-ID: <5515dabe.Q7Ek8eYHpLTwBlnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbC0Wdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 18:33:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@linux.vnet.ibm.com, anton@samba.org, dave.hansen@intel.com, ddstreet@ieee.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not throttle based on pfmemalloc reserves if node has no reclaimable pages
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: mm: vmscan: do not throttle based on pfmemalloc reserves if node has no reclaimable pages

Based upon 675becce15 ("mm: vmscan: do not throttle based on pfmemalloc
reserves if node has no ZONE_NORMAL") from Mel.

We have a system with the following topology:

# numactl -H
available: 3 nodes (0,2-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
23 24 25 26 27 28 29 30 31
node 0 size: 28273 MB
node 0 free: 27323 MB
node 2 cpus:
node 2 size: 16384 MB
node 2 free: 0 MB
node 3 cpus: 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
node 3 size: 30533 MB
node 3 free: 13273 MB
node distances:
node   0   2   3
  0:  10  20  20
  2:  20  10  20
  3:  20  20  10

Node 2 has no free memory, because:
# cat /sys/devices/system/node/node2/hugepages/hugepages-16777216kB/nr_hugepages
1

This leads to the following zoneinfo:

Node 2, zone      DMA
  pages free     0
        min      1840
        low      2300
        high     2760
        scanned  0
        spanned  262144
        present  262144
        managed  262144
...
  all_unreclaimable: 1

If one then attempts to allocate some normal 16M hugepages via

echo 37 > /proc/sys/vm/nr_hugepages

The echo never returns and kswapd2 consumes CPU cycles.

This is because throttle_direct_reclaim ends up calling
wait_event(pfmemalloc_wait, pfmemalloc_watermark_ok...). 
pfmemalloc_watermark_ok() in turn checks all zones on the node if there
are any reserves, and if so, then indicates the watermarks are ok, by
seeing if there are sufficient free pages.

675becce15 added a condition already for memoryless nodes.  In this case,
though, the node has memory, it is just all consumed (and not
reclaimable).  Effectively, though, the result is the same on this call to
pfmemalloc_watermark_ok() and thus seems like a reasonable additional
condition.

With this change, the afore-mentioned 16M hugepage allocation attempt
succeeds and correctly round-robins between Nodes 1 and 3.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Anton Blanchard <anton@samba.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages
+++ a/mm/vmscan.c
@@ -2646,7 +2646,8 @@ static bool pfmemalloc_watermark_ok(pg_d
 
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
-		if (!populated_zone(zone))
+		if (!populated_zone(zone) ||
+		    zone_reclaimable_pages(zone) == 0)
 			continue;
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
_

Patches currently in -mm which might be from nacc@linux.vnet.ibm.com are

mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
linux-next.patch

