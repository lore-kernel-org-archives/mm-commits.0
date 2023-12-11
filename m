Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AE13D8A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6A2jPop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EDFC433C8;
	Mon, 11 Dec 2023 00:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256090;
	bh=Qu9ap9qRpRLQlLXZA6jRlez9dM/QQW3c4PtxvR4B9Fo=;
	h=Date:To:From:Subject:From;
	b=D6A2jPopLqqeLLSgxCCRj41Sy4Bx8BddNrlYbVRrYJzfavPRdEZr9c49GR0X9vajA
	 licuQX4NLZzl9Bsqzjzm4HASdRf72YXCLwXGiRqqARsUvaZpEQgLRy0307D5rHXDlh
	 DoK6ht+Ms1ReY5/IyTXFwSydB92XHElxzzUDr48I=
Date: Sun, 10 Dec 2023 16:54:49 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch removed from -mm tree
Message-Id: <20231211005450.70EDFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: rework helpers for depot_alloc_stack
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


