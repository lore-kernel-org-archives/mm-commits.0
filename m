Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D7FC4167E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0E55610E5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347683AbhIBVxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347698AbhIBVxP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27FEC610A1;
        Thu,  2 Sep 2021 21:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619536;
        bh=apIbXKSXSb3k/bARqoOIwFVmpi2eUc31dwXvLpxE8y0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HjPRzxQkNvSap12IwfBAOfIecKkCdoRtJYmcLmskqIZQJ1axkXR5aGuI0qRIZF5me
         JdJJ6CRN0nXCBvDX/U5RPTaVKHkr/YqIJOqLso2sNzh91z+dJSoPIuDRN4hgB5WjVk
         T5V1M5bRmhgI1Fa6ebwsK+nhoH8th0DaywOR9cXI=
Date:   Thu, 02 Sep 2021 14:52:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sven@narfation.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 043/212] mm, slub: convert kmem_cpu_slab
 protection to local_lock
Message-ID: <20210902215215.7TuZyn_O7%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: convert kmem_cpu_slab protection to local_lock

Embed local_lock into struct kmem_cpu_slab and use the irq-safe versions
of local_lock instead of plain local_irq_save/restore.  On !PREEMPT_RT
that's equivalent, with better lockdep visibility.  On PREEMPT_RT that
means better preemption.

However, the cost on PREEMPT_RT is the loss of lockless fast paths which
only work with cpu freelist.  Those are designed to detect and recover
from being preempted by other conflicting operations (both fast or slow
path), but the slow path operations assume they cannot be preempted by a
fast path operation, which is guaranteed naturally with disabled irqs. 
With local locks on PREEMPT_RT, the fast paths now also need to take the
local lock to avoid races.

In the allocation fastpath slab_alloc_node() we can just defer to the
slowpath __slab_alloc() which also works with cpu freelist, but under the
local lock.  In the free fastpath do_slab_free() we have to add a new
local lock protected version of freeing to the cpu freelist, as the
existing slowpath only works with the page freelist.

Also update the comment about locking scheme in SLUB to reflect changes
done by this series.

[efault@gmx.de: use local_lock() without irq in PREEMPT_RT scope, debugging of RT crashes resulting in put_cpu_partial() locking changes]
[vbabka@suse.cz: simplify lockdep_assert_held in lockdep_assert_held()]
  Link: https://lkml.kernel.org/r/7e9ccf34-57d1-786b-2dfd-3b9ba78e1b32@suse.cz
[vbabka@suse.cz: fix kmem_cache_cpu fields alignment for double cmpxchg]
  Link: https://lkml.kernel.org/r/e907c2b6-6df1-8038-8c6c-aa9c1fd11259@suse.cz
Link: https://lkml.kernel.org/r/20210805152000.12817-36-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    6 +
 mm/slub.c                |  142 ++++++++++++++++++++++++++++---------
 2 files changed, 115 insertions(+), 33 deletions(-)

--- a/include/linux/slub_def.h~mm-slub-convert-kmem_cpu_slab-protection-to-local_lock
+++ a/include/linux/slub_def.h
@@ -10,6 +10,7 @@
 #include <linux/kfence.h>
 #include <linux/kobject.h>
 #include <linux/reciprocal_div.h>
+#include <linux/local_lock.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -40,6 +41,10 @@ enum stat_item {
 	CPU_PARTIAL_DRAIN,	/* Drain cpu partial to node partial */
 	NR_SLUB_STAT_ITEMS };
 
+/*
+ * When changing the layout, make sure freelist and tid are still compatible
+ * with this_cpu_cmpxchg_double() alignment requirements.
+ */
 struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
@@ -47,6 +52,7 @@ struct kmem_cache_cpu {
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *partial;	/* Partially allocated frozen slabs */
 #endif
+	local_lock_t lock;	/* Protects the fields above */
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
--- a/mm/slub.c~mm-slub-convert-kmem_cpu_slab-protection-to-local_lock
+++ a/mm/slub.c
@@ -46,13 +46,21 @@
 /*
  * Lock order:
  *   1. slab_mutex (Global Mutex)
- *   2. node->list_lock
- *   3. slab_lock(page) (Only on some arches and for debugging)
+ *   2. node->list_lock (Spinlock)
+ *   3. kmem_cache->cpu_slab->lock (Local lock)
+ *   4. slab_lock(page) (Only on some arches or for debugging)
+ *   5. object_map_lock (Only for debugging)
  *
  *   slab_mutex
  *
  *   The role of the slab_mutex is to protect the list of all the slabs
  *   and to synchronize major metadata changes to slab cache structures.
+ *   Also synchronizes memory hotplug callbacks.
+ *
+ *   slab_lock
+ *
+ *   The slab_lock is a wrapper around the page lock, thus it is a bit
+ *   spinlock.
  *
  *   The slab_lock is only used for debugging and on arches that do not
  *   have the ability to do a cmpxchg_double. It only protects:
@@ -61,6 +69,8 @@
  *	C. page->objects	-> Number of objects in page
  *	D. page->frozen		-> frozen state
  *
+ *   Frozen slabs
+ *
  *   If a slab is frozen then it is exempt from list management. It is not
  *   on any list except per cpu partial list. The processor that froze the
  *   slab is the one who can perform list operations on the page. Other
@@ -68,6 +78,8 @@
  *   froze the slab is the only one that can retrieve the objects from the
  *   page's freelist.
  *
+ *   list_lock
+ *
  *   The list_lock protects the partial and full list on each node and
  *   the partial slab counter. If taken then no new slabs may be added or
  *   removed from the lists nor make the number of partial slabs be modified.
@@ -79,10 +91,36 @@
  *   slabs, operations can continue without any centralized lock. F.e.
  *   allocating a long series of objects that fill up slabs does not require
  *   the list lock.
- *   Interrupts are disabled during allocation and deallocation in order to
- *   make the slab allocator safe to use in the context of an irq. In addition
- *   interrupts are disabled to ensure that the processor does not change
- *   while handling per_cpu slabs, due to kernel preemption.
+ *
+ *   cpu_slab->lock local lock
+ *
+ *   This locks protect slowpath manipulation of all kmem_cache_cpu fields
+ *   except the stat counters. This is a percpu structure manipulated only by
+ *   the local cpu, so the lock protects against being preempted or interrupted
+ *   by an irq. Fast path operations rely on lockless operations instead.
+ *   On PREEMPT_RT, the local lock does not actually disable irqs (and thus
+ *   prevent the lockless operations), so fastpath operations also need to take
+ *   the lock and are no longer lockless.
+ *
+ *   lockless fastpaths
+ *
+ *   The fast path allocation (slab_alloc_node()) and freeing (do_slab_free())
+ *   are fully lockless when satisfied from the percpu slab (and when
+ *   cmpxchg_double is possible to use, otherwise slab_lock is taken).
+ *   They also don't disable preemption or migration or irqs. They rely on
+ *   the transaction id (tid) field to detect being preempted or moved to
+ *   another cpu.
+ *
+ *   irq, preemption, migration considerations
+ *
+ *   Interrupts are disabled as part of list_lock or local_lock operations, or
+ *   around the slab_lock operation, in order to make the slab allocator safe
+ *   to use in the context of an irq.
+ *
+ *   In addition, preemption (or migration on PREEMPT_RT) is disabled in the
+ *   allocation slowpath, bulk allocation, and put_cpu_partial(), so that the
+ *   local cpu doesn't change in the process and e.g. the kmem_cache_cpu pointer
+ *   doesn't have to be revalidated in each section protected by the local lock.
  *
  * SLUB assigns one slab for allocation to each processor.
  * Allocations only occur from these slabs called cpu slabs.
@@ -2231,9 +2269,13 @@ static inline void note_cmpxchg_failure(
 static void init_kmem_cache_cpus(struct kmem_cache *s)
 {
 	int cpu;
+	struct kmem_cache_cpu *c;
 
-	for_each_possible_cpu(cpu)
-		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
+	for_each_possible_cpu(cpu) {
+		c = per_cpu_ptr(s->cpu_slab, cpu);
+		local_lock_init(&c->lock);
+		c->tid = init_tid(cpu);
+	}
 }
 
 /*
@@ -2444,10 +2486,10 @@ static void unfreeze_partials(struct kme
 	struct page *partial_page;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	partial_page = this_cpu_read(s->cpu_slab->partial);
 	this_cpu_write(s->cpu_slab->partial, NULL);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 	if (partial_page)
 		__unfreeze_partials(s, partial_page);
@@ -2480,7 +2522,7 @@ static void put_cpu_partial(struct kmem_
 	int pages = 0;
 	int pobjects = 0;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 
 	oldpage = this_cpu_read(s->cpu_slab->partial);
 
@@ -2508,7 +2550,7 @@ static void put_cpu_partial(struct kmem_
 
 	this_cpu_write(s->cpu_slab->partial, page);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 	if (page_to_unfreeze) {
 		__unfreeze_partials(s, page_to_unfreeze);
@@ -2532,7 +2574,7 @@ static inline void flush_slab(struct kme
 	struct page *page;
 
 	if (lock)
-		local_irq_save(flags);
+		local_lock_irqsave(&s->cpu_slab->lock, flags);
 
 	freelist = c->freelist;
 	page = c->page;
@@ -2542,7 +2584,7 @@ static inline void flush_slab(struct kme
 	c->tid = next_tid(c->tid);
 
 	if (lock)
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 	if (page)
 		deactivate_slab(s, page, freelist);
@@ -2849,9 +2891,9 @@ redo:
 		goto deactivate_slab;
 
 	/* must check again c->page in case we got preempted and it changed */
-	local_irq_save(flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (unlikely(page != c->page)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		goto reread_page;
 	}
 	freelist = c->freelist;
@@ -2862,7 +2904,7 @@ redo:
 
 	if (!freelist) {
 		c->page = NULL;
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
@@ -2871,7 +2913,7 @@ redo:
 
 load_freelist:
 
-	lockdep_assert_irqs_disabled();
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
 
 	/*
 	 * freelist is pointing to the list of objects to be used.
@@ -2881,39 +2923,39 @@ load_freelist:
 	VM_BUG_ON(!c->page->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 	return freelist;
 
 deactivate_slab:
 
-	local_irq_save(flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (page != c->page) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		goto reread_page;
 	}
 	freelist = c->freelist;
 	c->page = NULL;
 	c->freelist = NULL;
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 	deactivate_slab(s, page, freelist);
 
 new_slab:
 
 	if (slub_percpu_partial(c)) {
-		local_irq_save(flags);
+		local_lock_irqsave(&s->cpu_slab->lock, flags);
 		if (unlikely(c->page)) {
-			local_irq_restore(flags);
+			local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 			goto reread_page;
 		}
 		if (unlikely(!slub_percpu_partial(c))) {
-			local_irq_restore(flags);
+			local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 			/* we were preempted and partial list got empty */
 			goto new_objects;
 		}
 
 		page = c->page = slub_percpu_partial(c);
 		slub_set_percpu_partial(c, page);
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, CPU_PARTIAL_ALLOC);
 		goto redo;
 	}
@@ -2966,7 +3008,7 @@ check_new_page:
 
 retry_load_page:
 
-	local_irq_save(flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (unlikely(c->page)) {
 		void *flush_freelist = c->freelist;
 		struct page *flush_page = c->page;
@@ -2975,7 +3017,7 @@ retry_load_page:
 		c->freelist = NULL;
 		c->tid = next_tid(c->tid);
 
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 		deactivate_slab(s, flush_page, flush_freelist);
 
@@ -3094,7 +3136,15 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !page || !node_match(page, node))) {
+	/*
+	 * We cannot use the lockless fastpath on PREEMPT_RT because if a
+	 * slowpath has taken the local_lock_irqsave(), it is not protected
+	 * against a fast path operation in an irq handler. So we need to take
+	 * the slow path which uses local_lock. It is still relatively fast if
+	 * there is a suitable cpu freelist.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) ||
+	    unlikely(!object || !page || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
@@ -3354,6 +3404,7 @@ redo:
 	barrier();
 
 	if (likely(page == c->page)) {
+#ifndef CONFIG_PREEMPT_RT
 		void **freelist = READ_ONCE(c->freelist);
 
 		set_freepointer(s, tail_obj, freelist);
@@ -3366,6 +3417,31 @@ redo:
 			note_cmpxchg_failure("slab_free", s, tid);
 			goto redo;
 		}
+#else /* CONFIG_PREEMPT_RT */
+		/*
+		 * We cannot use the lockless fastpath on PREEMPT_RT because if
+		 * a slowpath has taken the local_lock_irqsave(), it is not
+		 * protected against a fast path operation in an irq handler. So
+		 * we need to take the local_lock. We shouldn't simply defer to
+		 * __slab_free() as that wouldn't use the cpu freelist at all.
+		 */
+		void **freelist;
+
+		local_lock(&s->cpu_slab->lock);
+		c = this_cpu_ptr(s->cpu_slab);
+		if (unlikely(page != c->page)) {
+			local_unlock(&s->cpu_slab->lock);
+			goto redo;
+		}
+		tid = c->tid;
+		freelist = c->freelist;
+
+		set_freepointer(s, tail_obj, freelist);
+		c->freelist = head;
+		c->tid = next_tid(tid);
+
+		local_unlock(&s->cpu_slab->lock);
+#endif
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, head, tail_obj, cnt, addr);
@@ -3544,7 +3620,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	 * handlers invoking normal fastpath.
 	 */
 	c = slub_get_cpu_ptr(s->cpu_slab);
-	local_irq_disable();
+	local_lock_irq(&s->cpu_slab->lock);
 
 	for (i = 0; i < size; i++) {
 		void *object = kfence_alloc(s, s->object_size, flags);
@@ -3565,7 +3641,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			 */
 			c->tid = next_tid(c->tid);
 
-			local_irq_enable();
+			local_unlock_irq(&s->cpu_slab->lock);
 
 			/*
 			 * Invoking slow path likely have side-effect
@@ -3579,7 +3655,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			c = this_cpu_ptr(s->cpu_slab);
 			maybe_wipe_obj_freeptr(s, p[i]);
 
-			local_irq_disable();
+			local_lock_irq(&s->cpu_slab->lock);
 
 			continue; /* goto for-loop */
 		}
@@ -3588,7 +3664,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		maybe_wipe_obj_freeptr(s, p[i]);
 	}
 	c->tid = next_tid(c->tid);
-	local_irq_enable();
+	local_unlock_irq(&s->cpu_slab->lock);
 	slub_put_cpu_ptr(s->cpu_slab);
 
 	/*
_
