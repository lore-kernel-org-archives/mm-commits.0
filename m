Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A662EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjIMT3K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbjIMT3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:29:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952FB1BEC
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:28:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29420C433C7;
        Wed, 13 Sep 2023 19:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633338;
        bh=VeidDBJqCaQ3LLVs3YaB4vyvhAH20U9j8aex+ATooOg=;
        h=Date:To:From:Subject:From;
        b=ASgnu31kdJMjCffXgRoTIdTWyQRQ2AeSyF3ide0Nr/cmZs4KwUFF4aNa14FIUIKv6
         +FYFbRr/cjW0cfS7CjyiZr6oeEJvPA0WR6UIgIxpTFNOs4BWEyM/i7tjs3ENDfazu2
         /vo5SORNN+y/a9OJxBUQx8V6LedP6myIc9E7cSwE=
Date:   Wed, 13 Sep 2023 12:28:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-use-read-write-lock.patch added to mm-unstable branch
Message-Id: <20230913192858.29420C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: use read/write lock
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-use-read-write-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-use-read-write-lock.patch

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
Subject: lib/stackdepot: use read/write lock
Date: Wed, 13 Sep 2023 19:14:36 +0200

Currently, stack depot uses the following locking scheme:

1. Lock-free accesses when looking up a stack record, which allows to
   have multiple users to look up records in parallel;
2. Spinlock for protecting the stack depot pools and the hash table
   when adding a new record.

For implementing the eviction of stack traces from stack depot, the
lock-free approach is not going to work anymore, as we will need to be
able to also remove records from the hash table.

Convert the spinlock into a read/write lock, and drop the atomic accesses,
as they are no longer required.

Looking up stack traces is now protected by the read lock and adding new
records - by the write lock.  One of the following patches will add a new
function for evicting stack records, which will be protected by the write
lock as well.

With this change, multiple users can still look up records in parallel.

This is preparatory patch for implementing the eviction of stack records
from the stack depot.

Link: https://lkml.kernel.org/r/5c5eca8a53ea53352794de57c87440ec509c9bbc.1694625260.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   86 ++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-use-read-write-lock
+++ a/lib/stackdepot.c
@@ -23,6 +23,7 @@
 #include <linux/percpu.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/stacktrace.h>
 #include <linux/stackdepot.h>
 #include <linux/string.h>
@@ -91,15 +92,15 @@ static void *new_pool;
 static int pools_num;
 /* Next stack in the freelist of stack records within stack_pools. */
 static struct stack_record *next_stack;
-/* Lock that protects the variables above. */
-static DEFINE_RAW_SPINLOCK(pool_lock);
 /*
  * Stack depot tries to keep an extra pool allocated even before it runs out
  * of space in the currently used pool. This flag marks whether this extra pool
  * needs to be allocated. It has the value 0 when either an extra pool is not
  * yet allocated or if the limit on the number of pools is reached.
  */
-static int new_pool_required = 1;
+static bool new_pool_required = true;
+/* Lock that protects the variables above. */
+static DEFINE_RWLOCK(pool_rwlock);
 
 static int __init disable_stack_depot(char *str)
 {
@@ -226,6 +227,8 @@ static void depot_init_pool(void *pool)
 	const int records_in_pool = DEPOT_POOL_SIZE / DEPOT_STACK_RECORD_SIZE;
 	int i, offset;
 
+	lockdep_assert_held_write(&pool_rwlock);
+
 	/* Initialize handles and link stack records to each other. */
 	for (i = 0, offset = 0;
 	     offset <= DEPOT_POOL_SIZE - DEPOT_STACK_RECORD_SIZE;
@@ -248,22 +251,19 @@ static void depot_init_pool(void *pool)
 
 	/* Save reference to the pool to be used by depot_fetch_stack. */
 	stack_pools[pools_num] = pool;
-
-	/*
-	 * WRITE_ONCE pairs with potential concurrent read in
-	 * depot_fetch_stack.
-	 */
-	WRITE_ONCE(pools_num, pools_num + 1);
+	pools_num++;
 }
 
 /* Keeps the preallocated memory to be used for a new stack depot pool. */
 static void depot_keep_new_pool(void **prealloc)
 {
+	lockdep_assert_held_write(&pool_rwlock);
+
 	/*
 	 * If a new pool is already saved or the maximum number of
 	 * pools is reached, do not use the preallocated memory.
 	 */
-	if (!next_pool_required)
+	if (!new_pool_required)
 		return;
 
 	/*
@@ -279,14 +279,15 @@ static void depot_keep_new_pool(void **p
 	 * At this point, either a new pool is kept or the maximum
 	 * number of pools is reached. In either case, take note that
 	 * keeping another pool is not required.
-	 * smp_store_release pairs with smp_load_acquire in stack_depot_save.
 	 */
-	smp_store_release(&new_pool_required, 0);
+	new_pool_required = false;
 }
 
 /* Updates refences to the current and the next stack depot pools. */
 static bool depot_update_pools(void **prealloc)
 {
+	lockdep_assert_held_write(&pool_rwlock);
+
 	/* Check if we still have objects in the freelist. */
 	if (next_stack)
 		goto out_keep_prealloc;
@@ -298,7 +299,7 @@ static bool depot_update_pools(void **pr
 
 		/* Take note that we might need a new new_pool. */
 		if (pools_num < DEPOT_MAX_POOLS)
-			smp_store_release(&new_pool_required, 1);
+			new_pool_required = true;
 
 		/* Try keeping the preallocated memory for new_pool. */
 		goto out_keep_prealloc;
@@ -332,6 +333,8 @@ depot_alloc_stack(unsigned long *entries
 {
 	struct stack_record *stack;
 
+	lockdep_assert_held_write(&pool_rwlock);
+
 	/* Update current and new pools if required and possible. */
 	if (!depot_update_pools(prealloc))
 		return NULL;
@@ -367,18 +370,15 @@ depot_alloc_stack(unsigned long *entries
 static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 {
 	union handle_parts parts = { .handle = handle };
-	/*
-	 * READ_ONCE pairs with potential concurrent write in
-	 * depot_init_pool.
-	 */
-	int pools_num_cached = READ_ONCE(pools_num);
 	void *pool;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
-	if (parts.pool_index > pools_num_cached) {
+	lockdep_assert_held(&pool_rwlock);
+
+	if (parts.pool_index > pools_num) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
-		     parts.pool_index, pools_num_cached, handle);
+		     parts.pool_index, pools_num, handle);
 		return NULL;
 	}
 
@@ -420,6 +420,8 @@ static inline struct stack_record *find_
 {
 	struct stack_record *found;
 
+	lockdep_assert_held(&pool_rwlock);
+
 	for (found = bucket; found; found = found->next) {
 		if (found->hash == hash &&
 		    found->size == size &&
@@ -437,6 +439,7 @@ depot_stack_handle_t __stack_depot_save(
 	depot_stack_handle_t handle = 0;
 	struct page *page = NULL;
 	void *prealloc = NULL;
+	bool need_alloc = false;
 	unsigned long flags;
 	u32 hash;
 
@@ -456,22 +459,26 @@ depot_stack_handle_t __stack_depot_save(
 	hash = hash_stack(entries, nr_entries);
 	bucket = &stack_table[hash & stack_hash_mask];
 
-	/*
-	 * Fast path: look the stack trace up without locking.
-	 * smp_load_acquire pairs with smp_store_release to |bucket| below.
-	 */
-	found = find_stack(smp_load_acquire(bucket), entries, nr_entries, hash);
-	if (found)
+	read_lock_irqsave(&pool_rwlock, flags);
+
+	/* Fast path: look the stack trace up without full locking. */
+	found = find_stack(*bucket, entries, nr_entries, hash);
+	if (found) {
+		read_unlock_irqrestore(&pool_rwlock, flags);
 		goto exit;
+	}
+
+	/* Take note if another stack pool needs to be allocated. */
+	if (new_pool_required)
+		need_alloc = true;
+
+	read_unlock_irqrestore(&pool_rwlock, flags);
 
 	/*
-	 * Check if another stack pool needs to be allocated. If so, allocate
-	 * the memory now: we won't be able to do that under the lock.
-	 *
-	 * smp_load_acquire pairs with smp_store_release in depot_update_pools
-	 * and depot_keep_new_pool.
+	 * Allocate memory for a new pool if required now:
+	 * we won't be able to do that under the lock.
 	 */
-	if (unlikely(can_alloc && smp_load_acquire(&new_pool_required))) {
+	if (unlikely(can_alloc && need_alloc)) {
 		/*
 		 * Zero out zone modifiers, as we don't have specific zone
 		 * requirements. Keep the flags related to allocation in atomic
@@ -485,7 +492,7 @@ depot_stack_handle_t __stack_depot_save(
 			prealloc = page_address(page);
 	}
 
-	raw_spin_lock_irqsave(&pool_lock, flags);
+	write_lock_irqsave(&pool_rwlock, flags);
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
@@ -494,11 +501,7 @@ depot_stack_handle_t __stack_depot_save(
 
 		if (new) {
 			new->next = *bucket;
-			/*
-			 * smp_store_release pairs with smp_load_acquire
-			 * from |bucket| above.
-			 */
-			smp_store_release(bucket, new);
+			*bucket = new;
 			found = new;
 		}
 	} else if (prealloc) {
@@ -509,7 +512,7 @@ depot_stack_handle_t __stack_depot_save(
 		depot_keep_new_pool(&prealloc);
 	}
 
-	raw_spin_unlock_irqrestore(&pool_lock, flags);
+	write_unlock_irqrestore(&pool_rwlock, flags);
 exit:
 	if (prealloc) {
 		/* Stack depot didn't use this memory, free it. */
@@ -533,6 +536,7 @@ unsigned int stack_depot_fetch(depot_sta
 			       unsigned long **entries)
 {
 	struct stack_record *stack;
+	unsigned long flags;
 
 	*entries = NULL;
 	/*
@@ -544,8 +548,12 @@ unsigned int stack_depot_fetch(depot_sta
 	if (!handle || stack_depot_disabled)
 		return 0;
 
+	read_lock_irqsave(&pool_rwlock, flags);
+
 	stack = depot_fetch_stack(handle);
 
+	read_unlock_irqrestore(&pool_rwlock, flags);
+
 	*entries = stack->entries;
 	return stack->size;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

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

