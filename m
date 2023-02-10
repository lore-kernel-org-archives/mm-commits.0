Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F12C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjBJVv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjBJVv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966FD60D4D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305C361E9C
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809C6C433EF;
        Fri, 10 Feb 2023 21:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065884;
        bh=Klg1DEEuR7ovSPBTklY56Fb1FK9IdxbEQjbwVYdukis=;
        h=Date:To:From:Subject:From;
        b=UPctbjBIXQX0hN12woHw2/MR1l33DMMkBTnuaANm6VR1RacXNX6ra/D0XGUrYxBVC
         1oBYjsWhnDQTUhfq4sc1NkSVEjNZM68JfbGkl/PExmQlZNgnqbt8LLCwZNhxe16dhS
         Gg7qhFx1Q8DBsz0iSkJKd7odTZMi/OOpjh3RZres=
Date:   Fri, 10 Feb 2023 13:51:23 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-mm-rename-stack_depot_want_early_init.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215124.809C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot, mm: rename stack_depot_want_early_init
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-mm-rename-stack_depot_want_early_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-mm-rename-stack_depot_want_early_init.patch

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
Subject: lib/stackdepot, mm: rename stack_depot_want_early_init
Date: Fri, 10 Feb 2023 22:15:51 +0100

Rename stack_depot_want_early_init to stack_depot_request_early_init.

The old name is confusing, as it hints at returning some kind of intention
of stack depot.  The new name reflects that this function requests an
action from stack depot instead.

No functional changes.

Link: https://lkml.kernel.org/r/359f31bf67429a06e630b4395816a967214ef753.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/stackdepot.h~lib-stackdepot-mm-rename-stack_depot_want_early_init
+++ a/include/linux/stackdepot.h
@@ -31,26 +31,26 @@ typedef u32 depot_stack_handle_t;
  * enabled as part of mm_init(), for subsystems where it's known at compile time
  * that stack depot will be used.
  *
- * Another alternative is to call stack_depot_want_early_init(), when the
+ * Another alternative is to call stack_depot_request_early_init(), when the
  * decision to use stack depot is taken e.g. when evaluating kernel boot
  * parameters, which precedes the enablement point in mm_init().
  *
- * stack_depot_init() and stack_depot_want_early_init() can be called regardless
- * of CONFIG_STACKDEPOT and are no-op when disabled. The actual save/fetch/print
- * functions should only be called from code that makes sure CONFIG_STACKDEPOT
- * is enabled.
+ * stack_depot_init() and stack_depot_request_early_init() can be called
+ * regardless of CONFIG_STACKDEPOT and are no-op when disabled. The actual
+ * save/fetch/print functions should only be called from code that makes sure
+ * CONFIG_STACKDEPOT is enabled.
  */
 #ifdef CONFIG_STACKDEPOT
 int stack_depot_init(void);
 
-void __init stack_depot_want_early_init(void);
+void __init stack_depot_request_early_init(void);
 
 /* This is supposed to be called only from mm_init() */
 int __init stack_depot_early_init(void);
 #else
 static inline int stack_depot_init(void) { return 0; }
 
-static inline void stack_depot_want_early_init(void) { }
+static inline void stack_depot_request_early_init(void) { }
 
 static inline int stack_depot_early_init(void)	{ return 0; }
 #endif
--- a/lib/stackdepot.c~lib-stackdepot-mm-rename-stack_depot_want_early_init
+++ a/lib/stackdepot.c
@@ -71,7 +71,7 @@ struct stack_record {
 	unsigned long entries[];	/* Variable-sized array of entries. */
 };
 
-static bool __stack_depot_want_early_init __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
+static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
 
 static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
@@ -107,12 +107,12 @@ static int __init is_stack_depot_disable
 }
 early_param("stack_depot_disable", is_stack_depot_disabled);
 
-void __init stack_depot_want_early_init(void)
+void __init stack_depot_request_early_init(void)
 {
-	/* Too late to request early init now */
+	/* Too late to request early init now. */
 	WARN_ON(__stack_depot_early_init_passed);
 
-	__stack_depot_want_early_init = true;
+	__stack_depot_early_init_requested = true;
 }
 
 int __init stack_depot_early_init(void)
@@ -128,7 +128,7 @@ int __init stack_depot_early_init(void)
 	if (kasan_enabled() && !stack_hash_order)
 		stack_hash_order = STACK_HASH_ORDER_MAX;
 
-	if (!__stack_depot_want_early_init || stack_depot_disable)
+	if (!__stack_depot_early_init_requested || stack_depot_disable)
 		return 0;
 
 	if (stack_hash_order)
--- a/mm/page_owner.c~lib-stackdepot-mm-rename-stack_depot_want_early_init
+++ a/mm/page_owner.c
@@ -48,7 +48,7 @@ static int __init early_page_owner_param
 	int ret = kstrtobool(buf, &page_owner_enabled);
 
 	if (page_owner_enabled)
-		stack_depot_want_early_init();
+		stack_depot_request_early_init();
 
 	return ret;
 }
--- a/mm/slub.c~lib-stackdepot-mm-rename-stack_depot_want_early_init
+++ a/mm/slub.c
@@ -1592,7 +1592,7 @@ static int __init setup_slub_debug(char
 		} else {
 			slab_list_specified = true;
 			if (flags & SLAB_STORE_USER)
-				stack_depot_want_early_init();
+				stack_depot_request_early_init();
 		}
 	}
 
@@ -1611,7 +1611,7 @@ static int __init setup_slub_debug(char
 out:
 	slub_debug = global_flags;
 	if (slub_debug & SLAB_STORE_USER)
-		stack_depot_want_early_init();
+		stack_depot_request_early_init();
 	if (slub_debug != 0 || slub_debug_string)
 		static_branch_enable(&slub_debug_enabled);
 	else
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

