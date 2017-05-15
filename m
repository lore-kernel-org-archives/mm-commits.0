From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
 added to -mm tree
Date: Mon, 15 May 2017 14:27:21 -0700
Message-ID: <591a1d39.UBsD+l/lPokz0QD9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759007AbdEOV1W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: remove unused cruft after memory hotplug rework
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: remove unused cruft after memory hotplug rework

zone_for_memory doesn't have any user anymore as well as the whole zone
shifting infrastructure so drop them all.

This shouldn't introduce any functional changes.

Link: http://lkml.kernel.org/r/20170515085827.16474-15-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 
 mm/memory_hotplug.c            |  207 -------------------------------
 2 files changed, 209 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework
+++ a/include/linux/memory_hotplug.h
@@ -295,8 +295,6 @@ extern int walk_memory_range(unsigned lo
 		void *arg, int (*func)(struct memory_block *, void *));
 extern int add_memory(int nid, u64 start, u64 size);
 extern int add_memory_resource(int nid, struct resource *resource, bool online);
-extern int zone_for_memory(int nid, u64 start, u64 size, int zone_default,
-		bool for_device);
 extern int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages);
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework
+++ a/mm/memory_hotplug.c
@@ -300,180 +300,6 @@ void __init register_page_bootmem_info_n
 }
 #endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
-static void __meminit grow_zone_span(struct zone *zone, unsigned long start_pfn,
-				     unsigned long end_pfn)
-{
-	unsigned long old_zone_end_pfn;
-
-	zone_span_writelock(zone);
-
-	old_zone_end_pfn = zone_end_pfn(zone);
-	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
-
-	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
-				zone->zone_start_pfn;
-
-	zone_span_writeunlock(zone);
-}
-
-static void resize_zone(struct zone *zone, unsigned long start_pfn,
-		unsigned long end_pfn)
-{
-	zone_span_writelock(zone);
-
-	if (end_pfn - start_pfn) {
-		zone->zone_start_pfn = start_pfn;
-		zone->spanned_pages = end_pfn - start_pfn;
-	} else {
-		/*
-		 * make it consist as free_area_init_core(),
-		 * if spanned_pages = 0, then keep start_pfn = 0
-		 */
-		zone->zone_start_pfn = 0;
-		zone->spanned_pages = 0;
-	}
-
-	zone_span_writeunlock(zone);
-}
-
-static void fix_zone_id(struct zone *zone, unsigned long start_pfn,
-		unsigned long end_pfn)
-{
-	enum zone_type zid = zone_idx(zone);
-	int nid = zone->zone_pgdat->node_id;
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn++)
-		set_page_links(pfn_to_page(pfn), zid, nid, pfn);
-}
-
-static void __ref ensure_zone_is_initialized(struct zone *zone,
-			unsigned long start_pfn, unsigned long num_pages)
-{
-	if (!zone_is_initialized(zone))
-		init_currently_empty_zone(zone, start_pfn, num_pages);
-}
-
-static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long flags;
-	unsigned long z1_start_pfn;
-
-	ensure_zone_is_initialized(z1, start_pfn, end_pfn - start_pfn);
-
-	pgdat_resize_lock(z1->zone_pgdat, &flags);
-
-	/* can't move pfns which are higher than @z2 */
-	if (end_pfn > zone_end_pfn(z2))
-		goto out_fail;
-	/* the move out part must be at the left most of @z2 */
-	if (start_pfn > z2->zone_start_pfn)
-		goto out_fail;
-	/* must included/overlap */
-	if (end_pfn <= z2->zone_start_pfn)
-		goto out_fail;
-
-	/* use start_pfn for z1's start_pfn if z1 is empty */
-	if (!zone_is_empty(z1))
-		z1_start_pfn = z1->zone_start_pfn;
-	else
-		z1_start_pfn = start_pfn;
-
-	resize_zone(z1, z1_start_pfn, end_pfn);
-	resize_zone(z2, end_pfn, zone_end_pfn(z2));
-
-	pgdat_resize_unlock(z1->zone_pgdat, &flags);
-
-	fix_zone_id(z1, start_pfn, end_pfn);
-
-	return 0;
-out_fail:
-	pgdat_resize_unlock(z1->zone_pgdat, &flags);
-	return -1;
-}
-
-static int __meminit move_pfn_range_right(struct zone *z1, struct zone *z2,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long flags;
-	unsigned long z2_end_pfn;
-
-	ensure_zone_is_initialized(z2, start_pfn, end_pfn - start_pfn);
-
-	pgdat_resize_lock(z1->zone_pgdat, &flags);
-
-	/* can't move pfns which are lower than @z1 */
-	if (z1->zone_start_pfn > start_pfn)
-		goto out_fail;
-	/* the move out part mast at the right most of @z1 */
-	if (zone_end_pfn(z1) >  end_pfn)
-		goto out_fail;
-	/* must included/overlap */
-	if (start_pfn >= zone_end_pfn(z1))
-		goto out_fail;
-
-	/* use end_pfn for z2's end_pfn if z2 is empty */
-	if (!zone_is_empty(z2))
-		z2_end_pfn = zone_end_pfn(z2);
-	else
-		z2_end_pfn = end_pfn;
-
-	resize_zone(z1, z1->zone_start_pfn, start_pfn);
-	resize_zone(z2, start_pfn, z2_end_pfn);
-
-	pgdat_resize_unlock(z1->zone_pgdat, &flags);
-
-	fix_zone_id(z2, start_pfn, end_pfn);
-
-	return 0;
-out_fail:
-	pgdat_resize_unlock(z1->zone_pgdat, &flags);
-	return -1;
-}
-
-static void __meminit grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
-				      unsigned long end_pfn)
-{
-	unsigned long old_pgdat_end_pfn = pgdat_end_pfn(pgdat);
-
-	if (!pgdat->node_spanned_pages || start_pfn < pgdat->node_start_pfn)
-		pgdat->node_start_pfn = start_pfn;
-
-	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
-					pgdat->node_start_pfn;
-}
-
-static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
-{
-	struct pglist_data *pgdat = zone->zone_pgdat;
-	int nr_pages = PAGES_PER_SECTION;
-	int nid = pgdat->node_id;
-	int zone_type;
-	unsigned long flags, pfn;
-
-	zone_type = zone - pgdat->node_zones;
-	ensure_zone_is_initialized(zone, phys_start_pfn, nr_pages);
-
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
-	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
-			phys_start_pfn + nr_pages);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
-	memmap_init_zone(nr_pages, nid, zone_type,
-			 phys_start_pfn, MEMMAP_HOTPLUG);
-
-	/* online_page_range is called later and expects pages reserved */
-	for (pfn = phys_start_pfn; pfn < phys_start_pfn + nr_pages; pfn++) {
-		if (!pfn_valid(pfn))
-			continue;
-
-		SetPageReserved(pfn_to_page(pfn));
-	}
-	return 0;
-}
-
 static int __meminit __add_section(int nid, unsigned long phys_start_pfn,
 		bool want_memblock)
 {
@@ -1356,39 +1182,6 @@ static int check_hotplug_memory_range(u6
 	return 0;
 }
 
-/*
- * If movable zone has already been setup, newly added memory should be check.
- * If its address is higher than movable zone, it should be added as movable.
- * Without this check, movable zone may overlap with other zone.
- */
-static int should_add_memory_movable(int nid, u64 start, u64 size)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	pg_data_t *pgdat = NODE_DATA(nid);
-	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
-
-	if (zone_is_empty(movable_zone))
-		return 0;
-
-	if (movable_zone->zone_start_pfn <= start_pfn)
-		return 1;
-
-	return 0;
-}
-
-int zone_for_memory(int nid, u64 start, u64 size, int zone_default,
-		bool for_device)
-{
-#ifdef CONFIG_ZONE_DEVICE
-	if (for_device)
-		return ZONE_DEVICE;
-#endif
-	if (should_add_memory_movable(nid, start, size))
-		return ZONE_MOVABLE;
-
-	return zone_default;
-}
