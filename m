From: akpm@linux-foundation.org
Subject: [merged] bugh-make-build_bug_on-generate-compile-time-error.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:23 -0800
Message-ID: <20130222203723.EC4395A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:50870 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3BVUhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:25 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so103020vea.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bug.h: make BUILD_BUG_ON generate compile-time error
has been removed from the -mm tree.  Its filename was
     bugh-make-build_bug_on-generate-compile-time-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: bug.h: make BUILD_BUG_ON generate compile-time error

Negative sized arrays wont create a compile-time error in some cases
starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
the error function attribute that will.  This patch modifies BUILD_BUG_ON
to behave like BUILD_BUG already does, using the error function attribute
so that you don't have to build the entire kernel to discover that you
have a problem, and then enjoy trying to track it down from a link-time
error.

Also, we are only including asm/bug.h and then expecting that
linux/compiler.h will eventually be included to define __linktime_error
(used in BUILD_BUG_ON).  This patch includes it directly for clarity and
to avoid the possibility of changes in <arch>/*/include/asm/bug.h being
changed or not including linux/compiler.h for some reason.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN include/linux/bug.h~bugh-make-build_bug_on-generate-compile-time-error include/linux/bug.h
--- a/include/linux/bug.h~bugh-make-build_bug_on-generate-compile-time-error
+++ a/include/linux/bug.h
@@ -2,6 +2,7 @@
 #define _LINUX_BUG_H
 
 #include <asm/bug.h>
+#include <linux/compiler.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
@@ -43,25 +44,30 @@ struct pt_regs;
  * @condition: the condition which the compiler should know is false.
  *
  * If you have some code which relies on certain constants being equal, or
- * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
  * detect if someone changes it.
  *
- * The implementation uses gcc's reluctance to create a negative array, but
- * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
- * to inline functions).  So as a fallback we use the optimizer; if it can't
- * prove the condition is false, it will cause a link error on the undefined
- * "__build_bug_on_failed".  This error message can be harder to track down
- * though, hence the two different methods.
+ * The implementation uses gcc's reluctance to create a negative array, but gcc
+ * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
+ * inline functions).  Luckily, in 4.3 they added the "error" function
+ * attribute just for this type of case.  Thus, we use a negative sized array
+ * (should always create an error on gcc versions older than 4.4) and then call
+ * an undefined function with the error attribute (should always create an
+ * error on gcc 4.3 and later).  If for some reason, neither creates a
+ * compile-time error, we'll still have a link-time error, which is harder to
+ * track down.
  */
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #else
-extern int __build_bug_on_failed;
-#define BUILD_BUG_ON(condition)					\
-	do {							\
-		bool __cond = !!(condition);			\
-		((void)sizeof(char[1 - 2 * __cond]));		\
-		if (__cond) __build_bug_on_failed = 1;		\
+#define BUILD_BUG_ON(condition)						\
+	do {								\
+		bool __cond = !!(condition);				\
+		extern void __build_bug_on_failed(void)			\
+			__compiletime_error("BUILD_BUG_ON failed");	\
+		if (__cond)						\
+			__build_bug_on_failed();			\
+		((void)sizeof(char[1 - 2 * __cond]));			\
 	} while (0)
 #endif
 
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch

