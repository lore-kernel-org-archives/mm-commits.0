Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E63C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBQEol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBQEog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5E642DFE
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C596133B
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA99C433EF;
        Fri, 17 Feb 2023 04:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609073;
        bh=Qc/Jup7zaK31qw6wtAbuyWOiuj5ka16DKmMMIu7Qi6Y=;
        h=Date:To:From:Subject:From;
        b=Mjznn7V/gLZcCgPPn0okS5X2l3KP0RSFBuS9e+Twrd/1YhdKHCQb7BhMhVBWvxaqf
         bEaikOk0s7dgff3WEr5Byjh8sl2gdEC4/HXwiOUBFkr/rJ+Xuekk7zkuwGxudXFQe4
         PI8KfLEYQa5lQMvzYZT/VTVsGwpBG3y+9MQG/P9g=
Date:   Thu, 16 Feb 2023 20:44:33 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch removed from -mm tree
Message-Id: <20230217044433.BEA99C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: rename next_pool_inited to next_pool_required
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Alexander Potapenko <glider@google.com>
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


