Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C68C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbjDFCr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbjDFCpq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462AE9759
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A06A64230
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F240C433EF;
        Thu,  6 Apr 2023 02:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749118;
        bh=vgrUPD3YciIMV3fPsGAwrHel+CA6ts+1mn5KprXDtGU=;
        h=Date:To:From:Subject:From;
        b=SOAMBeJ5lLQiZpFiTSP2citIELWLL+ZAd3REoq8IavAbNJiJC+GcdYs+Exa6b2GFm
         vWZ8k0m6+7QMtYlH0mh30iIN0lCgWpGzfPj1gile1Cl6ES6mlUIE7eaByI3NXo15sg
         H9Dw7Cm/YtqUsQy/UPet/gxTjUz2vpB097WffPeo=
Date:   Wed, 05 Apr 2023 19:45:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch removed from -mm tree
Message-Id: <20230406024518.6F240C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move init_mem_debugging_and_hardening() to mm/mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move init_mem_debugging_and_hardening() to mm/mm_init.c
Date: Tue, 21 Mar 2023 19:05:08 +0200

init_mem_debugging_and_hardening() is only called from mm_core_init().

Move it close to the caller, make it static and rename it to
mem_debugging_and_hardening_init() for consistency with surrounding
convention.

Link: https://lkml.kernel.org/r/20230321170513.2401534-10-rppt@kernel.org
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
 mm/internal.h      |    8 +++
 mm/mm_init.c       |   91 ++++++++++++++++++++++++++++++++++++++++-
 mm/page_alloc.c    |   95 -------------------------------------------
 4 files changed, 98 insertions(+), 97 deletions(-)

--- a/include/linux/mm.h~mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc
+++ a/include/linux/mm.h
@@ -3251,7 +3251,6 @@ extern int apply_to_existing_page_range(
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
@@ -2531,6 +2531,95 @@ void __init memblock_free_pages(struct p
 	__free_pages_core(page, order);
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
+static void __init mem_debugging_and_hardening_init(void)
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
@@ -2570,7 +2659,7 @@ void __init mm_core_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
-	init_mem_debugging_and_hardening();
+	mem_debugging_and_hardening_init();
 	kfence_alloc_pool();
 	report_meminit();
 	kmsan_init_shadow();
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

