From: akpm@linux-foundation.org
Subject: + mm-fix-__page_to_pfn-for-a-const-struct-page-argument.patch added to -mm tree
Date: Wed, 17 Aug 2011 12:22:57 -0700
Message-ID: <201108171922.p7HJMvhd022836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab1HQTX4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 15:23:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, walken@google.com


The patch titled
     mm: fix __page_to_pfn() for a const struct page argument
has been added to the -mm tree.  Its filename is
     mm-fix-__page_to_pfn-for-a-const-struct-page-argument.patch

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
Subject: mm: fix __page_to_pfn() for a const struct page argument
From: Ian Campbell <ian.campbell@citrix.com>

This allows the cast in lowmem_page_address (introduced as a warning fixup
to 33dd4e0ec911 "mm: make some struct page's const") to be removed.

Propagate const'ness to page_to_section() as well since it is required by
__page_to_pfn.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    4 ++--
 include/linux/mm.h                 |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/memory_model.h~mm-fix-__page_to_pfn-for-a-const-struct-page-argument include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~mm-fix-__page_to_pfn-for-a-const-struct-page-argument
+++ a/include/asm-generic/memory_model.h
@@ -39,7 +39,7 @@
 })
 
 #define __page_to_pfn(pg)						\
-({	struct page *__pg = (pg);					\
+({	const struct page *__pg = (pg);					\
 	struct pglist_data *__pgdat = NODE_DATA(page_to_nid(__pg));	\
 	(unsigned long)(__pg - __pgdat->node_mem_map) +			\
 	 __pgdat->node_start_pfn;					\
@@ -57,7 +57,7 @@
  * section[i].section_mem_map == mem_map's address - start_pfn;
  */
 #define __page_to_pfn(pg)					\
-({	struct page *__pg = (pg);				\
+({	const struct page *__pg = (pg);				\
 	int __sec = page_to_section(__pg);			\
 	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
diff -puN include/linux/mm.h~mm-fix-__page_to_pfn-for-a-const-struct-page-argument include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-__page_to_pfn-for-a-const-struct-page-argument
+++ a/include/linux/mm.h
@@ -685,7 +685,7 @@ static inline void set_page_section(stru
 	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
-static inline unsigned long page_to_section(struct page *page)
+static inline unsigned long page_to_section(const struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
@@ -720,7 +720,7 @@ static inline void set_page_links(struct
 
 static __always_inline void *lowmem_page_address(const struct page *page)
 {
-	return __va(PFN_PHYS(page_to_pfn((struct page *)page)));
+	return __va(PFN_PHYS(page_to_pfn(page)));
 }
 
 #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

mm-make-hashed_page_virtual-page_address-struct-page-argument-const.patch
mm-fix-__page_to_pfn-for-a-const-struct-page-argument.patch

