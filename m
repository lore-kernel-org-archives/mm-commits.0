Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E799C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2163061179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345621AbhIIVB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVB4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3966103E;
        Thu,  9 Sep 2021 21:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221247;
        bh=qZ5onl/PzZ7lphka0zgzG2OjFNhLnuUnpTjqHwG/uFg=;
        h=Date:From:To:Subject:From;
        b=G7FpBvzVEqq24RFCht4uwdorGR3pmCgw+sN+U3gAvpC+3oxYMaQAy6gj2pX1MsA8w
         1go7QqcFyJO3Gn4WoaZ+AlUP3zWHBl4Geqe5X6pLIvFYTyBqyUY41NV6ZFHRw1RORC
         Lfu+8U78tshXzzyXMaNGH8V5WKuaVCJRLc6i05UE=
Date:   Thu, 09 Sep 2021 14:00:46 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-stop-disabling-irqs-around-get_partial.patch removed from -mm tree
Message-ID: <20210909210046.f2oPvXrnJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: stop disabling irqs around get_partial()
has been removed from the -mm tree.  Its filename was
     mm-slub-stop-disabling-irqs-around-get_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: stop disabling irqs around get_partial()

The function get_partial() does not need to have irqs disabled as a whole.
It's sufficient to convert spin_lock operations to their irq
saving/restoring versions.

As a result, it's now possible to reach the page allocator from the slab
allocator without disabling and re-enabling interrupts on the way.

Link: https://lkml.kernel.org/r/20210904105003.11688-18-vbabka@suse.cz
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

 mm/slub.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/mm/slub.c~mm-slub-stop-disabling-irqs-around-get_partial
+++ a/mm/slub.c
@@ -2010,11 +2010,12 @@ static inline bool pfmemalloc_match(stru
  * Try to allocate a partial slab from a specific node.
  */
 static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
-			      struct page **ret_page, gfp_t flags)
+			      struct page **ret_page, gfp_t gfpflags)
 {
 	struct page *page, *page2;
 	void *object = NULL;
 	unsigned int available = 0;
+	unsigned long flags;
 	int objects;
 
 	/*
@@ -2026,11 +2027,11 @@ static void *get_partial_node(struct kme
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	spin_lock(&n->list_lock);
+	spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry_safe(page, page2, &n->partial, slab_list) {
 		void *t;
 
-		if (!pfmemalloc_match(page, flags))
+		if (!pfmemalloc_match(page, gfpflags))
 			continue;
 
 		t = acquire_slab(s, n, page, object == NULL, &objects);
@@ -2051,7 +2052,7 @@ static void *get_partial_node(struct kme
 			break;
 
 	}
-	spin_unlock(&n->list_lock);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	return object;
 }
 
@@ -2779,8 +2780,10 @@ new_slab:
 			local_irq_restore(flags);
 			goto reread_page;
 		}
-		if (unlikely(!slub_percpu_partial(c)))
+		if (unlikely(!slub_percpu_partial(c))) {
+			local_irq_restore(flags);
 			goto new_objects; /* stolen by an IRQ handler */
+		}
 
 		page = c->page = slub_percpu_partial(c);
 		slub_set_percpu_partial(c, page);
@@ -2789,18 +2792,9 @@ new_slab:
 		goto redo;
 	}
 
-	local_irq_save(flags);
-	if (unlikely(c->page)) {
-		local_irq_restore(flags);
-		goto reread_page;
-	}
-
 new_objects:
 
-	lockdep_assert_irqs_disabled();
-
 	freelist = get_partial(s, gfpflags, node, &page);
-	local_irq_restore(flags);
 	if (freelist)
 		goto check_new_page;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


