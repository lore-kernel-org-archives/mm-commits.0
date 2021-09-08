Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E755C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161DF61130
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbhIHCy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347506AbhIHCy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AAE1610C9;
        Wed,  8 Sep 2021 02:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069599;
        bh=ucRSdMMTvY12qn/Y46LNJm6dtoS1vB0uv8zlgp2hxmo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sAIYCe2rjNJEsq1ZIBNfR5RCO28B588BTRXOtnTC8CPiStlOXBG5whoSGoRlI7Jmg
         lK4XB4nBTQzkcKuAENZZHlqJVW1o2UdX6V+Ubgvb/GDXyRoM6BnXAiKUSkxhqrlYgP
         qN038yIv6XEyMWzTXLNgwovJiFfUo1vPfV2v0kuw=
Date:   Tue, 07 Sep 2021 19:53:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 007/147] mm, slub: dissolve new_slab_objects()
 into ___slab_alloc()
Message-ID: <20210908025318.0a_jq6Ci5%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: dissolve new_slab_objects() into ___slab_alloc()

The later patches will need more fine grained control over individual
actions in ___slab_alloc(), the only caller of new_slab_objects(), so
dissolve it there.  This is a preparatory step with no functional change.

The only minor change is moving WARN_ON_ONCE() for using a constructor
together with __GFP_ZERO to new_slab(), which makes it somewhat less
frequent, but still able to catch a development change introducing a
systematic misuse.

Link: https://lkml.kernel.org/r/20210904105003.11688-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
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

 mm/slub.c |   50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

--- a/mm/slub.c~mm-slub-dissolve-new_slab_objects-into-___slab_alloc
+++ a/mm/slub.c
@@ -1885,6 +1885,8 @@ static struct page *new_slab(struct kmem
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
 
+	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
+
 	return allocate_slab(s,
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 }
@@ -2610,36 +2612,6 @@ slab_out_of_memory(struct kmem_cache *s,
 #endif
 }
 
-static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
-			int node, struct kmem_cache_cpu **pc)
-{
-	void *freelist = NULL;
-	struct kmem_cache_cpu *c = *pc;
-	struct page *page;
-
-	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
-
-	page = new_slab(s, flags, node);
-	if (page) {
-		c = raw_cpu_ptr(s->cpu_slab);
-		if (c->page)
-			flush_slab(s, c);
-
-		/*
-		 * No other reference to the page yet so we can
-		 * muck around with it freely without cmpxchg
-		 */
-		freelist = page->freelist;
-		page->freelist = NULL;
-
-		stat(s, ALLOC_SLAB);
-		c->page = page;
-		*pc = c;
-	}
-
-	return freelist;
-}
-
 static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags)
 {
 	if (unlikely(PageSlabPfmemalloc(page)))
@@ -2786,13 +2758,27 @@ new_slab:
 	if (freelist)
 		goto check_new_page;
 
-	freelist = new_slab_objects(s, gfpflags, node, &c);
+	page = new_slab(s, gfpflags, node);
 
-	if (unlikely(!freelist)) {
+	if (unlikely(!page)) {
 		slab_out_of_memory(s, gfpflags, node);
 		return NULL;
 	}
 
+	c = raw_cpu_ptr(s->cpu_slab);
+	if (c->page)
+		flush_slab(s, c);
+
+	/*
+	 * No other reference to the page yet so we can
+	 * muck around with it freely without cmpxchg
+	 */
+	freelist = page->freelist;
+	page->freelist = NULL;
+
+	stat(s, ALLOC_SLAB);
+	c->page = page;
+
 check_new_page:
 	page = c->page;
 	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
_
