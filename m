From: akpm@linux-foundation.org
Subject: [merged] mm-initialize-hotplugged-pages-as-reserved.patch removed from -mm tree
Date: Fri, 07 Aug 2015 12:03:22 -0700
Message-ID: <55c500fa.1DQgVKYkGBFnB+1Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, david.vrabel@citrix.com, holt@sgi.com, mgorman@suse.de, nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: initialize hotplugged pages as reserved
has been removed from the -mm tree.  Its filename was
     mm-initialize-hotplugged-pages-as-reserved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: initialize hotplugged pages as reserved

Commit 92923ca3aace (mm: meminit: only set page reserved in the memblock
region) broke memory hotplug which expects the memmap for newly added
sections to be reserved until onlined by online_pages_range().  This patch
marks hotplugged pages as reserved when adding new zones.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: David Vrabel <david.vrabel@citrix.com>
Tested-by: David Vrabel <david.vrabel@citrix.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-initialize-hotplugged-pages-as-reserved mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-initialize-hotplugged-pages-as-reserved
+++ a/mm/memory_hotplug.c
@@ -446,7 +446,7 @@ static int __meminit __add_zone(struct z
 	int nr_pages = PAGES_PER_SECTION;
 	int nid = pgdat->node_id;
 	int zone_type;
-	unsigned long flags;
+	unsigned long flags, pfn;
 	int ret;
 
 	zone_type = zone - pgdat->node_zones;
@@ -461,6 +461,14 @@ static int __meminit __add_zone(struct z
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
+
+	/* online_page_range is called later and expects pages reserved */
+	for (pfn = phys_start_pfn; pfn < phys_start_pfn + nr_pages; pfn++) {
+		if (!pfn_valid(pfn))
+			continue;
+
+		SetPageReserved(pfn_to_page(pfn));
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

origin.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-vmscan-never-isolate-more-pages-than-necessary.patch
vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch

