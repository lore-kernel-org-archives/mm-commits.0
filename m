From: akpm@linux-foundation.org
Subject: - mm-print-out-the-zonelists-on-request-for-manual-verification.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:20:39 -0700
Message-ID: <200807242320.m6ONKd5E010347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbYGXXVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, cl@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: print out the zonelists on request for manual verification
has been removed from the -mm tree.  Its filename was
     mm-print-out-the-zonelists-on-request-for-manual-verification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: print out the zonelists on request for manual verification
From: Mel Gorman <mel@csn.ul.ie>

This patch prints out the zonelists during boot for manual verification by the
user if the mminit_loglevel is MMINIT_VERIFY or higher.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    5 +++++
 mm/mm_init.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c |    1 +
 3 files changed, 51 insertions(+)

diff -puN mm/internal.h~mm-print-out-the-zonelists-on-request-for-manual-verification mm/internal.h
--- a/mm/internal.h~mm-print-out-the-zonelists-on-request-for-manual-verification
+++ a/mm/internal.h
@@ -81,6 +81,7 @@ do { \
 extern void mminit_verify_pageflags_layout(void);
 extern void mminit_verify_page_links(struct page *page,
 		enum zone_type zone, unsigned long nid, unsigned long pfn);
+extern void mminit_verify_zonelist(void);
 
 #else
 
@@ -97,6 +98,10 @@ static inline void mminit_verify_page_li
 		enum zone_type zone, unsigned long nid, unsigned long pfn)
 {
 }
+
+static inline void mminit_verify_zonelist(void)
+{
+}
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
 /* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
diff -puN mm/mm_init.c~mm-print-out-the-zonelists-on-request-for-manual-verification mm/mm_init.c
--- a/mm/mm_init.c~mm-print-out-the-zonelists-on-request-for-manual-verification
+++ a/mm/mm_init.c
@@ -11,6 +11,51 @@
 
 int __meminitdata mminit_loglevel;
 
+/* The zonelists are simply reported, validation is manual. */
+void mminit_verify_zonelist(void)
+{
+	int nid;
+
+	if (mminit_loglevel < MMINIT_VERIFY)
+		return;
+
+	for_each_online_node(nid) {
+		pg_data_t *pgdat = NODE_DATA(nid);
+		struct zone *zone;
+		struct zoneref *z;
+		struct zonelist *zonelist;
+		int i, listid, zoneid;
+
+		BUG_ON(MAX_ZONELISTS > 2);
+		for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
+
+			/* Identify the zone and nodelist */
+			zoneid = i % MAX_NR_ZONES;
+			listid = i / MAX_NR_ZONES;
+			zonelist = &pgdat->node_zonelists[listid];
+			zone = &pgdat->node_zones[zoneid];
+			if (!populated_zone(zone))
+				continue;
+
+			/* Print information about the zonelist */
+			printk(KERN_DEBUG "mminit::zonelist %s %d:%s = ",
+				listid > 0 ? "thisnode" : "general", nid,
+				zone->name);
+
+			/* Iterate the zonelist */
+			for_each_zone_zonelist(zone, z, zonelist, zoneid) {
+#ifdef CONFIG_NUMA
+				printk(KERN_CONT "%d:%s ",
+					zone->node, zone->name);
+#else
+				printk(KERN_CONT "0:%s ", zone->name);
+#endif /* CONFIG_NUMA */
+			}
+			printk(KERN_CONT "\n");
+		}
+	}
+}
+
 void __init mminit_verify_pageflags_layout(void)
 {
 	int shift, width;
diff -puN mm/page_alloc.c~mm-print-out-the-zonelists-on-request-for-manual-verification mm/page_alloc.c
--- a/mm/page_alloc.c~mm-print-out-the-zonelists-on-request-for-manual-verification
+++ a/mm/page_alloc.c
@@ -2352,6 +2352,7 @@ void build_all_zonelists(void)
 
 	if (system_state == SYSTEM_BOOTING) {
 		__build_all_zonelists(NULL);
+		mminit_verify_zonelist();
 		cpuset_init_current_mems_allowed();
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

