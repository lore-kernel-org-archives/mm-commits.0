From: akpm@linux-foundation.org
Subject: [merged] mm-add-section_in_page_flags.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:26 -0800
Message-ID: <20130225205426.B143B5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37447 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BYUy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:28 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so347912ggi.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add SECTION_IN_PAGE_FLAGS
has been removed from the -mm tree.  Its filename was
     mm-add-section_in_page_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

