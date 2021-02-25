Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DA2C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9752C64F44
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhBYThe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhBYTfW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3EE264E90;
        Thu, 25 Feb 2021 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614281272;
        bh=5Z05go4m5mgOnRBLEG1Taz/sTYai4pDyi+GW7vPtmFk=;
        h=Date:From:To:Subject:From;
        b=d2MLO+kRtjd3hXtEinvQh2ps7daS+kp0M9QUTZJXlSJJDxf0fMmYNsRTReseLl7+x
         qa5POqnvsq1RMkjBLGtAz+ZmryUbs60txJsUftszrAumFrLucFSC8BasVlEmKBkn+0
         gEw0GSXkcxSWqmUJ92TAYQq9rCpKDJCGW5BYaBQo=
Date:   Thu, 25 Feb 2021 11:27:51 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, elver@google.com, keescook@chromium.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nivedita@alum.mit.edu,
        ojeda@kernel.org, rdunlap@infradead.org, samitolvanen@google.com
Subject:  + linux-compiler-clangh-define-have_builtin_bswap.patch
 added to -mm tree
Message-ID: <20210225192751.yv-FYErx1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*
has been added to the -mm tree.  Its filename is
     linux-compiler-clangh-define-have_builtin_bswap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-compiler-clangh-define-have_builtin_bswap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-compiler-clangh-define-have_builtin_bswap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Separating compiler-clang.h from compiler-gcc.h inadventently dropped the
definitions of the three HAVE_BUILTIN_BSWAP macros, which requires falling
back to the open-coded version and hoping that the compiler detects it.

Since all versions of clang support the __builtin_bswap interfaces, add
back the flags and have the headers pick these up automatically.

This results in a 4% improvement of compilation speed for arm defconfig.

Link: https://lkml.kernel.org/r/20210225164513.3667778-1-arnd@kernel.org
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/compiler-clang.h~linux-compiler-clangh-define-have_builtin_bswap
+++ a/include/linux/compiler-clang.h
@@ -31,6 +31,16 @@
 #define __no_sanitize_thread
 #endif
 
+/*
+ * sparse (__CHECKER__) pretends to be gcc, but can't do constant
+ * folding in __builtin_bswap*() (yet), so don't set these for it.
+ */
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP) && !defined(__CHECKER__)
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP && !__CHECKER__ */
+
 #if __has_feature(undefined_behavior_sanitizer)
 /* GCC does not have __SANITIZE_UNDEFINED__ */
 #define __no_sanitize_undefined \
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-compiler-clangh-define-have_builtin_bswap.patch

