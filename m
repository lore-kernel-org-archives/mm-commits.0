Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C68EE020F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjIMT2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjIMT2s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:28:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449EAB7
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:28:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D261BC433C7;
        Wed, 13 Sep 2023 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633323;
        bh=mOjeC8bCodBBOhfTw0vPNF+sIFSmXyNtsl6yo1aIwS4=;
        h=Date:To:From:Subject:From;
        b=VsatUaN6q4ByIVXiCz4naM7b/CCDRtu7IZbKzaCFFGgu+0aoopBwa8IiW4olsEr5m
         g2C4QWoK04Ne1TkXU3HuEqpiT7LnmPEdZh9X8DWsyYxzfs5UHMupXnf9I9bujhTKHk
         VTBSq8jUoCJimhYgbZigabl01JKUSHdZxSVqo6z8=
Date:   Wed, 13 Sep 2023 12:28:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-fix-and-clean-up-atomic-annotations.patch added to mm-unstable branch
Message-Id: <20230913192843.D261BC433C7@smtp.kernel.org>
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
Date: Wed, 13 Sep 2023 19:14:31 +0200

Simplify comments accompanying the use of atomic accesses in the stack
depot code.

Also drop smp_load_acquire from next_pool_required in depot_init_pool, as
both depot_init_pool and the all smp_store_release's to this variable are
executed under the stack depot lock.

Link: https://lkml.kernel.org/r/e78360a883edac7bc3c6a351c99a6019beacf264.1694625260.git.andreyknvl@google.com
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

 lib/stackdepot.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-fix-and-clean-up-atomic-annotations
+++ a/lib/stackdepot.c
@@ -225,10 +225,8 @@ static void depot_init_pool(void **preal
 	/*
 	 * If the next pool is already initialized or the maximum number of
 	 * pools is reached, do not use the preallocated memory.
-	 * smp_load_acquire() here pairs with smp_store_release() below and
-	 * in depot_alloc_stack().
 	 */
-	if (!smp_load_acquire(&next_pool_required))
+	if (!next_pool_required)
 		return;
 
 	/* Check if the current pool is not yet allocated. */
@@ -249,8 +247,8 @@ static void depot_init_pool(void **preal
 		 * At this point, either the next pool is initialized or the
 		 * maximum number of pools is reached. In either case, take
 		 * note that initializing another pool is not required.
-		 * This smp_store_release pairs with smp_load_acquire() above
-		 * and in stack_depot_save().
+		 * smp_store_release pairs with smp_load_acquire in
+		 * stack_depot_save.
 		 */
 		smp_store_release(&next_pool_required, 0);
 	}
@@ -274,15 +272,15 @@ depot_alloc_stack(unsigned long *entries
 		/*
 		 * Move on to the next pool.
 		 * WRITE_ONCE pairs with potential concurrent read in
-		 * stack_depot_fetch().
+		 * stack_depot_fetch.
 		 */
 		WRITE_ONCE(pool_index, pool_index + 1);
 		pool_offset = 0;
 		/*
 		 * If the maximum number of pools is not reached, take note
 		 * that the next pool needs to initialized.
-		 * smp_store_release() here pairs with smp_load_acquire() in
-		 * stack_depot_save() and depot_init_pool().
+		 * smp_store_release pairs with smp_load_acquire in
+		 * stack_depot_save.
 		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
 			smp_store_release(&next_pool_required, 1);
@@ -324,7 +322,7 @@ static struct stack_record *depot_fetch_
 	union handle_parts parts = { .handle = handle };
 	/*
 	 * READ_ONCE pairs with potential concurrent write in
-	 * depot_alloc_stack().
+	 * depot_alloc_stack.
 	 */
 	int pool_index_cached = READ_ONCE(pool_index);
 	void *pool;
@@ -413,8 +411,7 @@ depot_stack_handle_t __stack_depot_save(
 
 	/*
 	 * Fast path: look the stack trace up without locking.
-	 * The smp_load_acquire() here pairs with smp_store_release() to
-	 * |bucket| below.
+	 * smp_load_acquire pairs with smp_store_release to |bucket| below.
 	 */
 	found = find_stack(smp_load_acquire(bucket), entries, nr_entries, hash);
 	if (found)
@@ -424,8 +421,8 @@ depot_stack_handle_t __stack_depot_save(
 	 * Check if another stack pool needs to be initialized. If so, allocate
 	 * the memory now - we won't be able to do that under the lock.
 	 *
-	 * The smp_load_acquire() here pairs with smp_store_release() to
-	 * |next_pool_inited| in depot_alloc_stack() and depot_init_pool().
+	 * smp_load_acquire pairs with smp_store_release in depot_alloc_stack
+	 * and depot_init_pool.
 	 */
 	if (unlikely(can_alloc && smp_load_acquire(&next_pool_required))) {
 		/*
@@ -451,8 +448,8 @@ depot_stack_handle_t __stack_depot_save(
 		if (new) {
 			new->next = *bucket;
 			/*
-			 * This smp_store_release() pairs with
-			 * smp_load_acquire() from |bucket| above.
+			 * smp_store_release pairs with smp_load_acquire
+			 * from |bucket| above.
 			 */
 			smp_store_release(bucket, new);
 			found = new;
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

