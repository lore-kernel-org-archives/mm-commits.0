From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 12/67] mm/memory_hotplug: cleanup __remove_pages()
Date: Mon, 03 Feb 2020 17:34:23 -0800
Message-ID: <20200204013423.aFPO78Un-%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBe0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:26 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, torvalds@linux-foundation.org, willy@infradead.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: cleanup __remove_pages()

Let's drop the basically unused section stuff and simplify.

Also, let's use a shorter variant to calculate the number of pages to
the next section boundary.

Link: http://lkml.kernel.org/r/20191006085646.5768-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Pankaj Gupta <pagupta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-cleanup-__remove_pages
+++ a/mm/memory_hotplug.c
@@ -516,25 +516,20 @@ static void __remove_section(unsigned lo
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		    struct vmem_altmap *altmap)
 {
+	const unsigned long end_pfn = pfn + nr_pages;
+	unsigned long cur_nr_pages;
 	unsigned long map_offset = 0;
-	unsigned long nr, start_sec, end_sec;
 
 	map_offset = vmem_altmap_offset(altmap);
 
 	if (check_pfn_span(pfn, nr_pages, "remove"))
 		return;
 
-	start_sec = pfn_to_section_nr(pfn);
-	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
-	for (nr = start_sec; nr <= end_sec; nr++) {
-		unsigned long pfns;
