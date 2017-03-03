From: akpm@linux-foundation.org
Subject: + mm-vmstat-print-non-populated-zones-in-zoneinfo.patch added to
 -mm tree
Date: Fri, 03 Mar 2017 15:10:33 -0800
Message-ID: <58b9f7e9.bNUxnY/jbZx2/juT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdCCXL1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: print non-populated zones in zoneinfo
has been added to the -mm tree.  Its filename is
     mm-vmstat-print-non-populated-zones-in-zoneinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-print-non-populated-zones-in-zoneinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-print-non-populated-zones-in-zoneinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, vmstat: print non-populated zones in zoneinfo

Initscripts can use the information (protection levels) from
/proc/zoneinfo to configure vm.lowmem_reserve_ratio at boot.

vm.lowmem_reserve_ratio is an array of ratios for each configured zone on
the system.  If a zone is not populated on an arch, /proc/zoneinfo
suppresses its output.

This results in there not being a 1:1 mapping between the set of zones
emitted by /proc/zoneinfo and the zones configured by
vm.lowmem_reserve_ratio.

This patch shows statistics for non-populated zones in /proc/zoneinfo. 
The zones exist and hold a spot in the vm.lowmem_reserve_ratio array. 
Without this patch, it is not possible to determine which index in the
array controls which zone if one or more zones on the system are not
populated.

Remaining users of walk_zones_in_node() are unchanged.  Files such as
/proc/pagetypeinfo require certain zone data to be initialized properly
for display, which is not done for unpopulated zones.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1703031451310.98023@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-print-non-populated-zones-in-zoneinfo mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-print-non-populated-zones-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1124,8 +1124,12 @@ static void frag_stop(struct seq_file *m
 {
 }
 
-/* Walk all the zones in a node and print using a callback */
+/*
+ * Walk zones in a node and print using a callback.
+ * If @assert_populated is true, only use callback for zones that are populated.
+ */
 static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
+		bool assert_populated,
 		void (*print)(struct seq_file *m, pg_data_t *, struct zone *))
 {
 	struct zone *zone;
@@ -1133,7 +1137,7 @@ static void walk_zones_in_node(struct se
 	unsigned long flags;
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
-		if (!populated_zone(zone))
+		if (assert_populated && !populated_zone(zone))
 			continue;
 
 		spin_lock_irqsave(&zone->lock, flags);
@@ -1161,7 +1165,7 @@ static void frag_show_print(struct seq_f
 static int frag_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, frag_show_print);
+	walk_zones_in_node(m, pgdat, true, frag_show_print);
 	return 0;
 }
 
@@ -1202,7 +1206,7 @@ static int pagetypeinfo_showfree(struct
 		seq_printf(m, "%6d ", order);
 	seq_putc(m, '\n');
 
-	walk_zones_in_node(m, pgdat, pagetypeinfo_showfree_print);
+	walk_zones_in_node(m, pgdat, true, pagetypeinfo_showfree_print);
 
 	return 0;
 }
@@ -1254,7 +1258,7 @@ static int pagetypeinfo_showblockcount(s
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
 		seq_printf(m, "%12s ", migratetype_names[mtype]);
 	seq_putc(m, '\n');
-	walk_zones_in_node(m, pgdat, pagetypeinfo_showblockcount_print);
+	walk_zones_in_node(m, pgdat, true, pagetypeinfo_showblockcount_print);
 
 	return 0;
 }
@@ -1280,7 +1284,7 @@ static void pagetypeinfo_showmixedcount(
 		seq_printf(m, "%12s ", migratetype_names[mtype]);
 	seq_putc(m, '\n');
 
-	walk_zones_in_node(m, pgdat, pagetypeinfo_showmixedcount_print);
+	walk_zones_in_node(m, pgdat, true, pagetypeinfo_showmixedcount_print);
 #endif /* CONFIG_PAGE_OWNER */
 }
 
@@ -1430,12 +1434,15 @@ static void zoneinfo_show_print(struct s
 }
 
 /*
- * Output information about zones in @pgdat.
+ * Output information about zones in @pgdat.  All zones are printed regardless
+ * of whether they are populated or not: lowmem_reserve_ratio operates on the
+ * set of all zones and userspace would not be aware of such zones if they are
+ * suppressed here (zoneinfo displays the effect of lowmem_reserve_ratio).
  */
 static int zoneinfo_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, zoneinfo_show_print);
+	walk_zones_in_node(m, pgdat, false, zoneinfo_show_print);
 	return 0;
 }
 
@@ -1841,7 +1848,7 @@ static int unusable_show(struct seq_file
 	if (!node_state(pgdat->node_id, N_MEMORY))
 		return 0;
 
-	walk_zones_in_node(m, pgdat, unusable_show_print);
+	walk_zones_in_node(m, pgdat, true, unusable_show_print);
 
 	return 0;
 }
@@ -1893,7 +1900,7 @@ static int extfrag_show(struct seq_file
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
-	walk_zones_in_node(m, pgdat, extfrag_show_print);
+	walk_zones_in_node(m, pgdat, true, extfrag_show_print);
 
 	return 0;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

mm-vmstat-print-non-populated-zones-in-zoneinfo.patch

