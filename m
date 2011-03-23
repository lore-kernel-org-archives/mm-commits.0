From: akpm@linux-foundation.org
Subject: [merged] include-linux-compiler-gcch-unify-macro-definitions.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:32 -0700
Message-ID: <201103232042.p2NKg8PN028725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133Ab1CWUyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borislav.petkov@amd.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/compiler-gcc*.h: unify macro definitions
has been removed from the -mm tree.  Its filename was
     include-linux-compiler-gcch-unify-macro-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/compiler-gcc*.h: unify macro definitions
From: Borislav Petkov <borislav.petkov@amd.com>

Unify identical gcc3.x and gcc4.x macros.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h  |    8 ++++++++
 include/linux/compiler-gcc3.h |    8 --------
 include/linux/compiler-gcc4.h |    8 --------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff -puN include/linux/compiler-gcc.h~include-linux-compiler-gcch-unify-macro-definitions include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~include-linux-compiler-gcch-unify-macro-definitions
+++ a/include/linux/compiler-gcc.h
@@ -92,3 +92,11 @@
 #if !defined(__noclone)
 #define __noclone	/* not needed */
 #endif
+
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
+
+#define __always_inline		inline __attribute__((always_inline))
diff -puN include/linux/compiler-gcc3.h~include-linux-compiler-gcch-unify-macro-definitions include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~include-linux-compiler-gcch-unify-macro-definitions
+++ a/include/linux/compiler-gcc3.h
@@ -21,11 +21,3 @@
 #   error "GCOV profiling support for gcc versions below 3.4 not included"
 # endif /* __GNUC_MINOR__ */
 #endif /* CONFIG_GCOV_KERNEL */
-
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
-
-#define __always_inline		inline __attribute__((always_inline))
diff -puN include/linux/compiler-gcc4.h~include-linux-compiler-gcch-unify-macro-definitions include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~include-linux-compiler-gcch-unify-macro-definitions
+++ a/include/linux/compiler-gcc4.h
@@ -12,13 +12,6 @@
 #define __used			__attribute__((__used__))
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
-#define __always_inline		inline __attribute__((always_inline))
-
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
 
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
@@ -53,7 +46,6 @@
 #define __noclone	__attribute__((__noclone__))
 
 #endif
