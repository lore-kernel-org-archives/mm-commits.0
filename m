Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1197C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B88661108
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347443AbhIHCy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347489AbhIHCyo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F0961101;
        Wed,  8 Sep 2021 02:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069615;
        bh=bGD5jqjEQEWalfnYwXjrfClLGcSSZEVLqvsi7jJwfNY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YniceeCiEDf9+CwRhD2raUjiaiDOZ4IGRKzjxAlHE0dkiiEoy6atJmLm/PNixNHTU
         TujIvFS79KHz1I6Zfc7aAQYtrpOzE1s10VCsDcruHuHUsUbro7IqNmetSd3Zg8EH/F
         5AViUugywlzC5BY//SqSSzSzRHYglk3YI6LWoNis=
Date:   Tue, 07 Sep 2021 19:53:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 012/147] mm, slub: do initial checks in
 ___slab_alloc() with irqs enabled
Message-ID: <20210908025334.gWOTJ7sxW%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: do initial checks in ___slab_alloc() with irqs enabled

As another step of shortening irq disabled sections in ___slab_alloc(),
delay disabling irqs until we pass the initial checks if there is a cached
percpu slab and it's suitable for our allocation.

Now we have to recheck c->page after actually disabling irqs as an
allocation in irq handler might have replaced it.

Because we call pfmemalloc_match() as one of the checks, we might hit
VM_BUG_ON_PAGE(!PageSlab(page)) in PageSlabPfmemalloc in case we get
interrupted and the page is freed.  Thus introduce a
pfmemalloc_match_unsafe() variant that lacks the PageSlab check.

Link: https://lkml.kernel.org/r/20210904105003.11688-13-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    9 +++++
 mm/slub.c                  |   54 +++++++++++++++++++++++++++++------
 2 files changed, 54 insertions(+), 9 deletions(-)

--- a/include/linux/page-flags.h~mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled
+++ a/include/linux/page-flags.h
@@ -815,6 +815,15 @@ static inline int PageSlabPfmemalloc(str
 	return PageActive(page);
 }
 
+/*
+ * A version of PageSlabPfmemalloc() for opportunistic checks where the page
+ * might have been freed under us and not be a PageSlab anymore.
+ */
+static inline int __PageSlabPfmemalloc(struct page *page)
+{
+	return PageActive(page);
+}
+
 static inline void SetPageSlabPfmemalloc(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageSlab(page), page);
--- a/mm/slub.c~mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled
+++ a/mm/slub.c
@@ -2621,6 +2621,19 @@ static inline bool pfmemalloc_match(stru
 }
 
 /*
+ * A variant of pfmemalloc_match() that tests page flags without asserting
+ * PageSlab. Intended for opportunistic checks before taking a lock and
+ * rechecking that nobody else freed the page under us.
+ */
+static inline bool pfmemalloc_match_unsafe(struct page *page, gfp_t gfpflags)
+{
+	if (unlikely(__PageSlabPfmemalloc(page)))
+		return gfp_pfmemalloc_allowed(gfpflags);
+
+	return true;
+}
+
+/*
  * Check the page->freelist of a page and either transfer the freelist to the
  * per cpu freelist or deactivate the page.
  *
@@ -2682,8 +2695,9 @@ static void *___slab_alloc(struct kmem_c
 
 	stat(s, ALLOC_SLOWPATH);
 
-	local_irq_save(flags);
-	page = c->page;
+reread_page:
+
+	page = READ_ONCE(c->page);
 	if (!page) {
 		/*
 		 * if the node is not online or has no normal memory, just
@@ -2692,6 +2706,11 @@ static void *___slab_alloc(struct kmem_c
 		if (unlikely(node != NUMA_NO_NODE &&
 			     !node_isset(node, slab_nodes)))
 			node = NUMA_NO_NODE;
+		local_irq_save(flags);
+		if (unlikely(c->page)) {
+			local_irq_restore(flags);
+			goto reread_page;
+		}
 		goto new_slab;
 	}
 redo:
@@ -2706,8 +2725,7 @@ redo:
 			goto redo;
 		} else {
 			stat(s, ALLOC_NODE_MISMATCH);
-			deactivate_slab(s, page, c->freelist, c);
-			goto new_slab;
+			goto deactivate_slab;
 		}
 	}
 
@@ -2716,12 +2734,15 @@ redo:
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
-		deactivate_slab(s, page, c->freelist, c);
-		goto new_slab;
-	}
+	if (unlikely(!pfmemalloc_match_unsafe(page, gfpflags)))
+		goto deactivate_slab;
 
-	/* must check again c->freelist in case of cpu migration or IRQ */
+	/* must check again c->page in case IRQ handler changed it */
+	local_irq_save(flags);
+	if (unlikely(page != c->page)) {
+		local_irq_restore(flags);
+		goto reread_page;
+	}
 	freelist = c->freelist;
 	if (freelist)
 		goto load_freelist;
@@ -2737,6 +2758,9 @@ redo:
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
+
+	lockdep_assert_irqs_disabled();
+
 	/*
 	 * freelist is pointing to the list of objects to be used.
 	 * page is pointing to the page from which the objects are obtained.
@@ -2748,11 +2772,23 @@ load_freelist:
 	local_irq_restore(flags);
 	return freelist;
 
+deactivate_slab:
+
+	local_irq_save(flags);
+	if (page != c->page) {
+		local_irq_restore(flags);
+		goto reread_page;
+	}
+	deactivate_slab(s, page, c->freelist, c);
+
 new_slab:
 
+	lockdep_assert_irqs_disabled();
+
 	if (slub_percpu_partial(c)) {
 		page = c->page = slub_percpu_partial(c);
 		slub_set_percpu_partial(c, page);
+		local_irq_restore(flags);
 		stat(s, CPU_PARTIAL_ALLOC);
 		goto redo;
 	}
_
