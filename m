Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AC5C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D290610A2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347610AbhIBVwm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347609AbhIBVwm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0213E610A0;
        Thu,  2 Sep 2021 21:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619503;
        bh=mlBdHsp2CTdVScwWzUenoHUSJk08+bZQ362QE07js1U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rOzZk6N38aQoI0zJIO6DVPEJ7zr+BEK5cP3eoEt6zKxbVKbVYWFMTMLDFhGj8L39w
         2/oDneRFE6aCy4ZFj7j+DIZ6h8UnytMNyaBZCHoP/+8eKfVqOUdWIu3iw245upJk9F
         Qg68AVn/ZPFTfN+honjxz2RCpSWy7Wc3ilOWONYM=
Date:   Thu, 02 Sep 2021 14:51:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 033/212] mm, slub: separate detaching of partial
 list in unfreeze_partials() from unfreezing
Message-ID: <20210902215142.p2TJ5F4ga%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: separate detaching of partial list in unfreeze_partials() from unfreezing

Unfreezing partial list can be split to two phases - detaching the list
from struct kmem_cache_cpu, and processing the list.  The whole operation
does not need to be protected by disabled irqs.  Restructure the code to
separate the detaching (with disabled irqs) and unfreezing (with irq
disabling to be reduced in the next patch).

Also, unfreeze_partials() can be called from another cpu on behalf of a
cpu that is being offlined, where disabling irqs on the local cpu has no
sense, so restructure the code as follows:

- __unfreeze_partials() is the bulk of unfreeze_partials() that processes the
  detached percpu partial list
- unfreeze_partials() detaches list from current cpu with irqs disabled and
  calls __unfreeze_partials()
- unfreeze_partials_cpu() is to be called for the offlined cpu so it needs no
  irq disabling, and is called from __flush_cpu_slab()
- flush_cpu_slab() is for the local cpu thus it needs to call
  unfreeze_partials(). So it can't simply call
  __flush_cpu_slab(smp_processor_id()) anymore and we have to open-code the
  proper calls.

Link: https://lkml.kernel.org/r/20210805152000.12817-26-vbabka@suse.cz
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

 mm/slub.c |   73 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 22 deletions(-)

--- a/mm/slub.c~mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing
+++ a/mm/slub.c
@@ -2333,25 +2333,15 @@ redo:
 	}
 }
 
-/*
- * Unfreeze all the cpu partial slabs.
- *
- * This function must be called with preemption or migration
- * disabled with c local to the cpu.
- */
-static void unfreeze_partials(struct kmem_cache *s,
-		struct kmem_cache_cpu *c)
-{
 #ifdef CONFIG_SLUB_CPU_PARTIAL
+static void __unfreeze_partials(struct kmem_cache *s, struct page *partial_page)
+{
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
-	struct page *page, *partial_page, *discard_page = NULL;
+	struct page *page, *discard_page = NULL;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	partial_page = slub_percpu_partial(c);
-	c->partial = NULL;
-
 	while (partial_page) {
 		struct page new;
 		struct page old;
@@ -2406,10 +2396,45 @@ static void unfreeze_partials(struct kme
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
+}
 
-#endif	/* CONFIG_SLUB_CPU_PARTIAL */
+/*
+ * Unfreeze all the cpu partial slabs.
+ */
+static void unfreeze_partials(struct kmem_cache *s)
+{
+	struct page *partial_page;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	partial_page = this_cpu_read(s->cpu_slab->partial);
+	this_cpu_write(s->cpu_slab->partial, NULL);
+	local_irq_restore(flags);
+
+	if (partial_page)
+		__unfreeze_partials(s, partial_page);
+}
+
+static void unfreeze_partials_cpu(struct kmem_cache *s,
+				  struct kmem_cache_cpu *c)
+{
+	struct page *partial_page;
+
+	partial_page = slub_percpu_partial(c);
+	c->partial = NULL;
+
+	if (partial_page)
+		__unfreeze_partials(s, partial_page);
 }
 
+#else	/* CONFIG_SLUB_CPU_PARTIAL */
+
+static inline void unfreeze_partials(struct kmem_cache *s) { }
+static inline void unfreeze_partials_cpu(struct kmem_cache *s,
+				  struct kmem_cache_cpu *c) { }
+
+#endif	/* CONFIG_SLUB_CPU_PARTIAL */
+
 /*
  * Put a page that was just frozen (in __slab_free|get_partial_node) into a
  * partial page slot if available.
@@ -2438,7 +2463,7 @@ static void put_cpu_partial(struct kmem_
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
-				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+				unfreeze_partials(s);
 				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
@@ -2473,11 +2498,6 @@ static inline void flush_slab(struct kme
 	stat(s, CPUSLAB_FLUSH);
 }
 
-/*
- * Flush cpu slab.
- *
- * Called from IPI handler with interrupts disabled.
- */
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
@@ -2485,14 +2505,23 @@ static inline void __flush_cpu_slab(stru
 	if (c->page)
 		flush_slab(s, c);
 
-	unfreeze_partials(s, c);
+	unfreeze_partials_cpu(s, c);
 }
 
+/*
+ * Flush cpu slab.
+ *
+ * Called from IPI handler with interrupts disabled.
+ */
 static void flush_cpu_slab(void *d)
 {
 	struct kmem_cache *s = d;
+	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
+
+	if (c->page)
+		flush_slab(s, c);
 
-	__flush_cpu_slab(s, smp_processor_id());
+	unfreeze_partials(s);
 }
 
 static bool has_cpu_slab(int cpu, void *info)
_
