From: akpm@linux-foundation.org
Subject: - pageflags-get-rid-of-flags_reserved.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:18 -0700
Message-ID: <200804282152.m3SLqIOe017759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933964AbYD1Vwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, davem@davemloft.net, jeremy@goop.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vg


The patch titled
     pageflags: get rid of FLAGS_RESERVED
has been removed from the -mm tree.  Its filename was
     pageflags-get-rid-of-flags_reserved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflags: get rid of FLAGS_RESERVED
From: Christoph Lameter <clameter@sgi.com>

NR_PAGEFLAGS specifies the number of page flags we are using.  From that we
can calculate the number of bits leftover that can be used for zone, node (and
maybe the sections id).  There is no need anymore for FLAGS_RESERVED if we use
NR_PAGEFLAGS.

Use the new methods to make NR_PAGEFLAGS available via the preprocessor. 
NR_PAGEFLAGS is used to calculate field boundaries in the page flags fields. 
These field widths have to be available to the preprocessor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: David Miller <davem@davemloft.net>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/mm/init.c     |   16 ++++++++++++++--
 include/linux/mm.h         |    6 +++---
 include/linux/mmzone.h     |   19 -------------------
 include/linux/page-flags.h |   19 ++++++++++++-------
 kernel/bounds.c            |    2 ++
 5 files changed, 31 insertions(+), 31 deletions(-)

diff -puN arch/sparc64/mm/init.c~pageflags-get-rid-of-flags_reserved arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~pageflags-get-rid-of-flags_reserved
+++ a/arch/sparc64/mm/init.c
@@ -1699,9 +1699,21 @@ void __init paging_init(void)
 	 * functions like clear_dcache_dirty_cpu use the cpu mask
 	 * in 13-bit signed-immediate instruction fields.
 	 */
-	BUILD_BUG_ON(FLAGS_RESERVED != 32);
+
+	/*
+	 * Page flags must not reach into upper 32 bits that are used
+	 * for the cpu number
+	 */
+	BUILD_BUG_ON(NR_PAGEFLAGS > 32);
+
+	/*
+	 * The bit fields placed in the high range must not reach below
+	 * the 32 bit boundary. Otherwise we cannot place the cpu field
+	 * at the 32 bit boundary.
+	 */
 	BUILD_BUG_ON(SECTIONS_WIDTH + NODES_WIDTH + ZONES_WIDTH +
-		     ilog2(roundup_pow_of_two(NR_CPUS)) > FLAGS_RESERVED);
+		ilog2(roundup_pow_of_two(NR_CPUS)) > 32);
+
 	BUILD_BUG_ON(NR_CPUS > 4096);
 
 	kern_base = (prom_boot_mapping_phys_low >> 22UL) << 22UL;
diff -puN include/linux/mm.h~pageflags-get-rid-of-flags_reserved include/linux/mm.h
--- a/include/linux/mm.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/mm.h
@@ -407,7 +407,7 @@ static inline void set_compound_order(st
 
 #define ZONES_WIDTH		ZONES_SHIFT
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= FLAGS_RESERVED
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
 #define NODES_WIDTH		NODES_SHIFT
 #else
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
@@ -455,8 +455,8 @@ static inline void set_compound_order(st
 
 #define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
 
-#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
-#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
+#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
+#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
 #endif
 
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
diff -puN include/linux/mmzone.h~pageflags-get-rid-of-flags_reserved include/linux/mmzone.h
--- a/include/linux/mmzone.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/mmzone.h
@@ -820,25 +820,6 @@ static inline struct zoneref *first_zone
 #include <asm/sparsemem.h>
 #endif
 
-#if BITS_PER_LONG == 32
-/*
- * with 32 bit page->flags field, we reserve 9 bits for node/zone info.
- * there are 4 zones (3 bits) and this leaves 9-3=6 bits for nodes.
- */
-#define FLAGS_RESERVED		9
-
-#elif BITS_PER_LONG == 64
-/*
- * with 64 bit flags field, there's plenty of room.
- */
-#define FLAGS_RESERVED		32
-
-#else
-
-#error BITS_PER_LONG not defined
-
-#endif
-
 #if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
 	!defined(CONFIG_ARCH_POPULATES_NODE_MAP)
 static inline unsigned long early_pfn_to_nid(unsigned long pfn)
diff -puN include/linux/page-flags.h~pageflags-get-rid-of-flags_reserved include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/page-flags.h
@@ -6,7 +6,10 @@
 #define PAGE_FLAGS_H
 
 #include <linux/types.h>
+#ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
+#include <linux/bounds.h>
+#endif /* !__GENERATING_BOUNDS_H */
 
 /*
  * Various page->flags bits:
@@ -59,13 +62,12 @@
  * extends from the high bits downwards.
  *
  *  | FIELD | ... | FLAGS |
- *  N-1     ^             0
- *          (N-FLAGS_RESERVED)
+ *  N-1           ^       0
+ *               (NR_PAGEFLAGS)
  *
- * The fields area is reserved for fields mapping zone, node and SPARSEMEM
- * section.  The boundry between these two areas is defined by
- * FLAGS_RESERVED which defines the width of the fields section
- * (see linux/mmzone.h).  New flags must _not_ overlap with this area.
+ * The fields area is reserved for fields mapping zone, node (for NUMA) and
+ * SPARSEMEM section (for variants of SPARSEMEM that require section ids like
+ * SPARSEMEM_EXTREME with !SPARSEMEM_VMEMMAP).
  */
 enum pageflags {
 	PG_locked,		/* Page is locked. Don't touch. */
@@ -101,9 +103,11 @@ enum pageflags {
  */
 	PG_uncached = 31,		/* Page has been mapped as uncached */
 #endif
-	NR_PAGEFLAGS
+	__NR_PAGEFLAGS
 };
 
+#ifndef __GENERATING_BOUNDS_H
+
 /*
  * Manipulation of page state flags
  */
@@ -304,4 +308,5 @@ static inline void set_page_writeback(st
 	test_set_page_writeback(page);
 }
 
+#endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
diff -puN kernel/bounds.c~pageflags-get-rid-of-flags_reserved kernel/bounds.c
--- a/kernel/bounds.c~pageflags-get-rid-of-flags_reserved
+++ a/kernel/bounds.c
@@ -6,6 +6,7 @@
 
 #define __GENERATING_BOUNDS_H
 /* Include headers that define the enum constants of interest */
+#include <linux/page-flags.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -15,5 +16,6 @@
 void foo(void)
 {
 	/* The enum constants to put into include/linux/bounds.h */
+	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
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

