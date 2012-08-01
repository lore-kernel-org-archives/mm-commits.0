From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:43 -0700
Message-ID: <20120801201543.E2B171E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2HAUPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:45 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce __GFP_MEMALLOC to allow access to emergency reserves
has been removed from the -mm tree.  Its filename was
     mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: introduce __GFP_MEMALLOC to allow access to emergency reserves

__GFP_MEMALLOC will allow the allocation to disregard the watermarks, much
like PF_MEMALLOC.  It allows one to pass along the memalloc state in
object related allocation flags as opposed to task related flags, such as
sk->sk_allocation.  This removes the need for ALLOC_PFMEMALLOC as callers
using __GFP_MEMALLOC can get the ALLOC_NO_WATERMARK flag which is now
enough to identify allocations related to page reclaim.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h             |   10 ++++++++--
 include/linux/mm_types.h        |    2 +-
 include/trace/events/gfpflags.h |    1 +
 mm/page_alloc.c                 |   22 ++++++++++------------
 mm/slab.c                       |    2 +-
 5 files changed, 21 insertions(+), 16 deletions(-)

diff -puN include/linux/gfp.h~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves include/linux/gfp.h
--- a/include/linux/gfp.h~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves
+++ a/include/linux/gfp.h
@@ -23,6 +23,7 @@ struct vm_area_struct;
 #define ___GFP_REPEAT		0x400u
 #define ___GFP_NOFAIL		0x800u
 #define ___GFP_NORETRY		0x1000u
+#define ___GFP_MEMALLOC		0x2000u
 #define ___GFP_COMP		0x4000u
 #define ___GFP_ZERO		0x8000u
 #define ___GFP_NOMEMALLOC	0x10000u
@@ -76,9 +77,14 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)	/* See above */
 #define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)	/* See above */
 #define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
+#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves */
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
-#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves */
+#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves.
+							 * This takes precedence over the
+							 * __GFP_MEMALLOC flag if both are
+							 * set
+							 */
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
@@ -129,7 +135,7 @@ struct vm_area_struct;
 /* Control page allocator reclaim behavior */
 #define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_NOMEMALLOC)
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
 
 /* Control slab gfp mask during early boot */
 #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))
diff -puN include/linux/mm_types.h~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves
+++ a/include/linux/mm_types.h
@@ -55,7 +55,7 @@ struct page {
 			pgoff_t index;		/* Our offset within mapping. */
 			void *freelist;		/* slub/slob first free object */
 			bool pfmemalloc;	/* If set by the page allocator,
-						 * ALLOC_PFMEMALLOC was set
+						 * ALLOC_NO_WATERMARKS was set
 						 * and the low watermark was not
 						 * met implying that the system
 						 * is under some pressure. The
diff -puN include/trace/events/gfpflags.h~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves
+++ a/include/trace/events/gfpflags.h
@@ -30,6 +30,7 @@
 	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
 	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
 	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
+	{(unsigned long)__GFP_MEMALLOC,		"GFP_MEMALLOC"},	\
 	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
 	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
diff -puN mm/page_alloc.c~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves
+++ a/mm/page_alloc.c
@@ -1513,7 +1513,6 @@ failed:
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
-#define ALLOC_PFMEMALLOC	0x80 /* Caller has PF_MEMALLOC set */
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
@@ -2294,11 +2293,10 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-	if ((current->flags & PF_MEMALLOC) ||
-			unlikely(test_thread_flag(TIF_MEMDIE))) {
-		alloc_flags |= ALLOC_PFMEMALLOC;
-
-		if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
+	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
+		if (gfp_mask & __GFP_MEMALLOC)
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+		else if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 
@@ -2307,7 +2305,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 
 bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 {
-	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_PFMEMALLOC);
+	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
 }
 
 static inline struct page *
@@ -2498,12 +2496,12 @@ nopage:
 	return page;
 got_pg:
 	/*
-	 * page->pfmemalloc is set when the caller had PFMEMALLOC set or is
-	 * been OOM killed. The expectation is that the caller is taking
-	 * steps that will free more memory. The caller should avoid the
-	 * page being used for !PFMEMALLOC purposes.
+	 * page->pfmemalloc is set when the caller had PFMEMALLOC set, is
+	 * been OOM killed or specified __GFP_MEMALLOC. The expectation is
+	 * that the caller is taking steps that will free more memory. The
+	 * caller should avoid the page being used for !PFMEMALLOC purposes.
 	 */
-	page->pfmemalloc = !!(alloc_flags & ALLOC_PFMEMALLOC);
+	page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
 
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
diff -puN mm/slab.c~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves mm/slab.c
--- a/mm/slab.c~mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves
+++ a/mm/slab.c
@@ -1884,7 +1884,7 @@ static void *kmem_getpages(struct kmem_c
 		return NULL;
 	}
 
-	/* Record if ALLOC_PFMEMALLOC was set when allocating the slab */
+	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (unlikely(page->pfmemalloc))
 		pfmemalloc_active = true;
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

