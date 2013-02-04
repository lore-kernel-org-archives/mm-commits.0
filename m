From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch added to -mm tree
Date: Mon, 04 Feb 2013 14:11:19 -0800
Message-ID: <20130204221119.EC5C15A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:46793 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3BDWLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 17:11:21 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so757022ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 14:11:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm/memory_hotplug: use pgdat_end_pfn() instead of open coding the same.
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/memory_hotplug: use pgdat_end_pfn() instead of open coding the same.

Replace open coded pgdat_end_pfn() with helper function.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same
+++ a/mm/memory_hotplug.c
@@ -218,7 +218,7 @@ void register_page_bootmem_info_node(str
 	}
 
 	pfn = pgdat->node_start_pfn;
-	end_pfn = pfn + pgdat->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(pgdat);
 
 	/* register_section info */
 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

linux-next.patch
mm-add-section_in_page_flags.patch
mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch
mm-add-zone_is_empty-and-zone_is_initialized.patch
mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
mm-add-helper-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch
maintainers-mm-add-additional-include-files-to-listing.patch

