Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C23C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C21A60F6F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhIWXcM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 19:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235628AbhIWXcM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 19:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD7C86124C;
        Thu, 23 Sep 2021 23:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632439840;
        bh=uK8JHExYvUWb1+7wimGpNjDuoPcuCx/KXTmnfvgaMg0=;
        h=Date:From:To:Subject:From;
        b=sZLEAiWyJ611CsfK502Shmp4WIJUGSjePyxKrzLkFz8s9C0TWoL7YcHDcOOQ6C0DF
         5E/3edgtxz4wAhHgQXTEt2Gl4KnUgp94+/Wtx0v5qA5cNV1oVP/rJD9vUkQzszad0R
         bDhuhhxeiJvdgYUCkQQjB/Mv2O+G+lgCiYK8Bt58=
Date:   Thu, 23 Sep 2021 16:30:39 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  + kfence-count-unexpectedly-skipped-allocations.patch
 added to -mm tree
Message-ID: <20210923233039.GiesyQmNk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: count unexpectedly skipped allocations
has been added to the -mm tree.  Its filename is
     kfence-count-unexpectedly-skipped-allocations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-count-unexpectedly-skipped-allocations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-count-unexpectedly-skipped-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from elver@google.com are

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
lib-stackdepot-include-gfph.patch
lib-stackdepot-remove-unused-function-argument.patch
lib-stackdepot-introduce-__stack_depot_save.patch
kasan-common-provide-can_alloc-in-kasan_save_stack.patch
kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
mm-fix-data-race-in-pagepoisoned.patch
stacktrace-move-filter_irq_stacks-to-kernel-stacktracec.patch
kfence-count-unexpectedly-skipped-allocations.patch
kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full.patch
kfence-add-note-to-documentation-about-skipping-covered-allocations.patch

