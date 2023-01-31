Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96E6C63797
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjAaAYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjAaAYr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1401633E
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A2256133A
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6FEC433D2;
        Tue, 31 Jan 2023 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124684;
        bh=dt27vbDNxK5GTAvAVDmgz+z7LSC6H43/TLketv9zQlU=;
        h=Date:To:From:Subject:From;
        b=eVAdFaaNwCNpCnZNNtlW8rI+QZd8jiN2iUkVKyhp3VsrOPEEn9CZW85lpA5ZRbyio
         ZmCSAK8/60Au4jSu1qhOG297baouxUShRcMzZoXdIw/7G0OJmMNNPTjJWmhjDtuu7y
         vSKlQK/nfXGIgLr6Hk7vVvmj3LP4nG9F7rG+Ket4=
Date:   Mon, 30 Jan 2023 16:24:43 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-handle-and-slab-constants.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002444.8E6FEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename handle and slab constants
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-handle-and-slab-constants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-handle-and-slab-constants.patch

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
Subject: lib/stackdepot: rename handle and slab constants
Date: Mon, 30 Jan 2023 21:49:36 +0100

Change the "STACK_ALLOC_" prefix to "DEPOT_" for the constants that define
the number of bits in stack depot handles and the maximum number of slabs.

The old prefix is unclear and makes wonder about how these constants are
related to stack allocations.  The new prefix is also shorter.

Also simplify the comment for DEPOT_SLAB_ORDER.

No functional changes.

Link: https://lkml.kernel.org/r/d9c6d1fa0ae6e1e65577ee81444656c99eb598d8.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-handle-and-slab-constants
+++ a/lib/stackdepot.c
@@ -36,30 +36,28 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
-#define DEPOT_STACK_BITS (sizeof(depot_stack_handle_t) * 8)
+#define DEPOT_HANDLE_BITS (sizeof(depot_stack_handle_t) * 8)
 
-#define STACK_ALLOC_NULL_PROTECTION_BITS 1
-#define STACK_ALLOC_ORDER 2 /* 'Slab' size order for stack depot, 4 pages */
-#define STACK_ALLOC_SIZE (1LL << (PAGE_SHIFT + STACK_ALLOC_ORDER))
-#define STACK_ALLOC_ALIGN 4
-#define STACK_ALLOC_OFFSET_BITS (STACK_ALLOC_ORDER + PAGE_SHIFT - \
-					STACK_ALLOC_ALIGN)
-#define STACK_ALLOC_INDEX_BITS (DEPOT_STACK_BITS - \
-		STACK_ALLOC_NULL_PROTECTION_BITS - \
-		STACK_ALLOC_OFFSET_BITS - STACK_DEPOT_EXTRA_BITS)
-#define STACK_ALLOC_SLABS_CAP 8192
-#define STACK_ALLOC_MAX_SLABS \
-	(((1LL << (STACK_ALLOC_INDEX_BITS)) < STACK_ALLOC_SLABS_CAP) ? \
-	 (1LL << (STACK_ALLOC_INDEX_BITS)) : STACK_ALLOC_SLABS_CAP)
+#define DEPOT_VALID_BITS 1
+#define DEPOT_SLAB_ORDER 2 /* Slab size order, 4 pages */
+#define DEPOT_SLAB_SIZE (1LL << (PAGE_SHIFT + DEPOT_SLAB_ORDER))
+#define DEPOT_STACK_ALIGN 4
+#define DEPOT_OFFSET_BITS (DEPOT_SLAB_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
+#define DEPOT_SLAB_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_VALID_BITS - \
+			       DEPOT_OFFSET_BITS - STACK_DEPOT_EXTRA_BITS)
+#define DEPOT_SLABS_CAP 8192
+#define DEPOT_MAX_SLABS \
+	(((1LL << (DEPOT_SLAB_INDEX_BITS)) < DEPOT_SLABS_CAP) ? \
+	 (1LL << (DEPOT_SLAB_INDEX_BITS)) : DEPOT_SLABS_CAP)
 
 /* The compact structure to store the reference to stacks. */
 union handle_parts {
 	depot_stack_handle_t handle;
 	struct {
-		u32 slab_index : STACK_ALLOC_INDEX_BITS;
-		u32 offset : STACK_ALLOC_OFFSET_BITS;
-		u32 valid : STACK_ALLOC_NULL_PROTECTION_BITS;
-		u32 extra : STACK_DEPOT_EXTRA_BITS;
+		u32 slab_index	: DEPOT_SLAB_INDEX_BITS;
+		u32 offset	: DEPOT_OFFSET_BITS;
+		u32 valid	: DEPOT_VALID_BITS;
+		u32 extra	: STACK_DEPOT_EXTRA_BITS;
 	};
 };
 
@@ -91,7 +89,7 @@ static unsigned int stack_bucket_number_
 static unsigned int stack_hash_mask;
 
 /* Array of memory regions that store stack traces. */
-static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
+static void *stack_slabs[DEPOT_MAX_SLABS];
 /* Currently used slab in stack_slabs. */
 static int slab_index;
 /* Offset to the unused space in the currently used slab. */
@@ -235,7 +233,7 @@ static bool depot_init_slab(void **preal
 		*prealloc = NULL;
 	} else {
 		/* If this is the last depot slab, do not touch the next one. */
-		if (slab_index + 1 < STACK_ALLOC_MAX_SLABS) {
+		if (slab_index + 1 < DEPOT_MAX_SLABS) {
 			stack_slabs[slab_index + 1] = *prealloc;
 			*prealloc = NULL;
 			/*
@@ -256,10 +254,10 @@ depot_alloc_stack(unsigned long *entries
 	struct stack_record *stack;
 	size_t required_size = struct_size(stack, entries, size);
 
-	required_size = ALIGN(required_size, 1 << STACK_ALLOC_ALIGN);
+	required_size = ALIGN(required_size, 1 << DEPOT_STACK_ALIGN);
 
-	if (unlikely(slab_offset + required_size > STACK_ALLOC_SIZE)) {
-		if (unlikely(slab_index + 1 >= STACK_ALLOC_MAX_SLABS)) {
+	if (unlikely(slab_offset + required_size > DEPOT_SLAB_SIZE)) {
+		if (unlikely(slab_index + 1 >= DEPOT_MAX_SLABS)) {
 			WARN_ONCE(1, "Stack depot reached limit capacity");
 			return NULL;
 		}
@@ -270,7 +268,7 @@ depot_alloc_stack(unsigned long *entries
 		 * |next_slab_inited| in stack_depot_save() and
 		 * depot_init_slab().
 		 */
-		if (slab_index + 1 < STACK_ALLOC_MAX_SLABS)
+		if (slab_index + 1 < DEPOT_MAX_SLABS)
 			smp_store_release(&next_slab_inited, 0);
 	}
 	depot_init_slab(prealloc);
@@ -282,7 +280,7 @@ depot_alloc_stack(unsigned long *entries
 	stack->hash = hash;
 	stack->size = size;
 	stack->handle.slab_index = slab_index;
-	stack->handle.offset = slab_offset >> STACK_ALLOC_ALIGN;
+	stack->handle.offset = slab_offset >> DEPOT_STACK_ALIGN;
 	stack->handle.valid = 1;
 	stack->handle.extra = 0;
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
@@ -413,7 +411,7 @@ depot_stack_handle_t __stack_depot_save(
 		alloc_flags &= ~GFP_ZONEMASK;
 		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
 		alloc_flags |= __GFP_NOWARN;
-		page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);
+		page = alloc_pages(alloc_flags, DEPOT_SLAB_ORDER);
 		if (page)
 			prealloc = page_address(page);
 	}
@@ -445,7 +443,7 @@ depot_stack_handle_t __stack_depot_save(
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
-		free_pages((unsigned long)prealloc, STACK_ALLOC_ORDER);
+		free_pages((unsigned long)prealloc, DEPOT_SLAB_ORDER);
 	}
 	if (found)
 		retval.handle = found->handle.handle;
@@ -490,7 +488,7 @@ unsigned int stack_depot_fetch(depot_sta
 {
 	union handle_parts parts = { .handle = handle };
 	void *slab;
-	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
+	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
 	*entries = NULL;
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

