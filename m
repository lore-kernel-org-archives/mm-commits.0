Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2853CC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10C4F61104
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhHEXic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235436AbhHEXi3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C289760E52;
        Thu,  5 Aug 2021 23:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206695;
        bh=MOGlK3MOPxR1pyjdN7LsxK8Pq2SDmB/SNTLdp/cGCSc=;
        h=Date:From:To:Subject:From;
        b=L8zFcMgxnA7gxama9qJGcnem+pgTZ+OZEBBDOeEfOjp0azm/T9fFzSrPZFsBg8TzT
         5Xql2Ldx0RA2kYjeF78RhK+ITv8G2Tt+Di2UApjRavjjRtRp6vR2g8VY/umEs3lFno
         VAW7bDRYDO8CvSciuTUY4uvsW7K2H77YVOyEJUkA=
Date:   Thu, 05 Aug 2021 16:38:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  + mm-slub-use-migrate_disable-on-preempt_rt.patch added to
 -mm tree
Message-ID: <20210805233814.ThrM5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: use migrate_disable() on PREEMPT_RT
has been added to the -mm tree.  Its filename is
     mm-slub-use-migrate_disable-on-preempt_rt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-migrate_disable-on-preempt_rt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-migrate_disable-on-preempt_rt.patch

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
Subject: mm, slub: use migrate_disable() on PREEMPT_RT

We currently use preempt_disable() (directly or via get_cpu_ptr()) to
stabilize the pointer to kmem_cache_cpu.  On PREEMPT_RT this would be
incompatible with the list_lock spinlock.  We can use migrate_disable()
instead, but that increases overhead on !PREEMPT_RT as it's an
unconditional function call.

In order to get the best available mechanism on both PREEMPT_RT and
!PREEMPT_RT, introduce private slub_get_cpu_ptr() and slub_put_cpu_ptr()
wrappers and use them.

Link: https://lkml.kernel.org/r/20210805152000.12817-35-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

--- a/mm/slub.c~mm-slub-use-migrate_disable-on-preempt_rt
+++ a/mm/slub.c
@@ -118,6 +118,26 @@
  * 			the fast path and disables lockless freelists.
  */
 
+/*
+ * We could simply use migrate_disable()/enable() but as long as it's a
+ * function call even on !PREEMPT_RT, use inline preempt_disable() there.
+ */
+#ifndef CONFIG_PREEMPT_RT
+#define slub_get_cpu_ptr(var)	get_cpu_ptr(var)
+#define slub_put_cpu_ptr(var)	put_cpu_ptr(var)
+#else
+#define slub_get_cpu_ptr(var)		\
+({					\
+	migrate_disable();		\
+	this_cpu_ptr(var);		\
+})
+#define slub_put_cpu_ptr(var)		\
+do {					\
+	(void)(var);			\
+	migrate_enable();		\
+} while (0)
+#endif
+
 #ifdef CONFIG_SLUB_DEBUG
 #ifdef CONFIG_SLUB_DEBUG_ON
 DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
@@ -2809,7 +2829,7 @@ redo:
 	if (unlikely(!pfmemalloc_match(page, gfpflags)))
 		goto deactivate_slab;
 
-	/* must check again c->page in case IRQ handler changed it */
+	/* must check again c->page in case we got preempted and it changed */
 	local_irq_save(flags);
 	if (unlikely(page != c->page)) {
 		local_irq_restore(flags);
@@ -2868,7 +2888,8 @@ new_slab:
 		}
 		if (unlikely(!slub_percpu_partial(c))) {
 			local_irq_restore(flags);
-			goto new_objects; /* stolen by an IRQ handler */
+			/* we were preempted and partial list got empty */
+			goto new_objects;
 		}
 
 		page = c->page = slub_percpu_partial(c);
@@ -2884,9 +2905,9 @@ new_objects:
 	if (freelist)
 		goto check_new_page;
 
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!page)) {
 		slab_out_of_memory(s, gfpflags, node);
@@ -2969,12 +2990,12 @@ static void *__slab_alloc(struct kmem_ca
 	 * cpu before disabling preemption. Need to reload cpu area
 	 * pointer.
 	 */
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 #endif
 
 	p = ___slab_alloc(s, gfpflags, node, addr, c);
 #ifdef CONFIG_PREEMPT_COUNT
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 #endif
 	return p;
 }
@@ -3503,7 +3524,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	 * IRQs, which protects against PREEMPT and interrupts
 	 * handlers invoking normal fastpath.
 	 */
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 	local_irq_disable();
 
 	for (i = 0; i < size; i++) {
@@ -3549,7 +3570,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * memcg and kmem_cache debug support and memory initialization.
@@ -3559,7 +3580,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 				slab_want_init_on_alloc(flags, s));
 	return i;
 error:
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 	slab_post_alloc_hook(s, objcg, flags, i, p, false);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
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

