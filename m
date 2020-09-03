Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA78C2BC0E
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 650A920BED
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164126;
	bh=oPLU6JNIFSJkbFOOnyN4GHqKTcL5v5LxyNk13dlYWdU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VSlqSgpN1Gr1j5V7V41Dhz5IBJDiAWkx6DTjSeh32JDxYyjqupiZN1eFTjLWek2Al
	 AzdsvYr3mCeYVDSWMO9m5E8jVuQMKC4R/FQqCyNOz/JhiWUN+fxK6nVWzZ6tug9bHg
	 U9pde/u913jXA0B1fLcbTUI3WB5Zdcay85z4MAlI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgICUP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgICUP0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:26 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF74A208FE;
        Thu,  3 Sep 2020 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164125;
        bh=oPLU6JNIFSJkbFOOnyN4GHqKTcL5v5LxyNk13dlYWdU=;
        h=Date:From:To:Subject:From;
        b=W4OVtGqquMXbu8oZh9xCvwMghgQNOntWJoiNotnoT+HBgkBu6n9T5LLX951xOZeTM
         A7h+tSyeJzSM4hufQkbgz8uj7Tf/jOc8N0LVaKAbYf8bzT1cZRRJMA3i3JPAyr2xKJ
         PYaF5uZBJ3tpAYjmKr2S7/eiZO3a+WEQA0WLhEUw=
Date:   Thu, 03 Sep 2020 13:15:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        natechancellor@gmail.com, miguel.ojeda.sandonis@gmail.com,
        maskray@google.com, masahiroy@kernel.org, keescook@chromium.org,
        elver@google.com, daniel@iogearbox.net, ast@kernel.org,
        andreyknvl@google.com, ndesaulniers@google.com
Subject:  +
 =?us-ascii?Q?partially-revert-arm-8905-1-emit-=5F=5Fgnu=5Fmcount=5Fnc-?=
 =?us-ascii?Q?when-using-clang-1000-or-newer.patch?= added to -mm tree
Message-ID: <20200903201524.sReq6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Partially revert "ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer"
has been added to the -mm tree.  Its filename is
     partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Partially revert "ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer"

This partially reverts commit b0fe66cf095016e0b238374c10ae366e1f087d11.

The minimum supported version of clang is now clang 10.0.1. We still
want to pass -meabi=gnu.

Link: https://lkml.kernel.org/r/20200902225911.209899-6-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig~partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer
+++ a/arch/arm/Kconfig
@@ -83,7 +83,7 @@ config ARM
 	select HAVE_FAST_GUP if ARM_LPAE
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
-	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && (CC_IS_GCC || CLANG_VERSION >= 100000)
+	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7)
 	select HAVE_IDE if PCI || ISA || PCMCIA
_

Patches currently in -mm which might be from ndesaulniers@google.com are

maintainers-add-llvm-maintainers.patch
lib-stringc-implement-stpcpy.patch
compiler-clang-add-build-check-for-clang-1001.patch
revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch
revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch
partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch
compiler-gcc-improve-version-error.patch

