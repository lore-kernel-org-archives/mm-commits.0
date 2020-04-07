From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 054/166] mm/page_ext.c: drop pfn_present() check
 when onlining
Date: Mon, 06 Apr 2020 20:06:47 -0700
Message-ID: <20200407030647.t300q4oF3%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDGs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:06:48 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, rafael@kernel.org, torvalds@linux-foundation.org

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
