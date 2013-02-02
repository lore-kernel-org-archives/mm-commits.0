From: akpm@linux-foundation.org
Subject: + mm-add-section_in_page_flags.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:39:41 -0800
Message-ID: <20130202003941.6FD1D5A41B5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:37394 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3BBAjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:39:42 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so504563ghb.0
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:39:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm: add SECTION_IN_PAGE_FLAGS
has been added to the -mm tree.  Its filename is
     mm-add-section_in_page_flags.patch

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
Subject: mm: add SECTION_IN_PAGE_FLAGS

Instead of directly utilizing a combination of config options to determine
this, add a macro to specifically address it.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-add-section_in_page_flags include/linux/mm.h
--- a/include/linux/mm.h~mm-add-section_in_page_flags
+++ a/include/linux/mm.h
@@ -625,6 +625,10 @@ static inline enum zone_type page_zonenu
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#define SECTION_IN_PAGE_FLAGS
+#endif
+
 /*
  * The identification function is only used by the buddy allocator for
  * determining if two pages could be buddies. We are not really
@@ -708,7 +712,7 @@ static inline struct zone *page_zone(con
 	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
 }
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef SECTION_IN_PAGE_FLAGS
 static inline void set_page_section(struct page *page, unsigned long section)
 {
 	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
@@ -738,7 +742,7 @@ static inline void set_page_links(struct
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef SECTION_IN_PAGE_FLAGS
 	set_page_section(page, pfn_to_section_nr(pfn));
 #endif
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

