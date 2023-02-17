Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B49C64ED6
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBQEoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBQEog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BD737F06
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7634461306
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8920C433D2;
        Fri, 17 Feb 2023 04:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609072;
        bh=Pfc+tBnzgXgL6R+0zNft70kFu0Yve8ecCcUKdxDww/U=;
        h=Date:To:From:Subject:From;
        b=0PQJ5xDzSA2yMJg0ugBbxJE95M3z5DbKoBxIadguyJHQd07SSA4hJGxaUTp32+FFZ
         Av6E3aUwnLcL68Yv+ApvZH5rWSfEdMxTD5NJlkdciltEo9+D8P/vwjJQJpJOLJs/rH
         JdXSDErl1lcNrpD0yyuEVXQWkOjg/9sHHf0s0+PU=
Date:   Thu, 16 Feb 2023 20:44:32 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch removed from -mm tree
Message-Id: <20230217044432.C8920C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: annotate depot_init_pool and depot_alloc_stack
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Alexander Potapenko <glider@google.com>
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


