From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-increase-__gfp_bits_shift-to-include-__gfp_other_node.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:42 -0700
Message-ID: <201108161847.p7GIlnPO015155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPSsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, ak@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: page_alloc: increase __GFP_BITS_SHIFT to include __GFP_OTHER_NODE
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-increase-__gfp_bits_shift-to-include-__gfp_other_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: page_alloc: increase __GFP_BITS_SHIFT to include __GFP_OTHER_NODE
From: Johannes Weiner <hannes@cmpxchg.org>

__GFP_OTHER_NODE is used for NUMA allocations on behalf of other nodes. 
It's supposed to be passed through from the page allocator to
zone_statistics(), but it never gets there as gfp_allowed_mask is not wide
enough and masks out the flag early in the allocation path.

The result is an accounting glitch where successful NUMA allocations
by-agent are not properly attributed as local.

Increase __GFP_BITS_SHIFT so that it includes __GFP_OTHER_NODE.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-page_alloc-increase-__gfp_bits_shift-to-include-__gfp_other_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-increase-__gfp_bits_shift-to-include-__gfp_other_node
+++ a/include/linux/gfp.h
@@ -92,7 +92,7 @@ struct vm_area_struct;
  */
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
-#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 24	/* Room for N __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch

