Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0F4C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B92611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbhIIVCM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345763AbhIIVCL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B567C6103D;
        Thu,  9 Sep 2021 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221261;
        bh=992QgK2mJ3h+BkFqo5I5vxT3SI+MuwEVSVehuIBqmpA=;
        h=Date:From:To:Subject:From;
        b=R2pdSItRf8gYLCUH9ol+3rEfQ96yk5SJdxwHQEiei7zTI9fcRgo+BIuPs7aLQHqbo
         ZCF7J8TqYUaScIMKXB3FHrII1/7S5kY5A4O20YN3X3X0opP1f4LZEAOPptX1KWobZd
         /2DVzE/eOwxjADECbfJ3SbRMxeqhobipOR+Yps1Y=
Date:   Thu, 09 Sep 2021 14:01:00 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-slub-separate-detaching-of-partial-list-in-unfreeze=5Fpa?=
 =?US-ASCII?Q?rtials-from-unfreezing.patch?= removed from -mm tree
Message-ID: <20210909210100.ZblSw49wv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: separate detaching of partial list in unfreeze_partials() from unfreezing
has been removed from the -mm tree.  Its filename was
     mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210904105003.11688-25-vbabka@suse.cz
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

 mm/slub.c |   73 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 22 deletions(-)

--- a/mm/slub.c~mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing
+++ a/mm/slub.c
@@ -2347,25 +2347,15 @@ redo:
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
@@ -2420,10 +2410,45 @@ static void unfreeze_partials(struct kme
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
@@ -2452,7 +2477,7 @@ static void put_cpu_partial(struct kmem_
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
-				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+				unfreeze_partials(s);
 				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
@@ -2487,11 +2512,6 @@ static inline void flush_slab(struct kme
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
@@ -2499,14 +2519,23 @@ static inline void __flush_cpu_slab(stru
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

Patches currently in -mm which might be from vbabka@suse.cz are


