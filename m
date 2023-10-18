Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3305CCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjJRVoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344916AbjJRVn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EDA112
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84065C433CB;
        Wed, 18 Oct 2023 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665437;
        bh=pGACIzlBK0HCPApqxMUVi4haxZt30myob7L/KatGrjI=;
        h=Date:To:From:Subject:From;
        b=0eFh2wIVJ1T+rfxm2ErAHlZLcE5PpEhgvBBPIT4b20cm+zFWcoXhY4jELzy9v7gw4
         SvFMWO6XxB+HsZXgnuinbFTMNkOxa8eDHqwsjjbeS5Q3NksVUy0LEtuzq5yk1X67XX
         ikO4UyViHcxvBaK0TfkfzYM/S9RF96YJIPDBp+Ck=
Date:   Wed, 18 Oct 2023 14:43:56 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        david.laight@aculab.com, bvanassche@acm.org, arnd@arndb.de,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compilerh-move-__is_constexpr-to-compilerh.patch removed from -mm tree
Message-Id: <20231018214357.84065C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler.h: move __is_constexpr() to compiler.h
has been removed from the -mm tree.  Its filename was
     compilerh-move-__is_constexpr-to-compilerh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


