Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44139C54EAA
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjAaAYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjAaAYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17A912586
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90777B818BF
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3008FC433EF;
        Tue, 31 Jan 2023 00:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124681;
        bh=JXFugosQcWpS/Jx8YePflBjo8lz/GvSDm1qGPSrs6ek=;
        h=Date:To:From:Subject:From;
        b=Nso6zf1ZcRMNOk3phKD4JP8PvLoHwBRvzT9kWmdLWkUbS3lAeYqrbW8gwIctALpPC
         iUAFdPQI1goKi4ZptSE3ob0z3nahTcDGP7q/nQg7ePQDsfgXd6vSjCmOi/6SGeR6Ik
         62VDv8M7TTPnAXak/aHvHkfHNT9acP+K1bwXbplc=
Date:   Mon, 30 Jan 2023 16:24:40 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-init_stack_slab.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002441.3008FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename init_stack_slab
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-init_stack_slab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-init_stack_slab.patch

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
Subject: lib/stackdepot: rename init_stack_slab
Date: Mon, 30 Jan 2023 21:49:34 +0100

Rename init_stack_slab to depot_init_slab to align the name with
depot_alloc_stack.

No functional changes.

Link: https://lkml.kernel.org/r/b756e381a3526c6e59cb68c53ac0f172ddd22776.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-init_stack_slab
+++ a/lib/stackdepot.c
@@ -220,7 +220,7 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
-static bool init_stack_slab(void **prealloc)
+static bool depot_init_slab(void **prealloc)
 {
 	if (!*prealloc)
 		return false;
@@ -268,12 +268,12 @@ depot_alloc_stack(unsigned long *entries
 		/*
 		 * smp_store_release() here pairs with smp_load_acquire() from
 		 * |next_slab_inited| in stack_depot_save() and
-		 * init_stack_slab().
+		 * depot_init_slab().
 		 */
 		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS)
 			smp_store_release(&next_slab_inited, 0);
 	}
-	init_stack_slab(prealloc);
+	depot_init_slab(prealloc);
 	if (stack_slabs[depot_index] == NULL)
 		return NULL;
 
@@ -402,7 +402,7 @@ depot_stack_handle_t __stack_depot_save(
 	 * lock.
 	 *
 	 * The smp_load_acquire() here pairs with smp_store_release() to
-	 * |next_slab_inited| in depot_alloc_stack() and init_stack_slab().
+	 * |next_slab_inited| in depot_alloc_stack() and depot_init_slab().
 	 */
 	if (unlikely(can_alloc && !smp_load_acquire(&next_slab_inited))) {
 		/*
@@ -438,7 +438,7 @@ depot_stack_handle_t __stack_depot_save(
 		 * We didn't need to store this stack trace, but let's keep
 		 * the preallocated memory for the future.
 		 */
-		WARN_ON(!init_stack_slab(&prealloc));
+		WARN_ON(!depot_init_slab(&prealloc));
 	}
 
 	raw_spin_unlock_irqrestore(&depot_lock, flags);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-reset-page-tags-properly-with-sampling.patch
kasan-reset-page-tags-properly-with-sampling-v2.patch
lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab.patch
lib-stackdepot-put-functions-in-logical-order.patch
lib-stackdepot-use-pr_fmt-to-define-message-format.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init.patch
lib-stackdepot-rename-stack_depot_disable.patch
lib-stackdepot-annotate-init-and-early-init-functions.patch
lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch
lib-stackdepot-reorder-and-annotate-global-variables.patch
lib-stackdepot-rename-hash-table-constants-and-variables.patch
lib-stackdepot-rename-init_stack_slab.patch
lib-stackdepot-rename-slab-variables.patch
lib-stackdepot-rename-handle-and-slab-constants.patch
lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab.patch
lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack.patch
lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch
lib-stackdepot-annotate-racy-slab_index-accesses.patch
lib-stackdepot-various-comments-clean-ups.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

