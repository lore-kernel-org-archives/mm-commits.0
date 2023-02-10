Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D7EC6379F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjBJVvi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjBJVvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1B53E0A1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40699B825E6
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA237C433EF;
        Fri, 10 Feb 2023 21:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065888;
        bh=1ZWiN5ojjXF3mozXacG+pCvtfJKMCaAFpMPJGsi4Xd4=;
        h=Date:To:From:Subject:From;
        b=S3fYDSbuzbAvKanKpFVXCdzpaqoypwH5ENtGeGPsdywODurMX1BphwdqXGobJRRai
         gwUDjb4zxC5GUNKLEaNx6mQKRXhcVndagiYgG3UUIRe67gGzXj2A6+kpTUOLULiQK6
         gCIyIaya1GjkZblAIzefi92Kul29MRVUwnlymzwE=
Date:   Fri, 10 Feb 2023 13:51:28 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-annotate-init-and-early-init-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215128.CA237C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: annotate init and early init functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-annotate-init-and-early-init-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-annotate-init-and-early-init-functions.patch

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
Subject: lib/stackdepot: annotate init and early init functions
Date: Fri, 10 Feb 2023 22:15:53 +0100

Add comments to stack_depot_early_init and stack_depot_init to explain
certain parts of their implementation.

Also add a pr_info message to stack_depot_early_init similar to the one
in stack_depot_init.

Also move the scale variable in stack_depot_init to the scope where it
is being used.

Link: https://lkml.kernel.org/r/d17fbfbd4d73f38686c5e3d4824a6d62047213a1.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-annotate-init-and-early-init-functions
+++ a/lib/stackdepot.c
@@ -115,24 +115,34 @@ void __init stack_depot_request_early_in
 	__stack_depot_early_init_requested = true;
 }
 
+/* Allocates a hash table via memblock. Can only be used during early boot. */
 int __init stack_depot_early_init(void)
 {
 	unsigned long entries = 0;
 
-	/* This is supposed to be called only once, from mm_init() */
+	/* This function must be called only once, from mm_init(). */
 	if (WARN_ON(__stack_depot_early_init_passed))
 		return 0;
-
 	__stack_depot_early_init_passed = true;
 
+	/*
+	 * If KASAN is enabled, use the maximum order: KASAN is frequently used
+	 * in fuzzing scenarios, which leads to a large number of different
+	 * stack traces being stored in stack depot.
+	 */
 	if (kasan_enabled() && !stack_hash_order)
 		stack_hash_order = STACK_HASH_ORDER_MAX;
 
 	if (!__stack_depot_early_init_requested || stack_depot_disabled)
 		return 0;
 
+	/*
+	 * If stack_hash_order is not set, leave entries as 0 to rely on the
+	 * automatic calculations performed by alloc_large_system_hash.
+	 */
 	if (stack_hash_order)
-		entries = 1UL <<  stack_hash_order;
+		entries = 1UL << stack_hash_order;
+	pr_info("allocating hash table via alloc_large_system_hash\n");
 	stack_table = alloc_large_system_hash("stackdepot",
 						sizeof(struct stack_record *),
 						entries,
@@ -142,7 +152,6 @@ int __init stack_depot_early_init(void)
 						&stack_hash_mask,
 						1UL << STACK_HASH_ORDER_MIN,
 						1UL << STACK_HASH_ORDER_MAX);
-
 	if (!stack_table) {
 		pr_err("hash table allocation failed, disabling\n");
 		stack_depot_disabled = true;
@@ -152,6 +161,7 @@ int __init stack_depot_early_init(void)
 	return 0;
 }
 
+/* Allocates a hash table via kvcalloc. Can be used after boot. */
 int stack_depot_init(void)
 {
 	static DEFINE_MUTEX(stack_depot_init_mutex);
@@ -160,11 +170,16 @@ int stack_depot_init(void)
 	mutex_lock(&stack_depot_init_mutex);
 	if (!stack_depot_disabled && !stack_table) {
 		unsigned long entries;
-		int scale = STACK_HASH_SCALE;
 
+		/*
+		 * Similarly to stack_depot_early_init, use stack_hash_order
+		 * if assigned, and rely on automatic scaling otherwise.
+		 */
 		if (stack_hash_order) {
 			entries = 1UL << stack_hash_order;
 		} else {
+			int scale = STACK_HASH_SCALE;
+
 			entries = nr_free_buffer_pages();
 			entries = roundup_pow_of_two(entries);
 
@@ -179,7 +194,7 @@ int stack_depot_init(void)
 		if (entries > 1UL << STACK_HASH_ORDER_MAX)
 			entries = 1UL << STACK_HASH_ORDER_MAX;
 
-		pr_info("allocating hash table of %lu entries with kvcalloc\n",
+		pr_info("allocating hash table of %lu entries via kvcalloc\n",
 				entries);
 		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
 		if (!stack_table) {
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

