Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EA2C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B9F22CB2
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbhAXFCr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbhAXFCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0541922CB3;
        Sun, 24 Jan 2021 05:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464496;
        bh=WT/tc6IVw8wZVq1GinG+WKbF929TqWTcU553roxIv5U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HV80w1CmEPq1KHW3LjqbKIq/YM/wN3T/k7HPqaiU37UtmGKPdrj5Hx0P/hriYBb8y
         ZrcIl3ZMHI0CdzzinzkoeZv0Dnv+/+qJqs8wmAtYWfUA0YmqxgEVi7mWsgW967GKJV
         G69mDdVIAL3yGZNHTxBHDMi3LBL5eN+ehonGTzM4=
Date:   Sat, 23 Jan 2021 21:01:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 09/19] kasan: fix HW_TAGS boot parameters
Message-ID: <20210124050134.co1uota0r%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix HW_TAGS boot parameters

The initially proposed KASAN command line parameters are redundant.

This change drops the complex "kasan.mode=off/prod/full" parameter
and adds a simpler kill switch "kasan=off/on" instead. The new parameter
together with the already existing ones provides a cleaner way to
express the same set of features.

The full set of parameters with this change:

kasan=off/on             - whether KASAN is enabled
kasan.fault=report/panic - whether to only print a report or also panic
kasan.stacktrace=off/on  - whether to collect alloc/free stack traces

Default values:

kasan=on
kasan.fault=report
kasan.stacktrace=on  (if CONFIG_DEBUG_KERNEL=y)
kasan.stacktrace=off (otherwise)

Link: https://linux-review.googlesource.com/id/Ib3694ed90b1e8ccac6cf77dfd301847af4aba7b8
Link: https://lkml.kernel.org/r/4e9c4a4bdcadc168317deb2419144582a9be6e61.1610736745.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   27 ++-------
 mm/kasan/hw_tags.c                |   77 +++++++++++-----------------
 2 files changed, 38 insertions(+), 66 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-fix-hw_tags-boot-parameters
+++ a/Documentation/dev-tools/kasan.rst
@@ -160,29 +160,14 @@ intended for use in production as a secu
 boot parameters that allow to disable KASAN competely or otherwise control
 particular KASAN features.
 
-The things that can be controlled are:
+- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
-1. Whether KASAN is enabled at all.
-2. Whether KASAN collects and saves alloc/free stacks.
-3. Whether KASAN panics on a detected bug or not.
+- ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
+  traces collection (default: ``on`` for ``CONFIG_DEBUG_KERNEL=y``, otherwise
+  ``off``).
 
-The ``kasan.mode`` boot parameter allows to choose one of three main modes:
-
-- ``kasan.mode=off`` - KASAN is disabled, no tag checks are performed
-- ``kasan.mode=prod`` - only essential production features are enabled
-- ``kasan.mode=full`` - all KASAN features are enabled
-
-The chosen mode provides default control values for the features mentioned
-above. However it's also possible to override the default values by providing:
-
-- ``kasan.stacktrace=off`` or ``=on`` - enable alloc/free stack collection
-					(default: ``on`` for ``mode=full``,
-					 otherwise ``off``)
-- ``kasan.fault=report`` or ``=panic`` - only print KASAN report or also panic
-					 (default: ``report``)
-
-If ``kasan.mode`` parameter is not provided, it defaults to ``full`` when
-``CONFIG_DEBUG_KERNEL`` is enabled, and to ``prod`` otherwise.
+- ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
+  report or also panic the kernel (default: ``report``).
 
 For developers
 ~~~~~~~~~~~~~~
--- a/mm/kasan/hw_tags.c~kasan-fix-hw_tags-boot-parameters
+++ a/mm/kasan/hw_tags.c
@@ -19,11 +19,10 @@
 
 #include "kasan.h"
 
-enum kasan_arg_mode {
-	KASAN_ARG_MODE_DEFAULT,
-	KASAN_ARG_MODE_OFF,
-	KASAN_ARG_MODE_PROD,
-	KASAN_ARG_MODE_FULL,
+enum kasan_arg {
+	KASAN_ARG_DEFAULT,
+	KASAN_ARG_OFF,
+	KASAN_ARG_ON,
 };
 
 enum kasan_arg_stacktrace {
@@ -38,7 +37,7 @@ enum kasan_arg_fault {
 	KASAN_ARG_FAULT_PANIC,
 };
 
-static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
+static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_stacktrace kasan_arg_stacktrace __ro_after_init;
 static enum kasan_arg_fault kasan_arg_fault __ro_after_init;
 
@@ -52,26 +51,24 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_stack
 /* Whether panic or disable tag checking on fault. */
 bool kasan_flag_panic __ro_after_init;
 
-/* kasan.mode=off/prod/full */
-static int __init early_kasan_mode(char *arg)
+/* kasan=off/on */
+static int __init early_kasan_flag(char *arg)
 {
 	if (!arg)
 		return -EINVAL;
 
 	if (!strcmp(arg, "off"))
-		kasan_arg_mode = KASAN_ARG_MODE_OFF;
-	else if (!strcmp(arg, "prod"))
-		kasan_arg_mode = KASAN_ARG_MODE_PROD;
-	else if (!strcmp(arg, "full"))
-		kasan_arg_mode = KASAN_ARG_MODE_FULL;
+		kasan_arg = KASAN_ARG_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg = KASAN_ARG_ON;
 	else
 		return -EINVAL;
 
 	return 0;
 }
-early_param("kasan.mode", early_kasan_mode);
+early_param("kasan", early_kasan_flag);
 
-/* kasan.stack=off/on */
+/* kasan.stacktrace=off/on */
 static int __init early_kasan_flag_stacktrace(char *arg)
 {
 	if (!arg)
@@ -113,8 +110,8 @@ void kasan_init_hw_tags_cpu(void)
 	 * as this function is only called for MTE-capable hardware.
 	 */
 
-	/* If KASAN is disabled, do nothing. */
-	if (kasan_arg_mode == KASAN_ARG_MODE_OFF)
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg == KASAN_ARG_OFF)
 		return;
 
 	hw_init_tags(KASAN_TAG_MAX);
@@ -124,43 +121,28 @@ void kasan_init_hw_tags_cpu(void)
 /* kasan_init_hw_tags() is called once on boot CPU. */
 void __init kasan_init_hw_tags(void)
 {
-	/* If hardware doesn't support MTE, do nothing. */
+	/* If hardware doesn't support MTE, don't initialize KASAN. */
 	if (!system_supports_mte())
 		return;
 
-	/* Choose KASAN mode if kasan boot parameter is not provided. */
-	if (kasan_arg_mode == KASAN_ARG_MODE_DEFAULT) {
-		if (IS_ENABLED(CONFIG_DEBUG_KERNEL))
-			kasan_arg_mode = KASAN_ARG_MODE_FULL;
-		else
-			kasan_arg_mode = KASAN_ARG_MODE_PROD;
-	}
-
-	/* Preset parameter values based on the mode. */
-	switch (kasan_arg_mode) {
-	case KASAN_ARG_MODE_DEFAULT:
-		/* Shouldn't happen as per the check above. */
-		WARN_ON(1);
-		return;
-	case KASAN_ARG_MODE_OFF:
-		/* If KASAN is disabled, do nothing. */
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg == KASAN_ARG_OFF)
 		return;
-	case KASAN_ARG_MODE_PROD:
-		static_branch_enable(&kasan_flag_enabled);
-		break;
-	case KASAN_ARG_MODE_FULL:
-		static_branch_enable(&kasan_flag_enabled);
-		static_branch_enable(&kasan_flag_stacktrace);
-		break;
-	}
 
-	/* Now, optionally override the presets. */
+	/* Enable KASAN. */
+	static_branch_enable(&kasan_flag_enabled);
 
 	switch (kasan_arg_stacktrace) {
 	case KASAN_ARG_STACKTRACE_DEFAULT:
+		/*
+		 * Default to enabling stack trace collection for
+		 * debug kernels.
+		 */
+		if (IS_ENABLED(CONFIG_DEBUG_KERNEL))
+			static_branch_enable(&kasan_flag_stacktrace);
 		break;
 	case KASAN_ARG_STACKTRACE_OFF:
-		static_branch_disable(&kasan_flag_stacktrace);
+		/* Do nothing, kasan_flag_stacktrace keeps its default value. */
 		break;
 	case KASAN_ARG_STACKTRACE_ON:
 		static_branch_enable(&kasan_flag_stacktrace);
@@ -169,11 +151,16 @@ void __init kasan_init_hw_tags(void)
 
 	switch (kasan_arg_fault) {
 	case KASAN_ARG_FAULT_DEFAULT:
+		/*
+		 * Default to no panic on report.
+		 * Do nothing, kasan_flag_panic keeps its default value.
+		 */
 		break;
 	case KASAN_ARG_FAULT_REPORT:
-		kasan_flag_panic = false;
+		/* Do nothing, kasan_flag_panic keeps its default value. */
 		break;
 	case KASAN_ARG_FAULT_PANIC:
+		/* Enable panic on report. */
 		kasan_flag_panic = true;
 		break;
 	}
_
