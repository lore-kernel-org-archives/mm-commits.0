Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABFAC636D3
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjAaAYs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjAaAYk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D449B193D8
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702A761341
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EC3C4339E;
        Tue, 31 Jan 2023 00:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124677;
        bh=EL/aLkZSaf9ikYSh3IxGhpGvwNuUoY/4lsKacqWzuDc=;
        h=Date:To:From:Subject:From;
        b=QxxLS7O/4gj4Nrcsdp/XwGWIGey8AwD3ENExPAq0sfm1DPGvXeraQciJ1Fj72dlnK
         uk2kvDk6rZIowRJChW2PP6B9xKztq7qk9rHcfzpaB2/gLIdUVdZ1KNs3Bg8oKEb0K0
         rlCTRboR0Pa/2zpuRCfXT0KjzshO2Y05s+fFzr0c=
Date:   Mon, 30 Jan 2023 16:24:37 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-reorder-and-annotate-global-variables.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002437.C5EC3C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: reorder and annotate global variables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-reorder-and-annotate-global-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-reorder-and-annotate-global-variables.patch

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
Subject: lib/stackdepot: reorder and annotate global variables
Date: Mon, 30 Jan 2023 21:49:32 +0100

Group stack depot global variables by their purpose:

1. Hash table-related variables,
2. Slab-related variables,

and add comments.

Also clean up comments for hash table-related constants.

Link: https://lkml.kernel.org/r/4ed1d0828e837e15566a7cfa7688a47006e3f4b3.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-reorder-and-annotate-global-variables
+++ a/lib/stackdepot.c
@@ -75,24 +75,31 @@ static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
 
-static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
-
-static int depot_index;
-static int next_slab_inited;
-static size_t depot_offset;
-static DEFINE_RAW_SPINLOCK(depot_lock);
-
-/* one hash table bucket entry per 16kB of memory */
+/* Use one hash table bucket per 16 KB of memory. */
 #define STACK_HASH_SCALE	14
-/* limited between 4k and 1M buckets */
+/* Limit the number of buckets between 4K and 1M. */
 #define STACK_HASH_ORDER_MIN	12
 #define STACK_HASH_ORDER_MAX	20
+/* Initial seed for jhash2. */
 #define STACK_HASH_SEED 0x9747b28c
 
+/* Hash table of pointers to stored stack traces. */
+static struct stack_record **stack_table;
+/* Fixed order of the number of table buckets. Used when KASAN is enabled. */
 static unsigned int stack_hash_order;
+/* Hash mask for indexing the table. */
 static unsigned int stack_hash_mask;
 
-static struct stack_record **stack_table;
+/* Array of memory regions that store stack traces. */
+static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
+/* Currently used slab in stack_slabs. */
+static int depot_index;
+/* Offset to the unused space in the currently used slab. */
+static size_t depot_offset;
+/* Lock that protects the variables above. */
+static DEFINE_RAW_SPINLOCK(depot_lock);
+/* Whether the next slab is initialized. */
+static int next_slab_inited;
 
 static int __init disable_stack_depot(char *str)
 {
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

