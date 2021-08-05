Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5919DC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4222C60E53
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbhHEXif (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235436AbhHEXic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A841E61132;
        Thu,  5 Aug 2021 23:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206696;
        bh=5wLmS/OR0RK6Zechgs6J4BXo+lcHFFKv6xsaVXUcIgc=;
        h=Date:From:To:Subject:From;
        b=an6KsE5VnE9Sx9ptDsGntxMWZZ0B7g4WaiFmUX5cN2xOqQWc6AXELGeKispBknvrY
         MfPe5P1CycK1ksov1mxPDkDPG5kH/LjKE1waWk7oy94ODLe+YEtmnLxZsNxSrExO7e
         mUM+7Q/OVPhk9oNO5e/gx7bnoK/e0Apzj6rWynAA=
Date:   Thu, 05 Aug 2021 16:38:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, cl@linux.com, brouer@redhat.com,
        bigeasy@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch added to -mm
 tree
Message-ID: <20210805233816.v-xCD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: convert kmem_cpu_slab protection to local_lock
has been added to the -mm tree.  Its filename is
     mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Link: https://lkml.kernel.org/r/20210805152000.12817-36-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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

 include/linux/slub_def.h |    2 
 mm/slub.c                |  146 ++++++++++++++++++++++++++++---------
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
@@ -41,6 +42,7 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
+	local_lock_t lock;	/* Protects the fields below except stat */
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
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
@@ -2830,9 +2872,9 @@ redo:
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
@@ -2843,7 +2885,7 @@ redo:
 
 	if (!freelist) {
 		c->page = NULL;
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
@@ -2852,7 +2894,11 @@ redo:
 
 load_freelist:
 
-	lockdep_assert_irqs_disabled();
+#ifdef CONFIG_PREEMPT_RT
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock.lock));
+#else
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
+#endif
 
 	/*
 	 * freelist is pointing to the list of objects to be used.
@@ -2862,39 +2908,39 @@ load_freelist:
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
@@ -2947,7 +2993,7 @@ check_new_page:
 
 retry_load_page:
 
-	local_irq_save(flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (unlikely(c->page)) {
 		void *flush_freelist = c->freelist;
 		struct page *flush_page = c->page;
@@ -2956,7 +3002,7 @@ retry_load_page:
 		c->freelist = NULL;
 		c->tid = next_tid(c->tid);
 
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 		deactivate_slab(s, flush_page, flush_freelist);
 
@@ -3075,7 +3121,15 @@ redo:
 
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
@@ -3335,6 +3389,7 @@ redo:
 	barrier();
 
 	if (likely(page == c->page)) {
+#ifndef CONFIG_PREEMPT_RT
 		void **freelist = READ_ONCE(c->freelist);
 
 		set_freepointer(s, tail_obj, freelist);
@@ -3347,6 +3402,31 @@ redo:
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
@@ -3525,7 +3605,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	 * handlers invoking normal fastpath.
 	 */
 	c = slub_get_cpu_ptr(s->cpu_slab);
-	local_irq_disable();
+	local_lock_irq(&s->cpu_slab->lock);
 
 	for (i = 0; i < size; i++) {
 		void *object = kfence_alloc(s, s->object_size, flags);
@@ -3546,7 +3626,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			 */
 			c->tid = next_tid(c->tid);
 
-			local_irq_enable();
+			local_unlock_irq(&s->cpu_slab->lock);
 
 			/*
 			 * Invoking slow path likely have side-effect
@@ -3560,7 +3640,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			c = this_cpu_ptr(s->cpu_slab);
 			maybe_wipe_obj_freeptr(s, p[i]);
 
-			local_irq_disable();
+			local_lock_irq(&s->cpu_slab->lock);
 
 			continue; /* goto for-loop */
 		}
@@ -3569,7 +3649,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		maybe_wipe_obj_freeptr(s, p[i]);
 	}
 	c->tid = next_tid(c->tid);
-	local_irq_enable();
+	local_unlock_irq(&s->cpu_slab->lock);
 	slub_put_cpu_ptr(s->cpu_slab);
 
 	/*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch
mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch
mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

