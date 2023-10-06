Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7708E94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjJFTTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbjJFTTJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9BA6
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C49C433C9;
        Fri,  6 Oct 2023 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619947;
        bh=I6VB0xGSjCYDQfBBzSbMSzq07HB+28bK9R1QoTFVOZM=;
        h=Date:To:From:Subject:From;
        b=QTRo0qrxdcD0wAF76n9K6YFPLXvAcssS8UD3jb+c/nikkFBIqJPKIEVgCyRce+PBB
         Snc80pcBF+hK5WTrVk82C9D8PkST8upvpuYZdkKANmL3Wib9H9YD7za58xzlNpQCLy
         3aCmWGAEzPrhK9nMFHfFve1vmDHV61G3u4mqUE/M=
Date:   Fri, 06 Oct 2023 12:19:05 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        david.laight@aculab.com, bvanassche@acm.org, arnd@arndb.de,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-move-__is_constexpr-to-compilerh.patch added to mm-nonmm-unstable branch
Message-Id: <20231006191907.66C49C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: move __is_constexpr() to compiler.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compilerh-move-__is_constexpr-to-compilerh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-move-__is_constexpr-to-compilerh.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: compiler.h: move __is_constexpr() to compiler.h
Date: Thu, 5 Oct 2023 11:39:54 +0000

Prior to f747e6667ebb2 __is_constexpr() was in its only user minmax.h. 
That commit moved it to const.h - but that file just defines ULL(x) and
UL(x) so that constants can be defined for .S and .c files.

So apart from the word 'const' it wasn't really a good location.  Instead
move the definition to compiler.h just before the similar

  is_signed_type() and is_unsigned_type().

This may not be a good long-term home, but the three definitions belong
together.

Link: https://lkml.kernel.org/r/2a6680bbe2e84459816a113730426782@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h       |    8 ++++++++
 include/linux/const.h          |    8 --------
 tools/include/linux/compiler.h |    8 ++++++++
 tools/include/linux/const.h    |    8 --------
 4 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/compiler.h~compilerh-move-__is_constexpr-to-compilerh
+++ a/include/linux/compiler.h
@@ -228,6 +228,14 @@ static inline void *offset_to_ptr(const
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
 /*
+ * This returns a constant expression while determining if an argument is
+ * a constant expression, most importantly without evaluating the argument.
+ * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
+ */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+
+/*
  * Whether 'type' is a signed type or an unsigned type. Supports scalar types,
  * bool and also pointer types.
  */
--- a/include/linux/const.h~compilerh-move-__is_constexpr-to-compilerh
+++ a/include/linux/const.h
@@ -3,12 +3,4 @@
 
 #include <vdso/const.h>
 
-/*
- * This returns a constant expression while determining if an argument is
- * a constant expression, most importantly without evaluating the argument.
- * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
- */
-#define __is_constexpr(x) \
-	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
-
 #endif /* _LINUX_CONST_H */
--- a/tools/include/linux/compiler.h~compilerh-move-__is_constexpr-to-compilerh
+++ a/tools/include/linux/compiler.h
@@ -63,6 +63,14 @@
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/*
+ * This returns a constant expression while determining if an argument is
+ * a constant expression, most importantly without evaluating the argument.
+ * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
+ */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+
 #ifdef __ANDROID__
 /*
  * FIXME: Big hammer to get rid of tons of:
--- a/tools/include/linux/const.h~compilerh-move-__is_constexpr-to-compilerh
+++ a/tools/include/linux/const.h
@@ -3,12 +3,4 @@
 
 #include <vdso/const.h>
 
-/*
- * This returns a constant expression while determining if an argument is
- * a constant expression, most importantly without evaluating the argument.
- * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
- */
-#define __is_constexpr(x) \
-	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
-
 #endif /* _LINUX_CONST_H */
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are

minmax-add-umina-b-and-umaxa-b.patch
minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
compilerh-move-__is_constexpr-to-compilerh.patch

