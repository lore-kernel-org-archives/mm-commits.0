Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA96BC04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjHLWGF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjHLWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8731BD8
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5BCC61046
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8F4C433C8;
        Sat, 12 Aug 2023 22:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877945;
        bh=MaWKFUEtKV1PH/HHS/yrlsefbW56Erc5kc0jq+sJ8v0=;
        h=Date:To:From:Subject:From;
        b=zxj4qOciXgluJavL2flF4ICpKaN/5TqAWZhRSYu/Y9tKvOGG1xknyUifTOATBB3/n
         IMnLsY/OzTd/gyI4l21ayIp+V58usalwG0vUiXQroDFxOisTOh6NwpaKUBBbAR3zgz
         sdC4xTyj7pdCWxjWdGBhqh2Iyl7xhRYkQRpR+FFY=
Date:   Sat, 12 Aug 2023 15:05:44 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org, keescook@chromium.org,
        jkl820.git@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arch-enable-has_lto_clang-with-kasan-and-kcov.patch removed from -mm tree
Message-Id: <20230812220545.0A8F4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arch: enable HAS_LTO_CLANG with KASAN and KCOV
has been removed from the -mm tree.  Its filename was
     arch-enable-has_lto_clang-with-kasan-and-kcov.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakob Koschel <jkl820.git@gmail.com>
Subject: arch: enable HAS_LTO_CLANG with KASAN and KCOV
Date: Wed, 19 Jul 2023 00:29:12 +0200

Both KASAN and KCOV had issues with LTO_CLANG if DEBUG_INFO is enabled. 
With LTO inlinable function calls are required to have debug info if they
are inlined into a function that has debug info.

Starting with LLVM 17 this will be fixed ([1],[2]) and enabling LTO with
KASAN/KCOV and DEBUG_INFO doesn't cause linker errors anymore.

Link: https://github.com/llvm/llvm-project/commit/913f7e93dac67ecff47bade862ba42f27cb68ca9
Link: https://github.com/llvm/llvm-project/commit/4a8b1249306ff11f229320abdeadf0c215a00400
Link: https://lkml.kernel.org/r/20230717-enable-kasan-lto1-v3-1-650e1efc19d1@gmail.com
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/Kconfig~arch-enable-has_lto_clang-with-kasan-and-kcov
+++ a/arch/Kconfig
@@ -732,7 +732,9 @@ config HAS_LTO_CLANG
 	depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
 	depends on ARCH_SUPPORTS_LTO_CLANG
 	depends on !FTRACE_MCOUNT_USE_RECORDMCOUNT
-	depends on !KASAN || KASAN_HW_TAGS
+	# https://github.com/ClangBuiltLinux/linux/issues/1721
+	depends on (!KASAN || KASAN_HW_TAGS || CLANG_VERSION >= 170000) || !DEBUG_INFO
+	depends on (!KCOV || CLANG_VERSION >= 170000) || !DEBUG_INFO
 	depends on !GCOV_KERNEL
 	help
 	  The compiler and Kconfig options support building with Clang's
_

Patches currently in -mm which might be from jkl820.git@gmail.com are


