From: akpm@linux-foundation.org
Subject: - mm-verify-the-page-links-and-memory-model.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:20:27 -0700
Message-ID: <200807242320.m6ONKRII010341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYGXXUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, cl@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: verify the page links and memory model
has been removed from the -mm tree.  Its filename was
     mm-verify-the-page-links-and-memory-model.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: verify the page links and memory model
From: Mel Gorman <mel@csn.ul.ie>

Print out information on how the page flags are being used if mminit_loglevel
is MMINIT_VERIFY or higher and unconditionally performs sanity checks on the
flags regardless of loglevel.

When the page flags are updated with section, node and zone information, a
check are made to ensure the values can be retrieved correctly.  Finally we
confirm that pfn_to_page and page_to_pfn are the correct inverse functions.

[akpm@linux-foundation.org: fix printk warnings]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   12 +++++++
 mm/mm_init.c    |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c |    8 +++++
 3 files changed, 91 insertions(+)

diff -puN mm/internal.h~mm-verify-the-page-links-and-memory-model mm/internal.h
--- a/mm/internal.h~mm-verify-the-page-links-and-memory-model
+++ a/mm/internal.h
@@ -78,6 +78,10 @@ do { \
 	} \
 } while (0)
 
+extern void mminit_verify_pageflags_layout(void);
+extern void mminit_verify_page_links(struct page *page,
+		enum zone_type zone, unsigned long nid, unsigned long pfn);
+
 #else
 
 static inline void mminit_dprintk(enum mminit_level level,
@@ -85,5 +89,13 @@ static inline void mminit_dprintk(enum m
 {
 }
 
+static inline void mminit_verify_pageflags_layout(void)
+{
+}
+
+static inline void mminit_verify_page_links(struct page *page,
+		enum zone_type zone, unsigned long nid, unsigned long pfn)
+{
+}
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 #endif
diff -puN mm/mm_init.c~mm-verify-the-page-links-and-memory-model mm/mm_init.c
--- a/mm/mm_init.c~mm-verify-the-page-links-and-memory-model
+++ a/mm/mm_init.c
@@ -7,9 +7,80 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include "internal.h"
 
 int __meminitdata mminit_loglevel;
 
+void __init mminit_verify_pageflags_layout(void)
+{
+	int shift, width;
+	unsigned long or_mask, add_mask;
+
+	shift = 8 * sizeof(unsigned long);
+	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH;
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
+		"Section %d Node %d Zone %d Flags %d\n",
+		SECTIONS_WIDTH,
+		NODES_WIDTH,
+		ZONES_WIDTH,
+		NR_PAGEFLAGS);
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
+		"Section %d Node %d Zone %d\n",
+#ifdef SECTIONS_SHIFT
+		SECTIONS_SHIFT,
+#else
+		0,
+#endif
+		NODES_SHIFT,
+		ZONES_SHIFT);
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
+		"Section %lu Node %lu Zone %lu\n",
+		(unsigned long)SECTIONS_PGSHIFT,
+		(unsigned long)NODES_PGSHIFT,
+		(unsigned long)ZONES_PGSHIFT);
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_zoneid",
+		"Zone ID: %lu -> %lu\n",
+		(unsigned long)ZONEID_PGOFF,
+		(unsigned long)(ZONEID_PGOFF + ZONEID_SHIFT));
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_usage",
+		"location: %d -> %d unused %d -> %d flags %d -> %d\n",
+		shift, width, width, NR_PAGEFLAGS, NR_PAGEFLAGS, 0);
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
+		"Node not in page flags");
+#endif
+
+	if (SECTIONS_WIDTH) {
+		shift -= SECTIONS_WIDTH;
+		BUG_ON(shift != SECTIONS_PGSHIFT);
+	}
+	if (NODES_WIDTH) {
+		shift -= NODES_WIDTH;
+		BUG_ON(shift != NODES_PGSHIFT);
+	}
+	if (ZONES_WIDTH) {
+		shift -= ZONES_WIDTH;
+		BUG_ON(shift != ZONES_PGSHIFT);
+	}
+
+	/* Check for bitmask overlaps */
+	or_mask = (ZONES_MASK << ZONES_PGSHIFT) |
+			(NODES_MASK << NODES_PGSHIFT) |
+			(SECTIONS_MASK << SECTIONS_PGSHIFT);
+	add_mask = (ZONES_MASK << ZONES_PGSHIFT) +
+			(NODES_MASK << NODES_PGSHIFT) +
+			(SECTIONS_MASK << SECTIONS_PGSHIFT);
+	BUG_ON(or_mask != add_mask);
+}
+
+void __meminit mminit_verify_page_links(struct page *page, enum zone_type zone,
+			unsigned long nid, unsigned long pfn)
+{
+	BUG_ON(page_to_nid(page) != nid);
+	BUG_ON(page_zonenum(page) != zone);
+	BUG_ON(page_to_pfn(page) != pfn);
+}
+
 static __init int set_mminit_loglevel(char *str)
 {
 	get_option(&str, &mminit_loglevel);
diff -puN mm/page_alloc.c~mm-verify-the-page-links-and-memory-model mm/page_alloc.c
--- a/mm/page_alloc.c~mm-verify-the-page-links-and-memory-model
+++ a/mm/page_alloc.c
@@ -2534,6 +2534,7 @@ void __meminit memmap_init_zone(unsigned
 		}
 		page = pfn_to_page(pfn);
 		set_page_links(page, zone, nid, pfn);
+		mminit_verify_page_links(page, zone, nid, pfn);
 		init_page_count(page);
 		reset_page_mapcount(page);
 		SetPageReserved(page);
@@ -2836,6 +2837,12 @@ __meminit int init_currently_empty_zone(
 
 	zone->zone_start_pfn = zone_start_pfn;
 
+	mminit_dprintk(MMINIT_TRACE, "memmap_init",
+			"Initialising map node %d zone %lu pfns %lu -> %lu\n",
+			pgdat->node_id,
+			(unsigned long)zone_idx(zone),
+			zone_start_pfn, (zone_start_pfn + size));
+
 	zone_init_free_lists(zone);
 
 	return 0;
@@ -3961,6 +3968,7 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].end_pfn);
 
 	/* Initialise every node */
+	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

