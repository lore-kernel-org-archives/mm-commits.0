Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79F8C4742C
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8959320780
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vvs1ZmxH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbgKJXGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731805AbgKJXGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 18:06:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EAB520679;
        Tue, 10 Nov 2020 23:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049583;
        bh=/XLjpc79xO2n8ZongETvQFrYIGxFqhrt5Mf0ikB+Pac=;
        h=Date:From:To:Subject:From;
        b=vvs1ZmxHnXlz4MRtOWQW8sY0AfsxiweRicRYkLXlCod1fBwA+MR1J2kaXOGqB0UzL
         YyRKVbK/4ogupd45UleuWB0pZ8TkXwNS651K4ZTb5cZpcxPWxSDefxrpfV5po2p+lO
         TjS9qfnsMN5udBgoxxdHNqfQ5pBr17ma+TaKb+1M=
Date:   Tue, 10 Nov 2020 15:06:22 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-mm-allow-cache-merging-with-no-metadata.patch
 added to -mm tree
Message-ID: <20201110230622.NpleuYQQj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: allow cache merging with no metadata
has been added to the -mm tree.  Its filename is
     kasan-mm-allow-cache-merging-with-no-metadata.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-allow-cache-merging-with-no-metadata.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-allow-cache-merging-with-no-metadata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: allow cache merging with no metadata

The reason cache merging is disabled with KASAN is because KASAN puts its
metadata right after the allocated object. When the merged caches have
slightly different sizes, the metadata ends up in different places, which
KASAN doesn't support.

It might be possible to adjust the metadata allocation algorithm and make
it friendly to the cache merging code. Instead this change takes a simpler
approach and allows merging caches when no metadata is present. Which is
the case for hardware tag-based KASAN with kasan.mode=prod.

Link: https://lkml.kernel.org/r/936c0c198145b663e031527c49a6895bd21ac3a0.1605046662.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ia114847dfb2244f297d2cb82d592bf6a07455dba
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   26 ++++++++++++++++++++++++--
 mm/kasan/common.c     |   11 +++++++++++
 mm/slab_common.c      |   11 ++++++++---
 3 files changed, 43 insertions(+), 5 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-allow-cache-merging-with-no-metadata
+++ a/include/linux/kasan.h
@@ -81,17 +81,35 @@ struct kasan_cache {
 };
 
 #ifdef CONFIG_KASAN_HW_TAGS
+
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
+
 static inline kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
-#else
+
+slab_flags_t __kasan_never_merge(slab_flags_t flags);
+static inline slab_flags_t kasan_never_merge(slab_flags_t flags)
+{
+	if (kasan_enabled())
+		return __kasan_never_merge(flags);
+	return flags;
+}
+
+#else /* CONFIG_KASAN_HW_TAGS */
+
 static inline kasan_enabled(void)
 {
 	return true;
 }
-#endif
+
+static inline slab_flags_t kasan_never_merge(slab_flags_t flags)
+{
+	return flags;
+}
+
+#endif /* CONFIG_KASAN_HW_TAGS */
 
 void __kasan_alloc_pages(struct page *page, unsigned int order);
 static inline void kasan_alloc_pages(struct page *page, unsigned int order)
@@ -240,6 +258,10 @@ static inline kasan_enabled(void)
 {
 	return false;
 }
+static inline slab_flags_t kasan_never_merge(slab_flags_t flags)
+{
+	return flags;
+}
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 static inline void kasan_cache_create(struct kmem_cache *cache,
--- a/mm/kasan/common.c~kasan-mm-allow-cache-merging-with-no-metadata
+++ a/mm/kasan/common.c
@@ -82,6 +82,17 @@ asmlinkage void kasan_unpoison_task_stac
 }
 #endif /* CONFIG_KASAN_STACK */
 
+/*
+ * Only allow cache merging when stack collection is disabled and no metadata
+ * is present.
+ */
+slab_flags_t __kasan_never_merge(slab_flags_t flags)
+{
+	if (kasan_stack_collection_enabled())
+		return flags;
+	return flags & ~SLAB_KASAN;
+}
+
 void __kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	u8 tag;
--- a/mm/slab_common.c~kasan-mm-allow-cache-merging-with-no-metadata
+++ a/mm/slab_common.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/kasan.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
@@ -50,12 +51,16 @@ static DECLARE_WORK(slab_caches_to_rcu_d
 		    slab_caches_to_rcu_destroy_workfn);
 
 /*
- * Set of flags that will prevent slab merging
+ * Set of flags that will prevent slab merging.
+ * Use slab_never_merge() instead.
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
 		SLAB_FAILSLAB | SLAB_KASAN)
 
+/* KASAN allows merging in some configurations and will remove SLAB_KASAN. */
+#define slab_never_merge() (kasan_never_merge(SLAB_NEVER_MERGE))
+
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
 
@@ -165,7 +170,7 @@ static unsigned int calculate_alignment(
  */
 int slab_unmergeable(struct kmem_cache *s)
 {
-	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE))
+	if (slab_nomerge || (s->flags & slab_never_merge()))
 		return 1;
 
 	if (s->ctor)
@@ -199,7 +204,7 @@ struct kmem_cache *find_mergeable(unsign
 	size = ALIGN(size, align);
 	flags = kmem_cache_flags(size, flags, name, NULL);
 
-	if (flags & SLAB_NEVER_MERGE)
+	if (flags & slab_never_merge())
 		return NULL;
 
 	list_for_each_entry_reverse(s, &slab_caches, list) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
s390-kasan-include-asm-pageh-from-asm-kasanh.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_memory.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_granule_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-kasan_non_canonical_hook-only-for-software-modes.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch
kasan-simplify-quarantine_put-call-site.patch
kasan-rename-get_alloc-free_info.patch
kasan-introduce-set_alloc_info.patch
kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
kasan-allow-vmap_stack-for-hw_tags-mode.patch
kasan-remove-__kasan_unpoison_stack.patch
kasan-inline-kasan_reset_tag-for-tag-based-modes.patch
kasan-inline-random_tag-for-hw_tags.patch
kasan-inline-kasan_poison_memory-and-check_invalid_free.patch
kasan-inline-and-rename-kasan_unpoison_memory.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-simplify-kasan_poison_kfree.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-clean-up-metadata-allocation-and-usage.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch

