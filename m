From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-s390.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:10 -0800
Message-ID: <200802080808.m1888pK0014701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297AbYBHITb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to s390
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local to s390
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the standard __cmpxchg for every type that can be updated atomically.
Use the new generic cmpxchg_local (disables interrupt) for other types.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-s390/system.h |   44 +++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff -puN include/asm-s390/system.h~add-cmpxchg_local-to-s390 include/asm-s390/system.h
--- a/include/asm-s390/system.h~add-cmpxchg_local-to-s390
+++ a/include/asm-s390/system.h
@@ -201,9 +201,9 @@ static inline unsigned long __xchg(unsig
 
 #define __HAVE_ARCH_CMPXCHG 1
 
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))))
 
 extern void __cmpxchg_called_with_bad_pointer(void);
 
@@ -355,6 +355,44 @@ __cmpxchg(volatile void *ptr, unsigned l
 
 #include <linux/irqflags.h>
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+	case 2:
+	case 4:
+#ifdef __s390x__
+	case 8:
+#endif
+		return __cmpxchg(ptr, old, new, size);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#ifdef __s390x__
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 /*
  * Use to set psw mask except for the first byte which
  * won't be changed by this function.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
