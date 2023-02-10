Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BA9C677F1
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjBJVwG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjBJVvq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AC6635A0
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E707061E50
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9CEC433EF;
        Fri, 10 Feb 2023 21:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065904;
        bh=qMiEJo2L+amZUmDTTnwgdDpYi2V4BWTN7YSzyu7s8Mg=;
        h=Date:To:From:Subject:From;
        b=t4iqTV9ZCkAteU/zCo5bdqUQfDjMPYQ9O17Y8Oq74X9lrZloRxu/2Eqfg1Z4qcd75
         W1/yYrueSNQXlLTXew3Zi/Lnii1gQh7u8d+56B26DL/KibU4b7F9ciyTX0Q/GwIgPz
         Nj4ybPt19jC8l/+pIW9D1Ute+0H7C4kbv4y3SKXM=
Date:   Fri, 10 Feb 2023 13:51:43 -0800
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215144.3F9CEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename next_pool_inited to next_pool_required
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch

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
Subject: lib/stackdepot: rename next_pool_inited to next_pool_required
Date: Fri, 10 Feb 2023 22:16:02 +0100

Stack depot uses next_pool_inited to mark that either the next pool is
initialized or the limit on the number of pools is reached. However,
the flag name only reflects the former part of its purpose, which is
confusing.

Rename next_pool_inited to next_pool_required and invert its value.

Also annotate usages of next_pool_required with comments.

Link: https://lkml.kernel.org/r/484fd2695dff7a9bdc437a32f8a6ee228535aa02.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-next_pool_inited-to-next_pool_required
+++ a/lib/stackdepot.c
@@ -96,8 +96,14 @@ static int pool_index;
 static size_t pool_offset;
 /* Lock that protects the variables above. */
 static DEFINE_RAW_SPINLOCK(pool_lock);
-/* Whether the next pool is initialized. */
-static int next_pool_inited;
+/*
+ * Stack depot tries to keep an extra pool allocated even before it runs out
+ * of space in the currently used pool.
+ * This flag marks that this next extra pool needs to be allocated and
+ * initialized. It has the value 0 when either the next pool is not yet
+ * initialized or the limit on the number of pools is reached.
+ */
+static int next_pool_required = 1;
 
 static int __init disable_stack_depot(char *str)
 {
@@ -222,10 +228,12 @@ EXPORT_SYMBOL_GPL(stack_depot_init);
 static void depot_init_pool(void **prealloc)
 {
 	/*
+	 * If the next pool is already initialized or the maximum number of
+	 * pools is reached, do not use the preallocated memory.
 	 * smp_load_acquire() here pairs with smp_store_release() below and
 	 * in depot_alloc_stack().
 	 */
-	if (smp_load_acquire(&next_pool_inited))
+	if (!smp_load_acquire(&next_pool_required))
 		return;
 
 	/* Check if the current pool is not yet allocated. */
@@ -243,10 +251,13 @@ static void depot_init_pool(void **preal
 			*prealloc = NULL;
 		}
 		/*
+		 * At this point, either the next pool is initialized or the
+		 * maximum number of pools is reached. In either case, take
+		 * note that initializing another pool is not required.
 		 * This smp_store_release pairs with smp_load_acquire() above
 		 * and in stack_depot_save().
 		 */
-		smp_store_release(&next_pool_inited, 1);
+		smp_store_release(&next_pool_required, 0);
 	}
 }
 
@@ -271,11 +282,13 @@ depot_alloc_stack(unsigned long *entries
 		pool_index++;
 		pool_offset = 0;
 		/*
+		 * If the maximum number of pools is not reached, take note
+		 * that the next pool needs to initialized.
 		 * smp_store_release() here pairs with smp_load_acquire() in
 		 * stack_depot_save() and depot_init_pool().
 		 */
 		if (pool_index + 1 < DEPOT_MAX_POOLS)
-			smp_store_release(&next_pool_inited, 0);
+			smp_store_release(&next_pool_required, 1);
 	}
 
 	/* Assign the preallocated memory to a pool if required. */
@@ -406,14 +419,13 @@ depot_stack_handle_t __stack_depot_save(
 		goto exit;
 
 	/*
-	 * Check if the current or the next stack pool need to be initialized.
-	 * If so, allocate the memory - we won't be able to do that under the
-	 * lock.
+	 * Check if another stack pool needs to be initialized. If so, allocate
+	 * the memory now - we won't be able to do that under the lock.
 	 *
 	 * The smp_load_acquire() here pairs with smp_store_release() to
 	 * |next_pool_inited| in depot_alloc_stack() and depot_init_pool().
 	 */
-	if (unlikely(can_alloc && !smp_load_acquire(&next_pool_inited))) {
+	if (unlikely(can_alloc && smp_load_acquire(&next_pool_required))) {
 		/*
 		 * Zero out zone modifiers, as we don't have specific zone
 		 * requirements. Keep the flags related to allocation in atomic
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

