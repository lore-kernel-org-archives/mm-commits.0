Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEC0C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A45A208C7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164120;
	bh=TiazR4IGSmBAx0GQjKiwhsouVHA1Ma0qMzhgwuBp1SQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m9HbFSYhEy88JGVt0WXhgn+/Q2tZK0A/pErHuWXjBxcNft4ZRUnf7mnKieguLbXxh
	 hCkpMlmarh61wEUAqh+h3gNdO639rNkw6yc18f3h+Q0EZevbNal04g79EmWWGmsnVj
	 CZoiy2Doj8/HCUnOwkbcFKGYJKCLB1+TsLIqWvMU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgICUPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICUPU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:20 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C8820722;
        Thu,  3 Sep 2020 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164119;
        bh=TiazR4IGSmBAx0GQjKiwhsouVHA1Ma0qMzhgwuBp1SQ=;
        h=Date:From:To:Subject:From;
        b=Qq6Usj0Rm99wsUh1NQurmDocIoiMPKBZNe4cERZ+ESaZLtTH637tiqIFrb8SXTVt/
         dYuO3/Ny1sVYKrLQDpVH1imDvQmDp/oLQuJ9p4Sy0yFquCbhXqQFCC49DFJvYSQ7Ke
         kBKT4Ks+bM/MMeZcsCZ4V1j8YDjHOu9K0mnuP3qU=
Date:   Thu, 03 Sep 2020 13:15:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        natechancellor@gmail.com, miguel.ojeda.sandonis@gmail.com,
        maskray@google.com, masahiroy@kernel.org, keescook@chromium.org,
        elver@google.com, daniel@iogearbox.net, ast@kernel.org,
        andreyknvl@google.com, ndesaulniers@google.com
Subject:  +
 revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch added
 to -mm tree
Message-ID: <20200903201518.JKrRS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kbuild: disable clang's default use of -fmerge-all-constants"
has been added to the -mm tree.  Its filename is
     revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch

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
Subject: Revert "kbuild: disable clang's default use of -fmerge-all-constants"

This reverts commit 87e0d4f0f37fb0c8c4aeeac46fff5e957738df79.

-fno-merge-all-constants has been the default since clang-6; the minimum
supported version of clang in the kernel is clang-10 (10.0.1).

Link: https://lkml.kernel.org/r/20200902225911.209899-3-ndesaulniers@google.com
Link: https://reviews.llvm.org/rL329300.
Link: https://github.com/ClangBuiltLinux/linux/issues/9
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    9 ---------
 1 file changed, 9 deletions(-)

--- a/Makefile~revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants
+++ a/Makefile
@@ -925,15 +925,6 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
-# clang sets -fmerge-all-constants by default as optimization, but this
-# is non-conforming behavior for C and in fact breaks the kernel, so we
-# need to disable it here generally.
-KBUILD_CFLAGS	+= $(call cc-option,-fno-merge-all-constants)
-
-# for gcc -fno-merge-all-constants disables everything, but it is fine
-# to have actual conforming behavior enabled.
-KBUILD_CFLAGS	+= $(call cc-option,-fmerge-constants)
-
 # Make sure -fstack-check isn't enabled (like gentoo apparently did)
 KBUILD_CFLAGS  += $(call cc-option,-fno-stack-check,)
 
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

