Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B363D8A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="guTwBqUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348B9C433C7;
	Mon, 11 Dec 2023 00:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256089;
	bh=QMY6onxJR9YpAZFM8HXNOKgtn2Kxred6WWqnWugCVVc=;
	h=Date:To:From:Subject:From;
	b=guTwBqUs2tK2XXcsbg7jG2+b/cAN59/WQqOQKxpoQyERcIktLed6m+GJA6mWVvnXy
	 xt/iOreRFnJMveO3VHEk2MMuIalXhLd/w+D95PsVMCQxN0+Z9qg4CDowA14rezJidp
	 ncu2Of0O1Pt/2pETodaOf0Fz99p2MaHh9JZf1gUQ=
Date: Sun, 10 Dec 2023 16:54:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-fix-and-clean-up-atomic-annotations.patch removed from -mm tree
Message-Id: <20231211005449.348B9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: fix and clean-up atomic annotations
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-fix-and-clean-up-atomic-annotations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: fix and clean-up atomic annotations
Date: Mon, 20 Nov 2023 18:47:05 +0100

Drop smp_load_acquire from next_pool_required in depot_init_pool, as both
depot_init_pool and the all smp_store_release's to this variable are
executed under the stack depot lock.

Also simplify and clean up comments accompanying the use of atomic
accesses in the stack depot code.

Link: https://lkml.kernel.org/r/c118ef044d8db80248d9e1f14592c72e8429e9d9.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-fix-and-clean-up-atomic-annotations
+++ a/lib/stackdepot.c
@@ -231,10 +231,10 @@ static void depot_init_pool(void **preal
 	/*
 	 * If the next pool is already initialized or the maximum number of
 	 * pools is reached, do not use the preallocated memory.
-	 * smp_load_acquire() here pairs with smp_store_release() below and
-	 * in depot_alloc_stack().
+	 * Access next_pool_required non-atomically, as there are no concurrent
+	 * write accesses to this variable.
 	 */
-	if (!smp_load_acquire(&next_pool_required))
+	if (!next_pool_required)
 		return;
 
 	/* Check if the current pool is not yet allocated. */
@@ -255,8 +255,8 @@ static void depot_init_pool(void **preal
 		 * At this point, either the next pool is initialized or the
 		 * maximum number of pools is reached. In either case, take
 		 * note that initializing another pool is not required.
-		 * This smp_store_release pairs with smp_load_acquire() above
-		 * and in stack_depot_save().
+		 * smp_store_release() pairs with smp_load_acquire() in
+		 * stack_depot_save().
 		 */
 		smp_store_release(&next_pool_required, 0);
 	}
@@ -279,7 +279,7 @@ depot_alloc_stack(unsigned long *entries
 
 		/*
 		 * Move on to the next pool.
-		 * WRITE_ONCE pairs with potential concurrent read in
+		 * WRITE_ONCE() pairs with potential concurrent read in
 		 * stack_depot_fetch().
 		 */
 		WRITE_ONCE(pool_index, pool_index + 1);
@@ -287,8 +287,8 @@ depot_alloc_stack(unsigned long *entries
 		/*
 		 * If the maximum number of pools is not reached, take note
 		 * that the next pool needs to initialized.
-		 * smp_store_release() here pairs with smp_load_acquire() in
-		 * stack_depot_save() and depot_init_pool().
+		 * smp_store_release() pairs with smp_load_acquire() in
+		 * stack_depot_save().
 		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
 			smp_store_release(&next_pool_required, 1);
@@ -329,7 +329,7 @@ static struct stack_record *depot_fetch_
 {
 	union handle_parts parts = { .handle = handle };
 	/*
-	 * READ_ONCE pairs with potential concurrent write in
+	 * READ_ONCE() pairs with potential concurrent write in
 	 * depot_alloc_stack().
 	 */
 	int pool_index_cached = READ_ONCE(pool_index);
@@ -419,8 +419,7 @@ depot_stack_handle_t __stack_depot_save(
 
 	/*
 	 * Fast path: look the stack trace up without locking.
-	 * The smp_load_acquire() here pairs with smp_store_release() to
-	 * |bucket| below.
+	 * smp_load_acquire() pairs with smp_store_release() to |bucket| below.
 	 */
 	found = find_stack(smp_load_acquire(bucket), entries, nr_entries, hash);
 	if (found)
@@ -430,8 +429,8 @@ depot_stack_handle_t __stack_depot_save(
 	 * Check if another stack pool needs to be initialized. If so, allocate
 	 * the memory now - we won't be able to do that under the lock.
 	 *
-	 * The smp_load_acquire() here pairs with smp_store_release() to
-	 * |next_pool_inited| in depot_alloc_stack() and depot_init_pool().
+	 * smp_load_acquire() pairs with smp_store_release() in
+	 * depot_alloc_stack() and depot_init_pool().
 	 */
 	if (unlikely(can_alloc && smp_load_acquire(&next_pool_required))) {
 		/*
@@ -457,8 +456,8 @@ depot_stack_handle_t __stack_depot_save(
 		if (new) {
 			new->next = *bucket;
 			/*
-			 * This smp_store_release() pairs with
-			 * smp_load_acquire() from |bucket| above.
+			 * smp_store_release() pairs with smp_load_acquire()
+			 * from |bucket| above.
 			 */
 			smp_store_release(bucket, new);
 			found = new;
_

Patches currently in -mm which might be from andreyknvl@google.com are


