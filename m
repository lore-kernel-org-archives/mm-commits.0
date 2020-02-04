From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
 removed from -mm tree
Date: Tue, 04 Feb 2020 10:40:17 -0800
Message-ID: <20200204184017.Cd8QJe4mK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgBDSkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, willy@infradead.org


The patch titled
     Subject: mm/memory_hotplug: don't check for "all holes" in shrink_zone_span()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: don't check for "all holes" in shrink_zone_span()

If we have holes, the holes will automatically get detected and removed
once we remove the next bigger/smaller section.  The extra checks can go.

Link: http://lkml.kernel.org/r/20191006085646.5768-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span
+++ a/mm/memory_hotplug.c
@@ -411,6 +411,9 @@ static void shrink_zone_span(struct zone
 		if (pfn) {
 			zone->zone_start_pfn = pfn;
 			zone->spanned_pages = zone_end_pfn - pfn;
+		} else {
+			zone->zone_start_pfn = 0;
+			zone->spanned_pages = 0;
 		}
 	} else if (zone_end_pfn == end_pfn) {
 		/*
@@ -423,34 +426,11 @@ static void shrink_zone_span(struct zone
 					       start_pfn);
 		if (pfn)
 			zone->spanned_pages = pfn - zone_start_pfn + 1;
+		else {
+			zone->zone_start_pfn = 0;
+			zone->spanned_pages = 0;
+		}
 	}
-
-	/*
-	 * The section is not biggest or smallest mem_section in the zone, it
-	 * only creates a hole in the zone. So in this case, we need not
-	 * change the zone. But perhaps, the zone has only hole data. Thus
-	 * it check the zone has only hole or not.
-	 */
-	pfn = zone_start_pfn;
-	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(pfn)))
-			continue;
-
-		if (page_zone(pfn_to_page(pfn)) != zone)
-			continue;
-
-		/* Skip range to be removed */
-		if (pfn >= start_pfn && pfn < end_pfn)
-			continue;
-
-		/* If we find valid section, we have nothing to do */
-		zone_span_writeunlock(zone);
-		return;
-	}
