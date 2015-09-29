From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:07:45 -0700
Message-ID: <560afda1.7dfKuwfaEvrYrBmH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbI2VHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use masks and shifts when converting GFP flags to migrate types
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch

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
Subject: mm, page_alloc: use masks and shifts when converting GFP flags to migrate types

This patch redefines which GFP bits are used for specifying mobility and
the order of the migrate types.  Once redefined it's possible to convert
GFP flags to a migrate type with a simple mask and shift.  The only
downside is that readers of OOM kill messages and allocation failures may
have been used to the existing values but scripts/gfp-translate will help.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |   12 +++++++-----
 include/linux/mmzone.h |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/gfp.h~mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types
+++ a/include/linux/gfp.h
@@ -14,7 +14,7 @@ struct vm_area_struct;
 #define ___GFP_HIGHMEM		0x02u
 #define ___GFP_DMA32		0x04u
 #define ___GFP_MOVABLE		0x08u
-#define ___GFP_WAIT		0x10u
+#define ___GFP_RECLAIMABLE	0x10u
 #define ___GFP_HIGH		0x20u
 #define ___GFP_IO		0x40u
 #define ___GFP_FS		0x80u
@@ -29,7 +29,7 @@ struct vm_area_struct;
 #define ___GFP_NOMEMALLOC	0x10000u
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
-#define ___GFP_RECLAIMABLE	0x80000u
+#define ___GFP_WAIT		0x80000u
 #define ___GFP_NOACCOUNT	0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_NO_KSWAPD	0x400000u
@@ -126,6 +126,7 @@ struct vm_area_struct;
 
 /* This mask makes up all the page movable related flags */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
+#define GFP_MOVABLE_SHIFT 3
 
 /* Control page allocator reclaim behavior */
 #define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
@@ -152,14 +153,15 @@ struct vm_area_struct;
 /* Convert GFP flags to their corresponding migrate type */
 static inline int gfpflags_to_migratetype(const gfp_t gfp_flags)
 {
-	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
+	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
 
 	if (unlikely(page_group_by_mobility_disabled))
 		return MIGRATE_UNMOVABLE;
 
 	/* Group based on mobility */
-	return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
-		((gfp_flags & __GFP_RECLAIMABLE) != 0);
+	return (gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
 }
 
 #ifdef CONFIG_HIGHMEM
diff -puN include/linux/mmzone.h~mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types
+++ a/include/linux/mmzone.h
@@ -37,8 +37,8 @@
 
 enum {
 	MIGRATE_UNMOVABLE,
-	MIGRATE_RECLAIMABLE,
 	MIGRATE_MOVABLE,
+	MIGRATE_RECLAIMABLE,
 	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
 	MIGRATE_RESERVE = MIGRATE_PCPTYPES,
 #ifdef CONFIG_CMA
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
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

