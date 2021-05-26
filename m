Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307B4C47082
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B8A260C40
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhEZXdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 19:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234911AbhEZXdX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 19:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ABCB60E09;
        Wed, 26 May 2021 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622071910;
        bh=cV/+iHJfHbzzP6ZR7sB3Pz4763341D+8KtV8JfY9p3A=;
        h=Date:From:To:Subject:From;
        b=dFkyvy6ZAK4Go+enau/4WC17q5jIc4aq8l1LSCshAYAMsa+c7jddtRLSIQFCcuw70
         5il50sjY7Awz3CJspPP/+RBSNNw1iDabwnPGoZwN7lXkbRn4hHvgA3a6ZQKZYaYko4
         aTFzdSnb5Tvyc2b6UsHxVDtvJghlCCFRlddao2Vo=
Date:   Wed, 26 May 2021 16:31:49 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, dvyukov@google.com,
        elver@google.com, keescook@chromium.org,
        luc.vanoostenryck@gmail.com, mark.rutland@arm.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nivedita@alum.mit.edu,
        ojeda@kernel.org, peterz@infradead.org, samitolvanen@google.com,
        will@kernel.org
Subject:  +
 kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
 added to -mm tree
Message-ID: <20210526233149.XuooGrZLS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures
has been added to the -mm tree.  Its filename is
     kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
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
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

