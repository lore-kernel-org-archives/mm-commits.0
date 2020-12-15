Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B9EC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94AB223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgLODOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgLODOQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:16 -0500
Date:   Mon, 14 Dec 2020 19:13:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002015;
        bh=REDZwrWfIK5qpUhB6Su81zhqNBUazXnNpihQxzl1lr8=;
        h=From:To:Subject:In-Reply-To:From;
        b=C6VW69Qy0G3p2iMTAKyEzZQD0SAsY5kemjIN6cESSYNHI05u0htTGDnqach+lx48B
         OcsKkyo4DlHIvYKUtkJVw0uqFcbzFAx29zWBT4pyUIyCzohzqutJY3AqldddEU5LQ4
         vwWGl3hQQSg/MJ0a70htfLw+4LqLyjudQlQ3QXbA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, glider@google.com,
        keescook@chromium.org, labbott@kernel.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 175/200] mm, page_poison: use static key more
 efficiently
Message-ID: <20201215031334.d8lfhIMKJ%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_poison: use static key more efficiently

Commit 11c9c7edae06 ("mm/page_poison.c: replace bool variable with static
key") changed page_poisoning_enabled() to a static key check.  However,
the function is not inlined, so each check still involves a function call
with overhead not eliminated when page poisoning is disabled.

Analogically to how debug_pagealloc is handled, this patch converts
page_poisoning_enabled() back to boolean check, and introduces
page_poisoning_enabled_static() for fast paths.  Both functions are
inlined.

The function kernel_poison_pages() is also called unconditionally and does
the static key check inside.  Remove it from there and put it to callers. 
Also split it to two functions kernel_poison_pages() and
kernel_unpoison_pages() instead of the confusing bool parameter.

Also optimize the check that enables page poisoning instead of
debug_pagealloc for architectures without proper debug_pagealloc support. 
Move the check to init_mem_debugging_and_hardening() to enable a single
static key instead of having two static branches in
page_poisoning_enabled_static().

Link: https://lkml.kernel.org/r/20201113104033.22907-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    2 -
 include/linux/mm.h              |   33 ++++++++++++++++--
 mm/page_alloc.c                 |   18 ++++++++--
 mm/page_poison.c                |   53 +++---------------------------
 4 files changed, 52 insertions(+), 54 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~mm-page_poison-use-static-key-more-efficiently
+++ a/drivers/virtio/virtio_balloon.c
@@ -1116,7 +1116,7 @@ static int virtballoon_validate(struct v
 	 */
 	if (!want_init_on_free() &&
 	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
-	     !page_poisoning_enabled()))
+	     !page_poisoning_enabled_static()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
--- a/include/linux/mm.h~mm-page_poison-use-static-key-more-efficiently
+++ a/include/linux/mm.h
@@ -2874,12 +2874,37 @@ extern int apply_to_existing_page_range(
 
 extern void init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
-extern bool page_poisoning_enabled(void);
-extern void kernel_poison_pages(struct page *page, int numpages, int enable);
+extern void __kernel_poison_pages(struct page *page, int numpages);
+extern void __kernel_unpoison_pages(struct page *page, int numpages);
+extern bool _page_poisoning_enabled_early;
+DECLARE_STATIC_KEY_FALSE(_page_poisoning_enabled);
+static inline bool page_poisoning_enabled(void)
+{
+	return _page_poisoning_enabled_early;
+}
+/*
+ * For use in fast paths after init_mem_debugging() has run, or when a
+ * false negative result is not harmful when called too early.
+ */
+static inline bool page_poisoning_enabled_static(void)
+{
+	return static_branch_unlikely(&_page_poisoning_enabled);
+}
+static inline void kernel_poison_pages(struct page *page, int numpages)
+{
+	if (page_poisoning_enabled_static())
+		__kernel_poison_pages(page, numpages);
+}
+static inline void kernel_unpoison_pages(struct page *page, int numpages)
+{
+	if (page_poisoning_enabled_static())
+		__kernel_unpoison_pages(page, numpages);
+}
 #else
 static inline bool page_poisoning_enabled(void) { return false; }
-static inline void kernel_poison_pages(struct page *page, int numpages,
-					int enable) { }
+static inline bool page_poisoning_enabled_static(void) { return false; }
+static inline void kernel_poison_pages(struct page *page, int numpages) { }
+static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
 #endif
 
 DECLARE_STATIC_KEY_FALSE(init_on_alloc);
--- a/mm/page_alloc.c~mm-page_poison-use-static-key-more-efficiently
+++ a/mm/page_alloc.c
@@ -777,6 +777,17 @@ void init_mem_debugging_and_hardening(vo
 			static_branch_enable(&init_on_free);
 	}
 
+#ifdef CONFIG_PAGE_POISONING
+	/*
+	 * Page poisoning is debug page alloc for some arches. If
+	 * either of those options are enabled, enable poisoning.
+	 */
+	if (page_poisoning_enabled() ||
+	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
+	      debug_pagealloc_enabled()))
+		static_branch_enable(&_page_poisoning_enabled);
+#endif
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (!debug_pagealloc_enabled())
 		return;
@@ -1262,7 +1273,8 @@ static __always_inline bool free_pages_p
 	if (want_init_on_free())
 		kernel_init_free_pages(page, 1 << order);
 
-	kernel_poison_pages(page, 1 << order, 0);
+	kernel_poison_pages(page, 1 << order);
+
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
 	 * does this.  So nothing which can access the page's contents should
@@ -2219,7 +2231,7 @@ static inline int check_new_page(struct
 static inline bool free_pages_prezeroed(void)
 {
 	return (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
-		page_poisoning_enabled()) || want_init_on_free();
+		page_poisoning_enabled_static()) || want_init_on_free();
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2281,7 +2293,7 @@ inline void post_alloc_hook(struct page
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
 	kasan_alloc_pages(page, order);
-	kernel_poison_pages(page, 1 << order, 1);
+	kernel_unpoison_pages(page, 1 << order);
 	set_page_owner(page, order, gfp_flags);
 
 	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
--- a/mm/page_poison.c~mm-page_poison-use-static-key-more-efficiently
+++ a/mm/page_poison.c
@@ -8,45 +8,17 @@
 #include <linux/ratelimit.h>
 #include <linux/kasan.h>
 
-static DEFINE_STATIC_KEY_FALSE_RO(want_page_poisoning);
+bool _page_poisoning_enabled_early;
+EXPORT_SYMBOL(_page_poisoning_enabled_early);
+DEFINE_STATIC_KEY_FALSE(_page_poisoning_enabled);
+EXPORT_SYMBOL(_page_poisoning_enabled);
 
 static int __init early_page_poison_param(char *buf)
 {
-	int ret;
-	bool tmp;
-
-	ret = strtobool(buf, &tmp);
-	if (ret)
-		return ret;
-
-	if (tmp)
-		static_branch_enable(&want_page_poisoning);
-	else
-		static_branch_disable(&want_page_poisoning);
-
-	return 0;
+	return kstrtobool(buf, &_page_poisoning_enabled_early);
 }
 early_param("page_poison", early_page_poison_param);
 
-/**
- * page_poisoning_enabled - check if page poisoning is enabled
- *
- * Return true if page poisoning is enabled, or false if not.
- */
-bool page_poisoning_enabled(void)
-{
-	/*
-	 * Assumes that debug_pagealloc_enabled is set before
-	 * memblock_free_all.
-	 * Page poisoning is debug page alloc for some arches. If
-	 * either of those options are enabled, enable poisoning.
-	 */
-	return (static_branch_unlikely(&want_page_poisoning) ||
-		(!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
-		debug_pagealloc_enabled()));
-}
-EXPORT_SYMBOL_GPL(page_poisoning_enabled);
-
 static void poison_page(struct page *page)
 {
 	void *addr = kmap_atomic(page);
@@ -58,7 +30,7 @@ static void poison_page(struct page *pag
 	kunmap_atomic(addr);
 }
 
-static void poison_pages(struct page *page, int n)
+void __kernel_poison_pages(struct page *page, int n)
 {
 	int i;
 
@@ -117,7 +89,7 @@ static void unpoison_page(struct page *p
 	kunmap_atomic(addr);
 }
 
-static void unpoison_pages(struct page *page, int n)
+void __kernel_unpoison_pages(struct page *page, int n)
 {
 	int i;
 
@@ -125,17 +97,6 @@ static void unpoison_pages(struct page *
 		unpoison_page(page + i);
 }
 
-void kernel_poison_pages(struct page *page, int numpages, int enable)
-{
-	if (!page_poisoning_enabled())
-		return;
-
-	if (enable)
-		unpoison_pages(page, numpages);
-	else
-		poison_pages(page, numpages);
-}
-
 #ifndef CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
_
