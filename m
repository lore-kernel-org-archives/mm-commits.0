Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1091BC2BD11
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B9320BED
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164124;
	bh=XyQRWstUufLVeMfYJzRIjMT/CzJg6hpe3heXjLpZBv8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lXV//V5JTrd57N61D6snSUif/fKSReuWdXeTodmLN+EGNEHftQfVe2RoIXCK2/veb
	 dheVYWCGJvc7kA3YocJCuVh8y3fZjOQK0j0kx6okBujd0RUhnY5TKSXAJPuoVwG2gR
	 bPblQIG9UYEXqEPl2p08wUUD4qchOwpNaN76v42A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgICUPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgICUPY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:24 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B235A208CA;
        Thu,  3 Sep 2020 20:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164123;
        bh=XyQRWstUufLVeMfYJzRIjMT/CzJg6hpe3heXjLpZBv8=;
        h=Date:From:To:Subject:From;
        b=yD8Oy5z9EZQ+XuSOQRVXA16568Jk+pNXdCcsVWAuo46l8VM0X4+No6f6dhMbKcD9M
         FENDpurlW8PhaZ781MUL3wc53VFEslSwfXMZiMZxv8MDXa4psU6elJCerofcTFzZsj
         hXjQDWEJuNzmZlP0krswNzeRuOP9ZJAzZ2dvv4sU=
Date:   Thu, 03 Sep 2020 13:15:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        natechancellor@gmail.com, miguel.ojeda.sandonis@gmail.com,
        maskray@google.com, masahiroy@kernel.org, keescook@chromium.org,
        elver@google.com, daniel@iogearbox.net, ast@kernel.org,
        andreyknvl@google.com, ndesaulniers@google.com
Subject:  +
 revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch added to -mm
 tree
Message-ID: <20200903201522.C0N0G%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "arm64: vdso: Fix compilation with clang older than 8"
has been added to the -mm tree.  Its filename is
     revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch

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
Subject: Revert "arm64: vdso: Fix compilation with clang older than 8"

This reverts commit 3acf4be235280f14d838581a750532219d67facc.

The minimum supported version of clang is clang 10.0.1.

Link: https://lkml.kernel.org/r/20200902225911.209899-5-ndesaulniers@google.com
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

 arch/arm64/kernel/vdso/Makefile |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/arm64/kernel/vdso/Makefile~revert-arm64-vdso-fix-compilation-with-clang-older-than-8
+++ a/arch/arm64/kernel/vdso/Makefile
@@ -43,13 +43,6 @@ ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -include $(c-gettimeofday-y)
 endif
 
-# Clang versions less than 8 do not support -mcmodel=tiny
-ifeq ($(CONFIG_CC_IS_CLANG), y)
-  ifeq ($(shell test $(CONFIG_CLANG_VERSION) -lt 80000; echo $$?),0)
-    CFLAGS_REMOVE_vgettimeofday.o += -mcmodel=tiny
-  endif
-endif
-
 # Disable gcov profiling for VDSO code
 GCOV_PROFILE := n
 
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

