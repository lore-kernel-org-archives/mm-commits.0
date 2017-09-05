From: akpm@linux-foundation.org
Subject: [merged]
 compiler-dont-perform-compiletime_assert-with-o0.patch removed from -mm
 tree
Date: Tue, 05 Sep 2017 12:51:52 -0700
Message-ID: <20170905195152.KMYIsoFqq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbdIETvx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 15:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, arnd@arndb.de, joe@ovn.org, keescook@chromium.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler.h: don't perform compiletime_assert with -O0
has been removed from the -mm tree.  Its filename was
     compiler-dont-perform-compiletime_assert-with-o0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Stringer <joe@ovn.org>
Subject: include/linux/compiler.h: don't perform compiletime_assert with -O0

c7acec713d14c6c ("kernel.h: handle pointers to arrays better in
container_of()") made use of __compiletime_assert() from container_of()
thus increasing the usage of this macro, allowing developers to notice
type conflicts in usage of container_of() at compile time.

However, the implementation of __compiletime_assert relies on compiler
optimizations to report an error.  This means that if a developer uses
"-O0" with any code that performs container_of(), the compiler will always
report an error regardless of whether there is an actual problem in the
code.

This patch disables compile_time_assert when optimizations are disabled to
allow such code to compile with CFLAGS="-O0".

Example compilation failure:

./include/linux/compiler.h:547:38: error: call to `__compiletime_assert_94' declared with attribute error: pointer type mismatch in container_of()
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
./include/linux/compiler.h:530:4: note: in definition of macro `__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
./include/linux/compiler.h:547:2: note: in expansion of macro `_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:46:37: note: in expansion of macro `compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
./include/linux/kernel.h:860:2: note: in expansion of macro `BUILD_BUG_ON_MSG'
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
  ^~~~~~~~~~~~~~~~

[akpm@linux-foundation.org: use do{}while(0), per Michal]
Link: http://lkml.kernel.org/r/20170829230114.11662-1-joe@ovn.org
Fixes: c7acec713d14c6c ("kernel.h: handle pointers to arrays better in container_of()")
Signed-off-by: Joe Stringer <joe@ovn.org>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler.h~compiler-dont-perform-compiletime_assert-with-o0 include/linux/compiler.h
--- a/include/linux/compiler.h~compiler-dont-perform-compiletime_assert-with-o0
+++ a/include/linux/compiler.h
@@ -517,7 +517,8 @@ static __always_inline void __write_once
 # define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
-#define __compiletime_assert(condition, msg, prefix, suffix)		\
+#ifdef __OPTIMIZE__
+# define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
 		bool __cond = !(condition);				\
 		extern void prefix ## suffix(void) __compiletime_error(msg); \
@@ -525,6 +526,9 @@ static __always_inline void __write_once
 			prefix ## suffix();				\
 		__compiletime_error_fallback(__cond);			\
 	} while (0)
+#else
+# define __compiletime_assert(condition, msg, prefix, suffix) do { } while (0)
+#endif
 
 #define _compiletime_assert(condition, msg, prefix, suffix) \
 	__compiletime_assert(condition, msg, prefix, suffix)
_

Patches currently in -mm which might be from joe@ovn.org are


