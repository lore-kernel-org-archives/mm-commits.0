Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43E9C5AD4C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbjKTSDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbjKTSDr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:03:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3128FA7
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:03:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EC8C433C8;
        Mon, 20 Nov 2023 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503423;
        bh=imGH4ObGf08AjHcC29LWLzfUQaBcMI87MxElRMxQ30U=;
        h=Date:To:From:Subject:From;
        b=J4NOpXG0GIgYcguzxWtnU7PflVYMbqKV1VI2OCpYroBs9rM3vixcsfXcTMvBl0aUI
         O0VCiLCq5PR//QZwGWPJUY8dhg8UvR+IXDS4/tOK/0XipU+H9c5yjk08RGdzXKCfA0
         d9KZrQ3x2BcVTNdV0so+XkCm6lP0nQ+6VDOBV5is=
Date:   Mon, 20 Nov 2023 10:03:43 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-fix-and-clean-up-atomic-annotations.patch added to mm-unstable branch
Message-Id: <20231120180343.C1EC8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: fix and clean-up atomic annotations
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-fix-and-clean-up-atomic-annotations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-fix-and-clean-up-atomic-annotations.patch

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

