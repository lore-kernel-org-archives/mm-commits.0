From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:36 -0700
Message-ID: <579ba6a8.5DHXfAkmLy/MgU02%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcG2Szh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: print node-based stats in zoneinfo file
has been removed from the -mm tree.  Its filename was
     mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmstat: print node-based stats in zoneinfo file

There are a number of stats that were previously accessible via zoneinfo
that are now invisible. While it is possible to create a new file for the
node stats, this may be missed by users. Instead this patch prints the
stats under the first populated zone in /proc/zoneinfo.

Link: http://lkml.kernel.org/r/1467970510-21195-34-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN mm/vmstat.c~mm-vmstat-print-node-based-stats-in-zoneinfo-file mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-print-node-based-stats-in-zoneinfo-file
+++ a/mm/vmstat.c
@@ -1415,11 +1415,35 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
+static bool is_zone_first_populated(pg_data_t *pgdat, struct zone *zone)
+{
+	int zid;
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *compare = &pgdat->node_zones[zid];
+
+		if (populated_zone(compare))
+			return zone == compare;
+	}
+
+	/* The zone must be somewhere! */
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 							struct zone *zone)
 {
 	int i;
 	seq_printf(m, "Node %d, zone %8s", pgdat->node_id, zone->name);
+	if (is_zone_first_populated(pgdat, zone)) {
+		seq_printf(m, "\n  per-node stats");
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+			seq_printf(m, "\n      %-12s %lu",
+				vmstat_text[i + NR_VM_ZONE_STAT_ITEMS],
+				node_page_state(pgdat, i));
+		}
+	}
 	seq_printf(m,
 		   "\n  pages free     %lu"
 		   "\n        min      %lu"
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


