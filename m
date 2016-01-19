From: akpm@linux-foundation.org
Subject: [merged]
 page-flags-introduce-page-flags-policies-wrt-compound-pages.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:00:46 -0800
Message-ID: <569e95ee.X27CDmJ1rTSbeoRb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbcASUAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: introduce page flags policies wrt compound pa=
ges
has been removed from the -mm tree.  Its filename was
     page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: introduce page flags policies wrt compound pages

This patch adds a third argument to macros which create function
definitions for page flags.  This argument defines how page-flags helpe=
rs
behave on compound functions.

=46or now we define four policies:

- PF_ANY: the helper function operates on the page it gets, regardless
  if it's non-compound, head or tail.

- PF_HEAD: the helper function operates on the head page of the compoun=
d
  page if it gets tail page.

- PF_NO_TAIL: only head and non-compond pages are acceptable for this
  helper function.

- PF_NO_COMPOUND: only non-compound pages are acceptable for this helpe=
r
  function.

=46or now we use policy PF_ANY for all helpers, which matches current
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
Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h    |    6 +
 include/linux/page-flags.h |  168 +++++++++++++++++++++--------------
 lib/Kconfig.debug          |    8 +
 3 files changed, 117 insertions(+), 65 deletions(-)

diff -puN include/linux/mmdebug.h~page-flags-introduce-page-flags-polic=
ies-wrt-compound-pages include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~page-flags-introduce-page-flags-policies-=
wrt-compound-pages
+++ a/include/linux/mmdebug.h
@@ -56,4 +56,10 @@ void dump_mm(const struct mm_struct *mm)
 #define VIRTUAL_BUG_ON(cond) do { } while (0)
 #endif
=20
+#ifdef CONFIG_DEBUG_VM_PGFLAGS
+#define VM_BUG_ON_PGFLAGS(cond, page) VM_BUG_ON_PAGE(cond, page)
+#else
+#define VM_BUG_ON_PGFLAGS(cond, page) BUILD_BUG_ON_INVALID(cond)
+#endif
+
 #endif
diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-po=
licies-wrt-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-polici=
es-wrt-compound-pages
+++ a/include/linux/page-flags.h
@@ -155,48 +155,79 @@ static inline int PageCompound(struct pa
 }
=20
 /*
+ * Page flags policies wrt compound pages
+ *
+ * PF_ANY:
+ *     the page flag is relevant for small, head and tail pages.
+ *
+ * PF_HEAD:
+ *     for compound page all operations related to the page flag appli=
ed to
+ *     head page.
+ *
+ * PF_NO_TAIL:
+ *     modifications of the page flag must be done on small or head pa=
ges,
+ *     checks can be done on tail pages too.
+ *
+ * PF_NO_COMPOUND:
+ *     the page flag is not relevant for compound pages.
+ */
+#define PF_ANY(page, enforce)	page
+#define PF_HEAD(page, enforce)	compound_head(page)
+#define PF_NO_TAIL(page, enforce) ({					\
+		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
+		compound_head(page);})
+#define PF_NO_COMPOUND(page, enforce) ({					\
+		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
+		page;})
+
+/*
  * Macros to create function definitions for page flags
  */
-#define TESTPAGEFLAG(uname, lname)					\
-static inline int Page##uname(const struct page *page)			\
-			{ return test_bit(PG_##lname, &page->flags); }
+#define TESTPAGEFLAG(uname, lname, policy)				\
+static inline int Page##uname(struct page *page)			\
+	{ return test_bit(PG_##lname, &policy(page, 0)->flags); }
=20
-#define SETPAGEFLAG(uname, lname)					\
+#define SETPAGEFLAG(uname, lname, policy)				\
 static inline void SetPage##uname(struct page *page)			\
-			{ set_bit(PG_##lname, &page->flags); }
+	{ set_bit(PG_##lname, &policy(page, 1)->flags); }
=20
-#define CLEARPAGEFLAG(uname, lname)					\
+#define CLEARPAGEFLAG(uname, lname, policy)				\
 static inline void ClearPage##uname(struct page *page)			\
-			{ clear_bit(PG_##lname, &page->flags); }
+	{ clear_bit(PG_##lname, &policy(page, 1)->flags); }
=20
-#define __SETPAGEFLAG(uname, lname)					\
+#define __SETPAGEFLAG(uname, lname, policy)				\
 static inline void __SetPage##uname(struct page *page)			\
-			{ __set_bit(PG_##lname, &page->flags); }
+	{ __set_bit(PG_##lname, &policy(page, 1)->flags); }
=20
-#define __CLEARPAGEFLAG(uname, lname)					\
+#define __CLEARPAGEFLAG(uname, lname, policy)				\
 static inline void __ClearPage##uname(struct page *page)		\
-			{ __clear_bit(PG_##lname, &page->flags); }
+	{ __clear_bit(PG_##lname, &policy(page, 1)->flags); }
=20
-#define TESTSETFLAG(uname, lname)					\
+#define TESTSETFLAG(uname, lname, policy)				\
 static inline int TestSetPage##uname(struct page *page)			\
-		{ return test_and_set_bit(PG_##lname, &page->flags); }
+	{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
=20
-#define TESTCLEARFLAG(uname, lname)					\
+#define TESTCLEARFLAG(uname, lname, policy)				\
 static inline int TestClearPage##uname(struct page *page)		\
-		{ return test_and_clear_bit(PG_##lname, &page->flags); }
+	{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
=20
-#define __TESTCLEARFLAG(uname, lname)					\
+#define __TESTCLEARFLAG(uname, lname, policy)				\
 static inline int __TestClearPage##uname(struct page *page)		\
-		{ return __test_and_clear_bit(PG_##lname, &page->flags); }
-
-#define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
-	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
+	{ return __test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
=20
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
=20
 #define TESTPAGEFLAG_FALSE(uname)					\
 static inline int Page##uname(const struct page *page) { return 0; }
@@ -225,46 +256,48 @@ static inline int __TestClearPage##uname
 #define TESTSCFLAG_FALSE(uname)						\
 	TESTSETFLAG_FALSE(uname) TESTCLEARFLAG_FALSE(uname)
=20
+TESTPAGEFLAG(Locked, locked, PF_ANY)
+PAGEFLAG(Error, error, PF_ANY) TESTCLEARFLAG(Error, error, PF_ANY)
+PAGEFLAG(Referenced, referenced, PF_ANY) TESTCLEARFLAG(Referenced, ref=
erenced, PF_ANY)
+	__SETPAGEFLAG(Referenced, referenced, PF_ANY)
+PAGEFLAG(Dirty, dirty, PF_ANY) TESTSCFLAG(Dirty, dirty, PF_ANY)
+	__CLEARPAGEFLAG(Dirty, dirty, PF_ANY)
+PAGEFLAG(LRU, lru, PF_ANY) __CLEARPAGEFLAG(LRU, lru, PF_ANY)
+PAGEFLAG(Active, active, PF_ANY) __CLEARPAGEFLAG(Active, active, PF_AN=
Y)
+	TESTCLEARFLAG(Active, active, PF_ANY)
+__PAGEFLAG(Slab, slab, PF_ANY)
+PAGEFLAG(Checked, checked, PF_ANY)		/* Used by some filesystems */
+PAGEFLAG(Pinned, pinned, PF_ANY) TESTSCFLAG(Pinned, pinned, PF_ANY)	/*=
 Xen */
+PAGEFLAG(SavePinned, savepinned, PF_ANY);			/* Xen */
+PAGEFLAG(Foreign, foreign, PF_ANY);				/* Xen */
+PAGEFLAG(Reserved, reserved, PF_ANY) __CLEARPAGEFLAG(Reserved, reserve=
d, PF_ANY)
+PAGEFLAG(SwapBacked, swapbacked, PF_ANY)
+	__CLEARPAGEFLAG(SwapBacked, swapbacked, PF_ANY)
+	__SETPAGEFLAG(SwapBacked, swapbacked, PF_ANY)
=20
-TESTPAGEFLAG(Locked, locked)
-PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
-PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
-	__SETPAGEFLAG(Referenced, referenced)
-PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty,=
 dirty)
-PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
-PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
-	TESTCLEARFLAG(Active, active)
-__PAGEFLAG(Slab, slab)
-PAGEFLAG(Checked, checked)		/* Used by some filesystems */
-PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
-PAGEFLAG(SavePinned, savepinned);			/* Xen */
-PAGEFLAG(Foreign, foreign);				/* Xen */
-PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
-PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacke=
d)
-	__SETPAGEFLAG(SwapBacked, swapbacked)
-
-__PAGEFLAG(SlobFree, slob_free)
+__PAGEFLAG(SlobFree, slob_free, PF_ANY)
=20
 /*
  * Private page markings that may be used by the filesystem that owns =
the page
  * for its own purposes.
  * - PG_private and PG_private_2 cause releasepage() and co to be invo=
ked
  */
-PAGEFLAG(Private, private) __SETPAGEFLAG(Private, private)
-	__CLEARPAGEFLAG(Private, private)
-PAGEFLAG(Private2, private_2) TESTSCFLAG(Private2, private_2)
-PAGEFLAG(OwnerPriv1, owner_priv_1) TESTCLEARFLAG(OwnerPriv1, owner_pri=
v_1)
+PAGEFLAG(Private, private, PF_ANY) __SETPAGEFLAG(Private, private, PF_=
ANY)
+	__CLEARPAGEFLAG(Private, private, PF_ANY)
+PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, =
PF_ANY)
+PAGEFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
+	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
=20
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operat=
ors are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
-PAGEFLAG(MappedToDisk, mappedtodisk)
+TESTPAGEFLAG(Writeback, writeback, PF_ANY) TESTSCFLAG(Writeback, write=
back, PF_ANY)
+PAGEFLAG(MappedToDisk, mappedtodisk, PF_ANY)
=20
 /* PG_readahead is only used for reads; PG_reclaim is only for writes =
*/
-PAGEFLAG(Reclaim, reclaim) TESTCLEARFLAG(Reclaim, reclaim)
-PAGEFLAG(Readahead, reclaim) TESTCLEARFLAG(Readahead, reclaim)
+PAGEFLAG(Reclaim, reclaim, PF_ANY) TESTCLEARFLAG(Reclaim, reclaim, PF_=
ANY)
+PAGEFLAG(Readahead, reclaim, PF_ANY) TESTCLEARFLAG(Readahead, reclaim,=
 PF_ANY)
=20
 #ifdef CONFIG_HIGHMEM
 /*
@@ -277,31 +310,32 @@ PAGEFLAG_FALSE(HighMem)
 #endif
=20
 #ifdef CONFIG_SWAP
-PAGEFLAG(SwapCache, swapcache)
+PAGEFLAG(SwapCache, swapcache, PF_ANY)
 #else
 PAGEFLAG_FALSE(SwapCache)
 #endif
=20
-PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevic=
table)
-	TESTCLEARFLAG(Unevictable, unevictable)
+PAGEFLAG(Unevictable, unevictable, PF_ANY)
+	__CLEARPAGEFLAG(Unevictable, unevictable, PF_ANY)
+	TESTCLEARFLAG(Unevictable, unevictable, PF_ANY)
=20
 #ifdef CONFIG_MMU
-PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
-	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
+PAGEFLAG(Mlocked, mlocked, PF_ANY) __CLEARPAGEFLAG(Mlocked, mlocked, P=
=46_ANY)
+	TESTSCFLAG(Mlocked, mlocked, PF_ANY) __TESTCLEARFLAG(Mlocked, mlocked=
, PF_ANY)
 #else
 PAGEFLAG_FALSE(Mlocked) __CLEARPAGEFLAG_NOOP(Mlocked)
 	TESTSCFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
=20
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
-PAGEFLAG(Uncached, uncached)
+PAGEFLAG(Uncached, uncached, PF_ANY)
 #else
 PAGEFLAG_FALSE(Uncached)
 #endif
=20
 #ifdef CONFIG_MEMORY_FAILURE
-PAGEFLAG(HWPoison, hwpoison)
-TESTSCFLAG(HWPoison, hwpoison)
+PAGEFLAG(HWPoison, hwpoison, PF_ANY)
+TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison)
@@ -309,10 +343,10 @@ PAGEFLAG_FALSE(HWPoison)
 #endif
=20
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
=20
 /*
@@ -393,7 +427,7 @@ static inline void SetPageUptodate(struc
 	set_bit(PG_uptodate, &(page)->flags);
 }
=20
-CLEARPAGEFLAG(Uptodate, uptodate)
+CLEARPAGEFLAG(Uptodate, uptodate, PF_ANY)
=20
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
@@ -413,7 +447,7 @@ static inline void set_page_writeback_ke
 	test_set_page_writeback_keepwrite(page);
 }
=20
-__PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
+__PAGEFLAG(Head, head, PF_ANY) CLEARPAGEFLAG(Head, head, PF_ANY)
=20
 static inline void set_compound_head(struct page *page, struct page *h=
ead)
 {
@@ -615,6 +649,10 @@ static inline int page_has_private(struc
 	return !!(page->flags & PAGE_FLAGS_PRIVATE);
 }
=20
+#undef PF_ANY
+#undef PF_HEAD
+#undef PF_NO_TAIL
+#undef PF_NO_COMPOUND
 #endif /* !__GENERATING_BOUNDS_H */
=20
 #endif	/* PAGE_FLAGS_H */
diff -puN lib/Kconfig.debug~page-flags-introduce-page-flags-policies-wr=
t-compound-pages lib/Kconfig.debug
--- a/lib/Kconfig.debug~page-flags-introduce-page-flags-policies-wrt-co=
mpound-pages
+++ a/lib/Kconfig.debug
@@ -580,6 +580,14 @@ config DEBUG_VM_RB
=20
 	  If unsure, say N.
=20
+config DEBUG_VM_PGFLAGS
+	bool "Debug page-flags operations"
+	depends on DEBUG_VM
+	help
+	  Enables extra validation on page flags operations.
+
+	  If unsure, say N.
+
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && X86
_

Patches currently in -mm which might be from kirill.shutemov@linux.inte=
l.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
