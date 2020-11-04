Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B42C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21F6622403
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451973;
	bh=sEkD3lOlWBH3pKcvLMNwsDImo2TCluuHcThMC1KOEcc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YGyJ8u7fKEiAGvuo8xsq4K3/D+ggXHRK/jrx3a8BHjHEAC7rB1pVqXUN5Gj45qpxT
	 bLyLX3N9dUsHaw+bdAbobeAL1xybx9+ieuJVahewBQn07OCpLYDsrlM/gmpQX9Os3s
	 3hVuNbpxe5sTcEyDiI831eYBZjxzWU9nsfrK3Ofw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgKDBGL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgKDBGK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:06:10 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B21223AB;
        Wed,  4 Nov 2020 01:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451968;
        bh=sEkD3lOlWBH3pKcvLMNwsDImo2TCluuHcThMC1KOEcc=;
        h=Date:From:To:Subject:From;
        b=cMXFKIAWSmL44Nraoxsgnp8N/l3w2am/mTV7Me9xwyDdbCmCChB/J5N1u5MWRn5b6
         izG22q85czd5mxSud9Gc2R8WnvzBAbysVXaO14QACAh+/9C1Ro33T03DGjrcrw2tV7
         JrYrla++oQoqev2p/x+8irtbl1ZijEkWr5Gj8/Rk=
Date:   Tue, 03 Nov 2020 17:06:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, rjw@rjwysocki.net,
        pavel@ucw.cz, mhocko@kernel.org, mateusznosek0@gmail.com,
        len.brown@intel.com, labbott@kernel.org, keescook@chromium.org,
        glider@google.com, david@redhat.com, akinobu.mita@gmail.com,
        vbabka@suse.cz
Subject:  +
 =?us-ascii?Q?mm-page=5Falloc-do-not-rely-on-the-order-of-page=5Fpoison?=
 =?us-ascii?Q?-and-init=5Fon=5Falloc-free-parameters.patch?= added to -mm
 tree
Message-ID: <20201104010605.sBE74%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: do not rely on the order of page_poison and init_on_alloc/free parameters
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: do not rely on the order of page_poison and init_on_alloc/free parameters

Patch series "cleanup page poisoning", v2.

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

Link: https://lkml.kernel.org/r/20201103152237.9853-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20201103152237.9853-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 +--------
 init/main.c        |    2 
 mm/page_alloc.c    |   88 ++++++++++++++++++++-----------------------
 3 files changed, 46 insertions(+), 64 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters
+++ a/include/linux/mm.h
@@ -2853,6 +2853,7 @@ extern int apply_to_existing_page_range(
 				   unsigned long address, unsigned long size,
 				   pte_fn_t fn, void *data);
 
+extern void init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
 extern bool page_poisoning_enabled(void);
 extern void kernel_poison_pages(struct page *page, int numpages, int enable);
@@ -2862,35 +2863,20 @@ static inline void kernel_poison_pages(s
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
@@ -815,7 +815,7 @@ static void __init mm_init(void)
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
@@ -165,53 +165,26 @@ unsigned long totalcma_pages __read_most
 
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
 
@@ -728,19 +701,6 @@ static int __init early_debug_pagealloc(
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
@@ -792,6 +752,42 @@ static inline void clear_page_guard(stru
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

