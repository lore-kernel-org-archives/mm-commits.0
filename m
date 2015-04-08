From: akpm@linux-foundation.org
Subject: + slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
 added to -mm tree
Date: Wed, 08 Apr 2015 15:53:13 -0700
Message-ID: <5525b159.BpuUD6FQt89EaGh/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbbDHWxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 18:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub bulk alloc: extract objects from the per cpu slab
has been added to the -mm tree.  Its filename is
     slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch

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
Subject: slub bulk alloc: extract objects from the per cpu slab

First piece: acceleration of retrieval of per cpu objects

If we are allocating lots of objects then it is advantageous to disable
interrupts and avoid the this_cpu_cmpxchg() operation to get these objects
faster.  Note that we cannot do the fast operation if debugging is
enabled.  Note also that the requirement of having interrupts disabled
avoids having to do processor flag operations.

Allocate as many objects as possible in the fast way and then fall back to
the generic implementation for the rest of the objects.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
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

mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
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
mm-sanitize-page-mapping-for-tail-pages-v2.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
linux-next.patch

