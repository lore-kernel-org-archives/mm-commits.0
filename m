Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEEFE8FDC0
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 23:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbjJCXma (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 19:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237851AbjJCXm3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 19:42:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EBABD
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 16:42:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C03C433C7;
        Tue,  3 Oct 2023 23:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696376545;
        bh=S/aj0FQY6dxf8o4z2azbePLMWPQj9zHswRgqt6anzHY=;
        h=Date:To:From:Subject:From;
        b=vDW6GO5JG1K0fd1I6CQ/DeGf6EYxRAhryhZJvKQFVioCtrbz5KKagLzFWPxm7WvaW
         2FroKOq/SwrmYYG5euxli428Y6Nj3/uymsBhOsfjls8YvLTdbkidaGMEWFFqLtDTPh
         XmjP7t9bDmt9ThWwS5D54arZ8J2ephWKISlguqek=
Date:   Tue, 03 Oct 2023 16:42:24 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        david.laight@aculab.com, bvanassche@acm.org, arnd@arndb.de,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] compilerh-move-__is_constexpr-to-compilerh.patch removed from -mm tree
Message-Id: <20231003234225.15C03C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler.h: move __is_constexpr() to compiler.h
has been removed from the -mm tree.  Its filename was
     compilerh-move-__is_constexpr-to-compilerh.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: compiler.h: move __is_constexpr() to compiler.h
Date: Mon, 2 Oct 2023 14:34:05 +0000

Prior to f747e6667ebb2 __is_constexpr() was in its only user minmax.h. 
That commit moved it to const.h - but that file just defined ULL(x) and
UL(x) so that constants can be defined for .S and .c files.

So apart from the word 'const' it wasn't really a good location.  Instead
move the definition to compiler.h just before the similar

  is_signed_type() and is_unsigned_type().

(Which were moved there by dcf8e5633e2e6) This may not be a good long-term
home, but the three definitions belong together.

This makes it possible to use __is_constexpr() inside is_signed_type() so
that the result is constant integer expression for pointer types.  In
particular (void *)1 isn't constant enough.

Link: https://lkml.kernel.org/r/6d2b584e26544ee6a0810e494352d432@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h    |    8 ++++++++
 include/linux/const.h       |    8 --------
 tools/include/linux/const.h |    8 --------
 3 files changed, 8 insertions(+), 16 deletions(-)

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

