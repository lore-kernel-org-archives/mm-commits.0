From: akpm@linux-foundation.org
Subject: [merged]
 slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:41 -0700
Message-ID: <56e9b9c5.TGuldUkN2rUM3ymy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPTxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use slab_pre_alloc_hook in SLAB allocator shared with SLUB
has been removed from the -mm tree.  Its filename was
     slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: use slab_pre_alloc_hook in SLAB allocator shared with SLUB

Deduplicate code in SLAB allocator functions slab_alloc() and
slab_alloc_node() by using the slab_pre_alloc_hook() call, which is now
shared between SLUB and SLAB.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN mm/slab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub mm/slab.c
--- a/mm/slab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub
+++ a/mm/slab.c
@@ -3144,14 +3144,10 @@ slab_alloc_node(struct kmem_cache *cache
 	int slab_node = numa_mem_id();
 
 	flags &= gfp_allowed_mask;
-
-	lockdep_trace_alloc(flags);
-
-	if (should_failslab(cachep, flags))
+	cachep = slab_pre_alloc_hook(cachep, flags);
+	if (unlikely(!cachep))
 		return NULL;
 
-	cachep = memcg_kmem_get_cache(cachep, flags);
-
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3232,14 +3228,10 @@ slab_alloc(struct kmem_cache *cachep, gf
 	void *objp;
 
 	flags &= gfp_allowed_mask;
-
-	lockdep_trace_alloc(flags);
-
-	if (should_failslab(cachep, flags))
+	cachep = slab_pre_alloc_hook(cachep, flags);
+	if (unlikely(!cachep))
 		return NULL;
 
-	cachep = memcg_kmem_get_cache(cachep, flags);
