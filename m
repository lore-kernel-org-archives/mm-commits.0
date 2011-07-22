From: akpm@linux-foundation.org
Subject: + mm-make-some-struct-pages-const.patch added to -mm tree
Date: Fri, 22 Jul 2011 14:07:11 -0700
Message-ID: <201107222107.p6ML7Bjn012348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158Ab1GVVHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 17:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, walken@google.com


The patch titled
     mm: make some struct page's const
has been added to the -mm tree.  Its filename is
     mm-make-some-struct-pages-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make some struct page's const
From: Ian Campbell <ian.campbell@citrix.com>

These uses are read-only and in a subsequent patch I have a const struct
page in my hand...

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 +++++-----
 mm/sparse.c        |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-make-some-struct-pages-const include/linux/mm.h
--- a/include/linux/mm.h~mm-make-some-struct-pages-const
+++ a/include/linux/mm.h
@@ -636,7 +636,7 @@ static inline pte_t maybe_mkwrite(pte_t 
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
-static inline enum zone_type page_zonenum(struct page *page)
+static inline enum zone_type page_zonenum(const struct page *page)
 {
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
@@ -664,15 +664,15 @@ static inline int zone_to_nid(struct zon
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
@@ -717,7 +717,7 @@ static inline void set_page_links(struct
  */
 #include <linux/vmstat.h>
 
-static __always_inline void *lowmem_page_address(struct page *page)
+static __always_inline void *lowmem_page_address(const struct page *page)
 {
 	return __va(PFN_PHYS(page_to_pfn(page)));
 }
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

mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
linux-next.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
xen-balloon-memory-hotplug-support-for-xen-balloon-driver.patch

