Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9419CC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 18:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiIZSZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 14:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiIZSZS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 14:25:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C4213DFC
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 11:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93547611CD
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 18:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C152FC433D6;
        Mon, 26 Sep 2022 18:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664216592;
        bh=UxIXjnduZOo9zPbgLswXdKlbJsM2InRwwh0qmSc4tYA=;
        h=Date:To:From:Subject:From;
        b=Ko+qIBi15cnzs2rXQMTvNtRR0jY2UdnE8WcdpO5pQ8Emr8Lho0Gaze4qCOWZvAf4+
         BtwylH2GKsH+MpeAZy9qtTHFejHuTapQaI3nDnrh4F/7SP91cx1cVjv4j3tdfVArv7
         zpk/MSABCZ7ZLmiYzSArAOhaOP30TXhmW3ZhxxzI=
Date:   Mon, 26 Sep 2022 11:23:10 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-array-bounds-warnings-in-tests.patch added to mm-unstable branch
Message-Id: <20220926182311.C152FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix array-bounds warnings in tests
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fix-array-bounds-warnings-in-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-array-bounds-warnings-in-tests.patch

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
Subject: kasan: fix array-bounds warnings in tests
Date: Mon, 26 Sep 2022 20:08:47 +0200

GCC's -Warray-bounds option detects out-of-bounds accesses to
statically-sized allocations in krealloc out-of-bounds tests.

Use OPTIMIZER_HIDE_VAR to suppress the warning.

Also change kmalloc_memmove_invalid_size to use OPTIMIZER_HIDE_VAR
instead of a volatile variable.

Link: https://lkml.kernel.org/r/e94399242d32e00bba6fd0d9ec4c897f188128e8.1664215688.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/kasan_test.c~kasan-fix-array-bounds-warnings-in-tests
+++ a/mm/kasan/kasan_test.c
@@ -295,6 +295,9 @@ static void krealloc_more_oob_helper(str
 	ptr2 = krealloc(ptr1, size2, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 
+	/* Suppress -Warray-bounds warnings. */
+	OPTIMIZER_HIDE_VAR(ptr2);
+
 	/* All offsets up to size2 must be accessible. */
 	ptr2[size1 - 1] = 'x';
 	ptr2[size1] = 'x';
@@ -327,6 +330,9 @@ static void krealloc_less_oob_helper(str
 	ptr2 = krealloc(ptr1, size2, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 
+	/* Suppress -Warray-bounds warnings. */
+	OPTIMIZER_HIDE_VAR(ptr2);
+
 	/* Must be accessible for all modes. */
 	ptr2[size2 - 1] = 'x';
 
@@ -540,13 +546,14 @@ static void kmalloc_memmove_invalid_size
 {
 	char *ptr;
 	size_t size = 64;
-	volatile size_t invalid_size = size;
+	size_t invalid_size = size;
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
 	OPTIMIZER_HIDE_VAR(ptr);
+	OPTIMIZER_HIDE_VAR(invalid_size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
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
kasan-implement-stack-ring-for-tag-based-modes-fix.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch
kasan-better-invalid-double-free-report-header.patch
kasan-fix-array-bounds-warnings-in-tests.patch

