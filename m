From: akpm@linux-foundation.org
Subject: + mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:39:55 -0800
Message-ID: <20130202003956.2635631C1FA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:37849 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab3BBAj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:39:57 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so505070yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:39:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm/page_alloc: add informative debugging message in page_outside_zone_boundaries()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch

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
Subject: mm/page_alloc: add informative debugging message in page_outside_zone_boundaries()

Add a debug message which prints when a page is found outside of the
boundaries of the zone it should belong to. Format is:
	"page $pfn outside zone [ $start_pfn - $end_pfn ]"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries
+++ a/mm/page_alloc.c
@@ -246,13 +246,20 @@ static int page_outside_zone_boundaries(
 	int ret = 0;
 	unsigned seq;
 	unsigned long pfn = page_to_pfn(page);
+	unsigned long sp, start_pfn;
 
 	do {
 		seq = zone_span_seqbegin(zone);
+		start_pfn = zone->zone_start_pfn;
+		sp = zone->spanned_pages;
 		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
 	} while (zone_span_seqretry(zone, seq));
 
+	if (ret)
+		pr_debug("page %lu outside zone [ %lu - %lu ]\n",
+			pfn, start_pfn, start_pfn + sp);
+
 	return ret;
 }
 
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

