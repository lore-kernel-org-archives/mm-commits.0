From: akpm@linux-foundation.org
Subject: [merged] page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:33 -0700
Message-ID: <200906171835.n5HIZXIL001593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759248AbZFQSqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     page-allocator: use integer fields lookup for gfp_zone and check for errors in flags passed to the page allocator
has been removed from the -mm tree.  Its filename was
     page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: use integer fields lookup for gfp_zone and check for errors in flags passed to the page allocator
From: Christoph Lameter <cl@linux.com>

This simplifies the code in gfp_zone() and also keeps the ability of the
compiler to use constant folding to get rid of gfp_zone processing.

The lookup of the zone is done using a bitfield stored in an integer.  So
the code in gfp_zone is a simple extraction of bits from a constant
bitfield.  The compiler is generating a load of a constant into a register
and then performs a shift and mask operation to get the zone from a gfp_t.
 No cachelines are touched and no branches have to be predicted by the
compiler.

We are doing some macro tricks here to convince the compiler to always do
the constant folding if possible.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |  111 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 96 insertions(+), 15 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator
+++ a/include/linux/gfp.h
@@ -21,7 +21,8 @@ struct vm_area_struct;
 #define __GFP_DMA	((__force gfp_t)0x01u)
 #define __GFP_HIGHMEM	((__force gfp_t)0x02u)
 #define __GFP_DMA32	((__force gfp_t)0x04u)
-
+#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
+#define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 /*
  * Action modifiers - doesn't change the zoning
  *
@@ -51,7 +52,6 @@ struct vm_area_struct;
 #define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
-#define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
 
 #define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
@@ -116,24 +116,105 @@ static inline int allocflags_to_migratet
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
-static inline enum zone_type gfp_zone(gfp_t flags)
-{
+#ifdef CONFIG_HIGHMEM
+#define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
+#else
+#define OPT_ZONE_HIGHMEM ZONE_NORMAL
+#endif
+
 #ifdef CONFIG_ZONE_DMA
-	if (flags & __GFP_DMA)
-		return ZONE_DMA;
+#define OPT_ZONE_DMA ZONE_DMA
+#else
+#define OPT_ZONE_DMA ZONE_NORMAL
 #endif
+
 #ifdef CONFIG_ZONE_DMA32
-	if (flags & __GFP_DMA32)
-		return ZONE_DMA32;
+#define OPT_ZONE_DMA32 ZONE_DMA32
+#else
+#define OPT_ZONE_DMA32 ZONE_NORMAL
 #endif
-	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
-			(__GFP_HIGHMEM | __GFP_MOVABLE))
-		return ZONE_MOVABLE;
-#ifdef CONFIG_HIGHMEM
-	if (flags & __GFP_HIGHMEM)
-		return ZONE_HIGHMEM;
+
+/*
+ * GFP_ZONE_TABLE is a word size bitstring that is used for looking up the
+ * zone to use given the lowest 4 bits of gfp_t. Entries are ZONE_SHIFT long
+ * and there are 16 of them to cover all possible combinations of
+ * __GFP_DMA, __GFP_DMA32, __GFP_MOVABLE and __GFP_HIGHMEM
+ *
+ * The zone fallback order is MOVABLE=>HIGHMEM=>NORMAL=>DMA32=>DMA.
+ * But GFP_MOVABLE is not only a zone specifier but also an allocation
+ * policy. Therefore __GFP_MOVABLE plus another zone selector is valid.
+ * Only 1bit of the lowest 3 bit (DMA,DMA32,HIGHMEM) can be set to "1".
+ *
+ *       bit       result
+ *       =================
+ *       0x0    => NORMAL
+ *       0x1    => DMA or NORMAL
+ *       0x2    => HIGHMEM or NORMAL
+ *       0x3    => BAD (DMA+HIGHMEM)
+ *       0x4    => DMA32 or DMA or NORMAL
+ *       0x5    => BAD (DMA+DMA32)
+ *       0x6    => BAD (HIGHMEM+DMA32)
+ *       0x7    => BAD (HIGHMEM+DMA32+DMA)
+ *       0x8    => NORMAL (MOVABLE+0)
+ *       0x9    => DMA or NORMAL (MOVABLE+DMA)
+ *       0xa    => MOVABLE (Movable is valid only if HIGHMEM is set too)
+ *       0xb    => BAD (MOVABLE+HIGHMEM+DMA)
+ *       0xc    => DMA32 (MOVABLE+HIGHMEM+DMA32)
+ *       0xd    => BAD (MOVABLE+DMA32+DMA)
+ *       0xe    => BAD (MOVABLE+DMA32+HIGHMEM)
+ *       0xf    => BAD (MOVABLE+DMA32+HIGHMEM+DMA)
+ *
+ * ZONES_SHIFT must be <= 2 on 32 bit platforms.
+ */
+
+#if 16 * ZONES_SHIFT > BITS_PER_LONG
+#error ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
+#endif
+
+#define GFP_ZONE_TABLE ( \
+	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
+	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT) 			\
+	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
+	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
+	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
+	| (OPT_ZONE_DMA << (__GFP_MOVABLE | __GFP_DMA) * ZONES_SHIFT)	\
+	| (ZONE_MOVABLE << (__GFP_MOVABLE | __GFP_HIGHMEM) * ZONES_SHIFT)\
+	| (OPT_ZONE_DMA32 << (__GFP_MOVABLE | __GFP_DMA32) * ZONES_SHIFT)\
+)
+
+/*
+ * GFP_ZONE_BAD is a bitmap for all combination of __GFP_DMA, __GFP_DMA32
+ * __GFP_HIGHMEM and __GFP_MOVABLE that are not permitted. One flag per
+ * entry starting with bit 0. Bit is set if the combination is not
+ * allowed.
+ */
+#define GFP_ZONE_BAD ( \
+	1 << (__GFP_DMA | __GFP_HIGHMEM)				\
+	| 1 << (__GFP_DMA | __GFP_DMA32)				\
+	| 1 << (__GFP_DMA32 | __GFP_HIGHMEM)				\
+	| 1 << (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)		\
+	| 1 << (__GFP_MOVABLE | __GFP_HIGHMEM | __GFP_DMA)		\
+	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA)		\
+	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_HIGHMEM)		\
+	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA | __GFP_HIGHMEM)\
+)
+
+static inline enum zone_type gfp_zone(gfp_t flags)
+{
+	enum zone_type z;
+	int bit = flags & GFP_ZONEMASK;
+
+	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
+					 ((1 << ZONES_SHIFT) - 1);
+
+	if (__builtin_constant_p(bit))
+		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+	else {
+#ifdef CONFIG_DEBUG_VM
+		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 #endif
-	return ZONE_NORMAL;
+	}
+	return z;
 }
 
 /*
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

