Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C164C54EAA
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjAaAYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjAaAYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4302E166CA
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D092061314
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C5EC433D2;
        Tue, 31 Jan 2023 00:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124668;
        bh=u7TyFayUa/xtYOO1g4uzbEkCAP5PZaelkB7bA3Q1cuw=;
        h=Date:To:From:Subject:From;
        b=c03C85QV8Nk52RS2R4CHkdT3JZSty5FRs2ivLRpNLZ6pgFPcOmp0L9imvhRjhFN00
         LgM3gR7dV5PQgcaTq0uDsI9uZLYEyvbuhTP7SijZUD+ykoFCix7hLhSPOcZv0aZd0x
         msDYo6YkglPkMpahqXc1HG64v/wIbRs6OBzz62Kg=
Date:   Mon, 30 Jan 2023 16:24:27 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-use-pr_fmt-to-define-message-format.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002428.31C5EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: use pr_fmt to define message format
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-use-pr_fmt-to-define-message-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-use-pr_fmt-to-define-message-format.patch

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
Subject: lib/stackdepot: use pr_fmt to define message format
Date: Mon, 30 Jan 2023 21:49:27 +0100

Use pr_fmt to define the format for printing stack depot messages instead
of duplicating the "Stack Depot" prefix in each message.

Link: https://lkml.kernel.org/r/3600069e0b0b3df602999ec8a2d4fc14fcc56a01.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-use-pr_fmt-to-define-message-format
+++ a/lib/stackdepot.c
@@ -19,6 +19,8 @@
  * Based on code by Dmitry Chernenkov.
  */
 
+#define pr_fmt(fmt) "stackdepot: " fmt
+
 #include <linux/gfp.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
@@ -98,7 +100,7 @@ static int __init is_stack_depot_disable
 
 	ret = kstrtobool(str, &stack_depot_disable);
 	if (!ret && stack_depot_disable) {
-		pr_info("Stack Depot is disabled\n");
+		pr_info("disabled\n");
 		stack_table = NULL;
 	}
 	return 0;
@@ -142,7 +144,7 @@ int __init stack_depot_early_init(void)
 						1UL << STACK_HASH_ORDER_MAX);
 
 	if (!stack_table) {
-		pr_err("Stack Depot hash table allocation failed, disabling\n");
+		pr_err("hash table allocation failed, disabling\n");
 		stack_depot_disable = true;
 		return -ENOMEM;
 	}
@@ -177,11 +179,11 @@ int stack_depot_init(void)
 		if (entries > 1UL << STACK_HASH_ORDER_MAX)
 			entries = 1UL << STACK_HASH_ORDER_MAX;
 
-		pr_info("Stack Depot allocating hash table of %lu entries with kvcalloc\n",
+		pr_info("allocating hash table of %lu entries with kvcalloc\n",
 				entries);
 		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
 		if (!stack_table) {
-			pr_err("Stack Depot hash table allocation failed, disabling\n");
+			pr_err("hash table allocation failed, disabling\n");
 			stack_depot_disable = true;
 			ret = -ENOMEM;
 		}
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

