From: akpm@linux-foundation.org
Subject: [patch 77/96] drm/i915: use __GFP_RETRY_MAYFAIL
Date: Wed, 12 Jul 2017 14:36:55 -0700
Message-ID: <20170712213655.--8F2Gd5w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753300AbdGLVg5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.com, ralf@linux-mips.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: drm/i915: use __GFP_RETRY_MAYFAIL

24f8e00a8a2e ("drm/i915: Prefer to report ENOMEM rather than incur the oom
for gfx allocations") has tried to remove disruptive OOM killer because
the userspace should be able to cope with allocation failures.  At the
time only __GFP_NORETRY could achieve that and it turned out that this
would fail the allocations just too easily.  So "drm/i915: Remove
__GFP_NORETRY from our buffer allocator" removed it and hoped for a better
solution.  __GFP_RETRY_MAYFAIL is that solution.  It will keep retrying
the allocation until there is no more progress and we would go OOM. 
Instead we fail the allocation and let the caller to deal with it.

Link: http://lkml.kernel.org/r/20170623085345.11304-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-__gfp_retry_mayfail drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-__gfp_retry_mayfail
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2434,8 +2434,9 @@ rebuild_st:
 				 * again with !__GFP_NORETRY. However, we still
 				 * want to fail this allocation rather than
 				 * trigger the out-of-memory killer and for
-				 * this we want the future __GFP_MAYFAIL.
+				 * this we want __GFP_RETRY_MAYFAIL.
 				 */
+				gfp |= __GFP_RETRY_MAYFAIL;
 			}
 		} while (1);
 
_
