From: akpm@linux-foundation.org
Subject: [merged] slub-avoid-irqoff-on-in-bulk-allocation.patch removed
 from -mm tree
Date: Mon, 23 Nov 2015 12:15:30 -0800
Message-ID: <565373e2.OHlq4rnswHc3kmKe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbbKWUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, alexander.h.duyck@redhat.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: avoid irqoff/on in bulk allocation
has been removed from the -mm tree.  Its filename was
     slub-avoid-irqoff-on-in-bulk-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: avoid irqoff/on in bulk allocation

Use the new function that can do allocation while interrupts are disabled.
Avoids irq on/off sequences.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~slub-avoid-irqoff-on-in-bulk-allocation mm/slub.c
--- a/mm/slub.c~slub-avoid-irqoff-on-in-bulk-allocation
+++ a/mm/slub.c
@@ -2818,30 +2818,23 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 		void *object = c->freelist;
 
 		if (unlikely(!object)) {
-			local_irq_enable();
 			/*
 			 * Invoking slow path likely have side-effect
 			 * of re-populating per CPU c->freelist
 			 */
-			p[i] = __slab_alloc(s, flags, NUMA_NO_NODE,
+			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE,
 					    _RET_IP_, c);
-			if (unlikely(!p[i])) {
-				__kmem_cache_free_bulk(s, i, p);
-				return false;
-			}
-			local_irq_disable();
+			if (unlikely(!p[i]))
+				goto error;
+
 			c = this_cpu_ptr(s->cpu_slab);
 			continue; /* goto for-loop */
 		}
 
 		/* kmem_cache debug support */
 		s = slab_pre_alloc_hook(s, flags);
-		if (unlikely(!s)) {
-			__kmem_cache_free_bulk(s, i, p);
-			c->tid = next_tid(c->tid);
-			local_irq_enable();
-			return false;
-		}
+		if (unlikely(!s))
+			goto error;
 
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
@@ -2861,6 +2854,11 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 	}
 
 	return true;
+
+error:
+	__kmem_cache_free_bulk(s, i, p);
+	local_irq_enable();
+	return false;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
_

Patches currently in -mm which might be from cl@linux.com are


