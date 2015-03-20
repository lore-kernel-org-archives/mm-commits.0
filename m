From: akpm@linux-foundation.org
Subject: + mm-sanitize-page-mapping-for-tail-pages.patch added to -mm tree
Date: Fri, 20 Mar 2015 13:36:30 -0700
Message-ID: <550c84ce.7OZADd2nWOeYil22%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbbCTUgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:36:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sanitize page->mapping for tail pages
has been added to the -mm tree.  Its filename is
     mm-sanitize-page-mapping-for-tail-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sanitize-page-mapping-for-tail-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sanitize-page-mapping-for-tail-pages.patch

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
Subject: mm: sanitize page->mapping for tail pages

We don't define meaning of page->mapping for tail pages.  Currently it's
always NULL, which can be inconsistent with head page and potentially lead
to problems.

Let's poison the pointer to catch all illigal uses.

page_rmapping() and page_mapping() are changed to look on head page.

The only illegal use I've caught so far is __GPF_COMP pages from sound
subsystem, mapped with PTEs.  do_shared_fault() is changed to use
page_rmapping() instead of direct access to fault_page->mapping.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |    1 +
 include/linux/poison.h |    4 ++++
 mm/huge_memory.c       |    2 +-
 mm/memory.c            |    2 +-
 mm/page_alloc.c        |    7 +++++++
 mm/util.c              |    5 ++++-
 6 files changed, 18 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-sanitize-page-mapping-for-tail-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-sanitize-page-mapping-for-tail-pages
+++ a/include/linux/mm.h
@@ -915,6 +915,7 @@ extern struct address_space *page_mappin
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 static inline void *page_rmapping(struct page *page)
 {
+	page = compound_head(page);
 	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
 }
 
diff -puN include/linux/poison.h~mm-sanitize-page-mapping-for-tail-pages include/linux/poison.h
--- a/include/linux/poison.h~mm-sanitize-page-mapping-for-tail-pages
+++ a/include/linux/poison.h
@@ -32,6 +32,10 @@
 /********** mm/debug-pagealloc.c **********/
 #define PAGE_POISON 0xaa
 
+/********** mm/page_alloc.c ************/
+
+#define TAIL_MAPPING	((void *) 0x01014A11 + POISON_POINTER_DELTA)
+
 /********** mm/slab.c **********/
 /*
  * Magic nums for obj red zoning.
diff -puN mm/huge_memory.c~mm-sanitize-page-mapping-for-tail-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/huge_memory.c
@@ -1704,7 +1704,7 @@ static void __split_huge_page_refcount(s
 		*/
 		page_tail->_mapcount = page->_mapcount;
 
-		BUG_ON(page_tail->mapping);
+		BUG_ON(page_tail->mapping != TAIL_MAPPING);
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
diff -puN mm/memory.c~mm-sanitize-page-mapping-for-tail-pages mm/memory.c
--- a/mm/memory.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/memory.c
@@ -3033,7 +3033,7 @@ static int do_shared_fault(struct mm_str
 	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
 	 * release semantics to prevent the compiler from undoing this copying.
 	 */
-	mapping = fault_page->mapping;
+	mapping = page_rmapping(fault_page);
 	unlock_page(fault_page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
 		/*
diff -puN mm/page_alloc.c~mm-sanitize-page-mapping-for-tail-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/page_alloc.c
@@ -373,6 +373,7 @@ void prep_compound_page(struct page *pag
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 		set_page_count(p, 0);
+		p->mapping = TAIL_MAPPING;
 		p->first_page = page;
 		/* Make sure p->first_page is always valid for PageTail() */
 		smp_wmb();
@@ -765,6 +766,12 @@ static void free_one_page(struct zone *z
 
 static int free_tail_pages_check(struct page *head_page, struct page *page)
 {
+	if (page->mapping != TAIL_MAPPING) {
+		bad_page(page, "corrupted mapping in tail page", 0);
+		page->mapping = NULL;
+		return 1;
+	}
+	page->mapping = NULL;
 	if (!IS_ENABLED(CONFIG_DEBUG_VM))
 		return 0;
 	if (unlikely(!PageTail(page))) {
diff -puN mm/util.c~mm-sanitize-page-mapping-for-tail-pages mm/util.c
--- a/mm/util.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/util.c
@@ -327,7 +327,10 @@ EXPORT_SYMBOL(kvfree);
 
 struct address_space *page_mapping(struct page *page)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping;
+
+	page = compound_head(page);
+	mapping = page->mapping;
 
 	/* This happens if someone calls flush_dcache_page on slab page */
 	if (unlikely(PageSlab(page)))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
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

