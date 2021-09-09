Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75547C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 582C26103D
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345073AbhIIVBp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245624AbhIIVBo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B293C61026;
        Thu,  9 Sep 2021 21:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221235;
        bh=8xJNtejbvSp300MQ4IZCb6K1RJA1IYr1CcKszQYfK8U=;
        h=Date:From:To:Subject:From;
        b=qy8E1KbbBL8IzQ1YlJ57E3xM6dpJBb1Yxqqd1Tdu0P+LkN23peueHPE0fRoo1X9c/
         WE2TQD0YGvEVhwt971iZX6WS0NbSppaQyWn8g9BMk6tb3NsMO0jNTZ9QuttwoMrfcJ
         9tBXsIZCqaetdhyElXnrk0vKM8QqLhrtIPmFQ36U=
Date:   Thu, 09 Sep 2021 14:00:34 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch removed from
 -mm tree
Message-ID: <20210909210034.5A8H4a68O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: move disabling/enabling irqs to ___slab_alloc()
has been removed from the -mm tree.  Its filename was
     mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: move disabling/enabling irqs to ___slab_alloc()

Currently __slab_alloc() disables irqs around the whole ___slab_alloc(). 
This includes cases where this is not needed, such as when the allocation
ends up in the page allocator and has to awkwardly enable irqs back based
on gfp flags.  Also the whole kmem_cache_alloc_bulk() is executed with
irqs disabled even when it hits the __slab_alloc() slow path, and long
periods with disabled interrupts are undesirable.

As a first step towards reducing irq disabled periods, move irq handling
into ___slab_alloc().  Callers will instead prevent the s->cpu_slab percpu
pointer from becoming invalid via get_cpu_ptr(), thus preempt_disable(). 
This does not protect against modification by an irq handler, which is
still done by disabled irq for most of ___slab_alloc().  As a small
immediate benefit, slab_out_of_memory() from ___slab_alloc() is now called
with irqs enabled.

kmem_cache_alloc_bulk() disables irqs for its fastpath and then re-enables
them before calling ___slab_alloc(), which then disables them at its
discretion.  The whole kmem_cache_alloc_bulk() operation also disables
preemption.

When ___slab_alloc() calls new_slab() to allocate a new page, re-enable
preemption, because new_slab() will re-enable interrupts in contexts that
allow blocking (this will be improved by later patches).

The patch itself will thus increase overhead a bit due to disabled
preemption (on configs where it matters) and increased disabling/enabling
irqs in kmem_cache_alloc_bulk(), but that will be gradually improved in
the following patches.

Note in __slab_alloc() we need to change the #ifdef CONFIG_PREEMPT guard
to CONFIG_PREEMPT_COUNT to make sure preempt disable/enable is properly
paired in all configurations.  On configs without involuntary preemption
and debugging the re-read of kmem_cache_cpu pointer is still compiled out
as it was before.

[ Mike Galbraith <efault@gmx.de>: Fix kmem_cache_alloc_bulk() error path ]
Link: https://lkml.kernel.org/r/20210904105003.11688-12-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/mm/slub.c~mm-slub-move-disabling-enabling-irqs-to-___slab_alloc
+++ a/mm/slub.c
@@ -2670,7 +2670,7 @@ static inline void *get_freelist(struct
  * we need to allocate a new slab. This is the slowest path since it involves
  * a call to the page allocator and the setup of a new slab.
  *
- * Version of __slab_alloc to use when we know that interrupts are
+ * Version of __slab_alloc to use when we know that preemption is
  * already disabled (which is the case for bulk allocation).
  */
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
@@ -2678,9 +2678,11 @@ static void *___slab_alloc(struct kmem_c
 {
 	void *freelist;
 	struct page *page;
+	unsigned long flags;
 
 	stat(s, ALLOC_SLOWPATH);
 
+	local_irq_save(flags);
 	page = c->page;
 	if (!page) {
 		/*
@@ -2743,6 +2745,7 @@ load_freelist:
 	VM_BUG_ON(!c->page->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
+	local_irq_restore(flags);
 	return freelist;
 
 new_slab:
@@ -2760,14 +2763,16 @@ new_slab:
 		goto check_new_page;
 	}
 
+	put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
+	c = get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!page)) {
+		local_irq_restore(flags);
 		slab_out_of_memory(s, gfpflags, node);
 		return NULL;
 	}
 
-	c = raw_cpu_ptr(s->cpu_slab);
 	if (c->page)
 		flush_slab(s, c);
 
@@ -2807,31 +2812,33 @@ check_new_page:
 return_single:
 
 	deactivate_slab(s, page, get_freepointer(s, freelist), c);
+	local_irq_restore(flags);
 	return freelist;
 }
 
 /*
- * Another one that disabled interrupt and compensates for possible
- * cpu changes by refetching the per cpu area pointer.
+ * A wrapper for ___slab_alloc() for contexts where preemption is not yet
+ * disabled. Compensates for possible cpu changes by refetching the per cpu area
+ * pointer.
  */
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void *p;
-	unsigned long flags;
 
-	local_irq_save(flags);
-#ifdef CONFIG_PREEMPTION
+#ifdef CONFIG_PREEMPT_COUNT
 	/*
 	 * We may have been preempted and rescheduled on a different
-	 * cpu before disabling interrupts. Need to reload cpu area
+	 * cpu before disabling preemption. Need to reload cpu area
 	 * pointer.
 	 */
-	c = this_cpu_ptr(s->cpu_slab);
+	c = get_cpu_ptr(s->cpu_slab);
 #endif
 
 	p = ___slab_alloc(s, gfpflags, node, addr, c);
-	local_irq_restore(flags);
+#ifdef CONFIG_PREEMPT_COUNT
+	put_cpu_ptr(s->cpu_slab);
+#endif
 	return p;
 }
 
@@ -3359,8 +3366,8 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	 * IRQs, which protects against PREEMPT and interrupts
 	 * handlers invoking normal fastpath.
 	 */
+	c = get_cpu_ptr(s->cpu_slab);
 	local_irq_disable();
-	c = this_cpu_ptr(s->cpu_slab);
 
 	for (i = 0; i < size; i++) {
 		void *object = kfence_alloc(s, s->object_size, flags);
@@ -3381,6 +3388,8 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			 */
 			c->tid = next_tid(c->tid);
 
+			local_irq_enable();
+
 			/*
 			 * Invoking slow path likely have side-effect
 			 * of re-populating per CPU c->freelist
@@ -3393,6 +3402,8 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			c = this_cpu_ptr(s->cpu_slab);
 			maybe_wipe_obj_freeptr(s, p[i]);
 
+			local_irq_disable();
+
 			continue; /* goto for-loop */
 		}
 		c->freelist = get_freepointer(s, object);
@@ -3401,6 +3412,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
+	put_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * memcg and kmem_cache debug support and memory initialization.
@@ -3410,7 +3422,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 				slab_want_init_on_alloc(flags, s));
 	return i;
 error:
-	local_irq_enable();
+	put_cpu_ptr(s->cpu_slab);
 	slab_post_alloc_hook(s, objcg, flags, i, p, false);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
_

Patches currently in -mm which might be from vbabka@suse.cz are


