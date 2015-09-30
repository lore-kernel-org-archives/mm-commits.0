From: akpm@linux-foundation.org
Subject: [to-be-updated]
 include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch removed
 from -mm tree
Date: Wed, 30 Sep 2015 14:57:09 -0700
Message-ID: <560c5ab5.oc3cPJ5UBv1N4hvQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbbI3V5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags.h: rename macros to avoid collisions
has been removed from the -mm tree.  Its filename was
     include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/page-flags.h: rename macros to avoid collisions

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |  108 +++++++++++++++++------------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff -puN include/linux/page-flags.h~include-linux-page-flagsh-rename-macros-to-avoid-collisions include/linux/page-flags.h
--- a/include/linux/page-flags.h~include-linux-page-flagsh-rename-macros-to-avoid-collisions
+++ a/include/linux/page-flags.h
@@ -134,15 +134,15 @@ enum pageflags {
 #ifndef __GENERATING_BOUNDS_H
 
 /* Page flags policies wrt compound pages */
-#define ANY(page, enforce)	page
-#define HEAD(page, enforce)	compound_head(page)
-#define NO_TAIL(page, enforce) ({					\
+#define PF_ANY(page, enforce)	page
+#define PF_HEAD(page, enforce)	compound_head(page)
+#define PF_NO_TAIL(page, enforce) ({					\
 		if (enforce)						\
 			VM_BUG_ON_PAGE(PageTail(page), page);		\
 		else							\
 			page = compound_head(page);			\
 		page;})
-#define NO_COMPOUND(page, enforce) ({					\
+#define PF_NO_COMPOUND(page, enforce) ({					\
 		if (enforce)						\
 			VM_BUG_ON_PAGE(PageCompound(page), page);	\
 		page;})
@@ -229,55 +229,55 @@ static inline int PageCompound(struct pa
 static inline int PageTail(struct page *page);
 static inline struct page *compound_head(struct page *page);
 
-__PAGEFLAG(Locked, locked, NO_TAIL)
-PAGEFLAG(Error, error, NO_COMPOUND) TESTCLEARFLAG(Error, error, NO_COMPOUND)
-PAGEFLAG(Referenced, referenced, HEAD)
-	TESTCLEARFLAG(Referenced, referenced, HEAD)
-	__SETPAGEFLAG(Referenced, referenced, HEAD)
-PAGEFLAG(Dirty, dirty, HEAD) TESTSCFLAG(Dirty, dirty, HEAD)
-	__CLEARPAGEFLAG(Dirty, dirty, HEAD)
-PAGEFLAG(LRU, lru, HEAD) __CLEARPAGEFLAG(LRU, lru, HEAD)
-PAGEFLAG(Active, active, HEAD) __CLEARPAGEFLAG(Active, active, HEAD)
-	TESTCLEARFLAG(Active, active, HEAD)
-__PAGEFLAG(Slab, slab, NO_TAIL)
-__PAGEFLAG(SlobFree, slob_free, NO_TAIL)
-PAGEFLAG(Checked, checked, NO_COMPOUND) /* Used by some filesystems */
+__PAGEFLAG(Locked, locked, PF_NO_TAIL)
+PAGEFLAG(Error, error, PF_NO_COMPOUND) TESTCLEARFLAG(Error, error, PF_NO_COMPOUND)
+PAGEFLAG(Referenced, referenced, PF_HEAD)
+	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
+	__SETPAGEFLAG(Referenced, referenced, PF_HEAD)
+PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
+	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
+PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
+PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
+	TESTCLEARFLAG(Active, active, PF_HEAD)
+__PAGEFLAG(Slab, slab, PF_NO_TAIL)
+__PAGEFLAG(SlobFree, slob_free, PF_NO_TAIL)
+PAGEFLAG(Checked, checked, PF_NO_COMPOUND) /* Used by some filesystems */
 
 /* Xen */
-PAGEFLAG(Pinned, pinned, NO_COMPOUND) TESTSCFLAG(Pinned, pinned, NO_COMPOUND)
-PAGEFLAG(SavePinned, savepinned, NO_COMPOUND)
-PAGEFLAG(Foreign, foreign, NO_COMPOUND)
-
-PAGEFLAG(Reserved, reserved, NO_COMPOUND)
-	__CLEARPAGEFLAG(Reserved, reserved, NO_COMPOUND)
-PAGEFLAG(SwapBacked, swapbacked, NO_TAIL)
-	__CLEARPAGEFLAG(SwapBacked, swapbacked, NO_TAIL)
-	__SETPAGEFLAG(SwapBacked, swapbacked, NO_TAIL)
+PAGEFLAG(Pinned, pinned, PF_NO_COMPOUND) TESTSCFLAG(Pinned, pinned, PF_NO_COMPOUND)
+PAGEFLAG(SavePinned, savepinned, PF_NO_COMPOUND)
+PAGEFLAG(Foreign, foreign, PF_NO_COMPOUND)
+
+PAGEFLAG(Reserved, reserved, PF_NO_COMPOUND)
+	__CLEARPAGEFLAG(Reserved, reserved, PF_NO_COMPOUND)
+PAGEFLAG(SwapBacked, swapbacked, PF_NO_TAIL)
+	__CLEARPAGEFLAG(SwapBacked, swapbacked, PF_NO_TAIL)
+	__SETPAGEFLAG(SwapBacked, swapbacked, PF_NO_TAIL)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
  * - PG_private and PG_private_2 cause releasepage() and co to be invoked
  */
-PAGEFLAG(Private, private, ANY) __SETPAGEFLAG(Private, private, ANY)
-	__CLEARPAGEFLAG(Private, private, ANY)
-PAGEFLAG(Private2, private_2, ANY) TESTSCFLAG(Private2, private_2, ANY)
-PAGEFLAG(OwnerPriv1, owner_priv_1, ANY)
-	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, ANY)
+PAGEFLAG(Private, private, PF_ANY) __SETPAGEFLAG(Private, private, PF_ANY)
+	__CLEARPAGEFLAG(Private, private, PF_ANY)
+PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, PF_ANY)
+PAGEFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
+	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback, NO_COMPOUND)
-	TESTSCFLAG(Writeback, writeback, NO_COMPOUND)
-PAGEFLAG(MappedToDisk, mappedtodisk, NO_COMPOUND)
+TESTPAGEFLAG(Writeback, writeback, PF_NO_COMPOUND)
+	TESTSCFLAG(Writeback, writeback, PF_NO_COMPOUND)
+PAGEFLAG(MappedToDisk, mappedtodisk, PF_NO_COMPOUND)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, NO_COMPOUND)
-	TESTCLEARFLAG(Reclaim, reclaim, NO_COMPOUND)
-PAGEFLAG(Readahead, reclaim, NO_COMPOUND)
-	TESTCLEARFLAG(Readahead, reclaim, NO_COMPOUND)
+PAGEFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
+	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
+PAGEFLAG(Readahead, reclaim, PF_NO_COMPOUND)
+	TESTCLEARFLAG(Readahead, reclaim, PF_NO_COMPOUND)
 
 #ifdef CONFIG_HIGHMEM
 /*
@@ -290,33 +290,33 @@ PAGEFLAG_FALSE(HighMem)
 #endif
 
 #ifdef CONFIG_SWAP
-PAGEFLAG(SwapCache, swapcache, NO_COMPOUND)
+PAGEFLAG(SwapCache, swapcache, PF_NO_COMPOUND)
 #else
 PAGEFLAG_FALSE(SwapCache)
 #endif
 
-PAGEFLAG(Unevictable, unevictable, HEAD)
-	__CLEARPAGEFLAG(Unevictable, unevictable, HEAD)
-	TESTCLEARFLAG(Unevictable, unevictable, HEAD)
+PAGEFLAG(Unevictable, unevictable, PF_HEAD)
+	__CLEARPAGEFLAG(Unevictable, unevictable, PF_HEAD)
+	TESTCLEARFLAG(Unevictable, unevictable, PF_HEAD)
 
 #ifdef CONFIG_MMU
-PAGEFLAG(Mlocked, mlocked, NO_TAIL) __CLEARPAGEFLAG(Mlocked, mlocked, NO_TAIL)
-	TESTSCFLAG(Mlocked, mlocked, NO_TAIL)
-	__TESTCLEARFLAG(Mlocked, mlocked, NO_TAIL)
+PAGEFLAG(Mlocked, mlocked, PF_NO_TAIL) __CLEARPAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
+	TESTSCFLAG(Mlocked, mlocked, PF_NO_TAIL)
+	__TESTCLEARFLAG(Mlocked, mlocked, PF_NO_TAIL)
 #else
 PAGEFLAG_FALSE(Mlocked) __CLEARPAGEFLAG_NOOP(Mlocked)
 	TESTSCFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
-PAGEFLAG(Uncached, uncached, NO_COMPOUND)
+PAGEFLAG(Uncached, uncached, PF_NO_COMPOUND)
 #else
 PAGEFLAG_FALSE(Uncached)
 #endif
 
 #ifdef CONFIG_MEMORY_FAILURE
-PAGEFLAG(HWPoison, hwpoison, ANY)
-TESTSCFLAG(HWPoison, hwpoison, ANY)
+PAGEFLAG(HWPoison, hwpoison, PF_ANY)
+TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison)
@@ -413,7 +413,7 @@ static inline void SetPageUptodate(struc
 	set_bit(PG_uptodate, &page->flags);
 }
 
-CLEARPAGEFLAG(Uptodate, uptodate, NO_TAIL)
+CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
 
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
@@ -433,7 +433,7 @@ static inline void set_page_writeback_ke
 	test_set_page_writeback_keepwrite(page);
 }
 
-__PAGEFLAG(Head, head, ANY) CLEARPAGEFLAG(Head, head, ANY)
+__PAGEFLAG(Head, head, PF_ANY) CLEARPAGEFLAG(Head, head, PF_ANY)
 
 static inline int PageTail(struct page *page)
 {
@@ -654,10 +654,10 @@ static inline int page_has_private(struc
 	return !!(page->flags & PAGE_FLAGS_PRIVATE);
 }
 
-#undef ANY
-#undef HEAD
-#undef NO_TAIL
-#undef NO_COMPOUND
+#undef PF_ANY
+#undef PF_HEAD
+#undef PF_NO_TAIL
+#undef PF_NO_COMPOUND
 #endif /* !__GENERATING_BOUNDS_H */
 
 #endif	/* PAGE_FLAGS_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

