Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3732C004D5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F9E610E7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbhIBVxN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347695AbhIBVxM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0730610A0;
        Thu,  2 Sep 2021 21:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619533;
        bh=sxrQfxoHGVKbljgranv0aNECw12f7++8fUn5E91ntJ4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pLojRSyaTE+l0w/aMAHo4onNlQwJp5IAXYtI/04Yhs8CNxC824oGPXpUcLqb/dDeu
         wZvsDuGH1aPVyPIbcG/fjkkcBrgeSJc5bpkyB147wPsV40LzOEGskUac1k/0Jq1Mm/
         XvYAsDL6QB68tgdby2aB/XDfE+TXDqz0RoWd98No=
Date:   Thu, 02 Sep 2021 14:52:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 042/212] mm, slub: use migrate_disable() on
 PREEMPT_RT
Message-ID: <20210902215212.CUVLaVpin%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2828,7 +2848,7 @@ redo:
 	if (unlikely(!pfmemalloc_match_unsafe(page, gfpflags)))
 		goto deactivate_slab;
 
-	/* must check again c->page in case IRQ handler changed it */
+	/* must check again c->page in case we got preempted and it changed */
 	local_irq_save(flags);
 	if (unlikely(page != c->page)) {
 		local_irq_restore(flags);
@@ -2887,7 +2907,8 @@ new_slab:
 		}
 		if (unlikely(!slub_percpu_partial(c))) {
 			local_irq_restore(flags);
-			goto new_objects; /* stolen by an IRQ handler */
+			/* we were preempted and partial list got empty */
+			goto new_objects;
 		}
 
 		page = c->page = slub_percpu_partial(c);
@@ -2903,9 +2924,9 @@ new_objects:
 	if (freelist)
 		goto check_new_page;
 
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!page)) {
 		slab_out_of_memory(s, gfpflags, node);
@@ -2988,12 +3009,12 @@ static void *__slab_alloc(struct kmem_ca
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
@@ -3522,7 +3543,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	 * IRQs, which protects against PREEMPT and interrupts
 	 * handlers invoking normal fastpath.
 	 */
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 	local_irq_disable();
 
 	for (i = 0; i < size; i++) {
@@ -3568,7 +3589,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * memcg and kmem_cache debug support and memory initialization.
@@ -3578,7 +3599,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 				slab_want_init_on_alloc(flags, s));
 	return i;
 error:
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 	slab_post_alloc_hook(s, objcg, flags, i, p, false);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
_
