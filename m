Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDF6C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700ED610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbhIBVwU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347585AbhIBVwM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 166C5610A0;
        Thu,  2 Sep 2021 21:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619470;
        bh=iKCL9t0AJsfDaMp0Ws7YcAd+H0Cv9uhzY7W0KmNhbHw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bJzqmpFANgMV6CxS9B1aPbtX0wzAZav5Zx3i/9mAek5LFBYMFOqbUG7/mfzY8chLc
         BiSDldvjMGZTOK8Z4p+IaRei7nYyfyUpWcvGuZf7PLu0NSwKKd2qrvd0fdZch1suoR
         ASeT5x9s0c1MjiEF6dEpwIIWlYvzEbiC8aRa3x2s=
Date:   Thu, 02 Sep 2021 14:51:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 023/212] mm, slub: restore irqs around calling
 new_slab()
Message-ID: <20210902215109.3qZclyA0Y%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: restore irqs around calling new_slab()

allocate_slab() currently re-enables irqs before calling to the page
allocator.  It depends on gfpflags_allow_blocking() to determine if it's
safe to do so.  Now we can instead simply restore irq before calling it
through new_slab().  The other caller early_kmem_cache_node_alloc() is
unaffected by this.

Link: https://lkml.kernel.org/r/20210805152000.12817-16-vbabka@suse.cz
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

 mm/slub.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-restore-irqs-around-calling-new_slab
+++ a/mm/slub.c
@@ -1795,9 +1795,6 @@ static struct page *allocate_slab(struct
 
 	flags &= gfp_allowed_mask;
 
-	if (gfpflags_allow_blocking(flags))
-		local_irq_enable();
-
 	flags |= s->allocflags;
 
 	/*
@@ -1856,8 +1853,6 @@ static struct page *allocate_slab(struct
 	page->frozen = 1;
 
 out:
-	if (gfpflags_allow_blocking(flags))
-		local_irq_disable();
 	if (!page)
 		return NULL;
 
@@ -2798,16 +2793,17 @@ new_objects:
 		goto check_new_page;
 	}
 
+	local_irq_restore(flags);
 	put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
 	c = get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!page)) {
-		local_irq_restore(flags);
 		slab_out_of_memory(s, gfpflags, node);
 		return NULL;
 	}
 
+	local_irq_save(flags);
 	if (c->page)
 		flush_slab(s, c);
 
_
