From: akpm@linux-foundation.org
Subject: [merged] slub-support-for-bulk-free-with-slub-freelists.patch
 removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:37 -0800
Message-ID: <565373e9.VvwhMKqHWiHOjExV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbbKWUPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, alexander.h.duyck@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: support for bulk free with SLUB freelists
has been removed from the -mm tree.  Its filename was
     slub-support-for-bulk-free-with-slub-freelists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slub: support for bulk free with SLUB freelists

Make it possible to free a freelist with several objects by adjusting API
of slab_free() and __slab_free() to have head, tail and an objects counter
(cnt).

Tail being NULL indicate single object free of head object.  This allow
compiler inline constant propagation in slab_free() and
slab_free_freelist_hook() to avoid adding any overhead in case of single
object free.

This allows a freelist with several objects (all within the same
slab-page) to be free'ed using a single locked cmpxchg_double in
__slab_free() and with an unlocked cmpxchg_double in slab_free().

Object debugging on the free path is also extended to handle these
freelists.  When CONFIG_SLUB_DEBUG is enabled it will also detect if
objects don't belong to the same slab-page.

These changes are needed for the next patch to bulk free the detached
freelists it introduces and constructs.

Micro benchmarking showed no performance reduction due to this change,
when debugging is turned off (compiled with CONFIG_SLUB_DEBUG).

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   87 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 19 deletions(-)

diff -puN mm/slub.c~slub-support-for-bulk-free-with-slub-freelists mm/slub.c
--- a/mm/slub.c~slub-support-for-bulk-free-with-slub-freelists
+++ a/mm/slub.c
@@ -1065,11 +1065,15 @@ bad:
 	return 0;
 }
 
+/* Supports checking bulk free of a constructed freelist */
 static noinline struct kmem_cache_node *free_debug_processing(
-	struct kmem_cache *s, struct page *page, void *object,
+	struct kmem_cache *s, struct page *page,
+	void *head, void *tail, int bulk_cnt,
 	unsigned long addr, unsigned long *flags)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+	void *object = head;
+	int cnt = 0;
 
 	spin_lock_irqsave(&n->list_lock, *flags);
 	slab_lock(page);
@@ -1077,6 +1081,9 @@ static noinline struct kmem_cache_node *
 	if (!check_slab(s, page))
 		goto fail;
 
+next_object:
+	cnt++;
+
 	if (!check_valid_pointer(s, page, object)) {
 		slab_err(s, page, "Invalid object pointer 0x%p", object);
 		goto fail;
@@ -1107,8 +1114,19 @@ static noinline struct kmem_cache_node *
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
 	trace(s, page, object, 0);
+	/* Freepointer not overwritten by init_object(), SLAB_POISON moved it */
 	init_object(s, object, SLUB_RED_INACTIVE);
+
+	/* Reached end of constructed freelist yet? */
+	if (object != tail) {
+		object = get_freepointer(s, object);
+		goto next_object;
+	}
 out:
+	if (cnt != bulk_cnt)
+		slab_err(s, page, "Bulk freelist count(%d) invalid(%d)\n",
+			 bulk_cnt, cnt);
+
 	slab_unlock(page);
 	/*
 	 * Keep node_lock to preserve integrity
@@ -1212,7 +1230,8 @@ static inline int alloc_debug_processing
 	struct page *page, void *object, unsigned long addr) { return 0; }
 
 static inline struct kmem_cache_node *free_debug_processing(
-	struct kmem_cache *s, struct page *page, void *object,
+	struct kmem_cache *s, struct page *page,
+	void *head, void *tail, int bulk_cnt,
 	unsigned long addr, unsigned long *flags) { return NULL; }
 
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
@@ -1308,6 +1327,29 @@ static inline void slab_free_hook(struct
 	kasan_slab_free(s, x);
 }
 
+static inline void slab_free_freelist_hook(struct kmem_cache *s,
+					   void *head, void *tail)
+{
+/*
+ * Compiler cannot detect this function can be removed if slab_free_hook()
+ * evaluates to nothing.  Thus, catch all relevant config debug options here.
+ */
+#if defined(CONFIG_KMEMCHECK) ||		\
+	defined(CONFIG_LOCKDEP)	||		\
+	defined(CONFIG_DEBUG_KMEMLEAK) ||	\
+	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
+	defined(CONFIG_KASAN)
+
+	void *object = head;
+	void *tail_obj = tail ? : head;
+
+	do {
+		slab_free_hook(s, object);
+	} while ((object != tail_obj) &&
+		 (object = get_freepointer(s, object)));
+#endif
+}
+
 static void setup_object(struct kmem_cache *s, struct page *page,
 				void *object)
 {
@@ -2583,10 +2625,11 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trac
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-			void *x, unsigned long addr)
+			void *head, void *tail, int cnt,
+			unsigned long addr)
+
 {
 	void *prior;
-	void **object = (void *)x;
 	int was_frozen;
 	struct page new;
 	unsigned long counters;
@@ -2596,7 +2639,8 @@ static void __slab_free(struct kmem_cach
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) &&
-		!(n = free_debug_processing(s, page, x, addr, &flags)))
+	    !(n = free_debug_processing(s, page, head, tail, cnt,
+					addr, &flags)))
 		return;
 
 	do {
@@ -2606,10 +2650,10 @@ static void __slab_free(struct kmem_cach
 		}
 		prior = page->freelist;
 		counters = page->counters;
-		set_freepointer(s, object, prior);
+		set_freepointer(s, tail, prior);
 		new.counters = counters;
 		was_frozen = new.frozen;
-		new.inuse--;
+		new.inuse -= cnt;
 		if ((!new.inuse || !prior) && !was_frozen) {
 
 			if (kmem_cache_has_cpu_partial(s) && !prior) {
@@ -2640,7 +2684,7 @@ static void __slab_free(struct kmem_cach
 
 	} while (!cmpxchg_double_slab(s, page,
 		prior, counters,
-		object, new.counters,
+		head, new.counters,
 		"__slab_free"));
 
 	if (likely(!n)) {
@@ -2705,15 +2749,20 @@ slab_empty:
  *
  * If fastpath is not possible then fall back to __slab_free where we deal
  * with all sorts of special processing.
- */
-static __always_inline void slab_free(struct kmem_cache *s,
-			struct page *page, void *x, unsigned long addr)
+ *
+ * Bulk free of a freelist with several objects (all pointing to the
+ * same page) possible by specifying head and tail ptr, plus objects
+ * count (cnt). Bulk free indicated by tail pointer being set.
+ */
+static __always_inline void slab_free(struct kmem_cache *s, struct page *page,
+				      void *head, void *tail, int cnt,
+				      unsigned long addr)
 {
-	void **object = (void *)x;
+	void *tail_obj = tail ? : head;
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	slab_free_hook(s, x);
+	slab_free_freelist_hook(s, head, tail);
 
 redo:
 	/*
@@ -2732,19 +2781,19 @@ redo:
 	barrier();
 
 	if (likely(page == c->page)) {
-		set_freepointer(s, object, c->freelist);
+		set_freepointer(s, tail_obj, c->freelist);
 
 		if (unlikely(!this_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				c->freelist, tid,
-				object, next_tid(tid)))) {
+				head, next_tid(tid)))) {
 
 			note_cmpxchg_failure("slab_free", s, tid);
 			goto redo;
 		}
 		stat(s, FREE_FASTPATH);
 	} else
-		__slab_free(s, page, x, addr);
+		__slab_free(s, page, head, tail_obj, cnt, addr);
 
 }
 
@@ -2753,7 +2802,7 @@ void kmem_cache_free(struct kmem_cache *
 	s = cache_from_obj(s, x);
 	if (!s)
 		return;
-	slab_free(s, virt_to_head_page(x), x, _RET_IP_);
+	slab_free(s, virt_to_head_page(x), x, NULL, 1, _RET_IP_);
 	trace_kmem_cache_free(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
@@ -2788,7 +2837,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 			c->tid = next_tid(c->tid);
 			local_irq_enable();
 			/* Slowpath: overhead locked cmpxchg_double_slab */
-			__slab_free(s, page, object, _RET_IP_);
+			__slab_free(s, page, object, object, 1, _RET_IP_);
 			local_irq_disable();
 			c = this_cpu_ptr(s->cpu_slab);
 		}
@@ -3523,7 +3572,7 @@ void kfree(const void *x)
 		__free_kmem_pages(page, compound_order(page));
 		return;
 	}
-	slab_free(page->slab_cache, page, object, _RET_IP_);
+	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
_

Patches currently in -mm which might be from brouer@redhat.com are


