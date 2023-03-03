Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19129C678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjCCFza (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCCFz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4419301A7
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E5B616F9
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89445C433EF;
        Fri,  3 Mar 2023 05:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822895;
        bh=qh5uMonjBzJPJV83Adb1g9ZY/ZqID/QTwvaBl11g2UQ=;
        h=Date:To:From:Subject:From;
        b=ndtyuVXWNFZIrnhWVZjbdKix5geD+WIGRWdDtMVvAT3TMv1Q2hwcEg7Q1mbJWMjKJ
         CPpzQTnL4/FLgMqXwpNw47DjyQanulfyEPgsx6lKTOk8oGZQBA54Nei6cxiVam4vfo
         9igDk3olXZo/j7VYiFB/+UGuZibILARovjngOc2Q=
Date:   Thu, 02 Mar 2023 21:54:54 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andreyknvl@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-emit-different-calls-for-instrumentable-memintrinsics.patch removed from -mm tree
Message-Id: <20230303055455.89445C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: emit different calls for instrumentable memintrinsics
has been removed from the -mm tree.  Its filename was
     kasan-emit-different-calls-for-instrumentable-memintrinsics.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: emit different calls for instrumentable memintrinsics
Date: Fri, 24 Feb 2023 09:59:39 +0100

Clang 15 provides an option to prefix memcpy/memset/memmove calls with
__asan_/__hwasan_ in instrumented functions:
https://reviews.llvm.org/D122724

GCC will add support in future:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108777

Use it to regain KASAN instrumentation of memcpy/memset/memmove on
architectures that require noinstr to be really free from instrumented
mem*() functions (all GENERIC_ENTRY architectures).

Link: https://lkml.kernel.org/r/20230224085942.1791837-1-elver@google.com
Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: kasan-dev@googlegroups.com
Cc: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org> # build only
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/kasan.h~kasan-emit-different-calls-for-instrumentable-memintrinsics
+++ a/mm/kasan/kasan.h
@@ -666,4 +666,8 @@ void __hwasan_storeN_noabort(unsigned lo
 
 void __hwasan_tag_memory(unsigned long addr, u8 tag, unsigned long size);
 
+void *__hwasan_memset(void *addr, int c, size_t len);
+void *__hwasan_memmove(void *dest, const void *src, size_t len);
+void *__hwasan_memcpy(void *dest, const void *src, size_t len);
+
 #endif /* __MM_KASAN_KASAN_H */
--- a/mm/kasan/shadow.c~kasan-emit-different-calls-for-instrumentable-memintrinsics
+++ a/mm/kasan/shadow.c
@@ -107,6 +107,17 @@ void *__asan_memcpy(void *dest, const vo
 }
 EXPORT_SYMBOL(__asan_memcpy);
 
+#ifdef CONFIG_KASAN_SW_TAGS
+void *__hwasan_memset(void *addr, int c, size_t len) __alias(__asan_memset);
+EXPORT_SYMBOL(__hwasan_memset);
+#ifdef __HAVE_ARCH_MEMMOVE
+void *__hwasan_memmove(void *dest, const void *src, size_t len) __alias(__asan_memmove);
+EXPORT_SYMBOL(__hwasan_memmove);
+#endif
+void *__hwasan_memcpy(void *dest, const void *src, size_t len) __alias(__asan_memcpy);
+EXPORT_SYMBOL(__hwasan_memcpy);
+#endif
+
 void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
 	void *shadow_start, *shadow_end;
--- a/scripts/Makefile.kasan~kasan-emit-different-calls-for-instrumentable-memintrinsics
+++ a/scripts/Makefile.kasan
@@ -38,6 +38,11 @@ endif
 
 CFLAGS_KASAN += $(call cc-param,asan-stack=$(stack_enable))
 
+# Instrument memcpy/memset/memmove calls by using instrumented __asan_mem*()
+# instead. With compilers that don't support this option, compiler-inserted
+# memintrinsics won't be checked by KASAN on GENERIC_ENTRY architectures.
+CFLAGS_KASAN += $(call cc-param,asan-kernel-mem-intrinsic-prefix=1)
+
 endif # CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_SW_TAGS
@@ -54,6 +59,9 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddr
 		$(call cc-param,hwasan-inline-all-checks=0) \
 		$(instrumentation_flags)
 
+# Instrument memcpy/memset/memmove calls by using instrumented __hwasan_mem*().
+CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
+
 endif # CONFIG_KASAN_SW_TAGS
 
 export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE
_

Patches currently in -mm which might be from elver@google.com are


