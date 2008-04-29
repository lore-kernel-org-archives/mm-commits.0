From: akpm@linux-foundation.org
Subject: + mm-print-out-the-zonelists-on-request-for-manual-verification.patch added to -mm tree
Date: Tue, 29 Apr 2008 14:26:12 -0700
Message-ID: <200804292126.m3TLQC91010610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbYD2V0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 17:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mingo@elte.hu


The patch titled
     mm: print out the zonelists on request for manual verification
has been added to the -mm tree.  Its filename is
     mm-print-out-the-zonelists-on-request-for-manual-verification.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: print out the zonelists on request for manual verification
From: Mel Gorman <mel@csn.ul.ie>

This patch prints out the zonelists during boot for manual verification by the
user if the mminit_loglevel is MMINIT_VERIFY or higher.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
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
@@ -2372,6 +2372,7 @@ void build_all_zonelists(void)
 
 	if (system_state == SYSTEM_BOOTING) {
 		__build_all_zonelists(NULL);
+		mminit_verify_zonelist();
 		cpuset_init_current_mems_allowed();
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-fix-usemap-initialization.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

