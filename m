From: akpm@linux-foundation.org
Subject: - do-not-group-pages-by-mobility-type-on-low-memory-systems.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:46 -0700
Message-ID: <200710162034.l9GKYk18014992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966099AbXJPVrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Do not group pages by mobility type on low memory systems
has been removed from the -mm tree.  Its filename was
     do-not-group-pages-by-mobility-type-on-low-memory-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Do not group pages by mobility type on low memory systems
From: Mel Gorman <mel@csn.ul.ie>

Grouping pages by mobility can only successfully operate when there are more
MAX_ORDER_NR_PAGES areas than mobility types.  When there are insufficient
areas, fallbacks cannot be avoided.  This has noticeable performance impacts
on machines with small amounts of memory in comparison to MAX_ORDER_NR_PAGES. 
For example, on IA64 with a configuration including huge pages spans 1GiB with
MAX_ORDER_NR_PAGES so would need at least 4GiB of RAM before grouping pages by
mobility would be useful.  In comparison, an x86 would need 16MB.

This patch checks the size of vm_total_pages in build_all_zonelists(). If
there are not enough areas,  mobility is effectivly disabled by considering
all allocations as the same type (UNMOVABLE).  This is achived via a
__read_mostly flag.

With this patch, performance is comparable to disabling grouping pages
by mobility at compile-time on a test machine with insufficient memory.
With this patch, it is reasonable to get rid of grouping pages by mobility
a compile-time option.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~do-not-group-pages-by-mobility-type-on-low-memory-systems mm/page_alloc.c
--- a/mm/page_alloc.c~do-not-group-pages-by-mobility-type-on-low-memory-systems
+++ a/mm/page_alloc.c
@@ -159,8 +159,13 @@ EXPORT_SYMBOL(nr_node_ids);
 #endif
 
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
+int page_group_by_mobility_disabled __read_mostly;
+
 static inline int get_pageblock_migratetype(struct page *page)
 {
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
@@ -174,6 +179,9 @@ static inline int allocflags_to_migratet
 {
 	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
 	/* Cluster high-order atomic allocations together */
 	if (unlikely(order > 0) &&
 			(!(gfp_flags & __GFP_WAIT) || in_interrupt()))
@@ -2375,9 +2383,23 @@ void build_all_zonelists(void)
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
-	printk("Built %i zonelists in %s order.  Total pages: %ld\n",
+	/*
+	 * Disable grouping by mobility if the number of pages in the
+	 * system is too low to allow the mechanism to work. It would be
+	 * more accurate, but expensive to check per-zone. This check is
+	 * made on memory-hotadd so a system can start with mobility
+	 * disabled and enable it later
+	 */
+	if (vm_total_pages < (MAX_ORDER_NR_PAGES * MIGRATE_TYPES))
+		page_group_by_mobility_disabled = 1;
+	else
+		page_group_by_mobility_disabled = 0;
+
+	printk("Built %i zonelists in %s order, mobility grouping %s.  "
+		"Total pages: %ld\n",
 			num_online_nodes(),
 			zonelist_order_name[current_zonelist_order],
+			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
 #ifdef CONFIG_NUMA
 	printk("Policy zone: %s\n", zone_names[policy_zone]);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
