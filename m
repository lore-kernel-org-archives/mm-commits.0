Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA1C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CA2208FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164124;
	bh=s415jrBM/wGppm032s+6i6ourvhXI2A90zptcr9N0Ew=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AmPd8RzDNzovLSTWWk/uV65ZtLNLbyYHBVGqtMEhLL0C3dT/DgNAmL/S8JzOyR00O
	 TuLq8BD+9C6fWfdP/aez2nrc23d4lBX0ypsfMG8p6m0fxv1fXj3ROiwhfHh4he4NJo
	 0Sgc+rr9BEGdJFXm0awQDLL9N3lhZPHywkr9Z2Ig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgICUPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICUPW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:22 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1DD9208C7;
        Thu,  3 Sep 2020 20:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164121;
        bh=s415jrBM/wGppm032s+6i6ourvhXI2A90zptcr9N0Ew=;
        h=Date:From:To:Subject:From;
        b=kusAxT0Mt7z6uP87qPI8ZdDTQWzPWgllVhdWGHv4cq9uw4G2qN6tqWRLsyk/mqezS
         uuOny40yXtQn5VCYxATpl2+tvljiX1TvVPLYK7EIT+4VsZ//z67LWdlys5QVqBqlcP
         oQ/9R8FBm8KLAQwbmL//fzFCo7g9R7fGhbc72T4Y=
Date:   Thu, 03 Sep 2020 13:15:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        natechancellor@gmail.com, miguel.ojeda.sandonis@gmail.com,
        maskray@google.com, masahiroy@kernel.org, keescook@chromium.org,
        elver@google.com, daniel@iogearbox.net, ast@kernel.org,
        andreyknvl@google.com, ndesaulniers@google.com
Subject:  +
 revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch added
 to -mm tree
Message-ID: <20200903201520.Q4nzS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "arm64: bti: Require clang >= 10.0.1 for in-kernel BTI support"
has been added to the -mm tree.  Its filename is
     revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-arm64-bti-require-clang-%3D-1001-for-in-kernel-bti-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-arm64-bti-require-clang-%3D-1001-for-in-kernel-bti-support.patch

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
Subject: Revert "arm64: bti: Require clang >= 10.0.1 for in-kernel BTI support"

This reverts commit b9249cba25a5dce5de87e5404503a5e11832c2dd.

The minimum supported version of clang is now 10.0.1.

Link: https://lkml.kernel.org/r/20200902225911.209899-4-ndesaulniers@google.com
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

 arch/arm64/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/Kconfig~revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support
+++ a/arch/arm64/Kconfig
@@ -1630,8 +1630,6 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
-	# https://reviews.llvm.org/rGb8ae3fdfa579dbf366b1bb1cbfdbf8c51db7fa55
-	depends on !CC_IS_CLANG || CLANG_VERSION >= 100001
 	depends on !(CC_IS_CLANG && GCOV_KERNEL)
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)
 	help
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

