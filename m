Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9B6C2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbjKTSDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbjKTSDt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:03:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB20A7
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:03:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7DFC433C7;
        Mon, 20 Nov 2023 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503425;
        bh=mGAwl6BUBDEl/2td//7SQwZJc8V74HMFgAmTde/aNok=;
        h=Date:To:From:Subject:From;
        b=a28BR93H5eRKAtpqgmsOFmO1r8ym7fluEbSKtgSxWepfgtv2lmdihg76jwKRkK+07
         jt0UqedEzVpoN6lXv5Oa94CZldBawyCJ39/Pm3bWRx85VykWAS8oqC084p6pdwDAXs
         89zKx6N2BlGzbZj6wH2pxGPlO1Us+2RfuZyNex9g=
Date:   Mon, 20 Nov 2023 10:03:45 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch added to mm-unstable branch
Message-Id: <20231120180345.8A7DFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rework helpers for depot_alloc_stack
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: rework helpers for depot_alloc_stack
Date: Mon, 20 Nov 2023 18:47:06 +0100

Split code in depot_alloc_stack and depot_init_pool into 3 functions:

1. depot_keep_next_pool that keeps preallocated memory for the next pool
   if required.

2. depot_update_pools that moves on to the next pool if there's no space
   left in the current pool, uses preallocated memory for the new current
   pool if required, and calls depot_keep_next_pool otherwise.

3. depot_alloc_stack that calls depot_update_pools and then allocates
   a stack record as before.

This makes it somewhat easier to follow the logic of depot_alloc_stack and
also serves as a preparation for implementing the eviction of stack
records from the stack depot.

Link: https://lkml.kernel.org/r/71fb144d42b701fcb46708d7f4be6801a4a8270e.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   86 +++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 37 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-rework-helpers-for-depot_alloc_stack
+++ a/lib/stackdepot.c
@@ -225,11 +225,11 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
-/* Uses preallocated memory to initialize a new stack depot pool. */
-static void depot_init_pool(void **prealloc)
+/* Keeps the preallocated memory to be used for the next stack depot pool. */
+static void depot_keep_next_pool(void **prealloc)
 {
 	/*
-	 * If the next pool is already initialized or the maximum number of
+	 * If the next pool is already saved or the maximum number of
 	 * pools is reached, do not use the preallocated memory.
 	 * Access next_pool_required non-atomically, as there are no concurrent
 	 * write accesses to this variable.
@@ -237,44 +237,34 @@ static void depot_init_pool(void **preal
 	if (!next_pool_required)
 		return;
 
-	/* Check if the current pool is not yet allocated. */
-	if (stack_pools[pool_index] == NULL) {
-		/* Use the preallocated memory for the current pool. */
-		stack_pools[pool_index] = *prealloc;
+	/*
+	 * Use the preallocated memory for the next pool
+	 * as long as we do not exceed the maximum number of pools.
+	 */
+	if (pool_index + 1 < DEPOT_MAX_POOLS) {
+		stack_pools[pool_index + 1] = *prealloc;
 		*prealloc = NULL;
-	} else {
-		/*
-		 * Otherwise, use the preallocated memory for the next pool
-		 * as long as we do not exceed the maximum number of pools.
-		 */
-		if (pool_index + 1 < DEPOT_MAX_POOLS) {
-			stack_pools[pool_index + 1] = *prealloc;
-			*prealloc = NULL;
-		}
-		/*
-		 * At this point, either the next pool is initialized or the
-		 * maximum number of pools is reached. In either case, take
-		 * note that initializing another pool is not required.
-		 * smp_store_release() pairs with smp_load_acquire() in
-		 * stack_depot_save().
-		 */
-		smp_store_release(&next_pool_required, 0);
 	}
+
+	/*
+	 * At this point, either the next pool is kept or the maximum
+	 * number of pools is reached. In either case, take note that
+	 * keeping another pool is not required.
+	 * smp_store_release() pairs with smp_load_acquire() in
+	 * stack_depot_save().
+	 */
+	smp_store_release(&next_pool_required, 0);
 }
 
-/* Allocates a new stack in a stack depot pool. */
-static struct stack_record *
-depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
+/* Updates references to the current and the next stack depot pools. */
+static bool depot_update_pools(size_t required_size, void **prealloc)
 {
-	struct stack_record *stack;
-	size_t required_size = DEPOT_STACK_RECORD_SIZE;
-
 	/* Check if there is not enough space in the current pool. */
 	if (unlikely(pool_offset + required_size > DEPOT_POOL_SIZE)) {
 		/* Bail out if we reached the pool limit. */
 		if (unlikely(pool_index + 1 >= DEPOT_MAX_POOLS)) {
 			WARN_ONCE(1, "Stack depot reached limit capacity");
-			return NULL;
+			return false;
 		}
 
 		/*
@@ -284,9 +274,10 @@ depot_alloc_stack(unsigned long *entries
 		 */
 		WRITE_ONCE(pool_index, pool_index + 1);
 		pool_offset = 0;
+
 		/*
 		 * If the maximum number of pools is not reached, take note
-		 * that the next pool needs to initialized.
+		 * that the next pool needs to be initialized.
 		 * smp_store_release() pairs with smp_load_acquire() in
 		 * stack_depot_save().
 		 */
@@ -294,9 +285,30 @@ depot_alloc_stack(unsigned long *entries
 			smp_store_release(&next_pool_required, 1);
 	}
 
-	/* Assign the preallocated memory to a pool if required. */
+	/* Check if the current pool is not yet allocated. */
+	if (*prealloc && stack_pools[pool_index] == NULL) {
+		/* Use the preallocated memory for the current pool. */
+		stack_pools[pool_index] = *prealloc;
+		*prealloc = NULL;
+		return true;
+	}
+
+	/* Otherwise, try using the preallocated memory for the next pool. */
 	if (*prealloc)
-		depot_init_pool(prealloc);
+		depot_keep_next_pool(prealloc);
+	return true;
+}
+
+/* Allocates a new stack in a stack depot pool. */
+static struct stack_record *
+depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
+{
+	struct stack_record *stack;
+	size_t required_size = DEPOT_STACK_RECORD_SIZE;
+
+	/* Update current and next pools if required and possible. */
+	if (!depot_update_pools(required_size, prealloc))
+		return NULL;
 
 	/* Check if we have a pool to save the stack trace. */
 	if (stack_pools[pool_index] == NULL)
@@ -330,7 +342,7 @@ static struct stack_record *depot_fetch_
 	union handle_parts parts = { .handle = handle };
 	/*
 	 * READ_ONCE() pairs with potential concurrent write in
-	 * depot_alloc_stack().
+	 * depot_update_pools().
 	 */
 	int pool_index_cached = READ_ONCE(pool_index);
 	void *pool;
@@ -430,7 +442,7 @@ depot_stack_handle_t __stack_depot_save(
 	 * the memory now - we won't be able to do that under the lock.
 	 *
 	 * smp_load_acquire() pairs with smp_store_release() in
-	 * depot_alloc_stack() and depot_init_pool().
+	 * depot_update_pools() and depot_keep_next_pool().
 	 */
 	if (unlikely(can_alloc && smp_load_acquire(&next_pool_required))) {
 		/*
@@ -467,7 +479,7 @@ depot_stack_handle_t __stack_depot_save(
 		 * Stack depot already contains this stack trace, but let's
 		 * keep the preallocated memory for the future.
 		 */
-		depot_init_pool(&prealloc);
+		depot_keep_next_pool(&prealloc);
 	}
 
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch
lib-stackdepot-check-disabled-flag-when-fetching.patch
lib-stackdepot-simplify-__stack_depot_save.patch
lib-stackdepot-drop-valid-bit-from-handles.patch
lib-stackdepot-add-depot_fetch_stack-helper.patch
lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch
lib-stackdepot-fix-and-clean-up-atomic-annotations.patch
lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch
lib-stackdepot-store-next-pool-pointer-in-new_pool.patch
lib-stackdepot-store-free-stack-records-in-a-freelist.patch
lib-stackdepot-use-read-write-lock.patch
lib-stackdepot-use-list_head-for-stack-record-links.patch
kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch
lib-stackdepot-kasan-add-flags-to-__stack_depot_save-and-rename.patch
lib-stackdepot-add-refcount-for-records.patch
lib-stackdepot-allow-users-to-evict-stack-traces.patch
kasan-remove-atomic-accesses-to-stack-ring-entries.patch
kasan-check-object_size-in-kasan_complete_mode_report_info.patch
kasan-use-stack_depot_put-for-tag-based-modes.patch
kasan-use-stack_depot_put-for-generic-mode.patch
lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch

