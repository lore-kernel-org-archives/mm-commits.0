From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch
 added to -mm tree
Date: Mon, 06 Jul 2020 16:53:47 -0700
Message-ID: <20200706235347.MLi9EXuBP%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgGFXxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:53:48 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, lonuxli.64@gmail.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, willy@infradead.org


The patch titled
     Subject: mm, slab: check GFP_SLAB_BUG_MASK before alloc_pages in kmalloc_order
has been added to the -mm tree.  Its filename is
     mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Long Li <lonuxli.64@gmail.com>
Subject: mm, slab: check GFP_SLAB_BUG_MASK before alloc_pages in kmalloc_order

kmalloc cannot allocate memory from HIGHMEM.  Allocating large amounts of
memory currently bypasses the check and will simply leak the memory when
page_address() returns NULL.  To fix this, factor the GFP_SLAB_BUG_MASK
check out of slab & slub, and call it from kmalloc_order() as well.  In
order to make the code clear, the warning message is put in one place.

Link: http://lkml.kernel.org/r/20200704035027.GA62481@lilong
Signed-off-by: Long Li <lonuxli.64@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   10 +++-------
 mm/slab.h        |    1 +
 mm/slab_common.c |   17 +++++++++++++++++
 mm/slub.c        |    9 ++-------
 4 files changed, 23 insertions(+), 14 deletions(-)

--- a/mm/slab.c~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slab.c
@@ -2589,13 +2589,9 @@ static struct page *cache_grow_begin(str
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		flags &= ~GFP_SLAB_BUG_MASK;
-		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-				invalid_mask, &invalid_mask, flags, &flags);
-		dump_stack();
-	}
+	if (unlikely(flags & GFP_SLAB_BUG_MASK))
+		flags = kmalloc_fix_flags(flags);
+
 	WARN_ON_ONCE(cachep->ctor && (flags & __GFP_ZERO));
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
--- a/mm/slab_common.c~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slab_common.c
@@ -26,6 +26,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
+#include "internal.h"
+
 #include "slab.h"
 
 enum slab_state slab_state;
@@ -1311,6 +1313,18 @@ void __init create_kmalloc_caches(slab_f
 }
 #endif /* !CONFIG_SLOB */
 
+gfp_t kmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+
+	flags &= ~GFP_SLAB_BUG_MASK;
+	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+			invalid_mask, &invalid_mask, flags, &flags);
+	dump_stack();
+
+	return flags;
+}
+
 /*
  * To avoid unnecessary overhead, we pass through large allocation requests
  * directly to the page allocator. We use __GFP_COMP, because we will need to
@@ -1321,6 +1335,9 @@ void *kmalloc_order(size_t size, gfp_t f
 	void *ret = NULL;
 	struct page *page;
 
+	if (unlikely(flags & GFP_SLAB_BUG_MASK))
+		flags = kmalloc_fix_flags(flags);
+
 	flags |= __GFP_COMP;
 	page = alloc_pages(flags, order);
 	if (likely(page)) {
--- a/mm/slab.h~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slab.h
@@ -152,6 +152,7 @@ void create_kmalloc_caches(slab_flags_t)
 struct kmem_cache *kmalloc_slab(size_t, gfp_t);
 #endif
 
+gfp_t kmalloc_fix_flags(gfp_t flags);
 
 /* Functions provided by the slab allocators */
 int __kmem_cache_create(struct kmem_cache *, slab_flags_t flags);
--- a/mm/slub.c~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slub.c
@@ -1745,13 +1745,8 @@ out:
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
-	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		flags &= ~GFP_SLAB_BUG_MASK;
-		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-				invalid_mask, &invalid_mask, flags, &flags);
-		dump_stack();
-	}
+	if (unlikely(flags & GFP_SLAB_BUG_MASK))
+		flags = kmalloc_fix_flags(flags);
 
 	return allocate_slab(s,
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
_

Patches currently in -mm which might be from lonuxli.64@gmail.com are

mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch
