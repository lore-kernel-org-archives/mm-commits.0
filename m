From: akpm@linux-foundation.org
Subject: + slub-avoid-irqoff-on-in-bulk-allocation.patch added to -mm tree
Date: Wed, 16 Sep 2015 15:13:20 -0700
Message-ID: <55f9e980.EQNOgZb5ZByulDE9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbIPWNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Sep 2015 18:13:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: avoid irqoff/on in bulk allocation
has been added to the -mm tree.  Its filename is
     slub-avoid-irqoff-on-in-bulk-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-avoid-irqoff-on-in-bulk-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-avoid-irqoff-on-in-bulk-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~slub-avoid-irqoff-on-in-bulk-allocation mm/slub.c
--- a/mm/slub.c~slub-avoid-irqoff-on-in-bulk-allocation
+++ a/mm/slub.c
@@ -2807,30 +2807,23 @@ bool kmem_cache_alloc_bulk(struct kmem_c
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
@@ -2850,6 +2843,11 @@ bool kmem_cache_alloc_bulk(struct kmem_c
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

slub-avoid-irqoff-on-in-bulk-allocation.patch

