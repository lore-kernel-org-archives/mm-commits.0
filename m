From: akpm@linux-foundation.org
Subject: [patch 017/131] mm/slab.c: only set __GFP_RECLAIMABLE once
Date: Wed, 15 Nov 2017 17:32:14 -0800
Message-ID: <20171116013214.uxKP3R9S9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932772AbdKPBcQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
@@ -1410,8 +1410,6 @@ static struct page *kmem_getpages(struct
 	int nr_pages;
 
 	flags |= cachep->allocflags;
-	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		flags |= __GFP_RECLAIMABLE;
 
 	page = __alloc_pages_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
@@ -2144,6 +2142,8 @@ done:
 	cachep->allocflags = __GFP_COMP;
 	if (flags & SLAB_CACHE_DMA)
 		cachep->allocflags |= GFP_DMA;
+	if (flags & SLAB_RECLAIM_ACCOUNT)
+		cachep->allocflags |= __GFP_RECLAIMABLE;
 	cachep->size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
_
