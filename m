Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E513AC2D0A6
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A30206C0
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164131;
	bh=U0hgphvPXN+PEuZqf6MExllm6dlNPYr1UUBI5Ym4DMo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hTD0/okEZMZoQH8Y9lLBIsyiHX3Yews2vlXnCVdJvgPIxONsd05gOvew9h1fv/h4G
	 EFguFkzC/7KwaoyN9m6XFGPbjZErgCIhGct/Ox5vMRUL+Z6USbqmM5bZZmP0Q2DkIk
	 kCCjAHanvuc4o0GCay0AIvU0ij+OOTA7NcLXaNH4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgICUPb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgICUPb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:31 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B942071B;
        Thu,  3 Sep 2020 20:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164130;
        bh=U0hgphvPXN+PEuZqf6MExllm6dlNPYr1UUBI5Ym4DMo=;
        h=Date:From:To:Subject:From;
        b=NPLoQDdj4mIlSsWF1I6ntXHBkj2bQWBHzmX4X/Tdv/0qhc9ic8eHyqP/yHxFAnv+X
         j3LiFWaB0DHXQhBqeAUYGHFeNf08PgqCvQtbp87SeAYSPpcXCXuWR2yBcUKJ2gFzYw
         XE6WAOxW7/FeeglXp7d8EQkMvdQEcvDGp/up4k3s=
Date:   Thu, 03 Sep 2020 13:15:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        natechancellor@gmail.com, miguel.ojeda.sandonis@gmail.com,
        maskray@google.com, masahiroy@kernel.org, keescook@chromium.org,
        elver@google.com, daniel@iogearbox.net, ast@kernel.org,
        andreyknvl@google.com, ndesaulniers@google.com
Subject:  + compiler-gcc-improve-version-error.patch added to -mm
 tree
Message-ID: <20200903201529.JM72w%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc: improve version error
has been added to the -mm tree.  Its filename is
     compiler-gcc-improve-version-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-gcc-improve-version-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-gcc-improve-version-error.patch

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
Subject: compiler-gcc: improve version error

As Kees suggests, doing so provides developers with two useful pieces of
information:
- The kernel build was attempting to use GCC.
  (Maybe they accidentally poked the wrong configs in a CI.)
- They need 4.9 or better.
  ("Upgrade to what version?" doesn't need to be dug out of documentation,
   headers, etc.)

Link: https://lkml.kernel.org/r/20200902225911.209899-8-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-gcc.h~compiler-gcc-improve-version-error
+++ a/include/linux/compiler-gcc.h
@@ -12,7 +12,7 @@
 
 /* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145 */
 #if GCC_VERSION < 40900
-# error Sorry, your compiler is too old - please upgrade it.
+# error Sorry, your version of GCC is too old - please use 4.9 or newer.
 #endif
 
 /* Optimization barrier */
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

