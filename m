From: akpm@linux-foundation.org
Subject: - memory_hotplug-always-initialize-pageblock-bitmap.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:27 -0700
Message-ID: <200805162253.m4GMrR6H003141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777AbYEPWzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, apw@shadowen.org, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org, y-goto@jp.fujitsu.com, mm-commits@vger


The patch titled
     memory_hotplug: always initialize pageblock bitmap
has been removed from the -mm tree.  Its filename was
     memory_hotplug-always-initialize-pageblock-bitmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_hotplug: always initialize pageblock bitmap
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to online a new memory section that was added via memory hotplug
sometimes results in crashes when the new pages are added via __free_page.
 Reason for that is that the pageblock bitmap isn't initialized and hence
contains random stuff.  That means that get_pageblock_migratetype()
returns also random stuff and therefore

	list_add(&page->lru,
		&zone->free_area[order].free_list[migratetype]);

in __free_one_page() tries to do a list_add to something that isn't even
necessarily a list.

This happens since 86051ca5eaf5e560113ec7673462804c54284456 ("mm: fix
usemap initialization") which makes sure that the pageblock bitmap gets
only initialized for pages present in a zone.  Unfortunately for hot-added
memory the zones "grow" after the memmap and the pageblock memmap have
been initialized.  Which means that the new pages have an unitialized
bitmap.  To solve this the calls to grow_zone_span() and grow_pgdat_span()
are moved to __add_zone() just before the initialization happens.

The patch also moves the two functions since __add_zone() is the only
caller and I didn't want to add a forward declaration.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   83 ++++++++++++++++++++++--------------------
 mm/page_alloc.c     |    3 -
 2 files changed, 45 insertions(+), 41 deletions(-)

diff -puN mm/memory_hotplug.c~memory_hotplug-always-initialize-pageblock-bitmap mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-always-initialize-pageblock-bitmap
+++ a/mm/memory_hotplug.c
@@ -159,17 +159,58 @@ void register_page_bootmem_info_node(str
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
+static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
+			   unsigned long end_pfn)
+{
+	unsigned long old_zone_end_pfn;
+
+	zone_span_writelock(zone);
+
+	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	if (start_pfn < zone->zone_start_pfn)
+		zone->zone_start_pfn = start_pfn;
+
+	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
+				zone->zone_start_pfn;
+
+	zone_span_writeunlock(zone);
+}
+
+static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
+			    unsigned long end_pfn)
+{
+	unsigned long old_pgdat_end_pfn =
+		pgdat->node_start_pfn + pgdat->node_spanned_pages;
+
+	if (start_pfn < pgdat->node_start_pfn)
+		pgdat->node_start_pfn = start_pfn;
+
+	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
+					pgdat->node_start_pfn;
+}
+
 static int __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nr_pages = PAGES_PER_SECTION;
 	int nid = pgdat->node_id;
 	int zone_type;
+	unsigned long flags;
 
 	zone_type = zone - pgdat->node_zones;
-	if (!zone->wait_table)
-		return init_currently_empty_zone(zone, phys_start_pfn,
-						 nr_pages, MEMMAP_HOTPLUG);
+	if (!zone->wait_table) {
+		int ret;
+
+		ret = init_currently_empty_zone(zone, phys_start_pfn,
+						nr_pages, MEMMAP_HOTPLUG);
+		if (ret)
+			return ret;
+	}
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
+	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
+			phys_start_pfn + nr_pages);
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;
@@ -295,36 +336,6 @@ int __remove_pages(struct zone *zone, un
 }
 EXPORT_SYMBOL_GPL(__remove_pages);
 
-static void grow_zone_span(struct zone *zone,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long old_zone_end_pfn;
-
-	zone_span_writelock(zone);
-
-	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	if (start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
-
-	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
-				zone->zone_start_pfn;
-
-	zone_span_writeunlock(zone);
-}
-
-static void grow_pgdat_span(struct pglist_data *pgdat,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long old_pgdat_end_pfn =
-		pgdat->node_start_pfn + pgdat->node_spanned_pages;
-
-	if (start_pfn < pgdat->node_start_pfn)
-		pgdat->node_start_pfn = start_pfn;
-
-	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
-					pgdat->node_start_pfn;
-}
-
 void online_page(struct page *page)
 {
 	totalram_pages++;
@@ -363,7 +374,6 @@ static int online_pages_range(unsigned l
 
 int online_pages(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned long flags;
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
@@ -391,11 +401,6 @@ int online_pages(unsigned long pfn, unsi
 	 * memory_block->state_mutex.
 	 */
 	zone = page_zone(pfn_to_page(pfn));
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	grow_zone_span(zone, pfn, pfn + nr_pages);
-	grow_pgdat_span(zone->zone_pgdat, pfn, pfn + nr_pages);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
-
 	/*
 	 * If this zone is not populated, then it is not in zonelist.
 	 * This means the page allocator ignores this zone.
diff -puN mm/page_alloc.c~memory_hotplug-always-initialize-pageblock-bitmap mm/page_alloc.c
--- a/mm/page_alloc.c~memory_hotplug-always-initialize-pageblock-bitmap
+++ a/mm/page_alloc.c
@@ -2862,8 +2862,6 @@ __meminit int init_currently_empty_zone(
 
 	zone->zone_start_pfn = zone_start_pfn;
 
-	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
