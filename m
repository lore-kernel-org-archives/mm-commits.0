From: akpm@linux-foundation.org
Subject: [patch 078/115] bug: split BUILD_BUG stuff out into
 <linux/build_bug.h>
Date: Mon, 10 Jul 2017 15:51:07 -0700
Message-ID: <20170710225107.JdbqYi6Rn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbdGJWvJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, jakub.kicinski@netronome.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org

From: Ian Abbott <abbotti@mev.co.uk>
Subject: bug: split BUILD_BUG stuff out into <linux/build_bug.h>

Including <linux/bug.h> pulls in a lot of bloat from <asm/bug.h> and
<asm-generic/bug.h> that is not needed to call the BUILD_BUG() family of
macros.  Split them out into their own header, <linux/build_bug.h>.

Also correct some checkpatch.pl errors for the BUILD_BUG_ON_ZERO() and
BUILD_BUG_ON_NULL() macros by adding parentheses around the bitfield
widths that begin with a minus sign.

Link: http://lkml.kernel.org/r/20170525120316.24473-6-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h       |   74 -------------------------------
 include/linux/build_bug.h |   84 ++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 73 deletions(-)

diff -puN include/linux/bug.h~bug-split-build_bug-stuff-out-into-linux-build_bugh include/linux/bug.h
--- a/include/linux/bug.h~bug-split-build_bug-stuff-out-into-linux-build_bugh
+++ a/include/linux/bug.h
@@ -3,6 +3,7 @@
 
 #include <asm/bug.h>
 #include <linux/compiler.h>
+#include <linux/build_bug.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
@@ -13,82 +14,9 @@ enum bug_trap_type {
 struct pt_regs;
 
 #ifdef __CHECKER__
-#define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
-#define BUILD_BUG_ON_ZERO(e) (0)
-#define BUILD_BUG_ON_NULL(e) ((void *)0)
-#define BUILD_BUG_ON_INVALID(e) (0)
-#define BUILD_BUG_ON_MSG(cond, msg) (0)
-#define BUILD_BUG_ON(condition) (0)
-#define BUILD_BUG() (0)
 #define MAYBE_BUILD_BUG_ON(cond) (0)
 #else /* __CHECKER__ */
 
-/* Force a compilation error if a constant expression is not a power of 2 */
-#define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
-	BUILD_BUG_ON(((n) & ((n) - 1)) != 0)
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
-	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
-
-/*
- * Force a compilation error if condition is true, but also produce a
- * result (of value 0 and type size_t), so the expression can be used
- * e.g. in a structure initializer (or where-ever else comma expressions
- * aren't permitted).
- */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:(-!!(e)); }))
-
-/*
- * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
- * expression but avoids the generation of any code, even if that expression
- * has side-effects.
- */
-#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
-
-/**
- * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
- *		      error message.
- * @condition: the condition which the compiler should know is false.
- *
- * See BUILD_BUG_ON for description.
- */
-#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
-
-/**
- * BUILD_BUG_ON - break compile if a condition is true.
- * @condition: the condition which the compiler should know is false.
- *
- * If you have some code which relies on certain constants being equal, or
- * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
- * detect if someone changes it.
- *
- * The implementation uses gcc's reluctance to create a negative array, but gcc
- * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
- * inline functions).  Luckily, in 4.3 they added the "error" function
- * attribute just for this type of case.  Thus, we use a negative sized array
- * (should always create an error on gcc versions older than 4.4) and then call
- * an undefined function with the error attribute (should always create an
- * error on gcc 4.3 and later).  If for some reason, neither creates a
- * compile-time error, we'll still have a link-time error, which is harder to
- * track down.
- */
-#ifndef __OPTIMIZE__
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-#else
-#define BUILD_BUG_ON(condition) \
-	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
-#endif
-
-/**
- * BUILD_BUG - break compile if used.
- *
- * If you have some code that you expect the compiler to eliminate at
- * build time, you should use BUILD_BUG to detect if it is
- * unexpectedly used.
- */
-#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
-
 #define MAYBE_BUILD_BUG_ON(cond)			\
 	do {						\
 		if (__builtin_constant_p((cond)))       \
diff -puN /dev/null include/linux/build_bug.h
--- /dev/null
+++ a/include/linux/build_bug.h
@@ -0,0 +1,84 @@
+#ifndef _LINUX_BUILD_BUG_H
+#define _LINUX_BUILD_BUG_H
+
+#include <linux/compiler.h>
+
+#ifdef __CHECKER__
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void *)0)
+#define BUILD_BUG_ON_INVALID(e) (0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
+#define BUILD_BUG_ON(condition) (0)
+#define BUILD_BUG() (0)
+#else /* __CHECKER__ */
+
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
+	BUILD_BUG_ON(((n) & ((n) - 1)) != 0)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
+/*
+ * Force a compilation error if condition is true, but also produce a
+ * result (of value 0 and type size_t), so the expression can be used
+ * e.g. in a structure initializer (or where-ever else comma expressions
+ * aren't permitted).
+ */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:(-!!(e)); }))
+
+/*
+ * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
+ * expression but avoids the generation of any code, even if that expression
+ * has side-effects.
+ */
+#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
+
+/**
+ * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
+ *		      error message.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * See BUILD_BUG_ON for description.
+ */
+#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
+
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but gcc
+ * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
+ * inline functions).  Luckily, in 4.3 they added the "error" function
+ * attribute just for this type of case.  Thus, we use a negative sized array
+ * (should always create an error on gcc versions older than 4.4) and then call
+ * an undefined function with the error attribute (should always create an
+ * error on gcc 4.3 and later).  If for some reason, neither creates a
+ * compile-time error, we'll still have a link-time error, which is harder to
+ * track down.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
+#endif
+
+/**
+ * BUILD_BUG - break compile if used.
+ *
+ * If you have some code that you expect the compiler to eliminate at
+ * build time, you should use BUILD_BUG to detect if it is
+ * unexpectedly used.
+ */
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
+
+#endif	/* __CHECKER__ */
+
+#endif	/* _LINUX_BUILD_BUG_H */
_
