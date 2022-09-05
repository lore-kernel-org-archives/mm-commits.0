Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D061CC54EE9
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiIEWtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiIEWsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9634967CA0
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B92BB81112
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8ECC433D7;
        Mon,  5 Sep 2022 22:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418121;
        bh=80K6aYYK9glj5HsmcowVlw3HtLVsP822EFtoOxmembE=;
        h=Date:To:From:Subject:From;
        b=gbjST6MXdO1wQVcBg4xBojB1EMw/Uord01UXnPU+huwOn0Bv9n2DhBseDBcitnKop
         5EDwfrQkEHr7MxTBOkzOUg8TCArrncjJdnhSkakR2dMUp34wnrYaFQF0t/S4EYM6qj
         JYM7KgDs5K/vz7rBktwbQb7/Fw+J/UyDRef2Wtpw=
Date:   Mon, 05 Sep 2022 15:48:40 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fill-in-cache-and-object-in-complete_report_info.patch added to mm-unstable branch
Message-Id: <20220905224841.0B8ECC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fill in cache and object in complete_report_info
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fill-in-cache-and-object-in-complete_report_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fill-in-cache-and-object-in-complete_report_info.patch

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
Subject: kasan: fill in cache and object in complete_report_info
Date: Mon, 5 Sep 2022 23:05:42 +0200

Add cache and object fields to kasan_report_info and fill them in in
complete_report_info() instead of fetching them in the middle of the
report printing code.

This allows the reporting code to get access to the object information
before starting printing the report.  One of the following patches uses
this information to determine the bug type with the tag-based modes.

Link: https://lkml.kernel.org/r/23264572cb2cbb8f0efbb51509b6757eb3cc1fc9.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    2 ++
 mm/kasan/report.c |   21 +++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/mm/kasan/kasan.h~kasan-fill-in-cache-and-object-in-complete_report_info
+++ a/mm/kasan/kasan.h
@@ -162,6 +162,8 @@ struct kasan_report_info {
 
 	/* Filled in by the common reporting code. */
 	void *first_bad_addr;
+	struct kmem_cache *cache;
+	void *object;
 };
 
 /* Do not change the struct layout: compiler ABI. */
--- a/mm/kasan/report.c~kasan-fill-in-cache-and-object-in-complete_report_info
+++ a/mm/kasan/report.c
@@ -287,19 +287,16 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
-static void print_address_description(void *addr, u8 tag)
+static void print_address_description(void *addr, u8 tag,
+				      struct kasan_report_info *info)
 {
 	struct page *page = addr_to_page(addr);
-	struct slab *slab = kasan_addr_to_slab(addr);
 
 	dump_stack_lvl(KERN_ERR);
 	pr_err("\n");
 
-	if (slab) {
-		struct kmem_cache *cache = slab->slab_cache;
-		void *object = nearest_obj(cache, slab,	addr);
-
-		describe_object(cache, object, addr, tag);
+	if (info->cache && info->object) {
+		describe_object(info->cache, info->object, addr, tag);
 		pr_err("\n");
 	}
 
@@ -406,7 +403,7 @@ static void print_report(struct kasan_re
 	pr_err("\n");
 
 	if (addr_has_metadata(addr)) {
-		print_address_description(addr, tag);
+		print_address_description(addr, tag, info);
 		print_memory_metadata(info->first_bad_addr);
 	} else {
 		dump_stack_lvl(KERN_ERR);
@@ -416,12 +413,20 @@ static void print_report(struct kasan_re
 static void complete_report_info(struct kasan_report_info *info)
 {
 	void *addr = kasan_reset_tag(info->access_addr);
+	struct slab *slab;
 
 	if (info->type == KASAN_REPORT_ACCESS)
 		info->first_bad_addr = kasan_find_first_bad_addr(
 					info->access_addr, info->access_size);
 	else
 		info->first_bad_addr = addr;
+
+	slab = kasan_addr_to_slab(addr);
+	if (slab) {
+		info->cache = slab->slab_cache;
+		info->object = nearest_obj(info->cache, slab, addr);
+	} else
+		info->cache = info->object = NULL;
 }
 
 void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_type type)
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

