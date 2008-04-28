From: akpm@linux-foundation.org
Subject: - page-flags-add-pageflags_false-for-flags-that-are-always-false.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:30 -0700
Message-ID: <200804282152.m3SLqUpv017780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934711AbYD1Vwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     page flags: add PAGEFLAGS_FALSE for flags that are always false
has been removed from the -mm tree.  Its filename was
     page-flags-add-pageflags_false-for-flags-that-are-always-false.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page flags: add PAGEFLAGS_FALSE for flags that are always false
From: Christoph Lameter <clameter@sgi.com>

Turns out that there are a number of times that a flag is simply always
returning 0.  Define a macro for that.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-add-pageflags_false-for-flags-that-are-always-false include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-add-pageflags_false-for-flags-that-are-always-false
+++ a/include/linux/page-flags.h
@@ -134,6 +134,10 @@ static inline int TestClearPage##uname(s
 #define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
+#define PAGEFLAG_FALSE(uname) 						\
+static inline int Page##uname(struct page *page) 			\
+			{ return 0; }
+
 #define TESTSCFLAG(uname, lname)					\
 	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
 
@@ -171,28 +175,19 @@ PAGEFLAG(Readahead, reclaim)		/* Reminde
  */
 #define PageHighMem(__p) is_highmem(page_zone(__p))
 #else
-static inline int PageHighMem(struct page *page)
-{
-	return 0;
-}
+PAGEFLAG_FALSE(HighMem)
 #endif
 
 #ifdef CONFIG_SWAP
 PAGEFLAG(SwapCache, swapcache)
 #else
-static inline int PageSwapCache(struct page *page)
-{
-	return 0;
-}
+PAGEFLAG_FALSE(SwapCache)
 #endif
 
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 PAGEFLAG(Uncached, uncached)
 #else
-static inline int PageUncached(struct page *)
-{
-	return 0;
-}
+PAGEFLAG_FALSE(Uncached)
 #endif
 
 static inline int PageUptodate(struct page *page)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-pekka.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

