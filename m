Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2EBC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E51610E7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347581AbhIBVwG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347578AbhIBVwG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA5E60724;
        Thu,  2 Sep 2021 21:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619467;
        bh=sslgSYXpsHXbleifEt+YDGJnIH11eQyIZZH+kf25Wq4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2Uw9ATOVIXIoMP1d4qmd4mZVWUUVR/lafxdlVvgdh4f6oSNET3DFMy6kQMAuvl1xi
         j2d/cC63GVAT6j58ok/h3O23GzjZZ/RN6simUbmplPjqJjKPZBJLFU40x7p3FHgsn0
         2RBv3wOQ6sr10CoXh7++z+8YbFWsZz8AP2OhGR1s=
Date:   Thu, 02 Sep 2021 14:51:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 022/212] mm, slub: move disabling irqs closer to
 get_partial() in ___slab_alloc()
Message-ID: <20210902215106.SxsxDEto0%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: move disabling irqs closer to get_partial() in ___slab_alloc()

Continue reducing the irq disabled scope.  Check for per-cpu partial slabs
with first with irqs enabled and then recheck with irqs disabled before
grabbing the slab page.  Mostly preparatory for the following patches.

Link: https://lkml.kernel.org/r/20210805152000.12817-15-vbabka@suse.cz
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

 mm/slub.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/mm/slub.c~mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc
+++ a/mm/slub.c
@@ -2692,11 +2692,6 @@ reread_page:
 		if (unlikely(node != NUMA_NO_NODE &&
 			     !node_isset(node, slab_nodes)))
 			node = NUMA_NO_NODE;
-		local_irq_save(flags);
-		if (unlikely(c->page)) {
-			local_irq_restore(flags);
-			goto reread_page;
-		}
 		goto new_slab;
 	}
 redo:
@@ -2737,6 +2732,7 @@ redo:
 
 	if (!freelist) {
 		c->page = NULL;
+		local_irq_restore(flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
@@ -2766,12 +2762,19 @@ deactivate_slab:
 		goto reread_page;
 	}
 	deactivate_slab(s, page, c->freelist, c);
+	local_irq_restore(flags);
 
 new_slab:
 
-	lockdep_assert_irqs_disabled();
-
 	if (slub_percpu_partial(c)) {
+		local_irq_save(flags);
+		if (unlikely(c->page)) {
+			local_irq_restore(flags);
+			goto reread_page;
+		}
+		if (unlikely(!slub_percpu_partial(c)))
+			goto new_objects; /* stolen by an IRQ handler */
+
 		page = c->page = slub_percpu_partial(c);
 		slub_set_percpu_partial(c, page);
 		local_irq_restore(flags);
@@ -2779,6 +2782,16 @@ new_slab:
 		goto redo;
 	}
 
+	local_irq_save(flags);
+	if (unlikely(c->page)) {
+		local_irq_restore(flags);
+		goto reread_page;
+	}
+
+new_objects:
+
+	lockdep_assert_irqs_disabled();
+
 	freelist = get_partial(s, gfpflags, node, &page);
 	if (freelist) {
 		c->page = page;
@@ -2811,15 +2824,18 @@ new_slab:
 check_new_page:
 
 	if (kmem_cache_debug(s)) {
-		if (!alloc_debug_processing(s, page, freelist, addr))
+		if (!alloc_debug_processing(s, page, freelist, addr)) {
 			/* Slab failed checks. Next slab needed */
+			c->page = NULL;
+			local_irq_restore(flags);
 			goto new_slab;
-		else
+		} else {
 			/*
 			 * For debug case, we don't load freelist so that all
 			 * allocations go through alloc_debug_processing()
 			 */
 			goto return_single;
+		}
 	}
 
 	if (unlikely(!pfmemalloc_match(page, gfpflags)))
_
