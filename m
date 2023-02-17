Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCF6C64ED8
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBQEof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjBQEo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809F537F06
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 197D66133B
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69232C433EF;
        Fri, 17 Feb 2023 04:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609066;
        bh=Potm4YjTyP+PfUBeW5aVoRSl33Hrgof8r7KTfV/7bgM=;
        h=Date:To:From:Subject:From;
        b=E/ihkEVnkStHJclm9YKn7q7qcmEFmW1W2iTN1yhXzOso7ufeLalL5wpT7R44JZlS/
         jgDdVYkcaGaKRFEgvNhNwSHKtgyY4jX/Whg+oqbiLPk06LHt67U8iPmU44aeZ2uyJF
         mNi/rzIX6qv/+yn7hnFe2y+gkEdKGTkpNzfqkj40=
Date:   Thu, 16 Feb 2023 20:44:25 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-reorder-and-annotate-global-variables.patch removed from -mm tree
Message-Id: <20230217044426.69232C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: reorder and annotate global variables
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-reorder-and-annotate-global-variables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: reorder and annotate global variables
Date: Fri, 10 Feb 2023 22:15:55 +0100

Group stack depot global variables by their purpose:

1. Hash table-related variables,
2. Slab-related variables,

and add comments.

Also clean up comments for hash table-related constants.

Link: https://lkml.kernel.org/r/5606a6c70659065a25bee59cd10e57fc60bb4110.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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


