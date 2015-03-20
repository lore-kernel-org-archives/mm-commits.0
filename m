From: akpm@linux-foundation.org
Subject: +
 mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch added to
 -mm tree
Date: Fri, 20 Mar 2015 13:35:58 -0700
Message-ID: <550c84ae.PhNuHmzqr9DSO2sn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbCTUf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consolidate all page-flags helpers in <linux/page-flags.h>
has been added to the -mm tree.  Its filename is
     mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch

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
Subject: mm: consolidate all page-flags helpers in <linux/page-flags.h>

Currently we take a naive approach to page flags on compound pages - we
set the flag on the page without consideration if the flag makes sense for
tail page or for compound page in general.  This patchset try to sort this
out by defining per-flag policy on what need to be done if page-flag
helper operate on compound page.

The last patch in the patchset also sanitizes usege of page->mapping for
tail pages.  We don't define the meaning of page->mapping for tail pages. 
Currently it's always NULL, which can be inconsistent with head page and
potentially lead to problems.

For now I caught one case of illegal usage of page flags or ->mapping:
sound subsystem allocates pages with __GFP_COMP and maps them with PTEs. 
It leads to setting dirty bit on tail pages and access to tail_page's
->mapping.  I don't see any bad behaviour caused by this, but worth fixing
anyway.

This patchset makes more sense if you take my THP refcounting into
account: we will see more compound pages mapped with PTEs and we need to
define behaviour of flags on compound pages to avoid bugs.



This patch (of 16):

We have page-flags helper function declarations/definitions spread over
several header files.  Let's consolidate them in <linux/page-flags.h>.

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

 include/linux/hugetlb.h    |    7 --
 include/linux/ksm.h        |   17 ------
 include/linux/mm.h         |   81 -----------------------------
 include/linux/page-flags.h |   96 +++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 105 deletions(-)

diff -puN include/linux/hugetlb.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh
+++ a/include/linux/hugetlb.h
@@ -46,8 +46,6 @@ struct hugepage_subpool *hugepage_new_su
 						long min_size);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
-int PageHuge(struct page *page);
-
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
@@ -114,11 +112,6 @@ unsigned long hugetlb_change_protection(
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
-static inline int PageHuge(struct page *page)
-{
-	return 0;
-}
-
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
diff -puN include/linux/ksm.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh include/linux/ksm.h
--- a/include/linux/ksm.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh
+++ a/include/linux/ksm.h
@@ -35,18 +35,6 @@ static inline void ksm_exit(struct mm_st
 		__ksm_exit(mm);
 }
 
-/*
- * A KSM page is one of those write-protected "shared pages" or "merged pages"
- * which KSM maps into multiple mms, wherever identical anonymous page content
- * is found in VM_MERGEABLE vmas.  It's a PageAnon page, pointing not to any
- * anon_vma, but to that page's node of the stable tree.
- */
-static inline int PageKsm(struct page *page)
-{
-	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
-				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
-}
-
 static inline struct stable_node *page_stable_node(struct page *page)
 {
 	return PageKsm(page) ? page_rmapping(page) : NULL;
@@ -87,11 +75,6 @@ static inline void ksm_exit(struct mm_st
 {
 }
 
-static inline int PageKsm(struct page *page)
-{
-	return 0;
-}
-
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags)
diff -puN include/linux/mm.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh include/linux/mm.h
--- a/include/linux/mm.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh
+++ a/include/linux/mm.h
@@ -494,15 +494,6 @@ static inline int page_count(struct page
 	return atomic_read(&compound_head(page)->_count);
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
-extern int PageHeadHuge(struct page *page_head);
-#else /* CONFIG_HUGETLB_PAGE */
-static inline int PageHeadHuge(struct page *page_head)
-{
-	return 0;
-}
-#endif /* CONFIG_HUGETLB_PAGE */
-
 static inline bool __compound_tail_refcounted(struct page *page)
 {
 	return !PageSlab(page) && !PageHeadHuge(page);
@@ -571,53 +562,6 @@ static inline void init_page_count(struc
 	atomic_set(&page->_count, 1);
 }
 
-/*
- * PageBuddy() indicate that the page is free and in the buddy system
- * (see mm/page_alloc.c).
- *
- * PAGE_BUDDY_MAPCOUNT_VALUE must be <= -2 but better not too close to
- * -2 so that an underflow of the page_mapcount() won't be mistaken
- * for a genuine PAGE_BUDDY_MAPCOUNT_VALUE. -128 can be created very
- * efficiently by most CPU architectures.
- */
-#define PAGE_BUDDY_MAPCOUNT_VALUE (-128)
-
-static inline int PageBuddy(struct page *page)
-{
-	return atomic_read(&page->_mapcount) == PAGE_BUDDY_MAPCOUNT_VALUE;
-}
-
-static inline void __SetPageBuddy(struct page *page)
-{
-	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
-	atomic_set(&page->_mapcount, PAGE_BUDDY_MAPCOUNT_VALUE);
-}
-
-static inline void __ClearPageBuddy(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageBuddy(page), page);
-	atomic_set(&page->_mapcount, -1);
-}
-
-#define PAGE_BALLOON_MAPCOUNT_VALUE (-256)
-
-static inline int PageBalloon(struct page *page)
-{
-	return atomic_read(&page->_mapcount) == PAGE_BALLOON_MAPCOUNT_VALUE;
-}
-
-static inline void __SetPageBalloon(struct page *page)
-{
-	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
-	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
-}
-
-static inline void __ClearPageBalloon(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageBalloon(page), page);
-	atomic_set(&page->_mapcount, -1);
-}
-
 void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
@@ -1006,26 +950,6 @@ void page_address_init(void);
 #define page_address_init()  do { } while(0)
 #endif
 
-/*
- * On an anonymous page mapped into a user virtual memory area,
- * page->mapping points to its anon_vma, not to a struct address_space;
- * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
- *
- * On an anonymous page in a VM_MERGEABLE area, if CONFIG_KSM is enabled,
- * the PAGE_MAPPING_KSM bit may be set along with the PAGE_MAPPING_ANON bit;
- * and then page->mapping points, not to an anon_vma, but to a private
- * structure which KSM associates with that merged page.  See ksm.h.
- *
- * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is currently never used.
- *
- * Please note that, confusingly, "page_mapping" refers to the inode
- * address_space which maps the page from disk; whereas "page_mapped"
- * refers to user virtual address space into which the page is mapped.
- */
-#define PAGE_MAPPING_ANON	1
-#define PAGE_MAPPING_KSM	2
-#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
-
 extern struct address_space *page_mapping(struct page *page);
 
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
@@ -1045,11 +969,6 @@ struct address_space *page_file_mapping(
 	return page->mapping;
 }
 
-static inline int PageAnon(struct page *page)
-{
-	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
-}
-
 /*
  * Return the pagecache index of the passed page.  Regular pagecache pages
  * use ->index whereas swapcache pages use ->private
diff -puN include/linux/page-flags.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh
+++ a/include/linux/page-flags.h
@@ -289,6 +289,47 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+/*
+ * On an anonymous page mapped into a user virtual memory area,
+ * page->mapping points to its anon_vma, not to a struct address_space;
+ * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
+ *
+ * On an anonymous page in a VM_MERGEABLE area, if CONFIG_KSM is enabled,
+ * the PAGE_MAPPING_KSM bit may be set along with the PAGE_MAPPING_ANON bit;
+ * and then page->mapping points, not to an anon_vma, but to a private
+ * structure which KSM associates with that merged page.  See ksm.h.
+ *
+ * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is currently never used.
+ *
+ * Please note that, confusingly, "page_mapping" refers to the inode
+ * address_space which maps the page from disk; whereas "page_mapped"
+ * refers to user virtual address space into which the page is mapped.
+ */
+#define PAGE_MAPPING_ANON	1
+#define PAGE_MAPPING_KSM	2
+#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
+
+static inline int PageAnon(struct page *page)
+{
+	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
+}
+
+#ifdef CONFIG_KSM
+/*
+ * A KSM page is one of those write-protected "shared pages" or "merged pages"
+ * which KSM maps into multiple mms, wherever identical anonymous page content
+ * is found in VM_MERGEABLE vmas.  It's a PageAnon page, pointing not to any
+ * anon_vma, but to that page's node of the stable tree.
+ */
+static inline int PageKsm(struct page *page)
+{
+	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
+				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
+}
+#else
+TESTPAGEFLAG_FALSE(Ksm)
+#endif
+
 u64 stable_page_flags(struct page *page);
 
 static inline int PageUptodate(struct page *page)
@@ -426,6 +467,14 @@ static inline void ClearPageCompound(str
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
+#ifdef CONFIG_HUGETLB_PAGE
+int PageHuge(struct page *page);
+int PageHeadHuge(struct page *page);
+#else
+TESTPAGEFLAG_FALSE(Huge)
+TESTPAGEFLAG_FALSE(HeadHuge)
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for
@@ -480,6 +529,53 @@ static inline int PageTransTail(struct p
 #endif
 
 /*
+ * PageBuddy() indicate that the page is free and in the buddy system
+ * (see mm/page_alloc.c).
+ *
+ * PAGE_BUDDY_MAPCOUNT_VALUE must be <= -2 but better not too close to
+ * -2 so that an underflow of the page_mapcount() won't be mistaken
+ * for a genuine PAGE_BUDDY_MAPCOUNT_VALUE. -128 can be created very
+ * efficiently by most CPU architectures.
+ */
+#define PAGE_BUDDY_MAPCOUNT_VALUE (-128)
+
+static inline int PageBuddy(struct page *page)
+{
+	return atomic_read(&page->_mapcount) == PAGE_BUDDY_MAPCOUNT_VALUE;
+}
+
+static inline void __SetPageBuddy(struct page *page)
+{
+	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
+	atomic_set(&page->_mapcount, PAGE_BUDDY_MAPCOUNT_VALUE);
+}
+
+static inline void __ClearPageBuddy(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageBuddy(page), page);
+	atomic_set(&page->_mapcount, -1);
+}
+
+#define PAGE_BALLOON_MAPCOUNT_VALUE (-256)
+
+static inline int PageBalloon(struct page *page)
+{
+	return atomic_read(&page->_mapcount) == PAGE_BALLOON_MAPCOUNT_VALUE;
+}
+
+static inline void __SetPageBalloon(struct page *page)
+{
+	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
+	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
+}
+
+static inline void __ClearPageBalloon(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageBalloon(page), page);
+	atomic_set(&page->_mapcount, -1);
+}
+
+/*
  * If network-based swap is enabled, sl*b must keep track of whether pages
  * were allocated from pfmemalloc reserves.
  */
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

