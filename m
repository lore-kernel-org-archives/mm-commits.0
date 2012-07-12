From: akpm@linux-foundation.org
Subject: + mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:27:27 -0700
Message-ID: <20120712212727.CB2155C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:35370 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab2GLV1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:27:31 -0400
Received: by fat25 with SMTP id 25so147123fat.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:27:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: mm: introduce __GFP_MEMALLOC to allow access to emergency reserves
has been added to the -mm tree.  Its filename is
     mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1512,7 +1512,6 @@ failed:
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
-#define ALLOC_PFMEMALLOC	0x80 /* Caller has PF_MEMALLOC set */
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
@@ -2293,11 +2292,10 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
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
 
@@ -2306,7 +2304,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 
 bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 {
-	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_PFMEMALLOC);
+	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
 }
 
 static inline struct page *
@@ -2497,12 +2495,12 @@ nopage:
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
@@ -1883,7 +1883,7 @@ static void *kmem_getpages(struct kmem_c
 		return NULL;
 	}
 
-	/* Record if ALLOC_PFMEMALLOC was set when allocating the slab */
+	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (unlikely(page->pfmemalloc))
 		pfmemalloc_active = true;
 
_
Subject: Subject: mm: introduce __GFP_MEMALLOC to allow access to emergency reserves

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch

