From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:40:20 -0800
Message-ID: <20200204184020.Vsd6w1CLx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgBDSkV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, willy@infradead.org


The patch titled
     Subject: mm/memory_hotplug: drop local variables in shrink_zone_span()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: drop local variables in shrink_zone_span()

Get rid of the unnecessary local variables.

Link: http://lkml.kernel.org/r/20191006085646.5768-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-local-variables-in-shrink_zone_span
+++ a/mm/memory_hotplug.c
@@ -392,14 +392,11 @@ static unsigned long find_biggest_sectio
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
-	unsigned long zone_start_pfn = zone->zone_start_pfn;
-	unsigned long z = zone_end_pfn(zone); /* zone_end_pfn namespace clash */
-	unsigned long zone_end_pfn = z;
 	unsigned long pfn;
 	int nid = zone_to_nid(zone);
 
 	zone_span_writelock(zone);
-	if (zone_start_pfn == start_pfn) {
+	if (zone->zone_start_pfn == start_pfn) {
 		/*
 		 * If the section is smallest section in the zone, it need
 		 * shrink zone->zone_start_pfn and zone->zone_spanned_pages.
@@ -407,25 +404,25 @@ static void shrink_zone_span(struct zone
 		 * for shrinking zone.
 		 */
 		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
-						zone_end_pfn);
+						zone_end_pfn(zone));
 		if (pfn) {
+			zone->spanned_pages = zone_end_pfn(zone) - pfn;
 			zone->zone_start_pfn = pfn;
-			zone->spanned_pages = zone_end_pfn - pfn;
 		} else {
 			zone->zone_start_pfn = 0;
 			zone->spanned_pages = 0;
 		}
-	} else if (zone_end_pfn == end_pfn) {
+	} else if (zone_end_pfn(zone) == end_pfn) {
 		/*
 		 * If the section is biggest section in the zone, it need
 		 * shrink zone->spanned_pages.
 		 * In this case, we find second biggest valid mem_section for
 		 * shrinking zone.
 		 */
-		pfn = find_biggest_section_pfn(nid, zone, zone_start_pfn,
+		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
-			zone->spanned_pages = pfn - zone_start_pfn + 1;
+			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
 		else {
 			zone->zone_start_pfn = 0;
 			zone->spanned_pages = 0;
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
