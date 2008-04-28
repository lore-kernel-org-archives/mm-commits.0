From: akpm@linux-foundation.org
Subject: - page-flags-handle-pg_uncached-like-all-other-flags.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:28 -0700
Message-ID: <200804282152.m3SLqS2s017776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934684AbYD1Vwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dcn@sgi.com, jes@trained-monkey.org, mm-commits@vger.kernel.org


The patch titled
     page flags: handle PG_uncached like all other flags
has been removed from the -mm tree.  Its filename was
     page-flags-handle-pg_uncached-like-all-other-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page flags: handle PG_uncached like all other flags
From: Christoph Lameter <clameter@sgi.com>

Remove the special setup for PG_uncached and simply make it part of the enum. 
The page flag will only be allocated when the kernel build includes the
uncached allocator.

Acked-by: Dean Nelson <dcn@sgi.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-handle-pg_uncached-like-all-other-flags include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-handle-pg_uncached-like-all-other-flags
+++ a/include/linux/page-flags.h
@@ -88,16 +88,8 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
-
-#if (BITS_PER_LONG > 32)
-/*
- * 64-bit-only flags build down from bit 31
- *
- * 32 bit  -------------------------------| FIELDS |       FLAGS         |
- * 64 bit  |           FIELDS             | ??????         FLAGS         |
- *         63                            32                              0
- */
-	PG_uncached = 31,		/* Page has been mapped as uncached */
+#ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
+	PG_uncached,		/* Page has been mapped as uncached */
 #endif
 	__NR_PAGEFLAGS
 };
@@ -194,8 +186,13 @@ static inline int PageSwapCache(struct p
 }
 #endif
 
-#if (BITS_PER_LONG > 32)
+#ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 PAGEFLAG(Uncached, uncached)
+#else
+static inline int PageUncached(struct page *)
+{
+	return 0;
+}
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

