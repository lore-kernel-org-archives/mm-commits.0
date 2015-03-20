From: akpm@linux-foundation.org
Subject: +
 include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch added to
 -mm tree
Date: Fri, 20 Mar 2015 13:36:33 -0700
Message-ID: <550c84d1.soMUfOpf3ANsyKNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbCTUge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags.h: rename macros to avoid collisions
has been added to the -mm tree.  Its filename is
     include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/page-flags.h: rename macros to avoid collisions

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |  114 +++++++++++++++++------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff -puN include/linux/page-flags.h~include-linux-page-flagsh-rename-macros-to-avoid-collisions include/linux/page-flags.h
--- a/include/linux/page-flags.h~include-linux-page-flagsh-rename-macros-to-avoid-collisions
+++ a/include/linux/page-flags.h
@@ -135,15 +135,15 @@ enum pageflags {
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
@@ -269,55 +269,55 @@ static inline struct page *compound_head
 	return page;
 }
 
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
@@ -330,33 +330,33 @@ PAGEFLAG_FALSE(HighMem)
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
@@ -446,7 +446,7 @@ static inline void SetPageUptodate(struc
 	set_bit(PG_uptodate, &page->flags);
 }
 
-CLEARPAGEFLAG(Uptodate, uptodate, NO_TAIL)
+CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
 
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
@@ -475,8 +475,8 @@ static inline void set_page_writeback_ke
  * and arch/powerpc/kvm/book3s_64_vio_hv.c which use it to detect huge pages
  * and avoid handling those in real mode.
  */
-__PAGEFLAG(Head, head, ANY) CLEARPAGEFLAG(Head, head, ANY)
-__PAGEFLAG(Tail, tail, ANY)
+__PAGEFLAG(Head, head, PF_ANY) CLEARPAGEFLAG(Head, head, PF_ANY)
+__PAGEFLAG(Tail, tail, PF_ANY)
 
 static inline int PageCompound(struct page *page)
 {
@@ -500,8 +500,8 @@ static inline void ClearPageCompound(str
  * because PageCompound is always set for compound pages and not for
  * pages on the LRU and/or pagecache.
  */
-TESTPAGEFLAG(Compound, compound, ANY)
-__SETPAGEFLAG(Head, compound, ANY)  __CLEARPAGEFLAG(Head, compound, ANY)
+TESTPAGEFLAG(Compound, compound, PF_ANY)
+__SETPAGEFLAG(Head, compound, PF_ANY)  __CLEARPAGEFLAG(Head, compound, PF_ANY)
 
 /*
  * PG_reclaim is used in combination with PG_compound to mark the
@@ -715,10 +715,10 @@ static inline int page_has_private(struc
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

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-support-madvisemadv_free-fix-2.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

