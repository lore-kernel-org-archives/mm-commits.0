From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/67] mm/memory_hotplug: we always have a zone in
 find_(smallest|biggest)_section_pfn
Date: Mon, 03 Feb 2020 17:34:12 -0800
Message-ID: <20200204013412.xsMbePbBR%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBeO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:14 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, torvalds@linux-foundation.org, willy@infradead.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: we always have a zone in find_(smallest|biggest)_section_pfn

With shrink_pgdat_span() out of the way, we now always have a valid zone.

Link: http://lkml.kernel.org/r/20191006085646.5768-8-david@redhat.com
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

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn
+++ a/mm/memory_hotplug.c
@@ -355,7 +355,7 @@ static unsigned long find_smallest_secti
 		if (unlikely(pfn_to_nid(start_pfn) != nid))
 			continue;
 
-		if (zone && zone != page_zone(pfn_to_page(start_pfn)))
+		if (zone != page_zone(pfn_to_page(start_pfn)))
 			continue;
 
 		return start_pfn;
@@ -380,7 +380,7 @@ static unsigned long find_biggest_sectio
 		if (unlikely(pfn_to_nid(pfn) != nid))
 			continue;
 
-		if (zone && zone != page_zone(pfn_to_page(pfn)))
+		if (zone != page_zone(pfn_to_page(pfn)))
 			continue;
 
 		return pfn;
_
