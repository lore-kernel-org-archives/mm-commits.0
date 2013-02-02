From: akpm@linux-foundation.org
Subject: + mm-add-zone_is_empty-and-zone_is_initialized.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:39:46 -0800
Message-ID: <20130202003947.2B82931C1FA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50458 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3BBAjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:39:48 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so503934vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:39:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm: add zone_is_empty() and zone_is_initialized()
has been added to the -mm tree.  Its filename is
     mm-add-zone_is_empty-and-zone_is_initialized.patch

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
Subject: mm: add zone_is_empty() and zone_is_initialized()

Factoring out these 2 checks makes it more clear what we are actually
checking for.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/mmzone.h~mm-add-zone_is_empty-and-zone_is_initialized include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-zone_is_empty-and-zone_is_initialized
+++ a/include/linux/mmzone.h
@@ -537,6 +537,16 @@ static inline bool zone_spans_pfn(const 
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
+static inline bool zone_is_initialized(struct zone *zone)
+{
+	return !!zone->wait_table;
+}
+
+static inline bool zone_is_empty(struct zone *zone)
+{
+	return zone->spanned_pages == 0;
+}
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
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

