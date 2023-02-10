Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C53C64EC7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbjBJVwJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbjBJVvv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C34E6279B
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDDB7B825DB
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0ECC433EF;
        Fri, 10 Feb 2023 21:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065902;
        bh=xNACkzuVGPLao23vSLfAEiNLWfrOmPPFRhaY2/H9ows=;
        h=Date:To:From:Subject:From;
        b=lFB9aOHuQl/JBK+ZczHmC9Yr/sOfT93bnoU74cZCTDmuORsQAYJqz2C2EyyeK55OS
         DZQ92AsXB3AJCSY12CD1JX/3Mp/jiy0jIYPPc70gedQVvYOpJw7M2OO+wSZOFWvY8G
         aGtnLh3BoS9o1rOUpLYSD1FIr625TyDS6N0IaMak=
Date:   Fri, 10 Feb 2023 13:51:41 -0800
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215142.7F0ECC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: annotate depot_init_pool and depot_alloc_stack
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch

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
Subject: lib/stackdepot: annotate depot_init_pool and depot_alloc_stack
Date: Fri, 10 Feb 2023 22:16:01 +0100

Clean up the exisiting comments and add new ones to depot_init_pool and
depot_alloc_stack.

As a part of the clean-up, remove mentions of which variable is accessed
by smp_store_release and smp_load_acquire: it is clear as is from the
code.

Link: https://lkml.kernel.org/r/f80b02951364e6b40deda965b4003de0cd1a532d.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack
+++ a/lib/stackdepot.c
@@ -218,32 +218,39 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
+/* Uses preallocated memory to initialize a new stack depot pool. */
 static void depot_init_pool(void **prealloc)
 {
 	/*
-	 * This smp_load_acquire() pairs with smp_store_release() to
-	 * |next_pool_inited| below and in depot_alloc_stack().
+	 * smp_load_acquire() here pairs with smp_store_release() below and
+	 * in depot_alloc_stack().
 	 */
 	if (smp_load_acquire(&next_pool_inited))
 		return;
+
+	/* Check if the current pool is not yet allocated. */
 	if (stack_pools[pool_index] == NULL) {
+		/* Use the preallocated memory for the current pool. */
 		stack_pools[pool_index] = *prealloc;
 		*prealloc = NULL;
 	} else {
-		/* If this is the last depot pool, do not touch the next one. */
+		/*
+		 * Otherwise, use the preallocated memory for the next pool
+		 * as long as we do not exceed the maximum number of pools.
+		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS) {
 			stack_pools[pool_index + 1] = *prealloc;
 			*prealloc = NULL;
 		}
 		/*
-		 * This smp_store_release pairs with smp_load_acquire() from
-		 * |next_pool_inited| above and in stack_depot_save().
+		 * This smp_store_release pairs with smp_load_acquire() above
+		 * and in stack_depot_save().
 		 */
 		smp_store_release(&next_pool_inited, 1);
 	}
 }
 
-/* Allocation of a new stack in raw storage */
+/* Allocates a new stack in a stack depot pool. */
 static struct stack_record *
 depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
@@ -252,28 +259,35 @@ depot_alloc_stack(unsigned long *entries
 
 	required_size = ALIGN(required_size, 1 << DEPOT_STACK_ALIGN);
 
+	/* Check if there is not enough space in the current pool. */
 	if (unlikely(pool_offset + required_size > DEPOT_POOL_SIZE)) {
+		/* Bail out if we reached the pool limit. */
 		if (unlikely(pool_index + 1 >= DEPOT_MAX_POOLS)) {
 			WARN_ONCE(1, "Stack depot reached limit capacity");
 			return NULL;
 		}
+
+		/* Move on to the next pool. */
 		pool_index++;
 		pool_offset = 0;
 		/*
-		 * smp_store_release() here pairs with smp_load_acquire() from
-		 * |next_pool_inited| in stack_depot_save() and
-		 * depot_init_pool().
+		 * smp_store_release() here pairs with smp_load_acquire() in
+		 * stack_depot_save() and depot_init_pool().
 		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
 			smp_store_release(&next_pool_inited, 0);
 	}
+
+	/* Assign the preallocated memory to a pool if required. */
 	if (*prealloc)
 		depot_init_pool(prealloc);
+
+	/* Check if we have a pool to save the stack trace. */
 	if (stack_pools[pool_index] == NULL)
 		return NULL;
 
+	/* Save the stack trace. */
 	stack = stack_pools[pool_index] + pool_offset;
-
 	stack->hash = hash;
 	stack->size = size;
 	stack->handle.pool_index = pool_index;
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

