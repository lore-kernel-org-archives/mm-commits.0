From: akpm@linux-foundation.org
Subject: [patch 23/41] mm, sl[au]b: add __GFP_ATOMIC to the GFP reclaim
 mask
Date: Fri, 24 Jun 2016 14:49:37 -0700
Message-ID: <576daaf1.PXM3ANqFhU3PoL95%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcFXVti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, mhocko@suse.com, mw@semihalf.com, stable@vger.kernel.org, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, sl[au]b: add __GFP_ATOMIC to the GFP reclaim mask

Commit d0164adc89f6 ("mm, page_alloc: distinguish between being unable to
sleep, unwilling to sleep and avoiding waking kswapd") modified __GFP_WAIT
to explicitly identify the difference between atomic callers and those
that were unwilling to sleep.  Later the definition was removed entirely.

The GFP_RECLAIM_MASK is the set of flags that affect watermark checking
and reclaim behaviour but __GFP_ATOMIC was never added. Without it, atomic
users of the slab allocator strip the __GFP_ATOMIC flag and cannot access
the page allocator atomic reserves.  This patch addresses the problem.

The user-visible impact depends on the workload but potentially atomic
allocations unnecessarily fail without this path.

Link: http://lkml.kernel.org/r/20160610093832.GK2527@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Marcin Wojtas <mw@semihalf.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/internal.h~mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask mm/internal.h
--- a/mm/internal.h~mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask
+++ a/mm/internal.h
@@ -24,7 +24,8 @@
  */
 #define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC|\
+			__GFP_ATOMIC)
 
 /* The GFP flags allowed during early boot */
 #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
_
