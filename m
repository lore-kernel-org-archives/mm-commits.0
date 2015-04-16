From: akpm@linux-foundation.org
Subject: [merged]
 mm-uninline-and-cleanup-page-mapping-related-helpers.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:51 -0700
Message-ID: <552fe8e3.2yaWSURmv8UQVIyO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbbDPQrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, cl@linux.com, koct9i@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline and cleanup page-mapping related helpers
has been removed from the -mm tree.  Its filename was
     mm-uninline-and-cleanup-page-mapping-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: uninline and cleanup page-mapping related helpers

Most-used page->mapping helper -- page_mapping() -- has already uninlined.
 Let's uninline also page_rmapping() and page_anon_vma().  It saves us
depending on configuration around 400 bytes in text:

   text	   data	    bss	    dec	    hex	filename
 660318	  99254	 410000	1169572	 11d8a4	mm/built-in.o-before
 659854	  99254	 410000	1169108	 11d6d4	mm/built-in.o

I also tried to make code a bit more clean.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    8 ++------
 include/linux/rmap.h |    8 --------
 mm/util.c            |   41 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 19 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-and-cleanup-page-mapping-related-helpers include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-and-cleanup-page-mapping-related-helpers
+++ a/include/linux/mm.h
@@ -950,14 +950,10 @@ void page_address_init(void);
 #define page_address_init()  do { } while(0)
 #endif
 
+extern void *page_rmapping(struct page *page);
+extern struct anon_vma *page_anon_vma(struct page *page);
 extern struct address_space *page_mapping(struct page *page);
 
-/* Neutral page->mapping pointer to address_space or anon_vma or other */
-static inline void *page_rmapping(struct page *page)
-{
-	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
-}
-
 extern struct address_space *__page_file_mapping(struct page *);
 
 static inline
diff -puN include/linux/rmap.h~mm-uninline-and-cleanup-page-mapping-related-helpers include/linux/rmap.h
--- a/include/linux/rmap.h~mm-uninline-and-cleanup-page-mapping-related-helpers
+++ a/include/linux/rmap.h
@@ -105,14 +105,6 @@ static inline void put_anon_vma(struct a
 		__put_anon_vma(anon_vma);
 }
 
-static inline struct anon_vma *page_anon_vma(struct page *page)
-{
-	if (((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) !=
-					    PAGE_MAPPING_ANON)
-		return NULL;
-	return page_rmapping(page);
-}
-
 static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
diff -puN mm/util.c~mm-uninline-and-cleanup-page-mapping-related-helpers mm/util.c
--- a/mm/util.c~mm-uninline-and-cleanup-page-mapping-related-helpers
+++ a/mm/util.c
@@ -325,9 +325,37 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+static inline void *__page_rmapping(struct page *page)
+{
+	unsigned long mapping;
+
+	mapping = (unsigned long)page->mapping;
+	mapping &= ~PAGE_MAPPING_FLAGS;
+
+	return (void *)mapping;
+}
+
+/* Neutral page->mapping pointer to address_space or anon_vma or other */
+void *page_rmapping(struct page *page)
+{
+	page = compound_head(page);
+	return __page_rmapping(page);
+}
+
+struct anon_vma *page_anon_vma(struct page *page)
+{
+	unsigned long mapping;
+
+	page = compound_head(page);
+	mapping = (unsigned long)page->mapping;
+	if ((mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
+		return NULL;
+	return __page_rmapping(page);
+}
+
 struct address_space *page_mapping(struct page *page)
 {
-	struct address_space *mapping = page->mapping;
+	unsigned long mapping;
 
 	/* This happens if someone calls flush_dcache_page on slab page */
 	if (unlikely(PageSlab(page)))
@@ -337,10 +365,13 @@ struct address_space *page_mapping(struc
 		swp_entry_t entry;
 
 		entry.val = page_private(page);
-		mapping = swap_address_space(entry);
-	} else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
-		mapping = NULL;
-	return mapping;
+		return swap_address_space(entry);
+	}
+
+	mapping = (unsigned long)page->mapping;
+	if (mapping & PAGE_MAPPING_FLAGS)
+		return NULL;
+	return page->mapping;
 }
 
 int overcommit_ratio_handler(struct ctl_table *table, int write,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
linux-next.patch

