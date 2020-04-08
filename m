From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-simplify-calculation-of-number-of-pages?=
 =?US-ASCII?Q?-in-=5F=5Fremove=5Fpages.patch?= removed from -mm tree
Date: Tue, 07 Apr 2020 18:58:45 -0700
Message-ID: <20200408015845.4ZoIMSTzd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de, richard.weiyang@gmail.com, segher@kernel.crashing.org


The patch titled
     Subject: mm/memory_hotplug.c: simplify calculation of number of pages in __remove_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
