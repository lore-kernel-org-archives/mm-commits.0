Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221BCC636D6
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjAaAYi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjAaAYh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA6A199CB
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0211CB818C2
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858C1C433EF;
        Tue, 31 Jan 2023 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124672;
        bh=T/8U5dMEa+DrWLkgTxh+XCtiX6iBoOjoBPDo4ABj4nM=;
        h=Date:To:From:Subject:From;
        b=NdfU/u21Hdhqu4I+b4meB+iX3dnsfqo5Dp1HEMF+Z3vyvRcWtShRcMCNjCn7gE0k0
         xpMx/wm1Iq6ClajxpQr+8roldiVgzvrVHjNdu9ZpmAZ314Gz2c9x+Iirg24etldCeB
         7hxu7AVjlvFeY2SFVNgXhHpvdynNc8+ABsM3IGLM=
Date:   Mon, 30 Jan 2023 16:24:31 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-rename-stack_depot_disable.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002432.858C1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: rename stack_depot_disable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-rename-stack_depot_disable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-rename-stack_depot_disable.patch

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
Subject: lib/stackdepot: rename stack_depot_disable
Date: Mon, 30 Jan 2023 21:49:29 +0100

Rename stack_depot_disable to stack_depot_disabled to make its name look
similar to the names of other stack depot flags.

Also put stack_depot_disabled's definition together with the other flags.

Also rename is_stack_depot_disabled to disable_stack_depot: this name
looks more conventional for a function that processes a boot parameter.

No functional changes.

Link: https://lkml.kernel.org/r/293567627b0d59f1ae5a27ac9537c027a5ff729d.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-stack_depot_disable
+++ a/lib/stackdepot.c
@@ -71,6 +71,7 @@ struct stack_record {
 	unsigned long entries[];	/* Variable-sized array of entries. */
 };
 
+static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
 
@@ -91,21 +92,20 @@ static DEFINE_RAW_SPINLOCK(depot_lock);
 static unsigned int stack_hash_order;
 static unsigned int stack_hash_mask;
 
-static bool stack_depot_disable;
 static struct stack_record **stack_table;
 
-static int __init is_stack_depot_disabled(char *str)
+static int __init disable_stack_depot(char *str)
 {
 	int ret;
 
-	ret = kstrtobool(str, &stack_depot_disable);
-	if (!ret && stack_depot_disable) {
+	ret = kstrtobool(str, &stack_depot_disabled);
+	if (!ret && stack_depot_disabled) {
 		pr_info("disabled\n");
 		stack_table = NULL;
 	}
 	return 0;
 }
-early_param("stack_depot_disable", is_stack_depot_disabled);
+early_param("stack_depot_disable", disable_stack_depot);
 
 void __init stack_depot_request_early_init(void)
 {
@@ -128,7 +128,7 @@ int __init stack_depot_early_init(void)
 	if (kasan_enabled() && !stack_hash_order)
 		stack_hash_order = STACK_HASH_ORDER_MAX;
 
-	if (!__stack_depot_early_init_requested || stack_depot_disable)
+	if (!__stack_depot_early_init_requested || stack_depot_disabled)
 		return 0;
 
 	if (stack_hash_order)
@@ -145,7 +145,7 @@ int __init stack_depot_early_init(void)
 
 	if (!stack_table) {
 		pr_err("hash table allocation failed, disabling\n");
-		stack_depot_disable = true;
+		stack_depot_disabled = true;
 		return -ENOMEM;
 	}
 
@@ -158,7 +158,7 @@ int stack_depot_init(void)
 	int ret = 0;
 
 	mutex_lock(&stack_depot_init_mutex);
-	if (!stack_depot_disable && !stack_table) {
+	if (!stack_depot_disabled && !stack_table) {
 		unsigned long entries;
 		int scale = STACK_HASH_SCALE;
 
@@ -184,7 +184,7 @@ int stack_depot_init(void)
 		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
 		if (!stack_table) {
 			pr_err("hash table allocation failed, disabling\n");
-			stack_depot_disable = true;
+			stack_depot_disabled = true;
 			ret = -ENOMEM;
 		}
 		stack_hash_mask = entries - 1;
@@ -354,7 +354,7 @@ depot_stack_handle_t __stack_depot_save(
 	 */
 	nr_entries = filter_irq_stacks(entries, nr_entries);
 
-	if (unlikely(nr_entries == 0) || stack_depot_disable)
+	if (unlikely(nr_entries == 0) || stack_depot_disabled)
 		goto fast_exit;
 
 	hash = hash_stack(entries, nr_entries);
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

