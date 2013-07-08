From: akpm@linux-foundation.org
Subject: [merged]
 mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:26:18 -0700
Message-ID: <51db125a.lMloMGlTNFxuUucJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3GHT0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:18 -0700


The patch titled
     Subject: mm: accurately calculate zone->managed_pages for highmem zones
has been removed from the -mm tree.  Its filename was
     mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: accurately calculate zone->managed_pages for highmem zones

Commit "mm: introduce new field 'managed_pages' to struct zone" assumes
that all highmem pages will be freed into the buddy system by function
mem_init().  But that's not always true, some architectures may reserve
some highmem pages during boot.  For example PPC may allocate highmem
pages for giagant HugeTLB pages, and several architectures have code to
check PageReserved flag to exclude highmem pages allocated during boot
when freeing highmem pages into the buddy system.

So treat highmem pages in the same way as normal pages, that is to:
1) reset zone->managed_pages to zero in mem_init().
2) recalculate managed_pages when freeing pages into the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/mm/init.c     |    6 ++++++
 arch/x86/mm/highmem_32.c |    6 ++++++
 include/linux/bootmem.h  |    1 +
 mm/bootmem.c             |   32 ++++++++++++++++++--------------
 mm/nobootmem.c           |   30 ++++++++++++++++--------------
 mm/page_alloc.c          |    1 +
 6 files changed, 48 insertions(+), 28 deletions(-)

diff -puN arch/metag/mm/init.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones
+++ a/arch/metag/mm/init.c
@@ -380,6 +380,12 @@ void __init mem_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	unsigned long tmp;
+
+	/*
+	 * Explicitly reset zone->managed_pages because highmem pages are
+	 * freed before calling free_all_bootmem_node();
+	 */
+	reset_all_zones_managed_pages();
 	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++)
 		free_highmem_page(pfn_to_page(tmp));
 	num_physpages += totalhigh_pages;
diff -puN arch/x86/mm/highmem_32.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones
+++ a/arch/x86/mm/highmem_32.c
@@ -1,6 +1,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/swap.h> /* for totalram_pages */
+#include <linux/bootmem.h>
 
 void *kmap(struct page *page)
 {
@@ -121,6 +122,11 @@ void __init set_highmem_pages_init(void)
 	struct zone *zone;
 	int nid;
 
+	/*
+	 * Explicitly reset zone->managed_pages because set_highmem_pages_init()
+	 * is invoked before free_all_bootmem()
+	 */
+	reset_all_zones_managed_pages();
 	for_each_zone(zone) {
 		unsigned long zone_start_pfn, zone_end_pfn;
 
diff -puN include/linux/bootmem.h~mm-accurately-calculate-zone-managed_pages-for-highmem-zones include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-accurately-calculate-zone-managed_pages-for-highmem-zones
+++ a/include/linux/bootmem.h
@@ -46,6 +46,7 @@ extern unsigned long init_bootmem(unsign
 
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
+extern void reset_all_zones_managed_pages(void);
 
 extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
diff -puN mm/bootmem.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones mm/bootmem.c
--- a/mm/bootmem.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones
+++ a/mm/bootmem.c
@@ -241,20 +241,26 @@ static unsigned long __init free_all_boo
 	return count;
 }
 
-static void reset_node_lowmem_managed_pages(pg_data_t *pgdat)
+static int reset_managed_pages_done __initdata;
+
+static inline void __init reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
 
-	/*
-	 * In free_area_init_core(), highmem zone's managed_pages is set to
-	 * present_pages, and bootmem allocator doesn't allocate from highmem
-	 * zones. So there's no need to recalculate managed_pages because all
-	 * highmem pages will be managed by the buddy system. Here highmem
-	 * zone also includes highmem movable zone.
-	 */
+	if (reset_managed_pages_done)
+		return;
+
 	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		if (!is_highmem(z))
-			z->managed_pages = 0;
+		z->managed_pages = 0;
+}
+
+void __init reset_all_zones_managed_pages(void)
+{
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat)
+		reset_node_managed_pages(pgdat);
+	reset_managed_pages_done = 1;
 }
 
 /**
@@ -266,7 +272,7 @@ static void reset_node_lowmem_managed_pa
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
-	reset_node_lowmem_managed_pages(pgdat);
+	reset_node_managed_pages(pgdat);
 	return free_all_bootmem_core(pgdat->bdata);
 }
 
@@ -279,10 +285,8 @@ unsigned long __init free_all_bootmem(vo
 {
 	unsigned long total_pages = 0;
 	bootmem_data_t *bdata;
-	struct pglist_data *pgdat;
 
-	for_each_online_pgdat(pgdat)
-		reset_node_lowmem_managed_pages(pgdat);
+	reset_all_zones_managed_pages();
 
 	list_for_each_entry(bdata, &bdata_list, list)
 		total_pages += free_all_bootmem_core(bdata);
diff -puN mm/nobootmem.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones mm/nobootmem.c
--- a/mm/nobootmem.c~mm-accurately-calculate-zone-managed_pages-for-highmem-zones
+++ a/mm/nobootmem.c
@@ -137,20 +137,25 @@ static unsigned long __init free_low_mem
 	return count;
 }
 
-static void reset_node_lowmem_managed_pages(pg_data_t *pgdat)
+static int reset_managed_pages_done __initdata;
+
+static inline void __init reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
 
-	/*
-	 * In free_area_init_core(), highmem zone's managed_pages is set to
-	 * present_pages, and bootmem allocator doesn't allocate from highmem
-	 * zones. So there's no need to recalculate managed_pages because all
-	 * highmem pages will be managed by the buddy system. Here highmem
-	 * zone also includes highmem movable zone.
-	 */
+	if (reset_managed_pages_done)
+		return;
 	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		if (!is_highmem(z))
-			z->managed_pages = 0;
+		z->managed_pages = 0;
+}
+
+void __init reset_all_zones_managed_pages(void)
+{
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat)
+		reset_node_managed_pages(pgdat);
+	reset_managed_pages_done = 1;
 }
 
 /**
@@ -160,10 +165,7 @@ static void reset_node_lowmem_managed_pa
  */
 unsigned long __init free_all_bootmem(void)
 {
-	struct pglist_data *pgdat;
