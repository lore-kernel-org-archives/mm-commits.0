From: akpm@linux-foundation.org
Subject: - slab-remove-colouroff-from-struct-slab.patch removed from -mm tree
Date: Thu, 01 Mar 2007 23:14:55 -0800
Message-ID: <200703020714.l227EtuA003001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbXCBHPO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 02:15:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, manfred@colorfullife.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove colouroff from struct slab
has been removed from the -mm tree.  Its filename was
     slab-remove-colouroff-from-struct-slab.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: slab: remove colouroff from struct slab
From: Pekka Enberg <penberg@cs.helsinki.fi>

As the color offset is always within the first page of the slab,
virt_to_page() works just fine without slabp->colouroff.

Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~slab-remove-colouroff-from-struct-slab mm/slab.c
--- a/mm/slab.c~slab-remove-colouroff-from-struct-slab
+++ a/mm/slab.c
@@ -219,7 +219,6 @@ typedef unsigned int kmem_bufctl_t;
  */
 struct slab {
 	struct list_head list;
-	unsigned long colouroff;
 	void *s_mem;		/* including colour offset */
 	unsigned int inuse;	/* num of objs active in slab */
 	kmem_bufctl_t free;
@@ -1908,18 +1907,16 @@ static void slab_destroy_objs(struct kme
  */
 static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 {
-	void *addr = slabp->s_mem - slabp->colouroff;
-
 	slab_destroy_objs(cachep, slabp);
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slab_rcu *slab_rcu;
 
 		slab_rcu = (struct slab_rcu *)slabp;
 		slab_rcu->cachep = cachep;
-		slab_rcu->addr = addr;
+		slab_rcu->addr = slabp->s_mem;
 		call_rcu(&slab_rcu->head, kmem_rcu_free);
 	} else {
-		kmem_freepages(cachep, addr);
+		kmem_freepages(cachep, slabp->s_mem);
 		if (OFF_SLAB(cachep))
 			kmem_cache_free(cachep->slabp_cache, slabp);
 	}
@@ -2585,7 +2582,6 @@ static struct slab *alloc_slabmgmt(struc
 		colour_off += cachep->slab_size;
 	}
 	slabp->inuse = 0;
-	slabp->colouroff = colour_off;
 	slabp->s_mem = objp + colour_off;
 	slabp->nodeid = nodeid;
 	return slabp;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-remove-colouroff-from-struct-slab.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch
