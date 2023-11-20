Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0B7C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjKTSEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjKTSEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:04:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C16A4
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:04:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AAAC433C8;
        Mon, 20 Nov 2023 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503441;
        bh=tRhU6AZrWztnBF4lRy9zTXYeHgP12cu3o8aiKf8d3Ec=;
        h=Date:To:From:Subject:From;
        b=VMmmcOodAFJxgyKEruFOwKsLV1WtMqDS5p0XcbzuBOJfYea6KPhVW55JKGvAfMyNf
         RvKVA716r0CiUIeh0w65bnajuDBadGLOum1ccZMBrdZIm6QvnVSFsZvW4aZdgCBP2r
         wVUP0DTGM9qd0cOIBrEx/HfR335KhqvNdbcHZ+60=
Date:   Mon, 20 Nov 2023 10:04:01 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-add-refcount-for-records.patch added to mm-unstable branch
Message-Id: <20231120180401.85AAAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: add refcount for records
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-add-refcount-for-records.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-add-refcount-for-records.patch

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
Subject: lib/stackdepot: add refcount for records
Date: Mon, 20 Nov 2023 18:47:14 +0100

Add a reference counter for how many times a stack records has been
  added to stack depot.

Add a new STACK_DEPOT_FLAG_GET flag to stack_depot_save_flags that
  instructs the stack depot to increment the refcount.

Do not yet decrement the refcount; this is implemented in one of the
  following patches.

Do not yet enable any users to use the flag to avoid overflowing the
  refcount.

This is preparatory patch for implementing the eviction of stack records
  from the stack depot.

Link: https://lkml.kernel.org/r/a3fc14a2359d019d2a008d4ff8b46a665371ffee.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |   13 ++++++++++---
 lib/stackdepot.c           |   12 ++++++++++--
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-add-refcount-for-records
+++ a/include/linux/stackdepot.h
@@ -39,8 +39,9 @@ typedef u32 depot_flags_t;
  * to its declaration for more details.
  */
 #define STACK_DEPOT_FLAG_CAN_ALLOC	((depot_flags_t)0x0001)
+#define STACK_DEPOT_FLAG_GET		((depot_flags_t)0x0002)
 
-#define STACK_DEPOT_FLAGS_NUM	1
+#define STACK_DEPOT_FLAGS_NUM	2
 #define STACK_DEPOT_FLAGS_MASK	((depot_flags_t)((1 << STACK_DEPOT_FLAGS_NUM) - 1))
 
 /*
@@ -94,6 +95,9 @@ static inline int stack_depot_early_init
  * flags of @alloc_flags). Otherwise, stack depot avoids any allocations and
  * fails if no space is left to store the stack trace.
  *
+ * If STACK_DEPOT_FLAG_GET is set in @depot_flags, stack depot will increment
+ * the refcount on the saved stack trace if it already exists in stack depot.
+ *
  * If the provided stack trace comes from the interrupt context, only the part
  * up to the interrupt entry is saved.
  *
@@ -116,8 +120,11 @@ depot_stack_handle_t stack_depot_save_fl
  * @nr_entries:		Number of frames in the stack
  * @alloc_flags:	Allocation GFP flags
  *
- * Context: Contexts where allocations via alloc_pages() are allowed.
- *          See stack_depot_save_flags() for more details.
+ * Does not increment the refcount on the saved stack trace; see
+ * stack_depot_save_flags() for more details.
+ *
+ * Context: Contexts where allocations via alloc_pages() are allowed;
+ *          see stack_depot_save_flags() for more details.
  *
  * Return: Handle of the stack trace stored in depot, 0 on failure
  */
--- a/lib/stackdepot.c~lib-stackdepot-add-refcount-for-records
+++ a/lib/stackdepot.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/printk.h>
+#include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/stacktrace.h>
@@ -60,6 +61,7 @@ struct stack_record {
 	u32 hash;			/* Hash in hash table */
 	u32 size;			/* Number of stored frames */
 	union handle_parts handle;
+	refcount_t count;
 	unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
 };
 
@@ -373,6 +375,7 @@ depot_alloc_stack(unsigned long *entries
 	stack->hash = hash;
 	stack->size = size;
 	/* stack->handle is already filled in by depot_init_pool(). */
+	refcount_set(&stack->count, 1);
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
 
 	/*
@@ -489,6 +492,8 @@ depot_stack_handle_t stack_depot_save_fl
 	/* Fast path: look the stack trace up without full locking. */
 	found = find_stack(bucket, entries, nr_entries, hash);
 	if (found) {
+		if (depot_flags & STACK_DEPOT_FLAG_GET)
+			refcount_inc(&found->count);
 		read_unlock_irqrestore(&pool_rwlock, flags);
 		goto exit;
 	}
@@ -528,12 +533,15 @@ depot_stack_handle_t stack_depot_save_fl
 			list_add(&new->list, bucket);
 			found = new;
 		}
-	} else if (prealloc) {
+	} else {
+		if (depot_flags & STACK_DEPOT_FLAG_GET)
+			refcount_inc(&found->count);
 		/*
 		 * Stack depot already contains this stack trace, but let's
 		 * keep the preallocated memory for future.
 		 */
-		depot_keep_new_pool(&prealloc);
+		if (prealloc)
+			depot_keep_new_pool(&prealloc);
 	}
 
 	write_unlock_irqrestore(&pool_rwlock, flags);
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

