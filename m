Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0528C636D7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbjBJVvj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbjBJVvh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0DF60E46
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF9A5B825E0
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D77C4339B;
        Fri, 10 Feb 2023 21:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065890;
        bh=DaGHYXbncsb1d64TWe/G/NyE2TjS9DhwXN0XAd9c3Vg=;
        h=Date:To:From:Subject:From;
        b=BWyg3U633iwV79FtWzcZ5hhMP7xe4IrhdaSI2LcznINEmZu/IIhJBzmjMDApOv0DN
         o0EQweeBjHddVxqwtOhufFL+z73qNgAVgocBpacuwcV4nZZIlfxCig9m2hjjoxw6pG
         RiWeW7ige6Zazp/hZ29+ZtDmKcMN0k+5tfDgCHIM=
Date:   Fri, 10 Feb 2023 13:51:29 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215130.68D77C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: lower the indentation in stack_depot_init
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch

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
Subject: lib/stackdepot: lower the indentation in stack_depot_init
Date: Fri, 10 Feb 2023 22:15:54 +0100

stack_depot_init does most things inside an if check. Move them out and
use a goto statement instead.

No functional changes.

Link: https://lkml.kernel.org/r/8e382f1f0c352e4b2ad47326fec7782af961fe8e.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-lower-the-indentation-in-stack_depot_init
+++ a/lib/stackdepot.c
@@ -165,46 +165,50 @@ int __init stack_depot_early_init(void)
 int stack_depot_init(void)
 {
 	static DEFINE_MUTEX(stack_depot_init_mutex);
+	unsigned long entries;
 	int ret = 0;
 
 	mutex_lock(&stack_depot_init_mutex);
-	if (!stack_depot_disabled && !stack_table) {
-		unsigned long entries;
 
-		/*
-		 * Similarly to stack_depot_early_init, use stack_hash_order
-		 * if assigned, and rely on automatic scaling otherwise.
-		 */
-		if (stack_hash_order) {
-			entries = 1UL << stack_hash_order;
-		} else {
-			int scale = STACK_HASH_SCALE;
-
-			entries = nr_free_buffer_pages();
-			entries = roundup_pow_of_two(entries);
-
-			if (scale > PAGE_SHIFT)
-				entries >>= (scale - PAGE_SHIFT);
-			else
-				entries <<= (PAGE_SHIFT - scale);
-		}
-
-		if (entries < 1UL << STACK_HASH_ORDER_MIN)
-			entries = 1UL << STACK_HASH_ORDER_MIN;
-		if (entries > 1UL << STACK_HASH_ORDER_MAX)
-			entries = 1UL << STACK_HASH_ORDER_MAX;
-
-		pr_info("allocating hash table of %lu entries via kvcalloc\n",
-				entries);
-		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
-		if (!stack_table) {
-			pr_err("hash table allocation failed, disabling\n");
-			stack_depot_disabled = true;
-			ret = -ENOMEM;
-		}
-		stack_hash_mask = entries - 1;
+	if (stack_depot_disabled || stack_table)
+		goto out_unlock;
+
+	/*
+	 * Similarly to stack_depot_early_init, use stack_hash_order
+	 * if assigned, and rely on automatic scaling otherwise.
+	 */
+	if (stack_hash_order) {
+		entries = 1UL << stack_hash_order;
+	} else {
+		int scale = STACK_HASH_SCALE;
+
+		entries = nr_free_buffer_pages();
+		entries = roundup_pow_of_two(entries);
+
+		if (scale > PAGE_SHIFT)
+			entries >>= (scale - PAGE_SHIFT);
+		else
+			entries <<= (PAGE_SHIFT - scale);
+	}
+
+	if (entries < 1UL << STACK_HASH_ORDER_MIN)
+		entries = 1UL << STACK_HASH_ORDER_MIN;
+	if (entries > 1UL << STACK_HASH_ORDER_MAX)
+		entries = 1UL << STACK_HASH_ORDER_MAX;
+
+	pr_info("allocating hash table of %lu entries via kvcalloc\n", entries);
+	stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
+	if (!stack_table) {
+		pr_err("hash table allocation failed, disabling\n");
+		stack_depot_disabled = true;
+		ret = -ENOMEM;
+		goto out_unlock;
 	}
+	stack_hash_mask = entries - 1;
+
+out_unlock:
 	mutex_unlock(&stack_depot_init_mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
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

