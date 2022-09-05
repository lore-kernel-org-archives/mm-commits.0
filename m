Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07233ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiIEWtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiIEWss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA24467CAA
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32CE760CBB
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EED8C433D7;
        Mon,  5 Sep 2022 22:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418125;
        bh=iCA/+fwwn9kBDF6YsGA6amokBiFsMu5ovev5Ihq/6Rg=;
        h=Date:To:From:Subject:From;
        b=FG+OlV5/nbmwBpyBCLgKpX6jdoc35WOtjME7hxpujFzakr9rA7PBswki30YwhgyZQ
         kBZcQ7soPNX+RCFLgHzOO+TuCGHyGmT37OtCNZPy7kIhENF2DOKwouNJlQltDdn+t4
         4ADTn8p5SCtRuApgowqzaUVmMf/Y6JlekjakDjfQ=
Date:   Mon, 05 Sep 2022 15:48:44 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-kasan_complete_mode_report_info.patch added to mm-unstable branch
Message-Id: <20220905224845.7EED8C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: introduce kasan_complete_mode_report_info
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-kasan_complete_mode_report_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-kasan_complete_mode_report_info.patch

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
Subject: kasan: introduce kasan_complete_mode_report_info
Date: Mon, 5 Sep 2022 23:05:44 +0200

Add bug_type and alloc/free_track fields to kasan_report_info and add a
kasan_complete_mode_report_info() function that fills in these fields. 
This function is implemented differently for different KASAN mode.

Change the reporting code to use the filled in fields instead of invoking
kasan_get_bug_type() and kasan_get_alloc/free_track().

For the Generic mode, kasan_complete_mode_report_info() invokes these
functions instead.  For the tag-based modes, only the bug_type field is
filled in; alloc/free_track are handled in the next patch.

Using a single function that fills in these fields is required for the
tag-based modes, as the values for all three fields are determined in a
single procedure implemented in the following patch.

Link: https://lkml.kernel.org/r/8432b861054fa8d0cee79a8877dedeaf3b677ca8.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h          |   33 +++++++++++++++++----------------
 mm/kasan/report.c         |   30 ++++++++++++++----------------
 mm/kasan/report_generic.c |   32 +++++++++++++++++---------------
 mm/kasan/report_tags.c    |   13 +++----------
 4 files changed, 51 insertions(+), 57 deletions(-)

--- a/mm/kasan/kasan.h~kasan-introduce-kasan_complete_mode_report_info
+++ a/mm/kasan/kasan.h
@@ -146,6 +146,13 @@ static inline bool kasan_requires_meta(v
 #define META_MEM_BYTES_PER_ROW (META_BYTES_PER_ROW * KASAN_GRANULE_SIZE)
 #define META_ROWS_AROUND_ADDR 2
 
+#define KASAN_STACK_DEPTH 64
+
+struct kasan_track {
+	u32 pid;
+	depot_stack_handle_t stack;
+};
+
 enum kasan_report_type {
 	KASAN_REPORT_ACCESS,
 	KASAN_REPORT_INVALID_FREE,
@@ -164,6 +171,11 @@ struct kasan_report_info {
 	void *first_bad_addr;
 	struct kmem_cache *cache;
 	void *object;
+
+	/* Filled in by the mode-specific reporting code. */
+	const char *bug_type;
+	struct kasan_track alloc_track;
+	struct kasan_track free_track;
 };
 
 /* Do not change the struct layout: compiler ABI. */
@@ -189,14 +201,7 @@ struct kasan_global {
 #endif
 };
 
-/* Structures for keeping alloc and free tracks. */
-
-#define KASAN_STACK_DEPTH 64
-
-struct kasan_track {
-	u32 pid;
-	depot_stack_handle_t stack;
-};
+/* Structures for keeping alloc and free meta. */
 
 #ifdef CONFIG_KASAN_GENERIC
 
@@ -270,16 +275,16 @@ static inline bool addr_has_metadata(con
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
+void *kasan_find_first_bad_addr(void *addr, size_t size);
+void kasan_complete_mode_report_info(struct kasan_report_info *info);
+void kasan_metadata_fetch_row(char *buffer, void *row);
+
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 void kasan_print_tags(u8 addr_tag, const void *addr);
 #else
 static inline void kasan_print_tags(u8 addr_tag, const void *addr) { }
 #endif
 
-void *kasan_find_first_bad_addr(void *addr, size_t size);
-const char *kasan_get_bug_type(struct kasan_report_info *info);
-void kasan_metadata_fetch_row(char *buffer, void *row);
-
 #if defined(CONFIG_KASAN_STACK)
 void kasan_print_address_stack_frame(const void *addr);
 #else
@@ -314,10 +319,6 @@ depot_stack_handle_t kasan_save_stack(gf
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
 void kasan_save_free_info(struct kmem_cache *cache, void *object);
-struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
-						void *object);
-struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-						void *object, u8 tag);
 
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
--- a/mm/kasan/report.c~kasan-introduce-kasan_complete_mode_report_info
+++ a/mm/kasan/report.c
@@ -185,8 +185,7 @@ static void print_error_description(stru
 		return;
 	}
 
-	pr_err("BUG: KASAN: %s in %pS\n",
-		kasan_get_bug_type(info), (void *)info->ip);
+	pr_err("BUG: KASAN: %s in %pS\n", info->bug_type, (void *)info->ip);
 	if (info->access_size)
 		pr_err("%s of size %zu at addr %px by task %s/%d\n",
 			info->is_write ? "Write" : "Read", info->access_size,
@@ -242,31 +241,25 @@ static void describe_object_addr(const v
 		(void *)(object_addr + cache->object_size));
 }
 
-static void describe_object_stacks(u8 tag, struct kasan_report_info *info)
+static void describe_object_stacks(struct kasan_report_info *info)
 {
-	struct kasan_track *alloc_track;
-	struct kasan_track *free_track;
-
-	alloc_track = kasan_get_alloc_track(info->cache, info->object);
-	if (alloc_track) {
-		print_track(alloc_track, "Allocated");
+	if (info->alloc_track.stack) {
+		print_track(&info->alloc_track, "Allocated");
 		pr_err("\n");
 	}
 
-	free_track = kasan_get_free_track(info->cache, info->object, tag);
-	if (free_track) {
-		print_track(free_track, "Freed");
+	if (info->free_track.stack) {
+		print_track(&info->free_track, "Freed");
 		pr_err("\n");
 	}
 
 	kasan_print_aux_stacks(info->cache, info->object);
 }
 
-static void describe_object(const void *addr, u8 tag,
-			    struct kasan_report_info *info)
+static void describe_object(const void *addr, struct kasan_report_info *info)
 {
 	if (kasan_stack_collection_enabled())
-		describe_object_stacks(tag, info);
+		describe_object_stacks(info);
 	describe_object_addr(addr, info->cache, info->object);
 }
 
@@ -295,7 +288,7 @@ static void print_address_description(vo
 	pr_err("\n");
 
 	if (info->cache && info->object) {
-		describe_object(addr, tag, info);
+		describe_object(addr, info);
 		pr_err("\n");
 	}
 
@@ -426,6 +419,9 @@ static void complete_report_info(struct
 		info->object = nearest_obj(info->cache, slab, addr);
 	} else
 		info->cache = info->object = NULL;
+
+	/* Fill in mode-specific report info fields. */
+	kasan_complete_mode_report_info(info);
 }
 
 void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_type type)
@@ -443,6 +439,7 @@ void kasan_report_invalid_free(void *ptr
 
 	start_report(&flags, true);
 
+	memset(&info, 0, sizeof(info));
 	info.type = type;
 	info.access_addr = ptr;
 	info.access_size = 0;
@@ -477,6 +474,7 @@ bool kasan_report(unsigned long addr, si
 
 	start_report(&irq_flags, true);
 
+	memset(&info, 0, sizeof(info));
 	info.type = KASAN_REPORT_ACCESS;
 	info.access_addr = ptr;
 	info.access_size = size;
--- a/mm/kasan/report_generic.c~kasan-introduce-kasan_complete_mode_report_info
+++ a/mm/kasan/report_generic.c
@@ -109,7 +109,7 @@ static const char *get_wild_bug_type(str
 	return bug_type;
 }
 
-const char *kasan_get_bug_type(struct kasan_report_info *info)
+static const char *get_bug_type(struct kasan_report_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
@@ -127,25 +127,27 @@ const char *kasan_get_bug_type(struct ka
 	return get_wild_bug_type(info);
 }
 
-struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
-						void *object)
+void kasan_complete_mode_report_info(struct kasan_report_info *info)
 {
 	struct kasan_alloc_meta *alloc_meta;
+	struct kasan_free_meta *free_meta;
 
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return NULL;
+	info->bug_type = get_bug_type(info);
 
-	return &alloc_meta->alloc_track;
-}
+	if (!info->cache || !info->object)
+		return;
 
-struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-						void *object, u8 tag)
-{
-	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREETRACK)
-		return NULL;
-	/* Free meta must be present with KASAN_SLAB_FREETRACK. */
-	return &kasan_get_free_meta(cache, object)->free_track;
+	alloc_meta = kasan_get_alloc_meta(info->cache, info->object);
+	if (alloc_meta)
+		memcpy(&info->alloc_track, &alloc_meta->alloc_track,
+		       sizeof(info->alloc_track));
+
+	if (*(u8 *)kasan_mem_to_shadow(info->object) == KASAN_SLAB_FREETRACK) {
+		/* Free meta must be present with KASAN_SLAB_FREETRACK. */
+		free_meta = kasan_get_free_meta(info->cache, info->object);
+		memcpy(&info->free_track, &free_meta->free_track,
+		       sizeof(info->free_track));
+	}
 }
 
 void kasan_metadata_fetch_row(char *buffer, void *row)
--- a/mm/kasan/report_tags.c~kasan-introduce-kasan_complete_mode_report_info
+++ a/mm/kasan/report_tags.c
@@ -6,7 +6,7 @@
 
 #include "kasan.h"
 
-const char *kasan_get_bug_type(struct kasan_report_info *info)
+static const char *get_bug_type(struct kasan_report_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
@@ -22,14 +22,7 @@ const char *kasan_get_bug_type(struct ka
 	return "invalid-access";
 }
 
-struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
-						void *object)
+void kasan_complete_mode_report_info(struct kasan_report_info *info)
 {
-	return NULL;
-}
-
-struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-						void *object, u8 tag)
-{
-	return NULL;
+	info->bug_type = get_bug_type(info);
 }
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

