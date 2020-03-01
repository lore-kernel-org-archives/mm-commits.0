From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-memory=5Fhotplug-simplify-calculation-of-number-of-pages?=
 =?US-ASCII?Q?-in-=5F=5Fremove=5Fpages.patch?= added to -mm tree
Date: Sat, 29 Feb 2020 20:19:09 -0800
Message-ID: <20200301041909.2oTdlddQi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgCAETK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:19:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de, richard.weiyang@gmail.com, segher@kernel.crashing.org


The patch titled
     Subject: mm/memory_hotplug.c: simplify calculation of number of pages in __remove_pages()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug.c: simplify calculation of number of pages in __remove_pages()

In commit 52fb87c81f11 ("mm/memory_hotplug: cleanup __remove_pages()"), we
cleaned up __remove_pages(), and introduced a shorter variant to calculate
the number of pages to the next section boundary.

Turns out we can make this calculation easier to read.  We always want to
have the number of pages (> 0) to the next section boundary, starting fro=
m the current pfn.

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
drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
drivers-base-memoryc-drop-section_count.patch
drivers-base-memoryc-drop-pages_correctly_probed.patch
mm-page_extc-drop-pfn_present-check-when-onlining.patch
mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch
mm-memory_hotplug-cleanup-__add_pages.patch
