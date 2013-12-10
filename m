From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch added to -mm tree
Date: Mon, 09 Dec 2013 16:29:19 -0800
Message-ID: <52a6605f.chnZ/CUEG6JVv/2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3LJA3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: + mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch added to -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:19 -0800


The patch titled
     Subject: mm/page_alloc.c: use memblock apis for early memory allocations
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4221,7 +4221,6 @@ static noinline __init_refok
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	size_t alloc_size;
 
 	/*
@@ -4237,7 +4236,8 @@ int zone_wait_table_init(struct zone *zo
 
 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
-			alloc_bootmem_node_nopanic(pgdat, alloc_size);
+			memblock_virt_alloc_node_nopanic(
+				alloc_size, zone->zone_pgdat->node_id);
 	} else {
 		/*
 		 * This case means that a zone whose size was 0 gets new memory
@@ -4357,13 +4357,14 @@ bool __meminit early_pfn_in_nid(unsigned
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
@@ -4375,9 +4376,9 @@ void __init free_bootmem_with_active_reg
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
 
@@ -4648,8 +4649,9 @@ static void __init setup_usemap(struct p
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
@@ -4843,7 +4845,8 @@ static void __init_refok alloc_node_mem_
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
-			map = alloc_bootmem_node_nopanic(pgdat, size);
+			map = memblock_virt_alloc_node_nopanic(size,
+							       pgdat->node_id);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -5893,7 +5896,7 @@ void *__init alloc_large_system_hash(con
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

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
linux-next.patch

