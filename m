Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4ECC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05524224BD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgLODOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgLODNx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:53 -0500
Date:   Mon, 14 Dec 2020 19:13:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002011;
        bh=mZ8QwvM1obRIXkQwRVHPPnbEkyH0KihY1dvJtg5pS/s=;
        h=From:To:Subject:In-Reply-To:From;
        b=tf2OdODNv29B9jqdhtlj1SdzGqvZ/oTnuqfpzqrtKvX8JTZtRyXYuEmxpvigTCNzQ
         Nezh6OamqGkNOUzKNJDplCuAPPHIinJjSVxgn4bdk5fYEdigaExhbMe8F43skcgag1
         twz22EG6IItWpUMB3O3H0rKuqowr+6vmYURIWsSA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, glider@google.com,
        keescook@chromium.org, labbott@kernel.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 174/200] mm, page_alloc: do not rely on the order
 of page_poison and init_on_alloc/free parameters
Message-ID: <20201215031330.oiDvLLjUX%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: do not rely on the order of page_poison and init_on_alloc/free parameters

Patch series "cleanup page poisoning", v3.

I have identified a number of issues and opportunities for cleanup with
CONFIG_PAGE_POISON and friends:
- interaction with init_on_alloc and init_on_free parameters depends on
  the order of parameters (Patch 1)
- the boot time enabling uses static key, but inefficienty (Patch 2)
- sanity checking is incompatible with hibernation (Patch 3)
- CONFIG_PAGE_POISONING_NO_SANITY can be removed now that we have init_on_free
  (Patch 4)
- CONFIG_PAGE_POISONING_ZERO can be most likely removed now that we have
  init_on_free (Patch 5)


This patch (of 5):

Enabling page_poison=1 together with init_on_alloc=1 or init_on_free=1
produces a warning in dmesg that page_poison takes precedence.  However,
as these warnings are printed in early_param handlers for
init_on_alloc/free, they are not printed if page_poison is enabled later
on the command line (handlers are called in the order of their
parameters), or when init_on_alloc/free is always enabled by the
respective config option - before the page_poison early param handler is
called, it is not considered to be enabled.  This is inconsistent.

We can remove the dependency on order by making the init_on_* parameters
only set a boolean variable, and postponing the evaluation after all early
params have been processed.  Introduce a new
init_mem_debugging_and_hardening() function for that, and move the related
debug_pagealloc processing there as well.

As a result init_mem_debugging_and_hardening() knows always accurately if
init_on_* and/or page_poison options were enabled.  Thus we can also
optimize want_init_on_alloc() and want_init_on_free().  We don't need to
check page_poisoning_enabled() there, we can instead not enable the
init_on_* static keys at all, if page poisoning is enabled.  This results
in a simpler and more effective code.

Link: https://lkml.kernel.org/r/20201113104033.22907-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20201113104033.22907-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Laura Abbott <labbott@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 +--------
 init/main.c        |    2 
 mm/page_alloc.c    |   88 ++++++++++++++++++++-----------------------
 3 files changed, 46 insertions(+), 64 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters
+++ a/include/linux/mm.h
@@ -2872,6 +2872,7 @@ extern int apply_to_existing_page_range(
 				   unsigned long address, unsigned long size,
 				   pte_fn_t fn, void *data);
 
+extern void init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
 extern bool page_poisoning_enabled(void);
 extern void kernel_poison_pages(struct page *page, int numpages, int enable);
@@ -2881,35 +2882,20 @@ static inline void kernel_poison_pages(s
 					int enable) { }
 #endif
 
-#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
-DECLARE_STATIC_KEY_TRUE(init_on_alloc);
-#else
 DECLARE_STATIC_KEY_FALSE(init_on_alloc);
-#endif
 static inline bool want_init_on_alloc(gfp_t flags)
 {
-	if (static_branch_unlikely(&init_on_alloc) &&
-	    !page_poisoning_enabled())
+	if (static_branch_unlikely(&init_on_alloc))
 		return true;
 	return flags & __GFP_ZERO;
 }
 
-#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
-DECLARE_STATIC_KEY_TRUE(init_on_free);
-#else
 DECLARE_STATIC_KEY_FALSE(init_on_free);
-#endif
 static inline bool want_init_on_free(void)
 {
-	return static_branch_unlikely(&init_on_free) &&
-	       !page_poisoning_enabled();
+	return static_branch_unlikely(&init_on_free);
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-extern void init_debug_pagealloc(void);
-#else
-static inline void init_debug_pagealloc(void) {}
-#endif
 extern bool _debug_pagealloc_enabled_early;
 DECLARE_STATIC_KEY_FALSE(_debug_pagealloc_enabled);
 
--- a/init/main.c~mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters
+++ a/init/main.c
@@ -824,7 +824,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
-	init_debug_pagealloc();
+	init_mem_debugging_and_hardening();
 	report_meminit();
 	mem_init();
 	/* page_owner must be initialized after buddy is ready */
--- a/mm/page_alloc.c~mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters
+++ a/mm/page_alloc.c
@@ -167,53 +167,26 @@ unsigned long totalcma_pages __read_most
 
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
-#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
-DEFINE_STATIC_KEY_TRUE(init_on_alloc);
-#else
 DEFINE_STATIC_KEY_FALSE(init_on_alloc);
-#endif
 EXPORT_SYMBOL(init_on_alloc);
 
-#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
-DEFINE_STATIC_KEY_TRUE(init_on_free);
-#else
 DEFINE_STATIC_KEY_FALSE(init_on_free);
-#endif
 EXPORT_SYMBOL(init_on_free);
 
+static bool _init_on_alloc_enabled_early __read_mostly
+				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
 static int __init early_init_on_alloc(char *buf)
 {
-	int ret;
-	bool bool_result;
 
-	ret = kstrtobool(buf, &bool_result);
-	if (ret)
-		return ret;
-	if (bool_result && page_poisoning_enabled())
-		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, will take precedence over init_on_alloc\n");
-	if (bool_result)
-		static_branch_enable(&init_on_alloc);
-	else
-		static_branch_disable(&init_on_alloc);
-	return 0;
+	return kstrtobool(buf, &_init_on_alloc_enabled_early);
 }
 early_param("init_on_alloc", early_init_on_alloc);
 
+static bool _init_on_free_enabled_early __read_mostly
+				= IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON);
 static int __init early_init_on_free(char *buf)
 {
-	int ret;
-	bool bool_result;
-
-	ret = kstrtobool(buf, &bool_result);
-	if (ret)
-		return ret;
-	if (bool_result && page_poisoning_enabled())
-		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, will take precedence over init_on_free\n");
-	if (bool_result)
-		static_branch_enable(&init_on_free);
-	else
-		static_branch_disable(&init_on_free);
-	return 0;
+	return kstrtobool(buf, &_init_on_free_enabled_early);
 }
 early_param("init_on_free", early_init_on_free);
 
@@ -730,19 +703,6 @@ static int __init early_debug_pagealloc(
 }
 early_param("debug_pagealloc", early_debug_pagealloc);
 
-void init_debug_pagealloc(void)
-{
-	if (!debug_pagealloc_enabled())
-		return;
-
-	static_branch_enable(&_debug_pagealloc_enabled);
-
-	if (!debug_guardpage_minorder())
-		return;
-
-	static_branch_enable(&_debug_guardpage_enabled);
-}
-
 static int __init debug_guardpage_minorder_setup(char *buf)
 {
 	unsigned long res;
@@ -794,6 +754,42 @@ static inline void clear_page_guard(stru
 				unsigned int order, int migratetype) {}
 #endif
 
+/*
+ * Enable static keys related to various memory debugging and hardening options.
+ * Some override others, and depend on early params that are evaluated in the
+ * order of appearance. So we need to first gather the full picture of what was
+ * enabled, and then make decisions.
+ */
+void init_mem_debugging_and_hardening(void)
+{
+	if (_init_on_alloc_enabled_early) {
+		if (page_poisoning_enabled())
+			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
+				"will take precedence over init_on_alloc\n");
+		else
+			static_branch_enable(&init_on_alloc);
+	}
+	if (_init_on_free_enabled_early) {
+		if (page_poisoning_enabled())
+			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
+				"will take precedence over init_on_free\n");
+		else
+			static_branch_enable(&init_on_free);
+	}
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	if (!debug_pagealloc_enabled())
+		return;
+
+	static_branch_enable(&_debug_pagealloc_enabled);
+
+	if (!debug_guardpage_minorder())
+		return;
+
+	static_branch_enable(&_debug_guardpage_enabled);
+#endif
+}
+
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
_
