Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9732FEE0207
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjIMT26 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjIMT2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:28:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA53219BF
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:28:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76963C433C8;
        Wed, 13 Sep 2023 19:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633329;
        bh=WMP6ZfNdXYYBVmQ7EJHoWvb5widtTx9vmRamPqW7aeY=;
        h=Date:To:From:Subject:From;
        b=Qa7AsWHVEYRUgVl1WFeAseOyt4DrU8lWawx6ilVgKCGWMPF1qGX0wUtpMu5nKISVO
         s8sdAUAjjG0NH9ULZD0rSjC/Pgg7focVcQHHnIpLMJy0pQKAPYQAbMNjT5RPJa3MXR
         KJ8uiO7m6HOrIaYwnbK3w+5erK2+xVID+vJY5EEA=
Date:   Wed, 13 Sep 2023 12:28:48 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch added to mm-unstable branch
Message-Id: <20230913192849.76963C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename next_pool_required to new_pool_required
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch

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
Subject: lib/stackdepot: rename next_pool_required to new_pool_required
Date: Wed, 13 Sep 2023 19:14:33 +0200

Rename next_pool_required to new_pool_required.

This a purely code readability change: the following patch will change
stack depot to store the pointer to the new pool in a separate variable,
and "new" seems like a more logical name.

Link: https://lkml.kernel.org/r/e074fa3f4962897b84afb3d65767f5fc3b5d1234.1694625260.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-rename-next_pool_required-to-new_pool_required
+++ a/lib/stackdepot.c
@@ -93,12 +93,11 @@ static size_t pool_offset;
 static DEFINE_RAW_SPINLOCK(pool_lock);
 /*
  * Stack depot tries to keep an extra pool allocated even before it runs out
- * of space in the currently used pool.
- * This flag marks that this next extra pool needs to be allocated and
- * initialized. It has the value 0 when either the next pool is not yet
- * initialized or the limit on the number of pools is reached.
+ * of space in the currently used pool. This flag marks whether this extra pool
+ * needs to be allocated. It has the value 0 when either an extra pool is not
+ * yet allocated or if the limit on the number of pools is reached.
  */
-static int next_pool_required = 1;
+static int new_pool_required = 1;
 
 static int __init disable_stack_depot(char *str)
 {
@@ -219,18 +218,18 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
-/* Keeps the preallocated memory to be used for the next stack depot pool. */
-static void depot_keep_next_pool(void **prealloc)
+/* Keeps the preallocated memory to be used for a new stack depot pool. */
+static void depot_keep_new_pool(void **prealloc)
 {
 	/*
-	 * If the next pool is already saved or the maximum number of
+	 * If a new pool is already saved or the maximum number of
 	 * pools is reached, do not use the preallocated memory.
 	 */
 	if (!next_pool_required)
 		return;
 
 	/*
-	 * Use the preallocated memory for the next pool
+	 * Use the preallocated memory for the new pool
 	 * as long as we do not exceed the maximum number of pools.
 	 */
 	if (pool_index + 1 < DEPOT_MAX_POOLS) {
@@ -239,12 +238,12 @@ static void depot_keep_next_pool(void **
 	}
 
 	/*
-	 * At this point, either the next pool is kept or the maximum
+	 * At this point, either a new pool is kept or the maximum
 	 * number of pools is reached. In either case, take note that
 	 * keeping another pool is not required.
 	 * smp_store_release pairs with smp_load_acquire in stack_depot_save.
 	 */
-	smp_store_release(&next_pool_required, 0);
+	smp_store_release(&new_pool_required, 0);
 }
 
 /* Updates refences to the current and the next stack depot pools. */
@@ -259,7 +258,7 @@ static bool depot_update_pools(size_t re
 		}
 
 		/*
-		 * Move on to the next pool.
+		 * Move on to the new pool.
 		 * WRITE_ONCE pairs with potential concurrent read in
 		 * stack_depot_fetch.
 		 */
@@ -268,12 +267,12 @@ static bool depot_update_pools(size_t re
 
 		/*
 		 * If the maximum number of pools is not reached, take note
-		 * that the next pool needs to be initialized.
+		 * that yet another new pool needs to be allocated.
 		 * smp_store_release pairs with smp_load_acquire in
 		 * stack_depot_save.
 		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
-			smp_store_release(&next_pool_required, 1);
+			smp_store_release(&new_pool_required, 1);
 	}
 
 	/* Check if the current pool is not yet allocated. */
@@ -284,9 +283,9 @@ static bool depot_update_pools(size_t re
 		return true;
 	}
 
-	/* Otherwise, try using the preallocated memory for the next pool. */
+	/* Otherwise, try using the preallocated memory for a new pool. */
 	if (*prealloc)
-		depot_keep_next_pool(prealloc);
+		depot_keep_new_pool(prealloc);
 	return true;
 }
 
@@ -297,7 +296,7 @@ depot_alloc_stack(unsigned long *entries
 	struct stack_record *stack;
 	size_t required_size = DEPOT_STACK_RECORD_SIZE;
 
-	/* Update current and next pools if required and possible. */
+	/* Update current and new pools if required and possible. */
 	if (!depot_update_pools(required_size, prealloc))
 		return NULL;
 
@@ -429,13 +428,13 @@ depot_stack_handle_t __stack_depot_save(
 		goto exit;
 
 	/*
-	 * Check if another stack pool needs to be initialized. If so, allocate
-	 * the memory now - we won't be able to do that under the lock.
+	 * Check if another stack pool needs to be allocated. If so, allocate
+	 * the memory now: we won't be able to do that under the lock.
 	 *
 	 * smp_load_acquire pairs with smp_store_release in depot_update_pools
-	 * and depot_keep_next_pool.
+	 * and depot_keep_new_pool.
 	 */
-	if (unlikely(can_alloc && smp_load_acquire(&next_pool_required))) {
+	if (unlikely(can_alloc && smp_load_acquire(&new_pool_required))) {
 		/*
 		 * Zero out zone modifiers, as we don't have specific zone
 		 * requirements. Keep the flags related to allocation in atomic
@@ -468,9 +467,9 @@ depot_stack_handle_t __stack_depot_save(
 	} else if (prealloc) {
 		/*
 		 * Stack depot already contains this stack trace, but let's
-		 * keep the preallocated memory for the future.
+		 * keep the preallocated memory for future.
 		 */
-		depot_keep_next_pool(&prealloc);
+		depot_keep_new_pool(&prealloc);
 	}
 
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
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

