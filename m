Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270F8C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F944611CC
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJGBQS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 21:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhJGBQR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 21:16:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A227061090;
        Thu,  7 Oct 2021 01:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633569265;
        bh=Ccv2qS3tFnh63Io0dRC4CawnY+bf3q7F+pSITbfaoDQ=;
        h=Date:From:To:Subject:From;
        b=fChSXeuN06Z95+nsKmH83qecv6eVQnxbA0CEyx85WvTWqUGTX++yxfK2iDRI+3dMw
         8EJ9IW05FDye3N50ce/gDZWYfxxZZ5WtpAw5G+1UPDegjacU0baAH3xxJ/Y2WbpeTx
         tIzh8bUdvbqzkINvU7C6vzUsWPFgNwuPBdgc4psA=
Date:   Wed, 06 Oct 2021 18:14:24 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [alternative-merged]
 kasan-extend-kasan-mode-kernel-parameter.patch removed from -mm tree
Message-ID: <20211007011424.cNnPlljF2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: extend KASAN mode kernel parameter
has been removed from the -mm tree.  Its filename was
     kasan-extend-kasan-mode-kernel-parameter.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: kasan: extend KASAN mode kernel parameter

Architectures supported by KASAN_HW_TAGS can provide an asymmetric mode of
execution.  On an MTE enabled arm64 hw for example this can be identified
with the asymmetric tagging mode of execution.  In particular, when such a
mode is present, the CPU triggers a fault on a tag mismatch during a load
operation and asynchronously updates a register when a tag mismatch is
detected during a store operation.

Extend the KASAN HW execution mode kernel command line parameter to
support asymmetric mode.

Link: https://lkml.kernel.org/r/20211004202253.27857-6-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Branislav Rankov <branislav.rankov@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    7 +++++--
 lib/test_kasan.c                  |    2 +-
 mm/kasan/hw_tags.c                |   27 ++++++++++++++++++++++-----
 mm/kasan/kasan.h                  |   22 +++++++++++++++++++---
 mm/kasan/report.c                 |    2 +-
 5 files changed, 48 insertions(+), 12 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-extend-kasan-mode-kernel-parameter
+++ a/Documentation/dev-tools/kasan.rst
@@ -194,14 +194,17 @@ additional boot parameters that allow di
 
 - ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
-- ``kasan.mode=sync`` or ``=async`` controls whether KASAN is configured in
-  synchronous or asynchronous mode of execution (default: ``sync``).
+- ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
+  is configured in synchronous, asynchronous or asymmetric mode of
+  execution (default: ``sync``).
   Synchronous mode: a bad access is detected immediately when a tag
   check fault occurs.
   Asynchronous mode: a bad access detection is delayed. When a tag check
   fault occurs, the information is stored in hardware (in the TFSR_EL1
   register for arm64). The kernel periodically checks the hardware and
   only reports tag faults during these checks.
+  Asymmetric mode: a bad access is detected synchronously on reads and
+  asynchronously on writes.
 
 - ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
   traces collection (default: ``on``).
--- a/lib/test_kasan.c~kasan-extend-kasan-mode-kernel-parameter
+++ a/lib/test_kasan.c
@@ -88,7 +88,7 @@ static void kasan_test_exit(struct kunit
  */
 #define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {			\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
-	    !kasan_async_mode_enabled())				\
+	    kasan_sync_fault_possible())				\
 		migrate_disable();					\
 	KUNIT_EXPECT_FALSE(test, READ_ONCE(fail_data.report_found));	\
 	barrier();							\
--- a/mm/kasan/hw_tags.c~kasan-extend-kasan-mode-kernel-parameter
+++ a/mm/kasan/hw_tags.c
@@ -29,6 +29,7 @@ enum kasan_arg_mode {
 	KASAN_ARG_MODE_DEFAULT,
 	KASAN_ARG_MODE_SYNC,
 	KASAN_ARG_MODE_ASYNC,
+	KASAN_ARG_MODE_ASYMM,
 };
 
 enum kasan_arg_stacktrace {
@@ -49,6 +50,10 @@ EXPORT_SYMBOL(kasan_flag_enabled);
 bool kasan_flag_async __ro_after_init;
 EXPORT_SYMBOL_GPL(kasan_flag_async);
 
+/* Whether the asymmetric mode is enabled. */
+bool kasan_flag_asymm __ro_after_init;
+EXPORT_SYMBOL_GPL(kasan_flag_asymm);
+
 /* Whether to collect alloc/free stack traces. */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
 
@@ -69,7 +74,7 @@ static int __init early_kasan_flag(char
 }
 early_param("kasan", early_kasan_flag);
 
-/* kasan.mode=sync/async */
+/* kasan.mode=sync/async/asymm */
 static int __init early_kasan_mode(char *arg)
 {
 	if (!arg)
@@ -79,6 +84,8 @@ static int __init early_kasan_mode(char
 		kasan_arg_mode = KASAN_ARG_MODE_SYNC;
 	else if (!strcmp(arg, "async"))
 		kasan_arg_mode = KASAN_ARG_MODE_ASYNC;
+	else if (!strcmp(arg, "asymm"))
+		kasan_arg_mode = KASAN_ARG_MODE_ASYMM;
 	else
 		return -EINVAL;
 
@@ -116,11 +123,13 @@ void kasan_init_hw_tags_cpu(void)
 		return;
 
 	/*
-	 * Enable async mode only when explicitly requested through
-	 * the command line.
+	 * Enable async or asymm modes only when explicitly requested
+	 * through the command line.
 	 */
 	if (kasan_arg_mode == KASAN_ARG_MODE_ASYNC)
 		hw_enable_tagging_async();
+	else if (kasan_arg_mode == KASAN_ARG_MODE_ASYMM)
+		hw_enable_tagging_asymm();
 	else
 		hw_enable_tagging_sync();
 }
@@ -143,16 +152,24 @@ void __init kasan_init_hw_tags(void)
 	case KASAN_ARG_MODE_DEFAULT:
 		/*
 		 * Default to sync mode.
-		 * Do nothing, kasan_flag_async keeps its default value.
+		 * Do nothing, kasan_flag_async and kasan_flag_asymm keep
+		 * their default values.
 		 */
 		break;
 	case KASAN_ARG_MODE_SYNC:
-		/* Do nothing, kasan_flag_async keeps its default value. */
+		/*
+		 * Do nothing, kasan_flag_async and kasan_flag_asymm keep
+		 * their default values.
+		 */
 		break;
 	case KASAN_ARG_MODE_ASYNC:
 		/* Async mode enabled. */
 		kasan_flag_async = true;
 		break;
+	case KASAN_ARG_MODE_ASYMM:
+		/* Asymm mode enabled. */
+		kasan_flag_asymm = true;
+		break;
 	}
 
 	switch (kasan_arg_stacktrace) {
--- a/mm/kasan/kasan.h~kasan-extend-kasan-mode-kernel-parameter
+++ a/mm/kasan/kasan.h
@@ -14,15 +14,21 @@
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
 extern bool kasan_flag_async __ro_after_init;
+extern bool kasan_flag_asymm __ro_after_init;
 
 static inline bool kasan_stack_collection_enabled(void)
 {
 	return static_branch_unlikely(&kasan_flag_stacktrace);
 }
 
-static inline bool kasan_async_mode_enabled(void)
+static inline bool kasan_async_fault_possible(void)
 {
-	return kasan_flag_async;
+	return kasan_flag_async | kasan_flag_asymm;
+}
+
+static inline bool kasan_sync_fault_possible(void)
+{
+	return !kasan_flag_async | kasan_flag_asymm;
 }
 #else
 
@@ -31,11 +37,16 @@ static inline bool kasan_stack_collectio
 	return true;
 }
 
-static inline bool kasan_async_mode_enabled(void)
+static inline bool kasan_async_fault_possible(void)
 {
 	return false;
 }
 
+static inline bool kasan_sync_fault_possible(void)
+{
+	return true;
+}
+
 #endif
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
@@ -287,6 +298,9 @@ static inline const void *arch_kasan_set
 #ifndef arch_enable_tagging_async
 #define arch_enable_tagging_async()
 #endif
+#ifndef arch_enable_tagging_asymm
+#define arch_enable_tagging_asymm()
+#endif
 #ifndef arch_force_async_tag_fault
 #define arch_force_async_tag_fault()
 #endif
@@ -302,6 +316,7 @@ static inline const void *arch_kasan_set
 
 #define hw_enable_tagging_sync()		arch_enable_tagging_sync()
 #define hw_enable_tagging_async()		arch_enable_tagging_async()
+#define hw_enable_tagging_asymm()		arch_enable_tagging_asymm()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
@@ -312,6 +327,7 @@ static inline const void *arch_kasan_set
 
 #define hw_enable_tagging_sync()
 #define hw_enable_tagging_async()
+#define hw_enable_tagging_asymm()
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
--- a/mm/kasan/report.c~kasan-extend-kasan-mode-kernel-parameter
+++ a/mm/kasan/report.c
@@ -112,7 +112,7 @@ static void start_report(unsigned long *
 
 static void end_report(unsigned long *flags, unsigned long addr)
 {
-	if (!kasan_async_mode_enabled())
+	if (!kasan_async_fault_possible())
 		trace_error_report_end(ERROR_DETECTOR_KASAN, addr);
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are


