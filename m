Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E6C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBJVwD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjBJVvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0874B749
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B31D4B825DB
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BDAC433EF;
        Fri, 10 Feb 2023 21:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065897;
        bh=P1MXrAQPP/Qz0j3II7ahch+Jtf9K6ha/SKlpQIj+v7M=;
        h=Date:To:From:Subject:From;
        b=bOeRzxBR8hxlauPLxcdQKQB472RZ3tyTKg7lUTl+jyT1Fot9pPkLdVl5Yq8LawChN
         quqGUl4U7OsIvQeLeKeB7Mo+CyWQo4nRkU9RYDswoXC1Y35dOrnMVQeps7GWl59s57
         VDc1W+dpZGkdEHT2SigB4G/lgTPPuSyKnGhjdqWs=
Date:   Fri, 10 Feb 2023 13:51:36 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-handle-and-pool-constants.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215137.69BDAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename handle and pool constants
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-handle-and-pool-constants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-handle-and-pool-constants.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: lib/stackdepot: rename handle and pool constants
Date: Fri, 10 Feb 2023 22:15:58 +0100

Change the "STACK_ALLOC_" prefix to "DEPOT_" for the constants that
define the number of bits in stack depot handles and the maximum number
of pools.

The old prefix is unclear and makes wonder about how these constants
are related to stack allocations. The new prefix is also shorter.

Also simplify the comment for DEPOT_POOL_ORDER.

No functional changes.

Link: https://lkml.kernel.org/r/84fcceb0acc261a356a0ad4bdfab9ff04bea2445.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-handle-and-pool-constants
+++ a/lib/stackdepot.c
@@ -36,30 +36,28 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
-#define DEPOT_STACK_BITS (sizeof(depot_stack_handle_t) * 8)
+#define DEPOT_HANDLE_BITS (sizeof(depot_stack_handle_t) * 8)
 
-#define STACK_ALLOC_NULL_PROTECTION_BITS 1
-#define STACK_ALLOC_ORDER 2 /* Pool size order for stack depot, 4 pages */
-#define STACK_ALLOC_SIZE (1LL << (PAGE_SHIFT + STACK_ALLOC_ORDER))
-#define STACK_ALLOC_ALIGN 4
-#define STACK_ALLOC_OFFSET_BITS (STACK_ALLOC_ORDER + PAGE_SHIFT - \
-					STACK_ALLOC_ALIGN)
-#define STACK_ALLOC_INDEX_BITS (DEPOT_STACK_BITS - \
-		STACK_ALLOC_NULL_PROTECTION_BITS - \
-		STACK_ALLOC_OFFSET_BITS - STACK_DEPOT_EXTRA_BITS)
-#define STACK_ALLOC_POOLS_CAP 8192
-#define STACK_ALLOC_MAX_POOLS \
-	(((1LL << (STACK_ALLOC_INDEX_BITS)) < STACK_ALLOC_POOLS_CAP) ? \
-	 (1LL << (STACK_ALLOC_INDEX_BITS)) : STACK_ALLOC_POOLS_CAP)
+#define DEPOT_VALID_BITS 1
+#define DEPOT_POOL_ORDER 2 /* Pool size order, 4 pages */
+#define DEPOT_POOL_SIZE (1LL << (PAGE_SHIFT + DEPOT_POOL_ORDER))
+#define DEPOT_STACK_ALIGN 4
+#define DEPOT_OFFSET_BITS (DEPOT_POOL_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
+#define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_VALID_BITS - \
+			       DEPOT_OFFSET_BITS - STACK_DEPOT_EXTRA_BITS)
+#define DEPOT_POOLS_CAP 8192
+#define DEPOT_MAX_POOLS \
+	(((1LL << (DEPOT_POOL_INDEX_BITS)) < DEPOT_POOLS_CAP) ? \
+	 (1LL << (DEPOT_POOL_INDEX_BITS)) : DEPOT_POOLS_CAP)
 
 /* The compact structure to store the reference to stacks. */
 union handle_parts {
 	depot_stack_handle_t handle;
 	struct {
-		u32 pool_index : STACK_ALLOC_INDEX_BITS;
-		u32 offset : STACK_ALLOC_OFFSET_BITS;
-		u32 valid : STACK_ALLOC_NULL_PROTECTION_BITS;
-		u32 extra : STACK_DEPOT_EXTRA_BITS;
+		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
+		u32 offset	: DEPOT_OFFSET_BITS;
+		u32 valid	: DEPOT_VALID_BITS;
+		u32 extra	: STACK_DEPOT_EXTRA_BITS;
 	};
 };
 
@@ -91,7 +89,7 @@ static unsigned int stack_bucket_number_
 static unsigned int stack_hash_mask;
 
 /* Array of memory regions that store stack traces. */
-static void *stack_pools[STACK_ALLOC_MAX_POOLS];
+static void *stack_pools[DEPOT_MAX_POOLS];
 /* Currently used pool in stack_pools. */
 static int pool_index;
 /* Offset to the unused space in the currently used pool. */
@@ -235,7 +233,7 @@ static bool init_stack_pool(void **preal
 		*prealloc = NULL;
 	} else {
 		/* If this is the last depot pool, do not touch the next one. */
-		if (pool_index + 1 < STACK_ALLOC_MAX_POOLS) {
+		if (pool_index + 1 < DEPOT_MAX_POOLS) {
 			stack_pools[pool_index + 1] = *prealloc;
 			*prealloc = NULL;
 		}
@@ -255,10 +253,10 @@ depot_alloc_stack(unsigned long *entries
 	struct stack_record *stack;
 	size_t required_size = struct_size(stack, entries, size);
 
-	required_size = ALIGN(required_size, 1 << STACK_ALLOC_ALIGN);
+	required_size = ALIGN(required_size, 1 << DEPOT_STACK_ALIGN);
 
-	if (unlikely(pool_offset + required_size > STACK_ALLOC_SIZE)) {
-		if (unlikely(pool_index + 1 >= STACK_ALLOC_MAX_POOLS)) {
+	if (unlikely(pool_offset + required_size > DEPOT_POOL_SIZE)) {
+		if (unlikely(pool_index + 1 >= DEPOT_MAX_POOLS)) {
 			WARN_ONCE(1, "Stack depot reached limit capacity");
 			return NULL;
 		}
@@ -269,7 +267,7 @@ depot_alloc_stack(unsigned long *entries
 		 * |next_pool_inited| in stack_depot_save() and
 		 * init_stack_pool().
 		 */
-		if (pool_index + 1 < STACK_ALLOC_MAX_POOLS)
+		if (pool_index + 1 < DEPOT_MAX_POOLS)
 			smp_store_release(&next_pool_inited, 0);
 	}
 	init_stack_pool(prealloc);
@@ -281,7 +279,7 @@ depot_alloc_stack(unsigned long *entries
 	stack->hash = hash;
 	stack->size = size;
 	stack->handle.pool_index = pool_index;
-	stack->handle.offset = pool_offset >> STACK_ALLOC_ALIGN;
+	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
 	stack->handle.valid = 1;
 	stack->handle.extra = 0;
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
@@ -412,7 +410,7 @@ depot_stack_handle_t __stack_depot_save(
 		alloc_flags &= ~GFP_ZONEMASK;
 		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
 		alloc_flags |= __GFP_NOWARN;
-		page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);
+		page = alloc_pages(alloc_flags, DEPOT_POOL_ORDER);
 		if (page)
 			prealloc = page_address(page);
 	}
@@ -444,7 +442,7 @@ depot_stack_handle_t __stack_depot_save(
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
-		free_pages((unsigned long)prealloc, STACK_ALLOC_ORDER);
+		free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
 	}
 	if (found)
 		retval.handle = found->handle.handle;
@@ -489,7 +487,7 @@ unsigned int stack_depot_fetch(depot_sta
 {
 	union handle_parts parts = { .handle = handle };
 	void *pool;
-	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
+	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
 	*entries = NULL;
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-put-functions-in-logical-order.patch
lib-stackdepot-use-pr_fmt-to-define-message-format.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init.patch
lib-stackdepot-rename-stack_depot_disable.patch
lib-stackdepot-annotate-init-and-early-init-functions.patch
lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch
lib-stackdepot-reorder-and-annotate-global-variables.patch
lib-stackdepot-rename-hash-table-constants-and-variables.patch
lib-stackdepot-rename-slab-to-pool.patch
lib-stackdepot-rename-handle-and-pool-constants.patch
lib-stackdepot-rename-init_stack_pool.patch
lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch
lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch
lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch
lib-stackdepot-annotate-racy-pool_index-accesses.patch
lib-stackdepot-various-comments-clean-ups.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

