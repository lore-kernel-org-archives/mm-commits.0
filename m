Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75361C6FA89
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiIEWsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiIEWsP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99CA53002
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 582DE60ECE
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF81C433C1;
        Mon,  5 Sep 2022 22:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418092;
        bh=vuIo6ETu2mDq7V20fPGCr09RC0SxmGf26Sr0VYHZBV4=;
        h=Date:To:From:Subject:From;
        b=TLqgEHY391H+MAzlyGd/S1tdawsXil5loMFq+hbgcA+No1tPem9wpFaH9lu4OJm0M
         yyfcG0M3JJlCe4+NEfDMISRs6sKAl88QrfPBwWSzH5MHvXtQW8cQNMBHId8fgop5ah
         9v+ysHtqcn1Nop0sRBWpmitMffCuvZiuW9SrsXRU=
Date:   Mon, 05 Sep 2022 15:48:12 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-only-define-kasan_never_merge-for-generic-mode.patch added to mm-unstable branch
Message-Id: <20220905224812.ACF81C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: only define kasan_never_merge for Generic mode
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-only-define-kasan_never_merge-for-generic-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-only-define-kasan_never_merge-for-generic-mode.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: only define kasan_never_merge for Generic mode
Date: Mon, 5 Sep 2022 23:05:30 +0200

KASAN prevents merging of slab caches whose objects have per-object
metadata stored in redzones.

As now only the Generic mode uses per-object metadata, define
kasan_never_merge() only for this mode.

Link: https://lkml.kernel.org/r/81ed01f29ff3443580b7e2fe362a8b47b1e8006d.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   18 ++++++------------
 mm/kasan/common.c     |    8 --------
 mm/kasan/generic.c    |    8 ++++++++
 3 files changed, 14 insertions(+), 20 deletions(-)

--- a/include/linux/kasan.h~kasan-only-define-kasan_never_merge-for-generic-mode
+++ a/include/linux/kasan.h
@@ -103,14 +103,6 @@ struct kasan_cache {
 	bool is_kmalloc;
 };
 
-slab_flags_t __kasan_never_merge(void);
-static __always_inline slab_flags_t kasan_never_merge(void)
-{
-	if (kasan_enabled())
-		return __kasan_never_merge();
-	return 0;
-}
-
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -261,10 +253,6 @@ static __always_inline bool kasan_check_
 
 #else /* CONFIG_KASAN */
 
-static inline slab_flags_t kasan_never_merge(void)
-{
-	return 0;
-}
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
@@ -325,6 +313,7 @@ static inline void kasan_unpoison_task_s
 #ifdef CONFIG_KASAN_GENERIC
 
 size_t kasan_metadata_size(struct kmem_cache *cache);
+slab_flags_t kasan_never_merge(void);
 
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
@@ -338,6 +327,11 @@ static inline size_t kasan_metadata_size
 {
 	return 0;
 }
+/* And thus nothing prevents cache merging. */
+static inline slab_flags_t kasan_never_merge(void)
+{
+	return 0;
+}
 
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
--- a/mm/kasan/common.c~kasan-only-define-kasan_never_merge-for-generic-mode
+++ a/mm/kasan/common.c
@@ -88,14 +88,6 @@ asmlinkage void kasan_unpoison_task_stac
 }
 #endif /* CONFIG_KASAN_STACK */
 
-/* Only allow cache merging when no per-object metadata is present. */
-slab_flags_t __kasan_never_merge(void)
-{
-	if (kasan_requires_meta())
-		return SLAB_KASAN;
-	return 0;
-}
-
 void __kasan_unpoison_pages(struct page *page, unsigned int order, bool init)
 {
 	u8 tag;
--- a/mm/kasan/generic.c~kasan-only-define-kasan_never_merge-for-generic-mode
+++ a/mm/kasan/generic.c
@@ -328,6 +328,14 @@ DEFINE_ASAN_SET_SHADOW(f3);
 DEFINE_ASAN_SET_SHADOW(f5);
 DEFINE_ASAN_SET_SHADOW(f8);
 
+/* Only allow cache merging when no per-object metadata is present. */
+slab_flags_t kasan_never_merge(void)
+{
+	if (!kasan_requires_meta())
+		return 0;
+	return SLAB_KASAN;
+}
+
 /*
  * Adaptive redzone policy taken from the userspace AddressSanitizer runtime.
  * For larger allocations larger redzones are used.
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch

