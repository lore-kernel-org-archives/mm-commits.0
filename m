Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0F9C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147B9611B0
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbhIWXcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 19:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235628AbhIWXcO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 19:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF56560F6F;
        Thu, 23 Sep 2021 23:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632439842;
        bh=SViQi0fAD5PRTBwxf3CbIQfQXOrICerpEInVSF+VaQM=;
        h=Date:From:To:Subject:From;
        b=nd/DcBpF9P67jJJNoaNgzShHv9KFXf6p9rYva3ZbHeqmKgY2dQ/FF75tkzi7uXGS6
         KpIQQjS+pNkvZS3UiW9N/I/QMlOgTTf7su6hoQQhk5TOjtvWJCvr24eJ/HSHt8Uq/M
         9QYYABCFx3E9PuJF6Rmf485x9dYF8qcjDZoCeyVs=
Date:   Thu, 23 Sep 2021 16:30:41 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  +
 kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch
 added to -mm tree
Message-ID: <20210923233041.zrXpNiY0Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: move saving stack trace of allocations into __kfence_alloc()
has been added to the -mm tree.  Its filename is
     kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch

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
Subject: kfence: move saving stack trace of allocations into __kfence_alloc()

Move the saving of the stack trace of allocations into __kfence_alloc(),
so that the stack entries array can be used outside of
kfence_guarded_alloc() and we avoid potentially unwinding the stack
multiple times.

Link: https://lkml.kernel.org/r/20210923104803.2620285-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

--- a/mm/kfence/core.c~kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc
+++ a/mm/kfence/core.c
@@ -187,19 +187,26 @@ static inline unsigned long metadata_to_
  * Update the object's metadata state, including updating the alloc/free stacks
  * depending on the state transition.
  */
-static noinline void metadata_update_state(struct kfence_metadata *meta,
-					   enum kfence_object_state next)
+static noinline void
+metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state next,
+		      unsigned long *stack_entries, size_t num_stack_entries)
 {
 	struct kfence_track *track =
 		next == KFENCE_OBJECT_FREED ? &meta->free_track : &meta->alloc_track;
 
 	lockdep_assert_held(&meta->lock);
 
-	/*
-	 * Skip over 1 (this) functions; noinline ensures we do not accidentally
-	 * skip over the caller by never inlining.
-	 */
-	track->num_stack_entries = stack_trace_save(track->stack_entries, KFENCE_STACK_DEPTH, 1);
+	if (stack_entries) {
+		memcpy(track->stack_entries, stack_entries,
+		       num_stack_entries * sizeof(stack_entries[0]));
+	} else {
+		/*
+		 * Skip over 1 (this) functions; noinline ensures we do not
+		 * accidentally skip over the caller by never inlining.
+		 */
+		num_stack_entries = stack_trace_save(track->stack_entries, KFENCE_STACK_DEPTH, 1);
+	}
+	track->num_stack_entries = num_stack_entries;
 	track->pid = task_pid_nr(current);
 	track->cpu = raw_smp_processor_id();
 	track->ts_nsec = local_clock(); /* Same source as printk timestamps. */
@@ -261,7 +268,8 @@ static __always_inline void for_each_can
 	}
 }
 
-static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t gfp)
+static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t gfp,
+				  unsigned long *stack_entries, size_t num_stack_entries)
 {
 	struct kfence_metadata *meta = NULL;
 	unsigned long flags;
@@ -320,7 +328,7 @@ static void *kfence_guarded_alloc(struct
 	addr = (void *)meta->addr;
 
 	/* Update remaining metadata. */
-	metadata_update_state(meta, KFENCE_OBJECT_ALLOCATED);
+	metadata_update_state(meta, KFENCE_OBJECT_ALLOCATED, stack_entries, num_stack_entries);
 	/* Pairs with READ_ONCE() in kfence_shutdown_cache(). */
 	WRITE_ONCE(meta->cache, cache);
 	meta->size = size;
@@ -400,7 +408,7 @@ static void kfence_guarded_free(void *ad
 		memzero_explicit(addr, meta->size);
 
 	/* Mark the object as freed. */
-	metadata_update_state(meta, KFENCE_OBJECT_FREED);
+	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
 
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
@@ -742,6 +750,9 @@ void kfence_shutdown_cache(struct kmem_c
 
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
+	unsigned long stack_entries[KFENCE_STACK_DEPTH];
+	size_t num_stack_entries;
+
 	/*
 	 * Perform size check before switching kfence_allocation_gate, so that
 	 * we don't disable KFENCE without making an allocation.
@@ -786,7 +797,9 @@ void *__kfence_alloc(struct kmem_cache *
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
 
-	return kfence_guarded_alloc(s, size, flags);
+	num_stack_entries = stack_trace_save(stack_entries, KFENCE_STACK_DEPTH, 0);
+
+	return kfence_guarded_alloc(s, size, flags, stack_entries, num_stack_entries);
 }
 
 size_t kfence_ksize(const void *addr)
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

