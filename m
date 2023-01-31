Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC6CC636D6
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjAaAYs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjAaAYp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9A7166CA
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1B16133D
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4BEC433EF;
        Tue, 31 Jan 2023 00:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124682;
        bh=T3WmzfLJMNjQDOjFsS7MnJfijMwDSErEbcKK6+Nfluw=;
        h=Date:To:From:Subject:From;
        b=qcMl//CpoZ32KbhiDmIoDP8eg1QhGOPtXrSdvJnYXF+xcXkoFXP+dF2iyhaKH38S+
         YaFJ8T+LFb7c3bpXsWGHLNGkYB1aJ6mklCNFSR5IXWj1YTrJg3Wx0gBeMIHX4zqIKR
         /XvPTemAQgvh1kKNbLLTO13n40mtvELhmLfzn4mo=
Date:   Mon, 30 Jan 2023 16:24:42 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-slab-variables.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002442.CF4BEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename slab variables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-slab-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-slab-variables.patch

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
Subject: lib/stackdepot: rename slab variables
Date: Mon, 30 Jan 2023 21:49:35 +0100

Give better names to slab-related global variables: change "depot_" prefix
to "slab_" to point out that these variables are related to stack depot
slabs.

Also rename the slabindex field in handle_parts to align its name with the
slab_index global variable.

No functional changes.

Link: https://lkml.kernel.org/r/fc73ab8b1469d476363a918cbdfe28e1388c043a.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-slab-variables
+++ a/lib/stackdepot.c
@@ -56,7 +56,7 @@
 union handle_parts {
 	depot_stack_handle_t handle;
 	struct {
-		u32 slabindex : STACK_ALLOC_INDEX_BITS;
+		u32 slab_index : STACK_ALLOC_INDEX_BITS;
 		u32 offset : STACK_ALLOC_OFFSET_BITS;
 		u32 valid : STACK_ALLOC_NULL_PROTECTION_BITS;
 		u32 extra : STACK_DEPOT_EXTRA_BITS;
@@ -93,11 +93,11 @@ static unsigned int stack_hash_mask;
 /* Array of memory regions that store stack traces. */
 static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
 /* Currently used slab in stack_slabs. */
-static int depot_index;
+static int slab_index;
 /* Offset to the unused space in the currently used slab. */
-static size_t depot_offset;
+static size_t slab_offset;
 /* Lock that protects the variables above. */
-static DEFINE_RAW_SPINLOCK(depot_lock);
+static DEFINE_RAW_SPINLOCK(slab_lock);
 /* Whether the next slab is initialized. */
 static int next_slab_inited;
 
@@ -230,13 +230,13 @@ static bool depot_init_slab(void **preal
 	 */
 	if (smp_load_acquire(&next_slab_inited))
 		return true;
-	if (stack_slabs[depot_index] == NULL) {
-		stack_slabs[depot_index] = *prealloc;
+	if (stack_slabs[slab_index] == NULL) {
+		stack_slabs[slab_index] = *prealloc;
 		*prealloc = NULL;
 	} else {
 		/* If this is the last depot slab, do not touch the next one. */
-		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS) {
-			stack_slabs[depot_index + 1] = *prealloc;
+		if (slab_index + 1 < STACK_ALLOC_MAX_SLABS) {
+			stack_slabs[slab_index + 1] = *prealloc;
 			*prealloc = NULL;
 			/*
 			 * This smp_store_release pairs with smp_load_acquire()
@@ -258,35 +258,35 @@ depot_alloc_stack(unsigned long *entries
 
 	required_size = ALIGN(required_size, 1 << STACK_ALLOC_ALIGN);
 
-	if (unlikely(depot_offset + required_size > STACK_ALLOC_SIZE)) {
-		if (unlikely(depot_index + 1 >= STACK_ALLOC_MAX_SLABS)) {
+	if (unlikely(slab_offset + required_size > STACK_ALLOC_SIZE)) {
+		if (unlikely(slab_index + 1 >= STACK_ALLOC_MAX_SLABS)) {
 			WARN_ONCE(1, "Stack depot reached limit capacity");
 			return NULL;
 		}
-		depot_index++;
-		depot_offset = 0;
+		slab_index++;
+		slab_offset = 0;
 		/*
 		 * smp_store_release() here pairs with smp_load_acquire() from
 		 * |next_slab_inited| in stack_depot_save() and
 		 * depot_init_slab().
 		 */
-		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS)
+		if (slab_index + 1 < STACK_ALLOC_MAX_SLABS)
 			smp_store_release(&next_slab_inited, 0);
 	}
 	depot_init_slab(prealloc);
-	if (stack_slabs[depot_index] == NULL)
+	if (stack_slabs[slab_index] == NULL)
 		return NULL;
 
-	stack = stack_slabs[depot_index] + depot_offset;
+	stack = stack_slabs[slab_index] + slab_offset;
 
 	stack->hash = hash;
 	stack->size = size;
-	stack->handle.slabindex = depot_index;
-	stack->handle.offset = depot_offset >> STACK_ALLOC_ALIGN;
+	stack->handle.slab_index = slab_index;
+	stack->handle.offset = slab_offset >> STACK_ALLOC_ALIGN;
 	stack->handle.valid = 1;
 	stack->handle.extra = 0;
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
-	depot_offset += required_size;
+	slab_offset += required_size;
 
 	return stack;
 }
@@ -418,7 +418,7 @@ depot_stack_handle_t __stack_depot_save(
 			prealloc = page_address(page);
 	}
 
-	raw_spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&slab_lock, flags);
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
@@ -441,7 +441,7 @@ depot_stack_handle_t __stack_depot_save(
 		WARN_ON(!depot_init_slab(&prealloc));
 	}
 
-	raw_spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&slab_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
@@ -497,12 +497,12 @@ unsigned int stack_depot_fetch(depot_sta
 	if (!handle)
 		return 0;
 
-	if (parts.slabindex > depot_index) {
+	if (parts.slab_index > slab_index) {
 		WARN(1, "slab index %d out of bounds (%d) for stack id %08x\n",
-			parts.slabindex, depot_index, handle);
+			parts.slab_index, slab_index, handle);
 		return 0;
 	}
-	slab = stack_slabs[parts.slabindex];
+	slab = stack_slabs[parts.slab_index];
 	if (!slab)
 		return 0;
 	stack = slab + offset;
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

