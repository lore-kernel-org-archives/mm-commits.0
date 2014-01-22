From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:14:04 -0800
Message-ID: <52e0268c.KalMfg3K/EwDKPl5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaAVUOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: [merged] mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:04 -0800


The patch titled
     Subject: mm/page_alloc.c: use memblock apis for early memory allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: mm/page_alloc.c: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-memblock-apis-for-early-memory-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-memblock-apis-for-early-memory-allocations
+++ a/mm/page_alloc.c
@@ -4215,7 +4215,6 @@ static noinline __init_refok
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	size_t alloc_size;
 
 	/*
@@ -4231,7 +4230,8 @@ int zone_wait_table_init(struct zone *zo
 
 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
-			alloc_bootmem_node_nopanic(pgdat, alloc_size);
+			memblock_virt_alloc_node_nopanic(
+				alloc_size, zone->zone_pgdat->node_id);
 	} else {
 		/*
 		 * This case means that a zone whose size was 0 gets new memory
@@ -4351,13 +4351,14 @@ bool __meminit early_pfn_in_nid(unsigned
 #endif
 
 /**
- * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
+ * free_bootmem_with_active_regions - Call memblock_free_early_nid for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
- * @max_low_pfn: The highest PFN that will be passed to free_bootmem_node
+ * @max_low_pfn: The highest PFN that will be passed to memblock_free_early_nid
  *
  * If an architecture guarantees that all ranges registered with
  * add_active_ranges() contain no holes and may be freed, this
- * this function may be used instead of calling free_bootmem() manually.
+ * this function may be used instead of calling memblock_free_early_nid()
+ * manually.
  */
 void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
 {
@@ -4369,9 +4370,9 @@ void __init free_bootmem_with_active_reg
 		end_pfn = min(end_pfn, max_low_pfn);
 
 		if (start_pfn < end_pfn)
-			free_bootmem_node(NODE_DATA(this_nid),
-					  PFN_PHYS(start_pfn),
-					  (end_pfn - start_pfn) << PAGE_SHIFT);
+			memblock_free_early_nid(PFN_PHYS(start_pfn),
+					(end_pfn - start_pfn) << PAGE_SHIFT,
+					this_nid);
 	}
 }
 
@@ -4642,8 +4643,9 @@ static void __init setup_usemap(struct p
 	unsigned long usemapsize = usemap_size(zone_start_pfn, zonesize);
 	zone->pageblock_flags = NULL;
 	if (usemapsize)
-		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat,
-								   usemapsize);
+		zone->pageblock_flags =
+			memblock_virt_alloc_node_nopanic(usemapsize,
+							 pgdat->node_id);
 }
 #else
 static inline void setup_usemap(struct pglist_data *pgdat, struct zone *zone,
@@ -4837,7 +4839,8 @@ static void __init_refok alloc_node_mem_
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
-			map = alloc_bootmem_node_nopanic(pgdat, size);
+			map = memblock_virt_alloc_node_nopanic(size,
+							       pgdat->node_id);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -5887,7 +5890,7 @@ void *__init alloc_large_system_hash(con
 	do {
 		size = bucketsize << log2qty;
 		if (flags & HASH_EARLY)
-			table = alloc_bootmem_nopanic(size);
+			table = memblock_virt_alloc_nopanic(size, 0);
 		else if (hashdist)
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
linux-next.patch

