Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5D8C636D7
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjAaAYt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjAaAYn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8A619683
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E1361341
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6A3C4339E;
        Tue, 31 Jan 2023 00:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124679;
        bh=SpRlKrzpbGYHW7PEanxHjVDYI20ML0785wNBTvMlRwU=;
        h=Date:To:From:Subject:From;
        b=SBv7Mv9inmyLieaPDGV7x99RmaQ64QCj0BvdNknnV+hEMHNwbmssXlXCcAatJ3ZNT
         VoKM5N8v47j3Wj6JwmvPxiJqC5BXC8NNXy6LxTjGkgaPW2SUZI7UNZehNdVoaMh8bK
         r0ZuwTPxarV6+2/nLe42Gga6crxK3lfbgsx775QY=
Date:   Mon, 30 Jan 2023 16:24:38 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-hash-table-constants-and-variables.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002439.7C6A3C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename hash table constants and variables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-hash-table-constants-and-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-hash-table-constants-and-variables.patch

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
Subject: lib/stackdepot: rename hash table constants and variables
Date: Mon, 30 Jan 2023 21:49:33 +0100

Give more meaningful names to hash table-related constants and variables:

1. Rename STACK_HASH_SCALE to STACK_TABLE_SCALE to point out that it is
   related to scaling the hash table.

2. Rename STACK_HASH_ORDER_MIN/MAX to STACK_BUCKET_NUMBER_ORDER_MIN/MAX
   to point out that it is related to the number of hash table buckets.

3. Rename stack_hash_order to stack_bucket_number_order for the same
   reason as #2.

No functional changes.

Link: https://lkml.kernel.org/r/5456286e2c9f3cd5abf25ad2e7e60dc997c71f66.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-hash-table-constants-and-variables
+++ a/lib/stackdepot.c
@@ -76,17 +76,17 @@ static bool __stack_depot_early_init_req
 static bool __stack_depot_early_init_passed __initdata;
 
 /* Use one hash table bucket per 16 KB of memory. */
-#define STACK_HASH_SCALE	14
+#define STACK_TABLE_SCALE 14
 /* Limit the number of buckets between 4K and 1M. */
-#define STACK_HASH_ORDER_MIN	12
-#define STACK_HASH_ORDER_MAX	20
+#define STACK_BUCKET_NUMBER_ORDER_MIN 12
+#define STACK_BUCKET_NUMBER_ORDER_MAX 20
 /* Initial seed for jhash2. */
 #define STACK_HASH_SEED 0x9747b28c
 
 /* Hash table of pointers to stored stack traces. */
 static struct stack_record **stack_table;
 /* Fixed order of the number of table buckets. Used when KASAN is enabled. */
-static unsigned int stack_hash_order;
+static unsigned int stack_bucket_number_order;
 /* Hash mask for indexing the table. */
 static unsigned int stack_hash_mask;
 
@@ -137,28 +137,28 @@ int __init stack_depot_early_init(void)
 	 * in fuzzing scenarios, which leads to a large number of different
 	 * stack traces being stored in stack depot.
 	 */
-	if (kasan_enabled() && !stack_hash_order)
-		stack_hash_order = STACK_HASH_ORDER_MAX;
+	if (kasan_enabled() && !stack_bucket_number_order)
+		stack_bucket_number_order = STACK_BUCKET_NUMBER_ORDER_MAX;
 
 	if (!__stack_depot_early_init_requested || stack_depot_disabled)
 		return 0;
 
 	/*
-	 * If stack_hash_order is not set, leave entries as 0 to rely on the
-	 * automatic calculations performed by alloc_large_system_hash.
+	 * If stack_bucket_number_order is not set, leave entries as 0 to rely
+	 * on the automatic calculations performed by alloc_large_system_hash.
 	 */
-	if (stack_hash_order)
-		entries = 1UL << stack_hash_order;
+	if (stack_bucket_number_order)
+		entries = 1UL << stack_bucket_number_order;
 	pr_info("allocating hash table via alloc_large_system_hash\n");
 	stack_table = alloc_large_system_hash("stackdepot",
 						sizeof(struct stack_record *),
 						entries,
-						STACK_HASH_SCALE,
+						STACK_TABLE_SCALE,
 						HASH_EARLY | HASH_ZERO,
 						NULL,
 						&stack_hash_mask,
-						1UL << STACK_HASH_ORDER_MIN,
-						1UL << STACK_HASH_ORDER_MAX);
+						1UL << STACK_BUCKET_NUMBER_ORDER_MIN,
+						1UL << STACK_BUCKET_NUMBER_ORDER_MAX);
 	if (!stack_table) {
 		pr_err("hash table allocation failed, disabling\n");
 		stack_depot_disabled = true;
@@ -181,13 +181,13 @@ int stack_depot_init(void)
 		goto out_unlock;
 
 	/*
-	 * Similarly to stack_depot_early_init, use stack_hash_order
+	 * Similarly to stack_depot_early_init, use stack_bucket_number_order
 	 * if assigned, and rely on automatic scaling otherwise.
 	 */
-	if (stack_hash_order) {
-		entries = 1UL << stack_hash_order;
+	if (stack_bucket_number_order) {
+		entries = 1UL << stack_bucket_number_order;
 	} else {
-		int scale = STACK_HASH_SCALE;
+		int scale = STACK_TABLE_SCALE;
 
 		entries = nr_free_buffer_pages();
 		entries = roundup_pow_of_two(entries);
@@ -198,10 +198,10 @@ int stack_depot_init(void)
 			entries <<= (PAGE_SHIFT - scale);
 	}
 
-	if (entries < 1UL << STACK_HASH_ORDER_MIN)
-		entries = 1UL << STACK_HASH_ORDER_MIN;
-	if (entries > 1UL << STACK_HASH_ORDER_MAX)
-		entries = 1UL << STACK_HASH_ORDER_MAX;
+	if (entries < 1UL << STACK_BUCKET_NUMBER_ORDER_MIN)
+		entries = 1UL << STACK_BUCKET_NUMBER_ORDER_MIN;
+	if (entries > 1UL << STACK_BUCKET_NUMBER_ORDER_MAX)
+		entries = 1UL << STACK_BUCKET_NUMBER_ORDER_MAX;
 
 	pr_info("allocating hash table of %lu entries via kvcalloc\n", entries);
 	stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
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

