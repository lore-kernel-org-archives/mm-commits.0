Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEE3C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A019610F9
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347582AbhIBVwc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347608AbhIBVwc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 177ED610A0;
        Thu,  2 Sep 2021 21:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619493;
        bh=cpHWoFYt/F/GbF5zJU0NFBlwWwyPnMiyMk52GLaqIww=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HUxmueOu6T321fcO+8XlnhN0PUQVjztnINPyWU4+tjllUhFc1JLrVIZrN6RUdPlNL
         PA/mLXRaSYa2KMV2yGStBlTB8IAYVkRb4F3My0uaE7o/rKU/jPls7Kh54RawKZX+6K
         3kGTss9ddZvlkdZZxHUQb5tg6D2gck/nD8KGwQMs=
Date:   Thu, 02 Sep 2021 14:51:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 030/212] mm, slub: move irq control into
 unfreeze_partials()
Message-ID: <20210902215132.u50YP4H_j%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: move irq control into unfreeze_partials()

unfreeze_partials() can be optimized so that it doesn't need irqs disabled
for the whole time.  As the first step, move irq control into the function
and remove it from the put_cpu_partial() caller.

Link: https://lkml.kernel.org/r/20210805152000.12817-23-vbabka@suse.cz
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

 mm/slub.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-move-irq-control-into-unfreeze_partials
+++ a/mm/slub.c
@@ -2336,9 +2336,8 @@ redo:
 /*
  * Unfreeze all the cpu partial slabs.
  *
- * This function must be called with interrupts disabled
- * for the cpu using c (or some other guarantee must be there
- * to guarantee no concurrent accesses).
+ * This function must be called with preemption or migration
+ * disabled with c local to the cpu.
  */
 static void unfreeze_partials(struct kmem_cache *s,
 		struct kmem_cache_cpu *c)
@@ -2346,6 +2345,9 @@ static void unfreeze_partials(struct kme
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct page *page, *discard_page = NULL;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	while ((page = slub_percpu_partial(c))) {
 		struct page new;
@@ -2398,6 +2400,8 @@ static void unfreeze_partials(struct kme
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
+
+	local_irq_restore(flags);
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
 
@@ -2425,14 +2429,11 @@ static void put_cpu_partial(struct kmem_
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
 			if (drain && pobjects > slub_cpu_partial(s)) {
-				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
-				local_irq_save(flags);
 				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
-				local_irq_restore(flags);
 				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
_
