From: akpm@linux-foundation.org
Subject: + atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around.patch added to -mm tree
Date: Thu, 30 Apr 2009 14:45:23 -0700
Message-ID: <200904302145.n3ULjNid003631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762173AbZD3Vsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 17:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@novell.com, knikanth@suse.de, mingo@elte.hu


The patch titled
     atomic: detect and warn on atomic_inc/atomic_dec wrapping around
has been added to the -mm tree.  Its filename is
     atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic: detect and warn on atomic_inc/atomic_dec wrapping around
From: Nikanth Karthikesan <knikanth@novell.com>

Add a debug option to detect and warn when the 32-bit atomic_t overflows
during atomic_inc and atomic_dec.

We expect that overflow and underflow of an atomic_t is usually a bug. 
There was a patch of this nature in -mm for a long time and it never
triggered false positives and it did find a couple of real bugs.

The option is default-y for now.  It will have a fairly nasty impact on
.text size so we may decide to switch it to default-n prior to a kernel
release.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/atomic_32.h |    8 ++---
 arch/x86/include/asm/atomic_64.h |    8 ++---
 include/asm-generic/atomic.h     |   40 +++++++++++++++++++++++++++--
 lib/Kconfig.debug                |   11 +++++++
 5 files changed, 58 insertions(+), 10 deletions(-)

diff -puN arch/x86/Kconfig~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around arch/x86/Kconfig
--- a/arch/x86/Kconfig~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around
+++ a/arch/x86/Kconfig
@@ -46,6 +46,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_ARCH_DEBUG_ATOMIC
 
 config ARCH_DEFCONFIG
 	string
diff -puN arch/x86/include/asm/atomic_32.h~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around arch/x86/include/asm/atomic_32.h
--- a/arch/x86/include/asm/atomic_32.h~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around
+++ a/arch/x86/include/asm/atomic_32.h
@@ -78,24 +78,24 @@ static inline int atomic_sub_and_test(in
 }
 
 /**
- * atomic_inc - increment atomic variable
+ * raw_atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically increments @v by 1.
  */
-static inline void atomic_inc(atomic_t *v)
+static inline void raw_atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
 		     : "+m" (v->counter));
 }
 
 /**
- * atomic_dec - decrement atomic variable
+ * raw_atomic_dec - decrement atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically decrements @v by 1.
  */
-static inline void atomic_dec(atomic_t *v)
+static inline void raw_atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
 		     : "+m" (v->counter));
diff -puN arch/x86/include/asm/atomic_64.h~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around arch/x86/include/asm/atomic_64.h
--- a/arch/x86/include/asm/atomic_64.h~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around
+++ a/arch/x86/include/asm/atomic_64.h
@@ -77,12 +77,12 @@ static inline int atomic_sub_and_test(in
 }
 
 /**
- * atomic_inc - increment atomic variable
+ * raw_atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically increments @v by 1.
  */
-static inline void atomic_inc(atomic_t *v)
+static inline void raw_atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
 		     : "=m" (v->counter)
@@ -90,12 +90,12 @@ static inline void atomic_inc(atomic_t *
 }
 
 /**
- * atomic_dec - decrement atomic variable
+ * raw_atomic_dec - decrement atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically decrements @v by 1.
  */
-static inline void atomic_dec(atomic_t *v)
+static inline void raw_atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
 		     : "=m" (v->counter)
diff -puN include/asm-generic/atomic.h~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around
+++ a/include/asm-generic/atomic.h
@@ -4,15 +4,51 @@
  * Copyright (C) 2005 Silicon Graphics, Inc.
  *	Christoph Lameter
  *
- * Allows to provide arch independent atomic definitions without the need to
- * edit all arch specific atomic.h files.
  */
 
+#include <linux/kernel.h>
 #include <asm/types.h>
+#include <asm/bug.h>
+
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic_inc(atomic_t *v)
+{
+#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
+	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),
+		KERN_ERR "atomic inc overflow!");
+#endif
+	raw_atomic_inc(v);
+}
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic_dec(atomic_t *v)
+{
+#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
+	WARN_ONCE((atomic_read(v) < (INT_MIN / 2)),
+		KERN_ERR "atomic dec underflow!");
+#endif
+	raw_atomic_dec(v);
+
+}
+
 
 /*
  * Suppport for atomic_long_t
  *
+ * Allows to provide arch independent atomic definitions without the need to
+ * edit all arch specific atomic.h files.
+ *
  * Casts for parameters are avoided for existing atomic functions in order to
  * avoid issues with cast-as-lval under gcc 4.x and other limitations that the
  * macros of a platform may have.
diff -puN lib/Kconfig.debug~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around lib/Kconfig.debug
--- a/lib/Kconfig.debug~atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around
+++ a/lib/Kconfig.debug
@@ -17,6 +17,17 @@ config ENABLE_WARN_DEPRECATED
 	  Disable this to suppress the "warning: 'foo' is deprecated
 	  (declared at kernel/power/somefile.c:1234)" messages.
 
+config HAVE_ARCH_DEBUG_ATOMIC
+	bool
+
+config ENABLE_WARN_ATOMIC_INC_WRAP
+	bool "Enable warning on atomic_inc()/atomic_dec() wrap"
+	depends on HAVE_ARCH_DEBUG_ATOMIC
+	default y
+	help
+	  Enable printing a warning when atomic_inc() or atomic_dec()
+	  operation wraps around the 32-bit value.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y
_

Patches currently in -mm which might be from knikanth@novell.com are

block-prevent-possible-io_context-refcount-overflow.patch
atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around.patch

