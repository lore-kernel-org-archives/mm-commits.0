From: akpm@linux-foundation.org
Subject: [nacked] mm-buddy-get-the-allownodes-for-dump-at-once.patch removed from -mm tree
Date: Thu, 21 Jun 2012 14:01:12 -0700
Message-ID: <20120621210112.9300BA04A3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52474 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270Ab2FUVBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 17:01:14 -0400
Received: by qcsp5 with SMTP id p5so118318qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 14:01:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/buddy: get the allownodes for dump at once
has been removed from the -mm tree.  Its filename was
     mm-buddy-get-the-allownodes-for-dump-at-once.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/buddy: get the allownodes for dump at once

When dumping the statistics for zones in the allowed nodes in the function
show_free_areas(), skip_free_areas_node() got called for multiple times to
figure out the same information: the allowed nodes for dump.  It's
reasonable to get the allowed nodes at once.  That will also help to get
consistent dump information.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-buddy-get-the-allownodes-for-dump-at-once mm/page_alloc.c
--- a/mm/page_alloc.c~mm-buddy-get-the-allownodes-for-dump-at-once
+++ a/mm/page_alloc.c
@@ -2763,11 +2763,19 @@ out:
  */
 void show_free_areas(unsigned int filter)
 {
-	int cpu;
+	int nid, cpu;
+	nodemask_t allownodes;
 	struct zone *zone;
 
+	/* Figure out the allowed nodes for dump */
+	nodes_clear(allownodes);
+	for_each_online_node(nid) {
+		if (!skip_free_areas_node(filter, nid))
+			node_set(nid, allownodes);
+	}
+
 	for_each_populated_zone(zone) {
-		if (skip_free_areas_node(filter, zone_to_nid(zone)))
+		if (!node_isset(zone_to_nid(zone), allownodes))
 			continue;
 		show_node(zone);
 		printk("%s per-cpu:\n", zone->name);
@@ -2810,7 +2818,7 @@ void show_free_areas(unsigned int filter
 	for_each_populated_zone(zone) {
 		int i;
 
-		if (skip_free_areas_node(filter, zone_to_nid(zone)))
+		if (!node_isset(zone_to_nid(zone), allownodes))
 			continue;
 		show_node(zone);
 		printk("%s"
@@ -2879,7 +2887,7 @@ void show_free_areas(unsigned int filter
 	for_each_populated_zone(zone) {
  		unsigned long nr[MAX_ORDER], flags, order, total = 0;
 
-		if (skip_free_areas_node(filter, zone_to_nid(zone)))
+		if (!node_isset(zone_to_nid(zone), allownodes))
 			continue;
 		show_node(zone);
 		printk("%s: ", zone->name);
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

linux-next.patch
mm-slab-remove-duplicate-check.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
mm-compaction-cleanup-on-compaction_deferred.patch

