Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48432C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358816135A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhKEUsJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E746136F;
        Fri,  5 Nov 2021 20:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145128;
        bh=YW4baP5h7WgOWo6IqXQTCxde/fSUi9MZWni9ucF3ZcU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2kUUrmnjmqQgrniWzu+3YhFDF0ATUZiYIzMeVhFTeIydpNwBUHYooH2emrOoWGhuF
         hSjtKE8Yt24TuOIeFR6Biacw9W1jIRn3T+PnV480CHLnsYFgYWBLUF9WY58DTf305q
         n40S2ZfcImRyUuyyVKR8F1l7jvvfucXnMkDAMKDU=
Date:   Fri, 05 Nov 2021 13:45:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com, torvalds@linux-foundation.org
Subject:  [patch 206/262] kfence: count unexpectedly skipped
 allocations
Message-ID: <20211105204528.1mF27G-Uh%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence: count unexpectedly skipped allocations

Maintain a counter to count allocations that are skipped due to being
incompatible (oversized, incompatible gfp flags) or no capacity.

This is to compute the fraction of allocations that could not be serviced
by KFENCE, which we expect to be rare.

Link: https://lkml.kernel.org/r/20210923104803.2620285-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c~kfence-count-unexpectedly-skipped-allocations
+++ a/mm/kfence/core.c
@@ -112,6 +112,8 @@ enum kfence_counter_id {
 	KFENCE_COUNTER_FREES,
 	KFENCE_COUNTER_ZOMBIES,
 	KFENCE_COUNTER_BUGS,
+	KFENCE_COUNTER_SKIP_INCOMPAT,
+	KFENCE_COUNTER_SKIP_CAPACITY,
 	KFENCE_COUNTER_COUNT,
 };
 static atomic_long_t counters[KFENCE_COUNTER_COUNT];
@@ -121,6 +123,8 @@ static const char *const counter_names[]
 	[KFENCE_COUNTER_FREES]		= "total frees",
 	[KFENCE_COUNTER_ZOMBIES]	= "zombie allocations",
 	[KFENCE_COUNTER_BUGS]		= "total bugs",
+	[KFENCE_COUNTER_SKIP_INCOMPAT]	= "skipped allocations (incompatible)",
+	[KFENCE_COUNTER_SKIP_CAPACITY]	= "skipped allocations (capacity)",
 };
 static_assert(ARRAY_SIZE(counter_names) == KFENCE_COUNTER_COUNT);
 
@@ -271,8 +275,10 @@ static void *kfence_guarded_alloc(struct
 		list_del_init(&meta->list);
 	}
 	raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
-	if (!meta)
+	if (!meta) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_CAPACITY]);
 		return NULL;
+	}
 
 	if (unlikely(!raw_spin_trylock_irqsave(&meta->lock, flags))) {
 		/*
@@ -740,8 +746,10 @@ void *__kfence_alloc(struct kmem_cache *
 	 * Perform size check before switching kfence_allocation_gate, so that
 	 * we don't disable KFENCE without making an allocation.
 	 */
-	if (size > PAGE_SIZE)
+	if (size > PAGE_SIZE) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;
+	}
 
 	/*
 	 * Skip allocations from non-default zones, including DMA. We cannot
@@ -749,8 +757,10 @@ void *__kfence_alloc(struct kmem_cache *
 	 * properties (e.g. reside in DMAable memory).
 	 */
 	if ((flags & GFP_ZONEMASK) ||
-	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
+	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32))) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;
+	}
 
 	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
_
