Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB19C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 170BF6124B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348329AbhIXUCZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348328AbhIXUCZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A90F461038;
        Fri, 24 Sep 2021 20:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632513651;
        bh=pDWW1thxElOa3QBQZER8/7ESB5x65yGsj+sC2XazeTI=;
        h=Date:From:To:Subject:From;
        b=jT3C/7N+6pKZJe/8VN32mdxBbCbX5n3Xc7A+hNPKHxIVyAz5HGahfsrrjibV9gE1w
         5sELHUSi5rcPnDwhiRyj80ulzTvcSEQCaNv8Uf0V6nZzY5MTg87aUZEXCWTGH28o95
         QIKQ/pFGbJ67o1R1WVzfw+9KhuIt1wgQzEM7eSQg=
Date:   Fri, 24 Sep 2021 13:00:51 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  +
 kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch
 added to -mm tree
Message-ID: <20210924200051.HUXk_iKsU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix
has been added to the -mm tree.  Its filename is
     kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch

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
Subject: kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix

* Simplify and just use hash_32().
* Use more random stack_hash_seed.

Link: https://lkml.kernel.org/r/YU3MRGaCaJiYht5g@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/kfence/core.c~kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix
+++ a/mm/kfence/core.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
+#include <linux/hash.h>
 #include <linux/irq_work.h>
 #include <linux/jhash.h>
 #include <linux/kcsan-checks.h>
@@ -122,14 +123,21 @@ atomic_t kfence_allocation_gate = ATOMIC
  *	P(alloc_traces) = (1 - e^(-HNUM * (alloc_traces / SIZE)) ^ HNUM
  */
 #define ALLOC_COVERED_HNUM	2
-#define ALLOC_COVERED_SIZE	(1 << (const_ilog2(CONFIG_KFENCE_NUM_OBJECTS) + 2))
-#define ALLOC_COVERED_HNEXT(h)	(1664525 * (h) + 1013904223)
+#define ALLOC_COVERED_ORDER	(const_ilog2(CONFIG_KFENCE_NUM_OBJECTS) + 2)
+#define ALLOC_COVERED_SIZE	(1 << ALLOC_COVERED_ORDER)
+#define ALLOC_COVERED_HNEXT(h)	hash_32(h, ALLOC_COVERED_ORDER)
 #define ALLOC_COVERED_MASK	(ALLOC_COVERED_SIZE - 1)
 static atomic_t alloc_covered[ALLOC_COVERED_SIZE];
 
 /* Stack depth used to determine uniqueness of an allocation. */
 #define UNIQUE_ALLOC_STACK_DEPTH 8UL
 
+/*
+ * Randomness for stack hashes, making the same collisions across reboots and
+ * different machines less likely.
+ */
+static u32 stack_hash_seed __ro_after_init;
+
 /* Statistics counters for debugfs. */
 enum kfence_counter_id {
 	KFENCE_COUNTER_ALLOCATED,
@@ -166,12 +174,9 @@ static inline bool should_skip_covered(v
 
 static u32 get_alloc_stack_hash(unsigned long *stack_entries, size_t num_entries)
 {
-	/* Some randomness across reboots / different machines. */
-	u32 seed = (u32)((unsigned long)__kfence_pool >> (BITS_PER_LONG - 32));
-
 	num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
 	num_entries = filter_irq_stacks(stack_entries, num_entries);
-	return jhash(stack_entries, num_entries * sizeof(stack_entries[0]), seed);
+	return jhash(stack_entries, num_entries * sizeof(stack_entries[0]), stack_hash_seed);
 }
 
 /*
@@ -759,6 +764,7 @@ void __init kfence_init(void)
 	if (!kfence_sample_interval)
 		return;
 
+	stack_hash_seed = (u32)random_get_entropy();
 	if (!kfence_init_pool()) {
 		pr_err("%s failed\n", __func__);
 		return;
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
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch
kfence-add-note-to-documentation-about-skipping-covered-allocations.patch
kfence-test-use-kunit_skip-to-skip-tests.patch

