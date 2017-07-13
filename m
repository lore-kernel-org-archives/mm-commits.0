From: akpm@linux-foundation.org
Subject: [merged]
 mips-do-not-use-__gfp_repeat-for-order-0-request.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:42:51 -0700
Message-ID: <20170713204251.cA1KzrxZH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUmw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz


The patch titled
     Subject: MIPS: do not use __GFP_REPEAT for order-0 request
has been removed from the -mm tree.  Its filename was
     mips-do-not-use-__gfp_repeat-for-order-0-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: MIPS: do not use __GFP_REPEAT for order-0 request

Patch series "mm: give __GFP_REPEAT a better semantic".

The main motivation for the change is that the current implementation of
__GFP_REPEAT is not very much useful.  

The documentation says:
 * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
 *   _might_ fail.  This depends upon the particular VM implementation.

It just fails to mention that this is true only for large (costly) high
order which has been the case since the flag was introduced.  A similar
semantic would be really helpful for smal orders as well, though, because
we have places where a failure with a specific fallback error handling is
preferred to a potential endless loop inside the page allocator.

The earlier cleanup dropped __GFP_REPEAT usage for low (!costly) order
users so only those which might use larger orders have stayed.  One new
user added in the meantime is addressed in patch 1.

Let's rename the flag to something more verbose and use it for existing
users.  Semantic for those will not change.  Then implement low (!costly)
orders failure path which is hit after the page allocator is about to
invoke the oom killer.  With that we have a good counterpart for
__GFP_NORETRY and finally can tell try as hard as possible without the OOM
killer.

Xfs code already has an existing annotation for allocations which are
allowed to fail and we can trivially map them to the new gfp flag because
it will provide the semantic KM_MAYFAIL wants.  Christoph didn't consider
the new flag really necessary but didn't respond to the OOM killer aspect
of the change so I have kept the patch.  If this is still seen as not
really needed I can drop the patch.

kvmalloc will allow also !costly high order allocations to retry hard
before falling back to the vmalloc.

drm/i915 asked for the new semantic explicitly.

Memory migration code, especially for the memory hotplug, should back off
rather than invoking the OOM killer as well.


This patch (of 6):

3377e227af44 ("MIPS: Add 48-bit VA space (and 4-level page tables) for 4K
pages.") has added a new __GFP_REPEAT user but using this flag doesn't
really make any sense for order-0 request which is the case here because
PUD_ORDER is 0.  __GFP_REPEAT has historically effect only on allocation
requests with order > PAGE_ALLOC_COSTLY_ORDER.

This doesn't introduce any functional change.  This is a preparatory patch
for later work which renames the flag and redefines its semantic.

Link: http://lkml.kernel.org/r/20170623085345.11304-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/include/asm/pgalloc.h~mips-do-not-use-__gfp_repeat-for-order-0-request arch/mips/include/asm/pgalloc.h
--- a/arch/mips/include/asm/pgalloc.h~mips-do-not-use-__gfp_repeat-for-order-0-request
+++ a/arch/mips/include/asm/pgalloc.h
@@ -116,7 +116,7 @@ static inline pud_t *pud_alloc_one(struc
 {
 	pud_t *pud;
 
-	pud = (pud_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT, PUD_ORDER);
+	pud = (pud_t *) __get_free_pages(GFP_KERNEL, PUD_ORDER);
 	if (pud)
 		pud_init((unsigned long)pud, (unsigned long)invalid_pmd_table);
 	return pud;
_

Patches currently in -mm which might be from mhocko@suse.com are


