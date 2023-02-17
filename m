Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77387C64EC4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBQEok (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBQEog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D603D93E
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DA90B82B1D
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AA9C4339B;
        Fri, 17 Feb 2023 04:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609071;
        bh=CfW44UakKyWiKVcYAy2F2+VKjVvSGJbUE62K19FoF4I=;
        h=Date:To:From:Subject:From;
        b=nAie99Qmq5bbDt1PYHbHcIeL/Njlf3lmQ/ZVYd5ij/MDNAfboTzrevByHuH2HV/2K
         CS+YGD4hFHSCSxG31lq52GkA2Fuk+nONi5PUkorWuB2CGFof26pcr0YP/I8PWae7lu
         igC6CHUEBRhhS/sVrzW/Wu3LOPlpHNOWA6ye1OrY=
Date:   Thu, 16 Feb 2023 20:44:31 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch removed from -mm tree
Message-Id: <20230217044431.B5AA9C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stacktrace: drop impossible WARN_ON for depot_init_pool
has been removed from the -mm tree.  Its filename was
     lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Alexander Potapenko <glider@google.com>
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


