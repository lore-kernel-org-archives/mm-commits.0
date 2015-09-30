From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch added to -mm tree
Date: Wed, 30 Sep 2015 14:04:05 -0700
Message-ID: <560c4e45.1rYb4Y48KlcrDkT+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbbI3VEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: hide some GFP internals and document the bits and flag combinations
has been added to the -mm tree.  Its filename is
     mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: page_alloc: hide some GFP internals and document the bits and flag combinations

Andrew stated the following

	We have quite a history of remote parts of the kernel using
	weird/wrong/inexplicable combinations of __GFP_ flags.	I tend
	to think that this is because we didn't adequately explain the
	interface.

	And I don't think that gfp.h really improved much in this area as
	a result of this patchset.  Could you go through it some time and
	decide if we've adequately documented all this stuff?

This patches first moves some GFP flag combinations that are part of the MM
internals to mm/internal.h. The rest of the patch documents the __GFP_FOO
bits under various headings and then documents the flag combinations. It
will not help callers that are brain damaged but the clarity might motivate
some fixes and avoid future mistakes.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |  253 ++++++++++++++++++++++++++++--------------
 mm/internal.h       |   19 +++
 mm/shmem.c          |    2 
 mm/vmalloc.c        |    2 
 4 files changed, 194 insertions(+), 82 deletions(-)

diff -puN include/linux/gfp.h~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations
+++ a/include/linux/gfp.h
@@ -39,9 +39,7 @@ struct vm_area_struct;
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
- * GFP bitmasks..
- *
- * Zone modifiers (see linux/mmzone.h - low three bits)
+ * Physical address zone modifiers (see linux/mmzone.h - low four bits)
  *
  * Do not put any conditional on these. If necessary modify the definitions
  * without the underscores and use them consistently. The definitions here may
@@ -51,87 +49,199 @@ struct vm_area_struct;
 #define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
 #define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
 #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* Page is movable */
-#define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
+#define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* ZONE_MOVABLE allowed */
+
+/*
+ * Page mobility and placement hints
+ *
+ * These flags provide hints about how mobile the page is. Pages with similar
+ * mobility are placed within the same pageblocks to minimise problems due
+ * to external fragmentation.
+ *
+ * __GFP_MOVABLE (also a zone modifier) indicates that the page can be
+ *   moved by page migration during memory compaction or can be reclaimed.
+ *
+ * __GFP_RECLAIMABLE is used for slab allocations that specify
+ *   SLAB_RECLAIM_ACCOUNT and whose pages can be freed via shrinkers.
+ *
+ * __GFP_WRITE indicates the caller intends to dirty the page. Where possible,
+ *   these pages will be spread between local zones to avoid all the dirty
+ *   pages being in one zone (fair zone allocation policy).
+ *
+ * __GFP_HARDWALL enforces the cpuset memory allocation policy.
+ *
+ * __GFP_THISNODE forces the allocation to be satisified from the requested
+ *   node with no fallbacks or placement policy enforcements.
+ */
+#define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
+#define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
+#define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
+#define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
+
+/*
+ * Watermark modifiers -- controls access to emergency reserves
+ *
+ * __GFP_HIGH indicates that the caller is high-priority and that granting
+ *   the request is necessary before the system can make forward progress.
+ *   For example, creating an IO context to clean pages.
+ *
+ * __GFP_ATOMIC indicates that the caller cannot reclaim or sleep and is
+ *   high priority. Users are typically interrupt handlers. This may be
+ *   used in conjunction with __GFP_HIGH
+ *
+ * __GFP_MEMALLOC allows access to all memory. This should only be used when
+ *   the caller guarantees the allocation will allow more memory to be freed
+ *   very shortly e.g. process exiting or swapping. Users either should
+ *   be the MM or co-ordinating closely with the VM (e.g. swap over NFS).
+ *
+ * __GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
+ *   This takes precedence over the __GFP_MEMALLOC flag if both are set.
+ *
+ * __GFP_NOACCOUNT ignores the accounting for kmemcg limit enforcement.
+ */
+#define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)
+#define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)
+#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)
+#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC)
+#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT)
+
 /*
- * Action modifiers - doesn't change the zoning
+ * Reclaim modifiers
+ *
+ * __GFP_IO can start physical IO.
+ *
+ * __GFP_FS can call down to the low-level FS. Avoids the allocator
+ *   recursing into the filesystem which might already be holding locks.
+ *
+ * __GFP_DIRECT_RECLAIM indicates that the caller may enter direct reclaim.
+ *   This flag can be cleared to avoid unnecessary delays when a fallback
+ *   option is available.
+ *
+ * __GFP_KSWAPD_RECLAIM indicates that the caller wants kswapd when the low
+ *   watermark is reached and have it reclaim pages until the high watermark
+ *   is reached. A caller may wish to clear this flag when fallback options
+ *   are available and the reclaim is likely to disrupt the system. The
+ *   canonical example is THP allocation where a fallback is cheap but
+ *   reclaim/compaction may cause indirect stalls.
+ *
+ * __GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd reclaim.
  *
  * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
- * _might_ fail.  This depends upon the particular VM implementation.
+ *   _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures. New users should be evaluated carefully
- * (and the flag should be used only when there is no reasonable failure policy)
- * but it is definitely preferable to use the flag rather than opencode endless
- * loop around allocator.
+ *   cannot handle allocation failures. New users should be evaluated carefully
+ *   (and the flag should be used only when there is no reasonable failure
+ *   policy) but it is definitely preferable to use the flag rather than
+ *   opencode endless loop around allocator.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely and will
- * return NULL when direct reclaim and memory compaction have failed to allow
- * the allocation to succeed.  The OOM killer is not called with the current
- * implementation.
- *
- * __GFP_MOVABLE: Flag that this page will be movable by the page migration
- * mechanism or reclaimed
- */
-#define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)  /* Caller cannot wait or reschedule */
-#define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)	/* Should access emergency pools? */
-#define __GFP_IO	((__force gfp_t)___GFP_IO)	/* Can start physical IO? */
-#define __GFP_FS	((__force gfp_t)___GFP_FS)	/* Can call down to low-level FS? */
-#define __GFP_COLD	((__force gfp_t)___GFP_COLD)	/* Cache-cold page required */
-#define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)	/* Suppress page allocation failure warning */
-#define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)	/* See above */
-#define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)	/* See above */
-#define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
-#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves */
-#define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
-#define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
-#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves.
-							 * This takes precedence over the
-							 * __GFP_MEMALLOC flag if both are
-							 * set
-							 */
-#define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
-#define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
-#define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
-#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT) /* Don't account to kmemcg */
-#define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
-
-#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
-#define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
-
-/*
- * A caller that is willing to wait may enter direct reclaim and will
- * wake kswapd to reclaim pages in the background until the high
- * watermark is met. A caller may wish to clear __GFP_DIRECT_RECLAIM to
- * avoid unnecessary delays when a fallback option is available but
- * still allow kswapd to reclaim in the background. The kswapd flag
- * can be cleared when the reclaiming of pages would cause unnecessary
- * disruption.
+ *   return NULL when direct reclaim and memory compaction have failed to allow
+ *   the allocation to succeed.  The OOM killer is not called with the current
+ *   implementation.
  */
-#define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
+#define __GFP_IO	((__force gfp_t)___GFP_IO)
+#define __GFP_FS	((__force gfp_t)___GFP_FS)
 #define __GFP_DIRECT_RECLAIM	((__force gfp_t)___GFP_DIRECT_RECLAIM) /* Caller can reclaim */
 #define __GFP_KSWAPD_RECLAIM	((__force gfp_t)___GFP_KSWAPD_RECLAIM) /* kswapd can wake */
+#define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
+#define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)
+#define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)
+#define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY)
 
 /*
- * This may seem redundant, but it's a way of annotating false positives vs.
- * allocations that simply cannot be supported (e.g. page tables).
+ * Action modifiers
+ *
+ * __GFP_COLD indicates that the caller does not expect to be used in the near
+ *   future. Where possible, a cache-cold page will be returned.
+ *
+ * __GFP_NOWARN suppresses allocation failure reports.
+ *
+ * __GFP_COMP address compound page metadata.
+ *
+ * __GFP_ZERO returns a zeroed page on success.
+ *
+ * __GFP_NOTRACK avoids tracking with kmemcheck.
+ *
+ * __GFP_NOTRACK_FALSE_POSITIVE is an alias of __GFP_NOTRACK. It's a means of
+ *   distinguishing in the source between false positives and allocations that
+ *   cannot be supported (e.g. page tables).
+ *
+ * __GFP_OTHER_NODE is for allocations that are on a remote node but that
+ *   should not be accounted for as a remote allocation in vmstat. A
+ *   typical user would be khugepaged collapsing a huge page on a remote
+ *   node.
  */
+#define __GFP_COLD	((__force gfp_t)___GFP_COLD)
+#define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
+#define __GFP_COMP	((__force gfp_t)___GFP_COMP)
+#define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
+#define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
+#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE)
 
-#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
+/* Room for N __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 26
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /*
- * GFP_ATOMIC callers can not sleep, need the allocation to succeed.
- * A lower watermark is applied to allow access to "atomic reserves"
+ * Useful GFP flag combinations that are commonly used. It is recommended
+ * that subsystems start with one of these combinations and then set/clear
+ * __GFP_FOO flags as necessary.
+ *
+ * GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
+ *   watermark is applied to allow access to "atomic reserves"
+ *
+ * GFP_KERNEL is typical for kernel-internal allocations. The caller requires
+ *   ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
+ *
+ * GFP_NOWAIT is for kernel allocations that should not stall for direct
+ *   reclaim, start physical IO or use any filesystem callback.
+ *
+ * GFP_NOIO will use direct reclaim to discard clean pages or slab pages
+ *   that do not require the starting of any physical IO.
+ *
+ * GFP_NOFS will use direct reclaim but will not use any filesystem interfaces.
+ *
+ * GFP_USER is for userspace allocations that also need to be directly
+ *   accessibly by the kernel or hardware. It is typically used by hardware
+ *   for buffers that are mapped to userspace (e.g. graphics) that hardware
+ *   still must DMA to. cpuset limits are enforced for these allocations.
+ *
+ * GFP_HIGHUSER is for userspace allocations that may be mapped to userspace,
+ *   do not need to be directly accessible by the kernel but that cannot
+ *   move once in use. An example may be a hardware allocation that maps
+ *   data directly into userspace but has no addressing limitations.
+ *
+ * GFP_DMA exists for historical reasons and should be avoided where possible.
+ *   The flags indicates that the caller requires that the lowest zone be
+ *   used (ZONE_DMA or 16M on x86-64). Ideally, this would be removed but
+ *   it would require careful auditing as some users really require it and
+ *   others use the flag to avoid lowmem reserves in ZONE_DMA and treat the
+ *   lowest zone as a type of emergency reserve.
+ *
+ * GFP_DMA32 is similar to GFP_DMA except that the caller requires a 32-bit
+ *   address.
+ *
+ * GFP_HIGHUSER_MOVABLE is for userspace allocations that the kernel does not
+ *   need direct access to but can use kmap() when access is required. They
+ *   are expected to be movable via page reclaim or page migration. Typically,
+ *   pages on the LRU would also be allocated with GFP_HIGHUSER_MOVABLE.
+ *
+ * GFP_TRANSHUGE is used for THP allocations. They are compound allocations
+ *   that will fail quickly if memory is not available and will not wake
+ *   kswapd on failure.
  */
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
+#define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
 #define GFP_NOIO	(__GFP_RECLAIM)
 #define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
-#define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
 #define GFP_TEMPORARY	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | \
 			 __GFP_RECLAIMABLE)
 #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
+#define GFP_DMA		__GFP_DMA
+#define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_IOFS	(__GFP_IO | __GFP_FS | __GFP_KSWAPD_RECLAIM)
@@ -139,33 +249,10 @@ struct vm_area_struct;
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN) & \
 			 ~__GFP_KSWAPD_RECLAIM)
 
-/* This mask makes up all the page movable related flags */
+/* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 #define GFP_MOVABLE_SHIFT 3
 
-/* Control page allocator reclaim behavior */
-#define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
-			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
-
-/* Control slab gfp mask during early boot */
-#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
-
-/* Control allocation constraints */
-#define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
-
-/* Do not use these with a slab allocator */
-#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
-
-/* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
-   platforms, used as appropriate on others */
-
-#define GFP_DMA		__GFP_DMA
-
-/* 4GB DMA on some platforms */
-#define GFP_DMA32	__GFP_DMA32
-
-/* Convert GFP flags to their corresponding migrate type */
 static inline int gfpflags_to_migratetype(const gfp_t gfp_flags)
 {
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
@@ -178,6 +265,8 @@ static inline int gfpflags_to_migratetyp
 	/* Group based on mobility */
 	return (gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
 }
+#undef GFP_MOVABLE_MASK
+#undef GFP_MOVABLE_SHIFT
 
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
diff -puN mm/internal.h~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations mm/internal.h
--- a/mm/internal.h~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations
+++ a/mm/internal.h
@@ -18,6 +18,25 @@ extern int do_swap_page(struct mm_struct
 			unsigned long address, pte_t *page_table, pmd_t *pmd,
 			unsigned int flags, pte_t orig_pte);
 
+/*
+ * The set of flags that only affect watermark checking and reclaim
+ * behaviour. This is used by the MM to obey the caller constraints
+ * about IO, FS and watermark checking while ignoring placement
+ * hints such as HIGHMEM usage.
+ */
+#define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
+			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
+
+/* The GFP flags allowed during early boot */
+#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
+
+/* Control allocation cpuset and node placement constraints */
+#define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
+
+/* Do not use these with a slab allocator */
+#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
+
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
diff -puN mm/shmem.c~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations mm/shmem.c
--- a/mm/shmem.c~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations
+++ a/mm/shmem.c
@@ -73,6 +73,8 @@ static struct vfsmount *shm_mnt;
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
+#include "internal.h"
+
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_CACHE_ALIGN(size) >> PAGE_SHIFT)
 
diff -puN mm/vmalloc.c~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations mm/vmalloc.c
--- a/mm/vmalloc.c~mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations
+++ a/mm/vmalloc.c
@@ -35,6 +35,8 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
+#include "internal.h"
+
 struct vfree_deferred {
 	struct llist_head list;
 	struct work_struct wq;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

