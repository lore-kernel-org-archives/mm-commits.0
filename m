Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE8EC761AF
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCTWMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjCTWMS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75263360B0
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 964B66185A
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4A9C433EF;
        Mon, 20 Mar 2023 22:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350308;
        bh=FouqJLPWPtTY7hrUXkALFxSSs6PQ/K4lGXqnLFHa9gE=;
        h=Date:To:From:Subject:From;
        b=IZY5/JVntMhhUaqxsO+ggUsMI2W/YQvwqSIhDeMcUfPUSItWtV82CSCSoxGo7hfG0
         PDKdzKG1XMCsXz2bqPO6DpUdynsO99pKrnXZheDdqu0HCKdFStDfJyY439CRJayGbQ
         4TQy87JF5zpdHXUozps5EG++Bln94N4YX7lc0P/s=
Date:   Mon, 20 Mar 2023 15:11:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch added to mm-unstable branch
Message-Id: <20230320221147.EA4A9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move init_mem_debugging_and_hardening() to mm/mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move init_mem_debugging_and_hardening() to mm/mm_init.c
Date: Mon, 20 Mar 2023 00:00:03 +0200

init_mem_debugging_and_hardening() is only called from mm_core_init().

Move it close to the caller and make it static.

Link: https://lkml.kernel.org/r/20230319220008.2138576-11-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc
+++ a/include/linux/mm.h
@@ -3396,7 +3396,6 @@ extern int apply_to_existing_page_range(
 				   unsigned long address, unsigned long size,
 				   pte_fn_t fn, void *data);
 
-extern void __init init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
 extern void __kernel_poison_pages(struct page *page, int numpages);
 extern void __kernel_unpoison_pages(struct page *page, int numpages);
--- a/mm/internal.h~mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc
+++ a/mm/internal.h
@@ -204,6 +204,14 @@ pmd_t *mm_find_pmd(struct mm_struct *mm,
 
 extern char * const zone_names[MAX_NR_ZONES];
 
+/* perform sanity checks on struct pages being allocated or freed */
+DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+
+static inline bool is_check_pages_enabled(void)
+{
+	return static_branch_unlikely(&check_pages_enabled);
+}
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
--- a/mm/mm_init.c~mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc
+++ a/mm/mm_init.c
@@ -2517,6 +2517,95 @@ static void __init pgtable_init(void)
 	pgtable_cache_init();
 }
 
+static bool _init_on_alloc_enabled_early __read_mostly
+				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
+static int __init early_init_on_alloc(char *buf)
+{
+
+	return kstrtobool(buf, &_init_on_alloc_enabled_early);
+}
+early_param("init_on_alloc", early_init_on_alloc);
+
+static bool _init_on_free_enabled_early __read_mostly
+				= IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON);
+static int __init early_init_on_free(char *buf)
+{
+	return kstrtobool(buf, &_init_on_free_enabled_early);
+}
+early_param("init_on_free", early_init_on_free);
+
+DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+
+/*
+ * Enable static keys related to various memory debugging and hardening options.
+ * Some override others, and depend on early params that are evaluated in the
+ * order of appearance. So we need to first gather the full picture of what was
+ * enabled, and then make decisions.
+ */
+static void __init init_mem_debugging_and_hardening(void)
+{
+	bool page_poisoning_requested = false;
+	bool want_check_pages = false;
+
+#ifdef CONFIG_PAGE_POISONING
+	/*
+	 * Page poisoning is debug page alloc for some arches. If
+	 * either of those options are enabled, enable poisoning.
+	 */
+	if (page_poisoning_enabled() ||
+	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
+	      debug_pagealloc_enabled())) {
+		static_branch_enable(&_page_poisoning_enabled);
+		page_poisoning_requested = true;
+		want_check_pages = true;
+	}
+#endif
+
+	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early) &&
+	    page_poisoning_requested) {
+		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
+			"will take precedence over init_on_alloc and init_on_free\n");
+		_init_on_alloc_enabled_early = false;
+		_init_on_free_enabled_early = false;
+	}
+
+	if (_init_on_alloc_enabled_early) {
+		want_check_pages = true;
+		static_branch_enable(&init_on_alloc);
+	} else {
+		static_branch_disable(&init_on_alloc);
+	}
+
+	if (_init_on_free_enabled_early) {
+		want_check_pages = true;
+		static_branch_enable(&init_on_free);
+	} else {
+		static_branch_disable(&init_on_free);
+	}
+
+	if (IS_ENABLED(CONFIG_KMSAN) &&
+	    (_init_on_alloc_enabled_early || _init_on_free_enabled_early))
+		pr_info("mem auto-init: please make sure init_on_alloc and init_on_free are disabled when running KMSAN\n");
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	if (debug_pagealloc_enabled()) {
+		want_check_pages = true;
+		static_branch_enable(&_debug_pagealloc_enabled);
+
+		if (debug_guardpage_minorder())
+			static_branch_enable(&_debug_guardpage_enabled);
+	}
+#endif
+
+	/*
+	 * Any page debugging or hardening option also enables sanity checking
+	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
+	 * enabled already.
+	 */
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
+		static_branch_enable(&check_pages_enabled);
+}
+
 /* Report memory auto-initialization states for this boot. */
 static void __init report_meminit(void)
 {
--- a/mm/page_alloc.c~mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc
+++ a/mm/page_alloc.c
@@ -240,31 +240,6 @@ EXPORT_SYMBOL(init_on_alloc);
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
-/* perform sanity checks on struct pages being allocated or freed */
-static DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
-
-static inline bool is_check_pages_enabled(void)
-{
-	return static_branch_unlikely(&check_pages_enabled);
-}
-
-static bool _init_on_alloc_enabled_early __read_mostly
-				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
-static int __init early_init_on_alloc(char *buf)
-{
-
-	return kstrtobool(buf, &_init_on_alloc_enabled_early);
-}
-early_param("init_on_alloc", early_init_on_alloc);
-
-static bool _init_on_free_enabled_early __read_mostly
-				= IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON);
-static int __init early_init_on_free(char *buf)
-{
-	return kstrtobool(buf, &_init_on_free_enabled_early);
-}
-early_param("init_on_free", early_init_on_free);
-
 /*
  * A cached value of the page's pageblock's migratetype, used when the page is
  * put on a pcplist. Used to avoid the pageblock migratetype lookup when
@@ -798,76 +773,6 @@ static inline void clear_page_guard(stru
 				unsigned int order, int migratetype) {}
 #endif
 
-/*
- * Enable static keys related to various memory debugging and hardening options.
- * Some override others, and depend on early params that are evaluated in the
- * order of appearance. So we need to first gather the full picture of what was
- * enabled, and then make decisions.
- */
-void __init init_mem_debugging_and_hardening(void)
-{
-	bool page_poisoning_requested = false;
-	bool want_check_pages = false;
-
-#ifdef CONFIG_PAGE_POISONING
-	/*
-	 * Page poisoning is debug page alloc for some arches. If
-	 * either of those options are enabled, enable poisoning.
-	 */
-	if (page_poisoning_enabled() ||
-	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
-	      debug_pagealloc_enabled())) {
-		static_branch_enable(&_page_poisoning_enabled);
-		page_poisoning_requested = true;
-		want_check_pages = true;
-	}
-#endif
-
-	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early) &&
-	    page_poisoning_requested) {
-		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-			"will take precedence over init_on_alloc and init_on_free\n");
-		_init_on_alloc_enabled_early = false;
-		_init_on_free_enabled_early = false;
-	}
-
-	if (_init_on_alloc_enabled_early) {
-		want_check_pages = true;
-		static_branch_enable(&init_on_alloc);
-	} else {
-		static_branch_disable(&init_on_alloc);
-	}
-
-	if (_init_on_free_enabled_early) {
-		want_check_pages = true;
-		static_branch_enable(&init_on_free);
-	} else {
-		static_branch_disable(&init_on_free);
-	}
-
-	if (IS_ENABLED(CONFIG_KMSAN) &&
-	    (_init_on_alloc_enabled_early || _init_on_free_enabled_early))
-		pr_info("mem auto-init: please make sure init_on_alloc and init_on_free are disabled when running KMSAN\n");
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	if (debug_pagealloc_enabled()) {
-		want_check_pages = true;
-		static_branch_enable(&_debug_pagealloc_enabled);
-
-		if (debug_guardpage_minorder())
-			static_branch_enable(&_debug_guardpage_enabled);
-	}
-#endif
-
-	/*
-	 * Any page debugging or hardening option also enables sanity checking
-	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
-	 * enabled already.
-	 */
-	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
-		static_branch_enable(&check_pages_enabled);
-}
-
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-get_page_from_free_area-to-mm-page_allocc.patch
mips-fix-comment-about-pgtable_init.patch
mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static.patch
mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch
mm-move-most-of-core-mm-initialization-to-mm-mm_initc.patch
mm-handle-hashdist-initialization-in-mm-mm_initc.patch
mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch
init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch
initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch
mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static.patch
mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch
initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch
mm-move-mem_init_print_info-to-mm_initc.patch
mm-move-kmem_cache_init-declaration-to-mm-slabh.patch
mm-move-vmalloc_init-declaration-to-mm-internalh.patch
maintainers-extend-memblock-entry-to-include-mm-initialization.patch

