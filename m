Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF0FC11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 279B761424
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhGABGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238272AbhGABGN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:06:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE31F610A1;
        Thu,  1 Jul 2021 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101423;
        bh=cQKEyOlROZIwtVN+CwgtW296WhORh2PlqE2LOMsqUAw=;
        h=Date:From:To:Subject:From;
        b=Ut+C358cAx+44mIPvatASLspBbYEG2YeQpR9Y5KMnvDTf7lq4mqWQYb5RA8RN+5Tb
         6RjKr5zD20hXS7OpCB0hZnB+zFnBLc5NefrC0XDCcYaKjyLeOc1B+oz+NCU/sAhRtJ
         bBHSwTsvE0lVp/J74Zl9RX90xOGES0tksbvfuHYk=
Date:   Wed, 30 Jun 2021 18:03:42 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, dvyukov@google.com,
        elver@google.com, keescook@chromium.org,
        luc.vanoostenryck@gmail.com, mark.rutland@arm.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nivedita@alum.mit.edu,
        ojeda@kernel.org, peterz@infradead.org, samitolvanen@google.com,
        will@kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?kcov-add-=5F=5Fno=5Fsanitize=5Fcoverage-to-fix-noinstr-fo?=
 =?US-ASCII?Q?r-all-architectures-v2.patch?= removed from -mm tree
Message-ID: <20210701010342.IDHJWrOCC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2
has been removed from the -mm tree.  Its filename was
     kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2.patch

This patch was dropped because it was folded into kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2

Implement __has_feature(coverage_sanitizer) in Clang
(https://reviews.llvm.org/D103159) and use instead of version check.

Link: https://lkml.kernel.org/r/20210527162655.3246381-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2
+++ a/include/linux/compiler-clang.h
@@ -45,7 +45,12 @@
 #define __no_sanitize_undefined
 #endif
 
-#if defined(CONFIG_KCOV) && CONFIG_CLANG_VERSION >= 130000
+/*
+ * Support for __has_feature(coverage_sanitizer) was added in Clang 13 together
+ * with no_sanitize("coverage"). Prior versions of Clang support coverage
+ * instrumentation, but cannot be queried for support by the preprocessor.
+ */
+#if __has_feature(coverage_sanitizer)
 #define __no_sanitize_coverage __attribute__((no_sanitize("coverage")))
 #else
 #define __no_sanitize_coverage
_

Patches currently in -mm which might be from elver@google.com are

kfence-unconditionally-use-unbound-work-queue.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

