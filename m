From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix-2.patch
 removed from -mm tree
Date: Fri, 25 Mar 2016 14:15:04 -0700
Message-ID: <56f5aa58.RMx/L8LhFT9rxG1t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbcCYVPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 17:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix-2
has been removed from the -mm tree.  Its filename was
     mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix-2.patch

This patch was dropped because it was folded into mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject:  mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix-2

Comments style fixes.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN lib/stackdepot.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix-2 lib/stackdepot.c
--- a/lib/stackdepot.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix-2
+++ a/lib/stackdepot.c
@@ -81,7 +81,8 @@ static bool init_stack_slab(void **preal
 {
 	if (!*prealloc)
 		return false;
-	/* This smp_load_acquire() pairs with smp_store_release() to
+	/*
+	 * This smp_load_acquire() pairs with smp_store_release() to
 	 * |next_slab_inited| below and in depot_alloc_stack().
 	 */
 	if (smp_load_acquire(&next_slab_inited))
@@ -90,7 +91,8 @@ static bool init_stack_slab(void **preal
 		stack_slabs[depot_index] = *prealloc;
 	} else {
 		stack_slabs[depot_index + 1] = *prealloc;
-		/* This smp_store_release pairs with smp_load_acquire() from
+		/*
+		 * This smp_store_release pairs with smp_load_acquire() from
 		 * |next_slab_inited| above and in depot_save_stack().
 		 */
 		smp_store_release(&next_slab_inited, 1);
@@ -116,7 +118,8 @@ static struct stack_record *depot_alloc_
 		}
 		depot_index++;
 		depot_offset = 0;
-		/* smp_store_release() here pairs with smp_load_acquire() from
+		/*
+		 * smp_store_release() here pairs with smp_load_acquire() from
 		 * |next_slab_inited| in depot_save_stack() and
 		 * init_stack_slab().
 		 */
@@ -186,7 +189,7 @@ void depot_fetch_stack(depot_stack_handl
 	trace->skip = 0;
 }
 
-/*
+/**
  * depot_save_stack - save stack in a stack depot.
  * @trace - the stacktrace to save.
  * @alloc_flags - flags for allocating additional memory if required.
@@ -213,8 +216,8 @@ depot_stack_handle_t depot_save_stack(st
 
 	bucket = &stack_table[hash & STACK_HASH_MASK];
 
-	/* Fast path: look the stack trace up without locking.
-	 *
+	/*
+	 * Fast path: look the stack trace up without locking.
 	 * The smp_load_acquire() here pairs with smp_store_release() to
 	 * |bucket| below.
 	 */
@@ -223,7 +226,8 @@ depot_stack_handle_t depot_save_stack(st
 	if (found)
 		goto exit;
 
-	/* Check if the current or the next stack slab need to be initialized.
+	/*
+	 * Check if the current or the next stack slab need to be initialized.
 	 * If so, allocate the memory - we won't be able to do that under the
 	 * lock.
 	 *
@@ -231,7 +235,8 @@ depot_stack_handle_t depot_save_stack(st
 	 * |next_slab_inited| in depot_alloc_stack() and init_stack_slab().
 	 */
 	if (unlikely(!smp_load_acquire(&next_slab_inited))) {
-		/* Zero out zone modifiers, as we don't have specific zone
+		/*
+		 * Zero out zone modifiers, as we don't have specific zone
 		 * requirements. Keep the flags related to allocation in atomic
 		 * contexts and I/O.
 		 */
@@ -251,7 +256,8 @@ depot_stack_handle_t depot_save_stack(st
 					  hash, &prealloc, alloc_flags);
 		if (new) {
 			new->next = *bucket;
-			/* This smp_store_release() pairs with
+			/*
+			 * This smp_store_release() pairs with
 			 * smp_load_acquire() from |bucket| above.
 			 */
 			smp_store_release(bucket, new);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch
maintainers-fill-entries-for-kasan.patch

