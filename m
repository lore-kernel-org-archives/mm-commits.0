Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBEAC05027
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBQEoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjBQEod (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42BD42BEF
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6016C6134A
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFACBC433EF;
        Fri, 17 Feb 2023 04:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609070;
        bh=O5fPq4cxWAq3+3IalGkMK0qB2K4AugXnB9626YqAEAg=;
        h=Date:To:From:Subject:From;
        b=2A/aKze1nmmW9nivhArBUgPm1wedxgph692eAs0oh2yG1fR7Faa+Q5vEDf0pb/ygZ
         LA6SZI2rXgDxJVFF5jvk6D+7hSEETU5069QNztedqdW7G8/0G2Byok9ENksmpsVxp0
         Dmgoh02jLFj+vQSLe0hlTqKiWAQSfuRefpyMsopY=
Date:   Thu, 16 Feb 2023 20:44:30 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-rename-init_stack_pool.patch removed from -mm tree
Message-Id: <20230217044430.AFACBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: rename init_stack_pool
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-rename-init_stack_pool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


