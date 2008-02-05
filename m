From: akpm@linux-foundation.org
Subject: - slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:46 -0800
Message-ID: <200802050245.m152jRj3031185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYBECpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: do our own locking via slab_lock and slab_unlock
has been removed from the -mm tree.  Its filename was
     slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: do our own locking via slab_lock and slab_unlock
From: Christoph Lameter <clameter@sgi.com>

Too many troubles with the bitlocks and we really do not need to do any
bitops.  Bitops do not effectively retrieve the old value which we want.  So
use a cmpxchg instead on the arches that allow it.

Instead of modifying the page->flags with fake atomic operations we pass the
page state as a parameter to functions.  No function uses the slab state if
the page lock is held.  Function must wait until the lock is cleared.  Thus we
can defer the update of page->flags until slab processing is complete.  The
"unlock" operation is then simply updating page->flags.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  311 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 183 insertions(+), 128 deletions(-)

diff -puN mm/slub.c~slub-do-our-own-locking-via-slab_lock-and-slab_unlock mm/slub.c
--- a/mm/slub.c~slub-do-our-own-locking-via-slab_lock-and-slab_unlock
+++ a/mm/slub.c
@@ -101,6 +101,7 @@
  */
 
 #define FROZEN (1 << PG_active)
+#define LOCKED (1 << PG_locked)
 
 #ifdef CONFIG_SLUB_DEBUG
 #define SLABDEBUG (1 << PG_error)
@@ -108,36 +109,6 @@
 #define SLABDEBUG 0
 #endif
 
-static inline int SlabFrozen(struct page *page)
-{
-	return page->flags & FROZEN;
-}
-
-static inline void SetSlabFrozen(struct page *page)
-{
-	page->flags |= FROZEN;
-}
-
-static inline void ClearSlabFrozen(struct page *page)
-{
-	page->flags &= ~FROZEN;
-}
-
-static inline int SlabDebug(struct page *page)
-{
-	return page->flags & SLABDEBUG;
-}
-
-static inline void SetSlabDebug(struct page *page)
-{
-	page->flags |= SLABDEBUG;
-}
-
-static inline void ClearSlabDebug(struct page *page)
-{
-	page->flags &= ~SLABDEBUG;
-}
-
 /*
  * Issues still to be resolved:
  *
@@ -818,11 +789,12 @@ static void trace(struct kmem_cache *s, 
 /*
  * Tracking of fully allocated slabs for debugging purposes.
  */
-static void add_full(struct kmem_cache *s, struct page *page)
+static void add_full(struct kmem_cache *s, struct page *page,
+		unsigned long state)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	if (!SlabDebug(page) || !(s->flags & SLAB_STORE_USER))
+	if (!(state & SLABDEBUG) || !(s->flags & SLAB_STORE_USER))
 		return;
 	spin_lock(&n->list_lock);
 	list_add(&page->lru, &n->full);
@@ -894,7 +866,7 @@ bad:
 }
 
 static noinline int free_debug_processing(struct kmem_cache *s,
-			struct page *page, void *object, void *addr)
+	struct page *page, void *object, void *addr, unsigned long state)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -929,7 +901,7 @@ static noinline int free_debug_processin
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!SlabFrozen(page) && page->freelist == page->end)
+	if (!(state & FROZEN) && page->freelist == page->end)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1040,13 +1012,15 @@ static inline int alloc_debug_processing
 	struct page *page, void *object, void *addr) { return 0; }
 
 static inline int free_debug_processing(struct kmem_cache *s,
-	struct page *page, void *object, void *addr) { return 0; }
+	struct page *page, void *object, void *addr, unsigned long state)
+						{ return 0; }
 
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 			{ return 1; }
 static inline int check_object(struct kmem_cache *s, struct page *page,
 			void *object, int active) { return 1; }
-static inline void add_full(struct kmem_cache *s, struct page *page) {}
+static inline void add_full(struct kmem_cache *s, struct page *page,
+					unsigned long state) {}
 static inline unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
 	void (*ctor)(struct kmem_cache *, void *))
@@ -1104,6 +1078,7 @@ static noinline struct page *new_slab(st
 	void *start;
 	void *last;
 	void *p;
+	unsigned long state;
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
@@ -1116,11 +1091,12 @@ static noinline struct page *new_slab(st
 	if (n)
 		atomic_long_inc(&n->nr_slabs);
 	page->slab = s;
-	page->flags |= 1 << PG_slab;
+	state = 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
-		SetSlabDebug(page);
+		state |= SLABDEBUG;
 
+	page->flags |= state;
 	start = page_address(page);
 	page->end = start + 1;
 
@@ -1146,13 +1122,13 @@ static void __free_slab(struct kmem_cach
 {
 	int pages = 1 << s->order;
 
-	if (unlikely(SlabDebug(page))) {
+	if (unlikely(page->flags & SLABDEBUG)) {
 		void *p;
 
 		slab_pad_check(s, page);
 		for_each_object(p, s, slab_address(page))
 			check_object(s, page, p, 0);
-		ClearSlabDebug(page);
+		page->flags &= ~SLABDEBUG;
 	}
 
 	mod_zone_page_state(page_zone(page),
@@ -1195,26 +1171,72 @@ static void discard_slab(struct kmem_cac
 	free_slab(s, page);
 }
 
+#ifdef __HAVE_ARCH_CMPXCHG
 /*
  * Per slab locking using the pagelock
  */
-static __always_inline void slab_lock(struct page *page)
+static __always_inline void slab_unlock(struct page *page,
+					unsigned long state)
 {
-	bit_spin_lock(PG_locked, &page->flags);
+	smp_wmb();
+	page->flags = state;
+	preempt_enable();
+	 __release(bitlock);
 }
 
-static __always_inline void slab_unlock(struct page *page)
+static __always_inline unsigned long slab_trylock(struct page *page)
 {
+	unsigned long state;
+
+	preempt_disable();
+	state = page->flags & ~LOCKED;
+#ifdef CONFIG_SMP
+	if (cmpxchg(&page->flags, state, state | LOCKED) != state) {
+		 preempt_enable();
+		 return 0;
+	}
+#endif
+	__acquire(bitlock);
+	return state;
+}
+
+static __always_inline unsigned long slab_lock(struct page *page)
+{
+	unsigned long state;
+
+	preempt_disable();
+#ifdef CONFIG_SMP
+	do {
+		state = page->flags & ~LOCKED;
+	} while (cmpxchg(&page->flags, state, state | LOCKED) != state);
+#else
+	state = page->flags & ~LOCKED;
+#endif
+	__acquire(bitlock);
+	return state;
+}
+
+#else
+static __always_inline void slab_unlock(struct page *page,
+					unsigned long state)
+{
+	page->flags = state;
 	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
-static __always_inline int slab_trylock(struct page *page)
+static __always_inline unsigned long slab_trylock(struct page *page)
 {
-	int rc = 1;
+	if (!bit_spin_trylock(PG_locked, &page->flags))
+		return 0;
+	return page->flags;
+}
 
-	rc = bit_spin_trylock(PG_locked, &page->flags);
-	return rc;
+static __always_inline unsigned long slab_lock(struct page *page)
+{
+	bit_spin_lock(PG_locked, &page->flags);
+	return page->flags;
 }
+#endif
 
 /*
  * Management of partially allocated slabs
@@ -1249,13 +1271,17 @@ static noinline void remove_partial(stru
  *
  * Must hold list_lock.
  */
-static inline int lock_and_freeze_slab(struct kmem_cache_node *n, struct page *page)
+static inline unsigned long lock_and_freeze_slab(struct kmem_cache_node *n,
+		struct kmem_cache_cpu *c, struct page *page)
 {
-	if (slab_trylock(page)) {
+	unsigned long state;
+
+	state = slab_trylock(page);
+	if (state) {
 		list_del(&page->lru);
 		n->nr_partial--;
-		SetSlabFrozen(page);
-		return 1;
+		c->page = page;
+		return state | FROZEN;
 	}
 	return 0;
 }
@@ -1263,9 +1289,11 @@ static inline int lock_and_freeze_slab(s
 /*
  * Try to allocate a partial slab from a specific node.
  */
-static struct page *get_partial_node(struct kmem_cache_node *n)
+static unsigned long get_partial_node(struct kmem_cache_node *n,
+		struct kmem_cache_cpu *c)
 {
 	struct page *page;
+	unsigned long state;
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
@@ -1274,27 +1302,30 @@ static struct page *get_partial_node(str
 	 * will return NULL.
 	 */
 	if (!n || !n->nr_partial)
-		return NULL;
+		return 0;
 
 	spin_lock(&n->list_lock);
-	list_for_each_entry(page, &n->partial, lru)
-		if (lock_and_freeze_slab(n, page))
+	list_for_each_entry(page, &n->partial, lru) {
+		state = lock_and_freeze_slab(n, c, page);
+		if (state)
 			goto out;
-	page = NULL;
+	}
+	state = 0;
 out:
 	spin_unlock(&n->list_lock);
-	return page;
+	return state;
 }
 
 /*
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
-static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
+static unsigned long get_any_partial(struct kmem_cache *s,
+		struct kmem_cache_cpu *c, gfp_t flags)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
 	struct zone **z;
-	struct page *page;
+	unsigned long state;
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -1316,7 +1347,7 @@ static struct page *get_any_partial(stru
 	 */
 	if (!s->remote_node_defrag_ratio ||
 			get_cycles() % 1024 > s->remote_node_defrag_ratio)
-		return NULL;
+		return 0;
 
 	zonelist = &NODE_DATA(slab_node(current->mempolicy))
 					->node_zonelists[gfp_zone(flags)];
@@ -1327,28 +1358,30 @@ static struct page *get_any_partial(stru
 
 		if (n && cpuset_zone_allowed_hardwall(*z, flags) &&
 				n->nr_partial > MIN_PARTIAL) {
-			page = get_partial_node(n);
-			if (page)
-				return page;
+			state = get_partial_node(n, c);
+			if (state)
+				return state;
 		}
 	}
 #endif
-	return NULL;
+	return 0;
 }
 
 /*
- * Get a partial page, lock it and return it.
+ * Get a partial page, lock it and make it the current cpu slab.
  */
-static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
+static noinline unsigned long get_partial(struct kmem_cache *s,
+	struct kmem_cache_cpu *c, gfp_t flags, int node)
 {
-	struct page *page;
+	unsigned long state;
 	int searchnode = (node == -1) ? numa_node_id() : node;
 
-	page = get_partial_node(get_node(s, searchnode));
-	if (page || (flags & __GFP_THISNODE))
-		return page;
-
-	return get_any_partial(s, flags);
+	state = get_partial_node(get_node(s, searchnode), c);
+	if (!state && !(flags & __GFP_THISNODE))
+		state = get_any_partial(s, c, flags);
+	if (!state)
+		return 0;
+	return state;
 }
 
 /*
@@ -1358,16 +1391,17 @@ static struct page *get_partial(struct k
  *
  * On exit the slab lock will have been dropped.
  */
-static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
+static void unfreeze_slab(struct kmem_cache *s, struct page *page,
+				int tail, unsigned long state)
 {
-	ClearSlabFrozen(page);
+	state &= ~FROZEN;
 	if (page->inuse) {
 
 		if (page->freelist != page->end)
 			add_partial(s, page, tail);
 		else
-			add_full(s, page);
-		slab_unlock(page);
+			add_full(s, page, state);
+		slab_unlock(page, state);
 
 	} else {
 		if (get_node(s, page_to_nid(page))->nr_partial
@@ -1381,9 +1415,9 @@ static void unfreeze_slab(struct kmem_ca
 			 * reclaim empty slabs from the partial list.
 			 */
 			add_partial(s, page, 1);
-			slab_unlock(page);
+			slab_unlock(page, state);
 		} else {
-			slab_unlock(page);
+			slab_unlock(page, state);
 			discard_slab(s, page);
 		}
 	}
@@ -1392,7 +1426,8 @@ static void unfreeze_slab(struct kmem_ca
 /*
  * Remove the cpu slab
  */
-static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
+static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
+				unsigned long state)
 {
 	struct page *page = c->page;
 	int tail = 1;
@@ -1420,13 +1455,15 @@ static void deactivate_slab(struct kmem_
 		page->inuse--;
 	}
 	c->page = NULL;
-	unfreeze_slab(s, page, tail);
+	unfreeze_slab(s, page, tail, state);
 }
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
-	slab_lock(c->page);
-	deactivate_slab(s, c);
+	unsigned long state;
+
+	state = slab_lock(c->page);
+	deactivate_slab(s, c, state);
 }
 
 /*
@@ -1474,6 +1511,31 @@ static inline int node_match(struct kmem
 	return 1;
 }
 
+/* Allocate a new slab and make it the current cpu slab */
+static noinline unsigned long get_new_slab(struct kmem_cache *s,
+	struct kmem_cache_cpu **pc, gfp_t gfpflags, int node)
+{
+	struct kmem_cache_cpu *c = *pc;
+	struct page *page;
+
+	if (gfpflags & __GFP_WAIT)
+		local_irq_enable();
+
+	page = new_slab(s, gfpflags, node);
+
+	if (gfpflags & __GFP_WAIT)
+		local_irq_disable();
+
+	if (!page)
+		return 0;
+
+	*pc = c = get_cpu_slab(s, smp_processor_id());
+	if (c->page)
+		flush_slab(s, c);
+	c->page = page;
+	return slab_lock(page) | FROZEN;
+}
+
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -1495,7 +1557,7 @@ static void *__slab_alloc(struct kmem_ca
 		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
 {
 	void **object;
-	struct page *new;
+	unsigned long state;
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	unsigned long flags;
 
@@ -1505,14 +1567,14 @@ static void *__slab_alloc(struct kmem_ca
 	if (!c->page)
 		goto new_slab;
 
-	slab_lock(c->page);
+	state = slab_lock(c->page);
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
 load_freelist:
 	object = c->page->freelist;
 	if (unlikely(object == c->page->end))
 		goto another_slab;
-	if (unlikely(SlabDebug(c->page)))
+	if (unlikely(state & SLABDEBUG))
 		goto debug;
 
 	object = c->page->freelist;
@@ -1521,7 +1583,7 @@ load_freelist:
 	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
 unlock_out:
-	slab_unlock(c->page);
+	slab_unlock(c->page, state);
 out:
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	preempt_disable();
@@ -1530,32 +1592,17 @@ out:
 	return object;
 
 another_slab:
-	deactivate_slab(s, c);
+	deactivate_slab(s, c, state);
 
 new_slab:
-	new = get_partial(s, gfpflags, node);
-	if (new) {
-		c->page = new;
+	state = get_partial(s, c, gfpflags, node);
+	if (state)
 		goto load_freelist;
-	}
 
-	if (gfpflags & __GFP_WAIT)
-		local_irq_enable();
-
-	new = new_slab(s, gfpflags, node);
-
-	if (gfpflags & __GFP_WAIT)
-		local_irq_disable();
-
-	if (new) {
-		c = get_cpu_slab(s, smp_processor_id());
-		if (c->page)
-			flush_slab(s, c);
-		slab_lock(new);
-		SetSlabFrozen(new);
-		c->page = new;
+	state = get_new_slab(s, &c, gfpflags, node);
+	if (state)
 		goto load_freelist;
-	}
+
 	object = NULL;
 	goto out;
 debug:
@@ -1652,22 +1699,23 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long state;
 
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	unsigned long flags;
 
 	local_irq_save(flags);
 #endif
-	slab_lock(page);
+	state = slab_lock(page);
 
-	if (unlikely(SlabDebug(page)))
+	if (unlikely(state & SLABDEBUG))
 		goto debug;
 checks_ok:
 	prior = object[offset] = page->freelist;
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(SlabFrozen(page)))
+	if (unlikely(state & FROZEN))
 		goto out_unlock;
 
 	if (unlikely(!page->inuse))
@@ -1682,7 +1730,7 @@ checks_ok:
 		add_partial(s, page, 1);
 
 out_unlock:
-	slab_unlock(page);
+	slab_unlock(page, state);
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	local_irq_restore(flags);
 #endif
@@ -1695,7 +1743,7 @@ slab_empty:
 		 */
 		remove_partial(s, page);
 
-	slab_unlock(page);
+	slab_unlock(page, state);
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	local_irq_restore(flags);
 #endif
@@ -1703,7 +1751,7 @@ slab_empty:
 	return;
 
 debug:
-	if (!free_debug_processing(s, page, x, addr))
+	if (!free_debug_processing(s, page, x, addr, state))
 		goto out_unlock;
 	goto checks_ok;
 }
@@ -2748,6 +2796,7 @@ int kmem_cache_shrink(struct kmem_cache 
 	struct list_head *slabs_by_inuse =
 		kmalloc(sizeof(struct list_head) * s->objects, GFP_KERNEL);
 	unsigned long flags;
+	unsigned long state;
 
 	if (!slabs_by_inuse)
 		return -ENOMEM;
@@ -2771,20 +2820,23 @@ int kmem_cache_shrink(struct kmem_cache 
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			if (!page->inuse && slab_trylock(page)) {
-				/*
-				 * Must hold slab lock here because slab_free
-				 * may have freed the last object and be
-				 * waiting to release the slab.
-				 */
-				list_del(&page->lru);
-				n->nr_partial--;
-				slab_unlock(page);
-				discard_slab(s, page);
-			} else {
+			if (page->inuse) {
 				list_move(&page->lru,
 				slabs_by_inuse + page->inuse);
+				continue;
 			}
+			state = slab_trylock(page);
+			if (!state)
+				continue;
+			/*
+			 * Must hold slab lock here because slab_free may have
+			 * freed the last object and be waiting to release the
+			 * slab.
+			 */
+			list_del(&page->lru);
+			n->nr_partial--;
+			slab_unlock(page, state);
+			discard_slab(s, page);
 		}
 
 		/*
@@ -3230,19 +3282,22 @@ static int validate_slab(struct kmem_cac
 static void validate_slab_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
 {
-	if (slab_trylock(page)) {
+	unsigned long state;
+
+	state = slab_trylock(page);
+	if (state) {
 		validate_slab(s, page, map);
-		slab_unlock(page);
+		slab_unlock(page, state);
 	} else
 		printk(KERN_INFO "SLUB %s: Skipped busy slab 0x%p\n",
 			s->name, page);
 
 	if (s->flags & DEBUG_DEFAULT_FLAGS) {
-		if (!SlabDebug(page))
+		if (!(state & SLABDEBUG))
 			printk(KERN_ERR "SLUB %s: SlabDebug not set "
 				"on slab 0x%p\n", s->name, page);
 	} else {
-		if (SlabDebug(page))
+		if (state & SLABDEBUG)
 			printk(KERN_ERR "SLUB %s: SlabDebug set on "
 				"slab 0x%p\n", s->name, page);
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-newsetup.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
