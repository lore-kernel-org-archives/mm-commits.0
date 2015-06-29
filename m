From: akpm@linux-foundation.org
Subject: [merged] compiler-gcch-neatening.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:55 -0700
Message-ID: <5591aebf.b/JCuAEn5BU58Wmg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbbF2Uq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, amodra@gmail.com, andi@firstfloor.org, anton@samba.org, levinsasha928@gmail.com, mmarek@suse.cz, segher@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc.h: neatening
has been removed from the -mm tree.  Its filename was
     compiler-gcch-neatening.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: compiler-gcc.h: neatening

- Move the inline and noinline blocks together

- Comment neatening

- Alignment of __attribute__ uses

- Consistent naming of __must_be_array macro argument

- Multiline macro neatening

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Alan Modra <amodra@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |   85 +++++++++++++++++----------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-neatening include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-neatening
+++ a/include/linux/compiler-gcc.h
@@ -5,9 +5,9 @@
 /*
  * Common definitions for all gcc versions go here.
  */
-#define GCC_VERSION (__GNUC__ * 10000 \
-		   + __GNUC_MINOR__ * 100 \
-		   + __GNUC_PATCHLEVEL__)
+#define GCC_VERSION (__GNUC__ * 10000		\
+		     + __GNUC_MINOR__ * 100	\
+		     + __GNUC_PATCHLEVEL__)
 
 /* Optimization barrier */
 
@@ -46,55 +46,63 @@
  * the inline assembly constraint from =g to =r, in this particular
  * case either is valid.
  */
-#define RELOC_HIDE(ptr, off)					\
-  ({ unsigned long __ptr;					\
-    __asm__ ("" : "=r"(__ptr) : "0"(ptr));		\
-    (typeof(ptr)) (__ptr + (off)); })
+#define RELOC_HIDE(ptr, off)						\
+({									\
+	unsigned long __ptr;						\
+	__asm__ ("" : "=r"(__ptr) : "0"(ptr));				\
+	(typeof(ptr)) (__ptr + (off));					\
+})
 
 /* Make the optimizer believe the variable can be manipulated arbitrarily. */
-#define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=r" (var) : "0" (var))
+#define OPTIMIZER_HIDE_VAR(var)						\
+	__asm__ ("" : "=r" (var) : "0" (var))
 
 #ifdef __CHECKER__
-#define __must_be_array(arr) 0
+#define __must_be_array(a)	0
 #else
 /* &a[0] degrades to a pointer: a different type from an array */
-#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
+#define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 #endif
 
 /*
  * Force always-inline if the user requests it so via the .config,
  * or if gcc is too old:
  */
-#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
+#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) ||		\
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-# define inline		inline		__attribute__((always_inline)) notrace
-# define __inline__	__inline__	__attribute__((always_inline)) notrace
-# define __inline	__inline	__attribute__((always_inline)) notrace
+#define inline		inline		__attribute__((always_inline)) notrace
+#define __inline__	__inline__	__attribute__((always_inline)) notrace
+#define __inline	__inline	__attribute__((always_inline)) notrace
 #else
 /* A lot of inline functions can cause havoc with function tracing */
-# define inline		inline		notrace
-# define __inline__	__inline__	notrace
-# define __inline	__inline	notrace
+#define inline		inline		notrace
+#define __inline__	__inline__	notrace
+#define __inline	__inline	notrace
 #endif
 
-#define __deprecated			__attribute__((deprecated))
-#define __packed			__attribute__((packed))
-#define __weak				__attribute__((weak))
-#define __alias(symbol)		__attribute__((alias(#symbol)))
+#define __always_inline	inline __attribute__((always_inline))
+#define  noinline	__attribute__((noinline))
+
+#define __deprecated	__attribute__((deprecated))
+#define __packed	__attribute__((packed))
+#define __weak		__attribute__((weak))
+#define __alias(symbol)	__attribute__((alias(#symbol)))
 
 /*
- * it doesn't make sense on ARM (currently the only user of __naked) to trace
- * naked functions because then mcount is called without stack and frame pointer
- * being set up and there is no chance to restore the lr register to the value
- * before mcount was called.
+ * it doesn't make sense on ARM (currently the only user of __naked)
+ * to trace naked functions because then mcount is called without
+ * stack and frame pointer being set up and there is no chance to
+ * restore the lr register to the value before mcount was called.
+ *
+ * The asm() bodies of naked functions often depend on standard calling
+ * conventions, therefore they must be noinline and noclone.
  *
- * The asm() bodies of naked functions often depend on standard calling conventions,
- * therefore they must be noinline and noclone.  GCC 4.[56] currently fail to enforce
- * this, so we must do so ourselves.  See GCC PR44290.
+ * GCC 4.[56] currently fail to enforce this, so we must do so ourselves.
+ * See GCC PR44290.
  */
-#define __naked				__attribute__((naked)) noinline __noclone notrace
+#define __naked		__attribute__((naked)) noinline __noclone notrace
 
-#define __noreturn			__attribute__((noreturn))
+#define __noreturn	__attribute__((noreturn))
 
 /*
  * From the GCC manual:
@@ -106,14 +114,13 @@
  * would be.
  * [...]
  */
-#define __pure				__attribute__((pure))
-#define __aligned(x)			__attribute__((aligned(x)))
-#define __printf(a, b)			__attribute__((format(printf, a, b)))
-#define __scanf(a, b)			__attribute__((format(scanf, a, b)))
-#define  noinline			__attribute__((noinline))
-#define __attribute_const__		__attribute__((__const__))
-#define __maybe_unused			__attribute__((unused))
-#define __always_unused			__attribute__((unused))
+#define __pure			__attribute__((pure))
+#define __aligned(x)		__attribute__((aligned(x)))
+#define __printf(a, b)		__attribute__((format(printf, a, b)))
+#define __scanf(a, b)		__attribute__((format(scanf, a, b)))
+#define __attribute_const__	__attribute__((__const__))
+#define __maybe_unused		__attribute__((unused))
+#define __always_unused		__attribute__((unused))
 
 #define __gcc_header(x) #x
 #define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
@@ -129,5 +136,3 @@
  * code
  */
 #define uninitialized_var(x) x = x
