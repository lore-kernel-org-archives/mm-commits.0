Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20787C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05BD46103E
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345892AbhIIVC2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233991AbhIIVC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F4D6103D;
        Thu,  9 Sep 2021 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221277;
        bh=FDA1AAGEhW75OcDZz9C08bMlwwtnK1Z+qapjF/cgFtM=;
        h=Date:From:To:Subject:From;
        b=yVeDw2HOFI8rbe1uGb6v507hJj/4qHK/aqtjFk801L6AZdML4SnlxMolwrvFRy01f
         tJcOnMIaWGEUw4ob2acCFT9KA/veRHn8WRGLUqnv3ASZDlDtyczJIG/Cw84zo1Ay6Q
         n/1qENbqAFjw2cHvmr4cWQA/xrqVLWd1TpjWfHsk=
Date:   Thu, 09 Sep 2021 14:01:17 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged] mm-slub-use-migrate_disable-on-preempt_rt.patch
 removed from -mm tree
Message-ID: <20210909210117.nnDUzVwKL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: use migrate_disable() on PREEMPT_RT
has been removed from the -mm tree.  Its filename was
     mm-slub-use-migrate_disable-on-preempt_rt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Link: https://lkml.kernel.org/r/20210904105003.11688-33-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
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
@@ -2852,7 +2872,7 @@ redo:
 	if (unlikely(!pfmemalloc_match_unsafe(page, gfpflags)))
 		goto deactivate_slab;
 
-	/* must check again c->page in case IRQ handler changed it */
+	/* must check again c->page in case we got preempted and it changed */
 	local_irq_save(flags);
 	if (unlikely(page != c->page)) {
 		local_irq_restore(flags);
@@ -2911,7 +2931,8 @@ new_slab:
 		}
 		if (unlikely(!slub_percpu_partial(c))) {
 			local_irq_restore(flags);
-			goto new_objects; /* stolen by an IRQ handler */
+			/* we were preempted and partial list got empty */
+			goto new_objects;
 		}
 
 		page = c->page = slub_percpu_partial(c);
@@ -2927,9 +2948,9 @@ new_objects:
 	if (freelist)
 		goto check_new_page;
 
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!page)) {
 		slab_out_of_memory(s, gfpflags, node);
@@ -3012,12 +3033,12 @@ static void *__slab_alloc(struct kmem_ca
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
@@ -3546,7 +3567,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	 * IRQs, which protects against PREEMPT and interrupts
 	 * handlers invoking normal fastpath.
 	 */
-	c = get_cpu_ptr(s->cpu_slab);
+	c = slub_get_cpu_ptr(s->cpu_slab);
 	local_irq_disable();
 
 	for (i = 0; i < size; i++) {
@@ -3592,7 +3613,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
-	put_cpu_ptr(s->cpu_slab);
+	slub_put_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * memcg and kmem_cache debug support and memory initialization.
@@ -3602,7 +3623,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
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


