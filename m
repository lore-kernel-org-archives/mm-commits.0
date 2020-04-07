From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 057/166] mm/memory_hotplug.c: cleanup
 __add_pages()
Date: Mon, 06 Apr 2020 20:06:56 -0700
Message-ID: <20200407030656.IT7_TBcr-%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgDGDG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:06:58 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de, richard.weiyang@gmail.com, segher@kernel.crashing.org, torvalds@linux-foundation.org

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
