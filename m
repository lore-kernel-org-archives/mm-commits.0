From: akpm@linux-foundation.org
Subject: + mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed.patch added to -mm tree
Date: Thu, 22 Jun 2017 14:47:44 -0700
Message-ID: <594c3b00.8v1M0VuI/0xPIHzd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdFVVrq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vinmenon@codeaurora.org, bigeasy@linutronix.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, rientjes@google.com, sergey.senozhatsky@gmail.com, sudipm.mukherjee@gmail.com, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid taking zone lock in pagetypeinfo_showmixed()
has been added to the -mm tree.  Its filename is
     mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm: avoid taking zone lock in pagetypeinfo_showmixed()

pagetypeinfo_showmixedcount_print is found to take a lot of time to
complete and it does this holding the zone lock and disabling interrupts. 
In some cases it is found to take more than a second (On a 2.4GHz,8Gb
RAM,arm64 cpu).  Avoid taking the zone lock similar to what is done by
read_page_owner, which means possibility of inaccurate results.

Link: http://lkml.kernel.org/r/1498045643-12257-1-git-send-email-vinmenon@codeaurora.org
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 +++++-
 mm/vmstat.c     |   24 ++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff -puN mm/page_owner.c~mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed mm/page_owner.c
--- a/mm/page_owner.c~mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed
+++ a/mm/page_owner.c
@@ -281,7 +281,11 @@ void pagetypeinfo_showmixedcount_print(s
 				continue;
 
 			if (PageBuddy(page)) {
-				pfn += (1UL << page_order(page)) - 1;
+				unsigned long freepage_order;
+
+				freepage_order = page_order_unsafe(page);
+				if (freepage_order < MAX_ORDER)
+					pfn += (1UL << freepage_order) - 1;
 				continue;
 			}
 
diff -puN mm/vmstat.c~mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed mm/vmstat.c
--- a/mm/vmstat.c~mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed
+++ a/mm/vmstat.c
@@ -1130,7 +1130,7 @@ static void frag_stop(struct seq_file *m
  * If @assert_populated is true, only use callback for zones that are populated.
  */
 static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
-		bool assert_populated,
+		bool assert_populated, bool nolock,
 		void (*print)(struct seq_file *m, pg_data_t *, struct zone *))
 {
 	struct zone *zone;
@@ -1141,9 +1141,11 @@ static void walk_zones_in_node(struct se
 		if (assert_populated && !populated_zone(zone))
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		if (!nolock)
+			spin_lock_irqsave(&zone->lock, flags);
 		print(m, pgdat, zone);
-		spin_unlock_irqrestore(&zone->lock, flags);
+		if (!nolock)
+			spin_unlock_irqrestore(&zone->lock, flags);
 	}
 }
 #endif
@@ -1166,7 +1168,7 @@ static void frag_show_print(struct seq_f
 static int frag_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, true, frag_show_print);
+	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
 	return 0;
 }
 
@@ -1207,7 +1209,7 @@ static int pagetypeinfo_showfree(struct
 		seq_printf(m, "%6d ", order);
 	seq_putc(m, '\n');
 
-	walk_zones_in_node(m, pgdat, true, pagetypeinfo_showfree_print);
+	walk_zones_in_node(m, pgdat, true, false, pagetypeinfo_showfree_print);
 
 	return 0;
 }
@@ -1258,7 +1260,8 @@ static int pagetypeinfo_showblockcount(s
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
 		seq_printf(m, "%12s ", migratetype_names[mtype]);
 	seq_putc(m, '\n');
-	walk_zones_in_node(m, pgdat, true, pagetypeinfo_showblockcount_print);
+	walk_zones_in_node(m, pgdat, true, false,
+		pagetypeinfo_showblockcount_print);
 
 	return 0;
 }
@@ -1284,7 +1287,8 @@ static void pagetypeinfo_showmixedcount(
 		seq_printf(m, "%12s ", migratetype_names[mtype]);
 	seq_putc(m, '\n');
 
-	walk_zones_in_node(m, pgdat, true, pagetypeinfo_showmixedcount_print);
+	walk_zones_in_node(m, pgdat, true, true,
+		pagetypeinfo_showmixedcount_print);
 #endif /* CONFIG_PAGE_OWNER */
 }
 
@@ -1446,7 +1450,7 @@ static void zoneinfo_show_print(struct s
 static int zoneinfo_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, false, zoneinfo_show_print);
+	walk_zones_in_node(m, pgdat, false, false, zoneinfo_show_print);
 	return 0;
 }
 
@@ -1852,7 +1856,7 @@ static int unusable_show(struct seq_file
 	if (!node_state(pgdat->node_id, N_MEMORY))
 		return 0;
 
-	walk_zones_in_node(m, pgdat, true, unusable_show_print);
+	walk_zones_in_node(m, pgdat, true, false, unusable_show_print);
 
 	return 0;
 }
@@ -1904,7 +1908,7 @@ static int extfrag_show(struct seq_file
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
-	walk_zones_in_node(m, pgdat, true, extfrag_show_print);
+	walk_zones_in_node(m, pgdat, true, false, extfrag_show_print);
 
 	return 0;
 }
_

Patches currently in -mm which might be from vinmenon@codeaurora.org are

mm-avoid-taking-zone-lock-in-pagetypeinfo_showmixed.patch
mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch

