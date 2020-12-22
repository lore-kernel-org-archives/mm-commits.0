Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3C0C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D13C023139
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgLVUDY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgLVUDY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:03:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A4CB23133;
        Tue, 22 Dec 2020 20:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608667363;
        bh=WNKVRpkZq69N5UEbck7KrA2+8iIlHIEGJXiayP/E030=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZDVJlZjsw1Gdr45ZH6YWl3IMS79zWl55jWI6EmoOZvb53VzdC7UysN0FlKq2x2ZMR
         /eQJexKdxsPpG2H5DAd/B96v8D2FnO+Fkj+55hej3WoWtKzGMCdqVAflJ923cv+vl8
         U3HqIS22KrGEgbXNdlsgR0ejWfHgFqxCUEv1CgcM=
Date:   Tue, 22 Dec 2020 12:02:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 45/60] kasan, arm64: unpoison stack only with
 CONFIG_KASAN_STACK
Message-ID: <20201222200242.WjED4h0iJ%akpm@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: unpoison stack only with CONFIG_KASAN_STACK

There's a config option CONFIG_KASAN_STACK that has to be enabled for
KASAN to use stack instrumentation and perform validity checks for
stack variables.

There's no need to unpoison stack when CONFIG_KASAN_STACK is not enabled.
Only call kasan_unpoison_task_stack[_below]() when CONFIG_KASAN_STACK is
enabled.

Note, that CONFIG_KASAN_STACK is an option that is currently always
defined when CONFIG_KASAN is enabled, and therefore has to be tested
with #if instead of #ifdef.

Link: https://lkml.kernel.org/r/d09dd3f8abb388da397fd11598c5edeaa83fe559.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/If8a891e9fe01ea543e00b576852685afec0887e3
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/sleep.S        |    2 +-
 arch/x86/kernel/acpi/wakeup_64.S |    2 +-
 include/linux/kasan.h            |   10 ++++++----
 mm/kasan/common.c                |    2 ++
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/sleep.S~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/arch/arm64/kernel/sleep.S
@@ -133,7 +133,7 @@ SYM_FUNC_START(_cpu_resume)
 	 */
 	bl	cpu_do_resume
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
 	mov	x0, sp
 	bl	kasan_unpoison_task_stack_below
 #endif
--- a/arch/x86/kernel/acpi/wakeup_64.S~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/arch/x86/kernel/acpi/wakeup_64.S
@@ -112,7 +112,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	movq	pt_regs_r14(%rax), %r14
 	movq	pt_regs_r15(%rax), %r15
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
 	/*
 	 * The suspend path may have poisoned some areas deeper in the stack,
 	 * which we now need to unpoison.
--- a/include/linux/kasan.h~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/include/linux/kasan.h
@@ -77,8 +77,6 @@ static inline void kasan_disable_current
 
 void kasan_unpoison_range(const void *address, size_t size);
 
-void kasan_unpoison_task_stack(struct task_struct *task);
-
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
 
@@ -123,8 +121,6 @@ void kasan_restore_multi_shot(bool enabl
 
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 
-static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
-
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 
@@ -176,6 +172,12 @@ static inline size_t kasan_metadata_size
 
 #endif /* CONFIG_KASAN */
 
+#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+void kasan_unpoison_task_stack(struct task_struct *task);
+#else
+static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
+#endif
+
 #ifdef CONFIG_KASAN_GENERIC
 
 void kasan_cache_shrink(struct kmem_cache *cache);
--- a/mm/kasan/common.c~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/mm/kasan/common.c
@@ -63,6 +63,7 @@ void kasan_unpoison_range(const void *ad
 	unpoison_range(address, size);
 }
 
+#if CONFIG_KASAN_STACK
 static void __kasan_unpoison_stack(struct task_struct *task, const void *sp)
 {
 	void *base = task_stack_page(task);
@@ -89,6 +90,7 @@ asmlinkage void kasan_unpoison_task_stac
 
 	unpoison_range(base, watermark - base);
 }
+#endif /* CONFIG_KASAN_STACK */
 
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
_
