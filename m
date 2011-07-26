From: akpm@linux-foundation.org
Subject: [merged] mm-make-some-struct-pages-const.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:02 -0700
Message-ID: <201107260751.p6Q7p5pT002922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404Ab1GZHwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian.campbell@citrix.com, aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: make some struct page's const
has been removed from the -mm tree.  Its filename was
     mm-make-some-struct-pages-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make some struct page's const
From: Ian Campbell <ian.campbell@citrix.com>

These uses are read-only and in a subsequent patch I have a const struct
page in my hand...

[akpm@linux-foundation.org: fix warnings in lowmem_page_address()]
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++------
 mm/sparse.c        |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-make-some-struct-pages-const include/linux/mm.h
--- a/include/linux/mm.h~mm-make-some-struct-pages-const
+++ a/include/linux/mm.h
@@ -637,7 +637,7 @@ static inline pte_t maybe_mkwrite(pte_t 
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
-static inline enum zone_type page_zonenum(struct page *page)
+static inline enum zone_type page_zonenum(const struct page *page)
 {
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
@@ -665,15 +665,15 @@ static inline int zone_to_nid(struct zon
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-extern int page_to_nid(struct page *page);
+extern int page_to_nid(const struct page *page);
 #else
-static inline int page_to_nid(struct page *page)
+static inline int page_to_nid(const struct page *page)
 {
 	return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
-static inline struct zone *page_zone(struct page *page)
+static inline struct zone *page_zone(const struct page *page)
 {
 	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
 }
@@ -718,9 +718,9 @@ static inline void set_page_links(struct
  */
 #include <linux/vmstat.h>
 
-static __always_inline void *lowmem_page_address(struct page *page)
+static __always_inline void *lowmem_page_address(const struct page *page)
 {
-	return __va(PFN_PHYS(page_to_pfn(page)));
+	return __va(PFN_PHYS(page_to_pfn((struct page *)page)));
 }
 
 #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
diff -puN mm/sparse.c~mm-make-some-struct-pages-const mm/sparse.c
--- a/mm/sparse.c~mm-make-some-struct-pages-const
+++ a/mm/sparse.c
@@ -40,7 +40,7 @@ static u8 section_to_node_table[NR_MEM_S
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
-int page_to_nid(struct page *page)
+int page_to_nid(const struct page *page)
 {
 	return section_to_node_table[page_to_section(page)];
 }
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

origin.patch

