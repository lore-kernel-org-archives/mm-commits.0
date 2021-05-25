Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45648C47087
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B44961423
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhEZAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 20:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232155AbhEZAAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 20:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A70996140E;
        Tue, 25 May 2021 23:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621987150;
        bh=DzHDOERvxwEOhRTAa0bfXolwv4cuF9qC8Bx9wgPOuzE=;
        h=Date:From:To:Subject:From;
        b=1qpMwu8bfeHc17QAtYtvUc22qEnJdyzE6Y0JId95ITr4YOao1fXRHcsYdObwcKwoJ
         Dd+2OqK8+hhCuFQ3VuNAj4MWzR1406+uzL81KLsmDYdtBU82/dvamKIENRejZZM+sN
         cTcHbUYYVBDAJzy5E9gzlAxaIdvE9mAc9W2u3oPA=
Date:   Tue, 25 May 2021 16:59:09 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, dvyukov@google.com,
        elver@google.com, keescook@chromium.org,
        luc.vanoostenryck@gmail.com, mark.rutland@arm.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nivedita@alum.mit.edu,
        ojeda@kernel.org, peterz@infradead.org, samitolvanen@google.com,
        will@kernel.org
Subject:  [to-be-updated]
 kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
 removed from -mm tree
Message-ID: <20210525235909.STdFPyxJW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures
has been removed from the -mm tree.  Its filename was
     kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures

Until now no compiler supported an attribute to disable coverage
instrumentation as used by KCOV.

To work around this limitation on x86, noinstr functions have their
coverage instrumentation turned into nops by objtool.  However, this
solution doesn't scale automatically to other architectures, such as
arm64, which are migrating to use the generic entry code.

Clang [1] and GCC [2] have added support for the attribute recently.
[1] https://github.com/llvm/llvm-project/commit/280333021e9550d80f5c1152a34e33e81df1e178
[2] https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=cec4d4a6782c9bd8d071839c50a239c49caca689

Add __no_sanitize_coverage for both compilers, and add it to noinstr.

Link: https://lkml.kernel.org/r/20210525175819.699786-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    6 ++++++
 include/linux/compiler-gcc.h   |    6 ++++++
 include/linux/compiler_types.h |    2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures
+++ a/include/linux/compiler-clang.h
@@ -45,6 +45,12 @@
 #define __no_sanitize_undefined
 #endif
 
+#if defined(CONFIG_KCOV) && CONFIG_CLANG_VERSION >= 130000
+#define __no_sanitize_coverage __attribute__((no_sanitize("coverage")))
+#else
+#define __no_sanitize_coverage
+#endif
+
 /*
  * Not all versions of clang implement the type-generic versions
  * of the builtin overflow checkers. Fortunately, clang implements
--- a/include/linux/compiler-gcc.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures
+++ a/include/linux/compiler-gcc.h
@@ -122,6 +122,12 @@
 #define __no_sanitize_undefined
 #endif
 
+#if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
+#define __no_sanitize_coverage __attribute__((no_sanitize_coverage))
+#else
+#define __no_sanitize_coverage
+#endif
+
 #if GCC_VERSION >= 50100
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
--- a/include/linux/compiler_types.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures
+++ a/include/linux/compiler_types.h
@@ -210,7 +210,7 @@ struct ftrace_likely_data {
 /* Section for code which can't be instrumented at all */
 #define noinstr								\
 	noinline notrace __attribute((__section__(".noinstr.text")))	\
-	__no_kcsan __no_sanitize_address
+	__no_kcsan __no_sanitize_address __no_sanitize_coverage
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from elver@google.com are

kfence-use-task_idle-when-awaiting-allocation.patch
mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
printk-introduce-dump_stack_lvl-fix.patch
kfence-unconditionally-use-unbound-work-queue.patch

