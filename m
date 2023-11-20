Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1973CC5AE5B
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjKTSD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjKTSDx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:03:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92084BC
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:03:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6AEC433C8;
        Mon, 20 Nov 2023 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503429;
        bh=y6suyIXBcPp8OSjeKZwWj9XZxRwhnivi6s2itfyFTTQ=;
        h=Date:To:From:Subject:From;
        b=N7mqtKhNoR80+x3alDHrlG3c+ZZx6KENpk1PvJ2O3xOWF0HAsiqMtCOI/UWroLm0O
         BCnJdPq5XWeEN8lF2RmpCopGZIVFN02DscatEGDiYxCkHjskruJxrbnMaZ3dg0RZn+
         OiRU7mRTutfOic+iTbWqZWzw+fhSCrVAKQKtpJkM=
Date:   Mon, 20 Nov 2023 10:03:48 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-store-next-pool-pointer-in-new_pool.patch added to mm-unstable branch
Message-Id: <20231120180349.2E6AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: store next pool pointer in new_pool
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-store-next-pool-pointer-in-new_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-store-next-pool-pointer-in-new_pool.patch

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
Subject: lib/stackdepot: store next pool pointer in new_pool
Date: Mon, 20 Nov 2023 18:47:08 +0100

Instead of using the last pointer in stack_pools for storing the pointer
to a new pool (which does not yet store any stack records), use a new
new_pool variable.

This a purely code readability change: it seems more logical to store the
pointer to a pool with a special meaning in a dedicated variable.

Link: https://lkml.kernel.org/r/448bc18296c16bef95cb3167697be6583dcc8ce3.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-store-next-pool-pointer-in-new_pool
+++ a/lib/stackdepot.c
@@ -85,6 +85,8 @@ static unsigned int stack_hash_mask;
 
 /* Array of memory regions that store stack traces. */
 static void *stack_pools[DEPOT_MAX_POOLS];
+/* Newly allocated pool that is not yet added to stack_pools. */
+static void *new_pool;
 /* Currently used pool in stack_pools. */
 static int pool_index;
 /* Offset to the unused space in the currently used pool. */
@@ -241,7 +243,7 @@ static void depot_keep_new_pool(void **p
 	 * as long as we do not exceed the maximum number of pools.
 	 */
 	if (pool_index + 1 < DEPOT_MAX_POOLS) {
-		stack_pools[pool_index + 1] = *prealloc;
+		new_pool = *prealloc;
 		*prealloc = NULL;
 	}
 
@@ -272,6 +274,8 @@ static bool depot_update_pools(size_t re
 		 * stack_depot_fetch().
 		 */
 		WRITE_ONCE(pool_index, pool_index + 1);
+		stack_pools[pool_index] = new_pool;
+		new_pool = NULL;
 		pool_offset = 0;
 
 		/*
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

