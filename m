From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 056/166] mm/memory_hotplug.c: simplify calculation
 of number of pages in __remove_pages()
Date: Mon, 06 Apr 2020 20:06:53 -0700
Message-ID: <20200407030653.PJ_dMcGKr%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDG4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:06:56 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de, richard.weiyang@gmail.com, segher@kernel.crashing.org, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug.c: simplify calculation of number of pages in __remove_pages()

In commit 52fb87c81f11 ("mm/memory_hotplug: cleanup __remove_pages()"), we
cleaned up __remove_pages(), and introduced a shorter variant to calculate
the number of pages to the next section boundary.

Turns out we can make this calculation easier to read.  We always want to
have the number of pages (> 0) to the next section boundary, starting from
the current pfn.

We'll clean up __remove_pages() in a follow-up patch and directly make use
of this computation.

Link: http://lkml.kernel.org/r/20200228095819.10750-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages
+++ a/mm/memory_hotplug.c
@@ -534,7 +534,8 @@ void __remove_pages(unsigned long pfn, u
 	for (; pfn < end_pfn; pfn += cur_nr_pages) {
 		cond_resched();
 		/* Select all remaining pages up to the next section boundary */
-		cur_nr_pages = min(end_pfn - pfn, -(pfn | PAGE_SECTION_MASK));
+		cur_nr_pages = min(end_pfn - pfn,
+				   SECTION_ALIGN_UP(pfn + 1) - pfn);
 		__remove_section(pfn, cur_nr_pages, map_offset, altmap);
 		map_offset = 0;
 	}
_
