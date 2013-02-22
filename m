From: akpm@linux-foundation.org
Subject: [merged] bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:29 -0800
Message-ID: <20130222203729.E572131C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44103 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3BVUhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:31 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so103731ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bug.h, compiler.h: introduce compiletime_assert & BUILD_BUG_ON_MSG
has been removed from the -mm tree.  Its filename was
     bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: bug.h, compiler.h: introduce compiletime_assert & BUILD_BUG_ON_MSG

Introduce compiletime_assert to compiler.h, which moves the details of how
to break a build and emit an error message for a specific compiler to the
headers where these details should be.  Following in the tradition of the
POSIX assert macro, compiletime_assert creates a build-time error when the
supplied condition is *false*.

Next, we add BUILD_BUG_ON_MSG to bug.h which simply wraps
compiletime_assert, inverting the logic, so that it fails when the
condition is *true*, consistent with the language "build bug on." This
macro allows you to specify the error message you want emitted when the
supplied condition is true.

Finally, we remove all other code from bug.h that mucks with these details
(BUILD_BUG & BUILD_BUG_ON), and have them all call BUILD_BUG_ON_MSG.  This
not only reduces source code bloat, but also prevents the possibility of
code being changed for one macro and not for the other (which was
previously the case for BUILD_BUG and BUILD_BUG_ON).

Since __compiletime_error_fallback is now only used in compiler.h, I'm
considering it a private macro and removing the double negation that's now
extraneous.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h      |   28 +++++++++++++---------------
 include/linux/compiler.h |   26 +++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 16 deletions(-)

diff -puN include/linux/bug.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg include/linux/bug.h
--- a/include/linux/bug.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg
+++ a/include/linux/bug.h
@@ -17,6 +17,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON_INVALID(e) (0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
 #define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
@@ -40,6 +41,15 @@ struct pt_regs;
 #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
 
 /**
+ * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
+ *		      error message.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * See BUILD_BUG_ON for description.
+ */
+#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
+
+/**
  * BUILD_BUG_ON - break compile if a condition is true.
  * @condition: the condition which the compiler should know is false.
  *
@@ -60,15 +70,8 @@ struct pt_regs;
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #else
-#define BUILD_BUG_ON(condition)						\
-	do {								\
-		bool __cond = !!(condition);				\
-		extern void __build_bug_on_failed(void)			\
-			__compiletime_error("BUILD_BUG_ON failed");	\
-		if (__cond)						\
-			__build_bug_on_failed();			\
-		__compiletime_error_fallback(__cond);			\
-	} while (0)
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
 #endif
 
 /**
@@ -78,12 +81,7 @@ struct pt_regs;
  * build time, you should use BUILD_BUG to detect if it is
  * unexpectedly used.
  */
-#define BUILD_BUG()						\
-	do {							\
-		extern void __build_bug_failed(void)		\
-			__compiletime_error("BUILD_BUG failed");\
-		__build_bug_failed();				\
-	} while (0)
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
 
 #endif	/* __CHECKER__ */
 
diff -puN include/linux/compiler.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg include/linux/compiler.h
--- a/include/linux/compiler.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg
+++ a/include/linux/compiler.h
@@ -308,11 +308,35 @@ void ftrace_likely_update(struct ftrace_
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 # define __compiletime_error_fallback(condition) \
-	do { ((void)sizeof(char[1 - 2*!!(condition)])); } while (0)
+	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
 #else
 # define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
+#define __compiletime_assert(condition, msg, prefix, suffix)		\
+	do {								\
+		bool __cond = !(condition);				\
+		extern void prefix ## suffix(void) __compiletime_error(msg); \
+		if (__cond)						\
+			prefix ## suffix();				\
+		__compiletime_error_fallback(__cond);			\
+	} while (0)
+
+#define _compiletime_assert(condition, msg, prefix, suffix) \
+	__compiletime_assert(condition, msg, prefix, suffix)
+
+/**
+ * compiletime_assert - break build and emit msg if condition is false
+ * @condition: a compile-time constant condition to check
+ * @msg:       a message to emit if condition is false
+ *
+ * In tradition of POSIX assert, this macro will break the build if the
+ * supplied condition is *false*, emitting the supplied error message if the
+ * compiler has support to do so.
+ */
+#define compiletime_assert(condition, msg) \
+	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch

