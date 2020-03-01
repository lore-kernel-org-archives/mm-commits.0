From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-cleanup-__add_pages.patch added to
 -mm tree
Date: Sat, 29 Feb 2020 20:17:46 -0800
Message-ID: <20200301041746.RfknqupBq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgCAERt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de, richard.weiyang@gmail.com, segher@kernel.crashing.org


The patch titled
     Subject: mm/memory_hotplug.c: cleanup __add_pages()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-cleanup-__add_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-cleanup-__add_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-cleanup-__add_pages.patch

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
