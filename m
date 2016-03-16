From: akpm@linux-foundation.org
Subject: [merged]
 slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:53 -0700
Message-ID: <56e9b9d1.LyLqIwvpGtklxH5E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbcCPTxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: avoid running debug SLAB code with IRQs disabled for alloc_bulk
has been removed from the -mm tree.  Its filename was
     slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: avoid running debug SLAB code with IRQs disabled for alloc_bulk

Move the call to cache_alloc_debugcheck_after() outside the IRQ disabled
section in kmem_cache_alloc_bulk().

When CONFIG_DEBUG_SLAB is disabled the compiler should remove this code.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk mm/slab.c
--- a/mm/slab.c~slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk
+++ a/mm/slab.c
@@ -3391,6 +3391,16 @@ void kmem_cache_free_bulk(struct kmem_ca
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
+static __always_inline void
+cache_alloc_debugcheck_after_bulk(struct kmem_cache *s, gfp_t flags,
+				  size_t size, void **p, unsigned long caller)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++)
+		p[i] = cache_alloc_debugcheck_after(s, flags, p[i], caller);
+}
+
 int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 			  void **p)
 {
@@ -3406,15 +3416,14 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	for (i = 0; i < size; i++) {
 		void *objp = __do_cache_alloc(s, flags);
 
-		/* this call could be done outside IRQ disabled section */
-		objp = cache_alloc_debugcheck_after(s, flags, objp, _RET_IP_);
