From: akpm@linux-foundation.org
Subject: [merged] kernelh-add-build_bug-macro.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:54 -0800
Message-ID: <20120111212655.1A5BC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:36671 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab2AKV05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:57 -0500
Received: by wgbdt14 with SMTP id dt14so42866wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.daney@cavium.com, dhowells@redhat.com, dm.n9107@gmail.com, ralf@linux-mips.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: add BUILD_BUG() macro
has been removed from the -mm tree.  Its filename was
     kernelh-add-build_bug-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: kernel.h: add BUILD_BUG() macro

We can place this in definitions that we expect the compiler to remove by
dead code elimination.  If this assertion fails, we get a nice error
message at build time.

The GCC function attribute error("message") was added in version 4.3, so
we define a new macro __linktime_error(message) to expand to this for
GCC-4.3 and later.  This will give us an error diagnostic from the
compiler on the line that fails.  For other compilers
__linktime_error(message) expands to nothing, and we have to be content
with a link time error, but at least we will still get a build error.

BUILD_BUG() expands to the undefined function __build_bug_failed() and
will fail at link time if the compiler ever emits code for it.  On GCC-4.3
and later, attribute((error())) is used so that the failure will be noted
at compile time instead.

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: DM <dm.n9107@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    1 +
 include/linux/compiler.h      |    4 +++-
 include/linux/kernel.h        |   16 ++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc4.h~kernelh-add-build_bug-macro include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~kernelh-add-build_bug-macro
+++ a/include/linux/compiler-gcc4.h
@@ -29,6 +29,7 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
+#define __linktime_error(message) __attribute__((__error__(message)))
 
 #if __GNUC_MINOR__ >= 5
 /*
diff -puN include/linux/compiler.h~kernelh-add-build_bug-macro include/linux/compiler.h
--- a/include/linux/compiler.h~kernelh-add-build_bug-macro
+++ a/include/linux/compiler.h
@@ -293,7 +293,9 @@ void ftrace_likely_update(struct ftrace_
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-
+#ifndef __linktime_error
+# define __linktime_error(message)
+#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
diff -puN include/linux/kernel.h~kernelh-add-build_bug-macro include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-build_bug-macro
+++ a/include/linux/kernel.h
@@ -665,6 +665,7 @@ static inline void ftrace_dump(enum ftra
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
+#define BUILD_BUG() (0)
 #else /* __CHECKER__ */
 
 /* Force a compilation error if a constant expression is not a power of 2 */
@@ -703,6 +704,21 @@ extern int __build_bug_on_failed;
 		if (condition) __build_bug_on_failed = 1;	\
 	} while(0)
 #endif
+
+/**
+ * BUILD_BUG - break compile if used.
+ *
+ * If you have some code that you expect the compiler to eliminate at
+ * build time, you should use BUILD_BUG to detect if it is
+ * unexpectedly used.
+ */
+#define BUILD_BUG()						\
+	do {							\
+		extern void __build_bug_failed(void)		\
+			__linktime_error("BUILD_BUG failed");	\
+		__build_bug_failed();				\
+	} while (0)
+
 #endif	/* __CHECKER__ */
 
 /* Trap pasters of __FUNCTION__ at compile-time */
_

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch

