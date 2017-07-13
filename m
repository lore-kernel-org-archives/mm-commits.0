From: akpm@linux-foundation.org
Subject: [merged]
 mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:43:00 -0700
Message-ID: <20170713204300.HbDkNez53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUnB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz


The patch titled
     Subject: mm: kvmalloc support __GFP_RETRY_MAYFAIL for all sizes
has been removed from the -mm tree.  Its filename was
     mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: kvmalloc support __GFP_RETRY_MAYFAIL for all sizes

Now that __GFP_RETRY_MAYFAIL has a reasonable semantic regardless of the
request size we can drop the hackish implementation for !costly orders. 
__GFP_RETRY_MAYFAIL retries as long as the reclaim makes a forward
progress and backs of when we are out of memory for the requested size. 
Therefore we do not need to enforce__GFP_NORETRY for !costly orders just
to silent the oom killer anymore.

Link: http://lkml.kernel.org/r/20170623085345.11304-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN mm/util.c~mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes mm/util.c
--- a/mm/util.c~mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes
+++ a/mm/util.c
@@ -339,9 +339,9 @@ EXPORT_SYMBOL(vm_mmap);
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * Reclaim modifiers - __GFP_NORETRY and __GFP_NOFAIL are not supported. __GFP_RETRY_MAYFAIL
- * is supported only for large (>32kB) allocations, and it should be used only if
- * kmalloc is preferable to the vmalloc fallback, due to visible performance drawbacks.
+ * Reclaim modifiers - __GFP_NORETRY and __GFP_NOFAIL are not supported.
+ * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
+ * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
  * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
  */
@@ -366,13 +366,7 @@ void *kvmalloc_node(size_t size, gfp_t f
 	if (size > PAGE_SIZE) {
 		kmalloc_flags |= __GFP_NOWARN;
 
-		/*
-		 * We have to override __GFP_RETRY_MAYFAIL by __GFP_NORETRY for !costly
-		 * requests because there is no other way to tell the allocator
-		 * that we want to fail rather than retry endlessly.
-		 */
-		if (!(kmalloc_flags & __GFP_RETRY_MAYFAIL) ||
-				(size <= PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
+		if (!(kmalloc_flags & __GFP_RETRY_MAYFAIL))
 			kmalloc_flags |= __GFP_NORETRY;
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are


