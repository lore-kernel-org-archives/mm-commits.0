From: akpm@linux-foundation.org
Subject: + mm-buddy-get-the-allownodes-for-dump-at-once.patch added to -mm tree
Date: Wed, 20 Jun 2012 13:55:11 -0700
Message-ID: <20120620205511.5BD22A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35809 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2FTUzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 16:55:14 -0400
Received: by qabg24 with SMTP id g24so135383qab.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 13:55:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/buddy: get the allownodes for dump at once
has been added to the -mm tree.  Its filename is
     mm-buddy-get-the-allownodes-for-dump-at-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/buddy: get the allownodes for dump at once

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-buddy-get-the-allownodes-for-dump-at-once.patch

