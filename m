Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9202CC678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjCCFzf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCCFzd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD0736082
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:54:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A477A61732
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077A9C4339C;
        Fri,  3 Mar 2023 05:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822897;
        bh=h8bLh199FagsS3ruVOeu8AOMsNpwg08rL3We2gqT/Xk=;
        h=Date:To:From:Subject:From;
        b=wpHNjkxBSuxfyVUN7gFkmebleuIbIy4LgEelwsyLJhKHBN1xeF1L4OycJjAmKR5Jg
         Oq26JJA1inqAnY5PPwme07WE+pzdhVziPvKYgmekdQp/h3Jcq85O5Wi36oA6KmuNtp
         yTf0l5vyh/lxUHfQuIEayh/V9LSG7NZxrwRFkXlo=
Date:   Thu, 02 Mar 2023 21:54:56 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mpe@ellerman.id.au, mingo@redhat.com,
        lkft@linaro.org, keescook@chromium.org, jakub@redhat.com,
        glider@google.com, dvyukov@google.com, dave.hansen@linux.intel.com,
        bp@alien8.de, andreyknvl@gmail.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files.patch removed from -mm tree
Message-Id: <20230303055457.077A9C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: treat meminstrinsic as builtins in uninstrumented files
has been removed from the -mm tree.  Its filename was
     kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: treat meminstrinsic as builtins in uninstrumented files
Date: Fri, 24 Feb 2023 09:59:40 +0100

Where the compiler instruments meminstrinsics by generating calls to
__asan/__hwasan_ prefixed functions, let the compiler consider
memintrinsics as builtin again.

To do so, never override memset/memmove/memcpy if the compiler does the
correct instrumentation - even on !GENERIC_ENTRY architectures.

[elver@google.com: powerpc: don't rename memintrinsics if compiler adds prefixes]
  Link: https://lore.kernel.org/all/20230224085942.1791837-1-elver@google.com/ [1]
  Link: https://lkml.kernel.org/r/20230227094726.3833247-1-elver@google.com
Link: https://lkml.kernel.org/r/20230224085942.1791837-2-elver@google.com
Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.kasan~kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files
+++ a/lib/Kconfig.kasan
@@ -49,6 +49,15 @@ menuconfig KASAN
 
 if KASAN
 
+config CC_HAS_KASAN_MEMINTRINSIC_PREFIX
+	def_bool (CC_IS_CLANG && $(cc-option,-fsanitize=kernel-address -mllvm -asan-kernel-mem-intrinsic-prefix=1)) || \
+		 (CC_IS_GCC && $(cc-option,-fsanitize=kernel-address --param asan-kernel-mem-intrinsic-prefix=1))
+	# Don't define it if we don't need it: compilation of the test uses
+	# this variable to decide how the compiler should treat builtins.
+	depends on !KASAN_HW_TAGS
+	help
+	  The compiler is able to prefix memintrinsics with __asan or __hwasan.
+
 choice
 	prompt "KASAN mode"
 	default KASAN_GENERIC
--- a/mm/kasan/shadow.c~kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files
+++ a/mm/kasan/shadow.c
@@ -38,11 +38,14 @@ bool __kasan_check_write(const volatile
 }
 EXPORT_SYMBOL(__kasan_check_write);
 
-#ifndef CONFIG_GENERIC_ENTRY
+#if !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX) && !defined(CONFIG_GENERIC_ENTRY)
 /*
  * CONFIG_GENERIC_ENTRY relies on compiler emitted mem*() calls to not be
  * instrumented. KASAN enabled toolchains should emit __asan_mem*() functions
  * for the sites they want to instrument.
+ *
+ * If we have a compiler that can instrument meminstrinsics, never override
+ * these, so that non-instrumented files can safely consider them as builtins.
  */
 #undef memset
 void *memset(void *addr, int c, size_t len)
--- a/scripts/Makefile.kasan~kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files
+++ a/scripts/Makefile.kasan
@@ -1,5 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0
+
+ifdef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
+# Safe for compiler to generate meminstrinsic calls in uninstrumented files.
+CFLAGS_KASAN_NOSANITIZE :=
+else
+# Don't let compiler generate memintrinsic calls in uninstrumented files
+# because they are instrumented.
 CFLAGS_KASAN_NOSANITIZE := -fno-builtin
+endif
+
 KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
 cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
_

Patches currently in -mm which might be from elver@google.com are


