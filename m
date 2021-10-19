Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E464C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5042D6134F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhJSVo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhJSVo4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C7961052;
        Tue, 19 Oct 2021 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679763;
        bh=8Y6hh/3riPCkiMBa1rNFadiYs50Rqn8R9VtlsIhvqA4=;
        h=Date:From:To:Subject:From;
        b=N+ecdGoHddd7Ue+LjWfamRSADTw5LgvMhk+KQSWFiItP00Krw0dEA2AR9fTIFWPQL
         NxHb9DNqALiii6NqeJq7kQoj8WOKCGfL4f/FPTpIMMgDSXE/s9Gm9JT7de0piXmcCw
         K6KoZ+vzYsNkJ41PPfjqHUYa1/9yrqGVvyXth5Fs=
Date:   Tue, 19 Oct 2021 14:42:42 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org
Subject:  +
 kfence-always-use-static-branches-to-guard-kfence_alloc.patch added to -mm
 tree
Message-ID: <20211019214242.Ip0Mo1qj_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: always use static branches to guard kfence_alloc()
has been added to the -mm tree.  Its filename is
     kfence-always-use-static-branches-to-guard-kfence_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-always-use-static-branches-to-guard-kfence_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-always-use-static-branches-to-guard-kfence_alloc.patch

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
Subject: kfence: always use static branches to guard kfence_alloc()

Regardless of KFENCE mode (CONFIG_KFENCE_STATIC_KEYS: either using static
keys to gate allocations, or using a simple dynamic branch), always use a
static branch to avoid the dynamic branch in kfence_alloc() if KFENCE was
disabled at boot.

For CONFIG_KFENCE_STATIC_KEYS=n, this now avoids the dynamic branch if
KFENCE was disabled at boot.

To simplify, also unifies the location where kfence_allocation_gate is
read-checked to just be inline in kfence_alloc().

Link: https://lkml.kernel.org/r/20211019102524.2807208-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |   21 +++++++++++----------
 mm/kfence/core.c       |   16 +++++++---------
 2 files changed, 18 insertions(+), 19 deletions(-)

--- a/include/linux/kfence.h~kfence-always-use-static-branches-to-guard-kfence_alloc
+++ a/include/linux/kfence.h
@@ -14,6 +14,9 @@
 
 #ifdef CONFIG_KFENCE
 
+#include <linux/atomic.h>
+#include <linux/static_key.h>
+
 /*
  * We allocate an even number of pages, as it simplifies calculations to map
  * address to metadata indices; effectively, the very first page serves as an
@@ -22,13 +25,8 @@
 #define KFENCE_POOL_SIZE ((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE)
 extern char *__kfence_pool;
 
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-#include <linux/static_key.h>
 DECLARE_STATIC_KEY_FALSE(kfence_allocation_key);
-#else
-#include <linux/atomic.h>
 extern atomic_t kfence_allocation_gate;
-#endif
 
 /**
  * is_kfence_address() - check if an address belongs to KFENCE pool
@@ -116,13 +114,16 @@ void *__kfence_alloc(struct kmem_cache *
  */
 static __always_inline void *kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-	if (static_branch_unlikely(&kfence_allocation_key))
+#if defined(CONFIG_KFENCE_STATIC_KEYS) || CONFIG_KFENCE_SAMPLE_INTERVAL == 0
+	if (!static_branch_unlikely(&kfence_allocation_key))
+		return NULL;
 #else
-	if (unlikely(!atomic_read(&kfence_allocation_gate)))
+	if (!static_branch_likely(&kfence_allocation_key))
+		return NULL;
 #endif
-		return __kfence_alloc(s, size, flags);
-	return NULL;
+	if (likely(atomic_read(&kfence_allocation_gate)))
+		return NULL;
+	return __kfence_alloc(s, size, flags);
 }
 
 /**
--- a/mm/kfence/core.c~kfence-always-use-static-branches-to-guard-kfence_alloc
+++ a/mm/kfence/core.c
@@ -104,10 +104,11 @@ struct kfence_metadata kfence_metadata[C
 static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
 static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
 
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-/* The static key to set up a KFENCE allocation. */
+/*
+ * The static key to set up a KFENCE allocation; or if static keys are not used
+ * to gate allocations, to avoid a load and compare if KFENCE is disabled.
+ */
 DEFINE_STATIC_KEY_FALSE(kfence_allocation_key);
-#endif
 
 /* Gates the allocation, ensuring only one succeeds in a given period. */
 atomic_t kfence_allocation_gate = ATOMIC_INIT(1);
@@ -774,6 +775,8 @@ void __init kfence_init(void)
 		return;
 	}
 
+	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
+		static_branch_enable(&kfence_allocation_key);
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
@@ -866,12 +869,7 @@ void *__kfence_alloc(struct kmem_cache *
 		return NULL;
 	}
 
-	/*
-	 * allocation_gate only needs to become non-zero, so it doesn't make
-	 * sense to continue writing to it and pay the associated contention
-	 * cost, in case we have a large number of concurrent allocations.
-	 */
-	if (atomic_read(&kfence_allocation_gate) || atomic_inc_return(&kfence_allocation_gate) > 1)
+	if (atomic_inc_return(&kfence_allocation_gate) > 1)
 		return NULL;
 #ifdef CONFIG_KFENCE_STATIC_KEYS
 	/*
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
kfence-always-use-static-branches-to-guard-kfence_alloc.patch
kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch

