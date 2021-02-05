Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87ECC433E6
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8939C64D79
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhBEVWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhBEVUb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:20:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 033EC64FCE;
        Fri,  5 Feb 2021 21:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612559931;
        bh=bHy+wVSug1ErvA7vX6TJCvDd8q4UFU9TnFikHJ812YE=;
        h=Date:From:To:Subject:From;
        b=WJmWbToil1LB6ztbicZ/1JhCXnYWrOrjlKb2S09ZIzkKjRur6H0/Z0S2bft5gJK5P
         8ubJfZ2uYJUw0G/uEGjjWkLCEKZHtyubWq6Gj8ARwddanoLHwiM28LofdoswwmGZ/E
         n1YTN8SlY9QRAHARVzTkakoCVyNLwi6ZS2mjWP0k=
Date:   Fri, 05 Feb 2021 13:18:50 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  +
 kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch added to -mm
 tree
Message-ID: <20210205211850.O9Q3I65tu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clarify that only first bug is reported in HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

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
Subject: kasan: clarify that only first bug is reported in HW_TAGS

Hwardware tag-based KASAN only reports the first found bug. After that MTE
tag checking gets disabled. Clarify this in comments and documentation.

Link: https://lkml.kernel.org/r/00383ba88a47c3f8342d12263c24bdf95527b07d.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    8 ++++++--
 mm/kasan/hw_tags.c                |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-clarify-that-only-first-bug-is-reported-in-hw_tags
+++ a/Documentation/dev-tools/kasan.rst
@@ -155,7 +155,7 @@ Boot parameters
 ~~~~~~~~~~~~~~~
 
 Hardware tag-based KASAN mode (see the section about various modes below) is
-intended for use in production as a security mitigation. Therefore it supports
+intended for use in production as a security mitigation. Therefore, it supports
 boot parameters that allow to disable KASAN competely or otherwise control
 particular KASAN features.
 
@@ -166,7 +166,8 @@ particular KASAN features.
   ``off``).
 
 - ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``).
+  report or also panic the kernel (default: ``report``). Note, that tag
+  checking gets disabled after the first reported bug.
 
 For developers
 ~~~~~~~~~~~~~~
@@ -296,6 +297,9 @@ Note, that enabling CONFIG_KASAN_HW_TAGS
 enabled. Even when kasan.mode=off is provided, or when the hardware doesn't
 support MTE (but supports TBI).
 
+Hardware tag-based KASAN only reports the first found bug. After that MTE tag
+checking gets disabled.
+
 What memory accesses are sanitised by KASAN?
 --------------------------------------------
 
--- a/mm/kasan/hw_tags.c~kasan-clarify-that-only-first-bug-is-reported-in-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(kasan_flag_enabled);
 /* Whether to collect alloc/free stack traces. */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
 
-/* Whether panic or disable tag checking on fault. */
+/* Whether to panic or print a report and disable tag checking on fault. */
 bool kasan_flag_panic __ro_after_init;
 
 /* kasan=off/on */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
arm64-kasan-export-mte-symbols-for-kasan-tests.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

