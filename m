Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDBFC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E63613BD
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhETUmk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 16:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239251AbhETUmj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 16:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B220E613BB;
        Thu, 20 May 2021 20:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621543278;
        bh=SM5Ku59tbT0neKVAhVrYAXnLlSlisQmIkcyIW6WoVoo=;
        h=Date:From:To:Subject:From;
        b=dpBvakSC0KXnUkC044No0U3X8BpB7u5EZlqJYk1kUIH+bF2icsyrox8hZ1TvYfzN8
         W6yh7EF0LWIQuNmQfhxCqp2yJ/YoIJVtbXWU57hj3BUMLCYivwpjt3vXETMNOtl3NS
         pzgvCWvSuvatGp1YPV4RDZpT/9MnbJZppmC8fNVE=
Date:   Thu, 20 May 2021 13:41:17 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ardb@kernel.org, arnd@arndb.de,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, rikard.falkeborn@gmail.com,
        yury.norov@gmail.com
Subject:  + linux-bitsh-fix-compilation-error-with-genmask.patch
 added to -mm tree
Message-ID: <20210520204117.6eJSl-dWZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/bits.h: fix compilation error with GENMASK
has been added to the -mm tree.  Its filename is
     linux-bitsh-fix-compilation-error-with-genmask.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-bitsh-fix-compilation-error-with-genmask.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-bitsh-fix-compilation-error-with-genmask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: linux/bits.h: fix compilation error with GENMASK

GENMASK() has an input check which uses __builtin_choose_expr() to enable
a compile time sanity check of its inputs if they are known at compile
time.  However, it turns out that __builtin_constant_p() does not always
return a compile time constant [0].  It was thought this problem was fixed
with gcc 4.9 [1], but apparently this is not the case [2].

Switch to use __is_constexpr() instead which always returns a compile time
constant, regardless of its inputs.

[0]: https://lore.kernel.org/lkml/42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk
[1]: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=19449
[2]: https://lore.kernel.org/lkml/1ac7bbc2-45d9-26ed-0b33-bf382b8d858b@I-love.SAKURA.ne.jp

Link: https://lkml.kernel.org/r/20210511203716.117010-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bits.h        |    2 +-
 include/linux/const.h       |    8 ++++++++
 include/linux/minmax.h      |   10 ++--------
 tools/include/linux/bits.h  |    2 +-
 tools/include/linux/const.h |    8 ++++++++
 5 files changed, 20 insertions(+), 10 deletions(-)

--- a/include/linux/bits.h~linux-bitsh-fix-compilation-error-with-genmask
+++ a/include/linux/bits.h
@@ -22,7 +22,7 @@
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
-		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
+		__is_constexpr((l) > (h)), (l) > (h), 0)))
 #else
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
--- a/include/linux/const.h~linux-bitsh-fix-compilation-error-with-genmask
+++ a/include/linux/const.h
@@ -3,4 +3,12 @@
 
 #include <vdso/const.h>
 
+/*
+ * This returns a constant expression while determining if an argument is
+ * a constant expression, most importantly without evaluating the argument.
+ * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
+ */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+
 #endif /* _LINUX_CONST_H */
--- a/include/linux/minmax.h~linux-bitsh-fix-compilation-error-with-genmask
+++ a/include/linux/minmax.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/const.h>
+
 /*
  * min()/max()/clamp() macros must accomplish three things:
  *
@@ -17,14 +19,6 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/*
- * This returns a constant expression while determining if an argument is
- * a constant expression, most importantly without evaluating the argument.
- * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
- */
-#define __is_constexpr(x) \
-	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
-
 #define __no_side_effects(x, y) \
 		(__is_constexpr(x) && __is_constexpr(y))
 
--- a/tools/include/linux/bits.h~linux-bitsh-fix-compilation-error-with-genmask
+++ a/tools/include/linux/bits.h
@@ -22,7 +22,7 @@
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
-		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
+		__is_constexpr((l) > (h)), (l) > (h), 0)))
 #else
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
--- a/tools/include/linux/const.h~linux-bitsh-fix-compilation-error-with-genmask
+++ a/tools/include/linux/const.h
@@ -3,4 +3,12 @@
 
 #include <vdso/const.h>
 
+/*
+ * This returns a constant expression while determining if an argument is
+ * a constant expression, most importantly without evaluating the argument.
+ * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
+ */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+
 #endif /* _LINUX_CONST_H */
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

linux-bitsh-fix-compilation-error-with-genmask.patch

