Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70407C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D63464EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhBXUH7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235158AbhBXUHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF8764F1D;
        Wed, 24 Feb 2021 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197168;
        bh=3ZNqSqqDplsX1y/ZFBZgkR9nQAYS0PdFf0g51fPa2Kc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=flb6h3kYcOBSsBOreY0DfbP6KXrRayMoN/qcQQNFeD5klvNxOoNF/g9rmTE53jxhB
         ScawZ4bxs8zRgFoNFGZzG12b6qaH8rLfeLRcGfr1MobQanxn56ZrrUeFtqT10gf4co
         sQBGL33aXU3NI7bKD3lE6lcJ+pGOAAxfgjPk0yLQ=
Date:   Wed, 24 Feb 2021 12:06:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, torvalds@linux-foundation.org,
        walter-zh.wu@mediatek.com
Subject:  [patch 101/173] kasan: remove redundant config option
Message-ID: <20210224200606.fil4kbsxV%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: remove redundant config option

CONFIG_KASAN_STACK and CONFIG_KASAN_STACK_ENABLE both enable KASAN stack
instrumentation, but we should only need one config, so that we remove
CONFIG_KASAN_STACK_ENABLE and make CONFIG_KASAN_STACK workable.  see [1].

When enable KASAN stack instrumentation, then for gcc we could do no
prompt and default value y, and for clang prompt and default value n.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=210221

[walter-zh.wu@mediatek.com: fix remaining the pre-processor syntax]
  Link: https://lkml.kernel.org/r/20210108040940.1138-1-walter-zh.wu@mediatek.com
Link: https://lkml.kernel.org/r/20210107075315.3482-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/sleep.S        |    2 +-
 arch/x86/kernel/acpi/wakeup_64.S |    2 +-
 include/linux/kasan.h            |    2 +-
 lib/Kconfig.kasan                |    8 ++------
 mm/kasan/common.c                |    2 +-
 mm/kasan/kasan.h                 |    2 +-
 mm/kasan/report_generic.c        |    2 +-
 scripts/Makefile.kasan           |   10 ++++++++--
 8 files changed, 16 insertions(+), 14 deletions(-)

--- a/arch/arm64/kernel/sleep.S~kasan-remove-redundant-config-option
+++ a/arch/arm64/kernel/sleep.S
@@ -134,7 +134,7 @@ SYM_FUNC_START(_cpu_resume)
 	 */
 	bl	cpu_do_resume
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 	mov	x0, sp
 	bl	kasan_unpoison_task_stack_below
 #endif
--- a/arch/x86/kernel/acpi/wakeup_64.S~kasan-remove-redundant-config-option
+++ a/arch/x86/kernel/acpi/wakeup_64.S
@@ -115,7 +115,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	movq	pt_regs_r14(%rax), %r14
 	movq	pt_regs_r15(%rax), %r15
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 	/*
 	 * The suspend path may have poisoned some areas deeper in the stack,
 	 * which we now need to unpoison.
--- a/include/linux/kasan.h~kasan-remove-redundant-config-option
+++ a/include/linux/kasan.h
@@ -321,7 +321,7 @@ static inline bool kasan_check_byte(cons
 
 #endif /* CONFIG_KASAN */
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 void kasan_unpoison_task_stack(struct task_struct *task);
 #else
 static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
--- a/lib/Kconfig.kasan~kasan-remove-redundant-config-option
+++ a/lib/Kconfig.kasan
@@ -138,9 +138,10 @@ config KASAN_INLINE
 
 endchoice
 
-config KASAN_STACK_ENABLE
+config KASAN_STACK
 	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
+	default y if CC_IS_GCC
 	help
 	  The LLVM stack address sanitizer has a know problem that
 	  causes excessive stack usage in a lot of functions, see
@@ -154,11 +155,6 @@ config KASAN_STACK_ENABLE
 	  CONFIG_COMPILE_TEST.	On gcc it is assumed to always be safe
 	  to use and enabled by default.
 
-config KASAN_STACK
-	int
-	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
-	default 0
-
 config KASAN_SW_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
 	depends on KASAN_SW_TAGS
--- a/mm/kasan/common.c~kasan-remove-redundant-config-option
+++ a/mm/kasan/common.c
@@ -63,7 +63,7 @@ void __kasan_unpoison_range(const void *
 	kasan_unpoison(address, size);
 }
 
-#if CONFIG_KASAN_STACK
+#ifdef CONFIG_KASAN_STACK
 /* Unpoison the entire stack for a task. */
 void kasan_unpoison_task_stack(struct task_struct *task)
 {
--- a/mm/kasan/kasan.h~kasan-remove-redundant-config-option
+++ a/mm/kasan/kasan.h
@@ -230,7 +230,7 @@ void *kasan_find_first_bad_addr(void *ad
 const char *kasan_get_bug_type(struct kasan_access_info *info);
 void kasan_metadata_fetch_row(char *buffer, void *row);
 
-#if defined(CONFIG_KASAN_GENERIC) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN_GENERIC) && defined(CONFIG_KASAN_STACK)
 void kasan_print_address_stack_frame(const void *addr);
 #else
 static inline void kasan_print_address_stack_frame(const void *addr) { }
--- a/mm/kasan/report_generic.c~kasan-remove-redundant-config-option
+++ a/mm/kasan/report_generic.c
@@ -128,7 +128,7 @@ void kasan_metadata_fetch_row(char *buff
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
 
-#if CONFIG_KASAN_STACK
+#ifdef CONFIG_KASAN_STACK
 static bool __must_check tokenize_frame_descr(const char **frame_descr,
 					      char *token, size_t max_tok_len,
 					      unsigned long *value)
--- a/scripts/Makefile.kasan~kasan-remove-redundant-config-option
+++ a/scripts/Makefile.kasan
@@ -2,6 +2,12 @@
 CFLAGS_KASAN_NOSANITIZE := -fno-builtin
 KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
+ifdef CONFIG_KASAN_STACK
+	stack_enable := 1
+else
+	stack_enable := 0
+endif
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -27,7 +33,7 @@ else
 	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
 	 $(call cc-param,asan-globals=1) \
 	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-stack=$(CONFIG_KASAN_STACK)) \
+	 $(call cc-param,asan-stack=$(stack_enable)) \
 	 $(call cc-param,asan-instrument-allocas=1)
 endif
 
@@ -42,7 +48,7 @@ else
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		-mllvm -hwasan-instrument-stack=$(CONFIG_KASAN_STACK) \
+		-mllvm -hwasan-instrument-stack=$(stack_enable) \
 		-mllvm -hwasan-use-short-granules=0 \
 		$(instrumentation_flags)
 
_
