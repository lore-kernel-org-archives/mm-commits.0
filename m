From: akpm@linux-foundation.org
Subject: + mm-uninline-and-cleanup-page-mapping-related-helpers.patch
 added to -mm tree
Date: Thu, 02 Apr 2015 13:02:03 -0700
Message-ID: <551da03b.XWpiEjV4sSQ+a54g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbDBUCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 16:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, cl@linux.com, koct9i@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline and cleanup page-mapping related helpers
has been added to the -mm tree.  Its filename is
     mm-uninline-and-cleanup-page-mapping-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uninline-and-cleanup-page-mapping-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uninline-and-cleanup-page-mapping-related-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    9 +-------
 include/linux/rmap.h |    9 --------
 mm/util.c            |   42 +++++++++++++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-and-cleanup-page-mapping-related-helpers include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-and-cleanup-page-mapping-related-helpers
+++ a/include/linux/mm.h
@@ -910,15 +910,10 @@ void page_address_init(void);
 #define page_address_init()  do { } while(0)
 #endif
 
+extern void *page_rmapping(struct page *page);
+extern struct anon_vma *page_anon_vma(struct page *page);
 extern struct address_space *page_mapping(struct page *page);
 
-/* Neutral page->mapping pointer to address_space or anon_vma or other */
-static inline void *page_rmapping(struct page *page)
-{
-	page = compound_head(page);
-	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
-}
-
 extern struct address_space *__page_file_mapping(struct page *);
 
 static inline
diff -puN include/linux/rmap.h~mm-uninline-and-cleanup-page-mapping-related-helpers include/linux/rmap.h
--- a/include/linux/rmap.h~mm-uninline-and-cleanup-page-mapping-related-helpers
+++ a/include/linux/rmap.h
@@ -105,15 +105,6 @@ static inline void put_anon_vma(struct a
 		__put_anon_vma(anon_vma);
 }
 
-static inline struct anon_vma *page_anon_vma(struct page *page)
-{
-	page = compound_head(page);
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
@@ -325,12 +325,39 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+static inline void * __page_rmapping(struct page *page)
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
-	struct address_space *mapping;
+	unsigned long mapping;
 
 	page = compound_head(page);
-	mapping = page->mapping;
 
 	/* This happens if someone calls flush_dcache_page on slab page */
 	if (unlikely(PageSlab(page)))
@@ -340,10 +367,13 @@ struct address_space *page_mapping(struc
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

mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
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
mm-sanitize-page-mapping-for-tail-pages-v2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
linux-next.patch

