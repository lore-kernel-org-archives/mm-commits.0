Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F4EC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiFUUnr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352430AbiFUUnp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:43:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7D925C60
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF702B81B22
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C029FC341C5;
        Tue, 21 Jun 2022 20:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655844221;
        bh=T2LuaNkcQnz3wikO7VlhICyF8yhWxJL4TzNCEuG7k8I=;
        h=Date:To:From:Subject:From;
        b=xONbWpFz1LuJkFT6ADfYaFd+m5YHL804G48BgcR/8022+k/Vdme+v+NVoo/02fuH/
         TJtLy2tDNzGevPBDEh2l11ZZGLa88uG9QJZYN+ZdrrSUu/+CjqVdDfQMlA4Nuu67gn
         B/2gPVNq1IzTWzHA7CYU3QO4SRrV/DRCCb0F/u+k=
Date:   Tue, 21 Jun 2022 13:43:32 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-replace-config_stack_hash_order-with-automatic-sizing.patch added to mm-nonmm-unstable branch
Message-Id: <20220621204339.C029FC341C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: replace CONFIG_STACK_HASH_ORDER with automatic sizing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-replace-config_stack_hash_order-with-automatic-sizing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-replace-config_stack_hash_order-with-automatic-sizing.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/stackdepot: replace CONFIG_STACK_HASH_ORDER with automatic sizing
Date: Mon, 20 Jun 2022 17:02:49 +0200

As Linus explained [1], setting the stackdepot hash table size as a config
option is suboptimal, especially as stackdepot becomes a dependency of
less "expert" subsystems than initially (e.g.  DRM, networking,
SLUB_DEBUG):

: (a) it introduces a new compile-time question that isn't sane to ask
: a regular user, but is now exposed to regular users.

: (b) this by default uses 1MB of memory for a feature that didn't in
: the past, so now if you have small machines you need to make sure you
: make a special kernel config for them.

Ideally we would employ rhashtable for fully automatic resizing, which
should be feasible for many of the new users, but problematic for the
original users with restricted context that call __stack_depot_save() with
can_alloc == false, i.e.  KASAN.

However we can easily remove the config option and scale the hash table
automatically with system memory.  The STACK_HASH_MASK constant becomes
stack_hash_mask variable and is used only in one mask operation, so the
overhead should be negligible to none.  For early allocation we can employ
the existing alloc_large_system_hash() function and perform similar
scaling for the late allocation.

The existing limits of the config option (between 4k and 1M buckets) are
preserved, and scaling factor is set to one bucket per 16kB memory so on
64bit the max 1M buckets (8MB memory) is achieved with 16GB system, while
a 1GB system will use 512kB.

Because KASAN is reported to need the maximum number of buckets even with
smaller amounts of memory [2], set it as such when kasan_enabled().

If needed, the automatic scaling could be complemented with a boot-time
kernel parameter, but it feels pointless to add it without a specific use
case.

[1] https://lore.kernel.org/all/CAHk-=wjC5nS+fnf6EzRD9yQRJApAhxx7gRB87ZV+pAWo9oVrTg@mail.gmail.com/
[2] https://lore.kernel.org/all/CACT4Y+Y4GZfXOru2z5tFPzFdaSUd+GFc6KVL=bsa0+1m197cQQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20220620150249.16814-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig      |    9 ------
 lib/stackdepot.c |   59 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 49 insertions(+), 19 deletions(-)

--- a/lib/Kconfig~lib-stackdepot-replace-config_stack_hash_order-with-automatic-sizing
+++ a/lib/Kconfig
@@ -685,15 +685,6 @@ config STACKDEPOT_ALWAYS_INIT
 	bool
 	select STACKDEPOT
 
-config STACK_HASH_ORDER
-	int "stack depot hash size (12 => 4KB, 20 => 1024KB)"
-	range 12 20
-	default 20
-	depends on STACKDEPOT
-	help
-	 Select the hash size as a power of 2 for the stackdepot hash table.
-	 Choose a lower value to reduce the memory impact.
-
 config REF_TRACKER
 	bool
 	depends on STACKTRACE_SUPPORT
--- a/lib/stackdepot.c~lib-stackdepot-replace-config_stack_hash_order-with-automatic-sizing
+++ a/lib/stackdepot.c
@@ -32,6 +32,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/memblock.h>
+#include <linux/kasan-enabled.h>
 
 #define DEPOT_STACK_BITS (sizeof(depot_stack_handle_t) * 8)
 
@@ -145,10 +146,16 @@ depot_alloc_stack(unsigned long *entries
 	return stack;
 }
 
-#define STACK_HASH_SIZE (1L << CONFIG_STACK_HASH_ORDER)
-#define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
+/* one hash table bucket entry per 16kB of memory */
+#define STACK_HASH_SCALE	14
+/* limited between 4k and 1M buckets */
+#define STACK_HASH_ORDER_MIN	12
+#define STACK_HASH_ORDER_MAX	20
 #define STACK_HASH_SEED 0x9747b28c
 
+static unsigned int stack_hash_order;
+static unsigned int stack_hash_mask;
+
 static bool stack_depot_disable;
 static struct stack_record **stack_table;
 
@@ -175,7 +182,7 @@ void __init stack_depot_want_early_init(
 
 int __init stack_depot_early_init(void)
 {
-	size_t size;
+	unsigned long entries = 0;
 
 	/* This is supposed to be called only once, from mm_init() */
 	if (WARN_ON(__stack_depot_early_init_passed))
@@ -183,13 +190,23 @@ int __init stack_depot_early_init(void)
 
 	__stack_depot_early_init_passed = true;
 
+	if (kasan_enabled() && !stack_hash_order)
+		stack_hash_order = STACK_HASH_ORDER_MAX;
+
 	if (!__stack_depot_want_early_init || stack_depot_disable)
 		return 0;
 
-	size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
-	pr_info("Stack Depot early init allocating hash table with memblock_alloc, %zu bytes\n",
-		size);
-	stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
+	if (stack_hash_order)
+		entries = 1UL <<  stack_hash_order;
+	stack_table = alloc_large_system_hash("stackdepot",
+						sizeof(struct stack_record *),
+						entries,
+						STACK_HASH_SCALE,
+						HASH_EARLY | HASH_ZERO,
+						NULL,
+						&stack_hash_mask,
+						1UL << STACK_HASH_ORDER_MIN,
+						1UL << STACK_HASH_ORDER_MAX);
 
 	if (!stack_table) {
 		pr_err("Stack Depot hash table allocation failed, disabling\n");
@@ -207,13 +224,35 @@ int stack_depot_init(void)
 
 	mutex_lock(&stack_depot_init_mutex);
 	if (!stack_depot_disable && !stack_table) {
-		pr_info("Stack Depot allocating hash table with kvcalloc\n");
-		stack_table = kvcalloc(STACK_HASH_SIZE, sizeof(struct stack_record *), GFP_KERNEL);
+		unsigned long entries;
+		int scale = STACK_HASH_SCALE;
+
+		if (stack_hash_order) {
+			entries = 1UL << stack_hash_order;
+		} else {
+			entries = nr_free_buffer_pages();
+			entries = roundup_pow_of_two(entries);
+
+			if (scale > PAGE_SHIFT)
+				entries >>= (scale - PAGE_SHIFT);
+			else
+				entries <<= (PAGE_SHIFT - scale);
+		}
+
+		if (entries < 1UL << STACK_HASH_ORDER_MIN)
+			entries = 1UL << STACK_HASH_ORDER_MIN;
+		if (entries > 1UL << STACK_HASH_ORDER_MAX)
+			entries = 1UL << STACK_HASH_ORDER_MAX;
+
+		pr_info("Stack Depot allocating hash table of %lu entries with kvcalloc\n",
+				entries);
+		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
 		if (!stack_table) {
 			pr_err("Stack Depot hash table allocation failed, disabling\n");
 			stack_depot_disable = true;
 			ret = -ENOMEM;
 		}
+		stack_hash_mask = entries - 1;
 	}
 	mutex_unlock(&stack_depot_init_mutex);
 	return ret;
@@ -386,7 +425,7 @@ depot_stack_handle_t __stack_depot_save(
 		goto fast_exit;
 
 	hash = hash_stack(entries, nr_entries);
-	bucket = &stack_table[hash & STACK_HASH_MASK];
+	bucket = &stack_table[hash & stack_hash_mask];
 
 	/*
 	 * Fast path: look the stack trace up without locking.
_

Patches currently in -mm which might be from vbabka@suse.cz are

lib-stackdepot-replace-config_stack_hash_order-with-automatic-sizing.patch

