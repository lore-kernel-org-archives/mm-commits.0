From: akpm@linux-foundation.org
Subject: +
 page-flags-introduce-page-flags-policies-wrt-compound-pages.patch added to
 -mm tree
Date: Fri, 20 Mar 2015 13:36:02 -0700
Message-ID: <550c84b2.JNpALL1T5qi6v+xw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbbCTUgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: introduce page flags policies wrt compound pages
has been added to the -mm tree.  Its filename is
     page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

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
Subject: page-flags: introduce page flags policies wrt compound pages

This patch adds a third argument to macros which create function
definitions for page flags.  This argument defines how page-flags helpers
behave on compound functions.

For now we define four policies:

- PF_ANY: the helper function operates on the page it gets, regardless
  if it's non-compound, head or tail.

- PF_HEAD: the helper function operates on the head page of the compound
  page if it gets tail page.

- PF_NO_TAIL: only head and non-compond pages are acceptable for this
  helper function.

- PF_NO_COMPOUND: only non-compound pages are acceptable for this helper
  function.

For now we use policy PF_ANY for all helpers, which matches current
behaviour.

We do not enforce the policy for TESTPAGEFLAG, because we have flags
checked for random pages all over the kernel.  Noticeable exception to
this is PageTransHuge() which triggers VM_BUG_ON() for tail page.

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

 include/linux/mm.h         |   40 -------
 include/linux/page-flags.h |  198 +++++++++++++++++++++++------------
 2 files changed, 134 insertions(+), 104 deletions(-)

diff -puN include/linux/mm.h~page-flags-introduce-page-flags-policies-wrt-compound-pages include/linux/mm.h
--- a/include/linux/mm.h~page-flags-introduce-page-flags-policies-wrt-compound-pages
+++ a/include/linux/mm.h
@@ -433,46 +433,6 @@ static inline void compound_unlock_irqre
 #endif
 }
 
-static inline struct page *compound_head_by_tail(struct page *tail)
-{
-	struct page *head = tail->first_page;
-
-	/*
-	 * page->first_page may be a dangling pointer to an old
-	 * compound page, so recheck that it is still a tail
-	 * page before returning.
-	 */
-	smp_rmb();
-	if (likely(PageTail(tail)))
-		return head;
-	return tail;
-}
-
-/*
- * Since either compound page could be dismantled asynchronously in THP
- * or we access asynchronously arbitrary positioned struct page, there
- * would be tail flag race. To handle this race, we should call
- * smp_rmb() before checking tail flag. compound_head_by_tail() did it.
- */
-static inline struct page *compound_head(struct page *page)
-{
-	if (unlikely(PageTail(page)))
-		return compound_head_by_tail(page);
-	return page;
-}
-
-/*
- * If we access compound page synchronously such as access to
- * allocated page, there is no need to handle tail flag race, so we can
- * check tail flag directly without any synchronization primitive.
- */
-static inline struct page *compound_head_fast(struct page *page)
-{
-	if (unlikely(PageTail(page)))
-		return page->first_page;
-	return page;
-}
-
 /*
  * The atomic page->_mapcount, starts from -1: so that transitions
  * both from it and to it can be tracked, using atomic_inc_and_test
diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages
+++ a/include/linux/page-flags.h
@@ -134,49 +134,68 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
+/* Page flags policies wrt compound pages */
+#define ANY(page, enforce)	page
+#define HEAD(page, enforce)	compound_head(page)
+#define NO_TAIL(page, enforce) ({					\
+		if (enforce)						\
+			VM_BUG_ON_PAGE(PageTail(page), page);		\
+		else							\
+			page = compound_head(page);			\
+		page;})
+#define NO_COMPOUND(page, enforce) ({					\
+		if (enforce)						\
+			VM_BUG_ON_PAGE(PageCompound(page), page);	\
+		page;})
+
 /*
  * Macros to create function definitions for page flags
  */
-#define TESTPAGEFLAG(uname, lname)					\
-static inline int Page##uname(const struct page *page)			\
-			{ return test_bit(PG_##lname, &page->flags); }
+#define TESTPAGEFLAG(uname, lname, policy)				\
+static inline int Page##uname(struct page *page)			\
+	{ return test_bit(PG_##lname, &policy(page, 0)->flags); }
 
-#define SETPAGEFLAG(uname, lname)					\
+#define SETPAGEFLAG(uname, lname, policy)				\
 static inline void SetPage##uname(struct page *page)			\
-			{ set_bit(PG_##lname, &page->flags); }
+	{ set_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define CLEARPAGEFLAG(uname, lname)					\
+#define CLEARPAGEFLAG(uname, lname, policy)				\
 static inline void ClearPage##uname(struct page *page)			\
-			{ clear_bit(PG_##lname, &page->flags); }
+	{ clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define __SETPAGEFLAG(uname, lname)					\
+#define __SETPAGEFLAG(uname, lname, policy)				\
 static inline void __SetPage##uname(struct page *page)			\
-			{ __set_bit(PG_##lname, &page->flags); }
+	{ __set_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define __CLEARPAGEFLAG(uname, lname)					\
+#define __CLEARPAGEFLAG(uname, lname, policy)				\
 static inline void __ClearPage##uname(struct page *page)		\
-			{ __clear_bit(PG_##lname, &page->flags); }
+	{ __clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define TESTSETFLAG(uname, lname)					\
+#define TESTSETFLAG(uname, lname, policy)				\
 static inline int TestSetPage##uname(struct page *page)			\
-		{ return test_and_set_bit(PG_##lname, &page->flags); }
+	{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define TESTCLEARFLAG(uname, lname)					\
+#define TESTCLEARFLAG(uname, lname, policy)				\
 static inline int TestClearPage##uname(struct page *page)		\
-		{ return test_and_clear_bit(PG_##lname, &page->flags); }
+	{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define __TESTCLEARFLAG(uname, lname)					\
+#define __TESTCLEARFLAG(uname, lname, policy)				\
 static inline int __TestClearPage##uname(struct page *page)		\
-		{ return __test_and_clear_bit(PG_##lname, &page->flags); }
-
-#define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
-	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
-
-#define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
-	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
+	{ return __test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define TESTSCFLAG(uname, lname)					\
-	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
+#define PAGEFLAG(uname, lname, policy)					\
+	TESTPAGEFLAG(uname, lname, policy)				\
+	SETPAGEFLAG(uname, lname, policy)				\
+	CLEARPAGEFLAG(uname, lname, policy)
+
+#define __PAGEFLAG(uname, lname, policy)				\
+	TESTPAGEFLAG(uname, lname, policy)				\
+	__SETPAGEFLAG(uname, lname, policy)				\
+	__CLEARPAGEFLAG(uname, lname, policy)
+
+#define TESTSCFLAG(uname, lname, policy)				\
+	TESTSETFLAG(uname, lname, policy)				\
+	TESTCLEARFLAG(uname, lname, policy)
 
 #define TESTPAGEFLAG_FALSE(uname)					\
 static inline int Page##uname(const struct page *page) { return 0; }
@@ -205,47 +224,93 @@ static inline int __TestClearPage##uname
 #define TESTSCFLAG_FALSE(uname)						\
 	TESTSETFLAG_FALSE(uname) TESTCLEARFLAG_FALSE(uname)
 
-struct page;	/* forward declaration */
+/* Forward declarations */
+struct page;
+static inline int PageCompound(struct page *page);
+static inline int PageTail(struct page *page);
+
+static inline struct page *compound_head_by_tail(struct page *tail)
+{
+	struct page *head = tail->first_page;
+
+	/*
+	 * page->first_page may be a dangling pointer to an old
+	 * compound page, so recheck that it is still a tail
+	 * page before returning.
+	 */
+	smp_rmb();
+	if (likely(PageTail(tail)))
+		return head;
+	return tail;
+}
+
+/*
+ * Since either compound page could be dismantled asynchronously in THP
+ * or we access asynchronously arbitrary positioned struct page, there
+ * would be tail flag race. To handle this race, we should call
+ * smp_rmb() before checking tail flag. compound_head_by_tail() did it.
+ */
+static inline struct page *compound_head(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		return compound_head_by_tail(page);
+	return page;
+}
+
+/*
+ * If we access compound page synchronously such as access to
+ * allocated page, there is no need to handle tail flag race, so we can
+ * check tail flag directly without any synchronization primitive.
+ */
+static inline struct page *compound_head_fast(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		return page->first_page;
+	return page;
+}
 
-TESTPAGEFLAG(Locked, locked)
-PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
-PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
-	__SETPAGEFLAG(Referenced, referenced)
-PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
-PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
-PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
-	TESTCLEARFLAG(Active, active)
-__PAGEFLAG(Slab, slab)
-PAGEFLAG(Checked, checked)		/* Used by some filesystems */
-PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
-PAGEFLAG(SavePinned, savepinned);			/* Xen */
-PAGEFLAG(Foreign, foreign);				/* Xen */
-PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
-PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
-	__SETPAGEFLAG(SwapBacked, swapbacked)
+TESTPAGEFLAG(Locked, locked, ANY)
+PAGEFLAG(Error, error, ANY) TESTCLEARFLAG(Error, error, ANY)
+PAGEFLAG(Referenced, referenced, ANY) TESTCLEARFLAG(Referenced, referenced, ANY)
+	__SETPAGEFLAG(Referenced, referenced, ANY)
+PAGEFLAG(Dirty, dirty, ANY) TESTSCFLAG(Dirty, dirty, ANY)
+	__CLEARPAGEFLAG(Dirty, dirty, ANY)
+PAGEFLAG(LRU, lru, ANY) __CLEARPAGEFLAG(LRU, lru, ANY)
+PAGEFLAG(Active, active, ANY) __CLEARPAGEFLAG(Active, active, ANY)
+	TESTCLEARFLAG(Active, active, ANY)
+__PAGEFLAG(Slab, slab, ANY)
+PAGEFLAG(Checked, checked, ANY)		/* Used by some filesystems */
+PAGEFLAG(Pinned, pinned, ANY) TESTSCFLAG(Pinned, pinned, ANY)	/* Xen */
+PAGEFLAG(SavePinned, savepinned, ANY);			/* Xen */
+PAGEFLAG(Foreign, foreign, ANY);				/* Xen */
+PAGEFLAG(Reserved, reserved, ANY) __CLEARPAGEFLAG(Reserved, reserved, ANY)
+PAGEFLAG(SwapBacked, swapbacked, ANY)
+	__CLEARPAGEFLAG(SwapBacked, swapbacked, ANY)
+	__SETPAGEFLAG(SwapBacked, swapbacked, ANY)
 
-__PAGEFLAG(SlobFree, slob_free)
+__PAGEFLAG(SlobFree, slob_free, ANY)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
  * - PG_private and PG_private_2 cause releasepage() and co to be invoked
  */
-PAGEFLAG(Private, private) __SETPAGEFLAG(Private, private)
-	__CLEARPAGEFLAG(Private, private)
-PAGEFLAG(Private2, private_2) TESTSCFLAG(Private2, private_2)
-PAGEFLAG(OwnerPriv1, owner_priv_1) TESTCLEARFLAG(OwnerPriv1, owner_priv_1)
+PAGEFLAG(Private, private, ANY) __SETPAGEFLAG(Private, private, ANY)
+	__CLEARPAGEFLAG(Private, private, ANY)
+PAGEFLAG(Private2, private_2, ANY) TESTSCFLAG(Private2, private_2, ANY)
+PAGEFLAG(OwnerPriv1, owner_priv_1, ANY)
+	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, ANY)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
-PAGEFLAG(MappedToDisk, mappedtodisk)
+TESTPAGEFLAG(Writeback, writeback, ANY) TESTSCFLAG(Writeback, writeback, ANY)
+PAGEFLAG(MappedToDisk, mappedtodisk, ANY)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim) TESTCLEARFLAG(Reclaim, reclaim)
-PAGEFLAG(Readahead, reclaim) TESTCLEARFLAG(Readahead, reclaim)
+PAGEFLAG(Reclaim, reclaim, ANY) TESTCLEARFLAG(Reclaim, reclaim, ANY)
+PAGEFLAG(Readahead, reclaim, ANY) TESTCLEARFLAG(Readahead, reclaim, ANY)
 
 #ifdef CONFIG_HIGHMEM
 /*
@@ -258,31 +323,32 @@ PAGEFLAG_FALSE(HighMem)
 #endif
 
 #ifdef CONFIG_SWAP
-PAGEFLAG(SwapCache, swapcache)
+PAGEFLAG(SwapCache, swapcache, ANY)
 #else
 PAGEFLAG_FALSE(SwapCache)
 #endif
 
-PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
-	TESTCLEARFLAG(Unevictable, unevictable)
+PAGEFLAG(Unevictable, unevictable, ANY)
+	__CLEARPAGEFLAG(Unevictable, unevictable, ANY)
+	TESTCLEARFLAG(Unevictable, unevictable, ANY)
 
 #ifdef CONFIG_MMU
-PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
-	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
+PAGEFLAG(Mlocked, mlocked, ANY) __CLEARPAGEFLAG(Mlocked, mlocked, ANY)
+	TESTSCFLAG(Mlocked, mlocked, ANY) __TESTCLEARFLAG(Mlocked, mlocked, ANY)
 #else
 PAGEFLAG_FALSE(Mlocked) __CLEARPAGEFLAG_NOOP(Mlocked)
 	TESTSCFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
-PAGEFLAG(Uncached, uncached)
+PAGEFLAG(Uncached, uncached, ANY)
 #else
 PAGEFLAG_FALSE(Uncached)
 #endif
 
 #ifdef CONFIG_MEMORY_FAILURE
-PAGEFLAG(HWPoison, hwpoison)
-TESTSCFLAG(HWPoison, hwpoison)
+PAGEFLAG(HWPoison, hwpoison, ANY)
+TESTSCFLAG(HWPoison, hwpoison, ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison)
@@ -367,7 +433,7 @@ static inline void SetPageUptodate(struc
 	set_bit(PG_uptodate, &(page)->flags);
 }
 
-CLEARPAGEFLAG(Uptodate, uptodate)
+CLEARPAGEFLAG(Uptodate, uptodate, ANY)
 
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
@@ -396,8 +462,8 @@ static inline void set_page_writeback_ke
  * and arch/powerpc/kvm/book3s_64_vio_hv.c which use it to detect huge pages
  * and avoid handling those in real mode.
  */
-__PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
-__PAGEFLAG(Tail, tail)
+__PAGEFLAG(Head, head, ANY) CLEARPAGEFLAG(Head, head, ANY)
+__PAGEFLAG(Tail, tail, ANY)
 
 static inline int PageCompound(struct page *page)
 {
@@ -421,8 +487,8 @@ static inline void ClearPageCompound(str
  * because PageCompound is always set for compound pages and not for
  * pages on the LRU and/or pagecache.
  */
-TESTPAGEFLAG(Compound, compound)
-__SETPAGEFLAG(Head, compound)  __CLEARPAGEFLAG(Head, compound)
+TESTPAGEFLAG(Compound, compound, ANY)
+__SETPAGEFLAG(Head, compound, ANY)  __CLEARPAGEFLAG(Head, compound, ANY)
 
 /*
  * PG_reclaim is used in combination with PG_compound to mark the
@@ -636,6 +702,10 @@ static inline int page_has_private(struc
 	return !!(page->flags & PAGE_FLAGS_PRIVATE);
 }
 
+#undef ANY
+#undef HEAD
+#undef NO_TAIL
+#undef NO_COMPOUND
 #endif /* !__GENERATING_BOUNDS_H */
 
 #endif	/* PAGE_FLAGS_H */
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

