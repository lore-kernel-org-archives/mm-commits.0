Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42033468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BnTUi4kB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D82BC433C7;
	Mon, 11 Dec 2023 00:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256094;
	bh=gM7+79tJwlJda9abcAuYF5GaENWV4VFdGMQntYKw6q4=;
	h=Date:To:From:Subject:From;
	b=BnTUi4kBJjsng1b3NvSDqDNESkz8h8PsF9KzizgMLrDFy6Kbbe7NTg7gYTuVKlwNh
	 9I8mwbccezFaMSp0gLK6+UoNX+s4RnU2Aajb1ea2awt8CJzdoDWffakdkWEvF+GIAk
	 cfPRQUGOiI82+vy+tqrG9BQIIsI16hHBdiZQcWRU=
Date: Sun, 10 Dec 2023 16:54:53 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-store-free-stack-records-in-a-freelist.patch removed from -mm tree
Message-Id: <20231211005454.0D82BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: store free stack records in a freelist
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-store-free-stack-records-in-a-freelist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: store free stack records in a freelist
Date: Mon, 20 Nov 2023 18:47:09 +0100

Instead of using the global pool_offset variable to find a free slot when
storing a new stack record, mainlain a freelist of free slots within the
allocated stack pools.

A global next_stack variable is used as the head of the freelist, and the
next field in the stack_record struct is reused as freelist link (when the
record is not in the freelist, this field is used as a link in the hash
table).

This is preparatory patch for implementing the eviction of stack records
from the stack depot.

Link: https://lkml.kernel.org/r/b9e4c79955c2121b69301778643b203d3fb09ccc.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |  133 ++++++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 50 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-store-free-stack-records-in-a-freelist
+++ a/lib/stackdepot.c
@@ -54,8 +54,8 @@ union handle_parts {
 };
 
 struct stack_record {
-	struct stack_record *next;	/* Link in the hash table */
-	u32 hash;			/* Hash in the hash table */
+	struct stack_record *next;	/* Link in hash table or freelist */
+	u32 hash;			/* Hash in hash table */
 	u32 size;			/* Number of stored frames */
 	union handle_parts handle;
 	unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
@@ -87,10 +87,10 @@ static unsigned int stack_hash_mask;
 static void *stack_pools[DEPOT_MAX_POOLS];
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
-/* Currently used pool in stack_pools. */
-static int pool_index;
-/* Offset to the unused space in the currently used pool. */
-static size_t pool_offset;
+/* Number of pools in stack_pools. */
+static int pools_num;
+/* Next stack in the freelist of stack records within stack_pools. */
+static struct stack_record *next_stack;
 /* Lock that protects the variables above. */
 static DEFINE_RAW_SPINLOCK(pool_lock);
 /*
@@ -226,6 +226,42 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
+/* Initializes a stack depol pool. */
+static void depot_init_pool(void *pool)
+{
+	const int records_in_pool = DEPOT_POOL_SIZE / DEPOT_STACK_RECORD_SIZE;
+	int i, offset;
+
+	/* Initialize handles and link stack records to each other. */
+	for (i = 0, offset = 0;
+	     offset <= DEPOT_POOL_SIZE - DEPOT_STACK_RECORD_SIZE;
+	     i++, offset += DEPOT_STACK_RECORD_SIZE) {
+		struct stack_record *stack = pool + offset;
+
+		stack->handle.pool_index = pools_num;
+		stack->handle.offset = offset >> DEPOT_STACK_ALIGN;
+		stack->handle.extra = 0;
+
+		if (i < records_in_pool - 1)
+			stack->next = (void *)stack + DEPOT_STACK_RECORD_SIZE;
+		else
+			stack->next = NULL;
+	}
+
+	/* Link stack records into the freelist. */
+	WARN_ON(next_stack);
+	next_stack = pool;
+
+	/* Save reference to the pool to be used by depot_fetch_stack(). */
+	stack_pools[pools_num] = pool;
+
+	/*
+	 * WRITE_ONCE() pairs with potential concurrent read in
+	 * depot_fetch_stack().
+	 */
+	WRITE_ONCE(pools_num, pools_num + 1);
+}
+
 /* Keeps the preallocated memory to be used for a new stack depot pool. */
 static void depot_keep_new_pool(void **prealloc)
 {
@@ -242,7 +278,7 @@ static void depot_keep_new_pool(void **p
 	 * Use the preallocated memory for the new pool
 	 * as long as we do not exceed the maximum number of pools.
 	 */
-	if (pool_index + 1 < DEPOT_MAX_POOLS) {
+	if (pools_num < DEPOT_MAX_POOLS) {
 		new_pool = *prealloc;
 		*prealloc = NULL;
 	}
@@ -258,45 +294,42 @@ static void depot_keep_new_pool(void **p
 }
 
 /* Updates references to the current and the next stack depot pools. */
-static bool depot_update_pools(size_t required_size, void **prealloc)
+static bool depot_update_pools(void **prealloc)
 {
-	/* Check if there is not enough space in the current pool. */
-	if (unlikely(pool_offset + required_size > DEPOT_POOL_SIZE)) {
-		/* Bail out if we reached the pool limit. */
-		if (unlikely(pool_index + 1 >= DEPOT_MAX_POOLS)) {
-			WARN_ONCE(1, "Stack depot reached limit capacity");
-			return false;
-		}
-
-		/*
-		 * Move on to the new pool.
-		 * WRITE_ONCE() pairs with potential concurrent read in
-		 * stack_depot_fetch().
-		 */
-		WRITE_ONCE(pool_index, pool_index + 1);
-		stack_pools[pool_index] = new_pool;
+	/* Check if we still have objects in the freelist. */
+	if (next_stack)
+		goto out_keep_prealloc;
+
+	/* Check if we have a new pool saved and use it. */
+	if (new_pool) {
+		depot_init_pool(new_pool);
 		new_pool = NULL;
-		pool_offset = 0;
 
-		/*
-		 * If the maximum number of pools is not reached, take note
-		 * that yet another new pool needs to be allocated.
-		 * smp_store_release() pairs with smp_load_acquire() in
-		 * stack_depot_save().
-		 */
-		if (pool_index + 1 < DEPOT_MAX_POOLS)
+		/* Take note that we might need a new new_pool. */
+		if (pools_num < DEPOT_MAX_POOLS)
 			smp_store_release(&new_pool_required, 1);
+
+		/* Try keeping the preallocated memory for new_pool. */
+		goto out_keep_prealloc;
 	}
 
-	/* Check if the current pool is not yet allocated. */
-	if (*prealloc && stack_pools[pool_index] == NULL) {
-		/* Use the preallocated memory for the current pool. */
-		stack_pools[pool_index] = *prealloc;
+	/* Bail out if we reached the pool limit. */
+	if (unlikely(pools_num >= DEPOT_MAX_POOLS)) {
+		WARN_ONCE(1, "Stack depot reached limit capacity");
+		return false;
+	}
+
+	/* Check if we have preallocated memory and use it. */
+	if (*prealloc) {
+		depot_init_pool(*prealloc);
 		*prealloc = NULL;
 		return true;
 	}
 
-	/* Otherwise, try using the preallocated memory for a new pool. */
+	return false;
+
+out_keep_prealloc:
+	/* Keep the preallocated memory for a new pool if required. */
 	if (*prealloc)
 		depot_keep_new_pool(prealloc);
 	return true;
@@ -307,35 +340,35 @@ static struct stack_record *
 depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
 	struct stack_record *stack;
-	size_t required_size = DEPOT_STACK_RECORD_SIZE;
 
 	/* Update current and new pools if required and possible. */
-	if (!depot_update_pools(required_size, prealloc))
+	if (!depot_update_pools(prealloc))
 		return NULL;
 
-	/* Check if we have a pool to save the stack trace. */
-	if (stack_pools[pool_index] == NULL)
+	/* Check if we have a stack record to save the stack trace. */
+	stack = next_stack;
+	if (!stack)
 		return NULL;
 
+	/* Advance the freelist. */
+	next_stack = stack->next;
+
 	/* Limit number of saved frames to CONFIG_STACKDEPOT_MAX_FRAMES. */
 	if (size > CONFIG_STACKDEPOT_MAX_FRAMES)
 		size = CONFIG_STACKDEPOT_MAX_FRAMES;
 
 	/* Save the stack trace. */
-	stack = stack_pools[pool_index] + pool_offset;
+	stack->next = NULL;
 	stack->hash = hash;
 	stack->size = size;
-	stack->handle.pool_index = pool_index;
-	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
-	stack->handle.extra = 0;
+	/* stack->handle is already filled in by depot_init_pool(). */
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
-	pool_offset += required_size;
 
 	/*
 	 * Let KMSAN know the stored stack record is initialized. This shall
 	 * prevent false positive reports if instrumented code accesses it.
 	 */
-	kmsan_unpoison_memory(stack, required_size);
+	kmsan_unpoison_memory(stack, DEPOT_STACK_RECORD_SIZE);
 
 	return stack;
 }
@@ -345,16 +378,16 @@ static struct stack_record *depot_fetch_
 	union handle_parts parts = { .handle = handle };
 	/*
 	 * READ_ONCE() pairs with potential concurrent write in
-	 * depot_update_pools().
+	 * depot_init_pool().
 	 */
-	int pool_index_cached = READ_ONCE(pool_index);
+	int pools_num_cached = READ_ONCE(pools_num);
 	void *pool;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
-	if (parts.pool_index > pool_index_cached) {
+	if (parts.pool_index > pools_num_cached) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
-		     parts.pool_index, pool_index_cached, handle);
+		     parts.pool_index, pools_num_cached, handle);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


