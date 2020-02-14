From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_extc-drop-pfn_present-check-when-onlining.patch
 added to -mm tree
Date: Thu, 13 Feb 2020 21:31:04 -0800
Message-ID: <20200214053104.f9LibXMxN%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgBNFbF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:31:05 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, rafael@kernel.org


The patch titled
     Subject: mm/page_ext.c: drop pfn_present() check when onlining
has been added to the -mm tree.  Its filename is
     mm-page_extc-drop-pfn_present-check-when-onlining.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_extc-drop-pfn_present-check-when-onlining.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_extc-drop-pfn_present-check-when-onlining.patch

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
-		if (!pfn_present(pfn))
-			continue;
+	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION)
 		fail = init_section_page_ext(pfn, nid);
-	}
 	if (!fail)
 		return 0;
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
drivers-base-memoryc-drop-section_count.patch
drivers-base-memoryc-drop-pages_correctly_probed.patch
mm-page_extc-drop-pfn_present-check-when-onlining.patch
