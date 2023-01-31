Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4874C54EAA
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjAaAZB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaAY4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B633193E7
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE3EAB818C2
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63080C433D2;
        Tue, 31 Jan 2023 00:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124686;
        bh=u+modCt/HY8WY2JI8TJX+XiEs6alOAeA4Cj+tzXloJE=;
        h=Date:To:From:Subject:From;
        b=cVAF35bSkcPqkW0WJ5HYwociCVobH9n9JCvzFR/w0cSr3zjqv7Tdy6eMq0KM8F3YQ
         N4SubElDqqy6HZpTZsAv3mlujPFlBzhyROJzvqdOLYXPcCnG0nGq2k9ZrYRJ1NIwVh
         3M5MlFB5GLddXUh8wkP8pHCgIBPS4XUeDmQZPKxI=
Date:   Mon, 30 Jan 2023 16:24:45 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002446.63080C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stacktrace: drop impossible WARN_ON for depot_init_slab
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab.patch

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
Subject: lib/stacktrace: drop impossible WARN_ON for depot_init_slab
Date: Mon, 30 Jan 2023 21:49:37 +0100

depot_init_slab has two call sites:

1. In depot_alloc_stack with a potentially NULL prealloc.
2. In __stack_depot_save with a non-NULL prealloc.

At the same time depot_init_slab can only return false when prealloc is
NULL.

As the second call site makes sure that prealloc is not NULL, the WARN_ON
there can never trigger. Thus, drop the WARN_ON and also move the prealloc
check from depot_init_slab to its first call site.

Also change the return type of depot_init_slab to void as it now always
returns true.

Link: https://lkml.kernel.org/r/7e7434a0d4e8a71138aec2c8a3c69a4eebf49935.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab
+++ a/lib/stackdepot.c
@@ -218,16 +218,14 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
-static bool depot_init_slab(void **prealloc)
+static void depot_init_slab(void **prealloc)
 {
-	if (!*prealloc)
-		return false;
 	/*
 	 * This smp_load_acquire() pairs with smp_store_release() to
 	 * |next_slab_inited| below and in depot_alloc_stack().
 	 */
 	if (smp_load_acquire(&next_slab_inited))
-		return true;
+		return;
 	if (stack_slabs[slab_index] == NULL) {
 		stack_slabs[slab_index] = *prealloc;
 		*prealloc = NULL;
@@ -244,7 +242,6 @@ static bool depot_init_slab(void **preal
 			smp_store_release(&next_slab_inited, 1);
 		}
 	}
-	return true;
 }
 
 /* Allocation of a new stack in raw storage */
@@ -271,7 +268,8 @@ depot_alloc_stack(unsigned long *entries
 		if (slab_index + 1 < DEPOT_MAX_SLABS)
 			smp_store_release(&next_slab_inited, 0);
 	}
-	depot_init_slab(prealloc);
+	if (*prealloc)
+		depot_init_slab(prealloc);
 	if (stack_slabs[slab_index] == NULL)
 		return NULL;
 
@@ -436,7 +434,7 @@ depot_stack_handle_t __stack_depot_save(
 		 * We didn't need to store this stack trace, but let's keep
 		 * the preallocated memory for the future.
 		 */
-		WARN_ON(!depot_init_slab(&prealloc));
+		depot_init_slab(&prealloc);
 	}
 
 	raw_spin_unlock_irqrestore(&slab_lock, flags);
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

