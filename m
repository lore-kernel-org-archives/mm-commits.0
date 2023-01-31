Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E02CC61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjAaAZJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjAaAY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7BB19683
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C881B818BF
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA25C433D2;
        Tue, 31 Jan 2023 00:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124688;
        bh=kMozMyqEgy81EQKtLZUIuzlvCTSdPBE/n320xt/Gbv8=;
        h=Date:To:From:Subject:From;
        b=gH6focKioLE5zNsvMpnc1LP7ImIqLAyPeGiM7c+2ygNCe4S2GKPORdocfR7MrGP1r
         kWhuQTGkEm0Py8SYhbG9o87Lgeaa3KpRCww1wWsj+1HseW5VYzcb5jNB6T0AsTUgaa
         2NFYX7MaA6Fc9d9amr9Nn1QwhyT0bMALDc35mwMk=
Date:   Mon, 30 Jan 2023 16:24:47 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002448.1EA25C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: annotate depot_init_slab and depot_alloc_stack
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack.patch

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
Subject: lib/stackdepot: annotate depot_init_slab and depot_alloc_stack
Date: Mon, 30 Jan 2023 21:49:38 +0100

Clean up the exisiting comments and add new ones to depot_init_slab and
depot_alloc_stack.

As a part of the clean-up, remove mentions of which variable is accessed
by smp_store_release and smp_load_acquire: it is clear as is from the
code.

Link: https://lkml.kernel.org/r/3cf68a23da43cef0f8737f7a2c07f35ce6d841a7.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack
+++ a/lib/stackdepot.c
@@ -218,33 +218,41 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
 
+/* Uses preallocated memory to initialize a new stack depot slab. */
 static void depot_init_slab(void **prealloc)
 {
 	/*
-	 * This smp_load_acquire() pairs with smp_store_release() to
-	 * |next_slab_inited| below and in depot_alloc_stack().
+	 * If the next slab is already initialized, do not use the
+	 * preallocated memory.
+	 * smp_load_acquire() here pairs with smp_store_release() below and
+	 * in depot_alloc_stack().
 	 */
 	if (smp_load_acquire(&next_slab_inited))
 		return;
+
+	/* Check if the current slab is not yet allocated. */
 	if (stack_slabs[slab_index] == NULL) {
+		/* Use the preallocated memory for the current slab. */
 		stack_slabs[slab_index] = *prealloc;
 		*prealloc = NULL;
 	} else {
-		/* If this is the last depot slab, do not touch the next one. */
+		/*
+		 * Otherwise, use the preallocated memory for the next slab
+		 * as long as we do not exceed the maximum number of slabs.
+		 */
 		if (slab_index + 1 < DEPOT_MAX_SLABS) {
 			stack_slabs[slab_index + 1] = *prealloc;
 			*prealloc = NULL;
 			/*
 			 * This smp_store_release pairs with smp_load_acquire()
-			 * from |next_slab_inited| above and in
-			 * stack_depot_save().
+			 * above and in stack_depot_save().
 			 */
 			smp_store_release(&next_slab_inited, 1);
 		}
 	}
 }
 
-/* Allocation of a new stack in raw storage */
+/* Allocates a new stack in a stack depot slab. */
 static struct stack_record *
 depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
@@ -253,28 +261,35 @@ depot_alloc_stack(unsigned long *entries
 
 	required_size = ALIGN(required_size, 1 << DEPOT_STACK_ALIGN);
 
+	/* Check if there is not enough space in the current slab. */
 	if (unlikely(slab_offset + required_size > DEPOT_SLAB_SIZE)) {
+		/* Bail out if we reached the slab limit. */
 		if (unlikely(slab_index + 1 >= DEPOT_MAX_SLABS)) {
 			WARN_ONCE(1, "Stack depot reached limit capacity");
 			return NULL;
 		}
+
+		/* Move on to the next slab. */
 		slab_index++;
 		slab_offset = 0;
 		/*
-		 * smp_store_release() here pairs with smp_load_acquire() from
-		 * |next_slab_inited| in stack_depot_save() and
-		 * depot_init_slab().
+		 * smp_store_release() here pairs with smp_load_acquire() in
+		 * stack_depot_save() and depot_init_slab().
 		 */
 		if (slab_index + 1 < DEPOT_MAX_SLABS)
 			smp_store_release(&next_slab_inited, 0);
 	}
+
+	/* Assign the preallocated memory to a slab if required. */
 	if (*prealloc)
 		depot_init_slab(prealloc);
+
+	/* Check if we have a slab to save the stack trace. */
 	if (stack_slabs[slab_index] == NULL)
 		return NULL;
 
+	/* Save the stack trace. */
 	stack = stack_slabs[slab_index] + slab_offset;
-
 	stack->hash = hash;
 	stack->size = size;
 	stack->handle.slab_index = slab_index;
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

