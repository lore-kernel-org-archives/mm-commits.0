Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2730C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 21:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiBAVh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:37:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52726 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiBAVhz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 16:37:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D5FC61793
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 21:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA778C340EB;
        Tue,  1 Feb 2022 21:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643751475;
        bh=wxBbnteOScRmENSXJfneVOTKdAxyDxYLHTjVCy/wS58=;
        h=Date:To:From:Subject:From;
        b=eF7V9wRju9rceOc8weKHj/q0wNwMQiHImLMVBvzMOZAJatvCxHvlXccE4q3h6KoAI
         86W2f5A7PpBwnpEOEKpa1EJKvTKqeJ83MtApsxcIzkQkaDXTnnGLAnWvPzNI0wpdQj
         94/35dbsJ5Na22zuEEi/voRmOm8oW5m3tDqNq+Cw=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 13:37:53 -0800
Date:   Tue, 01 Feb 2022 13:37:53 -0800
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, keescook@chromium.org, glider@google.com,
        dvyukov@google.com, arnd@arndb.de, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang.patch added to -mm tree
Message-Id: <20220201213753.BA778C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "ubsan, kcsan: Don't combine sanitizer with kcov on clang"
has been added to the -mm tree.  Its filename is
     revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang.patch

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
Subject: Revert "ubsan, kcsan: Don't combine sanitizer with kcov on clang"

This reverts commit ea91a1d45d19469001a4955583187b0d75915759.

Since df05c0e9496c ("Documentation: Raise the minimum supported version
of LLVM to 11.0.0") the minimum Clang version is now 11.0, which fixed
the UBSAN/KCSAN vs. KCOV incompatibilities.

Link: https://bugs.llvm.org/show_bug.cgi?id=45831
Link: https://lkml.kernel.org/r/YaodyZzu0MTCJcvO@elver.google.com
Link: https://lkml.kernel.org/r/20220128105631.509772-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kcsan |   11 -----------
 lib/Kconfig.ubsan |   12 ------------
 2 files changed, 23 deletions(-)

--- a/lib/Kconfig.kcsan~revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang
+++ a/lib/Kconfig.kcsan
@@ -10,21 +10,10 @@ config HAVE_KCSAN_COMPILER
 	  For the list of compilers that support KCSAN, please see
 	  <file:Documentation/dev-tools/kcsan.rst>.
 
-config KCSAN_KCOV_BROKEN
-	def_bool KCOV && CC_HAS_SANCOV_TRACE_PC
-	depends on CC_IS_CLANG
-	depends on !$(cc-option,-Werror=unused-command-line-argument -fsanitize=thread -fsanitize-coverage=trace-pc)
-	help
-	  Some versions of clang support either KCSAN and KCOV but not the
-	  combination of the two.
-	  See https://bugs.llvm.org/show_bug.cgi?id=45831 for the status
-	  in newer releases.
-
 menuconfig KCSAN
 	bool "KCSAN: dynamic data race detector"
 	depends on HAVE_ARCH_KCSAN && HAVE_KCSAN_COMPILER
 	depends on DEBUG_KERNEL && !KASAN
-	depends on !KCSAN_KCOV_BROKEN
 	select STACKTRACE
 	help
 	  The Kernel Concurrency Sanitizer (KCSAN) is a dynamic
--- a/lib/Kconfig.ubsan~revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang
+++ a/lib/Kconfig.ubsan
@@ -27,16 +27,6 @@ config UBSAN_TRAP
 	  the system. For some system builders this is an acceptable
 	  trade-off.
 
-config UBSAN_KCOV_BROKEN
-	def_bool KCOV && CC_HAS_SANCOV_TRACE_PC
-	depends on CC_IS_CLANG
-	depends on !$(cc-option,-Werror=unused-command-line-argument -fsanitize=bounds -fsanitize-coverage=trace-pc)
-	help
-	  Some versions of clang support either UBSAN or KCOV but not the
-	  combination of the two.
-	  See https://bugs.llvm.org/show_bug.cgi?id=45831 for the status
-	  in newer releases.
-
 config CC_HAS_UBSAN_BOUNDS
 	def_bool $(cc-option,-fsanitize=bounds)
 
@@ -46,7 +36,6 @@ config CC_HAS_UBSAN_ARRAY_BOUNDS
 config UBSAN_BOUNDS
 	bool "Perform array index bounds checking"
 	default UBSAN
-	depends on !UBSAN_KCOV_BROKEN
 	depends on CC_HAS_UBSAN_ARRAY_BOUNDS || CC_HAS_UBSAN_BOUNDS
 	help
 	  This option enables detection of directly indexed out of bounds
@@ -72,7 +61,6 @@ config UBSAN_ARRAY_BOUNDS
 config UBSAN_LOCAL_BOUNDS
 	bool "Perform array local bounds checking"
 	depends on UBSAN_TRAP
-	depends on !UBSAN_KCOV_BROKEN
 	depends on $(cc-option,-fsanitize=local-bounds)
 	help
 	  This option enables -fsanitize=local-bounds which traps when an
_

Patches currently in -mm which might be from elver@google.com are

revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang.patch

