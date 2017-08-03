From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch added to -mm tree
Date: Thu, 03 Aug 2017 15:54:18 -0700
Message-ID: <5983a99a.vkl62BXVJYp9J1rJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdHCWyT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 18:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, lcapitulino@redhat.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: do not allocate non-migrateable gigantic pages from movable zones
has been added to the -mm tree.  Its filename is
     mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch

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

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
treewide-remove-gfp_temporary-allocation-flag.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
fs-proc-remove-priv-argument-from-is_stack.patch

