From: akpm@linux-foundation.org
Subject: [to-be-updated]
 page-flags-introduce-page-flags-policies-wrt-compound-pages.patch removed
 from -mm tree
Date: Wed, 30 Sep 2015 14:56:27 -0700
Message-ID: <560c5a8b.T/DP5ByQvPRAW6rN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbI3V42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: introduce page flags policies wrt compound pages
has been removed from the -mm tree.  Its filename was
     page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

This patch was dropped because an updated version will be merged

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

[akpm@linux-foundation.org: undo "kpageidle: decouple from page-flags rework"]
[sudipm.mukherjee@gmail.com: rectify forward declaration]
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

 include/linux/page-flags.h |  163 ++++++++++++++++++++---------------
 1 file changed, 97 insertions(+), 66 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages
+++ a/include/linux/page-flags.h
@@ -133,49 +133,68 @@ enum pageflags {
 
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
+	{ return __test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
-	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
-
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
@@ -204,47 +223,54 @@ static inline int __TestClearPage##uname
 #define TESTSCFLAG_FALSE(uname)						\
 	TESTSETFLAG_FALSE(uname) TESTCLEARFLAG_FALSE(uname)
 
-struct page;	/* forward declaration */
-
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
+/* Forward declarations */
+struct page;
+static inline int PageCompound(struct page *page);
+static inline int PageTail(struct page *page);
+static inline struct page *compound_head(struct page *page);
+
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
@@ -257,31 +283,32 @@ PAGEFLAG_FALSE(HighMem)
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
@@ -289,10 +316,10 @@ PAGEFLAG_FALSE(HWPoison)
 #endif
 
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
-TESTPAGEFLAG(Young, young)
-SETPAGEFLAG(Young, young)
-TESTCLEARFLAG(Young, young)
-PAGEFLAG(Idle, idle)
+TESTPAGEFLAG(Young, young, PF_ANY)
+SETPAGEFLAG(Young, young, PF_ANY)
+TESTCLEARFLAG(Young, young, PF_ANY)
+PAGEFLAG(Idle, idle, PF_ANY)
 #endif
 
 /*
@@ -373,7 +400,7 @@ static inline void SetPageUptodate(struc
 	set_bit(PG_uptodate, &(page)->flags);
 }
 
-CLEARPAGEFLAG(Uptodate, uptodate)
+CLEARPAGEFLAG(Uptodate, uptodate, ANY)
 
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
@@ -393,7 +420,7 @@ static inline void set_page_writeback_ke
 	test_set_page_writeback_keepwrite(page);
 }
 
-__PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
+__PAGEFLAG(Head, head, ANY) CLEARPAGEFLAG(Head, head, ANY)
 
 static inline int PageTail(struct page *page)
 {
@@ -614,6 +641,10 @@ static inline int page_has_private(struc
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

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
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
mm-support-madvisemadv_free-fix-3.patch

