Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5156C43333
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 701E564F30
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhBZBWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhBZBVU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E5CD64F31;
        Fri, 26 Feb 2021 01:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302440;
        bh=XL5Lbg9FpnZx+sRTQQpxNRMyW+riWGVdvnrvVqAyq0s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ubel/t07n32fMkSSN949MowZRVGWL+JGerNhB0zA1H8b+pzvp6Exk/wAYyHRUX31F
         l+SKqIL44sAQfyiWnWKRjLl8G75xGsG0hndva0o70reaZQeQqUyLDGaMWptzf9/JIO
         dN2tiEtYCftft1qxTqHx1FxlJETdlYIY1vSJf+4o=
Date:   Thu, 25 Feb 2021 17:20:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 081/118] kasan: clarify that only first bug is
 reported in HW_TAGS
Message-ID: <20210226012038.w5208Ozub%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clarify that only first bug is reported in HW_TAGS

Hwardware tag-based KASAN only reports the first found bug. After that MTE
tag checking gets disabled. Clarify this in comments and documentation.

Link: https://lkml.kernel.org/r/00383ba88a47c3f8342d12263c24bdf95527b07d.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
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
 
@@ -165,7 +165,8 @@ particular KASAN features.
   traces collection (default: ``on``).
 
 - ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``).
+  report or also panic the kernel (default: ``report``). Note, that tag
+  checking gets disabled after the first reported bug.
 
 For developers
 ~~~~~~~~~~~~~~
@@ -295,6 +296,9 @@ Note, that enabling CONFIG_KASAN_HW_TAGS
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
