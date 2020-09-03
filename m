Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD077C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A805D208C7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164118;
	bh=m3hvs0hsTt0nUCE2cbntFzrPYzeVb05S6KYmov+EADc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WQ5L5/sJ6ORtAo6x2FMIbKGvp2saFv3ymbDF7s1LRraom97fG9iWIBENdI7NLbFtk
	 ZbEuUZrTbm6Wp6Y51P1okLK7IeG/iRe2HjE/Heswk/WzME+lQsFyW2lS3hjtx2xngm
	 l85soTsmIx9KtbLL81VXfKo8QIvVMPOQR+KYoq20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgICUPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICUPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:18 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89D12071B;
        Thu,  3 Sep 2020 20:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164117;
        bh=m3hvs0hsTt0nUCE2cbntFzrPYzeVb05S6KYmov+EADc=;
        h=Date:From:To:Subject:From;
        b=YXji/xch4bFsOnvRCe2QIO6YXzaqTb+jHy3F0E/DU1SyXFdJ6YVUNh6IbCuX3nGQ/
         UKfnZ1zg4tnvL1pGeFlee7yWf0LTLnnUPkghaFu6uSbCk+5RBEiqjR+ExKltSJt24M
         dlBGiLkrW1cWejSaQDZyreUiDqqQYvCDhMa90tuo=
Date:   Thu, 03 Sep 2020 13:15:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        natechancellor@gmail.com, miguel.ojeda.sandonis@gmail.com,
        maskray@google.com, masahiroy@kernel.org, keescook@chromium.org,
        elver@google.com, daniel@iogearbox.net, ast@kernel.org,
        andreyknvl@google.com, ndesaulniers@google.com
Subject:  + compiler-clang-add-build-check-for-clang-1001.patch added
 to -mm tree
Message-ID: <20200903201516.n_aM3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-clang: add build check for clang 10.0.1
has been added to the -mm tree.  Its filename is
     compiler-clang-add-build-check-for-clang-1001.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-clang-add-build-check-for-clang-1001.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-clang-add-build-check-for-clang-1001.patch

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
Subject: compiler-clang: add build check for clang 10.0.1

Patch series "set clang minimum version to 10.0.1", v3.

Adds a compile time #error to compiler-clang.h setting the effective
minimum supported version to clang 10.0.1.  A separate patch has already
been picked up into the Documentation/ tree also confirming the version.

Next are a series of reverts. One for 32b arm is a partial revert.

Then Marco suggested fixes to KASAN docs.

Finally, improve the warning for GCC too as per Kees.


This patch (of 7):

During Plumbers 2020, we voted to just support the latest release of Clang
for now.  Add a compile time check for this.

We plan to remove workarounds for older versions now, which will break in
subtle and not so subtle ways.

Link: https://lkml.kernel.org/r/20200902225911.209899-1-ndesaulniers@google.com
Link: https://lkml.kernel.org/r/20200902225911.209899-2-ndesaulniers@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/9
Link: https://github.com/ClangBuiltLinux/linux/issues/941
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/compiler-clang.h~compiler-clang-add-build-check-for-clang-1001
+++ a/include/linux/compiler-clang.h
@@ -3,6 +3,14 @@
 #error "Please don't include <linux/compiler-clang.h> directly, include <linux/compiler.h> instead."
 #endif
 
+#define CLANG_VERSION (__clang_major__ * 10000	\
+		     + __clang_minor__ * 100	\
+		     + __clang_patchlevel__)
+
+#if CLANG_VERSION < 100001
+# error Sorry, your version of Clang is too old - please use 10.0.1 or newer.
+#endif
+
 /* Compiler specific definitions for Clang compiler */
 
 /* same as gcc, this was present in clang-2.6 so we can assume it works
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

