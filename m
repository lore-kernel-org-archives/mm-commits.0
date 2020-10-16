Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231F5C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910362087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816638;
	bh=j6U0MSB6fLVvjrkue0RddTVt9C7FtzQIz03zuc8Yhdg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=B3u8x6rZ1JFxIx0UXzg9+lMHtDeJgPXJ1ECcwMT9QMxsP5k7SfC4cf8uLgT16GOJF
	 QJHovkF3hIWY37OZwfurOaBA6zdIuJTkIXhw/qbDAtN1ZWy4o3GhXp7EZrcbckWxPR
	 07kJqOT/ZEkL8vB2HV499yM+En6KvihcuiHvf+3M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404401AbgJPCui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404127AbgJPCui (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2B820897;
        Fri, 16 Oct 2020 02:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816636;
        bh=j6U0MSB6fLVvjrkue0RddTVt9C7FtzQIz03zuc8Yhdg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UfzSM/pgMHZ2Au90Aejga+N1qiW1vjuivb9UZpu3uv+olFasih4gFdGokHWJ3f1r4
         L/k9oeBxI1leNGq6b45uHJklKZdZS/gmL6s9jPrJY3MKeMaxzURvZzPVDU1yM0pTOV
         cIfz/yOJEFbDwbjDXAoFF60/aPV0gCKLVwzyCGXQ=
Date:   Thu, 15 Oct 2020 19:50:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org, arnd@arndb.de,
        dbrazdil@google.com, dvyukov@google.com, elver@google.com,
        georgepope@android.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 153/156] ubsan: introduce
 CONFIG_UBSAN_LOCAL_BOUNDS for Clang
Message-ID: <20201016025035.gAr-CGVi_%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: George Popescu <georgepope@android.com>
Subject: ubsan: introduce CONFIG_UBSAN_LOCAL_BOUNDS for Clang

When the kernel is compiled with Clang, -fsanitize=bounds expands to
-fsanitize=array-bounds and -fsanitize=local-bounds.

Enabling -fsanitize=local-bounds with Clang has the unfortunate
side-effect of inserting traps; this goes back to its original intent,
which was as a hardening and not a debugging feature [1].  The same
feature made its way into -fsanitize=bounds, but the traps remained.  For
that reason, -fsanitize=bounds was split into 'array-bounds' and
'local-bounds' [2].

Since 'local-bounds' doesn't behave like a normal sanitizer, enable it
with Clang only if trapping behaviour was requested by
CONFIG_UBSAN_TRAP=y.

Add the UBSAN_BOUNDS_LOCAL config to Kconfig.ubsan to enable the
'local-bounds' option by default when UBSAN_TRAP is enabled.

[1] http://lists.llvm.org/pipermail/llvm-dev/2012-May/049972.html
[2] http://lists.llvm.org/pipermail/cfe-commits/Week-of-Mon-20131021/091536.html

Link: https://lkml.kernel.org/r/20200922074330.2549523-1-georgepope@google.com
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: David Brazdil <dbrazdil@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: George Popescu <georgepope@android.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   14 ++++++++++++++
 scripts/Makefile.ubsan |   10 +++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.ubsan~ubsan-introducing-config_ubsan_local_bounds-for-clang
+++ a/lib/Kconfig.ubsan
@@ -47,6 +47,20 @@ config UBSAN_BOUNDS
 	  to the {str,mem}*cpy() family of functions (that is addressed
 	  by CONFIG_FORTIFY_SOURCE).
 
+config UBSAN_LOCAL_BOUNDS
+	bool "Perform array local bounds checking"
+	depends on UBSAN_TRAP
+	depends on CC_IS_CLANG
+	depends on !UBSAN_KCOV_BROKEN
+	help
+	  This option enables -fsanitize=local-bounds which traps when an
+	  exception/error is detected. Therefore, it should be enabled only
+	  if trapping is expected.
+	  Enabling this option detects errors due to accesses through a
+	  pointer that is derived from an object of a statically-known size,
+	  where an added offset (which may not be known statically) is
+	  out-of-bounds.
+
 config UBSAN_MISC
 	bool "Enable all other Undefined Behavior sanity checks"
 	default UBSAN
--- a/scripts/Makefile.ubsan~ubsan-introducing-config_ubsan_local_bounds-for-clang
+++ a/scripts/Makefile.ubsan
@@ -4,7 +4,15 @@ ifdef CONFIG_UBSAN_ALIGNMENT
 endif
 
 ifdef CONFIG_UBSAN_BOUNDS
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+      ifdef CONFIG_CC_IS_CLANG
+            CFLAGS_UBSAN += -fsanitize=array-bounds
+      else
+            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+      endif
+endif
+
+ifdef CONFIG_UBSAN_LOCAL_BOUNDS
+      CFLAGS_UBSAN += -fsanitize=local-bounds
 endif
 
 ifdef CONFIG_UBSAN_MISC
_
