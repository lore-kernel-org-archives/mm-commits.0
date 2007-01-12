From: akpm@osdl.org
Subject: - fix-sparsemem-on-cell.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:17:34 -0800
Message-ID: <200701122217.l0CMHYik030739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39158 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161155AbXALWTr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, apw@shadowen.org, arndb@de.ibm.com, benh@kernel.crashing.org, clameter@engr.sgi.com, heiko.carstens@de.ibm.com, paulus@samba.org, schwidefsky@de.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix sparsemem on Cell
has been removed from the -mm tree.  Its filename was
     fix-sparsemem-on-cell.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix sparsemem on Cell
From: Dave Hansen <haveblue@us.ibm.com>

Fix an oops experienced on the Cell architecture when init-time functions,
early_*(), are called at runtime.  It alters the call paths to make sure
that the callers explicitly say whether the call is being made on behalf of
a hotplug even, or happening at boot-time.

It has been compile tested on ppc64, ia64, s390, i386 and x86_64.

Acked-by: Arnd Bergmann <arndb@de.ibm.com>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/mm/init.c    |    5 +++--
 arch/s390/mm/vmem.c    |    3 ++-
 include/linux/mm.h     |    3 ++-
 include/linux/mmzone.h |    8 ++++++--
 mm/memory_hotplug.c    |    6 ++++--
 mm/page_alloc.c        |   25 +++++++++++++++++--------
 6 files changed, 34 insertions(+), 16 deletions(-)

diff -puN arch/ia64/mm/init.c~fix-sparsemem-on-cell arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~fix-sparsemem-on-cell
+++ a/arch/ia64/mm/init.c
@@ -543,7 +543,8 @@ virtual_memmap_init (u64 start, u64 end,
 
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
-				 args->nid, args->zone, page_to_pfn(map_start));
+				 args->nid, args->zone, page_to_pfn(map_start),
+				 MEMMAP_EARLY);
 	return 0;
 }
 
@@ -552,7 +553,7 @@ memmap_init (unsigned long size, int nid
 	     unsigned long start_pfn)
 {
 	if (!vmem_map)
-		memmap_init_zone(size, nid, zone, start_pfn);
+		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY);
 	else {
 		struct page *start;
 		struct memmap_init_callback_data args;
diff -puN arch/s390/mm/vmem.c~fix-sparsemem-on-cell arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~fix-sparsemem-on-cell
+++ a/arch/s390/mm/vmem.c
@@ -61,7 +61,8 @@ void memmap_init(unsigned long size, int
 
 		if (map_start < map_end)
 			memmap_init_zone((unsigned long)(map_end - map_start),
-					 nid, zone, page_to_pfn(map_start));
+					 nid, zone, page_to_pfn(map_start),
+					 MEMMAP_EARLY);
 	}
 }
 
diff -puN include/linux/mm.h~fix-sparsemem-on-cell include/linux/mm.h
--- a/include/linux/mm.h~fix-sparsemem-on-cell
+++ a/include/linux/mm.h
@@ -978,7 +978,8 @@ extern int early_pfn_to_nid(unsigned lon
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 extern void set_dma_reserve(unsigned long new_dma_reserve);
-extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long);
+extern void memmap_init_zone(unsigned long, int, unsigned long,
+				unsigned long, enum memmap_context);
 extern void setup_per_zone_pages_min(void);
 extern void mem_init(void);
 extern void show_mem(void);
diff -puN include/linux/mmzone.h~fix-sparsemem-on-cell include/linux/mmzone.h
--- a/include/linux/mmzone.h~fix-sparsemem-on-cell
+++ a/include/linux/mmzone.h
@@ -450,9 +450,13 @@ void build_all_zonelists(void);
 void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		int classzone_idx, int alloc_flags);
-
+enum memmap_context {
+	MEMMAP_EARLY,
+	MEMMAP_HOTPLUG,
+};
 extern int init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
-				     unsigned long size);
+				     unsigned long size,
+				     enum memmap_context context);
 
 #ifdef CONFIG_HAVE_MEMORY_PRESENT
 void memory_present(int nid, unsigned long start, unsigned long end);
diff -puN mm/memory_hotplug.c~fix-sparsemem-on-cell mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~fix-sparsemem-on-cell
+++ a/mm/memory_hotplug.c
@@ -67,11 +67,13 @@ static int __add_zone(struct zone *zone,
 	zone_type = zone - pgdat->node_zones;
 	if (!populated_zone(zone)) {
 		int ret = 0;
-		ret = init_currently_empty_zone(zone, phys_start_pfn, nr_pages);
+		ret = init_currently_empty_zone(zone, phys_start_pfn,
+						nr_pages, MEMMAP_HOTPLUG);
 		if (ret < 0)
 			return ret;
 	}
-	memmap_init_zone(nr_pages, nid, zone_type, phys_start_pfn);
+	memmap_init_zone(nr_pages, nid, zone_type,
+			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;
 }
 
diff -puN mm/page_alloc.c~fix-sparsemem-on-cell mm/page_alloc.c
--- a/mm/page_alloc.c~fix-sparsemem-on-cell
+++ a/mm/page_alloc.c
@@ -1956,17 +1956,24 @@ static inline unsigned long wait_table_b
  * done. Non-atomic initialization, single-pass.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn)
+		unsigned long start_pfn, enum memmap_context context)
 {
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		if (!early_pfn_valid(pfn))
-			continue;
-		if (!early_pfn_in_nid(pfn, nid))
-			continue;
+		/*
+		 * There can be holes in boot-time mem_map[]s
+		 * handed to this function.  They do not
+		 * exist on hotplugged memory.
+		 */
+		if (context == MEMMAP_EARLY) {
+			if (!early_pfn_valid(pfn))
+				continue;
+			if (!early_pfn_in_nid(pfn, nid))
+				continue;
+		}
 		page = pfn_to_page(pfn);
 		set_page_links(page, zone, nid, pfn);
 		init_page_count(page);
@@ -1993,7 +2000,7 @@ void zone_init_free_lists(struct pglist_
 
 #ifndef __HAVE_ARCH_MEMMAP_INIT
 #define memmap_init(size, nid, zone, start_pfn) \
-	memmap_init_zone((size), (nid), (zone), (start_pfn))
+	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
 static int __cpuinit zone_batchsize(struct zone *zone)
@@ -2239,7 +2246,8 @@ static __meminit void zone_pcp_init(stru
 
 __meminit int init_currently_empty_zone(struct zone *zone,
 					unsigned long zone_start_pfn,
-					unsigned long size)
+					unsigned long size,
+					enum memmap_context context)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int ret;
@@ -2683,7 +2691,8 @@ static void __meminit free_area_init_cor
 		if (!size)
 			continue;
 
-		ret = init_currently_empty_zone(zone, zone_start_pfn, size);
+		ret = init_currently_empty_zone(zone, zone_start_pfn,
+						size, MEMMAP_EARLY);
 		BUG_ON(ret);
 		zone_start_pfn += size;
 	}
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
page-owner-tracking-leak-detector.patch
