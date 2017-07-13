From: akpm@linux-foundation.org
Subject: [merged] xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:42:57 -0700
Message-ID: <20170713204257.SxNLsxd70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUm6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz


The patch titled
     Subject: xfs: map KM_MAYFAIL to __GFP_RETRY_MAYFAIL
has been removed from the -mm tree.  Its filename was
     xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: xfs: map KM_MAYFAIL to __GFP_RETRY_MAYFAIL

KM_MAYFAIL didn't have any suitable GFP_FOO counterpart until recently so
it relied on the default page allocator behavior for the given set of
flags.  This means that small allocations actually never failed.

Now that we have __GFP_RETRY_MAYFAIL flag which works independently on the
allocation request size we can map KM_MAYFAIL to it.  The allocator will
try as hard as it can to fulfill the request but fails eventually if the
progress cannot be made.  It does so without triggering the OOM killer
which can be seen as an improvement because KM_MAYFAIL users should be
able to deal with allocation failures.

Link: http://lkml.kernel.org/r/20170623085345.11304-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Daney <david.daney@cavium.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/kmem.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/xfs/kmem.h~xfs-map-km_mayfail-to-__gfp_retry_mayfail fs/xfs/kmem.h
--- a/fs/xfs/kmem.h~xfs-map-km_mayfail-to-__gfp_retry_mayfail
+++ a/fs/xfs/kmem.h
@@ -54,6 +54,16 @@ kmem_flags_convert(xfs_km_flags_t flags)
 			lflags &= ~__GFP_FS;
 	}
 
+	/*
+	 * Default page/slab allocator behavior is to retry for ever
+	 * for small allocations. We can override this behavior by using
+	 * __GFP_RETRY_MAYFAIL which will tell the allocator to retry as long
+	 * as it is feasible but rather fail than retry forever for all
+	 * request sizes.
+	 */
+	if (flags & KM_MAYFAIL)
+		lflags |= __GFP_RETRY_MAYFAIL;
+
 	if (flags & KM_ZERO)
 		lflags |= __GFP_ZERO;
 
_

Patches currently in -mm which might be from mhocko@suse.com are


