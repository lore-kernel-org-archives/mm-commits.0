Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A079C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D4C61480
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbhGAB7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238569AbhGAB7V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF31761477;
        Thu,  1 Jul 2021 01:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104610;
        bh=tVj8h0/d1Wc7454HiRxxN7FOSqp9osNr9V232lwKMJQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zO1FMPi0Vdq3JJJBlwob3qb52rps/N5wx27Wg0AZM8PkD1C9czcASqoxu0Zgg7Hp0
         fBXxGRiyypD5YJ8Mx9zhz6dqg0aXwTFRoPZqmeeHJGWhdjZjIFOIySJ2lh+/VpaGzB
         8EYJ5fa3cwty7YPjN5fP0dyayvr/jCBDcQDB7MNo=
Date:   Wed, 30 Jun 2021 18:56:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
        dvyukov@google.com, elver@google.com, keescook@chromium.org,
        linux-mm@kvack.org, luc.vanoostenryck@gmail.com,
        mark.rutland@arm.com, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, nivedita@alum.mit.edu, ojeda@kernel.org,
        peterz@infradead.org, samitolvanen@google.com,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 183/192] kcov: add __no_sanitize_coverage to fix
 noinstr for all architectures
Message-ID: <20210701015649.5yaBp3d6B%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
The changes will appear in Clang 13 and GCC 12.

Add __no_sanitize_coverage for both compilers, and add it to noinstr.

Note: In the Clang case, __has_feature(coverage_sanitizer) is only true if
the feature is enabled, and therefore we do not require an additional
defined(CONFIG_KCOV) (like in the GCC case where __has_attribute(..) is
always true) to avoid adding redundant attributes to functions if KCOV is
off.  That being said, compilers that support the attribute will not
generate errors/warnings if the attribute is redundantly used; however,
where possible let's avoid it as it reduces preprocessed code size and
associated compile-time overheads.

[elver@google.com: Implement __has_feature(coverage_sanitizer) in Clang]
  Link: https://lkml.kernel.org/r/20210527162655.3246381-1-elver@google.com
[elver@google.com: add comment explaining __has_feature() in Clang]
  Link: https://lkml.kernel.org/r/20210527194448.3470080-1-elver@google.com
Link: https://lkml.kernel.org/r/20210525175819.699786-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
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

 include/linux/compiler-clang.h |   17 +++++++++++++++++
 include/linux/compiler-gcc.h   |    6 ++++++
 include/linux/compiler_types.h |    2 +-
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures
+++ a/include/linux/compiler-clang.h
@@ -13,6 +13,12 @@
 /* all clang versions usable with the kernel support KASAN ABI version 5 */
 #define KASAN_ABI_VERSION 5
 
+/*
+ * Note: Checking __has_feature(*_sanitizer) is only true if the feature is
+ * enabled. Therefore it is not required to additionally check defined(CONFIG_*)
+ * to avoid adding redundant attributes in other configurations.
+ */
+
 #if __has_feature(address_sanitizer) || __has_feature(hwaddress_sanitizer)
 /* Emulate GCC's __SANITIZE_ADDRESS__ flag */
 #define __SANITIZE_ADDRESS__
@@ -46,6 +52,17 @@
 #endif
 
 /*
+ * Support for __has_feature(coverage_sanitizer) was added in Clang 13 together
+ * with no_sanitize("coverage"). Prior versions of Clang support coverage
+ * instrumentation, but cannot be queried for support by the preprocessor.
+ */
+#if __has_feature(coverage_sanitizer)
+#define __no_sanitize_coverage __attribute__((no_sanitize("coverage")))
+#else
+#define __no_sanitize_coverage
+#endif
+
+/*
  * Not all versions of clang implement the type-generic versions
  * of the builtin overflow checkers. Fortunately, clang implements
  * __has_builtin allowing us to avoid awkward version
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
