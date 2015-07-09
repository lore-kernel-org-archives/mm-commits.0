From: akpm@linux-foundation.org
Subject: [to-be-updated]
 slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch removed from
 -mm tree
Date: Thu, 09 Jul 2015 11:56:25 -0700
Message-ID: <559ec3d9.WlNnbAOKAoat0k3b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbGIS40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 14:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub bulk alloc: extract objects from the per cpu slab
has been removed from the -mm tree.  Its filename was
     slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub bulk alloc: extract objects from the per cpu slab

First piece: acceleration of retrieval of per cpu objects

If we are allocating lots of objects then it is advantageous to disable
interrupts and avoid the this_cpu_cmpxchg() operation to get these objects
faster.

Note that we cannot do the fast operation if debugging is enabled, because
we would have to add extra code to do all the debugging checks.  And it
would not be fast anyway.

Note also that the requirement of having interrupts disabled
avoids having to do processor flag operations.

Allocate as many objects as possible in the fast way and then fall back to
the generic implementation for the rest of the objects.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-bulk-alloc-extract-objects-from-the-per-cpu-slab mm/slub.c
--- a/mm/slub.c~slub-bulk-alloc-extract-objects-from-the-per-cpu-slab
+++ a/mm/slub.c
@@ -2759,7 +2759,32 @@ EXPORT_SYMBOL(kmem_cache_free_bulk);
 bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 								void **p)
 {
-	return kmem_cache_alloc_bulk(s, flags, size, p);
+	if (!kmem_cache_debug(s)) {
+		struct kmem_cache_cpu *c;
+
+		/* Drain objects in the per cpu slab */
+		local_irq_disable();
+		c = this_cpu_ptr(s->cpu_slab);
+
+		while (size) {
+			void *object = c->freelist;
+
+			if (!object)
+				break;
+
+			c->freelist = get_freepointer(s, object);
+			*p++ = object;
+			size--;
+
+			if (unlikely(flags & __GFP_ZERO))
+				memset(object, 0, s->object_size);
+		}
+		c->tid = next_tid(c->tid);
+
+		local_irq_enable();
+	}
+
+	return __kmem_cache_alloc_bulk(s, flags, size, p);
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
_

Patches currently in -mm which might be from cl@linux.com are

slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

