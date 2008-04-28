From: akpm@linux-foundation.org
Subject: - mm-get-rid-of-__zone_count.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:32 -0700
Message-ID: <200804282152.m3SLqWLM017783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934713AbYD1Vwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm: Get rid of __ZONE_COUNT
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-__zone_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: Get rid of __ZONE_COUNT
From: Christoph Lameter <clameter@sgi.com>

It was used to compensate because MAX_NR_ZONES was not available to the
#ifdefs.  Export MAX_NR_ZONES via the new mechanism and get rid of
__ZONE_COUNT.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   28 +++++++++++-----------------
 kernel/bounds.c        |    2 ++
 2 files changed, 13 insertions(+), 17 deletions(-)

diff -puN include/linux/mmzone.h~mm-get-rid-of-__zone_count include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-get-rid-of-__zone_count
+++ a/include/linux/mmzone.h
@@ -3,6 +3,7 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
+#ifndef __GENERATING_BOUNDS_H
 
 #include <linux/spinlock.h>
 #include <linux/list.h>
@@ -15,6 +16,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
+#include <linux/bounds.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
 
@@ -129,6 +131,8 @@ struct per_cpu_pageset {
 #define zone_pcp(__z, __cpu) (&(__z)->pageset[(__cpu)])
 #endif
 
+#endif /* !__GENERATING_BOUNDS.H */
+
 enum zone_type {
 #ifdef CONFIG_ZONE_DMA
 	/*
@@ -177,9 +181,11 @@ enum zone_type {
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	MAX_NR_ZONES
+	__MAX_NR_ZONES
 };
 
+#ifndef __GENERATING_BOUNDS_H
+
 /*
  * When a memory allocation must conform to specific limitations (such
  * as being suitable for DMA) the caller will pass in hints to the
@@ -188,28 +194,15 @@ enum zone_type {
  * match the requested limits. See gfp_zone() in include/linux/gfp.h
  */
 
-/*
- * Count the active zones.  Note that the use of defined(X) outside
- * #if and family is not necessarily defined so ensure we cannot use
- * it later.  Use __ZONE_COUNT to work out how many shift bits we need.
- */
-#define __ZONE_COUNT (			\
-	  defined(CONFIG_ZONE_DMA)	\
-	+ defined(CONFIG_ZONE_DMA32)	\
-	+ 1				\
-	+ defined(CONFIG_HIGHMEM)	\
-	+ 1				\
-)
-#if __ZONE_COUNT < 2
+#if MAX_NR_ZONES < 2
 #define ZONES_SHIFT 0
-#elif __ZONE_COUNT <= 2
+#elif MAX_NR_ZONES <= 2
 #define ZONES_SHIFT 1
-#elif __ZONE_COUNT <= 4
+#elif MAX_NR_ZONES <= 4
 #define ZONES_SHIFT 2
 #else
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
-#undef __ZONE_COUNT
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
@@ -1008,6 +1001,7 @@ unsigned long __init node_memmap_size_by
 #define pfn_valid_within(pfn) (1)
 #endif
 
+#endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MMZONE_H */
diff -puN kernel/bounds.c~mm-get-rid-of-__zone_count kernel/bounds.c
--- a/kernel/bounds.c~mm-get-rid-of-__zone_count
+++ a/kernel/bounds.c
@@ -7,6 +7,7 @@
 #define __GENERATING_BOUNDS_H
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
+#include <linux/mmzone.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -17,5 +18,6 @@ void foo(void)
 {
 	/* The enum constants to put into include/linux/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
+	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 	/* End of constants */
 }
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

