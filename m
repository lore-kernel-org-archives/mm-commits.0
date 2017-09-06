From: akpm@linux-foundation.org
Subject: [patch 098/119] mm, hugetlb: do not allocate
 non-migrateable gigantic pages from movable zones
Date: Wed, 06 Sep 2017 16:24:03 -0700
Message-ID: <20170906232403.YWSS-TKJz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbdIFXYH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lcapitulino@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: do not allocate non-migrateable gigantic pages from movable zones

alloc_gigantic_page doesn't consider movability of the gigantic hugetlb
when scanning eligible ranges for the allocation.  As 1GB hugetlb pages
are not movable currently this can break the movable zone assumption that
all allocations are migrateable and as such break memory hotplug.

Reorganize the code and use the standard zonelist allocations scheme that
we use for standard hugetbl pages.  htlb_alloc_mask will ensure that only
migratable hugetlb pages will ever see a movable zone.

Link: http://lkml.kernel.org/r/20170803083549.21407-1-mhocko@kernel.org
Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones
+++ a/mm/hugetlb.c
@@ -1066,11 +1066,11 @@ static void free_gigantic_page(struct pa
 }
 
 static int __alloc_gigantic_page(unsigned long start_pfn,
-				unsigned long nr_pages)
+				unsigned long nr_pages, gfp_t gfp_mask)
 {
 	unsigned long end_pfn = start_pfn + nr_pages;
 	return alloc_contig_range(start_pfn, end_pfn, MIGRATE_MOVABLE,
-				  GFP_KERNEL);
+				  gfp_mask);
 }
 
 static bool pfn_range_valid_gigantic(struct zone *z,
@@ -1108,19 +1108,24 @@ static bool zone_spans_last_pfn(const st
 	return zone_spans_pfn(zone, last_pfn);
 }
 
-static struct page *alloc_gigantic_page(int nid, unsigned int order)
+static struct page *alloc_gigantic_page(int nid, struct hstate *h)
 {
+	unsigned int order = huge_page_order(h);
 	unsigned long nr_pages = 1 << order;
 	unsigned long ret, pfn, flags;
-	struct zone *z;
-
-	z = NODE_DATA(nid)->node_zones;
-	for (; z - NODE_DATA(nid)->node_zones < MAX_NR_ZONES; z++) {
-		spin_lock_irqsave(&z->lock, flags);
-
-		pfn = ALIGN(z->zone_start_pfn, nr_pages);
-		while (zone_spans_last_pfn(z, pfn, nr_pages)) {
-			if (pfn_range_valid_gigantic(z, pfn, nr_pages)) {
+	struct zonelist *zonelist;
+	struct zone *zone;
+	struct zoneref *z;
+	gfp_t gfp_mask;
+
+	gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+	zonelist = node_zonelist(nid, gfp_mask);
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), NULL) {
+		spin_lock_irqsave(&zone->lock, flags);
+
+		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
+		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
+			if (pfn_range_valid_gigantic(zone, pfn, nr_pages)) {
 				/*
 				 * We release the zone lock here because
 				 * alloc_contig_range() will also lock the zone
@@ -1128,16 +1133,16 @@ static struct page *alloc_gigantic_page(
 				 * spinning on this lock, it may win the race
 				 * and cause alloc_contig_range() to fail...
 				 */
-				spin_unlock_irqrestore(&z->lock, flags);
-				ret = __alloc_gigantic_page(pfn, nr_pages);
+				spin_unlock_irqrestore(&zone->lock, flags);
+				ret = __alloc_gigantic_page(pfn, nr_pages, gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
-				spin_lock_irqsave(&z->lock, flags);
+				spin_lock_irqsave(&zone->lock, flags);
 			}
 			pfn += nr_pages;
 		}
 
-		spin_unlock_irqrestore(&z->lock, flags);
+		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	return NULL;
@@ -1150,7 +1155,7 @@ static struct page *alloc_fresh_gigantic
 {
 	struct page *page;
 
-	page = alloc_gigantic_page(nid, huge_page_order(h));
+	page = alloc_gigantic_page(nid, h);
 	if (page) {
 		prep_compound_gigantic_page(page, huge_page_order(h));
 		prep_new_huge_page(h, page, nid);
_
