From: akpm@linux-foundation.org
Subject: + mm-cleanup-gfp_zone-fix-sparse-warnings.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:31:52 -0700
Message-ID: <201009282131.o8SLVq6v018986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab0I1VcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com


The patch titled
     mm: cleanup gfp_zone(), fix sparse warnings
has been added to the -mm tree.  Its filename is
     mm-cleanup-gfp_zone-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: cleanup gfp_zone(), fix sparse warnings
From: Namhyung Kim <namhyung@gmail.com>

Use Z[TB]_SHIFT() macro to calculate GFP_ZONE_TABLE and GFP_ZONE_BAD.
This also removes lots of warnings from sparse like following:

 warning: restricted gfp_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   43 +++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff -puN include/linux/gfp.h~mm-cleanup-gfp_zone-fix-sparse-warnings include/linux/gfp.h
--- a/include/linux/gfp.h~mm-cleanup-gfp_zone-fix-sparse-warnings
+++ a/include/linux/gfp.h
@@ -185,15 +185,16 @@ static inline int allocflags_to_migratet
 #error ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
 #endif
 
+#define ZT_SHIFT(gfp) ((__force int) (gfp) * ZONES_SHIFT)
 #define GFP_ZONE_TABLE ( \
-	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
-	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT)			\
-	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
-	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
-	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
-	| (OPT_ZONE_DMA << (__GFP_MOVABLE | __GFP_DMA) * ZONES_SHIFT)	\
-	| (ZONE_MOVABLE << (__GFP_MOVABLE | __GFP_HIGHMEM) * ZONES_SHIFT)\
-	| (OPT_ZONE_DMA32 << (__GFP_MOVABLE | __GFP_DMA32) * ZONES_SHIFT)\
+	(ZONE_NORMAL        << ZT_SHIFT(0))				\
+	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_DMA))			\
+	| (OPT_ZONE_HIGHMEM << ZT_SHIFT(__GFP_HIGHMEM))			\
+	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_DMA32))			\
+	| (ZONE_NORMAL      << ZT_SHIFT(__GFP_MOVABLE))			\
+	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA))	\
+	| (ZONE_MOVABLE     << ZT_SHIFT(__GFP_MOVABLE | __GFP_HIGHMEM)) \
+	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA32))	\
 )
 
 /*
@@ -202,24 +203,25 @@ static inline int allocflags_to_migratet
  * entry starting with bit 0. Bit is set if the combination is not
  * allowed.
  */
+#define ZB_SHIFT(gfp) ((__force int) (gfp))
 #define GFP_ZONE_BAD ( \
-	1 << (__GFP_DMA | __GFP_HIGHMEM)				\
-	| 1 << (__GFP_DMA | __GFP_DMA32)				\
-	| 1 << (__GFP_DMA32 | __GFP_HIGHMEM)				\
-	| 1 << (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)		\
-	| 1 << (__GFP_MOVABLE | __GFP_HIGHMEM | __GFP_DMA)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_HIGHMEM)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA | __GFP_HIGHMEM)\
+	1   << ZB_SHIFT(__GFP_DMA | __GFP_HIGHMEM)			\
+	| 1 << ZB_SHIFT(__GFP_DMA | __GFP_DMA32)			\
+	| 1 << ZB_SHIFT(__GFP_DMA32 | __GFP_HIGHMEM)			\
+	| 1 << ZB_SHIFT(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_HIGHMEM | __GFP_DMA)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_DMA32 | __GFP_HIGHMEM)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA |	\
+			__GFP_HIGHMEM)					\
 )
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
 	enum zone_type z;
-	int bit = flags & GFP_ZONEMASK;
+	int bit = (__force int) (flags & GFP_ZONEMASK);
 
-	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
-					 ((1 << ZONES_SHIFT) - 1);
+	z = (GFP_ZONE_TABLE >> ZT_SHIFT(bit)) & ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
 		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
@@ -231,6 +233,9 @@ static inline enum zone_type gfp_zone(gf
 	return z;
 }
 
+#undef ZT_SHIFT
+#undef ZB_SHIFT
+
 /*
  * There is only one page-allocator function, and two main namespaces to
  * it. The alloc_page*() variants return 'struct page *' and as such
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

