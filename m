Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4202C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 18:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbiEISwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 14:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbiEISwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 14:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0717A202B13
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 11:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912AB61657
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 18:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1A8C385B6;
        Mon,  9 May 2022 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652122104;
        bh=9PmWXByLz5locluvKEMd44o2TxIgb8HPdUCCqSJrDfI=;
        h=Date:To:From:Subject:From;
        b=N0igYpX2hmlZAcJApxoHYobYXVTgo12xbgrpmSPBE+rNE0H1AHJ64Tg3qh3Vv5jBX
         TuGSccxWxZ73h18zUeu+IvPuAYiGNxrr1sKlfaDXFGPWGnoOJOPaTHEyIGfeEVf0Z9
         Zng3z0iHzNCTX9FMCzgjexqifbTbP1AQH4gA5/pA=
Date:   Mon, 09 May 2022 11:48:23 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clean-up-comments-in-internal-kasanh.patch added to mm-unstable branch
Message-Id: <20220509184823.EB1A8C385B6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clean up comments in internal kasan.h
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clean-up-comments-in-internal-kasanh.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: kasan: clean up comments in internal kasan.h

Clean up comments in mm/kasan/kasan.h: clarify, unify styles, fix
punctuation, etc.

Link: https://lkml.kernel.org/r/a0680ff30035b56cb7bdd5f59fd400e71712ceb5.1652111464.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   74 ++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

--- a/mm/kasan/kasan.h~kasan-clean-up-comments-in-internal-kasanh
+++ a/mm/kasan/kasan.h
@@ -42,6 +42,7 @@ static inline bool kasan_sync_fault_poss
 {
 	return kasan_mode == KASAN_MODE_SYNC || kasan_mode == KASAN_MODE_ASYMM;
 }
+
 #else
 
 static inline bool kasan_stack_collection_enabled(void)
@@ -73,47 +74,41 @@ static inline bool kasan_sync_fault_poss
 #define KASAN_MEMORY_PER_SHADOW_PAGE	(KASAN_GRANULE_SIZE << PAGE_SHIFT)
 
 #ifdef CONFIG_KASAN_GENERIC
-#define KASAN_FREE_PAGE         0xFF  /* page was freed */
-#define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
-#define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
-#define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
-#define KASAN_VMALLOC_INVALID   0xF8  /* unallocated space in vmapped page */
+#define KASAN_FREE_PAGE         0xFF  /* freed page */
+#define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocation */
+#define KASAN_KMALLOC_REDZONE   0xFC  /* redzone for slab object */
+#define KASAN_KMALLOC_FREE      0xFB  /* freed slab object */
+#define KASAN_VMALLOC_INVALID   0xF8  /* inaccessible space in vmap area */
 #else
 #define KASAN_FREE_PAGE         KASAN_TAG_INVALID
 #define KASAN_PAGE_REDZONE      KASAN_TAG_INVALID
 #define KASAN_KMALLOC_REDZONE   KASAN_TAG_INVALID
 #define KASAN_KMALLOC_FREE      KASAN_TAG_INVALID
-#define KASAN_VMALLOC_INVALID   KASAN_TAG_INVALID /* only for SW_TAGS */
+#define KASAN_VMALLOC_INVALID   KASAN_TAG_INVALID /* only used for SW_TAGS */
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
 
-#define KASAN_KMALLOC_FREETRACK 0xFA  /* object was freed and has free track set */
+#define KASAN_KMALLOC_FREETRACK 0xFA  /* freed slab object with free track */
 #define KASAN_GLOBAL_REDZONE    0xF9  /* redzone for global variable */
 
-/*
- * Stack redzone shadow values
- * (Those are compiler's ABI, don't change them)
- */
+/* Stack redzone shadow values. Compiler ABI, do not change. */
 #define KASAN_STACK_LEFT        0xF1
 #define KASAN_STACK_MID         0xF2
 #define KASAN_STACK_RIGHT       0xF3
 #define KASAN_STACK_PARTIAL     0xF4
 
-/*
- * alloca redzone shadow values
- */
+/* alloca redzone shadow values. */
 #define KASAN_ALLOCA_LEFT	0xCA
 #define KASAN_ALLOCA_RIGHT	0xCB
 
+/* alloca redzone size. Compiler ABI, do not change. */
 #define KASAN_ALLOCA_REDZONE_SIZE	32
 
-/*
- * Stack frame marker (compiler ABI).
- */
+/* Stack frame marker. Compiler ABI, do not change. */
 #define KASAN_CURRENT_STACK_FRAME_MAGIC 0x41B58AB3
 
-/* Don't break randconfig/all*config builds */
+/* Dummy value to avoid breaking randconfig/all*config builds. */
 #ifndef KASAN_ABI_VERSION
 #define KASAN_ABI_VERSION 1
 #endif
@@ -141,21 +136,21 @@ struct kasan_report_info {
 	unsigned long ip;
 };
 
-/* The layout of struct dictated by compiler */
+/* Do not change the struct layout: compiler ABI. */
 struct kasan_source_location {
 	const char *filename;
 	int line_no;
 	int column_no;
 };
 
-/* The layout of struct dictated by compiler */
+/* Do not change the struct layout: compiler ABI. */
 struct kasan_global {
 	const void *beg;		/* Address of the beginning of the global variable. */
 	size_t size;			/* Size of the global variable. */
-	size_t size_with_redzone;	/* Size of the variable + size of the red zone. 32 bytes aligned */
+	size_t size_with_redzone;	/* Size of the variable + size of the redzone. 32 bytes aligned. */
 	const void *name;
 	const void *module_name;	/* Name of the module where the global variable is declared. */
-	unsigned long has_dynamic_init;	/* This needed for C++ */
+	unsigned long has_dynamic_init;	/* This is needed for C++. */
 #if KASAN_ABI_VERSION >= 4
 	struct kasan_source_location *location;
 #endif
@@ -164,9 +159,7 @@ struct kasan_global {
 #endif
 };
 
-/**
- * Structures to keep alloc and free tracks *
- */
+/* Structures for keeping alloc and free tracks. */
 
 #define KASAN_STACK_DEPTH 64
 
@@ -183,11 +176,8 @@ struct kasan_track {
 
 struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
+	/* Generic mode stores free track in kasan_free_meta. */
 #ifdef CONFIG_KASAN_GENERIC
-	/*
-	 * The auxiliary stack is stored into struct kasan_alloc_meta.
-	 * The free stack is stored into struct kasan_free_meta.
-	 */
 	depot_stack_handle_t aux_stack[2];
 #else
 	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
@@ -203,18 +193,18 @@ struct qlist_node {
 };
 
 /*
- * Generic mode either stores free meta in the object itself or in the redzone
- * after the object. In the former case free meta offset is 0, in the latter
- * case it has some sane value smaller than INT_MAX. Use INT_MAX as free meta
- * offset when free meta isn't present.
+ * Free meta is stored either in the object itself or in the redzone after the
+ * object. In the former case, free meta offset is 0. In the latter case, the
+ * offset is between 0 and INT_MAX. INT_MAX marks that free meta is not present.
  */
 #define KASAN_NO_FREE_META INT_MAX
 
+/*
+ * Free meta is only used by Generic mode while the object is in quarantine.
+ * After that, slab allocator stores the freelist pointer in the object.
+ */
 struct kasan_free_meta {
 #ifdef CONFIG_KASAN_GENERIC
-	/* This field is used while the object is in the quarantine.
-	 * Otherwise it might be used for the allocator freelist.
-	 */
 	struct qlist_node quarantine_link;
 	struct kasan_track free_track;
 #endif
@@ -417,9 +407,10 @@ static inline void kasan_unpoison(const
 		return;
 	/*
 	 * Explicitly initialize the memory with the precise object size to
-	 * avoid overwriting the SLAB redzone. This disables initialization in
-	 * the arch code and may thus lead to performance penalty. The penalty
-	 * is accepted since SLAB redzones aren't enabled in production builds.
+	 * avoid overwriting the slab redzone. This disables initialization in
+	 * the arch code and may thus lead to performance penalty. This penalty
+	 * does not affect production builds, as slab redzones are not enabled
+	 * there.
 	 */
 	if (__slub_debug_enabled() &&
 	    init && ((unsigned long)size & KASAN_GRANULE_MASK)) {
@@ -503,8 +494,9 @@ void kasan_restore_multi_shot(bool enabl
 
 /*
  * Exported functions for interfaces called from assembly or from generated
- * code. Declarations here to avoid warning about missing declarations.
+ * code. Declared here to avoid warnings about missing declarations.
  */
+
 asmlinkage void kasan_unpoison_task_stack_below(const void *watermark);
 void __asan_register_globals(struct kasan_global *globals, size_t size);
 void __asan_unregister_globals(struct kasan_global *globals, size_t size);
@@ -573,4 +565,4 @@ void __hwasan_storeN_noabort(unsigned lo
 
 void __hwasan_tag_memory(unsigned long addr, u8 tag, unsigned long size);
 
-#endif
+#endif /* __MM_KASAN_KASAN_H */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-clean-up-comments-in-internal-kasanh.patch
kasan-use-tabs-to-align-shadow-values.patch
kasan-give-better-names-to-shadow-values.patch

