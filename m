From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-cleanup-__add_pages.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:58:48 -0700
Message-ID: <20200408015848.kG7VLzPQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB6t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de, richard.weiyang@gmail.com, segher@kernel.crashing.org


The patch titled
     Subject: mm/memory_hotplug.c: cleanup __add_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-cleanup-__add_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug.c: cleanup __add_pages()

Let's drop the basically unused section stuff and simplify.  The logic now
matches the logic in __remove_pages().

Link: http://lkml.kernel.org/r/20200228095819.10750-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-cleanup-__add_pages
+++ a/mm/memory_hotplug.c
@@ -307,8 +307,9 @@ static int check_hotplug_memory_addressa
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_restrictions *restrictions)
 {
+	const unsigned long end_pfn = pfn + nr_pages;
+	unsigned long cur_nr_pages;
 	int err;
-	unsigned long nr, start_sec, end_sec;
 	struct vmem_altmap *altmap = restrictions->altmap;
 
 	err = check_hotplug_memory_addressable(pfn, nr_pages);
@@ -331,18 +332,13 @@ int __ref __add_pages(int nid, unsigned
 	if (err)
 		return err;
 
-	start_sec = pfn_to_section_nr(pfn);
-	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
-	for (nr = start_sec; nr <= end_sec; nr++) {
-		unsigned long pfns;
