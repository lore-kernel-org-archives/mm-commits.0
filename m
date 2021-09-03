Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BE9C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71CA361151
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhICVAO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350079AbhICVAK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A84A6112E;
        Fri,  3 Sep 2021 20:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702749;
        bh=L5wyI8Uf/ztCzHSl1TA9oSpQxwAfLJRnUlYP0ehorVM=;
        h=Date:From:To:Subject:From;
        b=feEHni+JGrEJ/TIBVJUp1I073Vn70QGLSSx5zzvw/H3GRuqrG2z1KnybOCXpV4o36
         3OGxFBh1VULaPkLe9e50SWRO2n6qqnv6APCm6JBh1HfG1vbtejERefie8VB0S5T1rr
         /3/QBJ6SrQZEUtZzJmAak8X/T4TyumEU1ACPf3c0=
Date:   Fri, 03 Sep 2021 13:59:09 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, corbet@lwn.net, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, woodylin@google.com
Subject:  [merged]
 mm-kasan-move-kasanfault-to-mm-kasan-reportc.patch removed from -mm tree
Message-ID: <20210903205909.UylZ_pOw4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: move kasan.fault to mm/kasan/report.c
has been removed from the -mm tree.  Its filename was
     mm-kasan-move-kasanfault-to-mm-kasan-reportc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Woody Lin <woodylin@google.com>
Subject: mm/kasan: move kasan.fault to mm/kasan/report.c

Move the boot parameter 'kasan.fault' from hw_tags.c to report.c, so it
can support all KASAN modes - generic, and both tag-based.

Link: https://lkml.kernel.org/r/20210713010536.3161822-1-woodylin@google.com
Signed-off-by: Woody Lin <woodylin@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   13 +++++---
 mm/kasan/hw_tags.c                |   43 ----------------------------
 mm/kasan/kasan.h                  |    1 
 mm/kasan/report.c                 |   29 ++++++++++++++++--
 4 files changed, 34 insertions(+), 52 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~mm-kasan-move-kasanfault-to-mm-kasan-reportc
+++ a/Documentation/dev-tools/kasan.rst
@@ -181,9 +181,16 @@ By default, KASAN prints a bug report on
 With ``kasan_multi_shot``, KASAN prints a report on every invalid access. This
 effectively disables ``panic_on_warn`` for KASAN reports.
 
+Alternatively, independent of ``panic_on_warn`` the ``kasan.fault=`` boot
+parameter can be used to control panic and reporting behaviour:
+
+- ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
+  report or also panic the kernel (default: ``report``). The panic happens even
+  if ``kasan_multi_shot`` is enabled.
+
 Hardware tag-based KASAN mode (see the section about various modes below) is
 intended for use in production as a security mitigation. Therefore, it supports
-boot parameters that allow disabling KASAN or controlling its features.
+additional boot parameters that allow disabling KASAN or controlling features:
 
 - ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
@@ -199,10 +206,6 @@ boot parameters that allow disabling KAS
 - ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
   traces collection (default: ``on``).
 
-- ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``). The panic happens even
-  if ``kasan_multi_shot`` is enabled.
-
 Implementation details
 ----------------------
 
--- a/mm/kasan/hw_tags.c~mm-kasan-move-kasanfault-to-mm-kasan-reportc
+++ a/mm/kasan/hw_tags.c
@@ -37,16 +37,9 @@ enum kasan_arg_stacktrace {
 	KASAN_ARG_STACKTRACE_ON,
 };
 
-enum kasan_arg_fault {
-	KASAN_ARG_FAULT_DEFAULT,
-	KASAN_ARG_FAULT_REPORT,
-	KASAN_ARG_FAULT_PANIC,
-};
-
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_stacktrace kasan_arg_stacktrace __ro_after_init;
-static enum kasan_arg_fault kasan_arg_fault __ro_after_init;
 
 /* Whether KASAN is enabled at all. */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
@@ -59,9 +52,6 @@ EXPORT_SYMBOL_GPL(kasan_flag_async);
 /* Whether to collect alloc/free stack traces. */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
 
-/* Whether to panic or print a report and disable tag checking on fault. */
-bool kasan_flag_panic __ro_after_init;
-
 /* kasan=off/on */
 static int __init early_kasan_flag(char *arg)
 {
@@ -113,23 +103,6 @@ static int __init early_kasan_flag_stack
 }
 early_param("kasan.stacktrace", early_kasan_flag_stacktrace);
 
-/* kasan.fault=report/panic */
-static int __init early_kasan_fault(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcmp(arg, "report"))
-		kasan_arg_fault = KASAN_ARG_FAULT_REPORT;
-	else if (!strcmp(arg, "panic"))
-		kasan_arg_fault = KASAN_ARG_FAULT_PANIC;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-early_param("kasan.fault", early_kasan_fault);
-
 /* kasan_init_hw_tags_cpu() is called for each CPU. */
 void kasan_init_hw_tags_cpu(void)
 {
@@ -197,22 +170,6 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
-	switch (kasan_arg_fault) {
-	case KASAN_ARG_FAULT_DEFAULT:
-		/*
-		 * Default to no panic on report.
-		 * Do nothing, kasan_flag_panic keeps its default value.
-		 */
-		break;
-	case KASAN_ARG_FAULT_REPORT:
-		/* Do nothing, kasan_flag_panic keeps its default value. */
-		break;
-	case KASAN_ARG_FAULT_PANIC:
-		/* Enable panic on report. */
-		kasan_flag_panic = true;
-		break;
-	}
-
 	pr_info("KernelAddressSanitizer initialized\n");
 }
 
--- a/mm/kasan/kasan.h~mm-kasan-move-kasanfault-to-mm-kasan-reportc
+++ a/mm/kasan/kasan.h
@@ -37,7 +37,6 @@ static inline bool kasan_async_mode_enab
 
 #endif
 
-extern bool kasan_flag_panic __ro_after_init;
 extern bool kasan_flag_async __ro_after_init;
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
--- a/mm/kasan/report.c~mm-kasan-move-kasanfault-to-mm-kasan-reportc
+++ a/mm/kasan/report.c
@@ -39,6 +39,31 @@ static unsigned long kasan_flags;
 #define KASAN_BIT_REPORTED	0
 #define KASAN_BIT_MULTI_SHOT	1
 
+enum kasan_arg_fault {
+	KASAN_ARG_FAULT_DEFAULT,
+	KASAN_ARG_FAULT_REPORT,
+	KASAN_ARG_FAULT_PANIC,
+};
+
+static enum kasan_arg_fault kasan_arg_fault __ro_after_init = KASAN_ARG_FAULT_DEFAULT;
+
+/* kasan.fault=report/panic */
+static int __init early_kasan_fault(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "report"))
+		kasan_arg_fault = KASAN_ARG_FAULT_REPORT;
+	else if (!strcmp(arg, "panic"))
+		kasan_arg_fault = KASAN_ARG_FAULT_PANIC;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.fault", early_kasan_fault);
+
 bool kasan_save_enable_multi_shot(void)
 {
 	return test_and_set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
@@ -102,10 +127,8 @@ static void end_report(unsigned long *fl
 		panic_on_warn = 0;
 		panic("panic_on_warn set ...\n");
 	}
-#ifdef CONFIG_KASAN_HW_TAGS
-	if (kasan_flag_panic)
+	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
-#endif
 	kasan_enable_current();
 }
 
_

Patches currently in -mm which might be from woodylin@google.com are


