From: akpm@linux-foundation.org
Subject: + mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch added
 to -mm tree
Date: Fri, 10 Jun 2016 14:22:44 -0700
Message-ID: <575b2fa4.Y9G96VwWFilzaclh%akpm__6767.67216432399$1465593780$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbcFJVWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 17:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mw@semihalf.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, sl[au]b: add __GFP_ATOMIC to the GFP reclaim mask
has been added to the -mm tree.  Its filename is
     mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch

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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch

