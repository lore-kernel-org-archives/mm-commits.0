From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_extc-drop-pfn_present-check-when-onlining.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:58:39 -0700
Message-ID: <20200408015839.FRFgfk23G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, rafael@kernel.org


The patch titled
     Subject: mm/page_ext.c: drop pfn_present() check when onlining
has been removed from the -mm tree.  Its filename was
     mm-page_extc-drop-pfn_present-check-when-onlining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_ext.c: drop pfn_present() check when onlining

Since commit c5e79ef561b0 ("mm/memory_hotplug.c: don't allow to
online/offline memory blocks with holes") we disallow to offline any
memory with holes.  As all boot memory is online and hotplugged memory
cannot contain holes, we never online memory with holes.

This present check can be dropped.

Link: http://lkml.kernel.org/r/20200127110424.5757-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_ext.c~mm-page_extc-drop-pfn_present-check-when-onlining
+++ a/mm/page_ext.c
@@ -303,11 +303,8 @@ static int __meminit online_page_ext(uns
 		VM_BUG_ON(!node_state(nid, N_ONLINE));
 	}
 
-	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
-		if (!pfn_in_present_section(pfn))
-			continue;
+	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION)
 		fail = init_section_page_ext(pfn, nid);
-	}
 	if (!fail)
 		return 0;
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
