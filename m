From: akpm@linux-foundation.org
Subject: [patch 030/102] mm, vmstat: suppress pcp stats for
 unpopulated zones in zoneinfo
Date: Wed, 03 May 2017 14:53:02 -0700
Message-ID: <20170503215302.lt_6be8P5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdECVxD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, vmstat: suppress pcp stats for unpopulated zones in zoneinfo

After "mm, vmstat: print non-populated zones in zoneinfo", /proc/zoneinfo
will show unpopulated zones.

The per-cpu pageset statistics are not relevant for unpopulated zones and
can be potentially lengthy, so supress them when they are not interesting.

Also moves lowmem reserve protection information above pcp stats since it
is relevant for all zones per vm.lowmem_reserve_ratio.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1703061400500.46428@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-suppress-pcp-stats-for-unpopulated-zones-in-zoneinfo mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-suppress-pcp-stats-for-unpopulated-zones-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1393,18 +1393,24 @@ static void zoneinfo_show_print(struct s
 		   zone->present_pages,
 		   zone->managed_pages);
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		seq_printf(m, "\n      %-12s %lu", vmstat_text[i],
-				zone_page_state(zone, i));
-
 	seq_printf(m,
 		   "\n        protection: (%ld",
 		   zone->lowmem_reserve[0]);
 	for (i = 1; i < ARRAY_SIZE(zone->lowmem_reserve); i++)
 		seq_printf(m, ", %ld", zone->lowmem_reserve[i]);
-	seq_printf(m,
-		   ")"
-		   "\n  pagesets");
+	seq_putc(m, ')');
+
+	/* If unpopulated, no other information is useful */
+	if (!populated_zone(zone)) {
+		seq_putc(m, '\n');
+		return;
+	}
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		seq_printf(m, "\n      %-12s %lu", vmstat_text[i],
+				zone_page_state(zone, i));
+
+	seq_printf(m, "\n  pagesets");
 	for_each_online_cpu(i) {
 		struct per_cpu_pageset *pageset;
 
_
