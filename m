Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22046C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A574610F7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347565AbhIBVvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhIBVvn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CACE0610E9;
        Thu,  2 Sep 2021 21:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619444;
        bh=O5D/xhKxJ2TH9c1z6DYdrLS2jmbPfm9L9oqykMdUpSw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xlmHsvlcs3tbe50FgXlhSJsMuWpeVuUQuIKNm+NpjozTNwnExEJ+TkM/38cWJaJTk
         xR36CFZpP4I/k9isHTfNrMLlpDwXFAgNvJEJfwPzReTAachJLMw9j3DThgFGDkuX6y
         9sL9fz7CSMzL56PmiC8oFI3rrnVUbrHh/K6OCZGQ=
Date:   Thu, 02 Sep 2021 14:50:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 015/212] mm, slub: extract get_partial() from
 new_slab_objects()
Message-ID: <20210902215043.OYw-zC-0A%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: extract get_partial() from new_slab_objects()

The later patches will need more fine grained control over individual
actions in ___slab_alloc(), the only caller of new_slab_objects(), so this
is a first preparatory step with no functional change.

This adds a goto label that appears unnecessary at this point, but will be
useful for later changes.

Link: https://lkml.kernel.org/r/20210805152000.12817-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
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

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-extract-get_partial-from-new_slab_objects
+++ a/mm/slub.c
@@ -2599,17 +2599,12 @@ slab_out_of_memory(struct kmem_cache *s,
 static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
 			int node, struct kmem_cache_cpu **pc)
 {
-	void *freelist;
+	void *freelist = NULL;
 	struct kmem_cache_cpu *c = *pc;
 	struct page *page;
 
 	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
 
-	freelist = get_partial(s, flags, node, c);
-
-	if (freelist)
-		return freelist;
-
 	page = new_slab(s, flags, node);
 	if (page) {
 		c = raw_cpu_ptr(s->cpu_slab);
@@ -2773,6 +2768,10 @@ new_slab:
 		goto redo;
 	}
 
+	freelist = get_partial(s, gfpflags, node, c);
+	if (freelist)
+		goto check_new_page;
+
 	freelist = new_slab_objects(s, gfpflags, node, &c);
 
 	if (unlikely(!freelist)) {
@@ -2780,6 +2779,7 @@ new_slab:
 		return NULL;
 	}
 
+check_new_page:
 	page = c->page;
 	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
 		goto load_freelist;
_
