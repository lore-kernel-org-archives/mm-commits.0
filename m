From: akpm@linux-foundation.org
Subject: - compiler-introduce-__used-and-__maybe_unused.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:30 -0700
Message-ID: <200705092154.l49LsUEC003166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759336AbXEIVzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, bunk@stusta.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     compiler: introduce __used and __maybe_unused
has been removed from the -mm tree.  Its filename was
     compiler-introduce-__used-and-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: compiler: introduce __used and __maybe_unused
From: David Rientjes <rientjes@google.com>

__used is defined to be __attribute__((unused)) for all pre-3.3 gcc
compilers to suppress warnings for unused functions because perhaps they
are referenced only in inline assembly.  It is defined to be
__attribute__((used)) for gcc 3.3 and later so that the code is still
emitted for such functions.

__maybe_unused is defined to be __attribute__((unused)) for both function
and variable use if it could possibly be unreferenced due to the evaluation
of preprocessor macros.  Function prototypes shall be marked with
__maybe_unused if the actual definition of the function is dependant on
preprocessor macros.

No update to compiler-intel.h is necessary because ICC supports both
__attribute__((used)) and __attribute__((unused)) as specified by the gcc
manual.

__attribute_used__ is deprecated and will be removed once all current
code is converted to using __used.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h  |    1 +
 include/linux/compiler-gcc3.h |    6 ++++--
 include/linux/compiler-gcc4.h |    3 ++-
 include/linux/compiler.h      |   21 ++++++++++++++++++---
 4 files changed, 25 insertions(+), 6 deletions(-)

diff -puN include/linux/compiler-gcc.h~compiler-introduce-__used-and-__maybe_unused include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-introduce-__used-and-__maybe_unused
+++ a/include/linux/compiler-gcc.h
@@ -40,3 +40,4 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
+#define __maybe_unused			__attribute__((unused))
diff -puN include/linux/compiler-gcc3.h~compiler-introduce-__used-and-__maybe_unused include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~compiler-introduce-__used-and-__maybe_unused
+++ a/include/linux/compiler-gcc3.h
@@ -4,9 +4,11 @@
 #include <linux/compiler-gcc.h>
 
 #if __GNUC_MINOR__ >= 3
-# define __attribute_used__	__attribute__((__used__))
+# define __used			__attribute__((__used__))
+# define __attribute_used__	__used				/* deprecated */
 #else
-# define __attribute_used__	__attribute__((__unused__))
+# define __used			__attribute__((__unused__))
+# define __attribute_used__	__used				/* deprecated */
 #endif
 
 #if __GNUC_MINOR__ >= 4
diff -puN include/linux/compiler-gcc4.h~compiler-introduce-__used-and-__maybe_unused include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-introduce-__used-and-__maybe_unused
+++ a/include/linux/compiler-gcc4.h
@@ -12,7 +12,8 @@
 # define __inline		__inline	__attribute__((always_inline))
 #endif
 
-#define __attribute_used__	__attribute__((__used__))
+#define __used			__attribute__((__used__))
+#define __attribute_used__	__used			/* deprecated */
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 #define __always_inline		inline __attribute__((always_inline))
diff -puN include/linux/compiler.h~compiler-introduce-__used-and-__maybe_unused include/linux/compiler.h
--- a/include/linux/compiler.h~compiler-introduce-__used-and-__maybe_unused
+++ a/include/linux/compiler.h
@@ -108,15 +108,30 @@ extern void __chk_io_ptr(const void __io
  * Allow us to avoid 'defined but not used' warnings on functions and data,
  * as well as force them to be emitted to the assembly file.
  *
- * As of gcc 3.3, static functions that are not marked with attribute((used))
- * may be elided from the assembly file.  As of gcc 3.3, static data not so
+ * As of gcc 3.4, static functions that are not marked with attribute((used))
+ * may be elided from the assembly file.  As of gcc 3.4, static data not so
  * marked will not be elided, but this may change in a future gcc version.
  *
+ * NOTE: Because distributions shipped with a backported unit-at-a-time
+ * compiler in gcc 3.3, we must define __used to be __attribute__((used))
+ * for gcc >=3.3 instead of 3.4.
+ *
  * In prior versions of gcc, such functions and data would be emitted, but
  * would be warned about except with attribute((unused)).
+ *
+ * Mark functions that are referenced only in inline assembly as __used so
+ * the code is emitted even though it appears to be unreferenced.
  */
 #ifndef __attribute_used__
-# define __attribute_used__	/* unimplemented */
+# define __attribute_used__	/* deprecated */
+#endif
+
+#ifndef __used
+# define __used			/* unimplemented */
+#endif
+
+#ifndef __maybe_unused
+# define __maybe_unused		/* unimplemented */
 #endif
 
 /*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
frv-gdb-use-__maybe_unused.patch
