From: akpm@linux-foundation.org
Subject: + mm-slab-only-set-__gfp_reclaimable-once.patch added to -mm tree
Date: Wed, 18 Oct 2017 15:31:14 -0700
Message-ID: <59e7d632.LeocPcXfcEBMbHLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdJRWbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, penberg@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: only set __GFP_RECLAIMABLE once
has been added to the -mm tree.  Its filename is
     mm-slab-only-set-__gfp_reclaimable-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-only-set-__gfp_reclaimable-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-only-set-__gfp_reclaimable-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/slab.c: only set __GFP_RECLAIMABLE once

SLAB_RECLAIM_ACCOUNT is a permanent attribute of a slab cache.  Set
__GFP_RECLAIMABLE as part of its ->allocflags rather than check the cachep
flag on every page allocation.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1710171527560.140898@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~mm-slab-only-set-__gfp_reclaimable-once mm/slab.c
--- a/mm/slab.c~mm-slab-only-set-__gfp_reclaimable-once
+++ a/mm/slab.c
@@ -1409,8 +1409,6 @@ static struct page *kmem_getpages(struct
 	int nr_pages;
 
 	flags |= cachep->allocflags;
-	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		flags |= __GFP_RECLAIMABLE;
 
 	page = __alloc_pages_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
@@ -2143,6 +2141,8 @@ done:
 	cachep->allocflags = __GFP_COMP;
 	if (flags & SLAB_CACHE_DMA)
 		cachep->allocflags |= GFP_DMA;
+	if (flags & SLAB_RECLAIM_ACCOUNT)
+		cachep->allocflags |= __GFP_RECLAIMABLE;
 	cachep->size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-slab-only-set-__gfp_reclaimable-once.patch
mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

