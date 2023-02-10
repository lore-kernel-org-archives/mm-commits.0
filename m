Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433F4C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjBJVwL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbjBJVv5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3AFB47D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07D1361E50
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B36CC433D2;
        Fri, 10 Feb 2023 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065912;
        bh=KjF5MV5wWe4UPhL7Mk7k6nwyUOQ6CVYq+HAgzoY11Wo=;
        h=Date:To:From:Subject:From;
        b=ykUeCeyjE3UAPAMh3HM+/mznnqgpPeSG/7lXge3c9i8wzZFjqK+mLOwhd6OatMAEi
         pkABxv3CT1U8H1t7WVcsEDq6tPJ+E+x47NooksUAUr3HTBRI4c0dPeWgsVal3kSLvt
         Ss/81QJ3MXfcpiLNvtUh/TPqdaxN3whnv/0qFX5Y=
Date:   Fri, 10 Feb 2023 13:51:51 -0800
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-move-documentation-comments-to-stackdepoth.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215152.5B36CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: move documentation comments to stackdepot.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

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
Subject: lib/stackdepot: move documentation comments to stackdepot.h
Date: Fri, 10 Feb 2023 22:16:06 +0100

Move all interface- and usage-related documentation comments to
include/linux/stackdepot.h.

It makes sense to have them in the header where they are available to
the interface users.

Link: https://lkml.kernel.org/r/fbfee41495b306dd8881f9b1c1b80999c885e82f.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/stackdepot.h~lib-stackdepot-move-documentation-comments-to-stackdepoth
+++ a/include/linux/stackdepot.h
@@ -2,6 +2,17 @@
 /*
  * Stack depot - a stack trace storage that avoids duplication.
  *
+ * Stack depot is intended to be used by subsystems that need to store and
+ * later retrieve many potentially duplicated stack traces without wasting
+ * memory.
+ *
+ * For example, KASAN needs to save allocation and free stack traces for each
+ * object. Storing two stack traces per object requires a lot of memory (e.g.
+ * SLUB_DEBUG needs 256 bytes per object for that). Since allocation and free
+ * stack traces often repeat, using stack depot allows to save about 100x space.
+ *
+ * Stack traces are never removed from stack depot.
+ *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
  *
@@ -57,24 +68,100 @@ static inline void stack_depot_request_e
 static inline int stack_depot_early_init(void)	{ return 0; }
 #endif
 
+/**
+ * __stack_depot_save - Save a stack trace to stack depot
+ *
+ * @entries:		Pointer to the stack trace
+ * @nr_entries:		Number of frames in the stack
+ * @alloc_flags:	Allocation GFP flags
+ * @can_alloc:		Allocate stack pools (increased chance of failure if false)
+ *
+ * Saves a stack trace from @entries array of size @nr_entries. If @can_alloc is
+ * %true, stack depot can replenish the stack pools in case no space is left
+ * (allocates using GFP flags of @alloc_flags). If @can_alloc is %false, avoids
+ * any allocations and fails if no space is left to store the stack trace.
+ *
+ * If the provided stack trace comes from the interrupt context, only the part
+ * up to the interrupt entry is saved.
+ *
+ * Context: Any context, but setting @can_alloc to %false is required if
+ *          alloc_pages() cannot be used from the current context. Currently
+ *          this is the case for contexts where neither %GFP_ATOMIC nor
+ *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
+ *
+ * Return: Handle of the stack struct stored in depot, 0 on failure
+ */
 depot_stack_handle_t __stack_depot_save(unsigned long *entries,
 					unsigned int nr_entries,
 					gfp_t gfp_flags, bool can_alloc);
 
+/**
+ * stack_depot_save - Save a stack trace to stack depot
+ *
+ * @entries:		Pointer to the stack trace
+ * @nr_entries:		Number of frames in the stack
+ * @alloc_flags:	Allocation GFP flags
+ *
+ * Context: Contexts where allocations via alloc_pages() are allowed.
+ *          See __stack_depot_save() for more details.
+ *
+ * Return: Handle of the stack trace stored in depot, 0 on failure
+ */
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
 				      unsigned int nr_entries, gfp_t gfp_flags);
 
+/**
+ * stack_depot_fetch - Fetch a stack trace from stack depot
+ *
+ * @handle:	Stack depot handle returned from stack_depot_save()
+ * @entries:	Pointer to store the address of the stack trace
+ *
+ * Return: Number of frames for the fetched stack
+ */
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+/**
+ * stack_depot_print - Print a stack trace from stack depot
+ *
+ * @stack:	Stack depot handle returned from stack_depot_save()
+ */
 void stack_depot_print(depot_stack_handle_t stack);
 
+/**
+ * stack_depot_snprint - Print a stack trace from stack depot into a buffer
+ *
+ * @handle:	Stack depot handle returned from stack_depot_save()
+ * @buf:	Pointer to the print buffer
+ * @size:	Size of the print buffer
+ * @spaces:	Number of leading spaces to print
+ *
+ * Return:	Number of bytes printed
+ */
 int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 		       int spaces);
 
+/**
+ * stack_depot_set_extra_bits - Set extra bits in a stack depot handle
+ *
+ * @handle:	Stack depot handle returned from stack_depot_save()
+ * @extra_bits:	Value to set the extra bits
+ *
+ * Return: Stack depot handle with extra bits set
+ *
+ * Stack depot handles have a few unused bits, which can be used for storing
+ * user-specific information. These bits are transparent to the stack depot.
+ */
 depot_stack_handle_t __must_check stack_depot_set_extra_bits(
 			depot_stack_handle_t handle, unsigned int extra_bits);
 
+/**
+ * stack_depot_get_extra_bits - Retrieve extra bits from a stack depot handle
+ *
+ * @handle:	Stack depot handle with extra bits saved
+ *
+ * Return: Extra bits retrieved from the stack depot handle
+ */
 unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle);
 
 #endif
--- a/lib/stackdepot.c~lib-stackdepot-move-documentation-comments-to-stackdepoth
+++ a/lib/stackdepot.c
@@ -2,21 +2,10 @@
 /*
  * Stack depot - a stack trace storage that avoids duplication.
  *
- * Stack depot is intended to be used by subsystems that need to store and
- * later retrieve many potentially duplicated stack traces without wasting
- * memory.
- *
- * For example, KASAN needs to save allocation and free stack traces for each
- * object. Storing two stack traces per object requires a lot of memory (e.g.
- * SLUB_DEBUG needs 256 bytes per object for that). Since allocation and free
- * stack traces often repeat, using stack depot allows to save about 100x space.
- *
  * Internally, stack depot maintains a hash table of unique stacktraces. The
  * stack traces themselves are stored contiguously one after another in a set
  * of separate page allocations.
  *
- * Stack traces are never removed from stack depot.
- *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
  *
@@ -360,29 +349,6 @@ static inline struct stack_record *find_
 	return NULL;
 }
 
-/**
- * __stack_depot_save - Save a stack trace to stack depot
- *
- * @entries:		Pointer to the stack trace
- * @nr_entries:		Number of frames in the stack
- * @alloc_flags:	Allocation GFP flags
- * @can_alloc:		Allocate stack pools (increased chance of failure if false)
- *
- * Saves a stack trace from @entries array of size @nr_entries. If @can_alloc is
- * %true, stack depot can replenish the stack pools in case no space is left
- * (allocates using GFP flags of @alloc_flags). If @can_alloc is %false, avoids
- * any allocations and fails if no space is left to store the stack trace.
- *
- * If the provided stack trace comes from the interrupt context, only the part
- * up to the interrupt entry is saved.
- *
- * Context: Any context, but setting @can_alloc to %false is required if
- *          alloc_pages() cannot be used from the current context. Currently
- *          this is the case for contexts where neither %GFP_ATOMIC nor
- *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
- *
- * Return: Handle of the stack struct stored in depot, 0 on failure
- */
 depot_stack_handle_t __stack_depot_save(unsigned long *entries,
 					unsigned int nr_entries,
 					gfp_t alloc_flags, bool can_alloc)
@@ -477,18 +443,6 @@ fast_exit:
 }
 EXPORT_SYMBOL_GPL(__stack_depot_save);
 
-/**
- * stack_depot_save - Save a stack trace to stack depot
- *
- * @entries:		Pointer to the stack trace
- * @nr_entries:		Number of frames in the stack
- * @alloc_flags:	Allocation GFP flags
- *
- * Context: Contexts where allocations via alloc_pages() are allowed.
- *          See __stack_depot_save() for more details.
- *
- * Return: Handle of the stack trace stored in depot, 0 on failure
- */
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
 				      unsigned int nr_entries,
 				      gfp_t alloc_flags)
@@ -497,14 +451,6 @@ depot_stack_handle_t stack_depot_save(un
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
 
-/**
- * stack_depot_fetch - Fetch a stack trace from stack depot
- *
- * @handle:	Stack depot handle returned from stack_depot_save()
- * @entries:	Pointer to store the address of the stack trace
- *
- * Return: Number of frames for the fetched stack
- */
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries)
 {
@@ -537,11 +483,6 @@ unsigned int stack_depot_fetch(depot_sta
 }
 EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
-/**
- * stack_depot_print - Print a stack trace from stack depot
- *
- * @stack:	Stack depot handle returned from stack_depot_save()
- */
 void stack_depot_print(depot_stack_handle_t stack)
 {
 	unsigned long *entries;
@@ -553,16 +494,6 @@ void stack_depot_print(depot_stack_handl
 }
 EXPORT_SYMBOL_GPL(stack_depot_print);
 
-/**
- * stack_depot_snprint - Print a stack trace from stack depot into a buffer
- *
- * @handle:	Stack depot handle returned from stack_depot_save()
- * @buf:	Pointer to the print buffer
- * @size:	Size of the print buffer
- * @spaces:	Number of leading spaces to print
- *
- * Return:	Number of bytes printed
- */
 int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 		       int spaces)
 {
@@ -575,17 +506,6 @@ int stack_depot_snprint(depot_stack_hand
 }
 EXPORT_SYMBOL_GPL(stack_depot_snprint);
 
-/**
- * stack_depot_set_extra_bits - Set extra bits in a stack depot handle
- *
- * @handle:	Stack depot handle returned from stack_depot_save()
- * @extra_bits:	Value to set the extra bits
- *
- * Return: Stack depot handle with extra bits set
- *
- * Stack depot handles have a few unused bits, which can be used for storing
- * user-specific information. These bits are transparent to the stack depot.
- */
 depot_stack_handle_t __must_check stack_depot_set_extra_bits(
 			depot_stack_handle_t handle, unsigned int extra_bits)
 {
@@ -600,13 +520,6 @@ depot_stack_handle_t __must_check stack_
 }
 EXPORT_SYMBOL(stack_depot_set_extra_bits);
 
-/**
- * stack_depot_get_extra_bits - Retrieve extra bits from a stack depot handle
- *
- * @handle:	Stack depot handle with extra bits saved
- *
- * Return: Extra bits retrieved from the stack depot handle
- */
 unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle)
 {
 	union handle_parts parts = { .handle = handle };
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

