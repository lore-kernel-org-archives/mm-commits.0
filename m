From: akpm@linux-foundation.org
Subject: [merged] mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:32 -0700
Message-ID: <20120801201533.A7F4B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39320 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2HAUPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:37 -0400
Received: by wibhr14 with SMTP id hr14so199018wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages
has been removed from the -mm tree.  Its filename was
     mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages

When a user or administrator requires swap for their application, they
create a swap partition and file, format it with mkswap and activate it
with swapon.  Swap over the network is considered as an option in diskless
systems.  The two likely scenarios are when blade servers are used as part
of a cluster where the form factor or maintenance costs do not allow the
use of disks and thin clients.

The Linux Terminal Server Project recommends the use of the Network Block
Device (NBD) for swap according to the manual at
https://sourceforge.net/projects/ltsp/files/Docs-Admin-Guide/LTSPManual.pdf/download
There is also documentation and tutorials on how to setup swap over NBD at
places like https://help.ubuntu.com/community/UbuntuLTSP/EnableNBDSWAP The
nbd-client also documents the use of NBD as swap.  Despite this, the fact
is that a machine using NBD for swap can deadlock within minutes if swap
is used intensively.  This patch series addresses the problem.

The core issue is that network block devices do not use mempools like
normal block devices do.  As the host cannot control where they receive
packets from, they cannot reliably work out in advance how much memory
they might need.  Some years ago, Peter Zijlstra developed a series of
patches that supported swap over an NFS that at least one distribution is
carrying within their kernels.  This patch series borrows very heavily
from Peter's work to support swapping over NBD as a pre-requisite to
supporting swap-over-NFS.  The bulk of the complexity is concerned with
preserving memory that is allocated from the PFMEMALLOC reserves for use
by the network layer which is needed for both NBD and NFS.

Patch 1 adds knowledge of the PFMEMALLOC reserves to SLAB and SLUB to
	preserve access to pages allocated under low memory situations
	to callers that are freeing memory.

Patch 2 optimises the SLUB fast path to avoid pfmemalloc checks

Patch 3 introduces __GFP_MEMALLOC to allow access to the PFMEMALLOC
	reserves without setting PFMEMALLOC.

Patch 4 opens the possibility for softirqs to use PFMEMALLOC reserves
	for later use by network packet processing.

Patch 5 only sets page->pfmemalloc when ALLOC_NO_WATERMARKS was required

Patch 6 ignores memory policies when ALLOC_NO_WATERMARKS is set.

Patches 7-12 allows network processing to use PFMEMALLOC reserves when
	the socket has been marked as being used by the VM to clean pages. If
	packets are received and stored in pages that were allocated under
	low-memory situations and are unrelated to the VM, the packets
	are dropped.

	Patch 11 reintroduces __skb_alloc_page which the networking
	folk may object to but is needed in some cases to propogate
	pfmemalloc from a newly allocated page to an skb. If there is a
	strong objection, this patch can be dropped with the impact being
	that swap-over-network will be slower in some cases but it should
	not fail.

Patch 13 is a micro-optimisation to avoid a function call in the
	common case.

Patch 14 tags NBD sockets as being SOCK_MEMALLOC so they can use
	PFMEMALLOC if necessary.

Patch 15 notes that it is still possible for the PFMEMALLOC reserve
	to be depleted. To prevent this, direct reclaimers get throttled on
	a waitqueue if 50% of the PFMEMALLOC reserves are depleted.  It is
	expected that kswapd and the direct reclaimers already running
	will clean enough pages for the low watermark to be reached and
	the throttled processes are woken up.

Patch 16 adds a statistic to track how often processes get throttled

Some basic performance testing was run using kernel builds, netperf on
loopback for UDP and TCP, hackbench (pipes and sockets), iozone and
sysbench.  Each of them were expected to use the sl*b allocators
reasonably heavily but there did not appear to be significant performance
variances.

For testing swap-over-NBD, a machine was booted with 2G of RAM with a
swapfile backed by NBD.  8*NUM_CPU processes were started that create
anonymous memory mappings and read them linearly in a loop.  The total
size of the mappings were 4*PHYSICAL_MEMORY to use swap heavily under
memory pressure.

Without the patches and using SLUB, the machine locks up within minutes
and runs to completion with them applied.  With SLAB, the story is
different as an unpatched kernel run to completion.  However, the patched
kernel completed the test 45% faster.

MICRO
                                         3.5.0-rc2 3.5.0-rc2
					 vanilla     swapnbd
Unrecognised test vmscan-anon-mmap-write
MMTests Statistics: duration
Sys Time Running Test (seconds)             197.80    173.07
User+Sys Time Running Test (seconds)        206.96    182.03
Total Elapsed Time (seconds)               3240.70   1762.09



This patch: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages

Allocations of pages below the min watermark run a risk of the machine
hanging due to a lack of memory.  To prevent this, only callers who have
PF_MEMALLOC or TIF_MEMDIE set and are not processing an interrupt are
allowed to allocate with ALLOC_NO_WATERMARKS.  Once they are allocated to
a slab though, nothing prevents other callers consuming free objects
within those slabs.  This patch limits access to slab pages that were
alloced from the PFMEMALLOC reserves.

When this patch is applied, pages allocated from below the low watermark
are returned with page->pfmemalloc set and it is up to the caller to
determine how the page should be protected.  SLAB restricts access to any
page with page->pfmemalloc set to callers which are known to able to
access the PFMEMALLOC reserve.  If one is not available, an attempt is
made to allocate a new page rather than use a reserve.  SLUB is a bit more
relaxed in that it only records if the current per-CPU page was allocated
from PFMEMALLOC reserve and uses another partial slab if the caller does
not have the necessary GFP or process flags.  This was found to be
sufficient in tests to avoid hangs due to SLUB generally maintaining
smaller lists than SLAB.

In low-memory conditions it does mean that !PFMEMALLOC allocators can fail
a slab allocation even though free objects are available because they are
being preserved for callers that are freeing pages.

[a.p.zijlstra@chello.nl: Original implementation]
[sebastian@breakpoint.cc: Correct order of page flag clearing]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h   |    9 +
 include/linux/page-flags.h |   29 +++++
 mm/internal.h              |    3 
 mm/page_alloc.c            |   27 ++++
 mm/slab.c                  |  192 +++++++++++++++++++++++++++++++----
 mm/slub.c                  |   29 ++++-
 6 files changed, 264 insertions(+), 25 deletions(-)

diff -puN include/linux/mm_types.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages
+++ a/include/linux/mm_types.h
@@ -54,6 +54,15 @@ struct page {
 		union {
 			pgoff_t index;		/* Our offset within mapping. */
 			void *freelist;		/* slub/slob first free object */
+			bool pfmemalloc;	/* If set by the page allocator,
+						 * ALLOC_PFMEMALLOC was set
+						 * and the low watermark was not
+						 * met implying that the system
+						 * is under some pressure. The
+						 * caller should try ensure
+						 * this page is only used to
+						 * free other pages.
+						 */
 		};
 
 		union {
diff -puN include/linux/page-flags.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages
+++ a/include/linux/page-flags.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/mmdebug.h>
 #ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
 #include <generated/bounds.h>
@@ -453,6 +454,34 @@ static inline int PageTransTail(struct p
 }
 #endif
 
+/*
+ * If network-based swap is enabled, sl*b must keep track of whether pages
+ * were allocated from pfmemalloc reserves.
+ */
+static inline int PageSlabPfmemalloc(struct page *page)
+{
+	VM_BUG_ON(!PageSlab(page));
+	return PageActive(page);
+}
+
+static inline void SetPageSlabPfmemalloc(struct page *page)
+{
+	VM_BUG_ON(!PageSlab(page));
+	SetPageActive(page);
+}
+
+static inline void __ClearPageSlabPfmemalloc(struct page *page)
+{
+	VM_BUG_ON(!PageSlab(page));
+	__ClearPageActive(page);
+}
+
+static inline void ClearPageSlabPfmemalloc(struct page *page)
+{
+	VM_BUG_ON(!PageSlab(page));
+	ClearPageActive(page);
+}
+
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1 << PG_mlocked)
 #else
diff -puN mm/internal.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages mm/internal.h
--- a/mm/internal.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages
+++ a/mm/internal.h
@@ -279,6 +279,9 @@ static inline struct page *mem_map_next(
 #define __paginginit __init
 #endif
 
+/* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
+bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
+
 /* Memory initialisation debug and verification */
 enum mminit_level {
 	MMINIT_WARNING,
diff -puN mm/page_alloc.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages
+++ a/mm/page_alloc.c
@@ -1513,6 +1513,7 @@ failed:
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
+#define ALLOC_PFMEMALLOC	0x80 /* Caller has PF_MEMALLOC set */
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
@@ -2293,16 +2294,22 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-		if (!in_interrupt() &&
-		    ((current->flags & PF_MEMALLOC) ||
-		     unlikely(test_thread_flag(TIF_MEMDIE))))
+	if ((current->flags & PF_MEMALLOC) ||
+			unlikely(test_thread_flag(TIF_MEMDIE))) {
+		alloc_flags |= ALLOC_PFMEMALLOC;
+
+		if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 
 	return alloc_flags;
 }
 
+bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
+{
+	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_PFMEMALLOC);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -2490,10 +2497,18 @@ nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
 	return page;
 got_pg:
+	/*
+	 * page->pfmemalloc is set when the caller had PFMEMALLOC set or is
+	 * been OOM killed. The expectation is that the caller is taking
+	 * steps that will free more memory. The caller should avoid the
+	 * page being used for !PFMEMALLOC purposes.
+	 */
+	page->pfmemalloc = !!(alloc_flags & ALLOC_PFMEMALLOC);
+
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
-	return page;
 
+	return page;
 }
 
 /*
@@ -2544,6 +2559,8 @@ retry_cpuset:
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
+	else
+		page->pfmemalloc = false;
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 
diff -puN mm/slab.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages mm/slab.c
--- a/mm/slab.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages
+++ a/mm/slab.c
@@ -124,6 +124,8 @@
 
 #include <trace/events/kmem.h>
 
+#include	"internal.h"
+
 /*
  * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_RED_ZONE & SLAB_POISON.
  *		  0 for faster, smaller code (especially in the critical paths).
@@ -152,6 +154,12 @@
 #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
 #endif
 
+/*
+ * true if a page was allocated from pfmemalloc reserves for network-based
+ * swap
+ */
+static bool pfmemalloc_active __read_mostly;
+
 /* Legal flag mask for kmem_cache_create(). */
 #if DEBUG
 # define CREATE_MASK	(SLAB_RED_ZONE | \
@@ -257,9 +265,30 @@ struct array_cache {
 			 * Must have this definition in here for the proper
 			 * alignment of array_cache. Also simplifies accessing
 			 * the entries.
+			 *
+			 * Entries should not be directly dereferenced as
+			 * entries belonging to slabs marked pfmemalloc will
+			 * have the lower bits set SLAB_OBJ_PFMEMALLOC
 			 */
 };
 
+#define SLAB_OBJ_PFMEMALLOC	1
+static inline bool is_obj_pfmemalloc(void *objp)
+{
+	return (unsigned long)objp & SLAB_OBJ_PFMEMALLOC;
+}
+
+static inline void set_obj_pfmemalloc(void **objp)
+{
+	*objp = (void *)((unsigned long)*objp | SLAB_OBJ_PFMEMALLOC);
+	return;
+}
+
+static inline void clear_obj_pfmemalloc(void **objp)
+{
+	*objp = (void *)((unsigned long)*objp & ~SLAB_OBJ_PFMEMALLOC);
+}
+
 /*
  * bootstrap: The caches do not work without cpuarrays anymore, but the
  * cpuarrays are allocated from the generic caches...
@@ -900,6 +929,102 @@ static struct array_cache *alloc_arrayca
 	return nc;
 }
 
+static inline bool is_slab_pfmemalloc(struct slab *slabp)
+{
+	struct page *page = virt_to_page(slabp->s_mem);
+
+	return PageSlabPfmemalloc(page);
+}
+
+/* Clears pfmemalloc_active if no slabs have pfmalloc set */
+static void recheck_pfmemalloc_active(struct kmem_cache *cachep,
+						struct array_cache *ac)
+{
+	struct kmem_list3 *l3 = cachep->nodelists[numa_mem_id()];
+	struct slab *slabp;
+	unsigned long flags;
+
+	if (!pfmemalloc_active)
+		return;
+
+	spin_lock_irqsave(&l3->list_lock, flags);
+	list_for_each_entry(slabp, &l3->slabs_full, list)
+		if (is_slab_pfmemalloc(slabp))
+			goto out;
+
+	list_for_each_entry(slabp, &l3->slabs_partial, list)
+		if (is_slab_pfmemalloc(slabp))
+			goto out;
+
+	list_for_each_entry(slabp, &l3->slabs_free, list)
+		if (is_slab_pfmemalloc(slabp))
+			goto out;
+
+	pfmemalloc_active = false;
+out:
+	spin_unlock_irqrestore(&l3->list_lock, flags);
+}
+
+static void *ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
+						gfp_t flags, bool force_refill)
+{
+	int i;
+	void *objp = ac->entry[--ac->avail];
+
+	/* Ensure the caller is allowed to use objects from PFMEMALLOC slab */
+	if (unlikely(is_obj_pfmemalloc(objp))) {
+		struct kmem_list3 *l3;
+
+		if (gfp_pfmemalloc_allowed(flags)) {
+			clear_obj_pfmemalloc(&objp);
+			return objp;
+		}
+
+		/* The caller cannot use PFMEMALLOC objects, find another one */
+		for (i = 1; i < ac->avail; i++) {
+			/* If a !PFMEMALLOC object is found, swap them */
+			if (!is_obj_pfmemalloc(ac->entry[i])) {
+				objp = ac->entry[i];
+				ac->entry[i] = ac->entry[ac->avail];
+				ac->entry[ac->avail] = objp;
+				return objp;
+			}
+		}
+
+		/*
+		 * If there are empty slabs on the slabs_free list and we are
+		 * being forced to refill the cache, mark this one !pfmemalloc.
+		 */
+		l3 = cachep->nodelists[numa_mem_id()];
+		if (!list_empty(&l3->slabs_free) && force_refill) {
+			struct slab *slabp = virt_to_slab(objp);
+			ClearPageSlabPfmemalloc(virt_to_page(slabp->s_mem));
+			clear_obj_pfmemalloc(&objp);
+			recheck_pfmemalloc_active(cachep, ac);
+			return objp;
+		}
+
+		/* No !PFMEMALLOC objects available */
+		ac->avail++;
+		objp = NULL;
+	}
+
+	return objp;
+}
+
+static void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
+								void *objp)
+{
+	if (unlikely(pfmemalloc_active)) {
+		/* Some pfmemalloc slabs exist, check if this is one */
+		struct page *page = virt_to_page(objp);
+		if (PageSlabPfmemalloc(page))
+			set_obj_pfmemalloc(&objp);
+	}
+
+	ac->entry[ac->avail++] = objp;
+}
+
 /*
  * Transfer objects in one arraycache to another.
  * Locking must be handled by the caller.
@@ -1076,7 +1201,7 @@ static inline int cache_free_alien(struc
 			STATS_INC_ACOVERFLOW(cachep);
 			__drain_alien_cache(cachep, alien, nodeid);
 		}
-		alien->entry[alien->avail++] = objp;
+		ac_put_obj(cachep, alien, objp);
 		spin_unlock(&alien->lock);
 	} else {
 		spin_lock(&(cachep->nodelists[nodeid])->list_lock);
@@ -1759,6 +1884,10 @@ static void *kmem_getpages(struct kmem_c
 		return NULL;
 	}
 
+	/* Record if ALLOC_PFMEMALLOC was set when allocating the slab */
+	if (unlikely(page->pfmemalloc))
+		pfmemalloc_active = true;
+
 	nr_pages = (1 << cachep->gfporder);
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		add_zone_page_state(page_zone(page),
@@ -1766,9 +1895,13 @@ static void *kmem_getpages(struct kmem_c
 	else
 		add_zone_page_state(page_zone(page),
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
-	for (i = 0; i < nr_pages; i++)
+	for (i = 0; i < nr_pages; i++) {
 		__SetPageSlab(page + i);
 
+		if (page->pfmemalloc)
+			SetPageSlabPfmemalloc(page + i);
+	}
+
 	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
 		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
 
@@ -1800,6 +1933,7 @@ static void kmem_freepages(struct kmem_c
 				NR_SLAB_UNRECLAIMABLE, nr_freed);
 	while (i--) {
 		BUG_ON(!PageSlab(page));
+		__ClearPageSlabPfmemalloc(page);
 		__ClearPageSlab(page);
 		page++;
 	}
@@ -3015,16 +3149,19 @@ bad:
 #define check_slabp(x,y) do { } while(0)
 #endif
 
-static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)
+static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags,
+							bool force_refill)
 {
 	int batchcount;
 	struct kmem_list3 *l3;
 	struct array_cache *ac;
 	int node;
 
-retry:
 	check_irq_off();
 	node = numa_mem_id();
+	if (unlikely(force_refill))
+		goto force_grow;
+retry:
 	ac = cpu_cache_get(cachep);
 	batchcount = ac->batchcount;
 	if (!ac->touched && batchcount > BATCHREFILL_LIMIT) {
@@ -3074,8 +3211,8 @@ retry:
 			STATS_INC_ACTIVE(cachep);
 			STATS_SET_HIGH(cachep);
 
-			ac->entry[ac->avail++] = slab_get_obj(cachep, slabp,
-							    node);
+			ac_put_obj(cachep, ac, slab_get_obj(cachep, slabp,
+									node));
 		}
 		check_slabp(cachep, slabp);
 
@@ -3094,18 +3231,22 @@ alloc_done:
 
 	if (unlikely(!ac->avail)) {
 		int x;
+force_grow:
 		x = cache_grow(cachep, flags | GFP_THISNODE, node, NULL);
 
 		/* cache_grow can reenable interrupts, then ac could change. */
 		ac = cpu_cache_get(cachep);
-		if (!x && ac->avail == 0)	/* no objects in sight? abort */
+
+		/* no objects in sight? abort */
+		if (!x && (ac->avail == 0 || force_refill))
 			return NULL;
 
 		if (!ac->avail)		/* objects refilled by interrupt? */
 			goto retry;
 	}
 	ac->touched = 1;
-	return ac->entry[--ac->avail];
+
+	return ac_get_obj(cachep, ac, flags, force_refill);
 }
 
 static inline void cache_alloc_debugcheck_before(struct kmem_cache *cachep,
@@ -3187,23 +3328,35 @@ static inline void *____cache_alloc(stru
 {
 	void *objp;
 	struct array_cache *ac;
+	bool force_refill = false;
 
 	check_irq_off();
 
 	ac = cpu_cache_get(cachep);
 	if (likely(ac->avail)) {
-		STATS_INC_ALLOCHIT(cachep);
 		ac->touched = 1;
-		objp = ac->entry[--ac->avail];
-	} else {
-		STATS_INC_ALLOCMISS(cachep);
-		objp = cache_alloc_refill(cachep, flags);
+		objp = ac_get_obj(cachep, ac, flags, false);
+
 		/*
-		 * the 'ac' may be updated by cache_alloc_refill(),
-		 * and kmemleak_erase() requires its correct value.
+		 * Allow for the possibility all avail objects are not allowed
+		 * by the current flags
 		 */
-		ac = cpu_cache_get(cachep);
+		if (objp) {
+			STATS_INC_ALLOCHIT(cachep);
+			goto out;
+		}
+		force_refill = true;
 	}
+
+	STATS_INC_ALLOCMISS(cachep);
+	objp = cache_alloc_refill(cachep, flags, force_refill);
+	/*
+	 * the 'ac' may be updated by cache_alloc_refill(),
+	 * and kmemleak_erase() requires its correct value.
+	 */
+	ac = cpu_cache_get(cachep);
+
+out:
 	/*
 	 * To avoid a false negative, if an object that is in one of the
 	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
@@ -3525,9 +3678,12 @@ static void free_block(struct kmem_cache
 	struct kmem_list3 *l3;
 
 	for (i = 0; i < nr_objects; i++) {
-		void *objp = objpp[i];
+		void *objp;
 		struct slab *slabp;
 
+		clear_obj_pfmemalloc(&objpp[i]);
+		objp = objpp[i];
+
 		slabp = virt_to_slab(objp);
 		l3 = cachep->nodelists[node];
 		list_del(&slabp->list);
@@ -3645,7 +3801,7 @@ static inline void __cache_free(struct k
 		cache_flusharray(cachep, ac);
 	}
 
-	ac->entry[ac->avail++] = objp;
+	ac_put_obj(cachep, ac, objp);
 }
 
 /**
diff -puN mm/slub.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages mm/slub.c
--- a/mm/slub.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages
+++ a/mm/slub.c
@@ -34,6 +34,8 @@
 
 #include <trace/events/kmem.h>
 
+#include "internal.h"
+
 /*
  * Lock order:
  *   1. slab_mutex (Global Mutex)
@@ -1354,6 +1356,8 @@ static struct page *new_slab(struct kmem
 	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab = s;
 	__SetPageSlab(page);
+	if (page->pfmemalloc)
+		SetPageSlabPfmemalloc(page);
 
 	start = page_address(page);
 
@@ -1397,6 +1401,7 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	if (current->reclaim_state)
@@ -2126,6 +2131,14 @@ static inline void *new_slab_objects(str
 	return freelist;
 }
 
+static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags)
+{
+	if (unlikely(PageSlabPfmemalloc(page)))
+		return gfp_pfmemalloc_allowed(gfpflags);
+
+	return true;
+}
+
 /*
  * Check the page->freelist of a page and either transfer the freelist to the per cpu freelist
  * or deactivate the page.
@@ -2206,6 +2219,18 @@ redo:
 		goto new_slab;
 	}
 
+	/*
+	 * By rights, we should be searching for a slab page that was
+	 * PFMEMALLOC but right now, we are losing the pfmemalloc
+	 * information when the page leaves the per-cpu allocator
+	 */
+	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
+		deactivate_slab(s, page, c->freelist);
+		c->page = NULL;
+		c->freelist = NULL;
+		goto new_slab;
+	}
+
 	/* must check again c->freelist in case of cpu migration or IRQ */
 	freelist = c->freelist;
 	if (freelist)
@@ -2312,8 +2337,8 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node)))
