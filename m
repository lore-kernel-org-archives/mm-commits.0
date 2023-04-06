Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581DEC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbjDFCrV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbjDFCpV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BE19742
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7718C62D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0AFC433D2;
        Thu,  6 Apr 2023 02:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749115;
        bh=Dy6754S1odnOd7akWY976plZEFao13xOVLrvDhUYkEY=;
        h=Date:To:From:Subject:From;
        b=UYLxg5+SqLFvM3s58D5YZSx76Yjz6meJHKB35L7xFZQfXL/docFFjxvx8F2vC7JlW
         beFFXhTFNTT/ndxwZNTTSg/ZFwRHhYXwvgtd8Cg8ditiJOBGP9G4wAz+LSTmHAQcNq
         JUm81HP9c7BTgWzsXNYqPl4FudiHbaj425kZ0Zlc=
Date:   Wed, 05 Apr 2023 19:45:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch removed from -mm tree
Message-Id: <20230406024515.CF0AFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init,mm: move mm_init() to mm/mm_init.c and rename it to mm_core_init()
has been removed from the -mm tree.  Its filename was
     initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: init,mm: move mm_init() to mm/mm_init.c and rename it to mm_core_init()
Date: Tue, 21 Mar 2023 19:05:06 +0200

Make mm_init() a part of mm/ codebase.  mm_core_init() better describes
what the function does and does not clash with mm_init() in kernel/fork.c

Link: https://lkml.kernel.org/r/20230321170513.2401534-8-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 init/main.c        |   71 +----------------------------------------
 mm/mm_init.c       |   73 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 69 deletions(-)

--- a/include/linux/mm.h~initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init
+++ a/include/linux/mm.h
@@ -38,6 +38,7 @@ struct pt_regs;
 
 extern int sysctl_page_lock_unfairness;
 
+void mm_core_init(void);
 void init_mm_internals(void);
 
 #ifndef CONFIG_NUMA		/* Don't use mapnrs, do it properly */
--- a/init/main.c~initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init
+++ a/init/main.c
@@ -807,73 +807,6 @@ static inline void initcall_debug_enable
 }
 #endif
 
-/* Report memory auto-initialization states for this boot. */
-static void __init report_meminit(void)
-{
-	const char *stack;
-
-	if (IS_ENABLED(CONFIG_INIT_STACK_ALL_PATTERN))
-		stack = "all(pattern)";
-	else if (IS_ENABLED(CONFIG_INIT_STACK_ALL_ZERO))
-		stack = "all(zero)";
-	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
-		stack = "byref_all(zero)";
-	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
-		stack = "byref(zero)";
-	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
-		stack = "__user(zero)";
-	else
-		stack = "off";
-
-	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
-		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
-		want_init_on_free() ? "on" : "off");
-	if (want_init_on_free())
-		pr_info("mem auto-init: clearing system memory may take some time...\n");
-}
-
-/*
- * Set up kernel memory allocators
- */
-static void __init mm_init(void)
-{
-	/* Initializations relying on SMP setup */
-	build_all_zonelists(NULL);
-	page_alloc_init_cpuhp();
-
-	/*
-	 * page_ext requires contiguous pages,
-	 * bigger than MAX_ORDER unless SPARSEMEM.
-	 */
-	page_ext_init_flatmem();
-	init_mem_debugging_and_hardening();
-	kfence_alloc_pool();
-	report_meminit();
-	kmsan_init_shadow();
-	stack_depot_early_init();
-	mem_init();
-	mem_init_print_info();
-	kmem_cache_init();
-	/*
-	 * page_owner must be initialized after buddy is ready, and also after
-	 * slab is ready so that stack_depot_init() works properly
-	 */
-	page_ext_init_flatmem_late();
-	kmemleak_init();
-	pgtable_init();
-	debug_objects_mem_init();
-	vmalloc_init();
-	/* If no deferred init page_ext now, as vmap is fully initialized */
-	if (!deferred_struct_pages)
-		page_ext_init();
-	/* Should be run before the first non-init thread is created */
-	init_espfix_bsp();
-	/* Should be run after espfix64 is set up. */
-	pti_init();
-	kmsan_init_runtime();
-	mm_cache_init();
-}
-
 #ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
 DEFINE_STATIC_KEY_MAYBE_RO(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
 			   randomize_kstack_offset);
@@ -997,13 +930,13 @@ asmlinkage __visible void __init __no_sa
 
 	/*
 	 * These use large bootmem allocations and must precede
-	 * kmem_cache_init()
+	 * initalization of page allocator
 	 */
 	setup_log_buf(0);
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
-	mm_init();
+	mm_core_init();
 	poking_init();
 	ftrace_init();
 
--- a/mm/mm_init.c~initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init
+++ a/mm/mm_init.c
@@ -20,9 +20,15 @@
 #include <linux/nmi.h>
 #include <linux/buffer_head.h>
 #include <linux/kmemleak.h>
+#include <linux/kfence.h>
+#include <linux/page_ext.h>
+#include <linux/pti.h>
+#include <linux/pgtable.h>
 #include "internal.h"
 #include "shuffle.h"
 
+#include <asm/setup.h>
+
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
@@ -2524,3 +2530,70 @@ void __init memblock_free_pages(struct p
 	}
 	__free_pages_core(page, order);
 }
+
+/* Report memory auto-initialization states for this boot. */
+static void __init report_meminit(void)
+{
+	const char *stack;
+
+	if (IS_ENABLED(CONFIG_INIT_STACK_ALL_PATTERN))
+		stack = "all(pattern)";
+	else if (IS_ENABLED(CONFIG_INIT_STACK_ALL_ZERO))
+		stack = "all(zero)";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
+		stack = "byref_all(zero)";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
+		stack = "byref(zero)";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
+		stack = "__user(zero)";
+	else
+		stack = "off";
+
+	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
+		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
+		want_init_on_free() ? "on" : "off");
+	if (want_init_on_free())
+		pr_info("mem auto-init: clearing system memory may take some time...\n");
+}
+
+/*
+ * Set up kernel memory allocators
+ */
+void __init mm_core_init(void)
+{
+	/* Initializations relying on SMP setup */
+	build_all_zonelists(NULL);
+	page_alloc_init_cpuhp();
+
+	/*
+	 * page_ext requires contiguous pages,
+	 * bigger than MAX_ORDER unless SPARSEMEM.
+	 */
+	page_ext_init_flatmem();
+	init_mem_debugging_and_hardening();
+	kfence_alloc_pool();
+	report_meminit();
+	kmsan_init_shadow();
+	stack_depot_early_init();
+	mem_init();
+	mem_init_print_info();
+	kmem_cache_init();
+	/*
+	 * page_owner must be initialized after buddy is ready, and also after
+	 * slab is ready so that stack_depot_init() works properly
+	 */
+	page_ext_init_flatmem_late();
+	kmemleak_init();
+	pgtable_init();
+	debug_objects_mem_init();
+	vmalloc_init();
+	/* If no deferred init page_ext now, as vmap is fully initialized */
+	if (!deferred_struct_pages)
+		page_ext_init();
+	/* Should be run before the first non-init thread is created */
+	init_espfix_bsp();
+	/* Should be run after espfix64 is set up. */
+	pti_init();
+	kmsan_init_runtime();
+	mm_cache_init();
+}
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch

