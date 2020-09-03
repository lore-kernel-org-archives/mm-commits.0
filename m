Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CCBC2D0A5
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 983BF206C0
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599164129;
	bh=zmzJV1e25Qmj1B5CFFKZbxNm49t5/z+gPxQoYsMkl+A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ltgGx3WACMGiG7UXOKw0Iit06CZwJvcfuFfSwrK5rlR/MUYBWLsVc0PC7fy4ooXiF
	 mFJhVDnqcJuLP92nMp3bB1sEBfeRPUenYKMa0oC3sd2/LG3ZIGNW3AUfsiZmB35OWh
	 tT++xW3SoiVanMhY8eF+3w+jgSDi1ycgsBWO8Gcs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgICUP3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgICUP2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:15:28 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69DA20BED;
        Thu,  3 Sep 2020 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599164127;
        bh=zmzJV1e25Qmj1B5CFFKZbxNm49t5/z+gPxQoYsMkl+A=;
        h=Date:From:To:Subject:From;
        b=ARUu+1yMsE07VIPsBK18iz0Q8wOMbkcD2hiMFkDf01TSHUYyIoIcenkvTzj4xUBm5
         VghIS5vgJuJGzx2eQ8e8KrPJ5yQtG1m5WcwGi8K/0vFlIajDthX8FZsG+8I9UY3Ule
         VHECDkkceQMZdH/l2OtNjSaU55XHaP46QxDZW1Es=
Date:   Thu, 03 Sep 2020 13:15:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sedat.dilek@gmail.com,
        ndesaulniers@google.com, natechancellor@gmail.com,
        miguel.ojeda.sandonis@gmail.com, maskray@google.com,
        masahiroy@kernel.org, keescook@chromium.org, daniel@iogearbox.net,
        ast@kernel.org, andreyknvl@google.com, elver@google.com
Subject:  + kasan-remove-mentions-of-unsupported-clang-versions.patch
 added to -mm tree
Message-ID: <20200903201526.CCLnr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove mentions of unsupported Clang versions
has been added to the -mm tree.  Its filename is
     kasan-remove-mentions-of-unsupported-clang-versions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-mentions-of-unsupported-clang-versions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-mentions-of-unsupported-clang-versions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: remove mentions of unsupported Clang versions

Since the kernel now requires at least Clang 10.0.1, remove any mention of
old Clang versions and simplify the documentation.

Link: https://lkml.kernel.org/r/20200902225911.209899-7-ndesaulniers@google.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    4 ++--
 lib/Kconfig.kasan                 |    9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-remove-mentions-of-unsupported-clang-versions
+++ a/Documentation/dev-tools/kasan.rst
@@ -13,10 +13,10 @@ KASAN uses compile-time instrumentation
 memory access, and therefore requires a compiler version that supports that.
 
 Generic KASAN is supported in both GCC and Clang. With GCC it requires version
-8.3.0 or later. With Clang it requires version 7.0.0 or later, but detection of
+8.3.0 or later. Any supported Clang version is compatible, but detection of
 out-of-bounds accesses for global variables is only supported since Clang 11.
 
-Tag-based KASAN is only supported in Clang and requires version 7.0.0 or later.
+Tag-based KASAN is only supported in Clang.
 
 Currently generic KASAN is supported for the x86_64, arm64, xtensa, s390 and
 riscv architectures, and tag-based KASAN is supported only for arm64.
--- a/lib/Kconfig.kasan~kasan-remove-mentions-of-unsupported-clang-versions
+++ a/lib/Kconfig.kasan
@@ -54,9 +54,9 @@ config KASAN_GENERIC
 	  Enables generic KASAN mode.
 
 	  This mode is supported in both GCC and Clang. With GCC it requires
-	  version 8.3.0 or later. With Clang it requires version 7.0.0 or
-	  later, but detection of out-of-bounds accesses for global variables
-	  is supported only since Clang 11.
+	  version 8.3.0 or later. Any supported Clang version is compatible,
+	  but detection of out-of-bounds accesses for global variables is
+	  supported only since Clang 11.
 
 	  This mode consumes about 1/8th of available memory at kernel start
 	  and introduces an overhead of ~x1.5 for the rest of the allocations.
@@ -78,8 +78,7 @@ config KASAN_SW_TAGS
 	  Enables software tag-based KASAN mode.
 
 	  This mode requires Top Byte Ignore support by the CPU and therefore
-	  is only supported for arm64. This mode requires Clang version 7.0.0
-	  or later.
+	  is only supported for arm64. This mode requires Clang.
 
 	  This mode consumes about 1/16th of available memory at kernel start
 	  and introduces an overhead of ~20% for the rest of the allocations.
_

Patches currently in -mm which might be from elver@google.com are

kasan-remove-mentions-of-unsupported-clang-versions.patch

