From: akpm@linux-foundation.org
Subject: [merged] slab-implement-bulk-alloc-in-slab-allocator.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:50 -0700
Message-ID: <56e9b9ce.pVL1G28JIAeNobe7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbcCPTxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: implement bulk alloc in SLAB allocator
has been removed from the -mm tree.  Its filename was
     slab-implement-bulk-alloc-in-slab-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: implement bulk alloc in SLAB allocator

This patch implements the alloc side of bulk API for the SLAB allocator.

Further optimization are still possible by changing the call to
__do_cache_alloc() into something that can return multiple objects.  This
optimization is left for later, given end results already show in the area
of 80% speedup.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-implement-bulk-alloc-in-slab-allocator mm/slab.c
--- a/mm/slab.c~slab-implement-bulk-alloc-in-slab-allocator
+++ a/mm/slab.c
@@ -3392,9 +3392,42 @@ void kmem_cache_free_bulk(struct kmem_ca
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
 int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
-								void **p)
+			  void **p)
 {
-	return __kmem_cache_alloc_bulk(s, flags, size, p);
+	size_t i;
+
+	s = slab_pre_alloc_hook(s, flags);
+	if (!s)
+		return 0;
+
+	cache_alloc_debugcheck_before(s, flags);
+
+	local_irq_disable();
+	for (i = 0; i < size; i++) {
+		void *objp = __do_cache_alloc(s, flags);
+
+		/* this call could be done outside IRQ disabled section */
+		objp = cache_alloc_debugcheck_after(s, flags, objp, _RET_IP_);
+
+		if (unlikely(!objp))
+			goto error;
+		p[i] = objp;
+	}
+	local_irq_enable();
+
+	/* Clear memory outside IRQ disabled section */
+	if (unlikely(flags & __GFP_ZERO))
+		for (i = 0; i < size; i++)
+			memset(p[i], 0, s->object_size);
+
+	slab_post_alloc_hook(s, flags, size, p);
+	/* FIXME: Trace call missing. Christoph would like a bulk variant */
+	return size;
+error:
+	local_irq_enable();
+	slab_post_alloc_hook(s, flags, i, p);
+	__kmem_cache_free_bulk(s, i, p);
+	return 0;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
_

Patches currently in -mm which might be from brouer@redhat.com are


