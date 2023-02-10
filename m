Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF5FC636D4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbjBJVwH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjBJVvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841360D4D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7431961E50
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC84C433D2;
        Fri, 10 Feb 2023 21:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065900;
        bh=RZI7Fz0j+XNMSunsgE3WB1YsWl1qCCX7cxpGf060+yc=;
        h=Date:To:From:Subject:From;
        b=mbVzOgwfZj7pvf2dnf+dFPer1bTpaERsgeL/2ArGm8jibBYEvADZf/h/h2HC7WXcq
         vnf57oB5WVSnERGTKNJR98s43AKhnTXBWhgAwHMZjKduUi6SICn2lUJCy4U/arc9Iv
         ouVz3EmexTY8P+jnSUAcS9Xf3dT+i9WzK0wGqUuI=
Date:   Fri, 10 Feb 2023 13:51:40 -0800
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215140.CBC84C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stacktrace: drop impossible WARN_ON for depot_init_pool
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch

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
Subject: lib/stacktrace: drop impossible WARN_ON for depot_init_pool
Date: Fri, 10 Feb 2023 22:16:00 +0100

depot_init_pool has two call sites:

1. In depot_alloc_stack with a potentially NULL prealloc.
2. In __stack_depot_save with a non-NULL prealloc.

At the same time depot_init_pool can only return false when prealloc is
NULL.

As the second call site makes sure that prealloc is not NULL, the WARN_ON
there can never trigger. Thus, drop the WARN_ON and also move the prealloc
check from depot_init_pool to its first call site.

Also change the return type of depot_init_pool to void as it now always
returns true.

Link: https://lkml.kernel.org/r/ce149f9bdcbc80a92549b54da67eafb27f846b7b.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool
+++ a/lib/stackdepot.c
@@ -218,16 +218,14 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
-static bool depot_init_pool(void **prealloc)
+static void depot_init_pool(void **prealloc)
 {
-	if (!*prealloc)
-		return false;
 	/*
 	 * This smp_load_acquire() pairs with smp_store_release() to
 	 * |next_pool_inited| below and in depot_alloc_stack().
 	 */
 	if (smp_load_acquire(&next_pool_inited))
-		return true;
+		return;
 	if (stack_pools[pool_index] == NULL) {
 		stack_pools[pool_index] = *prealloc;
 		*prealloc = NULL;
@@ -243,7 +241,6 @@ static bool depot_init_pool(void **preal
 		 */
 		smp_store_release(&next_pool_inited, 1);
 	}
-	return true;
 }
 
 /* Allocation of a new stack in raw storage */
@@ -270,7 +267,8 @@ depot_alloc_stack(unsigned long *entries
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
 			smp_store_release(&next_pool_inited, 0);
 	}
-	depot_init_pool(prealloc);
+	if (*prealloc)
+		depot_init_pool(prealloc);
 	if (stack_pools[pool_index] == NULL)
 		return NULL;
 
@@ -435,7 +433,7 @@ depot_stack_handle_t __stack_depot_save(
 		 * We didn't need to store this stack trace, but let's keep
 		 * the preallocated memory for the future.
 		 */
-		WARN_ON(!depot_init_pool(&prealloc));
+		depot_init_pool(&prealloc);
 	}
 
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
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

