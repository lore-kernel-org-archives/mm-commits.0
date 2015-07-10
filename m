From: akpm@linux-foundation.org
Subject: + mm-slub-move-slab-initialization-into-irq-enabled-region.patch
 added to -mm tree
Date: Fri, 10 Jul 2015 14:40:06 -0700
Message-ID: <55a03bb6.rflQsxwcemPorldZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbbGJVkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, bigeasy@linutronix.de, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, peterz@infradead.org, rientjes@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: move slab initialization into irq enabled region
has been added to the -mm tree.  Its filename is
     mm-slub-move-slab-initialization-into-irq-enabled-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-move-slab-initialization-into-irq-enabled-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-move-slab-initialization-into-irq-enabled-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/slub: move slab initialization into irq enabled region

Initializing a new slab can introduce rather large latencies because most
of the initialization runs always with interrupts disabled.

There is no point in doing so.  The newly allocated slab is not visible
yet, so there is no reason to protect it against concurrent alloc/free.

Move the expensive parts of the initialization into allocate_slab(), so
for all allocations with GFP_WAIT set, interrupts are enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   89 ++++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff -puN mm/slub.c~mm-slub-move-slab-initialization-into-irq-enabled-region mm/slub.c
--- a/mm/slub.c~mm-slub-move-slab-initialization-into-irq-enabled-region
+++ a/mm/slub.c
@@ -1306,6 +1306,17 @@ static inline void slab_free_hook(struct
 	kasan_slab_free(s, x);
 }
 
+static void setup_object(struct kmem_cache *s, struct page *page,
+				void *object)
+{
+	setup_object_debug(s, page, object);
+	if (unlikely(s->ctor)) {
+		kasan_unpoison_object_data(s, object);
+		s->ctor(object);
+		kasan_poison_object_data(s, object);
+	}
+}
+
 /*
  * Slab allocation and freeing
  */
@@ -1336,6 +1347,8 @@ static struct page *allocate_slab(struct
 	struct page *page;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
+	void *start, *p;
+	int idx, order;
 
 	flags &= gfp_allowed_mask;
 
@@ -1359,13 +1372,13 @@ static struct page *allocate_slab(struct
 		 * Try a lower order alloc if possible
 		 */
 		page = alloc_slab_page(s, alloc_gfp, node, oo);
-
-		if (page)
-			stat(s, ORDER_FALLBACK);
+		if (unlikely(!page))
+			goto out;
+		stat(s, ORDER_FALLBACK);
 	}
 
-	if (kmemcheck_enabled && page
-		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
+	if (kmemcheck_enabled &&
+	    !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
 
 		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
@@ -1380,51 +1393,9 @@ static struct page *allocate_slab(struct
 			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
-	if (flags & __GFP_WAIT)
-		local_irq_disable();
-	if (!page)
-		return NULL;
-
 	page->objects = oo_objects(oo);
-	mod_zone_page_state(page_zone(page),
-		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		1 << oo_order(oo));
-
-	return page;
-}
-
-static void setup_object(struct kmem_cache *s, struct page *page,
-				void *object)
-{
-	setup_object_debug(s, page, object);
-	if (unlikely(s->ctor)) {
-		kasan_unpoison_object_data(s, object);
-		s->ctor(object);
-		kasan_poison_object_data(s, object);
-	}
-}
-
-static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
-{
-	struct page *page;
-	void *start;
-	void *p;
-	int order;
-	int idx;
-
-	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
-		BUG();
-	}
-
-	page = allocate_slab(s,
-		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
-	if (!page)
-		goto out;
 
 	order = compound_order(page);
-	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab_cache = s;
 	__SetPageSlab(page);
 	if (page->pfmemalloc)
@@ -1448,10 +1419,34 @@ static struct page *new_slab(struct kmem
 	page->freelist = start;
 	page->inuse = page->objects;
 	page->frozen = 1;
+
 out:
+	if (flags & __GFP_WAIT)
+		local_irq_disable();
+	if (!page)
+		return NULL;
+
+	mod_zone_page_state(page_zone(page),
+		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+		1 << oo_order(oo));
+
+	inc_slabs_node(s, page_to_nid(page), page->objects);
+
 	return page;
 }
 
+static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+{
+	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
+		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		BUG();
+	}
+
+	return allocate_slab(s,
+		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
+}
+
 static void __free_slab(struct kmem_cache *s, struct page *page)
 {
 	int order = compound_order(page);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
mm-slub-move-slab-initialization-into-irq-enabled-region.patch
mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout.patch
linux-next.patch

