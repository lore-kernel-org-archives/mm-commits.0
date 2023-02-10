Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D71C64ED6
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjBJVwE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjBJVvl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393564DE3D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A3761EA8
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B5C433D2;
        Fri, 10 Feb 2023 21:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065899;
        bh=PyaOL7aCL38LWvU3RZGiK18vfrSgHRXHtrCI6o/Qtls=;
        h=Date:To:From:Subject:From;
        b=zGrO09AXRe2ALxJXdeX65Hf/+ocdTv4sMRT49Ay6B+al4LDSfXgLP804pPEaPsZlv
         UfSAMUjoqVOZWqYDHt6uaTb20XvUgHv+V+Uy1mHGjJfRRJJUqPVVn8JkYjeszyXRrk
         bKDmd9l022FenbnJCqD5PXQEcmWojpV14KzvmLA4=
Date:   Fri, 10 Feb 2023 13:51:38 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-init_stack_pool.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215139.292B5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename init_stack_pool
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-init_stack_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-init_stack_pool.patch

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
Subject: lib/stackdepot: rename init_stack_pool
Date: Fri, 10 Feb 2023 22:15:59 +0100

Rename init_stack_pool to depot_init_pool to align the name with
depot_alloc_stack.

No functional changes.

Link: https://lkml.kernel.org/r/23106a3e291d8df0aba33c0e2fe86dc596286479.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-init_stack_pool
+++ a/lib/stackdepot.c
@@ -218,7 +218,7 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
-static bool init_stack_pool(void **prealloc)
+static bool depot_init_pool(void **prealloc)
 {
 	if (!*prealloc)
 		return false;
@@ -265,12 +265,12 @@ depot_alloc_stack(unsigned long *entries
 		/*
 		 * smp_store_release() here pairs with smp_load_acquire() from
 		 * |next_pool_inited| in stack_depot_save() and
-		 * init_stack_pool().
+		 * depot_init_pool().
 		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
 			smp_store_release(&next_pool_inited, 0);
 	}
-	init_stack_pool(prealloc);
+	depot_init_pool(prealloc);
 	if (stack_pools[pool_index] == NULL)
 		return NULL;
 
@@ -399,7 +399,7 @@ depot_stack_handle_t __stack_depot_save(
 	 * lock.
 	 *
 	 * The smp_load_acquire() here pairs with smp_store_release() to
-	 * |next_pool_inited| in depot_alloc_stack() and init_stack_pool().
+	 * |next_pool_inited| in depot_alloc_stack() and depot_init_pool().
 	 */
 	if (unlikely(can_alloc && !smp_load_acquire(&next_pool_inited))) {
 		/*
@@ -435,7 +435,7 @@ depot_stack_handle_t __stack_depot_save(
 		 * We didn't need to store this stack trace, but let's keep
 		 * the preallocated memory for the future.
 		 */
-		WARN_ON(!init_stack_pool(&prealloc));
+		WARN_ON(!depot_init_pool(&prealloc));
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

