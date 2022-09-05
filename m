Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2293ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiIEWtM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiIEWss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C4567CA4
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D7FB815E6
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FEBC433D6;
        Mon,  5 Sep 2022 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418123;
        bh=9+5dA1NZE/WU3RQoug9vhm574jg5e8chZPXfVW8sCe0=;
        h=Date:To:From:Subject:From;
        b=g/zEGqpYcNkXAha9IIPRcrEtjw2xnqkWIHgYdNsxrYivbM/a7QSKGTqh/dvBmKToI
         87fkPklgn8K3j2GtmeoPpeUKu5xcAIJHwjw03VU2ZbXArVnq1lE3OJPRP0KcmLSMjk
         YcqY7GCT/qNx5UWoVZ5dffOdjVaJJvsKDOh3oA6M=
Date:   Mon, 05 Sep 2022 15:48:42 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-rework-function-arguments-in-reportc.patch added to mm-unstable branch
Message-Id: <20220905224843.67FEBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rework function arguments in report.c
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-rework-function-arguments-in-reportc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-rework-function-arguments-in-reportc.patch

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
Subject: kasan: rework function arguments in report.c
Date: Mon, 5 Sep 2022 23:05:43 +0200

Pass a pointer to kasan_report_info to describe_object() and
describe_object_stacks(), instead of passing the structure's fields.

The untagged pointer and the tag are still passed as separate arguments to
some of the functions to avoid duplicating the untagging logic.

This is preparatory change for the next patch.

Link: https://lkml.kernel.org/r/2e0cdb91524ab528a3c2b12b6d8bcb69512fc4af.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/kasan/report.c~kasan-rework-function-arguments-in-reportc
+++ a/mm/kasan/report.c
@@ -213,8 +213,8 @@ static inline struct page *addr_to_page(
 	return NULL;
 }
 
-static void describe_object_addr(struct kmem_cache *cache, void *object,
-				const void *addr)
+static void describe_object_addr(const void *addr, struct kmem_cache *cache,
+				 void *object)
 {
 	unsigned long access_addr = (unsigned long)addr;
 	unsigned long object_addr = (unsigned long)object;
@@ -242,33 +242,32 @@ static void describe_object_addr(struct
 		(void *)(object_addr + cache->object_size));
 }
 
-static void describe_object_stacks(struct kmem_cache *cache, void *object,
-					const void *addr, u8 tag)
+static void describe_object_stacks(u8 tag, struct kasan_report_info *info)
 {
 	struct kasan_track *alloc_track;
 	struct kasan_track *free_track;
 
-	alloc_track = kasan_get_alloc_track(cache, object);
+	alloc_track = kasan_get_alloc_track(info->cache, info->object);
 	if (alloc_track) {
 		print_track(alloc_track, "Allocated");
 		pr_err("\n");
 	}
 
-	free_track = kasan_get_free_track(cache, object, tag);
+	free_track = kasan_get_free_track(info->cache, info->object, tag);
 	if (free_track) {
 		print_track(free_track, "Freed");
 		pr_err("\n");
 	}
 
-	kasan_print_aux_stacks(cache, object);
+	kasan_print_aux_stacks(info->cache, info->object);
 }
 
-static void describe_object(struct kmem_cache *cache, void *object,
-				const void *addr, u8 tag)
+static void describe_object(const void *addr, u8 tag,
+			    struct kasan_report_info *info)
 {
 	if (kasan_stack_collection_enabled())
-		describe_object_stacks(cache, object, addr, tag);
-	describe_object_addr(cache, object, addr);
+		describe_object_stacks(tag, info);
+	describe_object_addr(addr, info->cache, info->object);
 }
 
 static inline bool kernel_or_module_addr(const void *addr)
@@ -296,7 +295,7 @@ static void print_address_description(vo
 	pr_err("\n");
 
 	if (info->cache && info->object) {
-		describe_object(info->cache, info->object, addr, tag);
+		describe_object(addr, tag, info);
 		pr_err("\n");
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

