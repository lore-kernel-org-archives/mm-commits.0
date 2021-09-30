Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42390C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11CF061A50
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347892AbhI3UeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347824AbhI3UeG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:34:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B24DB61994;
        Thu, 30 Sep 2021 20:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633033943;
        bh=0/euYZKEkxk4v9x2Rb1qG/zGpq4KrcO4dIzGNxQ1b+U=;
        h=Date:From:To:Subject:From;
        b=Xqmsxw5uWAJPLcbB7SCMEGWm8fssGMNbf794FbVUMKqJb52Q1Jl+/CLv65qn3kLoN
         8T3eC0vC13yP1Z5GItC9W/6ivvuJTDrwi4xv4WGIGKn5E0Vm9c1XB33A5vmLXsvI9J
         3ag6qD8NcvWvwR/b7iVgFWbnhFX0+vVs5zxom4Vk=
Date:   Thu, 30 Sep 2021 13:32:23 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org
Subject:  + kfence-shorten-critical-sections-of-alloc-free.patch
 added to -mm tree
Message-ID: <20210930203223.hNlqVlcry%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: shorten critical sections of alloc/free
has been added to the -mm tree.  Its filename is
     kfence-shorten-critical-sections-of-alloc-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-shorten-critical-sections-of-alloc-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-shorten-critical-sections-of-alloc-free.patch

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
Subject: kfence: shorten critical sections of alloc/free

Initializing memory and setting/checking the canary bytes is relatively
expensive, and doing so in the meta->lock critical sections extends the
duration with preemption and interrupts disabled unnecessarily.

Any reads to meta->addr and meta->size in kfence_guarded_alloc() and
kfence_guarded_free() don't require locking meta->lock as long as the
object is removed from the freelist: only kfence_guarded_alloc() sets
meta->addr and meta->size after removing it from the freelist, which
requires a preceding kfence_guarded_free() returning it to the list or the
initial state.

Therefore move reads to meta->addr and meta->size, including expensive
memory initialization using them, out of meta->lock critical sections.

Link: https://lkml.kernel.org/r/20210930153706.2105471-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/mm/kfence/core.c~kfence-shorten-critical-sections-of-alloc-free
+++ a/mm/kfence/core.c
@@ -309,12 +309,19 @@ static inline bool set_canary_byte(u8 *a
 /* Check canary byte at @addr. */
 static inline bool check_canary_byte(u8 *addr)
 {
+	struct kfence_metadata *meta;
+	unsigned long flags;
+
 	if (likely(*addr == KFENCE_CANARY_PATTERN(addr)))
 		return true;
 
 	atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-	kfence_report_error((unsigned long)addr, false, NULL, addr_to_metadata((unsigned long)addr),
-			    KFENCE_ERROR_CORRUPTION);
+
+	meta = addr_to_metadata((unsigned long)addr);
+	raw_spin_lock_irqsave(&meta->lock, flags);
+	kfence_report_error((unsigned long)addr, false, NULL, meta, KFENCE_ERROR_CORRUPTION);
+	raw_spin_unlock_irqrestore(&meta->lock, flags);
+
 	return false;
 }
 
@@ -324,8 +331,6 @@ static __always_inline void for_each_can
 	const unsigned long pageaddr = ALIGN_DOWN(meta->addr, PAGE_SIZE);
 	unsigned long addr;
 
-	lockdep_assert_held(&meta->lock);
-
 	/*
 	 * We'll iterate over each canary byte per-side until fn() returns
 	 * false. However, we'll still iterate over the canary bytes to the
@@ -414,8 +419,9 @@ static void *kfence_guarded_alloc(struct
 	WRITE_ONCE(meta->cache, cache);
 	meta->size = size;
 	meta->alloc_stack_hash = alloc_stack_hash;
+	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
-	for_each_canary(meta, set_canary_byte);
+	alloc_covered_add(alloc_stack_hash, 1);
 
 	/* Set required struct page fields. */
 	page = virt_to_page(meta->addr);
@@ -425,11 +431,8 @@ static void *kfence_guarded_alloc(struct
 	if (IS_ENABLED(CONFIG_SLAB))
 		page->s_mem = addr;
 
-	raw_spin_unlock_irqrestore(&meta->lock, flags);
-
-	alloc_covered_add(alloc_stack_hash, 1);
-
 	/* Memory initialization. */
+	for_each_canary(meta, set_canary_byte);
 
 	/*
 	 * We check slab_want_init_on_alloc() ourselves, rather than letting
@@ -454,6 +457,7 @@ static void kfence_guarded_free(void *ad
 {
 	struct kcsan_scoped_access assert_page_exclusive;
 	unsigned long flags;
+	bool init;
 
 	raw_spin_lock_irqsave(&meta->lock, flags);
 
@@ -481,6 +485,13 @@ static void kfence_guarded_free(void *ad
 		meta->unprotected_page = 0;
 	}
 
+	/* Mark the object as freed. */
+	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
+	init = slab_want_init_on_free(meta->cache);
+	raw_spin_unlock_irqrestore(&meta->lock, flags);
+
+	alloc_covered_add(meta->alloc_stack_hash, -1);
+
 	/* Check canary bytes for memory corruption. */
 	for_each_canary(meta, check_canary_byte);
 
@@ -489,16 +500,9 @@ static void kfence_guarded_free(void *ad
 	 * data is still there, and after a use-after-free is detected, we
 	 * unprotect the page, so the data is still accessible.
 	 */
-	if (!zombie && unlikely(slab_want_init_on_free(meta->cache)))
+	if (!zombie && unlikely(init))
 		memzero_explicit(addr, meta->size);
 
-	/* Mark the object as freed. */
-	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
-
-	raw_spin_unlock_irqrestore(&meta->lock, flags);
-
-	alloc_covered_add(meta->alloc_stack_hash, -1);
-
 	/* Protect to detect use-after-frees. */
 	kfence_protect((unsigned long)addr);
 
_

Patches currently in -mm which might be from elver@google.com are

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
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch
kfence-add-note-to-documentation-about-skipping-covered-allocations.patch
kfence-test-use-kunit_skip-to-skip-tests.patch
kfence-shorten-critical-sections-of-alloc-free.patch

