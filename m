From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 105/166] compiler.h: fix error in BUILD_BUG_ON()
 reporting
Date: Mon, 06 Apr 2020 20:09:37 -0700
Message-ID: <20200407030937.QP0WCVcPW%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDJj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:39 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, daniel.santos@pobox.com, joe@perches.com, linux-mm@kvack.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vegard.nossum@oracle.com, yamada.masahiro@socionext.com

From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: compiler.h: fix error in BUILD_BUG_ON() reporting

compiletime_assert() uses __LINE__ to create a unique function name.  This
means that if you have more than one BUILD_BUG_ON() in the same source
line (which can happen if they appear e.g.  in a macro), then the error
message from the compiler might output the wrong condition.

For this source file:

	#include <linux/build_bug.h>

	#define macro() \
		BUILD_BUG_ON(1); \
		BUILD_BUG_ON(0);

	void foo()
	{
		macro();
	}

gcc would output:

./include/linux/compiler.h:350:38: error: call to `__compiletime_assert_9' declared with attribute error: BUILD_BUG_ON failed: 0
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

However, it was not the BUILD_BUG_ON(0) that failed, so it should say 1
instead of 0. With this patch, we use __COUNTER__ instead of __LINE__, so
each BUILD_BUG_ON() gets a different function name and the correct
condition is printed:

./include/linux/compiler.h:350:38: error: call to `__compiletime_assert_0' declared with attribute error: BUILD_BUG_ON failed: 1
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)

Link: http://lkml.kernel.org/r/20200331112637.25047-1-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler.h~compilerh-fix-error-in-build_bug_on-reporting
+++ a/include/linux/compiler.h
@@ -347,7 +347,7 @@ static inline void *offset_to_ptr(const
  * compiler has support to do so.
  */
 #define compiletime_assert(condition, msg) \
-	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
 
 #define compiletime_assert_atomic_type(t)				\
 	compiletime_assert(__native_word(t),				\
_
