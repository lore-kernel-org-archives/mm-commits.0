Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A39AC4742C
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B7D22404
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451975;
	bh=MIvpIghbsMMV0X9TcbvLJbxt0fwpUYtDJRgboVTNbFg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aHttJAFDnQS5m4akTXfrOeca0C+j5Esm1gnkFtZvJ0CCmCBIoMFkFYyQviYxfXbKI
	 d/lFnvry1TEiGLqRGvngkc8P+p6KBJ7faerNChNPdQC5VbvealA0wpzw+ZSOtMpGQD
	 vp3qN+wJQYiYr+Xd22+lU3OYour8+R8oC/UyxLOk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgKDBGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgKDBGO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:06:14 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62550223C7;
        Wed,  4 Nov 2020 01:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451973;
        bh=MIvpIghbsMMV0X9TcbvLJbxt0fwpUYtDJRgboVTNbFg=;
        h=Date:From:To:Subject:From;
        b=N9zEGHu5skkm6UkiQsx2XPNiTduHGm2layiarot9YKWj2wmkyugULSqmh0QvxZTMQ
         oLlBRfY3rxqPcCASVbaCi2KLyDmw5XD5SI8h0QtKze7j+Mb+Qn4OOBUoke2vgLLN4o
         vk+qlYIK9gPXMJ2HzJULGlmg9AQKse132sCPizX0=
Date:   Tue, 03 Nov 2020 17:06:10 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, rjw@rjwysocki.net,
        pavel@ucw.cz, mhocko@kernel.org, mateusznosek0@gmail.com,
        len.brown@intel.com, labbott@kernel.org, keescook@chromium.org,
        glider@google.com, david@redhat.com, akinobu.mita@gmail.com,
        vbabka@suse.cz
Subject:  + mm-page_poison-use-static-key-more-efficiently.patch
 added to -mm tree
Message-ID: <20201104010610.x0lla%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: use static key more efficiently
has been added to the -mm tree.  Its filename is
     mm-page_poison-use-static-key-more-efficiently.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poison-use-static-key-more-efficiently.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poison-use-static-key-more-efficiently.patch

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

Link: https://lkml.kernel.org/r/20201103152237.9853-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    2 -
 include/linux/mm.h              |   23 ++++++++++---
 mm/page_alloc.c                 |   19 +++++++++-
 mm/page_poison.c                |   53 +++---------------------------
 4 files changed, 43 insertions(+), 54 deletions(-)

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
@@ -2855,12 +2855,27 @@ extern int apply_to_existing_page_range(
 
 extern void init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
-extern bool page_poisoning_enabled(void);
-extern void kernel_poison_pages(struct page *page, int numpages, int enable);
+extern void kernel_poison_pages(struct page *page, int numpages);
+extern void kernel_unpoison_pages(struct page *page, int numpages);
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
+	return (static_branch_unlikely(&_page_poisoning_enabled));
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
@@ -775,6 +775,17 @@ void init_mem_debugging_and_hardening(vo
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
@@ -1260,7 +1271,8 @@ static __always_inline bool free_pages_p
 	if (want_init_on_free())
 		kernel_init_free_pages(page, 1 << order);
 
-	kernel_poison_pages(page, 1 << order, 0);
+	if (page_poisoning_enabled_static())
+		kernel_poison_pages(page, 1 << order);
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
 	 * does this.  So nothing which can access the page's contents should
@@ -2205,7 +2217,7 @@ static inline int check_new_page(struct
 static inline bool free_pages_prezeroed(void)
 {
 	return (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
-		page_poisoning_enabled()) || want_init_on_free();
+		page_poisoning_enabled_static()) || want_init_on_free();
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2267,7 +2279,8 @@ inline void post_alloc_hook(struct page
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
-	kernel_poison_pages(page, 1 << order, 1);
+	if (page_poisoning_enabled_static())
+		kernel_unpoison_pages(page, 1 << order);
 	set_page_owner(page, order, gfp_flags);
 }
 
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
+void kernel_poison_pages(struct page *page, int n)
 {
 	int i;
 
@@ -117,7 +89,7 @@ static void unpoison_page(struct page *p
 	kunmap_atomic(addr);
 }
 
-static void unpoison_pages(struct page *page, int n)
+void kernel_unpoison_pages(struct page *page, int n)
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

